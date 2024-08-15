Return-Path: <kvm+bounces-24331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD85953B79
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 22:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C9CD1F262EB
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 20:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F1614A60E;
	Thu, 15 Aug 2024 20:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zkP8lE1y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306E21420DD;
	Thu, 15 Aug 2024 20:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723753868; cv=fail; b=E89mZZpQp8XbFrz4k7i309s3rHz7pI/GFYaj0ci0wpFA0lnTbwT/SBL1Mw8BLogBWDv7fkRTcKtnjdEbzG7PrhKoWccyxEaswWPiItsV+22sd4r5JKQ9c7f22QfzU9ic3OJHRFq3ehD5t/ezhqb9e4KeBbjNOeqtd4polq+DsBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723753868; c=relaxed/simple;
	bh=+L8siBGZ18vx1YUDJwUNNbITXXkVoQZOK9SHPgEd2QY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lI/jvj87QIFmGwNFqzPwIzuIbp9zlSr4A60xPywgQT5rPmSos2HMPNUZg0kXJGE/VrV1wnweTwl9Hc1bCs7cjqUyqryPylqrZh/nKQGXkdByDKwPXMXufDq/+i1U4h6dqhGKPEAQp49FzEzl7VVV8AeS5ZsrHtBT/8G3PjDUWV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zkP8lE1y; arc=fail smtp.client-ip=40.107.92.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ajS4RH0h1MDfR9l1pZmA4TCyRmbCTSY8RSbGnMVo2yNPnUMEXML2r3zPHy4v8G+IvpQIwrl9BE27ue7v3Mn45tAiHLK67ApqXAECdYPaf1vctgLBPDVrnJY3yEY8y7+AYNtxLnseC4N8j6xJcVJyBt3sAm8h/s4GyFwWEcQlIRLFESYoIQXMUrpIkrWyilnCJnyuyWfriMPsmLtzEc/GSxFFzKVlyObCrWUXLh/pVXPJYr9Vn7M0ibiDmTNJQd8L4OsR0/U/93aIa65Dn6POJ75YR9dO67TR+/xIsP9KdiC1/MvF0ivnJCb5oA5tXtpV4SZFz1MgiDTkvO/ClVvYxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9gVmvyTu77Gq4qy4cKpxDeU9nOqGkop90SnZ87mW7A=;
 b=wZLlJ6ghm8lrR+fmi3uCXtH3gYcOqDc1SkFixX7Aef3gSOd0TzVymlWKPAXbwajWkcWrgzcHMaSSIkDvmDoT0i1E+EJnVUm6D0Pl2We+9m6bwUJwAu/L+Ea+sreNN+X5LXqjfaJzcLowGcINOgqYxLvnGsS1qqSxsEDDFxXndGIcLP3xFVm21QJA6nyZSjO+08b9ge9+lZOnZ0Chc4fGTBlu4RjYhZ/muca/cKqEbxMkLy3OGk4S3PpTv0a3exZ5CHE0u0yVxfqk06+j8S3aw9zuEbW/nq0SAm6412GIcu+tBerCanuljssKPl2F0ZZjBgEc/WmVW9L5psVQn+Hn6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9gVmvyTu77Gq4qy4cKpxDeU9nOqGkop90SnZ87mW7A=;
 b=zkP8lE1y5X8XpIXYuSeViNSYH9pBj3TE6uAwp4rDpouEb1aT5I9c0Y2/lmDQYSyvF774k1MDnpqmnpEt6QhzjIHT8k0PzvlcyyrIc59/JUBfi/iRUvLZDBBayy2TCeE8T5p/wKRL3q1sLzDYqzCN/EfQoML68/3cdfwLKg2covE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by IA0PR12MB8975.namprd12.prod.outlook.com (2603:10b6:208:48f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Thu, 15 Aug
 2024 20:31:02 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 20:31:01 +0000
Message-ID: <85d4d61e-b56b-4e8e-ba3d-f239b648f47c@amd.com>
Date: Thu, 15 Aug 2024 15:30:58 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1723490152.git.ashish.kalra@amd.com>
 <b05c6de0c3cd47f804fd77be60ca2d90a6d28f8d.1723490152.git.ashish.kalra@amd.com>
 <afafee48-4a74-85a0-8455-640eb2d59948@amd.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <afafee48-4a74-85a0-8455-640eb2d59948@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::26) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|IA0PR12MB8975:EE_
X-MS-Office365-Filtering-Correlation-Id: 333ad417-9447-48d9-0a66-08dcbd692daf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TG5NQ05YTjhJTXc4aFNJWVVDK0lUa2RzMlpYMVlGamJ1UnJkNHF2dHpiR1BH?=
 =?utf-8?B?WEcwTjBIZHdiVGE1emtocGxWNzJIL3c5TUtwcnlYZ3lxZUlmRjErZUErdjhS?=
 =?utf-8?B?QzFsYXFjditsakVGTnFpMXBrSzdxSHRvblFtaDBHQlFTdDlaQU83TWNEVGZY?=
 =?utf-8?B?S1VadlErZEFLclgxU0JmeG43WlRjbW43RGwrRW9ZakkzWkc2VU9uMnJTNE0x?=
 =?utf-8?B?Wk1JK09PZVBSUGNLWnhqMVhNQzcrTm1YYzVXK05JMFpXYndSYmVUV2Y5NFo2?=
 =?utf-8?B?MisvcnpnOVNydzI0eXpSd3JVajNqakppbmFnMWdvWG40cUg4akJzM0NBSW5K?=
 =?utf-8?B?NnB3UEVUZHJMU05RUmRIdnhtMms0RXZwUmZNMExYb2ZTc2tXYWNYUGUwUjR6?=
 =?utf-8?B?VFhyZHBZVWZXNDlmaE1UUGJWUC9JMEtIVk1ycmhMa3MwVGtXTTAvRk1sSW1Q?=
 =?utf-8?B?SExGVm92N2JVeXMyNDRTUDZCWWVlUEZ5VXhGZUhaNndFQVpjcmxFK1ZEN3ZG?=
 =?utf-8?B?OWxoQTJzcHZQWStrRTROYmgzSEsyZ3U0Y2Vtd3lCWWVBL3BFamhKbzlsTGo5?=
 =?utf-8?B?dFFyZFJWTUErVWtZUDdBNWxHL1cyWHVUU2hRSTFpbFJSaTlONzhFL0pqSGJy?=
 =?utf-8?B?WHRNUVR2WGhBSGNFUG12SCtCd0FpUzdaaVR1bjlaTWh4YmtRWFJnQzloL1JF?=
 =?utf-8?B?Sm52TUx3eFowUlFZWm5QcTFKMjl5azNIdjBHRVQ0ZUs3ZWFRTjIxMEJENEhn?=
 =?utf-8?B?NHF1Zng1MUcxWW9NZkpjampIYmd5Q0M1OEJUdXVsdVZVSTVPdHhVc3N5aVZi?=
 =?utf-8?B?bU8rUitmMytKaU4zUnRQNEZReHRDYXc2UkpsbDd4b1BiTjA0N1pMQmlIb01P?=
 =?utf-8?B?VHo3UWtvZUx5NFJna2pyREF2NU81b3k1SSt0dW8wNStPZEhRQ1RmM2pCZ1Vl?=
 =?utf-8?B?N0pvYnVyNk0yVmpGTkZybWZIU29uaEpJNWI4RDlMc0VyWWJMcEpZZFVrZWdD?=
 =?utf-8?B?bjQ4dGNTMGtQYlRnWWVRZCtsUnR3OERjZVFXZkFIekloZ241b3RGckFqTXl0?=
 =?utf-8?B?Um5XaFVyYW56Z1lSc3dLczV1YURNb3VmS1BLRUljSmZHdVJyeld2bWtYU0po?=
 =?utf-8?B?QTA1bUpYb1hsTVNoTlFpQnVEV2xIaVRhKzlVWlpESmNIc0prcWhSaFQybGRU?=
 =?utf-8?B?Uyt6Y3lJQ0RlQVl2aDhGQW5POThoTUV4RHlUaFRURkR0VDAzVzhtYkdNcXFN?=
 =?utf-8?B?OUY3dURjMklVMUpKRTlRUU13eFZPaFExRWZDOTg5TGRVdGhsMUJCNCtNeitW?=
 =?utf-8?B?Q1FTME12dkptKzNWcjZla0dVWTJFRUdJZUh0MzhvOStDckZxVnF1VmJOUGly?=
 =?utf-8?B?TDQwd2RrdWNDc0g5dmZxbVpqU1dKSkVuV08zUWFhQlIxRXJ5UkRFM1VsOFdk?=
 =?utf-8?B?RDN4L1dKclIvWnFTOVlScC9HTm93WEZMT2ZVaDZOVlRoRWRxQncwWHBGc3M4?=
 =?utf-8?B?bFZLQTNjSk92NHBiYVdqSkJLUmlGaTZ5N24xbDVIbGUyZHJ1SlhzSUtzUmx0?=
 =?utf-8?B?VEQ3YkwrdmhIWmVLbnM4bEVSNDBZc0lrQVhsamN4VEoxRTlTM01LNmJaZ1lQ?=
 =?utf-8?B?ZUhIdGEzK1NoNmFsYVl0YU1uLzZ6TmpUWFNqUTJ2bk4yakxLdlJtNS9TeWpQ?=
 =?utf-8?B?ckZVd1dMQWpvUnhTcDJyYmZlVGFtaGl6S2Y2RitqN1RyUUhOUkVIR2cvdnQ3?=
 =?utf-8?B?R0FTaHJGNGk3ZzhzRElybDBWei9PVWUvZ1crYmRYclREbGpsTW5ENjRueEdx?=
 =?utf-8?B?eWllUkozU05TczdoQkdkdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NkxjakZ0dElhMFNJUUI4eWNsMmhBQS9BSm5KS0RzQ3oycE9mZENrZkhGSVJE?=
 =?utf-8?B?R0QzdTM4SVNrUFk3YTlMR2lFQ1VpMVJIUENDMGpkaUgybTd5ZzZDakFnek9k?=
 =?utf-8?B?U29GZWZSREdCeXNubXMySGtQOHpJTldLREx2L0FrcVNzKzFZVjhEQjUwT0Iy?=
 =?utf-8?B?dzM5SW1hUTI2VzdheThjT0VrMnZaN0xDZHBadTdFT29UMjlFYWZpaFRlV2c3?=
 =?utf-8?B?RGpIOVZtUGRvc3pqQXZqamdiZS9tK2VRK3BCdXJ5MndUSXFLRGN2aTM3TmtZ?=
 =?utf-8?B?a0d4UEdJVXU3aW5hNmZZWlNmaVN3K1l6Q09DalNTRmtRa3BDcjdEZlJZMUVa?=
 =?utf-8?B?SHVhemtNNXdPdllBNkluWFJSU3dWRy9jVkwzODkxajZiOVcxS2tGb3o1R1p1?=
 =?utf-8?B?TzQ4ellrU3N5S0xvLzJNbHdsdjIrcjJQTHh6U0dsbVZaUEszeEgrZkNVSmo1?=
 =?utf-8?B?amxLcXRXVDc2N0lJdUFHTWFkZG85dTluMGZtdm16UG5xSnoxRW9MYitIckE2?=
 =?utf-8?B?eitJT2FYeW9Va0NIYW5WVHdTR0o2QVorRFlvM0MyUlMrWGdHaEQvcVYrcHR1?=
 =?utf-8?B?MUZKMFNmeHQ3d0hyK2FoQ0VZZTJTM2NxS3RjR25aRHM3NGJRaC9MTUVUNW41?=
 =?utf-8?B?SXJWRzI4WTZIVldQY1ExOTczenVFcVZuZ1RDbk1KM2dHSTNZTWJ4dlNtSGdN?=
 =?utf-8?B?QjZmMEE5VWNHWHFxdXZDbmJvRjBHRCsvb0RXR0FQQWhmQWlZc2dSbWFMeUpu?=
 =?utf-8?B?SDk2eFhYMTloM2xRcVMxbkdqSEZZOHkzUm83dWRXZzU3WFp3RnhQOUw3R1VT?=
 =?utf-8?B?ZDROMmE4YVpCSkptSXkrQ2gyczVZZk14MlIwb0pvYnYwekR4UjVzM1QzdTRa?=
 =?utf-8?B?OEtJU1A2Szdhb1J1VmtLOER5OVZLNTJjM1ByeW5rSHVLejBvRWs3K1k0RzNv?=
 =?utf-8?B?aFFrRENXK1VHNW5LTFBCY1BDbVh2TU9jTEswNGRYSHZEbm1UTWFUbWhmUTFS?=
 =?utf-8?B?R25KUWNuSFlySUxZYURvd2pjeEdzMFl3dCtLYVArWVMyT3czVUltMzloRm9p?=
 =?utf-8?B?OFNGdmFYSTZoVytNMFNlK0ZreGVRdjdJWFViVDJ0TUZaS1pXMm9VMklHVEJF?=
 =?utf-8?B?cTZGUTVEcGwxL0dDNWh1ZGlzZ0R0eUlKbkF1cTFHd1BKS2VSQVZUMlh1TVlS?=
 =?utf-8?B?Y2k3eWllNkRENDhtOHc5U0V6N3k4eFdHb1VTQXZSTjdLZVZZd0hPY0RTK0Nl?=
 =?utf-8?B?OVhuVjl5STFJVTd1TWpISDdJL2NFdkpOVi91UDdMRkhPMmVmUmhoYjdEeDJS?=
 =?utf-8?B?UUFNbXJ2eGpRbjc5OGZ3YjVENXhudWtmZjloZHFQdVBjL3hhSkltbW10TEVq?=
 =?utf-8?B?SDFaVFVOL3RBbGJ0MUJWVG1pVE9SUXVlSVdNZVZMUDMvRUhpdUdUTDY3UlFZ?=
 =?utf-8?B?MCtEOGpaeVB5WUpzQmE5eE9DNXBsT3NMQ2VGTUNaUy9XMFRuUkxtSUNiUkVt?=
 =?utf-8?B?ZmZoelpySDdnZzFRYTNNcEZBUEFVdm90RnppS0ZUQ1VPcUNWWU1OZTg5RUZ2?=
 =?utf-8?B?Szl2TWhONlQwd1RrQlBNYkNXK3EzWHRLU0IvVklrb0NzQUZsVHB4bFFWV3p6?=
 =?utf-8?B?enhnNEJQcmpuLzh2TzZFb05rbjA3a093YjFQOEZNcmcwdHkwOHNXb3FFbGw3?=
 =?utf-8?B?dmdGaGV6SXFXR1BnRHNQYWRTeUlyOEZvb2lBU0VNTEJ5SmsxOEJtZlNLS0lG?=
 =?utf-8?B?S2JtVUJBV1lpaGVPK1JERy9zMHJJbDE0Z1Rid0d5YjF3WVZwNUdWcktjM1VC?=
 =?utf-8?B?YWNhK0drK1NEN3JEVDdSalVjVlZUWkVieEM3S0pXSHlEY05SaEdvaWYxZmpO?=
 =?utf-8?B?aThETlhvNEdyTG11OCtuMDhjNWRIbkZHcFMxSGIrM2dIbkFVTm1XZDRnRmpO?=
 =?utf-8?B?TFpuKzNlWFc2UzRlRE80UDNwWmJJZVdPMktMOWpqR1MxZ2FVWVBPTmwzUmVS?=
 =?utf-8?B?TUhMd1k5ZTRwbnhzcnJHMkJWWUZsSVl5a2RZRzR5MGdjVkVWZHMrMGpEeUh0?=
 =?utf-8?B?QXNkN0lxWWVZMy9SVnA2UHJ2cGtYanpaLzJ2c1c4V3psTm8rTVJBekFEUlVG?=
 =?utf-8?Q?BP27cYvoqM32DA+eodspUqYrM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 333ad417-9447-48d9-0a66-08dcbd692daf
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 20:31:01.7156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4/MhljDGqrR6CADIxZIAB650iWXCoht8fNnlzoNVpfZJV3LYYzOC0kMAMbK3S2oAyEP3vRbSYdFa8RLQgAWB/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8975

Hi Tom,

On 8/15/2024 10:58 AM, Tom Lendacky wrote:
>> +
>>  static bool psp_dead;
>>  static int psp_timeout;
>>  
>> @@ -1053,6 +1069,36 @@ static void snp_set_hsave_pa(void *arg)
>>  	wrmsrl(MSR_VM_HSAVE_PA, 0);
>>  }
>>  
>> +static void sev_snp_enable_ciphertext_hiding(struct sev_data_snp_init_ex *data, int *error)
>> +{
>> +	struct psp_device *psp = psp_master;
>> +	struct sev_device *sev;
>> +	unsigned int edx;
>> +
>> +	sev = psp->sev_data;
>> +
>> +	/*
>> +	 * Check if CipherTextHiding feature is supported and enabled
>> +	 * in the Platform/BIOS.
>> +	 */
>> +	if (sev->feat_info.ecx & FEAT_CIPHERTEXTHIDING_SUPPORTED &&
>> +	    sev->snp_plat_status.ciphertext_hiding_cap) {
> I'm not sure you need both checks. Either the platform status or the
> feature info check should be enough. Can you check on that?
>
FEATURE_INFO only indicates if SEV FW is capable of ciphertext hiding and SNP_PLATFORM_STATUS ciphertext_hiding_cap bit indicates if the CTH feature is enabled in BIOS, so both checks are needed.

Thanks, Ashish


