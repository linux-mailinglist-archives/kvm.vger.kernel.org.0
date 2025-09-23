Return-Path: <kvm+bounces-58555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 747CAB9688C
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43CB2164C36
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C20902206BF;
	Tue, 23 Sep 2025 15:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CS2wuiGj"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010068.outbound.protection.outlook.com [52.101.193.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF961805E;
	Tue, 23 Sep 2025 15:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758640600; cv=fail; b=LvOcXCvY8WZ+JLT1zBZX44H9R8XLrS5jmlTDIj4UePwxQPKeGfcXNpHAv8Vopo7h2KakJJdxRd05P0FAZauwX5mChWusWXaFVQhrcxeZrwpRB74G/04++5oBdwbcrd50QjeY5esQsRiXY9az01TOLfisCpm0cjG3VOuqQ+I8nPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758640600; c=relaxed/simple;
	bh=6FD8lxC6oo+L1xtlhuYIwCHYmWsVEc2ByH99kyKhqlM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UvfJqIfs+1plWfr6zUT5DIbSvTwsI+xIoe6Cr5b0W2MpkRsK4kIv3uruFFs0rqmfAXqJdp+uubjb9o8MG6LnXB25tncxTviVct4fK9BooDom6LNYi3dwsmGoaMZ/w4YJaKVD/9eziMTU6L9R8ctyytC0kj9FhelMlqbgs50LwsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CS2wuiGj; arc=fail smtp.client-ip=52.101.193.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fuQQuvEDluStDL9fOm2NwS7Qz83PcruY5uRyZ1fM9JQfSco7MgobDSGAMBCLOX1KwMx5MhGQF0BOKfoLJaMTPzlllQhYuOnx0mqCVeXl6+j1EOsJHc0CMBuopkmaGXOPBEmsSyau7/R5uXOMlr24+Lu48qoTDkcO9r9ZwlBkUKkSQi2g36rteo2WrLbl6mH/CyO/zNLhRhB1bmvVv6rbvLMRyFbznQ/RFhOle2oBMwQ44kdpdDMfhp3mi9XDonlHpcc0el4hf2dHNfLwhhSgdXUrcvlCp3P5uo1Yp9qnfdt6O2hNcHVKbkueBqIBhJZhhM6Z3htJU6b7hOsbDsb91Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/0xO1C8NuCPmmk/bxdnXitPwoyxkymrmAby/CBiu40=;
 b=rnkYm604TVYAc7ylFYdMXclkQ0F3cYHQLn42O+WbKV1vvzrZaxGUHs5Ue/O3l/3Cmij9qmibAQMvdnhN3oxSxddJS9PBk0/FwGeELEonnftTkwc8pwaf+8Q+ULNAdMLj1hcB3zqVQFSmEZA/Wqxhiaxou2Y0tOqJ6I1hrnfz5/t8y3/EqqKdr/Si480fmG4KfIo2Sqy09ZaKSyDnXDbrsOkPnOzuhyn4VEzaViB9uXZjHoI6/w+lNwZde3pAw4mi7JXuujC1irAFAyvjdw5/g4VLHmzBajJirV1y2xwsoc/NPbebVt+doR+8SPU7IejqanGyrbRKSvRf+AJFN2s1rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/0xO1C8NuCPmmk/bxdnXitPwoyxkymrmAby/CBiu40=;
 b=CS2wuiGjwEoU1UqJEZHKeN2DG8uB7LybvUW1FV2VD+f4CNo/DqmD1B738mzAVgmpWHY8UJAsi8toXY7EoZOxj9ZOUPa1iMLgT7J3ycFLzLUnf6JTLgjIlP6/S5KROg/j9C9zqi5xQzz29qWBlZouDZ+wXdv6gIucOYh9TKvOOIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7428.namprd12.prod.outlook.com (2603:10b6:510:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 15:16:36 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 15:16:36 +0000
Message-ID: <b3d83827-a4d8-78e0-a09a-41f4ec895a5a@amd.com>
Date: Tue, 23 Sep 2025 10:16:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 10/17] KVM: SVM: Set VGIF in VMSA area for Secure
 AVIC guests
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-11-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250923050317.205482-11-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0057.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 300c93cc-8086-4961-aff1-08ddfab42fd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXhyQm5rcGJTL2ZkSE53ZGpIN3RqKzdER0RPazd4Yi9CR2tiK0lheVI0dHJj?=
 =?utf-8?B?dFZaZ09ScCswV21uR3U4ZkFwYnd4MVQzYUN2T09Ub2pTR3pzVHRKNk0zTlA2?=
 =?utf-8?B?MFVxbWllVUVGNjJHREhRTHNuUmQ3SnVFQ3duakxHaUlRNG1FWTBiOEZyY3BI?=
 =?utf-8?B?WUN1ZU5LSW1qZ2h4a0taamNxZlg5bzJDbXMybFZrajc2cmVWclZYNXIzbTAx?=
 =?utf-8?B?alBHdGJsVnlydFlGeFd3OS8xc2RFWlVUc3dNbHZORWFSUWlxUHgyditDVERs?=
 =?utf-8?B?aldZNzFldlcxMi9DZkF1UTN0dzBhVzY4L2ZRZTVYRmtML0VDS1BVMFdxbDhK?=
 =?utf-8?B?VHpMK2hpMVJHSlNqZUlrL1Y2Q0djRmk3ZGxCa2Zvd3ozTTBYUDRBM3F0RTUr?=
 =?utf-8?B?VUxCc01OdDFaY3lmbEtTam5CbVFXWllzQkhhN1lnVDVGcUErb3JsZ2JJeXdr?=
 =?utf-8?B?WU1YMDc4UGl3MXBJd1hLL1BXZUtrcW13YVlVMTBlSk1yMWo4YmNaSHllMkkw?=
 =?utf-8?B?M2tyTUNrU01ScDgraEd4WUppaE1GR1JlTkEzZDM1WHZ1MzJwblVkMUd0bUJZ?=
 =?utf-8?B?Tzk0MDlXTzM3OWF5eW5NVzJXM09ZVzFTRm5ITHFyUndnMmNVdlBmVTE0RHp1?=
 =?utf-8?B?bHFab0dqdi9XVnVmR0JyRkhhZFV5b2xTMWEzelRzeThHR1JCM1BjYjloY0Zj?=
 =?utf-8?B?dzM1ZE9yY0hHSW0zOHM2YVNzWW1LTWR1bzF1TytUREszaHNmVGJPUXlUSC85?=
 =?utf-8?B?dUM4Smo5cWdVVzdnWldYWmlpd3hJNGJnZzBjbUl6aWxOUml1Q3l6K1cvMmRH?=
 =?utf-8?B?TlRuZStyTGlwS3VKRVV6NXRXRGl2VEhrN21qUTBBOHIvNk9SdDJNOFkwNGdW?=
 =?utf-8?B?cktIYlFaWkxrQVRVNEg0UVR6TFRISzhoczB2YUZjdjVpRUVsYnVNb0pvNmpG?=
 =?utf-8?B?d1pBbG1JK2tVUkpKTTR3MElERW9lRmFrbS9Na1FDMGNJdzgwZFFsZ3NqVUR2?=
 =?utf-8?B?b0F4bUtJcThqdElFNXh2K1l1RnBqd21kTko0ZnczODR2VXBnV0pqVjduVFE0?=
 =?utf-8?B?ZFE5TS91L2hxTTc3OHZ5dXQrL3cvalNVMmgvK3l5UjRUaEdGaXhEeXAwNk9o?=
 =?utf-8?B?V0JicnA2bFQrNGx0ZmhWS2R0c0V4anlBN1EvdlBCTzBHU2dkaWFpU3l4NWVO?=
 =?utf-8?B?Zldxb25HR1Ira2U3ZDBzRDBZMWpsWUE5ZjBPR2ZIM0RSdjNVU2c5ckE5VHBw?=
 =?utf-8?B?RU5KQ2Y0eFdpeDJ3UkhBak9uT2g1WlkyZjZaZVRHNEpML2hHSGgyY04xRDJ2?=
 =?utf-8?B?SHFKaWNBeWIzWE5XeHVFYlVSdFg1Ukw0TXZ3Mm5QTVVLblZ5VG5lKzRvaTJD?=
 =?utf-8?B?akY5MVBrazM5L0xYSWxDcFYwUXZLdk1FTnE1WitrY3pzaTdtcm1rZG9vaHBv?=
 =?utf-8?B?d3ZrN0JJRGp1dVZETDRFTWtiemkybWYwbmNXb1o0cDJJdC9ySUlob1RISFlX?=
 =?utf-8?B?VHdrbkI3N1lNMzR6c3B5UnFjbTF6VUFPQ2RSSXhOY0Uydi9kdEhhYTZ6ZjhB?=
 =?utf-8?B?eTBBclZ0YjNFN3BqcnZoa290VWhNelhTdEQ0cE9DWWtDKzlscWJlS1pqMmNk?=
 =?utf-8?B?bm4rUXd6aXR6SmZ3Mkh1azVncXFVUWlxdTBVa0JIdHR0YlUyOHVOK0U5ejR1?=
 =?utf-8?B?dVpOUWwxYWo2bWJybkJ1eHp0aVgxdWN0alJrU0FJUE91U3BRWEtTeEtGcU4x?=
 =?utf-8?B?ZG0rWExiRGt0ZGREOWVzaGs0clJCUmI3dE45UkdCL0NJcWVWUmhrUVFkenRx?=
 =?utf-8?B?RlFNeWN0cXNaa28wR2xZRU90VFpOWnlFNWNkUmhKWDI2c05WRktoVmJpalIx?=
 =?utf-8?B?Y3pOT1hPK1dLUC9MVlJvRHRVUWJBd1d3OE53TklGRnJQcERpWnZ5N0FpajVs?=
 =?utf-8?Q?65S7wZWiy2I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVBETjl6S2NQbGJReUZuNjVjU3k1eXlyZHl0Z3g4aEFzdDdETElPQVBmdCsz?=
 =?utf-8?B?eHNlT1B0NDBvcFdobG1BQ1NCRlZqYzN1QmxESHVvK0FGM2MvZXNhVlBPazNv?=
 =?utf-8?B?cnk2WTg0OUtkVzVMaElFNEwyUlE4SVVFdk5zRlVmdTVBQXRKcUxrdCs5dnZo?=
 =?utf-8?B?L3N0cUxIVTltZ0NMdTlHelBINHQxRHI5QWdxVWdsYUxHeXUyc0ZhdE9GdlQ1?=
 =?utf-8?B?czBKUWZDUmo0ZFUrRDFUZ0djU0lGYkM4d1VpK0YxOXRFUjBWTHE3MEwxRHRB?=
 =?utf-8?B?d0RrSzNnVytZV2w1WFdrSUxEZ0M5TzBsMXlwcE5yeVpieGw5UldXREljQ3JS?=
 =?utf-8?B?MWNXWHBxY2dhbEgxb0xaL0pVVnhNSzNTOFhpVXVnTW1mN1pzbjE3MVZReDlC?=
 =?utf-8?B?QWhCa3c1MzYyekE4c2tLbWg4QWdmTlNUOTFNYmhYVnVsaXNMcDZhTERmOU1s?=
 =?utf-8?B?eDJ0NkxGMVFPUHBTeVJQT0VORVlCTjFCa0RzTGVXN3JhNGJ1eHh3M1F5WTJD?=
 =?utf-8?B?RTFqenN5K2lCU0tweFJvSms4OVpJYXFGWHBBTWF4ZGtpOHFHNlk4ZndwT2VL?=
 =?utf-8?B?cUc4YkhieFUzNklJd1pRMndrN25Eb3gwQ1RRSDNZZFF0YWFhVFdIL2Nad29y?=
 =?utf-8?B?cHFWcG9LNzFvUXZHWEhpa3JIbFh4MkJGMlpOc0dQZi9NM2pzSFJSOVY0bkNI?=
 =?utf-8?B?RHdLUVRHODdxL0NFY0VmRDBTb21Yd2FhVmRRM2VWdTdzbjU2VmFibWZZOXp6?=
 =?utf-8?B?aGhML0Z4Z2k5YWgwaUw0VmRESDVZRWhFMXNJeTdPT3BObE9xN2JJeS9Zd0xX?=
 =?utf-8?B?VkQ1VWZSZUdieWVnLzJla3pjUHJZcUI0VFVibHM2azhtNmFMV2xsalF6Y1Y0?=
 =?utf-8?B?OU1pTFlFZUJRTjF3U3hhSG1EbkRqZEpqRWVnN0QvQUlIZnNiZ01nYnRyYWh2?=
 =?utf-8?B?YjlJWDRWZ1F5SFpieHlkQWYyOFdmRWRaL1h3YWtNbUhnZnJpbU5mUUp1ZnlM?=
 =?utf-8?B?RFE4V3RBRGxLUHBnQm5nMFRlNUh3N1ErU2tsUE1TaWlkZjUzTXc5LzY3Y1cr?=
 =?utf-8?B?MlBlTGQ1clVJTVJJTWFUdlM2L3ZWQ2ZCeW9NZ0tTbkdYQjRXa0VhUFJMOEJS?=
 =?utf-8?B?ZVdjZ3lpam9SRVlJWHlWaENzOHc2aWV3ZFpWendRT0lFaW1BMHdBTWlHUmdq?=
 =?utf-8?B?WC8rZjRodEhBTFpFRWszY3lFWlkyc0RSZzd1ZFRnUHJ2U1V6UFlZY3Y1RjZu?=
 =?utf-8?B?aVR6Rlc0bzU3SlUzM0tveEFGMVpHbEFzVmxyMEhhcjVIREtDQkppM3JQQzds?=
 =?utf-8?B?S0NxMWpJUWJqUnA1dTc3cERnVmV4ZGgyNmJkS3F3R3QwV1JTQ0k5b2RWdHM0?=
 =?utf-8?B?TTVmQjdMNGdXMXNldStPN2pLSHRmWEdYdjNHaVo5cmFaRGFyK1QyajBGMmkv?=
 =?utf-8?B?YmlUMkUzWTZxN2VXeXZRUHBvNW1YL1p2WUlzaUtWc2hkQzhVN2hTa0tVYnVo?=
 =?utf-8?B?eDJZQTFjY1Y2ekJQWGpXQktDKzErQ0VrMXNMWkpIUGpBS1M1TFI2QTd5djZR?=
 =?utf-8?B?emx3R2M4Q2l6NG9pZFdieldsWnJQYTBHNkl1UDBVdGIzSkJoSUJKSkhiQW9p?=
 =?utf-8?B?VjRnTkMwdWRDMjJ1aWthRTByYWRKRDRFWmdNenRhQ1U1ODlLNWJ0aGJ2bUlQ?=
 =?utf-8?B?WVgxVFFlcWRIVS9BdjkxSE1iWVRDVlBuOWQ2U1ZsVTJtQWtJMk8veituSFhM?=
 =?utf-8?B?UzU1N2V0dUl0RnlldUZ6NnBTMXIvTGxZZUVuT0kydUNPVnRKRVlrMlUrTWJp?=
 =?utf-8?B?d0hCdlN2SHpxSVhhN0lHTnJWM3pBcjVmbXVLLzkxMTV5a2xIazJUZVZUUTk4?=
 =?utf-8?B?ZDkrQXBNTDJQVHNlNFZFQmJxd2FxMmRoZE12d3NyNHBUR2RhZ3NEVFFVY2Z6?=
 =?utf-8?B?RnJjUHFjelFtcVBsTjVmODhnUlpHL0lkTmFxMTQ2c2FYamg3OWwxWWhTajlz?=
 =?utf-8?B?R1pNOFcwa2lFZE8yMWI5QlQwbGV3THRIS1cwMFc2bElBS2swZmhvU0l1QSsy?=
 =?utf-8?B?WUo0Vi8zUzVoRHVKSmdJYTBmZkFYR0huSjBCMytoWEx2Y3hRcXZVWjFoTXlj?=
 =?utf-8?Q?O5x/29PYCCF/2MbfdFS+uPCR5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300c93cc-8086-4961-aff1-08ddfab42fd5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 15:16:36.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XfvnG7uin7f04XDtBBuSBOE2FIdGtGSyqudRS+sk3udnnmP85IhZdWmBJnw2fkA29SULtS8cPlOPEqmwmTpZGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7428

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> Unlike standard SVM which uses the V_GIF (Virtual Global Interrupt Flag)
> bit in the VMCB, Secure AVIC ignores this field.
> 
> Instead, the hardware requires an equivalent V_GIF bit to be set within
> the vintr_ctrl field of the VMSA (Virtual Machine Save Area). Failure
> to set this bit will cause the hardware to block all interrupt delivery,
> rendering the guest non-functional.
> 
> To enable interrupts for Secure AVIC guests, modify sev_es_sync_vmsa()
> to unconditionally set the V_GIF_MASK in the VMSA's vintr_ctrl field
> whenever Secure AVIC is active. This ensures the hardware correctly
> identifies the guest as interruptible.
> 
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 837ab55a3330..2dee210efb37 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -884,6 +884,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  
>  	save->sev_features = sev->vmsa_features;
>  
> +	if (sev_savic_active(vcpu->kvm))
> +		save->vintr_ctrl |= V_GIF_MASK;

A comment above this would be good.

Thanks,
Tom

> +
>  	/*
>  	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
>  	 * breaking older measurements.

