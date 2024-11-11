Return-Path: <kvm+bounces-31454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9894D9C3DA6
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:44:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B859F1C21E95
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5C7189F5E;
	Mon, 11 Nov 2024 11:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wNcn8n4J"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F120F158A09;
	Mon, 11 Nov 2024 11:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731325475; cv=fail; b=T5tYjXrqKozBZKWLEeTU1sXzb9XlrEv0pgfe4RFOhbezdI3gvPojKM5tzzlC9t0ayiegzenOPXk7F1RsaR6AqRoLpbbY8i+pD0B7o8ZKZprjyD1qROj3qEvxlgcm/oBCKYxUZHY22nNosIc81porhKqJXiPlDgPsIulQWtUErr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731325475; c=relaxed/simple;
	bh=3dNxax4hCAnZkS/I+at58xsjtRKXzHG6/jlZeX93rxA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E1CT98QfjAVgWNjZbgnMhluQ41Q2mwFU0i03NOcyV4w3Rm51CXyIbvvLS+sXP1hoqw9o3iWSy2vbxvNMqVTo/MnrrkZENCKX66D+f2WBf+pMuFQJjILsFoz34Ask+2/pZCw2t/6sRKUC9pC4cfBqva63/6DtaR+FjiaRI5elUFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wNcn8n4J; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mBzsguHKKdoVF6Or21dkcw8Hhz5v09FCoxV7O+bmroG/Lg/kUl4p/waTaoI9x2waib4YaF9nSjO2YZ0loN5rOK1HpfJvF+lOpqWMJUIQSB1q9Sn1G8u4WslWEnY7d/ESWP/CBi+ybLFrtGp7iRo90DGStWALbSjPPy0hk+1jYwuYD6W6gTiLXsxjKs5LSOj38N21K2vBxwYujw1Ce4k+ceSC1QKBLpUx3F9OnZBVQNAYq7+N9+1bIuLtfEHFdUi6f/bT7ZCTyXf2aOhv8u5pbGQ8KXg3NdSAgBj2gFZvsBUH6optcgcEth3lKoPUP54Z9I5O0yciBFRNT5vTls3inQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LC6S6u7Q6kHGoPbemcQLjmCDGy3jh3tYF/XKw5MVScs=;
 b=Xpza46P1phdKyX+cjkHoaY79/R5TulN8ZrmEVbFGojlnMiJySEA9vQrCfTnxPxjcMQMPi14IPH9DC+FgjRK9K9w9lxVvhTAW6owE7FpPlujttJjjPAf7pSUNniTBd8fOkAn/NQnW2W1rZ6bUtZEOjYSj412vyXR9WkIQ7yOUyHp/9dgej0aRiXSULwMs26CVDQw6NiunYDIoI6i+9Ezqk14t6AlbZ9Leh3esYIqJ4oWxTtSgPFU2Q921NJW5IABiFihCKpU1OParAC1d9n+LtOPOHChMt3SykpfWjJZ/q97y0kMEKyF4O/ahKXEYkqv4DEtMoVO+J3t5M0yBqQjJPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LC6S6u7Q6kHGoPbemcQLjmCDGy3jh3tYF/XKw5MVScs=;
 b=wNcn8n4JqmC5aRppZpPVSxD7fGz4QtuOfi6kvM7xkAB833c2kwfPNDzpBEWCfn8jJBIwSWHI2AsQb7xmxosbdaZ3LexsYvZSD5KrQPrl1SCZKlpniiI7uGagkIU4mK0vxfaSiMfFC+bsdww5QKFcy6s8BnNNVE1KaBbtNQtuDoo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ2PR12MB9140.namprd12.prod.outlook.com (2603:10b6:a03:55f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 11:44:30 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 11:44:30 +0000
Message-ID: <0c13ab0e-ee34-5769-2039-32427ec4cf62@amd.com>
Date: Mon, 11 Nov 2024 17:14:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <20241101160019.GKZyT7E6DrVhCijDAH@fat_crate.local>
 <6816f40e-f5aa-1855-ef7e-690e2b0fcd1b@amd.com>
 <4115f048-5032-8849-bb92-bdc79fc5a741@amd.com>
 <20241111105152.GBZzHhyL4EkqJ5z84X@fat_crate.local>
 <df1da11b-6413-8198-1bb0-587212942dbc@amd.com>
 <20241111113054.GAZzHq7m-HqMz9Vqiv@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241111113054.GAZzHq7m-HqMz9Vqiv@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ2PR12MB9140:EE_
X-MS-Office365-Filtering-Correlation-Id: de9eee95-89fb-46e3-9853-08dd02463425
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0J3SGZsQS9pT0pKNTVGQXlicGdCM1VycW9XczZmZ1owZExuKytJVENCeC8w?=
 =?utf-8?B?M2RnMitUUHcyV0VjUk03R1J0RGt5UlBheTk2Mm1nd2ZEZlcvN0xqNTJGenRm?=
 =?utf-8?B?blEzNXRIb2ZOTHN3eUlMWklPaHBkeFU5UUlLQTJ6R1hyRGovYmxuQlA2U28v?=
 =?utf-8?B?dmxMc2dUOU95NWxvU0daNEcwaHEzU1ZkSDlQZjladDZMbXVqVWFJOTdOeWsx?=
 =?utf-8?B?U3ZLTk1EK2xEN3pZcG5SS05TVHErMVNkL3F5QUliTUllSlNudG9BN3hycisz?=
 =?utf-8?B?eENSSlAveHl2d1F4dU1yY2tXOE11NU81WldFWjQvY2RWNC9jWWNhUE50UzYv?=
 =?utf-8?B?bEJZbENxd1F2c3NWN0lvR3FjWUxVT0xPdnlrNTUwRGRsQXMreXRMazdmb1dn?=
 =?utf-8?B?akhsMXpEZ1FQcXBjRk5SQk93Snd4VnJEUzkzVS9TNE4reWxFR3BlejRWUHhP?=
 =?utf-8?B?dlNwSlBScUo0akc2UTN3MnNobk1DTWdlZitzdnc5ZTRyaTN6Z0JBYjcrMUxt?=
 =?utf-8?B?NlhRejRJZVFkQmdsZFg1cG5sbmZLZStXRWRac3Z1a0g0U3VYNG5TMjVYMS9E?=
 =?utf-8?B?SnBiWkhmWUl6a3o5b21PTDBXSmtRTzlzbEhkR1RQdFNqTXlJTXBZZGYxaHJL?=
 =?utf-8?B?R3BGa3ZJWmsyOE9tSU00cnBHY3Uvb2NScWdIeW5zZ1BrSGhMMVozNXp6MGtR?=
 =?utf-8?B?ZlFvOFpqeU9ERmdlZDZZMTAvaDV5cTlLVlJLMlU5djZxdGZSMjYxM1c2SkRX?=
 =?utf-8?B?c2lUakx2bXZPQitJL3ArTi9VODBqT2tnanlhK3NaRXJCbTFHazFjempoeTlG?=
 =?utf-8?B?bWN5M1B1bFBzaDVuR2VwOVRDWjF4dUpwVnV4MFVpQ0lYaWR1V2RxSjVSVC9X?=
 =?utf-8?B?cUdRQzM0YjJ5RkxXaDJqMXFsVGY2WjlKcWZobnZvTk01TFphOXY2eGlVYWM5?=
 =?utf-8?B?WnNhYXVuTXF6SWc3MjZqMnVTWFBJYUhiVGFNdmhnaEc5bGIrOWplSkREY0lp?=
 =?utf-8?B?Q1J5c3p0Wm1KWkdkcUxmQkVGWFZKeEF2S3pnb1BuR3hTTi83ZEUxUENZTVNw?=
 =?utf-8?B?eUxQZUR4c1lCendLMm1ReEJwbFpNVzRUdmhybGpaZnhuYWdTclRTSXVOeFJq?=
 =?utf-8?B?clZTWGtydWZzVDAycFdLTTZOeDJwVFg5OElySTRDZEdIUzZaTzJ0ZWtwTm9X?=
 =?utf-8?B?bmh6RzhVblVERVRXdUdEMkwrRVg3ZXJhRVpTaWZzcEd4cUJENEFuK3FLSVY1?=
 =?utf-8?B?dGcwR0hldUxWdGtYelY2c2NNUm5vNEtERkVBL3IvVmx1Z25ic29HSGFKTDVw?=
 =?utf-8?B?cEVVWEpPOGlLUFdwTm15eGdRcFoyWWg1UWs5SW1Ga0dyNUcxckJsb3lpY1dH?=
 =?utf-8?B?Z1pyOVYrOVRrVnp5WE5KMGFUMHN6cDRpVFVRdS9XY2NuZWNkUFFiMk11M3lK?=
 =?utf-8?B?b0VMb2FLQ1hEdkhxMUxYSmdYNlZTTWRObUY3dEhjQUFLTG1xQyt3MS8yLzBo?=
 =?utf-8?B?RDZGb01KeFg4WHl3b0RZWFRKcmdGbGRoL2JWeGt5MFR5Uno3QVdtNU9kTU81?=
 =?utf-8?B?THBuWWJoRCtKUXdMbC9Sem4waXF4c1pEdnEzMjBTOExvajRyWkhMNUp3dVNZ?=
 =?utf-8?B?UHdWdXJ2WFhLaXhuZFluSVdDYTZDNzQxWUkxajhIeXRFZUN0cjZ1WUlWbGMz?=
 =?utf-8?B?Y3dEV0E2d0ZaRVh0TkFtVWpqUGlDUHVLNWFSRnBqcjRuQWlnZHpYWE8xZGJq?=
 =?utf-8?Q?xRhm06onMZTBZf1/7B4wDC9XvrjjlQz+Py+lPZt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S3ovTWdJenNFS1JPaHhUVFZ3KzQzM1hlcHFSaDJyNE9zVW93YVJGVXkzK2dp?=
 =?utf-8?B?dExWRXRUVHRCeG5WdHd5bDdnbWVnZ3NzUWNiaU9uejlDQXZwTXQ5amdlOXRu?=
 =?utf-8?B?MnFtYnU3U2N4RFVoKzRrODJnZ3dqdnpyYXFaSlNwRWpHVS9NVEpXdnJtMUg2?=
 =?utf-8?B?U3hyWjlENmN5ekQwMUxGWWJTWjZjVTFXSFhMaEVQYUpYZmc5QTZ4Mm43c21S?=
 =?utf-8?B?UnQ2b3FZRGVDR2ZLVkJTdXdIenVRcWZrbUdUdjhBbCtrWmR4MGlIWGJrYTkv?=
 =?utf-8?B?bFM0NldZdmw1SHhBemxSMGlOSTNhNGVwaHphZjcxcTJzTFhBS2llREU3VEhK?=
 =?utf-8?B?VUh4YldBMloxRWZkR2laYXM4Z2QyRTBYeHM1c0FOWExtb25ZL1FkckUvZjdx?=
 =?utf-8?B?STcwb2RjcldyWDkxVDdrVk5QbkhXRlFKWW8zTFZERVR1WjlONHVzOUZkQTVY?=
 =?utf-8?B?TjhMWEpMUEJORVREdG9US1hFcldyUkVseGhpbk96cDFCSko1R2ZVUVBaa2Rp?=
 =?utf-8?B?U3Nqb1NRTEJmUFZ0OThjM0dzRUVxUU9wVWt5MGVzMjNvdHRMOUV5UW5nWkNO?=
 =?utf-8?B?cnZya29uMFIzNVVrU3VjdjV4SXh1N29MVllVVldhNi9DNzdOdVhFOCtoZHJu?=
 =?utf-8?B?SWtXTjJ2amFmMFFOZG1xeU4wcFkzcFc2SlFHMUhwaWNEQmF6UXZUbmpWVG9k?=
 =?utf-8?B?MjVMQS9HZFN4OHZXR3JXRVo4blNzZzlMK2Rlc0svU3V4Z0h1SVNpV3R5cU9j?=
 =?utf-8?B?aHA5NExMRExSR1pWdlpJcHlhT0FmeHNGZStVaFdETDdnekxZd256TmU2OERN?=
 =?utf-8?B?WXNGUEhndzRoS1hUaDZXVHpzSGhXbzM4dERBNDdHeDY1dVlNU3ZrQkhiN3gx?=
 =?utf-8?B?U3FYMkdsUWxITjA0QTJmd2ZUT2F5ai9JZzJKK1ozU0J4WjdiUElqZHp4TTZE?=
 =?utf-8?B?Z0tkTEpSaDZmb0JaZllxZng5Q2MrT1VsMDYwQytMdG9uVUxKeWY4KzB3eStY?=
 =?utf-8?B?N3pQQ2FjYTF5VE9seUgwQS9UWTg5MlNnaFZjNWdJSVpTbFRCYXhSYmZtTmFu?=
 =?utf-8?B?d3pGaHh6Zy9UbzB0cXNSSWhsMmdoR3RpZFQ5SnhDTHRDaHQra3FXeDdleUcw?=
 =?utf-8?B?RDlOaGM5aFVwLzJ2cmN4c1NrTUJodjh4VXBuUlNYQUZyUE1uNE1mSUpYbUdV?=
 =?utf-8?B?REo2VzZDcTloVDBZV2QxWlp6ZUgwZGN6UnEvZE9Ta2c0Y1psOHVBemhLTU5Q?=
 =?utf-8?B?dnR0a2ZyYWVleUhkMnFnaXRuSEVyNXZERDBGWjAvTWFGZElkRlgvN2R2enV6?=
 =?utf-8?B?WWFPZ0ZsY1FJc3R6MWpmMENqR2lMWUpKR3U0aWRGa0FXYWl0NSsxcDNabmNV?=
 =?utf-8?B?eXh5S2RNMzNvNjcxMzZxd1FjTS84ZGdCWmlYTGQ2U1MrYjJMRjFsQlJYdFdi?=
 =?utf-8?B?VjdTcWdVZTBmZXgrM0p4cGtMRHcvT3p2bW9za1V4L0xaZGhUZlVuN2tpV1Fp?=
 =?utf-8?B?ZmRDQXVoMGtKSFUyZWxtVE5DazQxSnBUZE1UUm1lQ2N3Si9JLzNRNlhzcWNu?=
 =?utf-8?B?TW03aC9pMXE5V3BoTjZJaUJnNWVWWi84T3RNbmJlNGRmOWdEM1JQZVhNYVo0?=
 =?utf-8?B?Mno0dTNpeWt6VXIyQWU1dU01all0Q0x5WDU0ZFo1cmg3V2J3VFYwOUVnTjZD?=
 =?utf-8?B?OTJJUDI2NnVNTU1VNHpOeU1ZR0syL2tkWFJ6WGFpcmNCQjdFcUQ0YjgwOHl1?=
 =?utf-8?B?MmNBcUUvM2VHV0RPcmNIbmsxQ2NLWkk2azBNNHRBNUpyT2NjSnNMblV5SE42?=
 =?utf-8?B?MEJaRGYrUkFHWHloeWh2OVVYZDFnSng5SmZMNTlOaFhmVE5lWUZsb281cFda?=
 =?utf-8?B?ZEhmRytFUWx6YWR6RFVoNnkrUVgrLzJxSThTdHlobHBxdUM3QjY2MmtLcDE1?=
 =?utf-8?B?cFlTa3BIazVKQ1dEOUZFVjh5dnNZZFhEU01MWGZPM1dwNWpHRzNVRVpSU3FU?=
 =?utf-8?B?eGdLWTFCN29LMkRxZ0VRRXdyME4wMUtBb3hmK1NKbTJvdGVtLy9mckdMYWpP?=
 =?utf-8?B?Q2UweTdSKy9aUlUyRlArWER6V1VZSm1lMG8zaEFTdGV0RFJkR0haVzRvNUxu?=
 =?utf-8?Q?IT0DQIAggIN0RIt0iqKC/l0zX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de9eee95-89fb-46e3-9853-08dd02463425
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 11:44:30.5754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruHUwO/B72w/cK5hP0qbjjSLdYtcTyGvgGm3YczWfm6wHx/Fl6WoYV4qwQfE7+yVH6xnaufbWWe2yiv4g0aAvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9140



On 11/11/2024 5:00 PM, Borislav Petkov wrote:
> On Mon, Nov 11, 2024 at 04:53:30PM +0530, Nikunj A. Dadhania wrote:
>> When snp_msg_alloc() is called by the sev-guest driver, secrets will
>> be reinitialized and buffers will be re-allocated, leaking memory
>> allocated during snp_get_tsc_info()::snp_msg_alloc(). 
> 
> Huh?
> 
> How do you leak memory when you clear all buffers before that?!?

Memory allocated for the request, response and certs_data is not
freed and we will clear the mdesc when sev-guest driver calls
snp_msg_alloc().

Let me try again to explain what I mean:

snp_msg_alloc() will be called by snp_get_tsc_info() and later by
sev-guest driver.

snp_prepare_tsc()
 ->snp_get_tsc_info()
    ->snp_msg_alloc()
      -> clears mdesc
      ->ioremaps secrets_pa
      ->request = alloc_shared_pages()
                   -> alloc_pages()
      ->response = alloc_shared_pages()
                    -> alloc_pages()
      ->certs_data = alloc_shared_pages()
                      -> alloc_pages()


sev-guest driver
sev_guest_probe()
 ->snp_msg_alloc()
   ->clears mdesc
   ->ioremaps secrets_pa
   ->request = alloc_shared_pages()
                -> alloc_pages()
   ->response = alloc_shared_pages()
                 -> alloc_pages()
   ->certs_data = alloc_shared_pages()
                   -> alloc_pages()

request, response and certs_data are re-allocated. Am I missing something ?

Regards
Nikunj

