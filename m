Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E727B682163
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 02:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjAaBag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 20:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAaBae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 20:30:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59152942E;
        Mon, 30 Jan 2023 17:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675128634; x=1706664634;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mCbTcNSjIWyRnXHSgve6MUZ/c41wT/Sy0NkCC4hOH4Y=;
  b=iidGwvMjZiQZgIsGeZ4e96g/26WXfrT2KwTWQRRmg9OxMFrSvreKfN3U
   4XYUpEADjRxp5uXkxalIzA1kDZMb54EXVKPbBIAE5j6rc0iE4pWaxDcLj
   F0KhLAlcZEMd6fT1X4VO+n7plTp19riiIcH7g9fwpFXmhX05DBAIqyXPs
   52onzqF03Vq9tIPR2uKcaf/S7yWtoKg0HRlp0wCpr65d7M8IirVTUzHSd
   4LPkfrDWjqsE4EbJ9JHVBKB27+fcN0AeGXecBZ03ABhgeLVsEgj6aV2AR
   7B+TIwc5UvxzOSUzCnpJDojgIOzhF4Yy7sZamAbsHTgVW6yy6RKTx9Z6E
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="329833108"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="329833108"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 17:30:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="641773594"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="641773594"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga006.jf.intel.com with ESMTP; 30 Jan 2023 17:30:30 -0800
Date:   Tue, 31 Jan 2023 09:30:29 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 099/113] KVM: TDX: Handle TDX PV map_gpa hypercall
Message-ID: <20230131013029.qtansdeuvwe7nlzt@yy-desk-7060>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <1a7c87931d303b2e66874e0bbbd791aa308bc918.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a7c87931d303b2e66874e0bbbd791aa308bc918.1673539699.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 08:32:47AM -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Wire up TDX PV map_gpa hypercall to the kvm/mmu backend.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 53 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 4bbde58510a4..486d0f0c6dd1 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1181,6 +1181,57 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>
> +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	gpa_t gpa = tdvmcall_a0_read(vcpu);
> +	gpa_t size = tdvmcall_a1_read(vcpu);
> +	gpa_t end = gpa + size;
> +	gfn_t s = gpa_to_gfn(gpa) & ~kvm_gfn_shared_mask(kvm);
> +	gfn_t e = gpa_to_gfn(end) & ~kvm_gfn_shared_mask(kvm);
> +	int i;
> +
> +	if (!IS_ALIGNED(gpa, 4096) || !IS_ALIGNED(size, 4096) ||
> +	    end < gpa ||
> +	    end > kvm_gfn_shared_mask(kvm) << (PAGE_SHIFT + 1) ||
> +	    kvm_is_private_gpa(kvm, gpa) != kvm_is_private_gpa(kvm, end)) {
> +		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> +		return 1;
> +	}
> +
> +	/*
> +	 * Check how the requested region overlaps with the KVM memory slots.
> +	 * For simplicity, require that it must be contained within a memslot or
> +	 * it must not overlap with any memslots (MMIO).
> +	 */
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
> +		struct kvm_memslot_iter iter;
> +
> +		kvm_for_each_memslot_in_gfn_range(&iter, slots, s, e) {
> +			struct kvm_memory_slot *slot = iter.slot;
> +			gfn_t slot_s = slot->base_gfn;
> +			gfn_t slot_e = slot->base_gfn + slot->npages;
> +
> +			/* no overlap */
> +			if (e < slot_s || s >= slot_e)
> +				continue;
> +
> +			/* contained in slot */
> +			if (slot_s <= s && e <= slot_e) {
> +				if (kvm_slot_can_be_private(slot))
> +					return tdx_vp_vmcall_to_user(vcpu);
> +				continue;
> +			}
> +
> +			break;
> +		}
> +	}
> +
> +	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);

This returns TDG_VP_VMCALL_INVALID_OPERAND if the TD is running with
non-private slots, which looks incorrect to the caller in TD guest(because
the operands are correct). Can we just refuse to create TD if private memory
slot is the only supported slot type for it ?

> +	return 1;
> +}
> +
>  static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>  {
>  	if (tdvmcall_exit_type(vcpu))
> @@ -1206,6 +1257,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>  		 * guest TD doesn't make sense.  No argument check is done.
>  		 */
>  		return tdx_vp_vmcall_to_user(vcpu);
> +	case TDG_VP_VMCALL_MAP_GPA:
> +		return tdx_map_gpa(vcpu);
>  	default:
>  		break;
>  	}
> --
> 2.25.1
>
