Return-Path: <kvm+bounces-30892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 566E49BE2D5
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:39:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13E7C283F65
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1461DD0DB;
	Wed,  6 Nov 2024 09:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d5gPtLGp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8431DD0C8
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885955; cv=fail; b=iaBdmwKMtUdJXwB67RaL9ev9D408mr+5AGzl7OE2RHNwOdGI+qUmdfGlEX4RxFQTOTP0ua51440AoM8fKFnuCI6gS3gDWaZJDcLebu2lDZ9Zm14vjhridGeE1eqdL91pVTfhWCKkMX6wS/sphcw7LDDtHlXxA7CVzdMHZjGto/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885955; c=relaxed/simple;
	bh=CKOaP8KvKreN6pT/xl3hA+xckVavSzBP7WnwEggVPWs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k6ZBj5tIXE/yYX9UBcouDWcBZM21O9dDBMDBLxzeK9cBEl+HYfGn/a+3nDXb+NDGNzGOlJV5ImgGNJa+jeSiLPQUAJxKKyefvLTChoQPXA1VRHC5htvs5BVJ2Eavev6kViIRPj/p0B5+CYI35n40d7fyCGKV3xXnxTHtglgXosg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d5gPtLGp; arc=fail smtp.client-ip=40.107.244.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CvmJPoR1alBxjkcJhx25gRkQbffZJBYcn3EYUNUjxmGkjUcKlxamCKIynNFX7AmVbVANYt5jGz3QYpi9CAc0fUFybGtdv11B7laDwQw76M4CfLa2lhhFcgIG1RShNnG2k8SMvKllvYTgt9iuC4RzvD9vryEk31eWWR5Gk343F5fqPZ8Enab8mCrRdzTParLKN9v36UxKkmITaPXQyvS0L/IcIouNgBTYy3OVKF1J+Hd3qpxmwTKlDvn6YUZRYGwsFTEwAjCh6DmZpncJCXQTI8E9xHdcmuhOAKG8B4SaY0/SM/JywGMUFXrctIN1NhaDnf4Yw69qyvqfxVQ332/eVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYe7MByez8UA51K2czXEgKmf8go1oBqYyvnXfiWjIDU=;
 b=yWBaswLltF7AeW0C44CJHgvp5JT8jr5Qs8i+fPNexgOpXvcFifu/5lwArDWA4Mshw2N4LPzvY1aKxaEHTidYWJWqWJmccDgYwymHiL41qyeS7sdkxWLeXbmcsg050CeOIeYILEb0mmnoY9xop0FCUNdn27qNJV5IiJTWWqYGsWBL6s9DSKZbdOhmGZqhaJsXRbXixhI/UCc8TgfkgUzSa/PiQW5iYjJGoB9ey5A/Z9lOybkagylEvF/Q6t6H+ccIYgJUAAjMFAsw8N/zrxIs0GVSfAbJxvIpeV47WFt6RLK4Fwpexl0P+wr2BrqQ0Lk7PLvUZI0f0zQe1JuN5iIb3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYe7MByez8UA51K2czXEgKmf8go1oBqYyvnXfiWjIDU=;
 b=d5gPtLGpBpCo1ZwjyP8zfEGZA8GQrCrJl/LY55CJpSJNp4WyxeqxAmezsv14fBMOaLkjD7TopdW/NhNh0PhN9spTOi3dU+JIGaoDEfYNscjbyQp0cHW5MTNB25ISNIJt8Z4R+Rz1T13f/4xCSeNlUssnp8sNe3+XPEO1CuZV4fA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA0PR12MB9047.namprd12.prod.outlook.com (2603:10b6:208:402::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.19; Wed, 6 Nov 2024 09:39:10 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:39:10 +0000
Message-ID: <752fa0c7-40d4-4ea3-8cf7-7315d3791267@amd.com>
Date: Wed, 6 Nov 2024 15:09:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] iommu: Remove the remove_dev_pasid op
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com, baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, will@kernel.org
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-8-yi.l.liu@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20241104132033.14027-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0233.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::12) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA0PR12MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f067422-0781-4973-c3c4-08dcfe46ddee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amlTamVLZ0pmVVU4WnpZRVZ0Qk5rVEpSRHRsSCtIVmJwenZWT2huSTZRb2lr?=
 =?utf-8?B?QkczM1MyeFp5TXRMVmJRQ2RGMTQ5dE9FeFZreXR2UmtsN3dTbE1OUVFXRWkv?=
 =?utf-8?B?Qk5yRnkxamR5WkpzQkp0NW9xdTVQcSsrZ3dXaGFGLzVJZXFJRkpPakM3Ukxt?=
 =?utf-8?B?L3JJWTk2WnFPRTdVNVpUSWJ5NCtrdUZqNG85SDhLSWxad3crdUQ1dEZONThW?=
 =?utf-8?B?Z3B0OE40S0ZJUUw2ejh0SHpFb0NUWVBSeURseUwxUE56SkNlS1FYQ0FKdng3?=
 =?utf-8?B?KzM0b1A2RjhUckRIZ2RndXExODExcGJFWHZRQ2RWZStSUHlBWXFoU1NWOHZB?=
 =?utf-8?B?UGxHUUZVbWFQOXdCWmt5TktvTS93RCtZQ1ZrVnFsOXhsa1l5S3R3NzVpOGho?=
 =?utf-8?B?RVNpWnZuN0NVdHJvby85K3JwczhYMG4vL3JoN0xsdW5jdEpDdlgydHZGYjRE?=
 =?utf-8?B?QWlOaEQ5dWYzWXhEQzhDb29sd2tYSjBJNE9wMEtGUHcza3JwSFVLS1FScE1B?=
 =?utf-8?B?MmsvRTVVNmlpRnE0NFBremRTWTNTNGJKMnBvZVpIdkNKT0NIeHBFLzJnai9U?=
 =?utf-8?B?MHNEZTNnWWZCbHpoR3JrQ2JIYXBFdkVROXBYcWNNTFpBeDFzQ2NjQXZab2lv?=
 =?utf-8?B?ZE9ZakZUeEFhVDJqdEMyc2tjVDJOdUJnc0dYcFJtK1JIK1pqSVRPM2J4c295?=
 =?utf-8?B?ZmJmN0trdmVBYUdDTG41RjlLTW5Nb2xOVGtuMWlnV0dXQmxoVnJoMFVBcFJC?=
 =?utf-8?B?TzlRR3pxNTViQ3djZlpVc2t3U1hUUlFvMmFTKzJUSU0vWTFsS3VOd3BVMzUz?=
 =?utf-8?B?K0VPbE9mS2tzSHdCNFNlTUJaVWhOUmhMQzQzUmdFaVVXbWtzNTJ2K082QU5D?=
 =?utf-8?B?SGZKaXFUUWNOZnVIdTZWZGtMSzBMTHRJWkc1Y3pCaFpPc2hsRVRTRTZsWmJL?=
 =?utf-8?B?eXlEK3BxNDJzNi9vRCtmdjMrNmc0aytSREdhOWhUNHU1K2RTVWtDQ1RHd1Z4?=
 =?utf-8?B?STF1RFRvU1V6bWx5Z3gvNmZVbGtzVW5vVVJXUDBVYUZZQTBSMjAwbDcrY1Ft?=
 =?utf-8?B?TG0wR2FqTExOY1QvRUZUSExHUEI0M0U2eXlEWkpUU1QzanpJaXA4S011UnVP?=
 =?utf-8?B?amNYM0FOaCt3dmwzeHlrd29XRVk5R3RWYlk1V05kSkt2TXh2V0F1bkZaa01I?=
 =?utf-8?B?UVA4dUJHRDlwV3BGang4dE5hWXVoZFVlemg5ZVQycHBtWGJoQ29ER09KODU2?=
 =?utf-8?B?N0tsTjRZa2p2bmxVK01UL2lPSG5FbGtHdEJZaUFXTTZXVHFLbEFOZEk2L2Jq?=
 =?utf-8?B?UEZKL3JwaGlQbkpBVDNMME5FQ0lCQ3Y0YW5SNEprakxXUlNnZUE0WU9jUkJL?=
 =?utf-8?B?ZVVlR2FocXNvdXJUYysreHY4ZS8xaUxsMVpNVzhjNU44eEZvR2ZjQTZTQUgy?=
 =?utf-8?B?TmJWeVB5VXlmYWNxTkRZQU5qc3c2eXNqUGNpbUJkZVRiQjNoQmZCSFJnbHpk?=
 =?utf-8?B?cVZNWlNkcTdrY1A1VXZJbDdONWRad2FibHpKRldwdEFNWFRGdWZLYktHYzR2?=
 =?utf-8?B?YWhaNFFEbG9SdWxvTXhtcFA1VCtzM0kvdTZsNGdxVVI0eFBxS2lhdkkzbG9B?=
 =?utf-8?B?dkVWTXRjc1hQZklncDFycmMzdm5jMktOS3NpellZSFZyU1FiNUtJRkt4S1hD?=
 =?utf-8?B?Skw2ZTVLeWNId0N1WklOWjNhOWUzdkZWQUVCL0ExT05aWGIybzRielR3dGJM?=
 =?utf-8?Q?rTi+1QgY2TuA2BXFJQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1ZaYlRPK1doZHNyN2NnNHlnL0ZhVXNxNzJKd1Q4NGVKMWxKdExiaEt0ZWll?=
 =?utf-8?B?TUFMSG1ZQlY2enY0SzF0UXdXaHpzR29ZcGN2RGF6czdiSStpRWEyTUlsSjhZ?=
 =?utf-8?B?MWV6dFErQldUT1pWcHZCdFlDYUxnU3dxNVFGRE4wZk1HS21xeWlOTTllWHpZ?=
 =?utf-8?B?ZFEzRjZVdG0xSDd1UTMzMWFocm5JZ1h2dVlTSEpsdTZDMDc0ZC9rWjdSQnpQ?=
 =?utf-8?B?Z0d4SEdUMmIrQlIwNUJXaWFUNVZkelNpK0VpNWlYdmRvOEhYdEp5SmV5YmRB?=
 =?utf-8?B?aE43b3VYejNqVEw0QnUxdXVWcVc4T3Z5MEVjMGNqaktURDExVFNtZk54OUtI?=
 =?utf-8?B?MUt3dDNuMVZwMWtkUFAxQWpibEtHaXNzUWpDTCtZSnpmUEtTdUFBbW5YT1hT?=
 =?utf-8?B?WC9tdFBxTXhXckJKY0NGd2dQTy9mUEh5OXkrL0VjUEQrZVNmbnRWbmpVUCtW?=
 =?utf-8?B?VWJOYzV0cmU3ZjVjTHc4MTdzQnFESnlVMWJzdzkxOEJzc0cwcU5uenlVTUhU?=
 =?utf-8?B?bWVNc1JqWjRkSHp0aDNuOGFZYjhCdUFXQ0JLL0NxUTFRVitkbFl2ZElJNHBS?=
 =?utf-8?B?KzY3T1d3ZExDNHNiWm5PbVZIMXd5bTNyZlpCRE1iVFpDS2F2dUxqL0pIU0VD?=
 =?utf-8?B?UGMwaks0U2FDblRZTDAzNGU5c3c3ZCt6bkdDeWVNbEVoeGhZN0tGTE9aaWtG?=
 =?utf-8?B?dDg5a0RWalBFd2tyL0ZsWURBUnE2akhiRWF1Uno1YkRHYUV3Q2hidEYvQ1B0?=
 =?utf-8?B?eFRXZ1kyK2RyalJhVVJPMldmelJRQXJnQytjSWlxRzU3WS9DR25CNWZrS215?=
 =?utf-8?B?THljYWhSLzlEVVhDejdPem1HRnpUM3FmMVdBS1NiYU9sZFFOTzVZWm9LcGEz?=
 =?utf-8?B?Ym9jWDZ3N1FualBCTnQ2eXIxbEcyNmcySCtxSkdoamh1RU4vTzBxaEFtVzBQ?=
 =?utf-8?B?S0tJdWdnWWpTUUpRN1EvMnovQUFLVFFsWmFlZXdhSXBJd1p3Q1ppaWYxckN3?=
 =?utf-8?B?cmRUQ2hLcVdTOXJ3UXVaZTQ2cm9vSEF6SDJGRTV1MnhjcTRvWHp6MWkvckhn?=
 =?utf-8?B?bmxRampxZkRXY25kQW56blBUZXZGRWZ3VjlRNE1Zd2pJSkFpUzFRa0t5a0tG?=
 =?utf-8?B?REpKSTdlWEJuanQ0MTlVZ2tGL2MvbVk3Z3A2WDN0MndLd3NiNFBvUG55MEc1?=
 =?utf-8?B?dzBOdm54dkZoT241QXNqV3FxdEpraXZKRzNVeFZPK0MzUk9lcSt6SkpNQTlr?=
 =?utf-8?B?czBKNlZxYjZyaEE4Y1RJdHQ1bXdHZi9iT2liK3NWZDNjWlE4TFpTSTV2dEhS?=
 =?utf-8?B?bEN2QThCcENVMVpOcmVHQXp2NkliVm5ETFNhZC9aQ3NvQ2Y1WWd5TzJXcCtr?=
 =?utf-8?B?bVdxOGZUZVZ2cndXekhBSmNUUFVyTTlISitGSHd5bmNmUTZGYjdDRVhxeHk4?=
 =?utf-8?B?SE42TTlyYWlQYXptYTdyT1R3LytWcTBkY25JejJGM3d6RFRqaHFtSHgveC8w?=
 =?utf-8?B?anFBcHMxbmc0bzZBYnZia2daRk16RFhEa2NaZHllcWJXZlZaZVJiZU83bzR1?=
 =?utf-8?B?UVo5dkVOeUlwbTJEeDVySjhyY1FiVTl6ekczbHVkcjQ0Mmh5a2FZT0laeDM4?=
 =?utf-8?B?WUR3bnJ6VjlBTVNsNzdZUkEvY21aU0plMU1lMHBGUmgxZEdrVFF6NXk0ZXI3?=
 =?utf-8?B?NkRhak02UVgzeDZQeVFGNHluZHhIdjZ1ZWhuMExQZ1lDR003T01lWFFxdHJJ?=
 =?utf-8?B?QytHTy9GaHBWQUJyWXRMRGhmcXpSUGQyZU8zL2h5YmxHQWMzbURyazAyL3Ay?=
 =?utf-8?B?aFlKZlhZRUpjWk9lU005UnZ1d0RZbGVzYkhIbFUzS29nTG5lWEdxMVJ2bUhx?=
 =?utf-8?B?ditLbHpSTFZlWFNlQisxU1czQmEzQSttTytYWFJWdVlyUmswdkVYZG95ZUtV?=
 =?utf-8?B?R1c4eHpJUWZjS1V6SEVXQTBrdGxvbStYWldrTU5OcWIxMVlidkJwR2xXMkY3?=
 =?utf-8?B?WksvWkQ3YlRpRTNxYWZMa01wbi91ajMzTmorcWVOK3VJTlU5YUQyazBQbUtZ?=
 =?utf-8?B?UUhsZjJNdGZSVWp0V044RWtqZWhQNEtrU0lBT2xKMDN2N1Y1d2w5SERHYnRy?=
 =?utf-8?Q?H6a+H9AWoVsRb8wOgRLyZzN4V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f067422-0781-4973-c3c4-08dcfe46ddee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:39:10.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5kbIPmxMSc5OCRivOL0kMNXze/3EomRmuE4AgvJbi/AP9aCqqjqTIbTGWoUPr3o0CHpXPkZacOLZDH5JFNy+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9047



On 11/4/2024 6:50 PM, Yi Liu wrote:
> The iommu drivers that supports PASID have supported attaching pasid to the
> blocked_domain, hence remove the remove_dev_pasid op from the iommu_ops.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>


-Vasant

