Return-Path: <kvm+bounces-11976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A783987E3F5
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 08:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CAEB1F21643
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 07:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA096224DC;
	Mon, 18 Mar 2024 07:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="UzwalN86"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2130.outbound.protection.outlook.com [40.107.243.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B951523741;
	Mon, 18 Mar 2024 07:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710746262; cv=fail; b=YVzNWqJtYxd68kVurdLiU3jpM3CLAYk5aWCJTbShp7Jo/ZaEecr0teHTMJkj9zpzpi42JTZy4BBnzWFzucFO/pyhlbcIUZIgHE4qirx7Lh1jksjrKkF31Nsl0NxdrMUZ5KwrRXYqLVg395HDg2B29vYB+Z2dHvKRB/epCaPZlLs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710746262; c=relaxed/simple;
	bh=Q2WYZ56znIOudsqNTmhEgcjCuf4TP6gNUzAVI/zLUZw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=akpxx0lRjum/lX8vCiCjnA1MeIYoXo/2vgRIQ3h30an7CKnryaT7gHLyUdRX/j2q4tdXwykzPcEEz07C9KokzOowcnQnyoyrJvCdA0r5poxiXqTKlLxIkkbilJNfb0kXhWT/N0zxolhEw6PuAmHsiNyt4Q0J1ERVamxM77035t0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=UzwalN86; arc=fail smtp.client-ip=40.107.243.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ite+GNJsanYn+V4oTjqIVdZpmrjJi85wQe9NaZQ/y1m8b+vCvxHPDpG3fcSUVnmWF7e9OlAoogxTpg7S3xrLy4Ra2r1SyXJjaCJQyrHbKMNcX2Vdm74+0Adw6kE9TwaPhi0/a3doGijatLGHV8G98TLs+wFVsocJkdsAOF7FfxgWfakuL133lcgvBsQZl4bLGtsxH96wVlvYiZgpW/Gn2JKKymb1X95LbYhvP/YqM2eWT3w0zAYNtWTIPS/WHZzn10s8df/wNArhTnvwt1lRPaWE9PmZy5APgsPm3ChPaeS+fnl+9WeX12Kfxi9ZhP5LsURgtSzTpSPG8xKFXPCuAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0ZQ9GyWRwaw9VO8UZTGHzkd0dSLOp7iG0Nc1a2y+U0=;
 b=D9jsJOqpXNq2l1rNaLc9nAxX1kPoo83EO4SL2740RXp2Pk7Tcyhdfg7RmO64XhUSL2GwB6X/ONJSv/vSdcqJG82dbOhGRpjhHjEvtC+/i/LeaLePbfh9+58QHGAngklseLpLzx8Ki2Q/ppNTEsb0dGuAJsCXxny6TQIlLS6SBayQSE2b8R/fVkPJBlFJDOBopovX0B39d7y5R3XFhDX7+5t9NqWrCpzsTlqoQMmEgUpkXrU1YVo+IIwY5IEF2zygQUL5dZCAfJzpzbqTjpmmZ/RHT2JauixazWfmA5vELr9l1iaRCoUlLqA+lvdok0AzAafkrhkTWA+OD7iD8CNHSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0ZQ9GyWRwaw9VO8UZTGHzkd0dSLOp7iG0Nc1a2y+U0=;
 b=UzwalN86aB6rS1Y2IvTyisN5Vb4b2nWUgfrWvIXoIJc5a19RJ3PmCuF1a8pKIQeZb9/ULCdowiAYSPxZlZLZOY4y9+gfun9C3tZMszjv4q1pROKhYlB+NiXBcRijxvwgFRK5mRNq2v5N+VQRGSvSCiIG2745CGqXytBmA9WpMhA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 BL3PR01MB6849.prod.exchangelabs.com (2603:10b6:208:350::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.35; Mon, 18 Mar 2024 07:17:36 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::d3dd:ece:637f:bde9%3]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 07:17:36 +0000
Message-ID: <d5a1adac-d0d1-4eac-b5ad-b2b8f4d9d971@os.amperecomputing.com>
Date: Mon, 18 Mar 2024 12:47:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/28] arm64: RME: Check for RME support at KVM init
Content-Language: en-US
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-5-steven.price@arm.com>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20230127112932.38045-5-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:610:59::33) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|BL3PR01MB6849:EE_
X-MS-Office365-Filtering-Correlation-Id: a28495ff-301d-45b1-5500-08dc471b7cf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4dAHXPx7QS0mDvlbBV+fUdEebqwmLL9sRDox0bbYNDfcfsUo+0u70+fUkBb4utck9stHE/HRBp1Gs9Esi/ZE06c9+jTpuh1vWeQS/SbY+9rO81VBPK+RccNByu2vo9oG1YWqI1pWGm561vJl811PTlezqBqZPQ7+J6yC34+Ift9o2aDm5mChO4S9i+/11x6Dw1xi7H6qAQkHcExnKQg+ViN9/63lwxZoHyC3s/VheM5DZXWiBvcLIAYVon6O4hNlPQ7Fn3OlJLwgzqqG5bouGjtvG/48+hnwaH61jKjHu/OiOTV4eMe3rxXgUz6FfCyaBhWqm85onCXeT5dELa4ATE7/KZuwC9mzMZZrZBPNOA+Hxz0Kxv3M+o9PUg8R/Khb3bWRP4y8wn8rKSg0MGU80Xu2NASrVS7ptDNylsuBdRn5Fft7NWV2Fu2FFE102+ksgr2WdlvLK25TUIvMwZsK7qDkzNXGBiNlNdhNP7H/T98IKd+3aLrieMa7BRy5w3DvywgseDHoXq+KcyBgwxVY6ediDgmfYlS4ldl9oFcBxpp3AWPbBvG497xaS0qzquOO/suSRfgaaRAeNsWFyD24wxn3QLsshismow+gRUTEdschYelFP+nnlvntQ0Ra7M/T21CMb+rewV7Stw8i0bzAlt+izD4RM8qcq5d5jKRuw2A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZElOc1NMS2hITHVORE9abTNGcmNvR2Yxdk9rMlBNWjVSd2tuNSswWE9KbzYz?=
 =?utf-8?B?SUJ1UkhlVU5zWXBMT3FVK0N4NFU3TFAzZDlQamNEa2xHaVZlNVFsVmQ0ZzlK?=
 =?utf-8?B?ZDNrb1dmdlZ1YTN5a1dhWjQ4ZXdTNkdqR3VGQ2xnaXhqaFNNVmozWHFOQnkx?=
 =?utf-8?B?Vm5YTDZoeW5zOEcybEJkeW1GbEdBUVRyZkhmM29MSi9BdmxQZmlmR0Y0S1pa?=
 =?utf-8?B?OTdUNENPOW83c2t6NFZwN0NBVmRjbkNjZEJPOEpWMXpwYnN5RHdycXRJcUVE?=
 =?utf-8?B?T2tDN1hUUFlvckxkWlcyNnlyT2ZmM2N5RUF5aEU2K0NJSTFXYnpKY0xsTisx?=
 =?utf-8?B?eFZGM3ZRZDFDV3FhT2duV292dTRlRVpucktvdlZxNG9wTElYQVRuUVpVd2xs?=
 =?utf-8?B?SVJUQ0Y4MU9NemQrRC9TYng5bExndHBYTWJoL0x4TzBjWDczYW8zN1oxYmdS?=
 =?utf-8?B?QnByYmQyZTdSbFBFYTlkdGZRZkFrRGxGRVI2cWplMVMxTFVrMy9zUm9TTmVZ?=
 =?utf-8?B?ZXdJRzVDd0dWRXlCaE81MlV2OCtYbWVIL1ZTVFdTMWxhSVFqN21sQUtRb0pG?=
 =?utf-8?B?R21mdG9Hb0owNEtCc0MxT0ZKRG1SVGREbXhTRGZjVDdqd3FWVVplcVJwdWFm?=
 =?utf-8?B?RFJLZGg0TXU5UkdFdXRwMHZCOEt6dlZxRDZZcWVDd3JVR1Uxc2p1K25RbHVZ?=
 =?utf-8?B?ZzhrV3FIUktFc3ExUHBCNTRkY0hGUWR2SmVKd1N5dGppdUJqY3F0cjMrRUlF?=
 =?utf-8?B?Nk51MHV0WEZWQjhmNldsaTB4a0xFb3h3em5xL2YrTzhaeUx2RUVZY205elNa?=
 =?utf-8?B?cUl1empVRDQyRGUwS2xWNm9uekFiMTA3OEpROS9BbHVkWncwcTF2T0N4WHI4?=
 =?utf-8?B?YU9rNTFPak5kbXQ3S0h1L3RnV0hubCtoRmlaak82U05BSU5wa29ucEgrTWZw?=
 =?utf-8?B?SEs1K0hodWRvNnlHYnBmVmF1L2ZPeXp4cWpremhvQVk3VUgxeXUrN1l5TUFG?=
 =?utf-8?B?OTFBVDdCWG9iN1llMVdIOWNrS3pYRjd6NXNwMm9EMzRTb3ZRK085djR2YjQ3?=
 =?utf-8?B?VjlDcVlmSGZtZVNsWmdJOFppbGF2ZXhaamZwQjJ3Q3hZSXZlalNtZWlhZ3BX?=
 =?utf-8?B?eEFwOEplTExoRGtISzRoMkN1KzROcWxiZjUvUmZ3TmNQYXlRazJpaExsUGw4?=
 =?utf-8?B?QWUzQUtSMC80MUp3cGVUWWtJd0ViWFlUZHhYcHZ1SHhQVi9IWkQ3ZFJRWTRD?=
 =?utf-8?B?Y3d2Q0ZFS3lrUHFDYTE2Y2dlUm1MUVhWWDBSN3k1TDRtWWxETDVQais5aXB4?=
 =?utf-8?B?K25UVmhuemJ1WTh2bGMxSlMxbi9aYThUSDhVck5KYllaZjBicis4eU5aaXVW?=
 =?utf-8?B?UE81NjZaSktEbFZHemNGZHRaayttWlJRRnNhMStDL0UvWUtvUVEzaE95YzRh?=
 =?utf-8?B?cWVzaVVIYUNaejJNUFNqUFVDVTV3bldoU3k5cjJMSnVGa3BjTWp5R2JuNThi?=
 =?utf-8?B?NHpiRUtFcW1WN1FKanpKYzBrNmdmeUxPNndsMHRWcXhlbmpnS016clJRcDd5?=
 =?utf-8?B?WjVNaVJaNFpxaGkrdy9FQUlTeWpST3dDeWwzL21NVHFMaE9VaitHTnpkQjJ5?=
 =?utf-8?B?Q1lDS2NJS1NVYndQSUxGd24xZVR1MnVGVFlsbzBwMjR6aEVOUWFNSlQ4VFVG?=
 =?utf-8?B?d2Y5ZW40TGFKUmJvN2ZpQmhPZzhOUEV1VkVnYVlZOGFnczhROEt5RHVnWXNV?=
 =?utf-8?B?YjkrUml1RmIvWDZjSm04QWNjVEs4TUx3Sko5Y05xRlFFSFNQQ3kzSXpVZEVM?=
 =?utf-8?B?VUV1VDZ4VjVUMzZBR0IxOHMyVU5zbG5OZzdab0hWZlF6djVxOVA5c1lGVUdN?=
 =?utf-8?B?WXZDbmFDQWVkM3VoQklWTW91QlJiTHNUT3NHMDZrR05yZ3RVYjUxOHZtV3NB?=
 =?utf-8?B?VTlrajZ6NDg3SDJUaVByaXQwbjY0dWFSb3J2OG9qRlJUSkF4dW9xY3kwWGlD?=
 =?utf-8?B?ZXFKaW5SMVhoenVQWlRYRytrUUFheWR3Vk15aEFMSHBlN1BVdi9MNk9rc243?=
 =?utf-8?B?S1lxT0ZsWTBCbS90bDhreUx5L3p4QWx3Z3YwVmgxOXZNK0lxSUczYk1iclNN?=
 =?utf-8?B?UU95MTBaaEpwTnJwVXV3SmdzcjV2TURGdnMyYkhzTjVPbXd2UG9PNERVdTUy?=
 =?utf-8?Q?sWLLmy11DWWwcPjSMT2MittFzyo+pTI0l1zzyFguVEE7?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a28495ff-301d-45b1-5500-08dc471b7cf1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 07:17:36.6590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VHfQiaFc1VNnMHnXSx5lLmqpW35zINsxWH6Y/41GxVf+uU0lk2kNkV9bK27vnx0IPcrqrwVGANMEzxG3qHKL06Qj0uNASyLw5Wr5TxyEamT06IIutD0FDpVqJ+f7VaXa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB6849



On 27-01-2023 04:59 pm, Steven Price wrote:
> Query the RMI version number and check if it is a compatible version. A
> static key is also provided to signal that a supported RMM is available.
> 
> Functions are provided to query if a VM or VCPU is a realm (or rec)
> which currently will always return false.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_emulate.h | 17 ++++++++++
>   arch/arm64/include/asm/kvm_host.h    |  4 +++
>   arch/arm64/include/asm/kvm_rme.h     | 22 +++++++++++++
>   arch/arm64/include/asm/virt.h        |  1 +
>   arch/arm64/kvm/Makefile              |  3 +-
>   arch/arm64/kvm/arm.c                 |  8 +++++
>   arch/arm64/kvm/rme.c                 | 49 ++++++++++++++++++++++++++++
>   7 files changed, 103 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>   create mode 100644 arch/arm64/kvm/rme.c
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 9bdba47f7e14..5a2b7229e83f 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -490,4 +490,21 @@ static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
>   	return test_bit(feature, vcpu->arch.features);
>   }
>   
> +static inline bool kvm_is_realm(struct kvm *kvm)
> +{
> +	if (static_branch_unlikely(&kvm_rme_is_available))
> +		return kvm->arch.is_realm;
> +	return false;
> +}
> +
> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
> +{
> +	return READ_ONCE(kvm->arch.realm.state);
> +}
> +
> +static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>   #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 35a159d131b5..04347c3a8c6b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -26,6 +26,7 @@
>   #include <asm/fpsimd.h>
>   #include <asm/kvm.h>
>   #include <asm/kvm_asm.h>
> +#include <asm/kvm_rme.h>
>   
>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>   
> @@ -240,6 +241,9 @@ struct kvm_arch {
>   	 * the associated pKVM instance in the hypervisor.
>   	 */
>   	struct kvm_protected_vm pkvm;
> +
> +	bool is_realm;
> +	struct realm realm;
>   };
>   
>   struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> new file mode 100644
> index 000000000000..c26bc2c6770d
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_KVM_RME_H
> +#define __ASM_KVM_RME_H
> +
> +enum realm_state {
> +	REALM_STATE_NONE,
> +	REALM_STATE_NEW,
> +	REALM_STATE_ACTIVE,
> +	REALM_STATE_DYING
> +};
> +
> +struct realm {
> +	enum realm_state state;
> +};
> +
> +int kvm_init_rme(void);
> +
> +#endif
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index 4eb601e7de50..be1383e26626 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -80,6 +80,7 @@ void __hyp_set_vectors(phys_addr_t phys_vector_base);
>   void __hyp_reset_vectors(void);
>   
>   DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> +DECLARE_STATIC_KEY_FALSE(kvm_rme_is_available);
>   
>   /* Reports the availability of HYP mode */
>   static inline bool is_hyp_mode_available(void)
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 5e33c2d4645a..d2f0400c50da 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -20,7 +20,8 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>   	 vgic/vgic-v3.o vgic/vgic-v4.o \
>   	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
>   	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
> -	 vgic/vgic-its.o vgic/vgic-debug.o
> +	 vgic/vgic-its.o vgic/vgic-debug.o \
> +	 rme.o
>   
>   kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
>   
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9c5573bc4614..d97b39d042ab 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -38,6 +38,7 @@
>   #include <asm/kvm_asm.h>
>   #include <asm/kvm_mmu.h>
>   #include <asm/kvm_pkvm.h>
> +#include <asm/kvm_rme.h>
>   #include <asm/kvm_emulate.h>
>   #include <asm/sections.h>
>   
> @@ -47,6 +48,7 @@
>   
>   static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
>   DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> +DEFINE_STATIC_KEY_FALSE(kvm_rme_is_available);
>   
>   DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);
>   
> @@ -2213,6 +2215,12 @@ int kvm_arch_init(void *opaque)
>   
>   	in_hyp_mode = is_kernel_in_hyp_mode();
>   
> +	if (in_hyp_mode) {
> +		err = kvm_init_rme();
> +		if (err)
> +			return err;
> +	}
> +
>   	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
>   	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
>   		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> new file mode 100644
> index 000000000000..f6b587bc116e
> --- /dev/null
> +++ b/arch/arm64/kvm/rme.c
> @@ -0,0 +1,49 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#include <asm/rmi_cmds.h>
> +#include <asm/virt.h>
> +
> +static int rmi_check_version(void)
> +{
> +	struct arm_smccc_res res;
> +	int version_major, version_minor;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, &res);
> +
> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> +		return -ENXIO;
> +
> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a0);
> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a0);
> +
> +	if (version_major != RMI_ABI_MAJOR_VERSION) {
> +		kvm_err("Unsupported RMI ABI (version %d.%d) we support %d\n",

Can we please replace "we support" to host supports.
Also in the patch present in the repo, you are using variable 
our_version, can this be changed to host_version?

> +			version_major, version_minor,
> +			RMI_ABI_MAJOR_VERSION);
> +		return -ENXIO;
> +	}
> +
> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
> +
> +	return 0;
> +}
> +
> +int kvm_init_rme(void)
> +{
> +	if (PAGE_SIZE != SZ_4K)
> +		/* Only 4k page size on the host is supported */
> +		return 0;
> +
> +	if (rmi_check_version())
> +		/* Continue without realm support */
> +		return 0;
> +
> +	/* Future patch will enable static branch kvm_rme_is_available */
> +
> +	return 0;
> +}

Thanks,
Ganapat

