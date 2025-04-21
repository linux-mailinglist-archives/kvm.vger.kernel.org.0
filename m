Return-Path: <kvm+bounces-43725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8056FA95672
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 21:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48CE11895BC1
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 19:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B382C1EB198;
	Mon, 21 Apr 2025 19:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hwORZaO5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2072.outbound.protection.outlook.com [40.107.243.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1E01E9B14;
	Mon, 21 Apr 2025 19:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745262253; cv=fail; b=cNTSx59cC7ScdRrwWxjTZGIxpfMQMm4KBNU+RbLZ79ueThA3ES0FI8fXtE96C+g4YcvyTs1pENez9OosIJGBBiJ9G3VbqROYhKlkRhs+SZY/mdZ8VnSjoTd/mMNL0ZddeM9qucihNTlrou/Z375Uv0v/KEAgSZZ0bKAvUm04mxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745262253; c=relaxed/simple;
	bh=e0Rg9MFv9MCZ8B9epmQapMUG9iSoRekcpiBuew8y1RE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C1EJMSWEnqUsOk1M9TjpVnHVIOgP5mTb343aev8OLGTt+dH6B9JtJjnXA/IRHkqSWyPFC4ymgMb6CgA3a+ALLwyOTecCrHZCQU5flezC8g8Q/4cr1Txu4GXZShDVU28adG1HKQ+VBHwv5rNXqfEU0rEU8DzxiZAk5s3SjcSVN20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hwORZaO5; arc=fail smtp.client-ip=40.107.243.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JJijAwQGA6o+1IMGWLkSULTKmeroF5DWy5/RZwXZiHYybT0NOys3sj5vI3eqGaOnp3CkcYd0TD0Z9VBrc8JWQ9O/4aBXlZ3vwzutapeBcdbQLdLyfQfJXlt9MAy5rVzBrvxO7W4ogEUCmxz2upLoBVsG1156DZtndOtOfQPwCjWi26ebx74yad2CLNV36WY9u7W+qvY1kTqiADf1KPDDAu4uk1/ilX6ewGgwC7ByxvNQEQNmEnaLxWIj7zFPyRy0aUc07tbTeorjyP0thgRPZUsT01swfbsKhfhEv3e8d3kJLAEEdN3wT+4GGXs6lx4/hkH3qFMgLsAVqq//Mrobyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXU5bsrQ/T5NNl1NwobJgm0pnX/GaMP+MgOm9VOZtjk=;
 b=zI/2caadbdi82EU828pgEyu1DSxTgehFh3OTm0ToD7Gf5wIJ7b+2M1qqfX3kiidWPnM+Dew0Efe1lbVJXPsg8iRwxDOzkmfe5lweYb6xANAAitVSp/6ahMtuOYERMd82jUokFOnafJUEPVBDAnYMflcEKls6BMv7AzhcCqIDxoDVh8g1Ud60vyRI9EVmhVpsO7C1oX++8aPEL11zyV96WGRE9znkcbcW1UZ3CMVF9aHay2xbsOUnw8lnwznDgwqafDOCu2Edc/KQigJlaJCwUE9EM5NyQxv68oztTCCsETysa0wBB7/0P6YVtz6cu63Nnu5x+5Sl402MiehcwwXdQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXU5bsrQ/T5NNl1NwobJgm0pnX/GaMP+MgOm9VOZtjk=;
 b=hwORZaO5OnXW8il6qL6cyJH7xRCnf1ifaL96NoaG7+HCVC8iW/7lWSle0k/wEFJcAZQOJ54mdIaRWh0qng/Kfclu6Oqvr26UuLttvGbATIQV6CJV6PjjZhfmSwPUWwzgOfSuyoNWktqkvdHHRw2C/oYLmQU9Zhq8Z1MFQZ++rJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV3PR12MB9329.namprd12.prod.outlook.com (2603:10b6:408:21c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Mon, 21 Apr
 2025 19:04:07 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8655.033; Mon, 21 Apr 2025
 19:04:07 +0000
Message-ID: <b1e89e6d-fec5-d865-533d-04902137c082@amd.com>
Date: Mon, 21 Apr 2025 14:04:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 03/29] KVM: add plane info to structs
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: roy.hopkins@suse.com, seanjc@google.com, ashish.kalra@amd.com,
 michael.roth@amd.com, jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de,
 James.Bottomley@HansenPartnership.com
References: <20250401161106.790710-1-pbonzini@redhat.com>
 <20250401161106.790710-4-pbonzini@redhat.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250401161106.790710-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0075.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV3PR12MB9329:EE_
X-MS-Office365-Filtering-Correlation-Id: c7182a8b-76ec-497d-8b4e-08dd81074a4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NFNiaGlaL2hCdDhOck9Oci9hTVZDckNtb2tyakFqYk44ZEZtRFhhMDhzZ1RP?=
 =?utf-8?B?d3pNYnUrSDZWZkdPcVNLZk1qWG5IenZ3UHQzY2RUbytoQ2tiQ0N1TXhnbmx2?=
 =?utf-8?B?WmlBR0hwemgvQmJDbnZCWjlLNVl1VGg3MEwySk8zVGhROW55RGhmZ1FwaDNX?=
 =?utf-8?B?NW95dXpLVzNrSFEyUTkvcko4NFJHVWVRbWNNM3FSWEpoeWRJWVVpTlFEd0h3?=
 =?utf-8?B?WDB4WW1EVE1ZQjdSdk5YREJJMFdqN09hZjV2YUFWWFk1MnkwSWlncFI1eHJi?=
 =?utf-8?B?aEZ1QjZVUytTbFNsMXV2VmtjRHNvWVUxU3RpQ3VpMk1Ec2MyenNhKyt2NCtH?=
 =?utf-8?B?aE9FNUlxSkF4NjIwTURnMGlKcDByNnRXL05BRENMeTVmd2hjSnl1T0xwNTBn?=
 =?utf-8?B?bGFJTy84OGs0NHJLLy9jdDFoTFliclIxOEJaYTN4RklwNHBFcHdYSjdUWmpz?=
 =?utf-8?B?UlJQaXMvWmpObm1qYmFsVDlpZW01TWZlL1hCYzZ1N2tjQS91STY2MXVHakdT?=
 =?utf-8?B?Rk9jVlFGSjB2VTNvZE1RK0poN3NIZi91dC9PQ25OQ2VVU09hU3JUcTUxUisv?=
 =?utf-8?B?LzJNdFZHQ2NpeTFNTjBCQjJzenFxamFsWXJNVjV2VXJiVkRUejNxM3VXb094?=
 =?utf-8?B?UjJNV0NEbUFuU2N0Y0RpdGlLNEM5ZjNTcmxtV1NFdXBKbzJKMWxCcE5uU2JU?=
 =?utf-8?B?Z1o0aDNBY09VSUtYaTl4NEV0R3pTYXZFY0VqQWNBMWJDdGxuU2RCM0E1aHI5?=
 =?utf-8?B?V252azlQMytUZjJGSDU1aDJXcHhSR1BPY0xnYS9CcjNSNXZwMGtwL1FMclF6?=
 =?utf-8?B?R3RFdzBJKy80bFlnVzJOVlZ0aXdNbDlDU043ZkN0RzUrUFlOQlhwOExVSkZX?=
 =?utf-8?B?V0QvcVh3QmlvSnJRbU9heEp0czBkbzRrcUFGWE5DQUpGWGdpbnNQNUxZejgr?=
 =?utf-8?B?MXJ4ZktVRnZMb1NHdDdFcitZS0oxc0QvQVZZalp6aS9KeXRPcWZQUElsd0VX?=
 =?utf-8?B?S0VqQWZSb3FwU2NvR2k5L0ZLUURneWxoVVV6UjlXaHVVZkFURGw5dlIvWEVq?=
 =?utf-8?B?ZEFkYWZ1TVdYbUtYbFAyM2pWQjBVUTVsem5FZ2JHWW04Nmw4bFMvVm4xUWwr?=
 =?utf-8?B?Tm5vR3FxYnh6WXcxOUVwTVZ0bUtxT3Y4V0xqR3RPOFRkNkY5UkNNQzNXcWty?=
 =?utf-8?B?c3ovMUZ3bTdLL0lWMHJtcVlQcUhJWnNzWit5MTQyazdjc0YxRlYyRGlEYUlr?=
 =?utf-8?B?eW1Wbi9JeERETnpIbU85Ui9kTHRJS1NjZWpFL1FhcVFxVFQrUlcxb1J0OFUy?=
 =?utf-8?B?WlF3bjJjQ1piSzdqbVArbGhwSUFZclJubXIwYWs0U0dXNS9ETVdlZUdhaTNs?=
 =?utf-8?B?cldwbWRVWE43dE1oOE9MdVpBUkF5UVVKUVc1a2piMmhEZWlWai91RDBVb0FB?=
 =?utf-8?B?UDlBVkE2N1RGU09IanUrLy9wZzczTVUzUUVJZERZYVBjaTFRNmRPTWorTEpW?=
 =?utf-8?B?YnFJSVhGcjBpaHJ1RExIZS9JZkZoYzRSeUZPN1hSWXlPN1ExVTBHbUtyQ3Va?=
 =?utf-8?B?eW5vaGtFM2RZS2FqK0prYXBOM1Y5emxZQ0NzdDV0NEhlYnNYVGwyMFhyRnFO?=
 =?utf-8?B?NG1zd2h6Nno3ZlFKTFkxYk1EYnFMUmFYbW1rd25EaGpYSDRaaG1Ta0J6eFhp?=
 =?utf-8?B?NFM5MkwxandabkVRdDJwN09vNElSOVY2V3FDSmRHV05aVGhtS2Fua25USWFs?=
 =?utf-8?B?eVFSQ3lvVjZJbURsVzdhSjlPTVU1Z1hCT21SckZQZnBNN3VlZnZUQ29HbzJw?=
 =?utf-8?B?TytRTDkvY3lKVGwremQrMVo3VEZDdXRQbW85SXgzMW5HU3hLWkg5T1UxbndX?=
 =?utf-8?B?MlhYTW1pUVZjU2hXTlN4TnhJeThpOXRXZmtxVGt3M3pRd1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEVPNGJZTWhUQWNIUlV3NlRmTkdmQWlOLzNMdktlL3N3dTM3VWQrZlM2T0VM?=
 =?utf-8?B?VU9rN2NQU1VRUTY0RnhpU3dhQVlkczl2QUdGT2FCdHZXY2ptc2YwNjArVUxB?=
 =?utf-8?B?MWxFMDNuQndST2RHdWFkMHo1WVZha2toL0tQTEg5UER4ZmZ6NHpuTWFWc2hl?=
 =?utf-8?B?ekNvYzllMFBhQUJMMzYwSW0rMXdsSEtOYkFBb3ljQ2NBRDJzV2x4RUs3VFNu?=
 =?utf-8?B?TTU4SlQxVExYbm1IUUdiNzJ4aWtvbjlGL3RRQU1raWVwdTN6RnpyRk96NnBR?=
 =?utf-8?B?RlBYVlN6YktNaEJ3eU9ITlNFWUgrT3RDd2lwbTRYbldUeExwRENQSE1sa21i?=
 =?utf-8?B?RUZxbzl3clViZ3lzeFVzSnd0bCtGZG56RGc5aldkR1h4VTd3TnNGejhOSVZK?=
 =?utf-8?B?ZzVzUEk0Sy9IQTM1OTlra1ZqM2dFSTRSelJZSVY1WUJJbHl1cGxHYmxpaFNR?=
 =?utf-8?B?RzlwbktuRlNPdkR2MDJ2WkZNTHcyM2ZDVnBKdzhWMkRtWXJMWkVPNmxkVnpw?=
 =?utf-8?B?alAvcHNyNm9wR3RrQlQ5Ym1UTXZlZ1JGRXNGWGJBZGNPVWhNZWF3Ym5jQmNC?=
 =?utf-8?B?eVlMSG1xdnlyNHkzSEI2ZmVxZGtTVlRCeWRtVE9ZY29IM0F6RVp2S1k2VU9x?=
 =?utf-8?B?TUlnWWVOb0NxNlZzR2JXN2pJYnZoa2NHTXVzVVNXKzJnSmpEdldhQmM5OFBS?=
 =?utf-8?B?RThzRnVnQlNOK2xDanVMazVBd0RQNWJqV0Nwa05CRFMyZUVHcTFISnI5aVVR?=
 =?utf-8?B?SUNaazlkdzlqMmdGQlZlV2lLdFhJbU1zd2V6cHlGUkNPbGhGcHR6QlJHTGFW?=
 =?utf-8?B?TnNjeGFsdHdoZ1QzUWxPU3hsdUowM1grZTZEdFh5eWlhYUMwVG0vQUhxbklY?=
 =?utf-8?B?YzY3VVJCcS9wdEVIR2VkeGhBRkJ1bGFjUjlvaitWTUhpbkxqdU9oR21HdTgw?=
 =?utf-8?B?bFJBZk1WRWw4dWtRYzREaENqQzFFUTVtSFhXZjFZVXR5ODRiY0FsNWxDNHZE?=
 =?utf-8?B?L0xtNDYxSGNrb21FTU9KcGprRk91WEw0bGJIZmZSeEtTN2xVelR3K0pFVkJW?=
 =?utf-8?B?Y2hDZ0k4VVJ4OW51V2Ric2N5bjVpVmFrb3NZWnlBQUl0eVF1aWE5NXlqT3Zq?=
 =?utf-8?B?djIzVjlBN0VyVnllNEh1cWk4YVZoRnFENElXRk1VNUFFQVV0SHNJKzdHdU5F?=
 =?utf-8?B?aThCSy9DUDBFUkNjUmJBOEpMZVFTYnJha3ZjMmMxc0l1L3M5R05IdXVTL0lJ?=
 =?utf-8?B?eDl5ODF6V201Yk9peUM0OGw5bEdIQ0t4a050Y0xNdmQrdEoxWEhVZlNQTnRs?=
 =?utf-8?B?dTNIK0x4eVNuWGVQUWFVNzZkQWpHb1ZsSXJTYmJCM3QySWJOWG1WUnh3U0RY?=
 =?utf-8?B?REd2QnhkRDNOeURwUVdvZzRvQUNCcHM3RkNtVHlhcFBLZ2M1OGNNTldSUVFp?=
 =?utf-8?B?WG1IbDJDYzBKZG9uMXAyQS91U0JGUXVtU1hBV1NoczJ0RHV3OUpBZmlFWHFt?=
 =?utf-8?B?ajU0Y2VyK1Z3VFBNK0l2UGx6bCs4ZHdPN1RlTm40TmpZSDAyc3Rhc3RFRUpZ?=
 =?utf-8?B?QXk0djQrQ1pNYnZJcmJZYktxcWg2eGUzcXQzZWxjbTBWRkVVT2VKd3phMWEr?=
 =?utf-8?B?UXA5QXYyV2YzODRaUkpqeWY3VENhSDJ0aGFWbDdNSXJncGh4eFRJVjJYTkVt?=
 =?utf-8?B?bE5aZXBlUUxTdkt6djdSYVBDbWR1VDhiY2k0bkxiZG5rMjJIa09oMThNMS83?=
 =?utf-8?B?blZrcms3ZWQrQ0xwSDlKYU1ZVFQvYW82WFpiL1BWRThmcXJwU2F4UklSK1N4?=
 =?utf-8?B?WFlWa2RyNHppamZpSHVNVHcwS3o4a0N0YjFaeStaYnA2cy9vV2hlWjQyVVVX?=
 =?utf-8?B?UU1UdTFVcllNbm82NXBvY1lPaGtRbFRFNCtCUzNERXlQVHlGNVpISVQxdTdx?=
 =?utf-8?B?bGhTT3AxUWxmbWZhcDUzckJBdytZZDFaT3ZaUGg0WUNWZ3FhSDRJNmRYTTR0?=
 =?utf-8?B?TXZXTzh5SFh4MWt1Q2g1MEpKWkNQdllhcDRoTjlPUDYzSVlHUFVjL29HTWha?=
 =?utf-8?B?QnJLU25oVG5nZG0wR2s4ZEsrcTBVQlFXWEY3NWdiWXpueU5TcGI2bThROU00?=
 =?utf-8?Q?2a5BR39NUCoz3ZNqHLDcjARqd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7182a8b-76ec-497d-8b4e-08dd81074a4b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 19:04:06.9372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RRBCyCp2GLB5cgOTSQCou/dEHN/RxrHBvYeRvgfzEy24ARePl0lCX+DOwX7fPAwxE8kBOqkqvlvP9fwuCUAULA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9329

On 4/1/25 11:10, Paolo Bonzini wrote:
> Add some of the data to move from one plane to the other within a VM,
> typically from plane N to plane 0.
> 
> There is quite some difference here because while separate planes provide
> very little of the vm file descriptor functionality, they are almost fully
> functional vCPUs except that non-zero planes(*) can only be ran indirectly
> through the initial plane.
> 
> Therefore, vCPUs use struct kvm_vcpu for all planes, with just a couple
> fields that will be added later and will only be valid for plane 0.  At
> the VM level instead plane info is stored in a completely different struct.
> For now struct kvm_plane has no architecture-specific counterpart, but this
> may change in the future if needed.  It's possible for example that some MMU
> info becomes per-plane in order to support per-plane RWX permissions.
> 
> (*) I will restrain from calling them astral planes.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/kvm_host.h  | 17 ++++++++++++++++-
>  include/linux/kvm_types.h |  1 +
>  virt/kvm/kvm_main.c       | 32 ++++++++++++++++++++++++++++++++
>  3 files changed, 49 insertions(+), 1 deletion(-)
> 

> @@ -332,7 +336,8 @@ struct kvm_vcpu {
>  #ifdef CONFIG_PROVE_RCU
>  	int srcu_depth;
>  #endif
> -	int mode;
> +	short plane;
> +	short mode;
>  	u64 requests;
>  	unsigned long guest_debug;
>  

> @@ -753,6 +760,11 @@ struct kvm_memslots {
>  	int node_idx;
>  };
>  
> +struct kvm_plane {
> +	struct kvm *kvm;
> +	int plane;

Should there be consistency between the use of short in kvm_run vs int
in kvm_plane? And elsewhere in the series, unsigned int is used, also.

Thanks,
Tom

> +};
> +


