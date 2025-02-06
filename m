Return-Path: <kvm+bounces-37427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCB0AA2A039
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 06:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63C9F7A3A71
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 05:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 219C1224889;
	Thu,  6 Feb 2025 05:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="C8Os7qkd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2052.outbound.protection.outlook.com [40.107.101.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9504B223703;
	Thu,  6 Feb 2025 05:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738820526; cv=fail; b=K8+BRlKkaoc+5E3MqH1GMsdB8k5jzsXw36HQl+tkn79aYemixVkWSRltn5SMukngtJi7SvT7h5zu7wXEGUYWg+ORJ+PKEvTfYVs4ovLAYO04w0K1ph7Cth5ijPNpbeIIgeqfxDNnHWdBL8qXYc09CarMIzfjF+HuOfxTmD/kILw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738820526; c=relaxed/simple;
	bh=uhWNocZRZKjyjWLfSh6IwTJtjxO0L+OY9rxESjZANLM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rj4pe4W/8dx046l/jPGpva1EK/U0IfRAwrwDtsgqXVFexXFozgN84VoXU8qMhY48qEEabCyz6StQs4V8DIyVh2NIjeVfOJQKP2mHjhU7cAjbS6Aigs2BpmFst00Lz229v/jkFM82/L44i/uM/AzjG4MmvjOwUEbNRls3lC5wqh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=C8Os7qkd; arc=fail smtp.client-ip=40.107.101.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=goYDntZrxQ++iUaLpI/w9kw4ldfB3pjYvo0sTeCZ7EKnS8Uix72wwPp2chjWlZ7m40wcqarkAZigXPLP8QXEi94g7t/n8YisigcrQvckj7kwB9wxWgLX3m2OwWKEmCSmowx5A+V4i3P9ItOom2ncvXe5lPw2zJ1DGGRXW6Jo82/Sg8UUuEwEB2ITuL4E8fpBu9gtaZMMLwzxlUml49lk3PTOxjGj1koXPrnpIMBZuoYlf7/VrIwJv2uc6UoUChHlUqGFZSoesqn+n2IJo74E8YjglwzpxjhgiAzOu5/wfYg+QG+Dc+L+Z8aKKeAVPEXMy9dhpZmimmHQ2Fdz/QjnZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ozGlKHFennasnNlmAeXZ225S6wLQwXPPDom976F5zs=;
 b=eUX43epTu4h00sgvFLV0Lc2Scck2SX5osRO7aywfLw+WSHcEUXOgwf4h6gEaYc0pDI+x8yvCrVa4eyRfOpPE00BFAtOvt29kqDFrPwaY0aJyu8cJN/uD4IoBSW2huY07183QT6YfvSHyU5yDOSVrrmYZs9nHLI2k11eocDerETeTKMcJ2VLfA4fs9d0Uyc8iBE3lurYgm7s1MhWQaCrWrqHed3t44gGQLm+6nrC9Nrp0N+0/0WJjRVdzqNNkPiZvr/p6AmJE5yddUZsm8v4eVZtuJjzRbjQo4K7oPXuzXXQQ+e995Vr4TH7fLNLmseDzlRTPY/RUrFIlD6gxa/Zu+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ozGlKHFennasnNlmAeXZ225S6wLQwXPPDom976F5zs=;
 b=C8Os7qkdt9GErgE8Im/mFfrkevj/vUi7tRwFcXX4IsLQzWErSx+o7FdN/kwhUQo5mjAdKUTThvVtCVKtMRVKs7S8M5VW48+guayM+OGVBlZd+iWazRv6dvgD0T+lVwgZgw7hhGDyH8i3SsOWICPNx/kdS+PncAPXXAza3CUW8vY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS7PR12MB6287.namprd12.prod.outlook.com (2603:10b6:8:94::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8422.10; Thu, 6 Feb 2025 05:42:02 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8398.025; Thu, 6 Feb 2025
 05:42:02 +0000
Message-ID: <8a4e9350-8a0e-469b-969c-25cd81926f7a@amd.com>
Date: Thu, 6 Feb 2025 11:11:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] x86/sev: Fix broken SNP support with KVM module
 built-in
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com,
 dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org,
 kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev, iommu@lists.linux.dev
References: <cover.1738618801.git.ashish.kalra@amd.com>
 <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
 <62b643dd-36d9-4b8d-bed6-189d84eeab59@amd.com> <Z6OA9OhxBgsTY2ni@google.com>
 <8f7822df-466d-497c-9c41-77524b2870b6@amd.com> <Z6O8p96ExhWFEn_9@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <Z6O8p96ExhWFEn_9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0156.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::11) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS7PR12MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b2babeb-1128-45ec-95c8-08dd4670faea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzdrajY0ei9YcHNpVnQ1dU9zMFdteHltSG9USFdvZHNZSGZTbTJTUitlU3FJ?=
 =?utf-8?B?T0NJd0JLSVZvUlIyQVRSSEd6aWlFTnVJeVZTU2haaysxUzVwYmU2UkZISkJK?=
 =?utf-8?B?ckFZZlBkWkJkK2E3L0RlK1pmQXVrR0FqZERHRHQxY1IrNlZ4K1lqb3JpNnlE?=
 =?utf-8?B?V0VCK2JlbUZUUVJqVUJZVlo3MnBJTE9Nclk5UThHYlBSWmJkYkphY2lYc01W?=
 =?utf-8?B?Yk5XZ29yRzJRRzZNcFk4eENYenQxdm9xbTlqTS9Ma3MrOXczNyt4YVZPdlI4?=
 =?utf-8?B?VkpnY0x4VG1wR3dGSmkzeVFkN0k3MWhYeUtaU28vY2d6Y29OcUdKQ3lKUG4z?=
 =?utf-8?B?TWJxOHNVcXNFcWkwZGFtU0lJM2t6bUM2Y3NZRm1hN2M4TURJS01la3dvUkEx?=
 =?utf-8?B?c2NHc0dCNy9xZWVyaUZIbzVRYmFuc1UrNGRoTzRtWGRqajkvdTNtdjAvUGpn?=
 =?utf-8?B?dUhobWw1QnFOOHN4cmluWnE3N3hQa3RDNUozUTdZQk5JTVU3dFFWT0dGRENI?=
 =?utf-8?B?TmUvQzFBUlM1anNJamNYMGtZaXcvSDhIRVVFSkNPV1grNkxGSGpOb2lYNTZF?=
 =?utf-8?B?ekZXZDBpL09GU2FGU2FUL2dzSjB3THhCcGFMTlBiNFdKcm00Q2pZVnFZcXg4?=
 =?utf-8?B?akZHS1NPWDhhUldzOU93dmJTT1cwZEtKdkpBSnBSSzZubDk2aGNxUjRVVHhr?=
 =?utf-8?B?VEQvaWo1UkdKd0ZEMWtMSmVSTFc4WmNhV2JvN3VFQUM3UTF0QmtQTjAxeUxU?=
 =?utf-8?B?TjJFa0VLYmJIVUJsUG81bEdFeFhCODUzQ2kvSmNhTzN4RDREcEJIbjAycE55?=
 =?utf-8?B?NDVnRTVGdUYrNFYzNS93MFpPUEhCQXhCVFVKenNhSnZRdlFhdk05TXRXUmZo?=
 =?utf-8?B?VVFteVFEalFvQVdpVHFDRkppTm1McmJaaGprM3lvSHllTTFDSVVaS2VrWWFQ?=
 =?utf-8?B?NzdCUDYzQm1HblIxRm13OXBheGhiZC90VFhicmpxTnAvWk1IeDBnY0RnM0U4?=
 =?utf-8?B?Ris4M1pQR1l6bDdyc1BFeC9selR2YmhPZjM3WTJWbWtjNzM4NUkzQzZxZCtI?=
 =?utf-8?B?ZXBRTEJHMEFDNjVPYTNNVmVqd0h2TklIYzByQ0RPaDE2RWNhSmw4azJ0c0U5?=
 =?utf-8?B?cU1aVGl4cXE1OFRyWHg0MXF6c3ZXa2t0dkNnZW94QlNNRDNIYklmNnQ4TStq?=
 =?utf-8?B?NzNObzNVYWUwcFQwZFBoNkhmM3RUTjYrOERBVWlBWXByOTEwUDVnN2diY0tu?=
 =?utf-8?B?bnV2RVNJeksxa0VRY0g0OHJOM1hLVGVzam4rNDJld2dYYVcveXFIOCszQVR5?=
 =?utf-8?B?cVl2aEZYNzZKR1l1T2RjOUlpSHFCczNuQUluZkEwdnh2cnRvbGZWS01TS3A5?=
 =?utf-8?B?ZHJOMDk4ajJEUGQvNE1YU3g0YkQybXhHOFZvdzI1Um9Na2JmK1NzVVVkUEN0?=
 =?utf-8?B?Q1hSdUJ2NHdvUXVYMXJrb09XaG1nMFVIdkNnc0JQdmZya0luZzc5eVNoUzhs?=
 =?utf-8?B?M3ZzUXdHdWtGait0dnpjcGdsbmp6czVGREJCYStXamJXTWJBb09UZnhueWNI?=
 =?utf-8?B?MnpUb1ZVclV3R29XdmhvMTQzOFQyeGwwQWVTNjBSKzIvVkthYzRzeFV5QjZF?=
 =?utf-8?B?V0h2QUUwNXVIZWxKVitzdTZoYk05Wmxuc1o2ZVdiK1FTM1ZwL2RWdEZsRWNq?=
 =?utf-8?B?bHV3YUhQbnY1TmJzK1Q3aTJKeGtiNURRWVVoUGlRallPR2VVUWxLUVpUaGtQ?=
 =?utf-8?B?a2ZuR2VSYndzNlRGcVpYblBqaGNIanZ4clEwa201ejFlTFppa28xQ2JTYWJO?=
 =?utf-8?B?TmpPY29QWG5VTE44NlZKOUtXQ1RoVFFrc0RXWlY0MjBuS3QxOUdMQ00xaHdW?=
 =?utf-8?Q?2z/NfnO3MzVLA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZDFYZ2pJMmx6UFVENm5pL1YyTE9FaVhxNjdPbWY4a05VZFc2aUVla0hmTTda?=
 =?utf-8?B?U2pENEYrcWhyVjVhMEtwWXQxek9RbDU2b3U0amQwYzNPTzIxR0ViVEY2aEty?=
 =?utf-8?B?ZVJ2b2s5UjAyYVlmM1krK3oyK0lsQ3Q1V2Z1ZVM1YjA5Q29OZDNCUTRzVXBJ?=
 =?utf-8?B?by9GY3IvSUIrcXRYK09BKzR2eitTOXZ3aXh3VzVkUEU1eXF3R1BWT0tXM1ly?=
 =?utf-8?B?UW5SN2dFNFgvTUhlcHJzd29mV1J3SUxTVzdTaU0wNUF1WWFLMnVJTytDbXox?=
 =?utf-8?B?VjZ3YSs2NnFQa212SjlrQ3VYNWp3QlFLME1VWTEreUpoNnJjc3RkVDZPR2J3?=
 =?utf-8?B?RHBGK2JueXhpQjZ1WHZYSDJ5b3VMd1NjMnZHakExZGE3TWMxK2lzOUJrNSs4?=
 =?utf-8?B?S0J4RmZOV21RRWNaUDl2bzI2d0FOU0lWRzF5KzZkQXZFa045cks2VkRuUWlw?=
 =?utf-8?B?UjRJcEM2QlkwVzBTWVVoV240YTlaYzJFQUZwNDA3VmxvVkZGTmxHcWQycGQw?=
 =?utf-8?B?WEd6bmVXaFNJWWxiM1M2aTc1ZFBmUFNYakozTysyVm8wZ0RJSHJwVW1vdkxK?=
 =?utf-8?B?YnNHbm5mN29vZmpxaWFRcS9xNjZmUVRDWnZ1elNpaFpDaXVMU2pjaWJFMTI3?=
 =?utf-8?B?WkREbXdDa2tERFVSdHMxeTY0amF2a1BLWXNvR0sxaGMyMVVva0ZNVUFML05w?=
 =?utf-8?B?MVRJeFlOV1pHNEhMVzlMZjZCU3RVU1BiWUdkWE00MUZCU083UnFsRUVRa1RH?=
 =?utf-8?B?OW5HdVdGd3E3RW00NXZLNmpRK0lreEZweWNqTURwUGY2T3YxL0lMZXJtWjVR?=
 =?utf-8?B?QTVvNVcwZGY0cnRjNzVxUmFOWGxVWWJwUng0YVQ5czBrMndqb2pOOE80OEw5?=
 =?utf-8?B?YmhiM3VFSkZ4MFJqM0c3TDdaWFRmUVVjdG0ra042M0JmdDFFbWVLTUVpZlF2?=
 =?utf-8?B?dlJEVXpwU1ZYTXM2Vy90Qzl6bnRlUTYxNWFENTlmVXE0ZW5vWElhOTVhS1JS?=
 =?utf-8?B?QlpuQnNNNEtVc2FSeGR5b0thMEEwSnYyQyszY3dwKzR2NjFLTlN2ZWgzQ3Zl?=
 =?utf-8?B?S1Q2RkFOcnBrVllKRkF0YWVWRHlyZnpCTTNWQTJEK3BKY0dJTk5wZGsxU21L?=
 =?utf-8?B?OUxPSitzK3NXQXA4M1dDUnQ4M3YxYjFrTXFMa043Nmk2S3FKY3NCaFhoQURm?=
 =?utf-8?B?c2M1Mm8xL0hEdVRuZU1yL3FRSFBzd003eTJsTEp6NlhRYmtmcDJpQUF4SkJl?=
 =?utf-8?B?Rk5CUEV6SS8vZG1HTFBFeTl3N3dpVDEyZTNJRGI0WlJYWjJydmJZVHFMZ3VK?=
 =?utf-8?B?UStTcDlIeW5sVzlsZUxnN3VDREpOYzUrT1ptWTJnL2ZHQmE1czJUdTZDZU1s?=
 =?utf-8?B?WGRsRFBNOVkxS1Bsa2NUZGx3WGVFQTNVTkpFcVd4eHMrTThzT1psS3hFSE1n?=
 =?utf-8?B?aW1QMmx4cmJjZy9GU29DaXM2d0tBM1hmM1pNclYrMFNPQTZpZEdxYnIvWDQr?=
 =?utf-8?B?RUhpUWJEWE5TUW96Ymtvbkl5c3RVWFA1emtBWFFQVGVja2ZXdllxbDJRclJw?=
 =?utf-8?B?ZTYzdmozV2dZeng3U0VnOHRwdmlpZXRYUEdmRVhRZGNTclJIWUlpVUVSR0p1?=
 =?utf-8?B?eUhQaWU2bVpPMEhuSUJkaUZWYmF1QmNJbERCTHBHcVFlWUh5ZzNXM0R2Rkpw?=
 =?utf-8?B?ZjNnc2pPZ01PTWV1Mnl2VGJaelBRbW1PSU14M3VvR3NyZDlvS3NCQzM2bDUv?=
 =?utf-8?B?VytUN1pqRHVEcXlzVUM5bndqMTkvcXl4bitmbGd1dmFuY2JlcFNITDgycTFw?=
 =?utf-8?B?aEgzTXdGK1daQXlsUE9KVEhUMklveHB1SjFxY2ZJSGdrcTFlRmVFb2c3elRv?=
 =?utf-8?B?SVFhcHUrbzFrUW1uRTNka1FMMEROUGlUQUkwV0pjNnduazdabTR0M0RUS0JC?=
 =?utf-8?B?cUhybktNVGZkUkdkbTlVLzMzbktMWVBLN3IxTWNMMHdIQ2RHU05yWnU2bTBt?=
 =?utf-8?B?aDBYelFKbkJHaEZwWlBuVHl1NU1jYnhqZHZ2TjFZaCtJYjhONisrZ1liZU9a?=
 =?utf-8?B?dE5YYitaYlR0QmtISElla0ZFQ2NqWnZubWZoekVURUpXSWlHRjhOZjYvZTlp?=
 =?utf-8?Q?ssGs0IxVNW1/nYLywdEQZdGMi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2babeb-1128-45ec-95c8-08dd4670faea
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 05:42:02.0005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUoFgZJXLRrP+IqD+xnvhnRUqXcN/lnYLLlVXrN+EOU1zYtPCAk4+ngyydT72DXUpUTpiyR3xa6N4OU2kyLjZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6287

Sean,

On 2/6/2025 1:01 AM, Sean Christopherson wrote:
> On Wed, Feb 05, 2025, Vasant Hegde wrote:
>> On 2/5/2025 8:47 PM, Sean Christopherson wrote:
>>> On Wed, Feb 05, 2025, Vasant Hegde wrote:
>>>>> @@ -3318,6 +3326,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
>>>>>  		ret = state_next();
>>>>>  	}
>>>>>  
>>>>> +	if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>>>>
>>>>
>>>> I think we should clear when `amd_iommu_snp_en` is true.
>>>
>>> That doesn't address the case where amd_iommu_prepare() fails, because amd_iommu_snp_en
>>> will be %false (its init value) and the RMP will be uninitialized, i.e.
>>> CC_ATTR_HOST_SEV_SNP will be incorrectly left set.
>>
>> You are right. I missed early failure scenarios :-(
>>
>>>
>>> And conversely, IMO clearing CC_ATTR_HOST_SEV_SNP after initializing the IOMMU
>>> and RMP is wrong as well.  Such a host is probably hosed regardless, but from
>>> the CPU's perspective, SNP is supported and enabled.
>>
>> So we don't want to clear  CC_ATTR_HOST_SEV_SNP after RMP initialization -OR-
>> clear for all failures?
> 
> I honestly don't know, because the answer largely depends on what happens with
> hardware.  I asked in an earlier version of this series if IOMMU initialization
> failure after the RMP is configured is even survivable.
> 
> For this series, I think it makes sense to match the existing behavior, unless
> someone from AMD can definitively state that we should do something different.
> And the existing behavior is that amd_iommu_snp_en and CC_ATTR_HOST_SEV_SNP will
> be left set if the IOMMU completes iommu_snp_enable(), and the kernel completes
> RMP setup.

Thanks for the clarification. Patch looks OK to me.

-Vasant


