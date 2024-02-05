Return-Path: <kvm+bounces-7956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F52F84923F
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 02:53:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 710971C20F25
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 01:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92ABE947A;
	Mon,  5 Feb 2024 01:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VNhvjSIr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EB18F44;
	Mon,  5 Feb 2024 01:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707098024; cv=none; b=rY9oOMJbh1BrrnAWDA7K9nRNnlgzBwIn6qxVGvzzX6DgZ72oB2p43tPFJHru/W6/7G3yjR3KPw79OwqhP838iyLRJx3sFlZq6trWnXhiixTL1HyVqKzFZy7y/m3Xx7gTDRCfR0tPsqO73n7WOpP36Tz753BX3LkNdLIhgV9bbsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707098024; c=relaxed/simple;
	bh=fKVOlqy8mzfSHeW8wmy1p4vp5f1UVDHY7UGrIq/S7x0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F+rkzv5cn5Z6kQDF2nimn0k2uepLw9FbrgG3S5itDRYJ91sM0/NpEs7jHkGXJPEHK8166h5ZCcog7LZ0TcxIErsDA5XcCtNyQIUhxyVqo9y85SJ6MUtp9nyrxycTkpTlN4emxny4ehGMDN9oGmAG9g49NSmsUCXzgdtAvgx3q4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VNhvjSIr; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707098022; x=1738634022;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fKVOlqy8mzfSHeW8wmy1p4vp5f1UVDHY7UGrIq/S7x0=;
  b=VNhvjSIrWzGO+kLezGMeEQxAA7NiXnJML0Xdshb30PBAubDxMvumCoaX
   7XABKtwn3S2Z0s7Y+xp+zzpIMEPjH8M5OHSMV4pwMb+Q0N1NTIFSHfdPk
   aUTrChBoH61zZcAcyj3N7QJ4zxHjcX7VPfZ1CUVRTBoZob6yKJAD3gD3h
   BQ40rqfWQ3LFaxmh8nLMl1x95AtCz4wNrRpLlutB60XUOJs2PmkbkKKwh
   nrhxSUtYoR0ggJffJ8EYzEEqK65deHqBwG2LbE9E2cSpGgDm4cbmxRvRF
   JaIbRnW+5VTVAJObR9Q7jjGsr7Nkm0ygGULa12J4RsDmxBftkqs0Mb2Yq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="326752"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="326752"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 17:53:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="877649"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2024 17:53:14 -0800
Message-ID: <e4d19c5c-9733-4859-8e04-91c86400e904@linux.intel.com>
Date: Mon, 5 Feb 2024 09:53:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 056/121] KVM: TDX: Add accessors VMX VMCS helpers
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <3a5694739b2d081198f84aaf08d81a746ae46285.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <3a5694739b2d081198f84aaf08d81a746ae46285.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX defines SEAMCALL APIs to access TDX control structures corresponding to
> the VMX VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.h | 95 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 95 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index d3077151252c..c8a52eedde02 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -58,6 +58,101 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
>   	return container_of(vcpu, struct vcpu_tdx, vcpu);
>   }
>   
> +static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> +{
> +#define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
> +#define VMCS_ENC_ACCESS_TYPE_FULL	0x0UL
> +#define VMCS_ENC_ACCESS_TYPE_HIGH	0x1UL
> +#define VMCS_ENC_ACCESS_TYPE(field)	((field) & VMCS_ENC_ACCESS_TYPE_MASK)
> +
> +	/* TDX is 64bit only.  HIGH field isn't supported. */
> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) &&
> +			 VMCS_ENC_ACCESS_TYPE(field) == VMCS_ENC_ACCESS_TYPE_HIGH,
> +			 "Read/Write to TD VMCS *_HIGH fields not supported");
> +
> +	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
> +
> +#define VMCS_ENC_WIDTH_MASK	GENMASK(14, 13)
> +#define VMCS_ENC_WIDTH_16BIT	(0UL << 13)
> +#define VMCS_ENC_WIDTH_64BIT	(1UL << 13)
> +#define VMCS_ENC_WIDTH_32BIT	(2UL << 13)
> +#define VMCS_ENC_WIDTH_NATURAL	(3UL << 13)
> +#define VMCS_ENC_WIDTH(field)	((field) & VMCS_ENC_WIDTH_MASK)
> +
> +	/* TDX is 64bit only.  i.e. natural width = 64bit. */
> +	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
> +			 (VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_64BIT ||
> +			  VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_NATURAL),
> +			 "Invalid TD VMCS access for 64-bit field");
> +	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
> +			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_32BIT,
> +			 "Invalid TD VMCS access for 32-bit field");
> +	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
> +			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_16BIT,
> +			 "Invalid TD VMCS access for 16-bit field");
> +}
> +
> +static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
> +static __always_inline void tdvps_management_check(u64 field, u8 bits) {}

Should this two APIs be added along with for he accessors for MANAGEMENT /
STATE_NON_ARCH?

> +
> +#define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
> +static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
> +							u32 field)		\
> +{										\
> +	struct tdx_module_args out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_rd(tdx->tdvpr_pa, TDVPS_##uclass(field), &out);		\
> +	if (KVM_BUG_ON(err, tdx->vcpu.kvm)) {					\
> +		pr_err("TDH_VP_RD["#uclass".0x%x] failed: 0x%llx\n",		\
> +		       field, err);						\
> +		return 0;							\
> +	}									\
> +	return (u##bits)out.r8;							\
> +}										\
> +static __always_inline void td_##lclass##_write##bits(struct vcpu_tdx *tdx,	\
> +						      u32 field, u##bits val)	\
> +{										\
> +	struct tdx_module_args out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx->tdvpr_pa, TDVPS_##uclass(field), val,		\
> +		      GENMASK_ULL(bits - 1, 0), &out);				\
> +	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] = 0x%llx failed: 0x%llx\n",	\
> +		       field, (u64)val, err);					\
> +}										\
> +static __always_inline void td_##lclass##_setbit##bits(struct vcpu_tdx *tdx,	\
> +						       u32 field, u64 bit)	\
> +{										\
> +	struct tdx_module_args out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx->tdvpr_pa, TDVPS_##uclass(field), bit, bit, &out);	\
> +	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] |= 0x%llx failed: 0x%llx\n",	\
> +		       field, bit, err);					\
> +}										\
> +static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
> +							 u32 field, u64 bit)	\
> +{										\
> +	struct tdx_module_args out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx->tdvpr_pa, TDVPS_##uclass(field), 0, bit, &out);	\
> +	if (KVM_BUG_ON(err, tdx->vcpu.kvm))					\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n",	\
> +		       field, bit,  err);					\
> +}
> +
> +TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
> +TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
> +TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
> +
>   static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
>   {
>   	struct tdx_module_args out;


