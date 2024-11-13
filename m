Return-Path: <kvm+bounces-31805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D4C39C7D4F
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF9BA1F235F9
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EABB4207203;
	Wed, 13 Nov 2024 21:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1atKIqZk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925F418B481;
	Wed, 13 Nov 2024 21:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731532085; cv=fail; b=sPoUIyL2/0BEyajoYHC4kZs+xBdklugG7k6SrdFbBcTuAT5WCyAl3ZUbTE8PVYH/TWNuzwIsnSbSSyCc7m9Pw1bduP1/hPVg8BWI8mejTfvQjH0OQuaIdbJFdK7r1OVsl9NE3uJlk0PaoS33sHO4oCJkRVPGeDZ4seZkzJ4uTXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731532085; c=relaxed/simple;
	bh=i8uipLTUO+6Uw1l/qB6TuxhvaLip13vjOGSkg4jNWRY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DcR3yv3pvy7uQ4rKLmmrmMmKeUsskVabUECW3HD5jjTxLY8DUChdsylhFgL8D5v1GTkIBY32knljPLZ2v/3ZZepLa2rQ6ALbCpGsSK/IEmWCj8ML3Jl7Fx4g5D73BBrTWcAmBbDT9PxKUYCB0zCXA/Pj/fXrnBG+8an5Ii8Saq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1atKIqZk; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tACJRF/qbr0DAy+WyeakNZ9CAwyk4ep+UWzppdS8D5jU8IL6vAvQa8D8oE8mWkQ2HmfqrMByGLvFkilSL94MWiJeT26nLjGOAPZhvlJk3TskqpDIra7EbXgjR4NmYzLL4jP3tbFC7KaYr4Qdz4Agl4O61uy3Zip8vgLvF1Ge4p8JTH/Zg6ALoaLw/pPBqGXWfUmF/6zE/hzv+wKg9zcKzf6I6g/kMx4UqDiWunyaToMYRV1TClnn1qJNfklZ7r5Yh5NpASg1RqPk8GBRtxz+U8fonWOXTBNu868wIHkZ+/iVuzI6NDTNYo3bYpxW4A5GlHrlYdyXqwmjdFrjywBO5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gI2qV2jw7tc95DB7js6kLSnTrwGmk6buc0QNAz4SGAM=;
 b=LQuUnX/rzqoFvmC30XOUK62Hanu15G9dxsbUSIY+6exM+HnrnfpR9JvybK1qy2xd9+CxXFSGzfZdZocr9NJk+DjobvoZBcYDQiocjS6z1mV1d089S37KWNOItmjnhnO8Ss78nAVjE7YOcQWwAdF37Kp3cY/7lomvzS/mNkv/yceT+RmXcg2sAa7QEB1p2aRlf7N55/L+V5HnVPn/PtKouDcjzF4OQW6Pc45qZJcuNx+Hne/3+gqHuL5QG6nTnzHvILwl8fNRWbCLa9Q26rpgMih5sJHirAJLUboht24aYfFZlGw37nGyz+4IYqi7++F2pFTFgecwtJ1LwhYhztpD/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gI2qV2jw7tc95DB7js6kLSnTrwGmk6buc0QNAz4SGAM=;
 b=1atKIqZkSCT+ZTpksAA5Xckh8ni5ylnEfQcdoA46beVR2YphbyvqIZRlM+gwL+TgsvLRUZaRwgM+2HfrgrX29/PN4mRszU0Rvcpi/T+OMl1qrv/qzpJ4jWztl50alDh9I2UF4GLpQS8d3CqWpeu/slAcVmkx1raKqe8SKg/kbdM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by DM4PR12MB6111.namprd12.prod.outlook.com (2603:10b6:8:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 21:07:58 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b4ba:6991:ab76:86d2%5]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 21:07:58 +0000
Message-ID: <49ada2d4-c876-1310-6bdf-3b0acf8c8dd1@amd.com>
Date: Wed, 13 Nov 2024 15:07:57 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Convert plain error code numbers to defines
To: Melody Wang <huibo.wang@amd.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 kvm@vger.kernel.org
References: <20241113204425.889854-1-huibo.wang@amd.com>
Content-Language: en-US
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <20241113204425.889854-1-huibo.wang@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0042.namprd13.prod.outlook.com
 (2603:10b6:806:22::17) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|DM4PR12MB6111:EE_
X-MS-Office365-Filtering-Correlation-Id: adecefc0-fd9d-4e1c-675f-08dd04274069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTBwWFBPN0w0U2tpSkhJTFpxa0pSVnpOT1AxQUZQWVVYOXZkVFI3YmZ0bTFG?=
 =?utf-8?B?ekpwSkt4V0xSWmF2K3o1TW92YUR1WVVpSUhDeVpoYlhQVjdoeVZmWXRoaDFq?=
 =?utf-8?B?R2Z0b1B5K0taN1F6OUtXMWhGWXRINm5DK2szSVVUa2FvR0VNWFJjYWVyR3Nh?=
 =?utf-8?B?YTIwN0ZCWEZxeWVvVWhjbkE0dnZOWGxHNWFmVHVLN1Q4cjB2YVpaNGNHSkpt?=
 =?utf-8?B?SE9rN1NuSHpkVVY4V3hiMElLVEM5OVlROE5kVXgrWFRRTnlmNU5acjdrWFNu?=
 =?utf-8?B?TVJqQmdKMmV3dkIyOXByODVnSGxKclVycVphdjVHeW1pNG13NlhMY294QWxh?=
 =?utf-8?B?NlJUcUM4RGFNVVBlQncreXhGV0NORm4vQkJZN09aWTZQeFhjZ3FydE44bmtQ?=
 =?utf-8?B?cHMvcEIzU2p1TWk2YjljS2JnN2lzK1hsVWNXYTVubnFLKy9URDVJd0VaK0lq?=
 =?utf-8?B?L01aNWZUUUlTUTd0M0lIc0FXczhRUzdyTGViSGxUYVNjWVAyWVlMcnhvK0hL?=
 =?utf-8?B?YmVPTDdUMWhYVkh2ZWtKTXl3Z0Q4LzlpMGVpcFFmQXV5Nk1KNkhxRVBlamJi?=
 =?utf-8?B?TncrMWsraUJxTm56NW9kdkJQeFQ2UnYxelM2WXc0eURGUzFSdmN0a05CdlB6?=
 =?utf-8?B?NHFuK25kalQ5Z1Nob1NGSWYyVHFUdXdyVW9VUXJtRzlWK21kdnZtSmhqYWda?=
 =?utf-8?B?VlJtRTFmTVlmTUtibGNJc3o2MjRjWkU5ei84VDB1UWtSZEV2Snc0cnNwZ2dI?=
 =?utf-8?B?ekh5QVdhNFBML0ppYVBJNVhyU3p6akFDengrZFNDSDJlaEVvWTQ2YmdDWCtv?=
 =?utf-8?B?R24yRkswNUtlUDBhQmhsblVlOXpnNjlTL3N5L2g0OWRoTktFK3BVMU5RMXUy?=
 =?utf-8?B?Zjhnc0ttenUxL3grWlNnaFIwYmpNVkJQdVVrejVRWFk0RmpZQ2EzR0pVU0Ry?=
 =?utf-8?B?K2JwV1BnVDQ3VUVCTWt6ak1rSHNkZWRhQVJkMmxWK2ZlU0c1MEdJQUFmWU53?=
 =?utf-8?B?bytySU1KaDdGK0diT3dRQzJyd1JMTnRBSmFwTmxVY3YrOFhLUXRJejZoL2ZU?=
 =?utf-8?B?UW5yZklPL3FEQnRQbm52OEZhczJaY1RZVFpvUEp4WjkvY0hyQXIwVFB2K2oz?=
 =?utf-8?B?MUFONXFPZDNRRDF4U0drVDRZTXRSekkzRUtpSk0xMVBtYWtLRGdkUzRFTVEx?=
 =?utf-8?B?QU1qZ3B0VWdkaXlYMnVPdlB3N0tybS9lbUg2RG1CeU1lSVFycnZXcDFsZ1RO?=
 =?utf-8?B?U3RlYVFab1JxZGlVR0YvbGVMcS9kUTNzbHJHUzdOM1gzWFprQ2NES05XZ05V?=
 =?utf-8?B?VW5MTVJraklhNUFra1ZxZElNSU9uS3Z1UFllbFZSQWdTTVltSFNYNG5CUXcy?=
 =?utf-8?B?WjVSM1ZQU0g1T2x6TDMzd0E5VEJ1Y1hTYnJSWXRuZXBFU0s2blNXd2xMeS9W?=
 =?utf-8?B?VFgvZklwak1OU0RrUG95UHpqbDFaYzBPc2ZyNEpkd2l6TERHdVNWOU5WODhI?=
 =?utf-8?B?VnZZRTJGa29DeStBUFI0Mk5BWTcvN2JyamJzUWpZUm1mcXg0b2x6WXprcEVj?=
 =?utf-8?B?MEdiTHU1eGs4djBUTW9iWStzckF5WGhRNnhpb2t3bjZmN1NzMGExaXUzZE9t?=
 =?utf-8?B?K0FsdndOUVZBR25wWjRuS3VmNmR3OU93VDgvbnVPdU45TllGZkFHa2NzRndR?=
 =?utf-8?B?WUhsR0J2Ujg4NnIyczJ2VWtveFRGYXAyQWZ0OVNFejNKZXljUytYb1Y4VEtj?=
 =?utf-8?Q?P961VsKlX4Ynl8loXMXBlH2y+GnajD3kyYA9Fe8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVZ1NjUxSWxBNTlTNkM0TWtxMFAzOXVsUEhkMGlYbjVxMlpLTHIrZWJ4WGVj?=
 =?utf-8?B?VHBoWlhEMDlhYWpNdytkYUpmTkF4Q1VVaE1kVStNWnc1UUdKTlNuKzJCTVJG?=
 =?utf-8?B?NDU3WUh4NXFtY3ZTQmlOQTNSenBSS0UvcWhaRmJ5cUZVTjFQWTUwVGpOallT?=
 =?utf-8?B?cFA3RVJib1RtRDZ1MWR5M0VMM1M1bHRZTm8wVDQwUGhWdHBwSTF4SG9XVFZ6?=
 =?utf-8?B?cGxwQ1BYY1JIM2hHUVFNT3FNbXNab2FJeEtsWm9ndHdlVFFWZDNmWEtFT2tR?=
 =?utf-8?B?M0U5aTNkNXhtZkRoR2RsR0tvT1dwcWxRTGwxTGt5cEdJZ09sU0I3VTdGY3dJ?=
 =?utf-8?B?QXJZeWxPZzlmWStvQWE0V3hnSlV2aU8rZlFjcGlFOHJ3SmxyUzcra0wyUEZv?=
 =?utf-8?B?djJaR2xCdWhkbDBuSFJxZU4zd2JsL2RVWjR6R2ZxWUNnbnVaL0ZVbnJwemtE?=
 =?utf-8?B?WWJXZTMvd0xsNlo3MGFyTWp5aVA5WEhmUFd1S093Nnh0d291ZkJKVi96MlhJ?=
 =?utf-8?B?Vm9WcGZveHpuTSs0KzlNNU41bWE5WWFMdjdmcFdOQ2NYVzQ4d1NIdWxMMmpT?=
 =?utf-8?B?NFJUR2NMZnVQVGJpOW5LSXBDRUllZmZwQXg5WXdUZGNvcTA1bmdNL3V4N3FX?=
 =?utf-8?B?dVZzUHlyczBkcVdkSWJvZldqTVprdDFvUjRFQkZlUXEyNlg5dmNHTDhFOTJ0?=
 =?utf-8?B?Y2RHUVU5ZzZxM2lzNGxMb3hYaW1ha095ckxkcExDSnRmbDdzQk9Ld0h5RHZw?=
 =?utf-8?B?aU1ydGI1ek1SUVN2cm9JU25UaXFWTEo0QmVIMGw3RThzZnM5R1dvR0Z1OHps?=
 =?utf-8?B?NGFKekxhcTYrRTVCVk9FbUY3UzR1TnFPSFVZVTg4NXo0ODNBTDhQOUlIOWdp?=
 =?utf-8?B?OHUvMUxNN3RROVNOMW8waVI5eHZkdElYdWlOZXJsUUJVSlJwMllORnZZY01L?=
 =?utf-8?B?RmxEUGJiTDNGcUkrSVNGeVVaaTRyd05iVlhKR3puWXpQRVAvbkJkS09ZeGd5?=
 =?utf-8?B?eStsV2JEb2VHWUVQQ3VwRkhyUk1zTTVnbUtCNnBCWEtMNTBzMFZJV20yNjZm?=
 =?utf-8?B?WlRPVDdzR29OSFp0dFUxOTFqS25DT2dvQURNVnl1RDYyQitCUUJtSkpCZDY5?=
 =?utf-8?B?bnBxTjJCYzV4NnFvbFBUU24wQ2pRaVR5aVIyMTczM2xCRFNzOERSMGYvcFg1?=
 =?utf-8?B?STR0cDM1clprUmE2WmcydWtCTHd5cXZhKzJDTW90Y210K3ZWTHA3SWdiWkhj?=
 =?utf-8?B?YkFNN09KTmdWRFdkaTMxQXhMQ0xmRDJjNHFjUXpaclBnK3p4MnQwRCtnd3Rw?=
 =?utf-8?B?VjFCQU53bWhkQ1RDd3RxcHhaVXlSdGVHTGRQOENkMW0wM1A5QkVlUzZ5RUpt?=
 =?utf-8?B?cTQ5OE9YTkJ5WWhHZitzRXBSUXNPZVppMzVlSmdTc1hvZFZaaFJ5KzRwRTI4?=
 =?utf-8?B?U1Jzbmd2S3dLNkRvZGZPTFBibVFuUjFPUlZFYU8zZG5kdFNPK3hhMmVRUWZY?=
 =?utf-8?B?aWtRampGUW93a3hJbU1OUWxNa1pOZWdpN0xvNFg3aHBwaXo5SlFyakhEMHdO?=
 =?utf-8?B?eWd0Um54Vlp3OHFPb1F3eGh4T3ZyQlZRejhTR1diQkttQm9NdGcwbXhqaXZw?=
 =?utf-8?B?THBJaGNrWit0a2xEa1lVSmdMRVdVRHpVN3JwRDF0Wm4zMmNzc0syYlJQay9m?=
 =?utf-8?B?TGZlRk8zcndINHpwcGVjMEhLRlJFVFg0UCsxWlFqYjc4Z3Z1SnhnZG5FZHIy?=
 =?utf-8?B?MHZCVTIrOHVhS3hubXAxL2EycG4rbFhyOFdGMW9wVWlmTEMzWDhERk0zMlhH?=
 =?utf-8?B?RU9ad25BZ2U1dmJHZ2V6TGgxcW5TWUFGUVFYOEoyWEhvQkFab0RlZktWTURs?=
 =?utf-8?B?ZWpkYldKMkNtSE81RWZsMEY1c25HSW1iV1NOY01ZQlAzS1gzNGN4OTlnZTZX?=
 =?utf-8?B?Y01jS3ZvQm1mSERIck1INTJvZ1hOaURaU1plWE05SzBTS2FKV05jTEpmaStm?=
 =?utf-8?B?RjU4Q0tSZVFXdUZyUWpHa3lxMi9vL1k3NDljQ29tNjlMNzY1QzNTaEtNS3Z2?=
 =?utf-8?B?b1ZKQVVnbmZuK3pJZkVweVVJOHJWYzNBQWhCVHcxbURSYlRjcTkrb1I2Vjlj?=
 =?utf-8?Q?tmgZrirUsYFPUDmQZvfAKzHWS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adecefc0-fd9d-4e1c-675f-08dd04274069
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 21:07:58.8747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WkkgRYnEagwGkx1s4tAR8SJIReO1EQmfcqQ8burbbiUkfLB2+1yswZ+RrN2jAVTjy5Y+UJnUGvVG7K4EtuRbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6111



On 11/13/2024 2:44 PM, Melody Wang wrote:
> Convert VMGEXIT SW_EXITINFO1 codes from plain numbers to proper defines.
> 
> No functionality changed.
> 
> Signed-off-by: Melody Wang <huibo.wang@amd.com>

Reviewed-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  arch/x86/include/asm/sev-common.h |  8 ++++++++
>  arch/x86/kvm/svm/sev.c            | 12 ++++++------
>  arch/x86/kvm/svm/svm.c            |  2 +-
>  3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 98726c2b04f8..01d4744e880a 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -209,6 +209,14 @@ struct snp_psc_desc {
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> +/*
> + * Error codes of the GHCB SW_EXITINFO1 related to GHCB input that can be
> + * communicated back to the guest
> + */
> +#define GHCB_HV_RESP_SUCCESS		0
> +#define GHCB_HV_RESP_ISSUE_EXCEPTION	1
> +#define GHCB_HV_RESP_MALFORMED_INPUT	2
> +
>  /*
>   * Error codes related to GHCB input that can be communicated back to the guest
>   * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c6c852485900..c78d18ba179c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3430,7 +3430,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  		dump_ghcb(svm);
>  	}
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
>  
>  	/* Resume the guest to "return" the error code. */
> @@ -3574,7 +3574,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>  	return 0;
>  
>  e_scratch:
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
>  
>  	return 1;
> @@ -4121,7 +4121,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
>  	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
>  
>  request_invalid:
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
>  	return 1; /* resume guest */
>  }
> @@ -4314,7 +4314,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		return ret;
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 0);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_SUCCESS);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
>  
>  	exit_code = kvm_ghcb_get_sw_exit_code(control);
> @@ -4364,7 +4364,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		default:
>  			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
>  			       control->exit_info_1);
> -			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
>  		}
>  
> @@ -4394,7 +4394,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  	case SVM_VMGEXIT_AP_CREATION:
>  		ret = sev_snp_ap_creation(svm);
>  		if (ret) {
> -			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
>  		}
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c1e29307826b..5ebe8177d2c6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2975,7 +2975,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
>  	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
>  		return kvm_complete_insn_gp(vcpu, err);
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 1);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_ISSUE_EXCEPTION);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
>  				X86_TRAP_GP |
>  				SVM_EVTINJ_TYPE_EXEPT |

