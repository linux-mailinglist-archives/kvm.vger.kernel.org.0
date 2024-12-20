Return-Path: <kvm+bounces-34257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 154F79F9AB5
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 20:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E4CD1897B89
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 19:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C0C225A22;
	Fri, 20 Dec 2024 19:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FrgrgPav"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FF22248BA;
	Fri, 20 Dec 2024 19:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734724352; cv=fail; b=qX6Tv6sxKgCnGsApC1NmE2yekBcCvGbJGMq/8/d00CG/4lJV876FZT+HChN1Q6v6Pi+d/MfcSHjw/L0scsQSvN0vF1L4GHcXDmJVrzveZ0XnRbKlSJ4QArkrWgUZBgSGe3WyPvA1+YfZv2DmEXxFFhcM9/K61a3aM6wHotkYwyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734724352; c=relaxed/simple;
	bh=/8LU9pRDS+slfEnigfuEk/PeAHjMxK70iQySnX+qZug=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R6FhqZQRPp4Nx0ZrwM6nW6PiW/v6uKFg1ZWqQWsXQ65/8pLs9o89WrCYv/zTfduZCGX2ND1hlv3JQ4A1AaIzu7Bv/7aDOa/9HksJEiXIGJ67+6KcheUbV1k1hk+Hv48WHJD2OeXGTKLp+VTDUk60V5ThUYX4/X9u4FGjIvbvMfw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FrgrgPav; arc=fail smtp.client-ip=40.107.237.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fSpLbds5xsW5ZL3ugjs0lU6fcnysZynPXneiTvIguLyZuQGV76xEbqlnGqPo8mjsWGh8CUGKnk+2C+mDu7WT8Gqe78uvYD6cLpObl4DoOx738EBBwUtLNqmmar82BqB0pfkTL1rYsWQdpmzob2xagpm8oONtLcIi7/NKjzSUQjf2U4VRU6RDhb7RXRIpYSd2JNwNFAYL6jKrw2qxjhKnqoGySbQ0LxRpPbaz2MVorqUyKq6C/2ylxeZ6cDPSFY2TZ5xAHAyPgxBKhY+RRpmYmUGXB0/TRPiq+wSYXAPir5U9S8SFeNEtnRCMY+Oms06xILyKy2pztHgrQBBw3PEp7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQfW7wCvIa3CBEkFMfKQWVRKmxZq1Nj9Ujl8qrIJERs=;
 b=jrmRWzZO/u99I2mXNG5Un/MqF62ePkZoMOmPQTYggDHalkQtb+PYUCIj3avagNKNReNxZSriUUDxLRbeQzMX/zSaBYXN2yDQw4zGGhPPzgC/JgxfJgh8DeZMUhADYTxxf435tfILnb8y1LSI/AQ82Dlfzg9HMQresC7qdb/3jvY6uk0ADXNLNPojjS1a8nhCStxp2caC7FnqGhOhiUCUrp2xXhgc5d7OpWX8qeUbO9CCj6S71i+kfDzCiwMUJqlz/Yk17wkPoplqs0ILq919uYq8kfqPcrJm0V76MQkyeWrjh+ItuviaPBaIwVVolFqFtbyDBJBf5qUEt5tiAMfQlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQfW7wCvIa3CBEkFMfKQWVRKmxZq1Nj9Ujl8qrIJERs=;
 b=FrgrgPavw1Khjym3jSi/VekkJWGr3VsWUwM+oWZi6bPh/rZ/PDKt2x34CQXY+5y2uCxpFW6IXDG2SZhzCcMU3oMnhbBysI0j9TfufEuMVTN3jHMALZvlwhjYR0OiaX5Zsg8k0+miarU5yYE3/unCU55xUovzPToQUvhMAsKD4Yg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH7PR12MB6908.namprd12.prod.outlook.com (2603:10b6:510:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.17; Fri, 20 Dec
 2024 19:52:24 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8272.005; Fri, 20 Dec 2024
 19:52:24 +0000
Message-ID: <88cd10e8-e9d4-4c11-a494-37e0cf83bad6@amd.com>
Date: Fri, 20 Dec 2024 13:52:20 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/9] Move initializing SEV/SNP functionality to KVM
To: Sean Christopherson <seanjc@google.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Dionna Amalie Glaze <dionnaglaze@google.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <CAAH4kHa2msL_gvk12h_qv9h2M43hVKQQaaYeEXV14=R3VtqsPg@mail.gmail.com>
 <cc27bfe2-de7c-4038-86e3-58da65f84e50@amd.com> <Z2HvJESqpc7Gd-dG@google.com>
 <57d43fae-ab5e-4686-9fed-82cd3c0e0a3c@amd.com> <Z2MeN9z69ul3oGiN@google.com>
 <3ef3f54c-c55f-482d-9c1f-0d40508e2002@amd.com>
 <d0ba5153-3d52-4481-82af-d5c7ee18725f@amd.com> <Z2UvlXeG6Iqd9eFQ@redhat.com>
 <Z2WaZvUPYNcP14Yp@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z2WaZvUPYNcP14Yp@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0172.namprd13.prod.outlook.com
 (2603:10b6:806:28::27) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH7PR12MB6908:EE_
X-MS-Office365-Filtering-Correlation-Id: 9532c626-21bd-46a8-42e6-08dd212fd2ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTV2aDg1aE9tSDJIRzhiNkovUG1OOTRhUS9aQ3ZXdUlxd2lEeDBURzlKejhL?=
 =?utf-8?B?U0duTFk3QnZGR1ZURzd6VjZaSDBRTWNyYWNUakRUMEVXc2xDanl1dmUzSVJT?=
 =?utf-8?B?S0NzSndxUzI5ell6c2ZhbFFnbzUxTW56azZCM3FuU2lZaE52RVE2djNhdmRq?=
 =?utf-8?B?SE5zOGVkYVh0dUdicHR6eVlNVDBoK0RiSncxL0poZG5odEo1ZnpYL21XYTg2?=
 =?utf-8?B?N1BQRHVtdHhBdERCNWduSmZ0THNWZFYrZGU0VE5kQ1gxcXBaVnpBTjNEY0Jl?=
 =?utf-8?B?L0lQZXhTSVdKR0hYaEF5YUZwWDdZZ2VXMXNPSmJwSGFwYmF2VmhFQXRlSFlQ?=
 =?utf-8?B?ODNmeFduTERIL0F4VmVBZXV0MzY2S2N6MXA5bzVnUzlUUEttUXdXNjdLYmVI?=
 =?utf-8?B?YlNON2ZlaWM0V205TVo4ZVBiSG9YRndNeW9NRzRSY2d3d2dwWjJBWENpRWZI?=
 =?utf-8?B?QUlKQlREOGo2VUcwREI3N2JwckpQb3dVWlM0WUFtQnpGQ3BMUEhyQ1VBRkpm?=
 =?utf-8?B?ODNQOFVUTExQRkNuMXdDNHBOS0NabkxvaERYNjJLMGk5YnZxekZDTXlIUDNG?=
 =?utf-8?B?a09GY203OFhtdXNTQVBzd2VuZHp5SFlBQWxJL0pSa0I0eGZVK29DWGhRZjNZ?=
 =?utf-8?B?aVNZOUtmeU5mNlY5eS9hL2FValVKNHArVVNBWFdyeU1VNWluYnR1MmlicTlo?=
 =?utf-8?B?SjBNL0lzYm1jZUdBQjVBZkJMU1phZ1ltS2lGK3NmVEZTaUw0YzFUNkMwY1Vw?=
 =?utf-8?B?aWhPVlpSTkRJeDVPc1B5SWRpb1U0UmZuUXNWZU5qTjIzZWhaTWRENk9WS2tR?=
 =?utf-8?B?TEtPMTFFMjl2YzZjTEJreHNkWWg3alA1RE13QXova0w5eFNBSUw0TG81OGRj?=
 =?utf-8?B?S1ExOGFWSjlxQThXNnZKVk9jY3VYdFd1TlRuNWpGMjF6bHNNQURHZXNrOEJn?=
 =?utf-8?B?T2h2bHh5RDJjRW9KT0Q3M29mOXczdHVNRHNsYTBxSVZudHRJeGd3ZnRxZ0xP?=
 =?utf-8?B?Yy9kVzNNdk1IWDcrZGlvVm9tMlJTSFUycVRIamYvWHV0TC9YMTdvemdWT3lt?=
 =?utf-8?B?dmViZjl0djF0S3RMRFVzeEJJblN2TDNuRGt6NTZTbkFEL3IrdGppZHZBcnVi?=
 =?utf-8?B?OGVzNTY3R3Z6M0s1azJVOGcyZnRvWFJINTNyNkxHc2JVS2VGUUZjU3o4SU9L?=
 =?utf-8?B?UUU5UkR6dGR5RVczc09aWUdONERJM2hUcHdBeVErNGNhY1B0bzlRSU83QzA4?=
 =?utf-8?B?M0J6ODVJTHVWamwvaitWVHV3VjZGWTE4S0gzNjJaZHZQai9OU1RnMmRtK0l0?=
 =?utf-8?B?YlJhWjhtVEtoejBsYTc3Z3pnTnBhcEh0QUN0ZnlxeTkzNlFkdWRxd3Y1OGRj?=
 =?utf-8?B?ZFRsWVhxNXFZeENaT1VHSFVRTUorZUFzNVhZaG85WUtVQ09MblZLOVdXYldH?=
 =?utf-8?B?b1EybVlXb3E4bkVTZk9PSzV3N0NTbjJBK2dhRmdPUDlXNWdSMG9nRHdFSnIy?=
 =?utf-8?B?WXhlQVd3MXp6R3NTRUJkWGR3NWNmdVMrR0RpQjBZOVorT3FhdW5KajdYTUVJ?=
 =?utf-8?B?RU85SUluRFF6MnRNT0kwS1RpQTYrZEFWbDN3em1KdkhKNnZpSWhGZWY0ZGRR?=
 =?utf-8?B?VUJUbVBwK2pEWExYbkxkNzNvSGpiTVJmcTFUSnpnV1FkYjFxaHRQSzFwc2xv?=
 =?utf-8?B?RmVPZUFIays4bUdFbzZhc0RPclBNLzlOTmVLd1hQT3NqOG1ZVzNnOEkrdzJp?=
 =?utf-8?B?d3QzNlBtZ0JHYlNUVFp0TzBLdFFrMHJuZUw2Q2ZoUkpHZEQrVDF2aFN3ZU5H?=
 =?utf-8?B?YUpDYVZGSVI3bkNIbC9LL2hUZThJNHJVRkNZRCtSSWlaR3BmUjlNY0ZOTGY5?=
 =?utf-8?Q?Q+kEakxDAWRPc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFh2djJsclpiMXNQYVBOcHkyYnhjTDFsUUJYRURTbmM0dlVLK2c1S3g1Zldo?=
 =?utf-8?B?Tm02RUtkVE9HQ3U1dy9BRmV1UjkvbXZIeUdibVlPZDhoT3BlZmtGWG1tSUFx?=
 =?utf-8?B?S01jRktKdGh3ZHowMk1Talgzb1FiYUpKcUJFdVEzWjU5bW0ybi9CM3JjQzVn?=
 =?utf-8?B?ZnhHREJMWGVNNFk3Ylo0QTBTMHpYekhyOGlwZE5QcEVtM3V6dlZIMWxGdDlO?=
 =?utf-8?B?aUpYU1ZEUDFSY0Y3QWdSOHRYbzh3dm9DTW94VzcvNjJlTit1aTBKMEwvK0ND?=
 =?utf-8?B?Zkg0M2YrSEJqMTdzbnJONzJGTHhoSlI3WnpYakpzTHNuRDd0R0NOSkk1ZlBw?=
 =?utf-8?B?NHE1MiswOHAxSVFZZVNSUC93UHlENmpFZzdLODRsTENZM1piOHpzbTkwdkZp?=
 =?utf-8?B?dGQvNlFoRHVKVW1XWVppL2ZwOHVaUjhoRE5JcGlvV2RSSWh0dG05aVBoamlF?=
 =?utf-8?B?NEM1ZTFNVW11Q0ZLK3oxVEQ2VDhZYjQyNWtpUkZlTVRzTTUwNW95Smo2aXhH?=
 =?utf-8?B?SCtKOGxkVW8yVmcrMldGTUhscnRieDViT2Nvd3pvbUJ4NGtFWUt0bnRpNWps?=
 =?utf-8?B?Y1NKeGo3YVJONUNPYzV4bDg3UWRZSUlUcVRCb2NQQ0d4Q2VMNjlJd2ptS3o4?=
 =?utf-8?B?MU8vM1ZNdDk4aFZLRWVCWjZOODJzSThTS3RSL2ZheUpBQkpFODU5YzVMSjdv?=
 =?utf-8?B?NTdsZWhNTk9POWgyYXVHOUh0N0IxNkJCRmpNOUJ1eUVKQ3R3bFc3cXd1bVZr?=
 =?utf-8?B?cnhoS1dhM09VUWhEVG9maVR0REhETFkzUElQWkZmdm5SS2FSSlYvcGlJd0VM?=
 =?utf-8?B?YVUxaVBjbUdSeTZJdFdWTTlaN2ViMHpLcTlZV0c0M3ptNzJNME9ZMGNsSWdu?=
 =?utf-8?B?RHg2aVNtV2d4amNqck5wVUpZcVpQYTFFaFNpV1BOUllydzdXejBLV1dXVHdV?=
 =?utf-8?B?OUNRaXRCdnZnVkJMSVFqZktDbnpxNHh0R1hta2J2Y3FCWm4rdmFvbWpMalAv?=
 =?utf-8?B?TGUrTHBOTVdEVDJLNXlxVnMvMFo4cUxFNzZGb1JXU0VJNlpWVmdjMnd5cm10?=
 =?utf-8?B?ZUh4bVZ5TUVhMnA3UCtFTmQrYXMvWXJGV3NjMXZGVWZoVGZzS0ZiZEZvUDBM?=
 =?utf-8?B?NzhRSU8xQzNCdlhqSjlPdGxmUVlpTlZvVGhzVFU4c2k2SkdSeW9zdDlzZ21o?=
 =?utf-8?B?R1R4ZW82WHhudkQ2SnU3QkZ6UllMT0ZJSTZkWlB1N2xBcFNaeXhtMXhLNFgy?=
 =?utf-8?B?YU8yYkY5TlJHK1Nmekd3TERZaEYwM1duZnhwZEJ6OHk1OGRMVkwzREtVR3Nu?=
 =?utf-8?B?ak9IaW1nRHdCT2FxaUxwWkJkK0RTeWh1K1gyR3E3TXVUa2hqVmg1OHZ1SHBy?=
 =?utf-8?B?cUZyR24ydXdKRlVHQjNPRjFUS2g5MnFXbU0ybXNvakxlc3EzVjEvMlJRNlA5?=
 =?utf-8?B?TnRPMTZsc2dHMHplN3NvVlpLVkRoR0RsTTBiOUVBa3hOZzNHTWRmMVJOUnls?=
 =?utf-8?B?OEFjMDByc2tYRlAvQmJ5VVIwSHY1T2NteHJraklPcDRJWkNDQWR1cXVYdDl3?=
 =?utf-8?B?cHFzL2Vua0pHeTM5Y1c1U0I5SEVJbTFBd0l3RkJUbVZhVTh0ZFp2TEZjS3NO?=
 =?utf-8?B?ak1BdWZ5aHo3eElmVk5nWXUzZm9STUF0c2hYc0hUOTZpeW5PYVYzUjNwOEFZ?=
 =?utf-8?B?N21YWlJsSUZxVGMrWjBMU1hPQ3Jnb0k5MjBzTWYzakFKYjVxN2NXdVRCdGZj?=
 =?utf-8?B?VTV4cU01d1VjNlJzWW8xVTF6ZzlFTDl0TldnRlcyak8wbmhqQXRMM3VVcVRK?=
 =?utf-8?B?TFFQTGFOYUN0c0FicXF0MytGSm9hUlpFUU5wZEVxRXlXV0U2cVF2WUJSQk5T?=
 =?utf-8?B?MlVCOC9id3NtdWRlZ1N1aUV4Q0JreElyZ21qRUtjYk1XT05PaC9xd0drYm5l?=
 =?utf-8?B?bzhUeWRYdmc3WGhITHpaS2c4SExTM2E4OVh0cTB2MFhxU0ZBSURNSFZZdjRr?=
 =?utf-8?B?QlJubVVhZ09IRnpWQmVXRnA3Q0hNcDZFQ0pyRUEwbmJyd28wZmRXdlZSQmdj?=
 =?utf-8?B?Z1YwckNhUTRIRXJQRjd0Und5NE1FQk1PK3BMTjl1NkJjdERpTlZyaTVwVVJ3?=
 =?utf-8?Q?1B9j1Ar6bzpNvjHbUIDSr1iX2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9532c626-21bd-46a8-42e6-08dd212fd2ad
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2024 19:52:23.9861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmWy/tUS8JrLvtkE/Rtr2svMGf61tXz1iyk55IiTLIdCjACn0JsMLTK5iVUfD7zR+RpeR86gGGHKoWBpp/9NAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6908



On 12/20/2024 10:25 AM, Sean Christopherson wrote:
> On Fri, Dec 20, 2024, Daniel P. Berrangé wrote:
>> On Thu, Dec 19, 2024 at 04:04:45PM -0600, Kalra, Ashish wrote:
>>> On 12/18/2024 7:11 PM, Kalra, Ashish wrote:
>>>> But, i believe there is another alternative approach : 
>>>>
>>>> - PSP driver can call SEV Shutdown right before calling DLFW_EX and then do
>>>> a SEV INIT after successful DLFW_EX, in other words, we wrap DLFW_EX with 
>>>> SEV_SHUTDOWN prior to it and SEV INIT post it. This approach will also allow
>>>> us to do both SNP and SEV INIT at KVM module load time, there is no need to
>>>> do SEV INIT lazily or on demand before SEV/SEV-ES VM launch.
>>>>
>>>> This approach should work without any changes in qemu and also allow 
>>>> SEV firmware hotloading without having any concerns about SEV INIT state.
>>>>
>>>
>>> And to add here that SEV Shutdown will succeed with active SEV and SNP guests. 
>>>
>>> SEV Shutdown (internally) marks all SEV asids as invalid and decommission all
>>> SEV guests and does not affect SNP guests. 
>>>
>>> So any active SEV guests will be implicitly shutdown and SNP guests will not be 
>>> affected after SEV Shutdown right before doing SEV firmware hotloading and
>>> calling DLFW_EX command. 
>>>
>>> It should be fine to expect that there are no active SEV guests or any active
>>> SEV guests will be shutdown as part of SEV firmware hotloading while keeping 
>>> SNP guests running.
>>
>> That's a pretty subtle distinction that I don't think host admins will
>> be likely to either learn about or remember. IMHO if there are active
>> SEV guests, the kernel should refuse the run the operation, rather
>> than kill running guests. The host admin must decide whether it is
>> appropriate to shutdown the guests in order to be able to run the
>> upgrade.
> 
> +1 to this and what Dionna said.  Aside from being a horrible experience for
> userspace, trying to forcefully stop actions from within the kernel gets ugly.

Ok, SEV firmware hotloading will refuse the operation if there are active
SEV/SEV-ES guests.

SNP firmware hotloading/DLFW_EX is anyway transparent to SNP guests.

If there are no active SEV/SEV-ES guests, DLFW_EX will do SEV Shutdown
prior to it and SEV INIT post it, to work with the requirement of SEV
to be in UNINIT state to do DLFW_EX.

KVM module load time will do both SNP and SEV INIT. 

There is no reason to support lazy/on-demand SEV INIT when the first SEV VM
is launched, and that anyway can't be supported till qemu is changed to remove
the check for SEV INIT to be done before launching SEV/SEV-ES VMs.

Hopefully this should be the final design for SEV/SNP platform initialization
changes and SEV firmware hotloading support which i can go ahead and implement
and if someone has comments or concerns with the above please let me know.

Thanks,
Ashish


