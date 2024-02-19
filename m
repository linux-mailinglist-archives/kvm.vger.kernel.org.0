Return-Path: <kvm+bounces-9007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03683859BA7
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 06:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 712DE1F21D62
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 05:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126AE1F952;
	Mon, 19 Feb 2024 05:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nMKnJG5V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941FC1CD23;
	Mon, 19 Feb 2024 05:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708320069; cv=none; b=kArV/Phw00yOqBwc4uqm+9BAShDrh528RLgVZZs9V4ZaILq1U+SmLf17oPUZGBPeHVvFfZ2pRn4TcqgW8BTkKOcxd2BqEov4oVXAMQQ4NZYWO/vCSQfhwyMdJ1qBTgTYcZZxWoHMEx7WAzAx9L+gYO5APjzyYNoojd+KlxrXetA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708320069; c=relaxed/simple;
	bh=pN0VCoWunX2OLnCNR54V/+S+F1vbvvcHeczduh6bbys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gO7C6k7zzATboDRS+UZo1LgGRu8T20C12X0gUka4VX15l3/elKQ10F+V9tKy1Kph6twnCrnt4I7Jvh8reS6rl3gq3Yg+u7BgU+AxRLnpku7eZZDlFrO6JmyEovOsljY9wzjKmv7S1XWnxlQ3uJ+dn02piukKVsRzQbIvP1lVhG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nMKnJG5V; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708320065; x=1739856065;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pN0VCoWunX2OLnCNR54V/+S+F1vbvvcHeczduh6bbys=;
  b=nMKnJG5VKSkiSay0HOpWEJcsB9xR+qZ16nDkNycTukJmkDQ2ce3CZCa1
   kYp3ycD0l9X9IzOXOvyxNzc2wjVKs2So3s1+l00/9L51ULBIZEyC5gNgP
   /Zhsyr0XykUS3my26ytS+ha7vPTGy26G9l2VcGnf13Oc1meG9WEH+Gnyb
   ELfwH0WrcfasAmLOXRZTPaq1xKGrpdcEPpDZarWySzy93aom7t33hUQP4
   ivZJjc0gJhczK6TzMQz4v5y7layxsCvsmakgKEnFjs1ddUT9fcUuAN0mV
   8dmei8Q45MBwIkcWhRoRLwndoPgGy+yU5Fyyg4hjEpQKa022AD4CZQTEn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="19812948"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="19812948"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 21:21:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="8977536"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.1.66]) ([10.238.1.66])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 21:21:00 -0800
Message-ID: <b676c8f7-fa3c-44f7-bfbf-0f28d46a7576@linux.intel.com>
Date: Mon, 19 Feb 2024 13:20:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 061/121] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <83048a3bba898a4a81215f3c62489b03e307d180.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <83048a3bba898a4a81215f3c62489b03e307d180.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Because TDX virtualize cpuid[0x1].EDX[MTRR: bit 12] to fixed 1, guest TD
> thinks MTRR is supported.  Although TDX supports only WB for private GPA,
> it's desirable to support MTRR for shared GPA.  As guest access to MTRR
> MSRs causes #VE and KVM/x86 tracks the values of MTRR MSRs, the remining

s/remining/remaining

> part is to implement get_mt_mask method for TDX for shared GPA.
>
> Pass around shared bit from kvm fault handler to get_mt_mask method so that
> it can determine if the gfn is shared or private.  Implement get_mt_mask()
> following vmx case for shared GPA and return WB for private GPA.

But the shared bit is not consumed in get_mt_mask()?

> the existing vmx_get_mt_mask() can't be directly used as CPU state(CR0.CD)
> is protected.  GFN passed to kvm_mtrr_check_gfn_range_consistency() should
> include shared bit.
>
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 10 +++++++++-
>   arch/x86/kvm/vmx/tdx.c     | 23 +++++++++++++++++++++++
>   arch/x86/kvm/vmx/x86_ops.h |  2 ++
>   3 files changed, 34 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 569f2f67094c..0784290d846f 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -232,6 +232,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>   	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
>   }
>   
> +static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
> +
> +	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
> +}
> +
>   static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -351,7 +359,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   
>   	.set_tss_addr = vmx_set_tss_addr,
>   	.set_identity_map_addr = vmx_set_identity_map_addr,
> -	.get_mt_mask = vmx_get_mt_mask,
> +	.get_mt_mask = vt_get_mt_mask,
>   
>   	.get_exit_info = vmx_get_exit_info,
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 4002e7e7b191..4cbcedff4f16 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -439,6 +439,29 @@ int tdx_vm_init(struct kvm *kvm)
>   	return 0;
>   }
>   
> +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +{
> +	if (is_mmio)
> +		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> +
> +	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> +
> +	/*
> +	 * TDX enforces CR0.CD = 0 and KVM MTRR emulation enforces writeback.
> +	 * TODO: implement MTRR MSR emulation so that
> +	 * MTRRCap: SMRR=0: SMRR interface unsupported
> +	 *          WC=0: write combining unsupported
> +	 *          FIX=0: Fixed range registers unsupported
> +	 *          VCNT=0: number of variable range regitsers = 0
> +	 * MTRRDefType: E=1, FE=0, type=writeback only. Don't allow other value.
> +	 *              E=1: enable MTRR
> +	 *              FE=0: disable fixed range MTRRs
> +	 *              type: default memory type=writeback
> +	 */
> +	return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> +}
> +
>   int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 441915e9293e..5a9aabf39c02 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -150,6 +150,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_create(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_free(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
> +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>   
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>   
> @@ -176,6 +177,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
>   static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
>   static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
>   static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
> +static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
>   
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>   


