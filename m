Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40529771B07
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 09:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjHGHEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 03:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjHGHEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 03:04:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFF31736;
        Mon,  7 Aug 2023 00:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691391837; x=1722927837;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OYx8ib8UwDw50WR3f9wPZdPj36xMXCE8nxGRK88XDgw=;
  b=SZW9mlZbpCJBFMJ1nj0PwBQcuWI3a6iAbTeDqnhDPi7c8uwoWuxzGQjM
   LJ5N60c6pi1t9ezQ2IGXhvG4jwzqYnMc1OKvB2uNt9e4Qm7sEslIEov7S
   gaNKRNbi5USs5YjZwt9bk0chiny3J/QlvnNmdZaOvqqlF4VdYq7psRaPQ
   u2ll2OEVOeOg+yLQnBv3YJ+s9OhxYpwstcOJ59TH5iCDMQS/8e1wbyviv
   mXfW5/2NbRCqLROBaObGGEzEZdHhBWB1e83Jpy+SUu7CZ7M/lG2hPWcOB
   MAAWK4AB6UDYgTinkCCW9+Df2hVmbJkgzMyY5GniiGRsxbxUVhUIKn/X5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10794"; a="367930720"
X-IronPort-AV: E=Sophos;i="6.01,261,1684825200"; 
   d="scan'208";a="367930720"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 00:03:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10794"; a="730844393"
X-IronPort-AV: E=Sophos;i="6.01,261,1684825200"; 
   d="scan'208";a="730844393"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.230]) ([10.238.9.230])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2023 00:03:53 -0700
Message-ID: <8c628549-a388-afd5-3c6e-a956fbce7f79@linux.intel.com>
Date:   Mon, 7 Aug 2023 15:03:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2 6/8] KVM: VMX: Implement and apply
 vmx_is_lass_violation() for LASS protection
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230719024558.8539-1-guang.zeng@intel.com>
 <20230719024558.8539-7-guang.zeng@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230719024558.8539-7-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/19/2023 10:45 AM, Zeng Guang wrote:
> Implement and wire up vmx_is_lass_violation() in kvm_x86_ops for VMX.
>
> LASS violation check takes effect in KVM emulation of instruction fetch
> and data access including implicit access when vCPU is running in long
> mode, and also involved in emulation of VMX instruction and SGX ENCLS
> instruction to enforce the mode-based protections before paging.
>
> But the target memory address of emulation of TLB invalidation and branch
> instructions aren't subject to LASS as exceptions.
>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> ---
>   arch/x86/kvm/vmx/nested.c |  3 ++-
>   arch/x86/kvm/vmx/sgx.c    |  4 ++++
>   arch/x86/kvm/vmx/vmx.c    | 35 +++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/vmx.h    |  3 +++
>   4 files changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e35cf0bd0df9..72e78566a3b6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4985,7 +4985,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>   		 * non-canonical form. This is the only check on the memory
>   		 * destination for long mode!
>   		 */
> -		exn = is_noncanonical_address(*ret, vcpu);
> +		exn = is_noncanonical_address(*ret, vcpu) ||
> +		      vmx_is_lass_violation(vcpu, *ret, len, 0);
>   	} else {
>   		/*
>   		 * When not in long mode, the virtual/linear address is
> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> index 2261b684a7d4..f8de637ce634 100644
> --- a/arch/x86/kvm/vmx/sgx.c
> +++ b/arch/x86/kvm/vmx/sgx.c
> @@ -46,6 +46,10 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
>   			((s.base != 0 || s.limit != 0xffffffff) &&
>   			(((u64)*gva + size - 1) > s.limit + 1));
>   	}
> +
> +	if (!fault)
> +		fault = vmx_is_lass_violation(vcpu, *gva, size, 0);
> +
>   	if (fault)
>   		kvm_inject_gp(vcpu, 0);
>   	return fault ? -EINVAL : 0;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 44fb619803b8..15a7c6e7a25d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8127,6 +8127,40 @@ static void vmx_vm_destroy(struct kvm *kvm)
>   	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>   }
>   
> +bool vmx_is_lass_violation(struct kvm_vcpu *vcpu, unsigned long addr,
> +			   unsigned int size, unsigned int flags)
> +{
> +	const bool is_supervisor_address = !!(addr & BIT_ULL(63));
> +	const bool implicit = !!(flags & X86EMUL_F_IMPLICIT);
> +	const bool fetch = !!(flags & X86EMUL_F_FETCH);
> +	const bool is_wraparound_access = size ? (addr + size - 1) < addr : false;
> +
> +	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || !is_long_mode(vcpu))
> +		return false;
> +
> +	/*
> +	 * INVTLB isn't subject to LASS, e.g. to allow invalidating userspace
> +	 * addresses without toggling RFLAGS.AC.  Branch targets aren't subject
> +	 * to LASS in order to simplifiy far control transfers (the subsequent
s/simplifiy/simplifiy

> +	 * fetch will enforce LASS as appropriate).
> +	 */
> +	if (flags & (X86EMUL_F_BRANCH | X86EMUL_F_INVTLB))
> +		return false;
> +
> +	if (!implicit && vmx_get_cpl(vcpu) == 3)
> +		return is_supervisor_address;
> +
> +	/* LASS is enforced for supervisor-mode access iff SMAP is enabled. */
To be more accurate, supervisor-mode data access.
Also, "iff" here is not is a typo for "if" or it stands for "if and only 
if"?
It is not accureate to use "if and only if" here because beside SMAP, 
there are other conditions, i.e. implicit or RFLAGS.AC.

> +	if (!fetch && !kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
> +		return false;
> +
> +	/* Like SMAP, RFLAGS.AC disables LASS checks in supervisor mode. */
> +	if (!fetch && !implicit && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
> +		return false;
> +
> +	return is_wraparound_access ? true : !is_supervisor_address;
> +}
> +
>   static struct kvm_x86_ops vmx_x86_ops __initdata = {
>   	.name = KBUILD_MODNAME,
>   
> @@ -8266,6 +8300,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>   	.complete_emulated_msr = kvm_complete_insn_gp,
>   
>   	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> +	.is_lass_violation = vmx_is_lass_violation,
>   };
>   
>   static unsigned int vmx_handle_intel_pt_intr(void)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 9e66531861cf..c1e541a790bb 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -433,6 +433,9 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>   u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>   u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>   
> +bool vmx_is_lass_violation(struct kvm_vcpu *vcpu, unsigned long addr,
> +			   unsigned int size, unsigned int flags);
> +
>   static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>   					     int type, bool value)
>   {

