Return-Path: <kvm+bounces-41236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC84A65574
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1AA43B50D8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 15:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEEE02451F3;
	Mon, 17 Mar 2025 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="08IWMGDC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7EA218E96
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742224915; cv=fail; b=ZxnzhQGmu/3DT8+4LxUxv0Ixlh9LX5e/Tv5vzGPRZOqLHjXm6hzARRD4o0qDQH1S2NVZEv8f+wbZYpUOAzHSwwVkBHDdPVNejgp+C2M5vaiB3asrdS0LTFB8h5TRSuRfPBtQQ7TnLniIIzCEoiuw8s0aLYqbJEWgZI5c7Tnkpfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742224915; c=relaxed/simple;
	bh=PgFtCRvS+WdYI+WHEXYVqBzijEG/Yajou4xhdeIxJuY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MbwEy4RPvZ20iuDAjFeCs6nEu9XJQHo1U8ZCJLZnAhKUweiKBSbogUlButwds1xFdE96bhzN3PGm2DDeYl1FPHKkgBUbqQ0qaOR7PuBoQ5sSmbhkLE85i5T/f51Y5lW13H/QZPwobGd15ZV9LTaESgmoQuq7TVlQ/W638upLj7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=08IWMGDC; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jNR2fMPYepj8PCA4ZCKM4Q5wdQdiHoZkpHQvO7E2Ir6YlgjmL9GN8ZC7zdcVipNjxuBSGA8w24eUuhwVgeUtEJxzH1JIVljgnygRv8wVDxOxYO5L4sY6qo0eJ85Cx7zeLdAS1XMeZkPvjcPdMjp/foG9VSD3uEHea7sJ43pH+tshSsbhxyxis40iiGQR3cnioCXbrtZ8J6F7I4VhHOSfqzUXn+fr/tryf9w/JmK3X/HlZ4v8r6IZC1a2BkGMLrytbjKqoLVxWAXExkDf0UMPGB0LpJKTtgRPRozyneQ9swVdv5ic14m8ICWFouQLGyKEe00Y57qD3U/yBRiWSkJo+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wj4dhsJ8OetioZFuMbS/0m62YmLokkNe6jXM95eTFq8=;
 b=wPLtfraUWM23Pkelh/gNKISO0yo3vxPSwLgKQCt2sJjZWiiiVutuVrh5TmL+KC0/sQp1ulF4j73N7WG1arYxIF0XS5bfCARhXYI+9W4gUnNmL1Vh4sdS2tiusVy0aBUW24/rMuAS4ElqNaV0hrv6mAkDD0hQ/uKfj5Wdexabnul5uuILxkeqUZg3hlh0GSJhA46Wb26Q4AStCSAIhrBsC0UIZ4zTc38JAPHjfzuws6cwuNCRtNXyewic4vTuesX2nkiv+yl+tJoWbqQgMKrC0aD+Mdd34unsZJr6d+beaLayZyTRaQQTIiCqxhWaXEl2SyaGY8EvDMMZOgtVbyz6lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj4dhsJ8OetioZFuMbS/0m62YmLokkNe6jXM95eTFq8=;
 b=08IWMGDCq9YMXoVzEDzyRAFFkHF+WiS/mw9RpX4GbWkFdctcQcHjKKoB+tHnF9JWQoxoh8+kIPWUeIfmDgj+Wz8+0a4ZTSKLG7nuKJeaZVLoABMT1AOy2zwthQTi+HFaCGB81nFnlHEc9Tevku/DjnxH0Pvw9lCpF0UQ2/1FLwY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by SJ2PR12MB9244.namprd12.prod.outlook.com (2603:10b6:a03:574::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 15:21:48 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%3]) with mapi id 15.20.8511.026; Mon, 17 Mar 2025
 15:21:45 +0000
Message-ID: <e8385f73-2c41-4ee9-9350-4f3b9c0b9a19@amd.com>
Date: Mon, 17 Mar 2025 20:51:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] Enable Secure TSC for SEV-SNP
To: Tom Lendacky <thomas.lendacky@amd.com>,
 Vaishali Thakkar <vaishali.thakkar@suse.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250317052308.498244-1-nikunj@amd.com>
 <fd404afa-7a42-4fa9-8652-519649482d75@suse.com>
 <8b312f7d-428a-aeab-cf26-412f8d8270e6@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <8b312f7d-428a-aeab-cf26-412f8d8270e6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0040.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::9) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|SJ2PR12MB9244:EE_
X-MS-Office365-Filtering-Correlation-Id: d362efe4-9cd5-4ef0-4b00-08dd65676dc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2JrT0ZjeGR2Z3RPb0hNTkJPN0JzVnZSamR0NlZFUllRL0FUdmNFT2hLeXZI?=
 =?utf-8?B?enpIRXMxTE13NVhFUkdyY3hMR3pnbys0Y1VRWDkrL0hKL0pyL3hsU0YvQk94?=
 =?utf-8?B?T3NOZ3M4eE9mUzRDZjN0SGlyL0lnNHdlcERTT3NaOUI1N09WNFRNM2lWQ25h?=
 =?utf-8?B?eFpMa2R3RHNCVjdIbVoyb1dzN2pQczZML1h1MHhoTk16Nng4S0NpSWVLSCtP?=
 =?utf-8?B?YzZEdzdwQmk4Qjg4L3VZSW82UVBrUGdjcktJU1Iwa0JHSWdEVlY4VGpmUDhk?=
 =?utf-8?B?V2hkYzlQbHNBbzFpajRJTHdVVUduV3liVWRzN2tEYzY5eDkxTUErSGV0Qlg3?=
 =?utf-8?B?ekNycVh3Ty9RLy9aS0EwdFI0TWQ0R1FXcC8zWmd6clhGZUgvZjZoYmpSWjdv?=
 =?utf-8?B?UmsyVVIxSmRJeGpYalJ3OUpZWG1vUU5DdVlvMUlFaG1ZbGpVM0UrMUhJQUJD?=
 =?utf-8?B?TUVJNFRSUzh2cStHM3NjTGNldnBNRWJGUFRBbExsYjBrU2VUY3poTE00N1o4?=
 =?utf-8?B?WEh5bnhTZG1ja1ptYVR1VS84ZFpDNjFTZ05nY2trN0VyM1cwZW8zblZQZW40?=
 =?utf-8?B?ajg2MXFpNm5GbzZEQnVObGs3VFJWNHFtdGdIUFp4dDR4dkdEYllCeWZ1djFh?=
 =?utf-8?B?ZEdZVmQrdlQ2RjhlN251Ym9YYkhxSXhscDhZQ0lrUU02VjNpSDR5cUJhR3dH?=
 =?utf-8?B?NWRFUVJNQXRVWllQcXYyaWliSE1tV3JVbzhJMUMvL1Z0bWtzSE9wcC93OFNL?=
 =?utf-8?B?MFRwSnVBUXVjL1pwWEt3RjJvT1ltNW41ZnNacEhkQ2NPREZOeVpJMzZIYlYw?=
 =?utf-8?B?ejMzT3F1OUJmQ1BIM3gwZ2l5cnZtTWFQOXZ4ZkswemxBNVdzOCsveFJvaldm?=
 =?utf-8?B?R2FCaVhHN3VYTXIzb1BjT1lEdU5tV0o3UlZCZlQzTWl6TTFqUnRNSTR2dnBJ?=
 =?utf-8?B?QUJtNGpsWk9sdW81eEJNTmJua1RKQUtMQ21qdmN3V09ucmNRVVk0RTRkLzNa?=
 =?utf-8?B?YXBnbytQK3QzbVlyeHZpTUNYdVNoS1BBRjVUNkV3dnVjRmVCL3A2S3hubkU3?=
 =?utf-8?B?UEd0eStISldvT3lvRExTeVhoOVlzZVZiUUo2OUFnK0x1dGNNcVB5a1lVbFN1?=
 =?utf-8?B?MGY2bWJwVWd6ZXU4T2J2aCszQ3cvVWlQU2x1cDZkMTVGV1JLQkxySjZZbndI?=
 =?utf-8?B?cGhCMVZETTNmaHVYUDg2eTFTeU1DOFdwTWFLNlBpaUttNVhhcElWdm1kMUpM?=
 =?utf-8?B?V2xZR2tLWXhUZytWUWd5eEZJM2lkb05jRk5uU3RQNE9USnhabzlBWTYyMFk0?=
 =?utf-8?B?VDhlbjkwYXNEMlJUOGNvT2JLNlFSSUxMK005aW1KczBGdjFLYzVFYm80T3lk?=
 =?utf-8?B?Uk8zN3JIRFluS1lNS3hqcDRxSEVoVmFwSUVVbGMwTnlvN2dtSUMvUmVuVXU5?=
 =?utf-8?B?UklYc3hDc2RUMGY1S25sRzZzZytUYmlvRkFNOWhweDhYc01PSnlUKzNna1Uw?=
 =?utf-8?B?Vm9kcnpoMEUxWGZTY2RHMVVnMjZNZlJoZXhpWWRudmpGem9rTWc0WW52R3RZ?=
 =?utf-8?B?QXBmcVhsVitBS2lTRHNWMUFueDYwNVhMSTNZWWhUR3RqTjNad3g1a2hHVDhP?=
 =?utf-8?B?V0cvVVNZQU9kMVFqNjVENzVoOGFJZWdOdjhHajErV1lwTlJ1a1g2dkhVbEt6?=
 =?utf-8?B?c1QrZk9FUEVGSVFYSkpQKy9kZVY1YmlXRXR3Z0ZJMnhkV2dwZi8zbG5nVTVj?=
 =?utf-8?B?c082dW9DRjA3V21VbUxKNmsxUE5GNm91MU1zZmFvaXhyNXp4dVhRczJBeHBG?=
 =?utf-8?B?TEZReTFqS2hZdmpBSlVTam40RHFiN2lYdWJPOFNhRlMyMk9wT3NQd2svNzQ2?=
 =?utf-8?Q?ftYg9N21XiPLy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHdVOSs4eHhDNFhJOXZzLzk3cGE3SFczaFJacE1LWHdNWitLeklhQVYzaDFm?=
 =?utf-8?B?cks4N1pMVy9KMDAyYjZuY3ZLUzJoZWloZzNtYk1UMzZyMnlvVStMUWJWZHJu?=
 =?utf-8?B?d3pBVk94MGxSNkJtN3NGTjJ4T0w2ZUlnWU4zNDFwbTFLRGV3WEVTdGJkQ1VO?=
 =?utf-8?B?QW9QWHdhNjR4bTRaNDRManpPalBhVlk0RllUbUY0ZHhTejBXc0VrUnNSb0NG?=
 =?utf-8?B?OWtMRHp6dDBSTlFESWdFR3Y4bXJpcXJMckRDenJmMjh1TldCalo1aGo4aGt3?=
 =?utf-8?B?YzZCamtQempVSVFMVjBwTnNTNWxoYTdLcDN0L3ZCSG8rU0lNZjdGZmhyWm0r?=
 =?utf-8?B?OUlDbk04RHdjYVoyUHpMc2NWN0dUTmRCUytZQTZEL0lxTmZDekpvSWJmZFBP?=
 =?utf-8?B?bjVVK2F1cFlXOHVZTndOS3NKV0Y3MUFPM0JIR0RBUGpjZXkycUNJRFJDWFBq?=
 =?utf-8?B?YXI2V3dxVHNvK2ZRSFNxQlRJeEYvUGo1a0hSbXhBell1bkRtTEdVWFh1MzZJ?=
 =?utf-8?B?UGJyQnM4dlB4S090RDR4clJPbFhjRjlodU5OWWRnY2dmaGsxdEJVVTBTRjhz?=
 =?utf-8?B?SVI5VDF6aUE2K0ZpTnh4WmlmRk1ONGtLU3BGZnN2R0FUNnZPZVc3djFvNG9Z?=
 =?utf-8?B?NTFTOU5DeGFrVURWbFo5Snc1eWN4a1NsK24yTXllTE0vTUhGdmlTc2VKWnND?=
 =?utf-8?B?WGF4ZVVKaHE1dVBiYld4NlBoUXlRbGpPRktIKzZ5SjNZajhiajZFdWxKOU5L?=
 =?utf-8?B?cWZKeWlyc2NhbjMrM1RrSW9sOWpNdEJpaXdNQ3AxOXh4ZW9lK3AxTG9BcTUw?=
 =?utf-8?B?bzJBNHRtS1E2TUZNTnFIYWdOdU1BYndkOHZxdjZNSC93cVFkTjNmNWN0TGs0?=
 =?utf-8?B?bkJnOU9BbHp4OUJXR25uT01wQlRyUXEvcCsxV0dBalFqNFFjSWFzYnNXL0FL?=
 =?utf-8?B?N3JEUFRFOE9GYmRlOGcyUW5Tc2N2YktqWE1YZHRWb2EvRUtOMGwxeDdKOE5l?=
 =?utf-8?B?cEZyVFNxVHJlSldPbFZkZmJDdExPUk1SN3hSY0w1ejNQa0tMb0FGd2hEQUhM?=
 =?utf-8?B?THJLU01PZUorMm52ZElPeE4zOXR0cEtNTWZ3alFKdHowY1V1N3RYV0g2WnNW?=
 =?utf-8?B?aUFOT2NNdHpPazBBTXpybzZYeDhZb1ZmcDRYMWg0T20zS1EvbyttQ1hRdjhF?=
 =?utf-8?B?TkNqNTI0Y2NIWmtNdWQxVUdlaFdSWmdmUnEvYkxLTnQvUlNCR3Jjc0ZHcGdO?=
 =?utf-8?B?dnhQanEremRXZ0RDUXNocHphUzJYbEU0ZnhQV0p5aUQyZ2tCQmtXZlRTLy8v?=
 =?utf-8?B?eVRYSnZJOCtVbTR2elRmY3JXZXUyVHhSLzhRMmlSR3FqTWFzL0VXSjRySmpl?=
 =?utf-8?B?d0hPWTk3b3hwMWxqb3dLY3hjYWFFYXg3NXhFWm1PcXlqeFo4TE1SRmdzNUpl?=
 =?utf-8?B?anJqRUpQUlB6cUJBbUZFS3QwaDlNOWVrVDNYdlV5c1gycE1RbCthalJiREZu?=
 =?utf-8?B?dFVycnJiU08rZzhXNm9vWTJ3SWtDWVBRYTY4dm4vZjkzS0NDV3ZwM3poZXZY?=
 =?utf-8?B?M3lJY3R0RnVPc2wvVlIvZ2c1RGgvVXNJT0JmVFFDTTVGaFE2dVY4bFRDZklH?=
 =?utf-8?B?eFpVbjVOc2owbzJ4b1NhSFcxb1FlUVArU09rdFdRNmQ2UnMyWHFyRHpKaUtp?=
 =?utf-8?B?aU80UCtrNVJQd25INkhVWm9Kb3pNSEJUc3VCUHd6SnBLd2Fpa2lvNXhIbzZS?=
 =?utf-8?B?cWxYaTNFU0h4S1Z0SXhVM00zSU94RVRibkI5OWlWa2NjUS9NTWNNUTVpVGxO?=
 =?utf-8?B?aHlOUVphZ05OS3lwZjFmdVppc2JpT1EvV1hlVFI4T1VPZFcwZFV1ejVTU3NF?=
 =?utf-8?B?WlQzUTJYNjdycXpXSS9kNFNEZC94SlRkY0thYllOR3NNSk4ycUlxRnRmVkpp?=
 =?utf-8?B?QmFoK2cvR2RlZzdlWU8vTmFFRlorTnN6TXRnVGIvVnQ2RXUzNGYrem5JeHpX?=
 =?utf-8?B?Qi9JOStmRzZKem9VRXJrY0RDSHVUMDV2eTBoZFpReUpaalVZaWVSS3lmVU83?=
 =?utf-8?B?OFdQWDFOR0Y0ZmRQZWhNZmNnNUtJbFlhSVA5c1dHV2VYQ29ZUkhZc2puaWxT?=
 =?utf-8?Q?liz34/nfVYJLrZuuPTuxRhsFt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d362efe4-9cd5-4ef0-4b00-08dd65676dc5
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 15:21:45.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBRI7JuvzVg1bTSrFTJG7j0QJyIWFW/MnLljrMnm2zzVXFc7wSk/hngb3nLjbc0L2wUx3T7MyH7tn8tJ0fY2Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9244

Hi Vaishali,

Thanks for testing the patches.

On 3/17/2025 8:37 PM, Tom Lendacky wrote:
> On 3/17/25 07:52, Vaishali Thakkar wrote:
>> On 3/17/25 6:23 AM, Nikunj A Dadhania wrote:
>>>
>>
>> Hi Nikunj,
>>
>> I've been trying to test this patchset with the above QEMU command line
>> and with the OVMF built from upstream master. But I'm encountering
>> following errors:
>>
>> " !!!!!!!!  Image Section Alignment(0x40) does not match Required Alignment
>> (0x1000)  !!!!!!!!
>> ProtectUefiImage failed to create image properties record "
> 
> I bisected EDK2/OVMF and found that the above messages started appearing
> with commit 37f63deeefa8 ("MdeModulePkg: MemoryProtection: Use
> ImageRecordPropertiesLib")
> 
> It doesn't appear to cause any issues while booting as I'm able to
> progress to the grub menu and boot the OS. Is it failing for you?
> 
> Thanks,
> Tom
> 
>>
>> I briefly looked at this[1] branch as well but it appears to be no longer
>> actively maintained as I ran into some build errors which are fixed in
>> upstream.
>>
>> The build command I'm using to build the OVMF is as follows:
>> build -a X64 -b DEBUG -t GCC5 -D DEBUG_VERBOSE -p OvmfPkg/OvmfPkgX64.dsc
>>
>> So, I was wondering if you've some extra patches on top of upstream OVMF
>> to test SecureTSC or are there any modifications required in my build
>> command?

No, I do not have any Secure TSC related modification in OVMF. If it can boot
SNP, that should work for Secure TSC guests as well.

Regards
Nikunj

>>
>> Thank you!
>>
>>
>> [1] https://github.com/AMDESE/ovmf/tree/snp-latest
>>

