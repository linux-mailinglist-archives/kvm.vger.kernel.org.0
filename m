Return-Path: <kvm+bounces-48254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA93ACBF8B
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25ED73A39EE
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 05:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6904C1F2B8D;
	Tue,  3 Jun 2025 05:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EHZm0tJ3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D201519BC
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 05:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748928403; cv=fail; b=og/ZBiAp3lmfJlZsqSCzhy/6S/W0Q7tcXhPgT6FjH0NKEYp/uzUDw5l5DDlGu91pspTKi7dkpxg7GaiWDhW23XPR/AFfOeLbgmPdlhOH3aaMxTg+40D8TOsWW9JwmaHltBCCd9qSK0viIQvv55FAukMgEkjJTV0SVJYE7ywnpJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748928403; c=relaxed/simple;
	bh=FcRST+InCsErgnt02/+iC0cSEh901uAEuAl1SxqwfFM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SNMcb3c8PFE8msZ2OQMgQUjL6JdcBMhEBkI7g/6VZkxKd9MHfjKBF5/VptbFEvQ3MdNmZ2IpDHLwyUfvbhmT1VWm2ip2AWRIQZEHaS2+DcrswaW+MZBDQSkJ2nn9PGO2Lxn5tgfHoydEUu1f+kQSHI64/hJOztzZvWnkWLZfBEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EHZm0tJ3; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qv6L3rJ/4vM4AQ84HURyq1WSWMYpekw3/zCnyoMKAhpz2l7y9Ew8dDm1ypPW18TOYpNxmi5GZsUjYjjLOCqgjc+rwHSpiARiKjCTu6W+tai7Rkfjt/X5HuaN3O3L5gB9NyN7wy1sBLqxBhMkH4Rs9DSFUBHTyGgc36dvgKm0eWW9gom+cVlBkBQQ7bIVa79wNSl46WoB7icJwSwdYxsEuafdeXd3ck+2M847YvA+GufSW0AVGLP2zI6OACoLqySFZ/60g598tII16iKqW/eHgggQPpNd1j9Lpj+y0wRmIGAjjaPmQfFT/OyHgfLMEQmbtckMGT2PqLvScHcechFRYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D42YUzZte7AxNrwFkcYMoKO/UgQPuK2ahlA9X05Ug5k=;
 b=lhL45nlxitWMxocHOZNPXspCBXCKugg1LCG9ivCsItrvHjFYO55752+l7rJVxn+CAvV/rxR+SgnJmDv1aPlrtHPmrG5VZ4MKa7uqdIiVi4oqWf3m89UpIJ7/XBxkG++oTqa0v2kHTJDLM+b0B53bLJ706bfKyNMMUJhuAjf5mb0UCsZEtcIDCaS4gxmmtoIH0w+EtDr0NS87weUMtbde1fqgYV7EzL3IXzC6561363cr+XZabBwIki2JVKRo3aiG4fooQelxyq9XI2oQ97YANyeiwWsLSvmmoiRrxSz20jeZGG262m0qQVQvwejz5MxoC/xZ/xK5WgBRSjXGvMtuTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D42YUzZte7AxNrwFkcYMoKO/UgQPuK2ahlA9X05Ug5k=;
 b=EHZm0tJ3AdC19FEHRX7eVRHyc9Bx43IxmNivu9eNjag1YnOO0vHSEF2hLfEXcjf+EBmXB8d+dH+BKlIwfq2UMmKW8QCBBuaHgexsF1Hynu6GR8iTJL3O4jEr1gvKaXTOsa0p1DoMQXHL4Yf90I3RzVoeBLVxfHaoxQccrqLru3I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by LV8PR12MB9642.namprd12.prod.outlook.com (2603:10b6:408:295::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Tue, 3 Jun
 2025 05:26:38 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8769.031; Tue, 3 Jun 2025
 05:26:38 +0000
Message-ID: <d0d1bed2-c1ee-4ae7-afaf-fbd07975f52c@amd.com>
Date: Tue, 3 Jun 2025 07:26:33 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
 <4105d9ad-176e-423a-9b4f-8308205fe204@amd.com>
 <9a9bb6bb-f8c0-4849-afb0-7cf5a409dab0@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <9a9bb6bb-f8c0-4849-afb0-7cf5a409dab0@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR0P278CA0141.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::20) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|LV8PR12MB9642:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bbc8031-2f4a-41e2-a3d3-08dda25f3684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlRtekxCZGJQOWFubkZsTkNVREJGS05DVWNUUTFlNlQ5T0s4MU54QlNFV2ll?=
 =?utf-8?B?ZzVaRlVjRXJwV2l4MVg4ZG5YVUlVUkpwZkRmNTViR3JTT0FxWU1CN2x4RWs4?=
 =?utf-8?B?bDd3MG5kamVTdnR5UkZGOXQxbnFYb2lsTFI0MDJjd2VkNnFaMEhhc2RMdUg2?=
 =?utf-8?B?N0hFZnRLSk9ySUZRbnhTdXJxWFpvcWV1aUZuOFBvME1waDdFM3VnQTJqUFY2?=
 =?utf-8?B?QWluOXV1WmlkRlQ3bFAzend0Y05kbnR5emlLVXh0a2x4ajVQaldoSkorR09h?=
 =?utf-8?B?dGtoN0V3cTE5bE9WRWk5bE1JT21TZm1SQkNaU0dSTDBSbDBkKzdrQ3ZXSHpp?=
 =?utf-8?B?VTE2d1pRVkVOY3VRcE8yOThBcHhQYTRJVnRwNit4ZllSRjVBTmNZZC9sVG9Y?=
 =?utf-8?B?QXJpbERiNHlzZ1NLL2FGY25tTlZ3NWhTUzc4SHNEc093cjR2UUcrVEZqVTRs?=
 =?utf-8?B?bGxRWVhxdTdTeGlNZG9wWVd2ZDdoNU9qb1U3QWhFQjV2bUV3dWs2aHlKM0R1?=
 =?utf-8?B?TU1lSFUzRkhyeEZvSDRyQVZ4NEZLU3c4c2ZPdGwxV2tpZ1NBQlplZnd6eGs3?=
 =?utf-8?B?ZkhaMjRhaU9IRGo1bmJpK2NUaElSaFY5bWthQnZNdW9DMk5OdVRpdVB6N2M1?=
 =?utf-8?B?UWM0N2tJcENBYi9jWFVFd2NKWDJJMVV0OTFiSjRmdnlGQmNRZjVpWmtrWWtR?=
 =?utf-8?B?UmlxUXVWaE9xZXVLMGR6ZEk4aHRyTmt3ZE9leno5eVNKN3JYbmRSY29vSHFF?=
 =?utf-8?B?dE8vRXBqZ3pkeVZlbUVNSFA0a1hMUUZLcWJDZDl0U0w1M1ptakczRkI3cWxh?=
 =?utf-8?B?TEZLZDZ4L1JYV3FOeWdOSXBlTjVKY2Jhd2UvK2lTSUJPU2VTQXR0RXRsZ2Jn?=
 =?utf-8?B?T2Fzd2NuVUpDRmtLdUVYUEVOOTJNT1RaVklwSHRaQmw4ZVRHNVRxM1Via1Jw?=
 =?utf-8?B?TkgyS09hVmVnQm9COFcwMEhzNGJKc1dPZmZLRlBNYjgyRzlWWTg4RXA5TC9P?=
 =?utf-8?B?YjJCcGpPMmRKaUlOL1BzWlVIMmhRb2NSVlpWeVJDSkRZM1BmY0N0ZndnT01I?=
 =?utf-8?B?dk8xOE1rZkRRWnJEYkRvQXdVOElNekhTNXk0OFhpVkI4a3cvaGpwU2Ixaktm?=
 =?utf-8?B?cXEvb3ZJdnJ5bWZUNEg2S3FuY0x6VG5PRVY5aytHcXRmVnNUMVVVbzI4V3N2?=
 =?utf-8?B?aXJWclkrSDBNUE4yQkJKelhqSlFpenVZUDZPR0IxZ1FhUHk2QTR6dkJaT1lF?=
 =?utf-8?B?NnhiNDgycWtVWVBrT0gvNWNRczVEWWlZRjBaNzJVYzdlUlhFZzFwbVNmNy80?=
 =?utf-8?B?azd4SEorTCs3K1NyZTI3QkR3N1RVeklEb2NGYkVqclRWRWlXaXdvUitmcnZO?=
 =?utf-8?B?TnRsRWVvcXJacFFLK0FobTBkRzhIK0g3eU9jMXZIcWRrVDNVaDdCR0t2S2Vy?=
 =?utf-8?B?cnFkR3ZlbFNWOXFiU09zd2NkTkVxcWl3WDZYdjFneUhYN1N0V004K3BILzVY?=
 =?utf-8?B?anJJZmVpMVlOMzR0b1h2ZjZjbVVQemxyVlowWUptc2ZjTTB3SEl5K2U0b2NM?=
 =?utf-8?B?OFJhSmZ2UXJNUWVSWEVlSStpVFR0SGNZL0l2SUtsc1RPNTUrZ1BuNUUyOEhx?=
 =?utf-8?B?MlZQMml5YjJDTERaT2VKb0NLYjRNOW0xVERLMUl1TzlpWjFJOWF3NTFlTmty?=
 =?utf-8?B?Q002RXdDbDhqdVFOWUdUT3BDdEwvZDJpMWU5WVRsU3Z6ZGtXU05qOEYyaHBO?=
 =?utf-8?B?NUxHQm9uOWpZTkppTG52eC9IQTZFSFdONUozVGRlbVR6dW5hMUhNWUVyVDhP?=
 =?utf-8?B?VUVTbjM4TkwzQmt3RVB4aVovZWE4enFiK3NrZFZPblJubmR6VjVTWDI3N3c4?=
 =?utf-8?B?dFZtdU1kZE85MkNoSS9mSjJHeVdSN0d6NWpsMFQ4b05oTjk0dDBnN2d4TDJi?=
 =?utf-8?Q?NcFD6yI3fpE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWg4M09MTklsZEw4VmRXYXNtR1VXT1o2MlNITDNIZCtPclY3Tmp5eXRRcHl3?=
 =?utf-8?B?d25mZ09RVCtMdW03eE1uV0EvSHc0NTlwdUtxdHVMOFkrT0cvUkM3SkEwR3NK?=
 =?utf-8?B?YkprMWlSc1pUTzhaQm9SOHVhTVlnbHJnak5BbWRQTEJteG1Fd2p5a1Rxb2J4?=
 =?utf-8?B?WVBUUVhaaGlTQUhPdE1JdWJIQ2U0SE1nalhaalRQSE15Y3Y0TnJhdnFIcGV0?=
 =?utf-8?B?eDlNTDFJNHNRK1crczNkWUhzcTVjckxDNzFtblBRaXRkaVNMRTlIMi82bTBS?=
 =?utf-8?B?RUlrVVhud05Jdk8xRUdERUJ6Ti94UFNhaXhiM3FDa1lab1I5cC9FeTNxV1NI?=
 =?utf-8?B?WmF5akZRSVFGU2JIMlZKZnhwNTNYc2xqWGY2cmJvOG9xRTlLcmtZWHVXcmNX?=
 =?utf-8?B?WGthMW9zWHRaQys3ZzJEWjJrbU9QQ2JrMDFaNnlZaHRlKzBjSGgrRzVrK1Ru?=
 =?utf-8?B?OVdGampCQjlQMVJYVHlEWjN4alUxUEJ3RlVyZnhmY1JzcjlITjRUVHZaQ1pJ?=
 =?utf-8?B?eDhXN2tqaXVKSUx0QzZlUThRMDlaOU5PblpibnJLenV6UXpmT3RCZXRhOUw1?=
 =?utf-8?B?K28wRjR5aVI5Q01KRGNLdlNlN3JSRktQVjNqcVFhdWcvRjZWT2t4a2ovMHpU?=
 =?utf-8?B?WkNhTVR0YzFUaEt5OVJ5Ym5EeVFxSGx1eUNyV2ppNi9ubk5iemRXZDhWNDJl?=
 =?utf-8?B?Snc0Vmc4eTVxRW9XaGd3LzVRQlFBNmJTUGxJRktXdVFkZG1wMUFWU3ZoRzB2?=
 =?utf-8?B?djFxelEvb2Y2STFIZUNJbitsRUJDUDRVRlIrZFRKMHFkY21JRVpuYjRkL2tk?=
 =?utf-8?B?ZWplOTNIbXEwdjFoZk0rSThmK0FCTC9SS1lMSThYb20yVThsbk03M3UyS1lE?=
 =?utf-8?B?VDhkREc4YVlpek4yTVJqdFJVNUljWW5sc3g1TDRnZWh1SjB6TEcvcmo3K0pj?=
 =?utf-8?B?K3JNRlBPc3Y4eFpjODlUMGxPZWxHUFpxdVRwTEpWYWdqZGNTUkRCNnBoWFdO?=
 =?utf-8?B?RkhBTnhWaDl4Rk0vamhGQWMwRzVUbkExWEp1YjBlMkNwcjBIMG52aXJ5dWhT?=
 =?utf-8?B?Y0dzRm41Y3RSWGJDUzg0OTNvc2pqc0llaW83akltOHFtcis1SUN6RmZ4WkF6?=
 =?utf-8?B?cjlDV3RwVkEyNG0zZkNFTkM1Zm9TWmRpcjR0alJMeU1ndGcrSjdVUWZiWWQy?=
 =?utf-8?B?QmRhVXpCR2FrL2FWWmlPUXgwOFZMQmZkS1BXZE5QbHpoTHd4bCtJWC9oZnFh?=
 =?utf-8?B?c1V3c1RiUEdnZko1YzlseThEZnU2LyswcTFiVEJ2dHVoZEp1aEpxZlZRRld2?=
 =?utf-8?B?WE83YmxqTlZ6eUQzUXpxYXFHTC9qc0hqWGQ2QlZTVG4zSUVaMm9yalNOc21u?=
 =?utf-8?B?MXZQRmJFZ0cyY1NMNG4rZFI5RHg3N3dnQ1FhUXJDVVNBcHViclQyTlNYT216?=
 =?utf-8?B?L2JPMjFVRVRRYWEwaHVaQWZmVGRHT1dyMi8wSWswZ05kNlVFcWJXRWwzMFc3?=
 =?utf-8?B?bzZud0N4VW1SeEVyenpIYVpNUG5VTlRlaEVqV0g1NjdueFUzUUJ1ZkhrajZU?=
 =?utf-8?B?UXRrdFBSYkxVT3VsT3NlejFDUFArYm1xazUwZXQxZEZoNVJRZXhYT0trQ0ts?=
 =?utf-8?B?b0tCMlZ0NUJMTXhCNWZnKzVhM2YwVk9kMGFqM3NJQkV1SFFuU1dZdGhRbld3?=
 =?utf-8?B?UnB0aVdWd0R0RkJ5WUJCQjVyeG5nNktCL0pjcnl1dm9sRXRJbk5KUHFseDZS?=
 =?utf-8?B?N3FKK1RWSW94K0hWVGN6WlVjMzk5Um1JU0lkQmUweDZDWHF6UzZiQ3NiMzFq?=
 =?utf-8?B?K3hMbWFnQUJsc0JNT3E5TjcwRXAxTmw3b3YyQW1jaVFIaDkvV05DWHdsZy83?=
 =?utf-8?B?K3cwS3NXQ3NURnlBNUhRS1NVa1gzUmlJUzBKdGtWczVneURGOTJ2WTVrSjg1?=
 =?utf-8?B?VkV1NGU1bHRPQUdVd0pDK2RnNElhL1dpWWwyS2hqOXVYTVp6QzhmeEVsVGdX?=
 =?utf-8?B?UldvM0toWEVXb2d3aEpNOXVEd2lmSURnNGJnai9QSjgyZnp6WU1qT3BQY1Ji?=
 =?utf-8?B?d1dTbi9VV2dEWnM2cjhkSUtQcUd3dlRXbWhDaDhkVHArejk2eERUTGJPNDhx?=
 =?utf-8?Q?ucs1dD9rfrUwCiHCXzuN0b6vf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbc8031-2f4a-41e2-a3d3-08dda25f3684
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 05:26:38.1267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FlNp8n+AI5UR90SknRqlNWIqinRobe+bjr5EpHpeMdqM10IKtOoK1ZCjeSMeIeiHaO2FiQX5pCo2OOhHcoxZIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9642

On 6/3/2025 3:26 AM, Chenyi Qiang wrote:
> 
> 
> On 6/1/2025 5:58 PM, Gupta, Pankaj wrote:
>> On 5/30/2025 10:32 AM, Chenyi Qiang wrote:
>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>> discard") highlighted that subsystems like VFIO may disable RAM block
>>> discard. However, guest_memfd relies on discard operations for page
>>> conversion between private and shared memory, potentially leading to
>>> the stale IOMMU mapping issue when assigning hardware devices to
>>> confidential VMs via shared memory. To address this and allow shared
>>> device assignement, it is crucial to ensure the VFIO system refreshes
>>> its IOMMU mappings.
>>>
>>> RamDiscardManager is an existing interface (used by virtio-mem) to
>>> adjust VFIO mappings in relation to VM page assignment. Effectively page
>>> conversion is similar to hot-removing a page in one mode and adding it
>>> back in the other. Therefore, similar actions are required for page
>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>> facilitate this process.
>>>
>>> Since guest_memfd is not an object, it cannot directly implement the
>>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>>> have a memory backend while others do not. Notably, virtual BIOS
>>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>>> backend.
>>>
>>> To manage RAMBlocks with guest_memfd, define a new object named
>>> RamBlockAttributes to implement the RamDiscardManager interface. This
>>> object can store the guest_memfd information such as bitmap for shared
>>> memory and the registered listeners for event notification. In the
>>> context of RamDiscardManager, shared state is analogous to populated, and
>>> private state is signified as discarded. To notify the conversion events,
>>> a new state_change() helper is exported for the users to notify the
>>> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
>>> shared mapping.
>>>
>>> Note that the memory state is tracked at the host page size granularity,
>>> as the minimum conversion size can be one page per request and VFIO
>>> expects the DMA mapping for a specific iova to be mapped and unmapped
>>> with the same granularity. Confidential VMs may perform partial
>>> conversions, such as conversions on small regions within larger ones.
>>> To prevent such invalid cases and until DMA mapping cut operation
>>> support is available, all operations are performed with 4K granularity.
>>>
>>> In addition, memory conversion failures cause QEMU to quit instead of
>>> resuming the guest or retrying the operation at present. It would be
>>> future work to add more error handling or rollback mechanisms once
>>> conversion failures are allowed. For example, in-place conversion of
>>> guest_memfd could retry the unmap operation during the conversion from
>>> shared to private. For now, keep the complex error handling out of the
>>> picture as it is not required.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>> Changes in v6:
>>>       - Change the object type name from RamBlockAttribute to
>>>         RamBlockAttributes. (David)
>>>       - Save the associated RAMBlock instead MemoryRegion in
>>>         RamBlockAttributes. (David)
>>>       - Squash the state_change() helper introduction in this commit as
>>>         well as the mixture conversion case handling. (David)
>>>       - Change the block_size type from int to size_t and some cleanup in
>>>         validation check. (Alexey)
>>>       - Add a tracepoint to track the state changes. (Alexey)
>>>
>>> Changes in v5:
>>>       - Revert to use RamDiscardManager interface instead of introducing
>>>         new hierarchy of class to manage private/shared state, and keep
>>>         using the new name of RamBlockAttribute compared with the
>>>         MemoryAttributeManager in v3.
>>>       - Use *simple* version of object_define and object_declare since the
>>>         state_change() function is changed as an exported function instead
>>>         of a virtual function in later patch.
>>>       - Move the introduction of RamBlockAttribute field to this patch and
>>>         rename it to ram_shared. (Alexey)
>>>       - call the exit() when register/unregister failed. (Zhao)
>>>       - Add the ram-block-attribute.c to Memory API related part in
>>>         MAINTAINERS.
>>>
>>> Changes in v4:
>>>       - Change the name from memory-attribute-manager to
>>>         ram-block-attribute.
>>>       - Implement the newly-introduced PrivateSharedManager instead of
>>>         RamDiscardManager and change related commit message.
>>>       - Define the new object in ramblock.h instead of adding a new file.
>>> ---
>>>    MAINTAINERS                   |   1 +
>>>    include/system/ramblock.h     |  21 ++
>>>    system/meson.build            |   1 +
>>>    system/ram-block-attributes.c | 480 ++++++++++++++++++++++++++++++++++
>>>    system/trace-events           |   3 +
>>>    5 files changed, 506 insertions(+)
>>>    create mode 100644 system/ram-block-attributes.c
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 6dacd6d004..8ec39aa7f8 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>>    F: system/memory_mapping.c
>>>    F: system/physmem.c
>>>    F: system/memory-internal.h
>>> +F: system/ram-block-attributes.c
>>>    F: scripts/coccinelle/memory-region-housekeeping.cocci
>>>      Memory devices
>>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>>> index d8a116ba99..1bab9e2dac 100644
>>> --- a/include/system/ramblock.h
>>> +++ b/include/system/ramblock.h
>>> @@ -22,6 +22,10 @@
>>>    #include "exec/cpu-common.h"
>>>    #include "qemu/rcu.h"
>>>    #include "exec/ramlist.h"
>>> +#include "system/hostmem.h"
>>> +
>>> +#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
>>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
>>>      struct RAMBlock {
>>>        struct rcu_head rcu;
>>> @@ -91,4 +95,21 @@ struct RAMBlock {
>>>        ram_addr_t postcopy_length;
>>>    };
>>>    +struct RamBlockAttributes {
>>> +    Object parent;
>>> +
>>> +    RAMBlock *ram_block;
>>> +
>>> +    /* 1-setting of the bitmap represents ram is populated (shared) */
>>> +    unsigned bitmap_size;
>>> +    unsigned long *bitmap;
>>> +
>>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>>> +};
>>> +
>>> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
>>> +void ram_block_attributes_destroy(RamBlockAttributes *attr);
>>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>>> uint64_t offset,
>>> +                                      uint64_t size, bool to_discard);
>>> +
>>>    #endif
>>> diff --git a/system/meson.build b/system/meson.build
>>> index c2f0082766..2747dbde80 100644
>>> --- a/system/meson.build
>>> +++ b/system/meson.build
>>> @@ -17,6 +17,7 @@ libsystem_ss.add(files(
>>>      'dma-helpers.c',
>>>      'globals.c',
>>>      'ioport.c',
>>> +  'ram-block-attributes.c',
>>>      'memory_mapping.c',
>>>      'memory.c',
>>>      'physmem.c',
>>> diff --git a/system/ram-block-attributes.c b/system/ram-block-
>>> attributes.c
>>> new file mode 100644
>>> index 0000000000..514252413f
>>> --- /dev/null
>>> +++ b/system/ram-block-attributes.c
>>> @@ -0,0 +1,480 @@
>>> +/*
>>> + * QEMU ram block attributes
>>> + *
>>> + * Copyright Intel
>>> + *
>>> + * Author:
>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>> + *
>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>> later.
>>> + * See the COPYING file in the top-level directory
>>> + *
>>> + */
>>> +
>>> +#include "qemu/osdep.h"
>>> +#include "qemu/error-report.h"
>>> +#include "system/ramblock.h"
>>> +#include "trace.h"
>>> +
>>> +OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttributes,
>>> +                                          ram_block_attributes,
>>> +                                          RAM_BLOCK_ATTRIBUTES,
>>> +                                          OBJECT,
>>> +                                          { TYPE_RAM_DISCARD_MANAGER },
>>> +                                          { })
>>> +
>>> +static size_t
>>> +ram_block_attributes_get_block_size(const RamBlockAttributes *attr)
>>> +{
>>> +    /*
>>> +     * Because page conversion could be manipulated in the size of at
>>> least 4K
>>> +     * or 4K aligned, Use the host page size as the granularity to
>>> track the
>>> +     * memory attribute.
>>> +     */
>>> +    g_assert(attr && attr->ram_block);
>>> +    g_assert(attr->ram_block->page_size == qemu_real_host_page_size());
>>> +    return attr->ram_block->page_size;
>>> +}
>>> +
>>> +
>>> +static bool
>>> +ram_block_attributes_rdm_is_populated(const RamDiscardManager *rdm,
>>> +                                      const MemoryRegionSection
>>> *section)
>>> +{
>>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>>> +    const uint64_t first_bit = section->offset_within_region /
>>> block_size;
>>> +    const uint64_t last_bit = first_bit + int128_get64(section-
>>>> size) / block_size - 1;
>>> +    unsigned long first_discarded_bit;
>>> +
>>> +    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>>> +                                           first_bit);
>>> +    return first_discarded_bit > last_bit;
>>> +}
>>> +
>>> +typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
>>> +                                               void *arg);
>>> +
>>> +static int
>>> +ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
>>> +                                        void *arg)
>>> +{
>>> +    RamDiscardListener *rdl = arg;
>>> +
>>> +    return rdl->notify_populate(rdl, section);
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_notify_discard_cb(MemoryRegionSection *section,
>>> +                                       void *arg)
>>> +{
>>> +    RamDiscardListener *rdl = arg;
>>> +
>>> +    rdl->notify_discard(rdl, section);
>>> +    return 0;
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_for_each_populated_section(const
>>> RamBlockAttributes *attr,
>>> +                                                MemoryRegionSection
>>> *section,
>>> +                                                void *arg,
>>> +
>>> ram_block_attributes_section_cb cb)
>>> +{
>>> +    unsigned long first_bit, last_bit;
>>> +    uint64_t offset, size;
>>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>>> +    int ret = 0;
>>> +
>>> +    first_bit = section->offset_within_region / block_size;
>>> +    first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>>> +                              first_bit);
>>> +
>>> +    while (first_bit < attr->bitmap_size) {
>>> +        MemoryRegionSection tmp = *section;
>>> +
>>> +        offset = first_bit * block_size;
>>> +        last_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>>> +                                      first_bit + 1) - 1;
>>> +        size = (last_bit - first_bit + 1) * block_size;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            break;
>>> +        }
>>> +
>>> +        ret = cb(&tmp, arg);
>>> +        if (ret) {
>>> +            error_report("%s: Failed to notify RAM discard listener:
>>> %s",
>>> +                         __func__, strerror(-ret));
>>> +            break;
>>> +        }
>>> +
>>> +        first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>>> +                                  last_bit + 2);
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_for_each_discarded_section(const
>>> RamBlockAttributes *attr,
>>> +                                                MemoryRegionSection
>>> *section,
>>> +                                                void *arg,
>>> +
>>> ram_block_attributes_section_cb cb)
>>> +{
>>> +    unsigned long first_bit, last_bit;
>>> +    uint64_t offset, size;
>>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>>> +    int ret = 0;
>>> +
>>> +    first_bit = section->offset_within_region / block_size;
>>> +    first_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>>> +                                   first_bit);
>>> +
>>> +    while (first_bit < attr->bitmap_size) {
>>> +        MemoryRegionSection tmp = *section;
>>> +
>>> +        offset = first_bit * block_size;
>>> +        last_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>>> +                                 first_bit + 1) - 1;
>>> +        size = (last_bit - first_bit + 1) * block_size;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            break;
>>> +        }
>>> +
>>> +        ret = cb(&tmp, arg);
>>> +        if (ret) {
>>> +            error_report("%s: Failed to notify RAM discard listener:
>>> %s",
>>> +                         __func__, strerror(-ret));
>>> +            break;
>>> +        }
>>> +
>>> +        first_bit = find_next_zero_bit(attr->bitmap,
>>> +                                       attr->bitmap_size,
>>> +                                       last_bit + 2);
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static uint64_t
>>> +ram_block_attributes_rdm_get_min_granularity(const RamDiscardManager
>>> *rdm,
>>> +                                             const MemoryRegion *mr)
>>> +{
>>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +
>>> +    g_assert(mr == attr->ram_block->mr);
>>> +    return ram_block_attributes_get_block_size(attr);
>>> +}
>>> +
>>> +static void
>>> +ram_block_attributes_rdm_register_listener(RamDiscardManager *rdm,
>>> +                                           RamDiscardListener *rdl,
>>> +                                           MemoryRegionSection *section)
>>> +{
>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    int ret;
>>> +
>>> +    g_assert(section->mr == attr->ram_block->mr);
>>> +    rdl->section = memory_region_section_new_copy(section);
>>> +
>>> +    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
>>> +
>>> +    ret = ram_block_attributes_for_each_populated_section(attr,
>>> section, rdl,
>>> +
>>> ram_block_attributes_notify_populate_cb);
>>> +    if (ret) {
>>> +        error_report("%s: Failed to register RAM discard listener: %s",
>>> +                     __func__, strerror(-ret));
>>> +        exit(1);
>>> +    }
>>> +}
>>> +
>>> +static void
>>> +ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
>>> +                                             RamDiscardListener *rdl)
>>> +{
>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    int ret;
>>> +
>>> +    g_assert(rdl->section);
>>> +    g_assert(rdl->section->mr == attr->ram_block->mr);
>>> +
>>> +    if (rdl->double_discard_supported) {
>>> +        rdl->notify_discard(rdl, rdl->section);
>>> +    } else {
>>> +        ret = ram_block_attributes_for_each_populated_section(attr,
>>> +                rdl->section, rdl,
>>> ram_block_attributes_notify_discard_cb);
>>> +        if (ret) {
>>> +            error_report("%s: Failed to unregister RAM discard
>>> listener: %s",
>>> +                         __func__, strerror(-ret));
>>> +            exit(1);
>>> +        }
>>> +    }
>>> +
>>> +    memory_region_section_free_copy(rdl->section);
>>> +    rdl->section = NULL;
>>> +    QLIST_REMOVE(rdl, next);
>>> +}
>>> +
>>> +typedef struct RamBlockAttributesReplayData {
>>> +    ReplayRamDiscardState fn;
>>> +    void *opaque;
>>> +} RamBlockAttributesReplayData;
>>> +
>>> +static int ram_block_attributes_rdm_replay_cb(MemoryRegionSection
>>> *section,
>>> +                                              void *arg)
>>> +{
>>> +    RamBlockAttributesReplayData *data = arg;
>>> +
>>> +    return data->fn(section, data->opaque);
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_rdm_replay_populated(const RamDiscardManager *rdm,
>>> +                                          MemoryRegionSection *section,
>>> +                                          ReplayRamDiscardState
>>> replay_fn,
>>> +                                          void *opaque)
>>> +{
>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque =
>>> opaque };
>>> +
>>> +    g_assert(section->mr == attr->ram_block->mr);
>>> +    return ram_block_attributes_for_each_populated_section(attr,
>>> section, &data,
>>> +
>>> ram_block_attributes_rdm_replay_cb);
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_rdm_replay_discarded(const RamDiscardManager *rdm,
>>> +                                          MemoryRegionSection *section,
>>> +                                          ReplayRamDiscardState
>>> replay_fn,
>>> +                                          void *opaque)
>>> +{
>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque =
>>> opaque };
>>> +
>>> +    g_assert(section->mr == attr->ram_block->mr);
>>> +    return ram_block_attributes_for_each_discarded_section(attr,
>>> section, &data,
>>> +
>>> ram_block_attributes_rdm_replay_cb);
>>> +}
>>> +
>>> +static bool
>>> +ram_block_attributes_is_valid_range(RamBlockAttributes *attr,
>>> uint64_t offset,
>>> +                                    uint64_t size)
>>> +{
>>> +    MemoryRegion *mr = attr->ram_block->mr;
>>> +
>>> +    g_assert(mr);
>>> +
>>> +    uint64_t region_size = memory_region_size(mr);
>>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>>> +
>>> +    if (!QEMU_IS_ALIGNED(offset, block_size) ||
>>> +        !QEMU_IS_ALIGNED(size, block_size)) {
>>> +        return false;
>>> +    }
>>> +    if (offset + size <= offset) {
>>> +        return false;
>>> +    }
>>> +    if (offset + size > region_size) {
>>> +        return false;
>>> +    }
>>> +    return true;
>>> +}
>>> +
>>> +static void ram_block_attributes_notify_discard(RamBlockAttributes
>>> *attr,
>>> +                                                uint64_t offset,
>>> +                                                uint64_t size)
>>> +{
>>> +    RamDiscardListener *rdl;
>>> +
>>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>>> +        MemoryRegionSection tmp = *rdl->section;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            continue;
>>> +        }
>>> +        rdl->notify_discard(rdl, &tmp);
>>> +    }
>>> +}
>>> +
>>> +static int
>>> +ram_block_attributes_notify_populate(RamBlockAttributes *attr,
>>> +                                     uint64_t offset, uint64_t size)
>>> +{
>>> +    RamDiscardListener *rdl;
>>> +    int ret = 0;
>>> +
>>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>>> +        MemoryRegionSection tmp = *rdl->section;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            continue;
>>> +        }
>>> +        ret = rdl->notify_populate(rdl, &tmp);
>>> +        if (ret) {
>>> +            break;
>>> +        }
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static bool
>>> ram_block_attributes_is_range_populated(RamBlockAttributes *attr,
>>> +                                                    uint64_t offset,
>>> +                                                    uint64_t size)
>>> +{
>>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>>> +    const unsigned long first_bit = offset / block_size;
>>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>>> +    unsigned long found_bit;
>>> +
>>> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>>> +                                   first_bit);
>>> +    return found_bit > last_bit;
>>> +}
>>> +
>>> +static bool
>>> +ram_block_attributes_is_range_discarded(RamBlockAttributes *attr,
>>> +                                        uint64_t offset, uint64_t size)
>>> +{
>>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>>> +    const unsigned long first_bit = offset / block_size;
>>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>>> +    unsigned long found_bit;
>>> +
>>> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
>>> +    return found_bit > last_bit;
>>> +}
>>> +
>>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>>> +                                      uint64_t offset, uint64_t size,
>>> +                                      bool to_discard)
>>> +{
>>> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
>>> +    const unsigned long first_bit = offset / block_size;
>>> +    const unsigned long nbits = size / block_size;
>>> +    bool is_range_discarded, is_range_populated;
>>> +    const uint64_t end = offset + size;
>>> +    unsigned long bit;
>>> +    uint64_t cur;
>>> +    int ret = 0;
>>> +
>>> +    if (!ram_block_attributes_is_valid_range(attr, offset, size)) {
>>> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
>>> +                     __func__, offset, size);
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    is_range_discarded =
>>> ram_block_attributes_is_range_discarded(attr, offset,
>>> +                                                                 size);
>>> +    is_range_populated =
>>> ram_block_attributes_is_range_populated(attr, offset,
>>> +                                                                 size);
>>> +
>>> +    trace_ram_block_attributes_state_change(offset, size,
>>> +                                            is_range_discarded ?
>>> "discarded" :
>>> +                                            is_range_populated ?
>>> "populated" :
>>> +                                            "mixture",
>>> +                                            to_discard ? "discarded" :
>>> +                                            "populated");
>>> +    if (to_discard) {
>>> +        if (is_range_discarded) {
>>> +            /* Already private */
>>> +        } else if (is_range_populated) {
>>> +            /* Completely shared */
>>> +            bitmap_clear(attr->bitmap, first_bit, nbits);
>>> +            ram_block_attributes_notify_discard(attr, offset, size);
>>
>> In this patch series we are only maintaining the bitmap for Ram discard/
>> populate state not for regular guest_memfd private/shared?
> 
> As mentioned in changelog, "In the context of RamDiscardManager, shared
> state is analogous to populated, and private state is signified as
> discarded." To keep consistent with RamDiscardManager, I used the ram
> "populated/discareded" in variable and function names.
> 
> Of course, we can use private/shared if we rename the RamDiscardManager
> to something like RamStateManager. But I haven't done it in this series.
> Because I think we can also view the bitmap as the state of shared
> memory (shared discard/shared populate) at present. The VFIO user only
> manipulate the dma map/unmap of shared mapping. (We need to consider how
> to extend the RDM framwork to manage the shared/private/discard states
> in the future when need to distinguish private and discard states.)

As function name 'ram_block_attributes_state_change' is generic. Maybe 
for now metadata update for only two states (shared/private) is enough 
as it also aligns with discard vs populate states?

As we would also need the shared vs private state metadata for other 
COCO operations e.g live migration, so wondering having this metadata 
already there would be helpful. This also will keep the legacy interface 
(prior to in-place conversion) consistent (As memory-attributes handling 
is generic operation anyway).

I saw you had it in previous versions(v3) but removed later?

https://lore.kernel.org/qemu-devel/20250310081837.13123-6-chenyi.qiang@intel.com/ 


Best regards,
Pankaj



