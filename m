Return-Path: <kvm+bounces-66844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F8BCCE9E14
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 15:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5220D3022A99
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 14:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F63248F73;
	Tue, 30 Dec 2025 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rCh74jBn"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010012.outbound.protection.outlook.com [52.101.61.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4661DE8A4;
	Tue, 30 Dec 2025 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767103852; cv=fail; b=JdUka9SYBVd4eaGM64POhMO/sm2THx8jku4wrOi1RDZfSgj2t2QGX6YaMCr3CFFE4y4C0kcWDhnpG+DBZNJEDQIdOdmYBvoWIHrFKmhhAk3wZJyBDVmv62KfdDuzyLzgvz+Oke7hfpWSXaC051kjDPVzGXC+AAbDhYBE8aP/S6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767103852; c=relaxed/simple;
	bh=OCXWp6ov4VMyUjUiN8bRBxskf9MXPztTSAvgRQJ7STQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ef4XfO/kODvqn5JBJksrFb1ZD4+tCHLq64rhgf35RtfLcKRsLgmkTGC9qHDbwfUbpMQ4Dv31be2YkqQFA3crJ4SpJZa44WknwPd9QQyxw5GT6Coa0k4DXh+O2d1LfHfVqn+tpzoefbX7c9muoWZ15TAOwnemx6mzclD2W8SbtD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rCh74jBn; arc=fail smtp.client-ip=52.101.61.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GY9l8iYMp4qH1bcUNLTezvPTWCbnU9Awd0/PhYXLnhvoE/fH3ZRU3cht9wVgRRN/21re+wREo18+u8dzcJoN5Xp1AyEn0U6xOjXa0qNOL3LaGyNHeYIJFUFEd8A4UUwXj+Lakgd3AMeU7aEo8mlLO8gDQDI5MfxcDFV/7qURh4xGnUvoKudEw7wIlPoU3fog6E2EYZzREYF2zRDUdAVE/LYedXymqrRU+XQeL1whpC/I1OJtfW8TQag3T01Z3+80QLs2E6a518alGN9FgYH9xitR346+VbOZEbZG7ciJfDLFU5IVQ0UDOSZKFRMsZN3ThRPzyCTh6ShIU/kTeAqk3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xn0IzRL6q6wY3zeibJ90elWjn+eIk7RyhmnJrjS7z7c=;
 b=apowZq05JNw/SpMIA2VxA/mDnqQ8paqj0iRfwQPH8IVEiYM99cLdAn27IdDad/vK6n1n3PG3fIbbkvaWsN1HkN34LnlCEWX1m3Z4FgXU4Kq0t+0zKYhhjPE0aphPz9Bd8qF9SZPeN376lDmazh0ZlmjPbt+BrKkRxMGHvF1JMbtB3SJyc7Jh3gWRkRzrGlgNYnYbnA9aFDypEPEjmsOLqpRriQKmSwVGpc1VAm7udD2U5Ui37Bxa1x5czh9W9a4O4C785wgt0ByevcEIn9jBrU0v/Gcdq147zfQ6UXB1zg7jluwADtVHTDZc6hwtQeDNMZAPQvwaHMK8ztNAK1XVAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn0IzRL6q6wY3zeibJ90elWjn+eIk7RyhmnJrjS7z7c=;
 b=rCh74jBnTcOVgUMBS+VjdMpJ4mwhvhdu5GE0jGxYkV9nvKbUwzyigi/zl/+ssteMcvHPyeZjoBy+bt+dnxyR3HPeFnNz2e5Q88Futv1ZxooPpIGV63Cxxlqe6h1Nh1UaWQ1dXstUHvDQHq8grZNqtl74yuAmLnz3EnHrr8P3HfQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by MN2PR12MB4454.namprd12.prod.outlook.com (2603:10b6:208:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 30 Dec
 2025 14:10:47 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277%5]) with mapi id 15.20.9456.013; Tue, 30 Dec 2025
 14:10:47 +0000
Message-ID: <c589418d-dc2e-4229-8f3c-fb49d8f9c45a@amd.com>
Date: Tue, 30 Dec 2025 15:10:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] KVM: SEV: use mutex guard in snp_launch_update()
To: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 linux-kernel@vger.kernel.org
References: <20251219114238.3797364-1-clopez@suse.de>
 <20251219114238.3797364-2-clopez@suse.de>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20251219114238.3797364-2-clopez@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0110.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::20) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|MN2PR12MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: fbd29520-2d2d-4cc9-60b6-08de47ad3aac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZllFMVBsRC9CSGk0U0FWVnlDUXFnVEFwVHdNUmZmU0RyM3NCak9sdDBVNWlq?=
 =?utf-8?B?WGtxd0RPaldSRmRPTkhhbVhtbUNPSytIUEdwMUJvM1lCVy95N3RUd3pDdVFj?=
 =?utf-8?B?cWEyUERSazVmTW5jRjN6Vm8ySFpPSWJtMDg4RHR6U1VpemFtWEdnRlpiODNY?=
 =?utf-8?B?dTlnNTBobURwOVh1NFl1dzVBRS9RRjN6TDkyU0JaQWViVnNROGRnQUkwRzA3?=
 =?utf-8?B?U1owcUtNUEliNHVqUkdvM0lFemlaWHFsUHcrellGQVBPZnNoWlFCalpCWnFG?=
 =?utf-8?B?am40aUJ5OW80TmZXYWRtVE5yQ0pFbW16MjVlU0xWTFdFaUtzakZZTUh4TG9a?=
 =?utf-8?B?SkJkMzZJYUs5U21TVFVVZWlOdVh6bUFzUHVXWWFDamIwOGhMelg3eWhPSUhh?=
 =?utf-8?B?WktmR2pKbWlXRTZ6NHc4TUpGcytoVkl5TTV4ZzJZV1NlcnNRMXBSck1YanV3?=
 =?utf-8?B?M2pPazRWc0phY09wN1FzUzgyVE4rMTkyeTBxVnhDa3RwZ0JXSW5KTXBXdlpy?=
 =?utf-8?B?cG1abmd3QkJKK3cvUzlNRk5yS2hXNTNOSGRMQmFnanQycUd0Q3kxSUR2N2Yy?=
 =?utf-8?B?aSsxUTJtSUpxVkZOVW5QZjl3c21UUTNwaTVGNDVlMC9QVjBvMytYR1FibC9u?=
 =?utf-8?B?NkEvam1oZ0U4TDdReW5iWk1TV0gxeU1OMW9Kc1pMdEJmQnNGWjdadE9xYXh5?=
 =?utf-8?B?YTFvQ0RnT0FRRUVzaFlYQ3QrS3AvUFpTclFJdDRTY2N3YXlpOVUzMUs3bG5O?=
 =?utf-8?B?enVVZWJZWXZqbW0xcFVVZlltUjUrSk9WMXBsaDVsak1KSWVVRStEVmpWQ3Fm?=
 =?utf-8?B?RUZXVnRTeG9OSHpxM0pUTzI5bGdrL1hnWktpN21haitEUFMyZVkwdmh4dXFw?=
 =?utf-8?B?YVpPMmV4cWpuVk9VeitrdzVwZnpycm5lSEtUeEU1emdvVDJIYmU4ZmJLV1R5?=
 =?utf-8?B?UDBkdGJCZTNydUREc0wzSVQ3V3E1RVVlMnFWUUREVDNEaThFc09DUlVscnpT?=
 =?utf-8?B?V2dhdXpTVGdHNjRveWxJUG12VVRpVDg4UGp5UDBuSzF3SEpFQzJwby9PVmgr?=
 =?utf-8?B?SXBDUGFFQ1ZNdEx4NTVIY2ZGMnd4b1hMeVVncnB3M0hTWEhHbEs0K0R2VXJq?=
 =?utf-8?B?aTFtRzBrSmg2TjUyWFREWW5xeVQvbE5kSFBVdkJaa3NjTWlHQU9wZVFUWW5V?=
 =?utf-8?B?OUhpcW9kL0ZDbWFkZXNjV1FITU5zWVBRMlMyd2o0eVVHbFN3N2ZsUDhianN5?=
 =?utf-8?B?SDk2M0hKYjhibzZKLzQrM1lTOEFVSGVMTG1jSE9ycG85Z0Q2SFlGQ1licWFa?=
 =?utf-8?B?cStlOWcxT1krMzl4c2NxNkRzZnpqdGNHRldSRE5SWjlOelQ3MHE2MnowN3pJ?=
 =?utf-8?B?ZDZ1TmI2V0RudzJ6Rk5sYy9vL2p4SHoyL3dLREVxbktsTkx2OXFVVE5yY0xr?=
 =?utf-8?B?ejhvemlYcVdVelltZmN1azAweTd0d2FYT3JlTm5PZDdNMGpqamQzM2IwOERO?=
 =?utf-8?B?ekVFYVdva3VKOFFqME0xclFDbXNSNGpGd0IxMThkY3U2NXFkZDFoci9vYjdP?=
 =?utf-8?B?Y1RvVUZRV2d1Y2t0OVMzUUZqd3JXYldlS256UnRWb0t3eWtZc2ZUbG92dVNB?=
 =?utf-8?B?czc4STl6VU9oMFF5TjRKWVg3Tk1zOWZhNUtYR2lRRVFjazJWTnBDazU3bCtp?=
 =?utf-8?B?SjJZUjN3c3RFa0prTTIvUHd1TFYydkdyVHVWTlluUzRZUE54MWo1Z1dtNXp5?=
 =?utf-8?B?Sm5SY281V1kva3BWM3puNVRYaXhVeFZMdTJQTkJXamQ0aTJpQytiaVdRVTB5?=
 =?utf-8?B?YkRFdE1FR1l5aGJGTFY3OEV5YW5iYnQyVnlSZkozc1laZC9rYUhGVnhzN2NP?=
 =?utf-8?B?S1V2M3c0NTdRYUQya3p4amVQMUVaY0hGZHc3NFlZT1VBSVhqMExVclBmakda?=
 =?utf-8?Q?omnqKR2I7L6oajR5DmEzikzOwhOMZkBe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVdnY0hHZG1ua2hZZWs5TGFzcnZUTGhHbDhzQnhMTmlQRGFVTHZzYkJXQXl6?=
 =?utf-8?B?VWd4MVkxcS9EM3grVitmaU92N0lGYWRsaGFKeGJ2UWlQNjFROUp3R240WnpI?=
 =?utf-8?B?YnBlQ01aNlBUWlNLQ0NLOWg1d3YwWmoyWnRaZ044dm9tQVhadFdvTWhDZlA1?=
 =?utf-8?B?dGFVQzVOd01kYXdFSU5GOUgrUEdOWWptSy80M21tamZhZ3FXQnFJc0RrVmpP?=
 =?utf-8?B?T0tJYkVqUWo4RHQxLzQrZmdTTHg1eW55ZTlYYjd1NmNFMlIzb1pXazNIbzN1?=
 =?utf-8?B?MzN1cnk0eFJORE92dER2SC9RVjdjMkpkenNVWHA1TjJKWmNjL3ArenRXbkEv?=
 =?utf-8?B?bFlGSnN3N1dYaEJuQnJxN29GblNMaHcySmt2M2swLzRXODlqSGlpbWJsQXQr?=
 =?utf-8?B?UDIzVnYyVElMSG52a2M5TXdST2l3RjNKdWVrRzhMNzZTdEJqUjV2QlN3V3ds?=
 =?utf-8?B?ZjhNVTZ5MkM0VDJVcDdpR25ERnBMTXpCbm1zWC9Xd2diZ0wzUjNzWDZEUnUz?=
 =?utf-8?B?WUE5SlF5a2pIdTdIMW1ST2JEZVdrYnRnMklta2Y2b1l2ZWdISmZ1WHVyT3NF?=
 =?utf-8?B?QXFZOFJoWlJ4bDhnYW1TYmdSV2MraVRVNWUxWjB6UmJ4Y1pSaVlscDgySHVZ?=
 =?utf-8?B?WGdGOVJlU0I3NWNETkJSRnoyeFYvRStqVWdBUGtHVFRwTUxuUURzMDNrM1dP?=
 =?utf-8?B?OVVWVUltclZvMm0vdXM0dDRpelgvSjcxRU9US0pZaWJZRlZQUXQ5NmJqcHhT?=
 =?utf-8?B?ajI0aTIwVlNuREdzdzRSdGI4Zkx3WGNVMk45NUlEL2JyWmp4Z3V2VWxCYm4x?=
 =?utf-8?B?dzRhdnJ1eFZPbVpsTEV3TFF0VDRYZmVnU2R6Q2FYVGtoWm9md1JoZUtGeFVP?=
 =?utf-8?B?MkVxdlQ1ZUx3K2FVczVpeW9LUllMU3J6T284aUtIejdWekxaa1VJOVpGY2FZ?=
 =?utf-8?B?QVlGeEpHQm5ZejUvZE5qa0UrRktmTWllWlRFZWVOUVRWcWhKdmxKV1Z6MTVH?=
 =?utf-8?B?bEtJcnFoTkR6SXlySmZtSDhTckV6cTMxQ0NyY1M5RHg0cXRLVlRrV1hDckgw?=
 =?utf-8?B?bGhBdDBsSUUxZE9HbnUvVElvckFGRWRpSFFJS0lEeHRjQms4a2pleFVxSXdX?=
 =?utf-8?B?NllhR0gzQkZLTHFocjVtMjI3TERreDd0SnV3R3hCVTE4RkUwZGplMTdmK212?=
 =?utf-8?B?QlExaHJReDF3am9aTTZzRTlJOThOdGlGcEZFcHM4T1Z6cWNSV2JXNnRFZjZI?=
 =?utf-8?B?YVNFZXlyMmY0cEdiK2FZVFpqM3c4REVyTkJQdmlwazRjLzV6bnhNL2VQc0VD?=
 =?utf-8?B?WHFabUJwOU0xaW1nNkh4QnBnNlJMMHYyUnFWYVMwUFVlSDRQWnJmZzU3b2FX?=
 =?utf-8?B?NkdNMXBEcVpydTNWOFovOXBCNTBJdFpuWmxTMGhDQTNrQmJzRDF4QXBhSjJI?=
 =?utf-8?B?ZWNlMEhHZkQ3YjFidzFYSy9IWWpEaG9hM3dSWjdjS2VjSFJhVmJYekczSVhh?=
 =?utf-8?B?aW1DSDFOaHB0QThHU05YVFExSzlicm9pNXVmREl1MG1ZNTViYmpVempDbjVq?=
 =?utf-8?B?czJJYVRXUGxycklnK0Y5NjRkSHA2TE40NzJ0Rjl2Z0FyWnJ4NEMvN1JNbmRq?=
 =?utf-8?B?SlpLSktoRmFQcDFrdjVwVkJITFFiQXp1WXFLZkxnbTBLSlVOTWFEKzVBOGQ5?=
 =?utf-8?B?RUNxa0U2MXMxOUxudEtCdlVnUW0vbWFsUU9kbjNtcEhRYWN3cjJLS2QwRzFM?=
 =?utf-8?B?VmdNUHNTVlFpN3lWOFZHWkVoSDFPTEhNSTBDUCttV3BINDRJQXVvU1QyZGgz?=
 =?utf-8?B?RnRGNXc3S2gyRW9jdlA1c1FjNGp0allnOHRNUkhRczNlbU5ybnZVUWdtV2p3?=
 =?utf-8?B?TXNrUmpRQUc0S1pRMUdJVVRRbFQrYkhqd1RybmNuWW5mZEFGVG4vM1BxajV5?=
 =?utf-8?B?NE9BcVk1eW9GRnRtOGlreDRGdE1aajFBM2UxbmhodFFEUzNDbkFudHcvT1NK?=
 =?utf-8?B?NXgrWThwZkNBY29RRUtmNiswWldNelZDOThuSDg1VndXYVlVQWE0UEFBbCtJ?=
 =?utf-8?B?aG1Fd08vUGlGY2JnUXRrcFBnbnhvWmI1Z3BpTWRTK1ZLNXZlejM1WXFzblFB?=
 =?utf-8?B?V2ZkRWVvQ0U2MklIelRIYXduY3pHaWQxVWYxait2dnA2MVJkVGVGL2hjcjB4?=
 =?utf-8?B?ZHFmT24wQzlzcGd2MG5iczZId1BYMWQvalQ4c3lEZGtpckw0QkJIZWpnd3RN?=
 =?utf-8?B?Q25uQWFMTnVRWklUQUJxZWZuWWpWcWhoWmFPNU9rTFV4eml4YUhBZGdaNURw?=
 =?utf-8?Q?WXbyF8lmO7FSGhthcB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd29520-2d2d-4cc9-60b6-08de47ad3aac
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2025 14:10:47.6586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DXJ76N7Ru419ixjKIW+rlcjObPLHD4dEXn3j3r02GFyWB6prTtOwSwVOlQ0WLfatvFuXpusBczlqWQfxzWlIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4454


> Simplify the error paths in snp_launch_update() by using a mutex guard,
> allowing early return instead of using gotos.
>
> Signed-off-by: Carlos López <clopez@suse.de>
> ---
>   arch/x86/kvm/svm/sev.c | 32 +++++++++++++-------------------
>   1 file changed, 13 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f59c65abe3cf..1b325ae61d15 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -8,6 +8,7 @@
>    */
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
> +#include <linux/cleanup.h>

This does not seem to be required, as compiling without this as well.

Otherwise looks fine:

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

>   #include <linux/kvm_types.h>
>   #include <linux/kvm_host.h>
>   #include <linux/kernel.h>
> @@ -2367,7 +2368,6 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	struct kvm_memory_slot *memslot;
>   	long npages, count;
>   	void __user *src;
> -	int ret = 0;
>   
>   	if (!sev_snp_guest(kvm) || !sev->snp_context)
>   		return -EINVAL;
> @@ -2407,13 +2407,11 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	 * initial expected state and better guard against unexpected
>   	 * situations.
>   	 */
> -	mutex_lock(&kvm->slots_lock);
> +	guard(mutex)(&kvm->slots_lock);
>   
>   	memslot = gfn_to_memslot(kvm, params.gfn_start);
> -	if (!kvm_slot_has_gmem(memslot)) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> +	if (!kvm_slot_has_gmem(memslot))
> +		return -EINVAL;
>   
>   	sev_populate_args.sev_fd = argp->sev_fd;
>   	sev_populate_args.type = params.type;
> @@ -2425,22 +2423,18 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		argp->error = sev_populate_args.fw_error;
>   		pr_debug("%s: kvm_gmem_populate failed, ret %ld (fw_error %d)\n",
>   			 __func__, count, argp->error);
> -		ret = -EIO;
> -	} else {
> -		params.gfn_start += count;
> -		params.len -= count * PAGE_SIZE;
> -		if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
> -			params.uaddr += count * PAGE_SIZE;
> -
> -		ret = 0;
> -		if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
> -			ret = -EFAULT;
> +		return -EIO;
>   	}
>   
> -out:
> -	mutex_unlock(&kvm->slots_lock);
> +	params.gfn_start += count;
> +	params.len -= count * PAGE_SIZE;
> +	if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
> +		params.uaddr += count * PAGE_SIZE;
>   
> -	return ret;
> +	if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
> +		return -EFAULT;
> +
> +	return 0;
>   }
>   
>   static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)

