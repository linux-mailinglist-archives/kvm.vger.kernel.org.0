Return-Path: <kvm+bounces-34974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB05CA084F3
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 02:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4BE216894B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 01:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 416787D3F4;
	Fri, 10 Jan 2025 01:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gXEp1Kj5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E142C9D
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 01:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736473339; cv=fail; b=MOztS+YULMugcXL+bM8eY//JiR5jR486V5TuJ9PUyhRJpb7sUfTv7I3csNE8Lnmr6F0IE0CYRwZcD/HjBgih7E14clDgjqTCPmayxqQlpszAl2zU5J9Tlbkr6wpPboNoD2EOw+0qnLHRajPVV0ngEy0ev87KbLMcECUdsL7sgCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736473339; c=relaxed/simple;
	bh=2f9Znj+TAm75FmmQTHwSwYuEsuccsLKGvGXWZsHuBiU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dxlJPOOG66ScDdQ/att822G9nEOYZrvuk/9g80XzeMMNewbEfBvya95VE9vsyq4nPx7IlI+PZJnB+1D3lxGCq3bjSBAoGQHb+H83/6AbVnt0hFMA9l4zrHeHZQnAeNOpY0OoZZCJj4iGmYjfGRezVusFutjgECZk8aBnTIvtl1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gXEp1Kj5; arc=fail smtp.client-ip=40.107.220.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GCFFTOrRiTAYFXZJ/JoFdAedPLcSaF4wCsqU7BfSVwyubz3NRIBkwM7vIO//aGT1RV31G2AKo9CW0OYqt8bVvgmt5/T1OVF7/5eDvt2pc48SMAsMLn7rNXrXgigbfw0Nx1YDJaCWdbrAyXP09lgIBWsaaCb2zA0zHeJX/Y3mK+7A8JwdIAr9L+9XiFDvvO2bAMo28VZwUH/YKyJsrjLMH5Pyhk3OnVDGB9HXD4f5GqGPV8YatOxd2X+upMsMkmu4kzipdTIyls4SDFQ+Q2IQfi5p+kL6xg4bO7L6Bb2dvYiiC26G9RL0nK1h2QGN4BKWf93mJP6sNgSwP0lzdWGtlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HHKyNhhohKG56jsk1I1jX/0Pcy3q8F+HYBfd4fh9GSs=;
 b=pXkRp9CyhQC65s1sj1wzd2hryntMOLD/IvcQ/hBEhi2A2+4iC1U+WwuhcepIPfnAMGYa1CCVHlEEA7uXKWlu6EKa10eU46HUFL2bddNrEETT2ce2z/k574EnDricSsfDS7nI19gC70g5gZ/wTBwFEbhEGBMW4BQ2MuPt81Bde/PedV8Th1pn4otKYH0KzgA86ozrxe4b+HRuabO8LSWTio2eUdXxtlazw34FaQLsLQVLXrED0NUQtrhdIOiU3ply59ErrwlNa7BSPlp5o/zqepzi6Eu5QZu+RNUZST+EXUcswyDoDX9MnAXjIpYslgOtnZb81goo/kmGhPCKK4eCLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHKyNhhohKG56jsk1I1jX/0Pcy3q8F+HYBfd4fh9GSs=;
 b=gXEp1Kj5zoqTHngPabALNvcrtuF4ChJeUw/JaYoVdWQ9+a/1v0Fi4FcHsAHwgKkyuQJdLpSPIgtEhkthMmqdi89uABGN4jRz1cTb1ACIKJjIA1qICrw3THPQRW+kuGK5ZgvoXQhyqmid7dLGpFuPrZ05wiDLi8UPjjD8pXUAXxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB8015.namprd12.prod.outlook.com (2603:10b6:510:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 01:42:15 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 01:42:14 +0000
Message-ID: <008bfbf2-3ea4-4e6c-ad0d-91655cdfc4e8@amd.com>
Date: Fri, 10 Jan 2025 12:42:06 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 0/7] Enable shared device assignment
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
 <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
 <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
 <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
 <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
 <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: OS0PR01CA0155.jpnprd01.prod.outlook.com
 (2603:1096:604:27::30) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: fc5320e0-d289-460f-34bf-08dd31180286
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YndPd3hOdnA3SFY4QTJORzZ4dy8xRTZYOHQxT2YweGVsWkJ1eGlXQ0VjZm9M?=
 =?utf-8?B?cWlKME5GcEk5Qk53dkRTeU1uWnZYbSt6bWI1OTlrQ3MvU2E0QTlyT3d1TWJ3?=
 =?utf-8?B?YzBLRXBHaEtIYkU5eWZDVUY1RkdFNmpBV2lQaVQzdnZLWGRXYWcvMEcxYmhx?=
 =?utf-8?B?aTFibTdSTVpnRHZJTklob2J6ZzFEckx4V2MyTk8vZGZISndWa3hnODB6WSth?=
 =?utf-8?B?ZG9iSzBoMDlIeSsxZzEvbUE4WGJaM2FQSGViTVVYWHE3UXJyVjFhTklSbzM4?=
 =?utf-8?B?c091eHNIanQvSGxBUVc5a2Z2QWR5Njc3QytPTFMzQmdTY1IwMzNsRVU4YmF2?=
 =?utf-8?B?STR3RkpCL3A2L2lGS3RuWUdCaGU1ZXBUOHJBM3RHS3VpU2s1NzBtdm1OZDly?=
 =?utf-8?B?MUJuYVEwaVp2eGJHa0F5OVJMK1NUZHptbFhZOHMwcHU2SVlzQjhXbDQ5RWpx?=
 =?utf-8?B?WWZFVElObjBIU2E2bitsaWRvMGVqdWlSV3dYMDNCVk9qM1VUUVRxbnpoQjJ3?=
 =?utf-8?B?QXBSckV1RnBmd0JJZUVZWlluQ2ROL1NiZzhBU3ZxSGRxTTJHRjhtUlFVL0pS?=
 =?utf-8?B?VU42dWNNZ0J2VGtKMUtjWEhPeFppT0RqRUdFUmZUTm4yWUtWV0dEUk9oYkRn?=
 =?utf-8?B?SGV4KzBia0NpQWdFcEh1a09iSGRST2NHak5ab0xMTmJ1cm0xKy9hcEFnSlVl?=
 =?utf-8?B?NTVoNUVyemtHSUY4dWxBb21IVFJxa0lGSXZpM1pZMGtxZGd4RU83TmtFeTF2?=
 =?utf-8?B?N0w5V3BWV0U0QmYvM2t3VDhuc0ZlRkhQQ0lkcVVTQSsrS0hNZDF4WWI3Y0Nu?=
 =?utf-8?B?eHdmSndQbmEyRlE5bHdSaE5jODkxUzNJWEJKTEVHZHh3VWl6WkN3bkZSbFpG?=
 =?utf-8?B?LzBTRlhDOHZUL1dxWmIrUUNhd21QMjFPeUlKOTFHbTdQNDdwdjU0VTQva0U5?=
 =?utf-8?B?cUVEN1VVdHk4NFQvWlZna3pHb3J6WDEvTklQR2QvK0l3YnBkQjFYSW5SY25R?=
 =?utf-8?B?RTRxVGIxT3NYSmNacVllVXhKUDhKTmc5Vjk3a1p5VmpZZTQyQ2dTYnU4c2o2?=
 =?utf-8?B?NXlseS9TRGxPbTFpdWlRKzRKZmlqZjIvRGx3T1dIL3g0TTVUYTVaTUhIbXda?=
 =?utf-8?B?ZjBMNmJ0SFZHQ2hPTHBDRzVyWGIyTHdUU1FhYkdBMUVGTFA3SW1SV3F3VGla?=
 =?utf-8?B?RHduQitOZTZRM1AvcVJPRHNvclhaTTVpSnoyeWJQaVN4V0RZNlYwTWNRSzdy?=
 =?utf-8?B?T0ZVVTBDT2ZqNVpidGVvNklFeVJSZXRoZE44dER3aURhWGx0MWVpam11elA0?=
 =?utf-8?B?eDc1NDNWU3o0MHZGYS80OUVkVUJUdGgrKzJNQ3hWVzR3bmgrWjNNdFNPU1Bo?=
 =?utf-8?B?ZVY1UzRFUEF5Vlo2SVkybDNHY0hjRmtWWWNNQm4vWTNVU0FQR2x2eXhxTGNQ?=
 =?utf-8?B?SlIyMXFnQkg0NTc1T2VETFhXQXRJMmtrRDJxYXN2MzBVc2RjbGpHNDlCcHNp?=
 =?utf-8?B?Z0NiNVhMeGEwT0xEWGM5dlVQRDRkeEF3UzNnZHhHVExCR3MvcThrT3FXbEJK?=
 =?utf-8?B?NHV1QWNyYWdYTUtUWTR0NXRmc1U1R0RFbVFtNWx4S0VVZ041blFiQ3JKSVc5?=
 =?utf-8?B?OTUvUXVnOFZxVFR0TVRLbGhSQ2ZxZjEwaVdVakl3Njhna01OZHNhVUQrcDZj?=
 =?utf-8?B?aEZEUmVwTEN1OXZPOURob2s1Wk5pZm1oWHljd2xLaXk4MHZWQjNmOHVoMHNX?=
 =?utf-8?B?MDVxTEJESVVhNXJuc3ZQcUF4Q1FDT1JtYUFyMWl4aHFQY3hsaGx5N3RmbmNx?=
 =?utf-8?B?eDNVTktWNVV5dmZKM3g0QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUZodHZMM1d2cTBEMHBWTUg2dFJEYkdZUXJmRFNRcmdCb1AyWHpsM1d0c1Nx?=
 =?utf-8?B?VmZHZWpPckpyb0g2SWtKdVhaalZpU3FYUUF5eXZQTEtWQmJ5aUNNS0lwaHg4?=
 =?utf-8?B?cHlJOTQ5OEo0WStJeFNURE8zWjFHMWxwWXFzZ3BXK2pTdHR1UTIyeUFNRmI4?=
 =?utf-8?B?ZTl1RC94VVJHV201NGZqclNpRVdIYTd4SjIvSUhyc1M4VDlaTnJRR2ZVS1Bu?=
 =?utf-8?B?NHU0Ylc0WHJsaEVhczlrL0NTa25GazJwSWtOM01nb01UYTN5Q1hqZUVrQlRa?=
 =?utf-8?B?OHN4NVEwS3RDTU5OcHh0dGpTUDk2NzBlbHE4ZE1zaDgvRVBxZ3dkVEhkb0NE?=
 =?utf-8?B?Tm9VemNWcjhraks1NFVjOC9NWFk0a2I5NVovZHZ5aW1xenVGUG96amVQZkpM?=
 =?utf-8?B?ekZQaEorSzNKU21BK3B2Z29HSFRLMVhGcEpQc1JHeFZWUzRqYUQwOFdtRGNF?=
 =?utf-8?B?QWRaUjF5eGE2ZDlEU29EMW5sRzZGMVd5M0VWdzlpK1ZSRUd2V1dGYXRYTDJz?=
 =?utf-8?B?eVp5V21RVkpPZjRyYjdORHFjUW8zYVptc1BtYkFScWNXYjc5dEMvelJmZkx0?=
 =?utf-8?B?bUNaVEJScE9NZ2VkWjZDc0ZLUmRDQjkrdk1id0Z4RllWZi9POUFUMGo0dnhZ?=
 =?utf-8?B?WXJRMjNDQlN3YjJ4SnAzRDE2OFVBYnFCTmRsZ3g2NVE3MkdkOWw2cGlxR3ow?=
 =?utf-8?B?dCtXVGVzZGNIcWgxZVlUYngyNzdDZjBkempyemRPSk4rWHhBQ3g1emNxbllt?=
 =?utf-8?B?ZTlCRnljNzBnYnExM1IxekVUNnRQT2hwNy9USXR6VDNlRFZuMWFvR0pLQzds?=
 =?utf-8?B?OTQ4VE8xcWJ4TnNVM21obXAvdFMrK1VPOHNVZ2tzUjlPZjNPZzZMRlp2a05R?=
 =?utf-8?B?OFRidEVsR09sVk10a1BkYTYxZktuSGtXaTlUa2FLVSt0VjNldDJDdWN0M2JU?=
 =?utf-8?B?MTlEWDQ1TlQwMjlZWitaVDF2eCtaT2RWRmQvejc0NEpNQzhicVhHUkZKN0Jr?=
 =?utf-8?B?WWt5TXZjYm1xQXIycUFtd0ZtTEcrSE04Njh5VEhTbnhWc2htUTVmYVhRV2FH?=
 =?utf-8?B?dmtKK3U4TS9ydU9qSVNsNTIxbnpDWDRwaFhBbmdJdWd6MnI3RGFWNVVRZGx3?=
 =?utf-8?B?TGJWeEh0MGQ4SVhVb0QyQXdyM0hHZlhLR0ZVKzhTcVhSRWw4UVpSd0RFb0VV?=
 =?utf-8?B?bGNVMXVBQUlKTGhRWktjcGxnbkpuZ25BdzM3ZzlKSTBNdXZBQis4RXNHR2p1?=
 =?utf-8?B?WmZEWEtCZE5tUWF1Mmd3L0dUZ0VLL2twUmU4Wloxa0lLYzJOUnJEZWFNSm80?=
 =?utf-8?B?Mk5VMGhGekhRdVpJY3hEbTd0b2lnZkZFN3MvK0RlL2pCZGZaSUJLNHdFUnk2?=
 =?utf-8?B?SXRvUEpXNERSOTJTakpmMFZzVlhPVGRqK1A4RDhsdUtsblJvMlFXQ0lEZldr?=
 =?utf-8?B?U1c1MzV1aFBjUXZXMnNRV2d2WE50T3VCdUtKMjRKTmdTRlRGS2ZlMzhpUzAz?=
 =?utf-8?B?b2JINHhYTk5GOXVyeWoxZXB5c0lpS3lENHdDRElKM0lvODIydGcwSzZmQWVn?=
 =?utf-8?B?SVdMOXhnTk5HSUlUUHppMk5SVkJSWVhKQUJRWmdGMUZIZjE5SXdhbjFtMk5a?=
 =?utf-8?B?ZU1KcWlla3NUYzNkeXFidzloS3FjeURzMXdhaVMyWGRGbjhJY3hCMDRlV0Zo?=
 =?utf-8?B?ODFjci9uQzN3M3I4b0hxRmJQRHh6L0N4ZmczQXZlMVJKVzRzZkdtTFdUOHR0?=
 =?utf-8?B?RWh6Sng0UWI5bEpqakN4VDd2d1VCSXpLbjJLbjkrb0xDZ0FpcjFMckYzclYy?=
 =?utf-8?B?MFY1NWFUQ1dpVHNPM3ZYRWduUkVtMnRiYXNrRmVDN2FIQUpXQjFLQkRiYzNT?=
 =?utf-8?B?SmZVZFhLbUtlZncyRnZwRU12QUhVVzdyZXZPTkNkSnRxc092SFRIek9lUmw5?=
 =?utf-8?B?MFB4UUkwS2RES3ZjYngvbFlwQ2x1ZVBCYlVMdXA3ZXJPamFDamNNZDIrUnpL?=
 =?utf-8?B?QjRPV2FlRTR0YWtBb2ZRSDd3N3FhUnVBNWhVbmlqRjdBYnFUVGZwQUN5V21S?=
 =?utf-8?B?eGdsaUtuSG9iOVB3a0ZTMUlsY3lXcEhrWitJcy9GNDU5Zm5tdG12T3RvKzl1?=
 =?utf-8?Q?Luhnl43o4up4vdCEuLFD0Q+Pf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5320e0-d289-460f-34bf-08dd31180286
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 01:42:14.8785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfNUOWSN6H1IuYmOgYJ70SvqB9AGwN+txI62u9oSEta9+EvS6MYgLkScaIjCB7WZ12zoSUK8IMGtcktdEfCE1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8015



On 9/1/25 19:49, Chenyi Qiang wrote:
> 
> 
> On 1/9/2025 4:18 PM, Alexey Kardashevskiy wrote:
>>
>>
>> On 9/1/25 18:52, Chenyi Qiang wrote:
>>>
>>>
>>> On 1/8/2025 7:38 PM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 8/1/25 17:28, Chenyi Qiang wrote:
>>>>> Thanks Alexey for your review!
>>>>>
>>>>> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>>>>>> discard") effectively disables device assignment when using
>>>>>>> guest_memfd.
>>>>>>> This poses a significant challenge as guest_memfd is essential for
>>>>>>> confidential guests, thereby blocking device assignment to these VMs.
>>>>>>> The initial rationale for disabling device assignment was due to
>>>>>>> stale
>>>>>>> IOMMU mappings (see Problem section) and the assumption that TEE I/O
>>>>>>> (SEV-TIO, TDX Connect, COVE-IO, etc.) would solve the device-
>>>>>>> assignment
>>>>>>> problem for confidential guests [1]. However, this assumption has
>>>>>>> proven
>>>>>>> to be incorrect. TEE I/O relies on the ability to operate devices
>>>>>>> against
>>>>>>> "shared" or untrusted memory, which is crucial for device
>>>>>>> initialization
>>>>>>> and error recovery scenarios. As a result, the current implementation
>>>>>>> does
>>>>>>> not adequately support device assignment for confidential guests,
>>>>>>> necessitating
>>>>>>> a reevaluation of the approach to ensure compatibility and
>>>>>>> functionality.
>>>>>>>
>>>>>>> This series enables shared device assignment by notifying VFIO of
>>>>>>> page
>>>>>>> conversions using an existing framework named RamDiscardListener.
>>>>>>> Additionally, there is an ongoing patch set [2] that aims to add 1G
>>>>>>> page
>>>>>>> support for guest_memfd. This patch set introduces in-place page
>>>>>>> conversion,
>>>>>>> where private and shared memory share the same physical pages as the
>>>>>>> backend.
>>>>>>> This development may impact our solution.
>>>>>>>
>>>>>>> We presented our solution in the guest_memfd meeting to discuss its
>>>>>>> compatibility with the new changes and potential future directions
>>>>>>> (see [3]
>>>>>>> for more details). The conclusion was that, although our solution may
>>>>>>> not be
>>>>>>> the most elegant (see the Limitation section), it is sufficient for
>>>>>>> now and
>>>>>>> can be easily adapted to future changes.
>>>>>>>
>>>>>>> We are re-posting the patch series with some cleanup and have removed
>>>>>>> the RFC
>>>>>>> label for the main enabling patches (1-6). The newly-added patch 7 is
>>>>>>> still
>>>>>>> marked as RFC as it tries to resolve some extension concerns
>>>>>>> related to
>>>>>>> RamDiscardManager for future usage.
>>>>>>>
>>>>>>> The overview of the patches:
>>>>>>> - Patch 1: Export a helper to get intersection of a
>>>>>>> MemoryRegionSection
>>>>>>>       with a given range.
>>>>>>> - Patch 2-6: Introduce a new object to manage the guest-memfd with
>>>>>>>       RamDiscardManager, and notify the shared/private state change
>>>>>>> during
>>>>>>>       conversion.
>>>>>>> - Patch 7: Try to resolve a semantics concern related to
>>>>>>> RamDiscardManager
>>>>>>>       i.e. RamDiscardManager is used to manage memory plug/unplug
>>>>>>> state
>>>>>>>       instead of shared/private state. It would affect future users of
>>>>>>>       RamDiscardManger in confidential VMs. Attach it behind as a RFC
>>>>>>> patch[4].
>>>>>>>
>>>>>>> Changes since last version:
>>>>>>> - Add a patch to export some generic helper functions from virtio-mem
>>>>>>> code.
>>>>>>> - Change the bitmap in guest_memfd_manager from default shared to
>>>>>>> default
>>>>>>>       private. This keeps alignment with virtio-mem that 1-setting in
>>>>>>> bitmap
>>>>>>>       represents the populated state and may help to export more
>>>>>>> generic
>>>>>>> code
>>>>>>>       if necessary.
>>>>>>> - Add the helpers to initialize/uninitialize the guest_memfd_manager
>>>>>>> instance
>>>>>>>       to make it more clear.
>>>>>>> - Add a patch to distinguish between the shared/private state change
>>>>>>> and
>>>>>>>       the memory plug/unplug state change in RamDiscardManager.
>>>>>>> - RFC: https://lore.kernel.org/qemu-devel/20240725072118.358923-1-
>>>>>>> chenyi.qiang@intel.com/
>>>>>>>
>>>>>>> ---
>>>>>>>
>>>>>>> Background
>>>>>>> ==========
>>>>>>> Confidential VMs have two classes of memory: shared and private
>>>>>>> memory.
>>>>>>> Shared memory is accessible from the host/VMM while private memory is
>>>>>>> not. Confidential VMs can decide which memory is shared/private and
>>>>>>> convert memory between shared/private at runtime.
>>>>>>>
>>>>>>> "guest_memfd" is a new kind of fd whose primary goal is to serve
>>>>>>> guest
>>>>>>> private memory. The key differences between guest_memfd and normal
>>>>>>> memfd
>>>>>>> are that guest_memfd is spawned by a KVM ioctl, bound to its owner
>>>>>>> VM and
>>>>>>> cannot be mapped, read or written by userspace.
>>>>>>
>>>>>> The "cannot be mapped" seems to be not true soon anymore (if not
>>>>>> already).
>>>>>>
>>>>>> https://lore.kernel.org/all/20240801090117.3841080-1-
>>>>>> tabba@google.com/T/
>>>>>
>>>>> Exactly, allowing guest_memfd to do mmap is the direction. I mentioned
>>>>> it below with in-place page conversion. Maybe I would move it here to
>>>>> make it more clear.
>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> In QEMU's implementation, shared memory is allocated with normal
>>>>>>> methods
>>>>>>> (e.g. mmap or fallocate) while private memory is allocated from
>>>>>>> guest_memfd. When a VM performs memory conversions, QEMU frees pages
>>>>>>> via
>>>>>>> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
>>>>>>> allocates new pages from the other side.
>>>>>>>
>>>>>
>>>>> [...]
>>>>>
>>>>>>>
>>>>>>> One limitation (also discussed in the guest_memfd meeting) is that
>>>>>>> VFIO
>>>>>>> expects the DMA mapping for a specific IOVA to be mapped and unmapped
>>>>>>> with
>>>>>>> the same granularity. The guest may perform partial conversions,
>>>>>>> such as
>>>>>>> converting a small region within a larger region. To prevent such
>>>>>>> invalid
>>>>>>> cases, all operations are performed with 4K granularity. The possible
>>>>>>> solutions we can think of are either to enable VFIO to support
>>>>>>> partial
>>>>>>> unmap
>>>>
>>>> btw the old VFIO does not split mappings but iommufd seems to be capable
>>>> of it - there is iopt_area_split(). What happens if you try unmapping a
>>>> smaller chunk that does not exactly match any mapped chunk? thanks,
>>>
>>> iopt_cut_iova() happens in iommufd vfio_compat.c, which is to make
>>> iommufd be compatible with old VFIO_TYPE1. IIUC, it happens with
>>> disable_large_page=true. That means the large IOPTE is also disabled in
>>> IOMMU. So it can do the split easily. See the comment in
>>> iommufd_vfio_set_iommu().
>>>
>>> iommufd VFIO compatible mode is a transition from legacy VFIO to
>>> iommufd. For the normal iommufd, it requires the iova/length must be a
>>> superset of a previously mapped range. If not match, will return error.
>>
>>
>> This is all true but this also means that "The former requires complex
>> changes in VFIO" is not entirely true - some code is already there. Thanks,
> 
> Hmm, my statement is a little confusing.  The bottleneck is that the
> IOMMU driver doesn't support the large page split. So if we want to
> enable large page and want to do partial unmap, it requires complex change.

We won't need to split large pages (if we stick to 4K for now), we need 
to split large mappings (not large pages) to allow partial unmapping and 
iopt_area_split() seems to be doing this. Thanks,


> 
>>
>>
>>
> 

-- 
Alexey


