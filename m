Return-Path: <kvm+bounces-36688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A08A1DD7F
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:43:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66E01164CD7
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715F419885F;
	Mon, 27 Jan 2025 20:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zNTWoSn6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C3E17799F;
	Mon, 27 Jan 2025 20:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738010605; cv=fail; b=f9TDPDkhd/SrNoh2TDeY3oI/MYV+DI8gWHK8EBLhFJcEL8eduDE4FkpEghr0ZU6WDroajQjMGsuXNvwPOW6kOgNOXrIfV5nBgW+e52dZaZGIKVO/v4k8t853qR8W3VHvV7OWO97KfQdCQVKeavZgEITRwxu1XSEP96fe21IUSFc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738010605; c=relaxed/simple;
	bh=81ZDzCSSaK2ihvWxoHuxsw6ogj/WliXUc+PVuWA9aYo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U4Sh6meEtxkgdHjiIc3MU8dz3mBnbPGwNPbjhcnSNQbWQ9rfBuSzv+JG88rTYWnehjonG6THBCt/CrUy1vQNKNrvO88W4lwjjZz28zpdwUZvLkktT90RNQ7Iv7V9lDDGXEoB7XeaEq/ltpoajHvusDVEdS0UfYbE7vJeDmnXbm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zNTWoSn6; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ty609IrFQlUbM96pg95DAkdvMJYVsPXRmx5e03a9rrjptlHFCZtkbry8o/kCF7vOlG9RGn9qx4UBbY9I4mWkV0mvFtudq+0jqhgOFoSf2lweDHQfBDSIPJC6ep1zUFDD3iQyyQ+DVq8xMH9pYB94/bg4GxaYxojtgPQYvXSSBzKCFEC9kUxQLDtyEgzzHQEowt6iZNyk7YAtOhCnktWvbLtyokR7tpTe9Ibkh81ZKHr3ljUavEBITTVe5t9eUAX+3TjrsW3nR60uoWtXPWdvMLHfN6qqNpoSFH4vZX1kvDSxLR7M0ratJrWzgyJUHIjEwna5ZcG5sfORoYRdhMinAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTcYWXZapUY0iC3wrhVpsOyc3SIglPOTyN0TlEDSVVo=;
 b=bpDY0h7CaJMAJBnuPm+PEJhUkT95ZPs/ai4uLkGNoNzXq8RJ8WqXzHjxnRF3cfKS2UbeXERST2bsdt9v2M6drsnwsSu0YxXZlkGsirxKG0MnXDxfPtnAfgKlCXWKbeXvd0Z4aSk8NciYYtup4FCclmtg6aCZT3xc0k5G7FsaTVT7g0jAChb8597ORuoUrKum4xflguZLzVq8ZFTnpYLrZVfAamhRbkpp8u38SlsUdON7FKLt3Kfkln5/bPYt7/gIhgukk7mGlcHLquy3unryRerAAUdUrGNchLo3QP7NLFyK7jYX984aU2e3GKDxzvXUXag2H43I6V+gRgG8fh+Suw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTcYWXZapUY0iC3wrhVpsOyc3SIglPOTyN0TlEDSVVo=;
 b=zNTWoSn6F9ydB6VXcK51OTGWmRn4Mgm9/qsoQ1xL+wXeyO6gGZ9qSKKAnfRp2CSiDfMI9gcmTF6XTJ1sVy9jH7gJ8lGdapi6o9A49Z2dAiJUyydB5PIqScUVTnrR86GgJ9+5r/BAN+diiBvIw8FmUfQNLlgUwvmomKMjAFV3wfw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB6257.namprd12.prod.outlook.com (2603:10b6:208:3e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Mon, 27 Jan
 2025 20:43:21 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 20:43:21 +0000
Message-ID: <e23a94f0-c35f-4d50-b348-4cd64b5ebb67@amd.com>
Date: Mon, 27 Jan 2025 14:43:16 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] iommu/amd: Check SNP support before enabling IOMMU
To: Sean Christopherson <seanjc@google.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org,
 robin.murphy@arm.com, michael.roth@amd.com, dionnaglaze@google.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <cover.1737505394.git.ashish.kalra@amd.com>
 <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
 <c310e42d-d8a8-4ca0-f308-e5bb4e978002@amd.com>
 <5df43bd9-e154-4227-9202-bd72b794fdfb@amd.com>
 <5af2cc74-c56d-4bcf-870e-afa98d6456b3@amd.com> <Z5QyybbSk4NeroyZ@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z5QyybbSk4NeroyZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0078.namprd04.prod.outlook.com
 (2603:10b6:805:f2::19) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB6257:EE_
X-MS-Office365-Filtering-Correlation-Id: a97a5162-c1f3-4c35-f322-08dd3f133c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEFESVB1KzczeTFpUEpwZFFpY1JWckdzbmx3N1UxZzlOa1djejZOSW8rRWpC?=
 =?utf-8?B?SVBPc1NtWElOOVkvWC9RU3RRZXByVUUzZVJHaTJsTTV3S2tBWUc2VCs5KzR4?=
 =?utf-8?B?NHZIRmFBOVNPQVVGNG5STVc2aWtHNXlvZy9BN1YyemNPTTJyQm1USncvanFk?=
 =?utf-8?B?Mzh3aFNqcHorK014RFFUVklLWVYxUkxpaDF1MUZMUDQ2L051UzZ4N3BNc1NK?=
 =?utf-8?B?cVV6TENRdEx1cllzVlNHWUxoRlF5WFU0STBBVHJwbDIrdzdkTkkxVCtDWVVy?=
 =?utf-8?B?YkNtVnQ5VDJKQXRiNFloWEc4Z3NFSXpZNTY0RGsxdC9uUHFnR2hHWkVVSm1Q?=
 =?utf-8?B?TEsrVFlPc2NrcnpWRFpOeVJFY0ZhcHhtc3ltaldHVjY1Y1BVQTNIMmdPZDM1?=
 =?utf-8?B?dWNQeVdHQkhBRXN2UGxoZWZya292QVdXOW1TOGE0Zm9UZHF6ZG92Y2owSkN4?=
 =?utf-8?B?ZFN6VnhpeHh3RG13c2h1cVA5OUNUUGw3YlpRR0hDRWxMbUxPcCtmWHFxM0d0?=
 =?utf-8?B?VFQvWDZTWWxwaWxWK1MrblFIcUVpMTVPQkxnT3hxbzl3cjJKWWFNbWsrK2Mr?=
 =?utf-8?B?ZDFiTEtsZW1lWTFQMGlmWStVUWVuNDhoNEtXVXVRUUd3QWJQTW4ra2pGVHlj?=
 =?utf-8?B?ZlNNeXlUTW1mMUwzcStoa01sWDdUZExZWGgrUDhLeC9lSEpJUW10c0FLN3BE?=
 =?utf-8?B?TzJwcHNpU2Zya2FoYmNtbUZQSDJLYnBIc3UyRjFXY3oxYnFRQUpYTm05Z0tm?=
 =?utf-8?B?c1MveXk1WXFNK1B4WkNvaExDd2wyQkgxK3BIQjNBNStucTBKNm9ma0VtS0ZD?=
 =?utf-8?B?Q21mRWZBdmFhOUoxc2pmajBmc2thNE1VTEdzZk4zVUIxOHE5RndmUnRTYzEy?=
 =?utf-8?B?ZlN0dEZra0VuYkdxTzhjWGJzcjhQNUYrTGtUUE81OGZyeDlSNlZsaVQ0c0ZU?=
 =?utf-8?B?UzNXblBKZUw5SDdNNGVKSkxtRHRGSi9KN3NsMDR6a05KWWtaMUE0aHdVVENU?=
 =?utf-8?B?WWlsYjFtaXBQcTdqb1RYMmNrbENOMG1mc01RSkt6ZXp2MGtsR21Jc0VKbE40?=
 =?utf-8?B?LzRXTG1VbnRCVXIwT0RDOXNyM2hrS2ppRVE0cEcydWZuK3FqNmFZRjV2V1V5?=
 =?utf-8?B?QmNjVnVHZXNEMHArQlhCVm1pMk5JeFRxWi9BNy9DRjlYK0RYQzhPMXkvUitC?=
 =?utf-8?B?azU2WFBmS2ZnTHVBYVU3SnNMRFRvd0w3bHJmRGZqeEJTR0JvZmVWTmdOZ1hQ?=
 =?utf-8?B?aTJPV283Z1l0bUFOelUwbUxhVjFUV0dEb3VNTlMvdDAvaThrTTQ5anAvNmNI?=
 =?utf-8?B?WGxTZE4vYlVZeHh2aXpKblJJcDJEKzlZMTdYa1dlc2JSY0o2dVpnTHRPN2dj?=
 =?utf-8?B?d2VJL0xLWHpJOE1WYWw3ZGJ1dFZrajBIUnZoWjNESEhwNXMzRTlNZ3JBTVIw?=
 =?utf-8?B?SDVQOXh6cE1KcXdvNmw0dEpPemgwMThrL3ZNSy9SZnVOR3R3VndNQ0R3M1JO?=
 =?utf-8?B?OFhBU2RWUVpNQ3pCTWt0ZHE4bzFxTUswNTJVRU1hR3J6VCs1RVI3d3hnMzU5?=
 =?utf-8?B?WmFjN0hBbkpwQ1NpS0lCRnNESkFhcDdjVDRYSjZOTjlxN1NkbHVkVGptNmV2?=
 =?utf-8?B?RWtBNEY5U0NraXhrQ0dEaFR1OUM4dSsyNzJ3Wm1RbUlVSzBlR1NyN0dOeitZ?=
 =?utf-8?B?ZjJLY2VONGMrYWE3UTJkb2VnL0xIckVXalVyRUc1dWhQYmNjVDdlK2p2bUJR?=
 =?utf-8?B?V0lseWd5WFJMWTFOQTVSdGlhMDVKckxhVzUyblZaTEdVNFptSi9TenRqWHFF?=
 =?utf-8?B?eFdrcVFyeFNjQ2FnQ0lVc0RKTXFJaEtVZ3NNODcrZ29KdDRoUXMzS3JlN2Vs?=
 =?utf-8?Q?QHLhDkPUVVjIS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkhjR0FZQnhPNklXSEFDN0t4ZWhFQmZUZnFEMElYWko5VHRRU2hMVlhEbDIr?=
 =?utf-8?B?Rkx0RGxYUEoxNlU2aERqOEd6K1M1eHVMUFdZZ3FLWVdZL3pJV2FIUEs1eDRB?=
 =?utf-8?B?NjY3bUZ5ZjhvQ21CMmF3emI5aFpsMk00a1BPZHJuY1ZPMDlUZDBYRTNqNm5k?=
 =?utf-8?B?dk15Y0ljMjhnankxK0Y2bnNoSm1EZEhMSnRIT1lGUjVNYXF6VzFMa2wxL21G?=
 =?utf-8?B?WndCR2FOS2hTOHN2UzRhUzZidDVUVzlDQy9odzMzMUNSN3FjWmtqZGJDMVRk?=
 =?utf-8?B?dUZkOERrbzZrWjNNVzU5MDNxNGgrNTZGR2h4c2dxVGlxdm56UTVQMGVXaVpT?=
 =?utf-8?B?L2dkMzVqOGcxUDYzcTdpN2tFT0NhSUJzWXBNWFdWVndxYWZFV2FLNGNqZ0hP?=
 =?utf-8?B?RWd5SGt5SjZ3MHJrd3MwdXEyUDlwMXFwZFdjc0U3dXU0QzhMV0dPakVxOHFW?=
 =?utf-8?B?a3h3ZGdqaGh2SU5LdWtWeXVnM0hJL1NvcDc0ZUUzUUs1dC9ab3pEUXRKeVlp?=
 =?utf-8?B?d2M3RjkwMlFRNk1Sd2s1RGorQXRGZWJ6M1RHK3FkemZvRjVuc1J5bEZQUU9Z?=
 =?utf-8?B?NG16RWxNeERoMlBTdFY4Y0ZPRHdlaW54UEFLcE5WUkMvbmgyaklNci9uKzFw?=
 =?utf-8?B?UE5PdDVnVTFUM1JZTDVSZnFTS0h1WkZpK1dVQzBhb0ppOGhUY2RaZDl5SXE2?=
 =?utf-8?B?aHZQWE1DdUQwdkNQbHoxMURHN1IwQ3FFOHRRdGdPTm1FNXhSazlVd1pPbzh1?=
 =?utf-8?B?OVU0bEJib201SVZqNk0xenBqbEJkZ0lBdkNnYlBKTlVtaUFJaDVLbEJKQUlp?=
 =?utf-8?B?OUVZL1BRaUhveEZ3MStBbjlzQnZNVTRhWXUwM2ZuTExDV3hQY25jaWxGMjgz?=
 =?utf-8?B?eE85Nm1aT3NYZkVsK0tFMDRCV3REZVEzV0pnM2NwNTRPSWJUcHZwZjU3N1hi?=
 =?utf-8?B?aWNnVGd0b0c5dVE3c01XbkhaaExaeXlJb0lRR2x4U0c4WTFReGdvaUx3bzkv?=
 =?utf-8?B?SzgySGlVU1RQUDNPTTkwNmhoTitxYnJ5T0l2RG9hWForaUI5VmVJUUpkL3Bu?=
 =?utf-8?B?SXZBRU8wMXVtZ2laRGVVQ0wyUkJNY01sRktsYzVmZFpIRkhUUy9xcmdIaEVn?=
 =?utf-8?B?RExIRE9ZWmsvMzlnTy9CYzlMZW52RWNOTjQ5dERWbS9uWG9DQWNReEt2V0Nh?=
 =?utf-8?B?OEVya3ozcXoyOFhVZmJBbWpucXZpeUJlN0prRUowREhXK1FxQWU2RGJNNm93?=
 =?utf-8?B?M2lONjBHZkdkOWZ2R0xSMi84MHcrUjRuSk4vT1pWenQxK21PNC9uTzhnS2Nr?=
 =?utf-8?B?S2V3YXlqNmFHcXNVdW1MQis3ejVvTkYrazBlYTVYUTBYMHd4a2FZenI4bVF3?=
 =?utf-8?B?QjJRTUFNdFhHZ3N0ZmJLekFkS0FmcFJQNmdaRVAzaEllYVltMEVjUmF3WmlC?=
 =?utf-8?B?cWZjVlIxZkZhWVdnMzN5c0lGVlpUaWJyZG9raXdzOHJxcVpRRVFXU09rZGQx?=
 =?utf-8?B?bk5uQXIvNURJYzVXZS9ENFk4QjdYZ015ZEZ2S3ZxRUNieWZ4SlNyTzdyQlA4?=
 =?utf-8?B?TmZTbENOVWJmK0R3VzQ1WDV3ZnhTM29JRFhGdElOSG1qRSszRFRlRWNXT0ZU?=
 =?utf-8?B?VjNXTWw2UkRKcGtCdTFybnNDTzlRd2xRclhMSXFpek1aU2FCdmlIWExybzVz?=
 =?utf-8?B?YUoyYTZFSld3Q2RFcUswZWpxSU0zQzlydWdxbmZQMVJYT281SHRHSUlBaEhI?=
 =?utf-8?B?L2Nia01NVXFFcElpZ0ZYM2ZUaWJ2Q0JOb3owSm16MGY5cmZDcHdoZkNWc21L?=
 =?utf-8?B?eFJSSjZiVW11QU9DZDJlYmxFMnAyNWFuVCtHNGFoc082bnAvVWRGS3IwNXF6?=
 =?utf-8?B?NXUrdkp0MFp4WlBKOXU3cUo1SkNPb3hWSW8zWnRZSm8xUjNFSlIvUHFLTUpr?=
 =?utf-8?B?anNvQzdHMFRUY1lBazQ5cUdXZEo3cmY3YnNtRE4reWk2dzZlTzZtS25JbGZF?=
 =?utf-8?B?U0JVL0hmNVVNblpEWUpnbDJkTWk2ZFBxS0R0eURmeHI0amNOVW8wR0pBTEVU?=
 =?utf-8?B?R2p6aFM5dHdrUzNsWGZEd2pHVTIxdHdUTjVobWN2MjdQc0piMW9NbTIwa0cv?=
 =?utf-8?Q?8z2uA5slpZ1m9nAI4cKszSznz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a97a5162-c1f3-4c35-f322-08dd3f133c66
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 20:43:20.9985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mq0di6Ow/W6+z9UJxDPRXQC6IDrtGubTkeKe8k0Inf8ly/F7Sbc/tCsmmC6hWvt1+aBjgPmf1byOmHkDSinNvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6257

Hello Sean,

On 1/24/2025 6:39 PM, Sean Christopherson wrote:
> On Fri, Jan 24, 2025, Ashish Kalra wrote:
>> With discussions with the AMD IOMMU team, here is the AMD IOMMU
>> initialization flow:
> 
> ..
> 
>> IOMMU SNP check
>>   Core IOMMU subsystem init is done during iommu_subsys_init() via
>>   subsys_initcall.  This function does change the DMA mode depending on
>>   kernel config.  Hence, SNP check should be done after subsys_initcall.
>>   That's why its done currently during IOMMU PCI init (IOMMU_PCI_INIT stage).
>>   And for that reason snp_rmptable_init() is currently invoked via
>>   device_initcall().
>>  
>> The summary is that we cannot move snp_rmptable_init() to subsys_initcall as
>> core IOMMU subsystem gets initialized via subsys_initcall.
> 
> Just explicitly invoke RMP initialization during IOMMU SNP setup.  Pretending
> there's no connection when snp_rmptable_init() checks amd_iommu_snp_en and has
> a comment saying it needs to come after IOMMU SNP setup is ridiculous.
> 

Thanks for the suggestion and the patch, i have tested it works for all cases
and scenarios. I will post the next version of the patch-set based on this
patch.

Ashish

> Compile tested only.
> 
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 24 Jan 2025 16:25:58 -0800
> Subject: [PATCH] x86/sev: iommu/amd: Explicitly init SNP's RMP table during
>  IOMMU SNP setup
> 
> Explicitly initialize the RMP table during IOMMU SNP setup, as there is a
> hard dependency on the IOMMU being configured first, and dancing around
> the dependency with initcall shenanigans and a comment is all kinds of
> stupid.
> 
> The RMP is blatantly not a device; initializing it via a device_initcall()
> is confusing and "works" only because of dumb luck: due to kernel build
> order, when the the PSP driver is built-in, its effective device_initcall()
> just so happens to be invoked after snp_rmptable_init().
> 
> That all falls apart if the order is changed in any way.  E.g. if KVM
> is built-in and attempts to access the RMP during its device_initcall(),
> chaos ensues.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/sev.h |  1 +
>  arch/x86/virt/svm/sev.c    | 25 ++++++++-----------------
>  drivers/iommu/amd/init.c   |  7 ++++++-
>  3 files changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 91f08af31078..30da0fc15923 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -503,6 +503,7 @@ static inline void snp_kexec_begin(void) { }
>  
>  #ifdef CONFIG_KVM_AMD_SEV
>  bool snp_probe_rmptable_info(void);
> +int __init snp_rmptable_init(void);
>  int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
>  void snp_dump_hva_rmpentry(unsigned long address);
>  int psmash(u64 pfn);
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 9a6a943d8e41..d932aa21340b 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -189,19 +189,19 @@ void __init snp_fixup_e820_tables(void)
>   * described in the SNP_INIT_EX firmware command description in the SNP
>   * firmware ABI spec.
>   */
> -static int __init snp_rmptable_init(void)
> +int __init snp_rmptable_init(void)
>  {
>  	u64 max_rmp_pfn, calc_rmp_sz, rmptable_size, rmp_end, val;
>  	void *rmptable_start;
>  
> -	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> -		return 0;
> +	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
> +		return -ENOSYS;
>  
> -	if (!amd_iommu_snp_en)
> -		goto nosnp;
> +	if (WARN_ON_ONCE(!amd_iommu_snp_en))
> +		return -ENOSYS;
>  
>  	if (!probed_rmp_size)
> -		goto nosnp;
> +		return -ENOSYS;
>  
>  	rmp_end = probed_rmp_base + probed_rmp_size - 1;
>  
> @@ -218,13 +218,13 @@ static int __init snp_rmptable_init(void)
>  	if (calc_rmp_sz > probed_rmp_size) {
>  		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
>  		       calc_rmp_sz, probed_rmp_size);
> -		goto nosnp;
> +		return -ENOSYS;
>  	}
>  
>  	rmptable_start = memremap(probed_rmp_base, probed_rmp_size, MEMREMAP_WB);
>  	if (!rmptable_start) {
>  		pr_err("Failed to map RMP table\n");
> -		goto nosnp;
> +		return -ENOMEM;
>  	}
>  
>  	/*
> @@ -261,17 +261,8 @@ static int __init snp_rmptable_init(void)
>  	crash_kexec_post_notifiers = true;
>  
>  	return 0;
> -
> -nosnp:
> -	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
> -	return -ENOSYS;
>  }
>  
> -/*
> - * This must be called after the IOMMU has been initialized.
> - */
> -device_initcall(snp_rmptable_init);
> -
>  static struct rmpentry *get_rmpentry(u64 pfn)
>  {
>  	if (WARN_ON_ONCE(pfn > rmptable_max_pfn))
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 0e0a531042ac..d00530156a72 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3171,7 +3171,7 @@ static bool __init detect_ivrs(void)
>  	return true;
>  }
>  
> -static void iommu_snp_enable(void)
> +static __init void iommu_snp_enable(void)
>  {
>  #ifdef CONFIG_KVM_AMD_SEV
>  	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> @@ -3196,6 +3196,11 @@ static void iommu_snp_enable(void)
>  		goto disable_snp;
>  	}
>  
> +	if (snp_rmptable_init()) {
> +		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
> +		goto disable_snp;
> +	}
> +
>  	pr_info("IOMMU SNP support enabled.\n");
>  	return;
>  
> 
> base-commit: ac80076177131f6e3291737c851a6fe32cc03fd3


