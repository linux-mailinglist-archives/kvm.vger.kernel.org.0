Return-Path: <kvm+bounces-27024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FFF997AB2C
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 07:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64D272849CB
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 05:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98A256B8C;
	Tue, 17 Sep 2024 05:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EyI0EO2K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDBE4594D;
	Tue, 17 Sep 2024 05:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726552336; cv=fail; b=pAUjsrdJttg7Y4tCbpUXHpFS96guLIgmPr2+E4jCKmRzndMmfPozuM5qi6GrDvk87G71XModX/g983IdrFsPWFVSmfnkMoSncN3/q0DPW7cbul+FbKPoHP4bKfswWcFqgl89n8PXMddQMaEQtamx1lDxRwdhg8mtMzojsw7j91c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726552336; c=relaxed/simple;
	bh=JFTORQuUnDQOutI337fFVZHSHBag/Xk5GpZy6U0M530=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h23UuceWeAJkQm67fecOJiENmkomtJ6thQhbsYsrJVNejzzZgcGqv7ADne8yjTE6VD7V62xYrWg/ZCbSjMqt40Sp1rPlUFOhUf90vYsA7r4/PvJsQHoax0lK7pUkiGapthNKXJymaoe/pCXMs/+FdRgR0EtqbtcM0/6l5V2BlZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EyI0EO2K; arc=fail smtp.client-ip=40.107.236.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYhNcLTx9yljDwYF2HY/i/3xC9rLElQISB4l89iYHyww74CCHhJuGdAMmTy4tZXfREg4DS7eKq5SjPoNWozUghzn/hvI4JVKAXtGLFkv/+Il5mrrvEubF0zKH8I6QR5wFmQ/RKxP9bbZltyboqMh+YOb4O9fA+9Un5KO6jyPL/XBOMJzboT03DRctjsFF1dc/BtuChLJAoxCrQMGdKsyI643iHYH4sBpkQY3eOtJIgkzdzIFR0PXIimUQjgxkC16cxxu37Ow+QU9xktGZT5aUlShgbrERvsmP+XB/zkikaj2uU09KtTgdYkll7nzfEjtRvZQ0OC9VCpq44i73+s55A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GsT2/k4SzMLgBSr0A6qPvLuhN9Q5fapJ+bkb8JspqrY=;
 b=IHQ1oL922axGYclm42GPYg67axTRJ739wfnLp8tJ9UmrwDEP9N1kCBeOalZdJZYp+Uft/dKhcSH3WKALSolbcMPigBWkjY50CFgsFBVjw+iRftaoHDEyRqwghz+vvsGVyifY692t0tqHkAkG87mt8Z3gHsAK7Xx4+bo3TEwbQtvMz8U9b8m9RBdH0r80orG1zZ5XInLvYQRF/lHGg/La6hCVNxm4rQPbpR/yRc3tbAGdNNKAVjFqPl80pUaqV+Y62FgCxd5tCpdLUTq4M5pfb9gwzk/GEdwv3660db5mWy/sGkoawMNq2mjXWR7ythzB87FxLWTln9BJNu3vgr0fog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsT2/k4SzMLgBSr0A6qPvLuhN9Q5fapJ+bkb8JspqrY=;
 b=EyI0EO2K8zCfSsIySi2sdD2zE/meenqpqhPtPkWheg1+wrEZhLAWhd1vSSVymC3xnC+gu+rt6Yv8UBy3aUjXiiVQLAcQOfionP16EIEPaADKVwGuRSto7NUX2DogEFBlhDux29tVAty6AsiLIkPrDW9MfU6Uhz5MoYu/jIX7/BM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by BL1PR12MB5993.namprd12.prod.outlook.com (2603:10b6:208:399::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.24; Tue, 17 Sep
 2024 05:52:12 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%3]) with mapi id 15.20.7962.022; Tue, 17 Sep 2024
 05:52:11 +0000
Message-ID: <04a91009-c160-4920-a5d0-81a8e1e7cf97@amd.com>
Date: Tue, 17 Sep 2024 11:22:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: Small question about reserved bits in
 MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR
To: dongli.zhang@oracle.com, Maxim Levitsky <mlevitsk@redhat.com>
Cc: linux-perf-users@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
References: <5ddfb6576d751aa948069edc905626ca27e175ae.camel@redhat.com>
 <2e3f168c-3b0f-4f18-9db3-0cb2be69bb5c@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <2e3f168c-3b0f-4f18-9db3-0cb2be69bb5c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0213.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::7) To MN0PR12MB5713.namprd12.prod.outlook.com
 (2603:10b6:208:370::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|BL1PR12MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: 336ddd0e-a48a-470b-c471-08dcd6dcdef3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1A3NUoxMmtvZ0lsQWEyYk9EWGNRbkxXK1JrVGNxTytNaDFsSTRMejJyTFFm?=
 =?utf-8?B?aGJTdS9TTkxMdVNKQTNPNEhUUkRQTG9sUzd2THI3K1ozYi8yYk5IakdORHQ4?=
 =?utf-8?B?L0ZsMkpQbXlEOEFwRmM4OXdCeFdDOHBhYms3M0ZockdTVlhlQXRqTzZlbzgx?=
 =?utf-8?B?d1VzR1RZTFRvWXNwSFZiMUR6d0hIekpGRlJ5VENRYXBPb1JGMVhFRGJMWDY4?=
 =?utf-8?B?NkUweTZmanh2aWg4SWhEaFArbEtJVDRxbURTditIcE1TbGZzOFpFSnd0Skph?=
 =?utf-8?B?MzZwY2NyaEQ5U1QxU0N4azNJWG43Ui9YOHBWdTlkRFprM25rUU84Umx1WW9B?=
 =?utf-8?B?QkNBckZodnVpQjN4MW1vZTdPaEdPdy9sblI4cjdWMzAwcHhtNExtZzlKOUpZ?=
 =?utf-8?B?SmZTQmkyaTVVdnZzVG50UmpZV1hicUJ6bk9aaXFzd25kTFV6eVVpM2FBTmlm?=
 =?utf-8?B?MllFWkx1MVViOUM3N1k0Q3hKL2tkZHdqNVcrRkdLZ211YnYrc2NSeXNLb1ht?=
 =?utf-8?B?b3g2cEw5RmkzL2Fiajl5VXB6LzFISjdxbVIwUDlMaEowemJBc0NiZldSVm5m?=
 =?utf-8?B?M0tzaGNIT0lMR21XY2VlWjZuMlIyNU9mSGNRUjhPbThTbGJXQ2VWMFJ5Rm44?=
 =?utf-8?B?cU5yc1E3R1RxREpSSDRqVUJQV29DdXd2WEtYSDV3VEM3alRySVl4aDFOMWJX?=
 =?utf-8?B?UFFEUlludk9lOGtJZzBWeVVhYjF0MGlTaUlVU1hZT2V1RUlzYW5NaVJzellW?=
 =?utf-8?B?UVNLalFyV3lKSDlPL2VlV1p0bXJ2L1VkL25WK3FEbVlmeXFzcXdvamUrd043?=
 =?utf-8?B?WEU3bkF1UXhSZC9XRmxzaXhmNXkxcE5DRTh3MVluRW1PY2FqSmRwaFFMYXRN?=
 =?utf-8?B?UmtVWVVaY2VPYXdkdUNSc1lHY0djMUFTS0NuR3BXZjg2Q2dYVEZBR255YzdY?=
 =?utf-8?B?cUNmeDZhd3dGVm5aMHVhOUJtdUpPKzhxcEJmNVNxck5TYk15emNlVG9oMnFW?=
 =?utf-8?B?MEtNS2hVYzEyeWhIcFhrR29xR3U1cXBDa3dSS2FSbW0xbzE0MmQxZWJtWFVo?=
 =?utf-8?B?WVRxTU9ObERBNzk1TEZDL1JpSWZ6UWtnSHliTjhvZUYwZENJSVd6aUFxYm1x?=
 =?utf-8?B?VU00SnYrOUpmK2U5TW4xOEoyM2tHdzUxK1QrNStrZXZVa0dneEJJZXFDZHUr?=
 =?utf-8?B?bTlRczZ4L3FnQWEzZE4yemkrT21pSElyYjExZzJlSXVycUJVaHBuUkdQWEVW?=
 =?utf-8?B?N3owL0ZwcDA2aldReVlmdm52MGpiaFpQQUx3cGNlTUx5VkNvcTVPeG40d1VG?=
 =?utf-8?B?YkdURGFJNnRLVjVlamQzTHhxaC96Q0Qxd2JPS1BrTGNWWjc4UnZJMWN1Uyt1?=
 =?utf-8?B?anRhK0t6VU1tRFJ3dW1WSU8rUzRzMWlqeWZwaTdINjN0SGM0d21iQmw1NWJP?=
 =?utf-8?B?T3ljOUxpUTgwaEdaREZQbVd5RGNxUnZPbmpWcVEvWWRHcVBERFh3RTlWTzVJ?=
 =?utf-8?B?WmJrYXJab2NOeEl4bUVyTGhsTmZhd1F1NmJtWVFGRFVnQlB4Q0NQSURvQTNR?=
 =?utf-8?B?dnlVK1U3aHlsdU1yalBpZkQ3SUJ6TnQ1cnVUVlVBdWNpOXovcmpnSitvM09o?=
 =?utf-8?B?K0Jrc0M2eHl5MVY1ZnlFdEo1MnFTYVhoTDZpWVg1RzM4QnlXYmVkUDEzNmVR?=
 =?utf-8?B?YXZNSFZwaGQ5N1l6T3FTbVBPTWNOdHlETTBPMmthdkNsbU4zc2sxbmZIK0Ix?=
 =?utf-8?B?c1U3MzFwR0tqQnpJOHJHUDNLTW9wOHpDdGxWZ2p0ZzF4d3dxN0VSQ1dQenlI?=
 =?utf-8?Q?AaSV0/vSp7qcjNTNbqGdk1olqCQ10jjIQeRu8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzF4WHBzRlpXajd2VW9PcHJDdzZWOVh2T29RaEVCeGY3NXVZcG01dlQwRHJv?=
 =?utf-8?B?SXg1TFBlc0F6MWNXbjhJSkdRSUI4UC9RL054a1BmejVHSXpsQmVkUUVlUHFv?=
 =?utf-8?B?VE5xeUlJT0lXTE1FcDVIakFMRWpqakZpMjBLVndsV2lqNHVndktCMjNFNnFR?=
 =?utf-8?B?d2VzaVorc1kyNGI4Z1AzZW55eEg2eHRvRFhWdWpyWmllOVg2Q1lBcVpXMFNk?=
 =?utf-8?B?VUdGdWljZ2dBNGpPRWtjdnVma3hFN3pSc0pOL0xFOHlqK1RKOFdMbGZEcWx4?=
 =?utf-8?B?WWdtUmQ1K3k3dytjaEJteVpLSi9FT1pPZjVoVkNza1czUHgwUG9XaUwydGtw?=
 =?utf-8?B?ZExSK2NWTWJBOHU2bVk4dHZnZVBIV2NXM1lvUEdCSUt2NmhKMHREWklGS0E2?=
 =?utf-8?B?UXlHaFloUVdiSGQrdi9jSU56UDNBZGdzQW5aYnFGOTY4NkVMOXRLdkJNZGd1?=
 =?utf-8?B?QlpQTk9vaTVRVnFqbW5MNWhUczd0TEo0QjNGMFd1Q3pERHlSY3FNV1o5azhp?=
 =?utf-8?B?eFpVMUNydGZ5NzBjbWltd0Z3QjA1Ym4rbnZCR0FQakpEZWgyK29uSi8yVm9U?=
 =?utf-8?B?TmZ5VTRUQXZMK2N0MkNYNVpuQThHSlFzUE9lSzY5Z0d1bW5zVEVBQUVETzZo?=
 =?utf-8?B?L1FnSUkzUGlkVXJWcDhIRjVPeE1vRWxXakFlR0dCTmxVZ0RYZlBtWjducmNI?=
 =?utf-8?B?eEFGK05PWXVaczBrTTZrVUVSWHludE02VGdRWHV4Ykpnb295dnNpN2wwUDUw?=
 =?utf-8?B?MWRiQTJnQzBhckhoRmtNcS9XVWZIaHQ5L0YyVFhwNy9vYU9WbnJBR0VPMFV2?=
 =?utf-8?B?VE8ycC9sTG9MRmJzZGNnQ0RMNFpkN2E1VXR1VTYwR05YNmhmZWhvcE9jRFJY?=
 =?utf-8?B?Y1BSK3FQTDZlc052UmE4Y0NzdU5Sdlh6YVRsSWhnVlI1OTJoaE9Ea3hZZlFN?=
 =?utf-8?B?ejZMRXFYeEdIR2JvazYzVFJWclRqcUZGYTBkUlE5QWlHN2dicXRVQnFnKzZv?=
 =?utf-8?B?T3pmZmcxWkJ4Qjh6d3pTSjRpQTdsNlV5ODFvcGk0RzhZTWZNYitKRmw0K3Jx?=
 =?utf-8?B?MTNsNzM3TFJ2aHZuM3NVb251ZE8yS1N5Y1hZRjczdURvVUFPTmVzbi9TUk56?=
 =?utf-8?B?YjN3SEczcVFuMGR3aTE4WGN0OHJZOUo3Wkh3QTByZ0I2QkVNU0RRcGt1VExP?=
 =?utf-8?B?Q0x2WXpCRTdBL25jSlh1RkE4K2hPMWgrQWxVdDJ1NnhKS21mNU9aRE4ycjJO?=
 =?utf-8?B?M3FXelpPc0FVRmlEYjIwWWFHbDRFOGJwdHdGSk5tMHlpRmRBMWJOUkcvNmRT?=
 =?utf-8?B?VFd0TUtJTXd3VFlCUVVzZ0pvRFR5Wk5VWk1LR0pFRDlMaUt2WjhYVS91UDZs?=
 =?utf-8?B?RzVSd0UzMWs2ZnVLWVdPUEI1dW0xclJJaURUbUxnVHNJMlA2UUpnd2VEWEsy?=
 =?utf-8?B?Nk1GcDZtQTRLeERLcWVDWWptYzJkV0VUTVFxZWt4WXA0QkZnUWU3SDY5d3VD?=
 =?utf-8?B?K29JTFFRTG9WcnhKazdYQ1VFSmJaYnh2d2lpMTFMTFZ1a3lLZ0FTMFMyTVhx?=
 =?utf-8?B?czl1ZWFXc2NIWWxTMElaTVAwSGJ1c21hOGV4N3VVNU81b1duMTBPMElBZmZz?=
 =?utf-8?B?TFNNN2I5bVhUbWNzY2ZYWG9rcEw0UERjeXJicllnVVBmdFFSVnJwdlZUcGJO?=
 =?utf-8?B?KzFIdndoeHZwODFoUVZMVGR6T0xES3E0LzBvMUJFOTd0aS9YaElkWnFxcnp5?=
 =?utf-8?B?TU1RVEtIWGU1QXdtUDRScDNISUR0cDMwbVBybWxyRXhFcEZMeCtBeDdTeG53?=
 =?utf-8?B?Mys2K3crRFM2eXlCVTNDUHhsM1FNeDE0a3lPZFpvd1l3dFZnUkJPbVdrM3gx?=
 =?utf-8?B?aXowQ2JoNHdySGxUTGtRUXRuT0hrTi9sSmJwajBCR0IzcTJWUlcxZnRHQW0z?=
 =?utf-8?B?MCtzV294bzJNUjdiNjU4ZUlXNE1kRHl0cWY1My9VUCtzQThTK0hiS25jV0sw?=
 =?utf-8?B?ays2Z0FlT2hrTC96UlR1bXdkZk5sNHVGU3BvUXR6ZHI1OUZHbm9VQ2doQUxz?=
 =?utf-8?B?RXE0NitTVmxZZlRpdEpBVHo0aHF5M3FCSEFOdWhpajZGMWc2SzNaTlJXaUFT?=
 =?utf-8?Q?Qt2qbAnCcDX2VBJSDu3r4edMP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 336ddd0e-a48a-470b-c471-08dcd6dcdef3
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5713.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 05:52:11.7747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9WhbXtI0yU8FHS3nD8/eexaPvMPn0cFbE9vSfjXI3LG0A9pFGO4Eobt52K7X9ucRvNmylh9ETYNmaIiHLB2WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5993

On 9/17/2024 2:11 AM, dongli.zhang@oracle.com wrote:
> 
> On 9/16/24 11:54 AM, Maxim Levitsky wrote:
>> Hi!
>>
>> We recently saw a failure in one of the aws VM instances that causes the following error during the guest boot:
>>
>>  0.480051] unchecked MSR access error: WRMSR to 0xc0000302 (tried to write 0x040000000000001f) at rIP: 0xffffffff96c093e2 (amd_pmu_cpu_reset.constprop.0+0x42/0x80)
>>
>>
>> I investigated the issue and I see that the hypervisor does expose PerfmonV2, but not the LBRv2 support:
>>
>> #  cpuid -1 -l 0x80000022 
>> CPU:
>>    Extended Performance Monitoring and Debugging (0x80000022):
>>       AMD performance monitoring V2         = true
>>       AMD LBR V2                            = false
>>       AMD LBR stack & PMC freezing          = false
>>       number of core perf ctrs              = 0x5 (5)
>>       number of LBR stack entries           = 0x0 (0)
>>       number of avail Northbridge perf ctrs = 0x0 (0)
>>       number of available UMC PMCs          = 0x0 (0)
>>       active UMCs bitmask                   = 0x0
>>

That's expected. LBRv2 is currently not available to KVM guests. However, PerfMonV2 should be the
only feature bit required to indicate the availability of MSRs 0xc0000300..0xc0000303

>> I also verified that I can write 0x1f to 0xc0000302 but not 0x040000000000001f:
>>
>> # wrmsr 0xc0000302 0x1f
>> # wrmsr 0xc0000302 0x040000000000001f
>> wrmsr: CPU 0 cannot set MSR 0xc0000302 to 0x040000000000001f
>> #
>>
>> The AMD's APM is not clear on what should happen if unsupported bits are attempted to be cleared
>> using this MSR.
>>
>> Also I noticed that amd_pmu_v2_handle_irq writes 0xffffffffffffffff to this msrs.
>> It has the following code:
>>
>>
>> 	WARN_ON(status > 0);
>>
>> 	/* Clear overflow and freeze bits */
>> 	amd_pmu_ack_global_status(~status);
>>
>>
>> This implies that it is OK to set all bits in this MSR.
>>

It is, but writes to the reserved bits are ignored.

> 
> To share my data point on QEMU+KVM: I am not able to reproduce with the most
> recent QEMU (not AWS) + below patch.
> 
> [PATCH v2 2/4] i386/cpu: Add PerfMonV2 feature bit
> https://lore.kernel.org/all/69905b486218f8287b9703d1a9001175d04c2f02.1723068946.git.babu.moger@amd.com/
> 
> Both my VM and KVM are 6.10.
> 
> vm# cpuid -1 -l 0x80000022
> CPU:
>    Extended Performance Monitoring and Debugging (0x80000022):
>       AMD performance monitoring V2         = true
>       AMD LBR V2                            = false
>       AMD LBR stack & PMC freezing          = false
>       number of core perf ctrs              = 0x6 (6)
>       number of LBR stack entries           = 0x0 (0)
>       number of avail Northbridge perf ctrs = 0x0 (0)
>       number of available UMC PMCs          = 0x0 (0)
>       active UMCs bitmask                   = 0x0
> 
> 
> Both writes are passed.
> 
> vm# wrmsr 0xc0000302 0x1f
> vm# wrmsr 0xc0000302 0x040000000000001f
> 
> Here is bcc output. Both writes are good.
> 
> kvm# /usr/share/bcc/tools/trace -t -C 'kvm_pmu_set_msr "%x", retval'
> ... ...
> 4.748614 19  43545   43550   CPU 0/KVM       kvm_pmu_set_msr  0
> 10.97396 19  43545   43550   CPU 0/KVM       kvm_pmu_set_msr  0
> 

Thanks for testing. I cannot replicate this either with an upstream kernel.

- Sandipan

