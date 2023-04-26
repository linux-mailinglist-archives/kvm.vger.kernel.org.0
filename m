Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2256EEBEF
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 03:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbjDZBcM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 21:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239039AbjDZBcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 21:32:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92B64C02;
        Tue, 25 Apr 2023 18:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682472714; x=1714008714;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/oC0e/XOdhyKD0nsiuHU3f4G9lD/lVeRCMcbxFMAx58=;
  b=YpaBj96ovZMOf6eLldBHxf+g8jKlVMUR8qpABppsWAPnBAfA6SQiPbch
   TspB00Gb/XrL32BVxpfi41mPCKWxlvfZypbrfS+ySU8ONmaJwS68yobds
   EC8zxdD7SR1XcGzVt52U8FWiuoPhR0iyyQGyXAbqPEEamtTXvla5BHCKC
   00wXJbZ2msPxIABHiBbsqiwmEszfau/5kuJwBZ/Lfoi5RMEWeSimzGnag
   YxlKzLpfsvoIO0YLOz05yX2MLho/baSeDRrPijhV15D73pH4ymHEeNMUQ
   BWcQ1w5F351WXCtF2KtGzvcpWviMHDZb+rUhsMdkYJW0pYI6Ghk8HMUQY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="348886974"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="348886974"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 18:31:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="693754288"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="693754288"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 25 Apr 2023 18:31:41 -0700
Date:   Wed, 26 Apr 2023 09:31:40 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH 4/6] KVM: x86: LASS protection on KVM emulation when LASS
 enabled
Message-ID: <20230426013140.6sw6mc55q7q6fmq6@yy-desk-7060>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-5-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420133724.11398-5-guang.zeng@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 09:37:22PM +0800, Zeng Guang wrote:
> Do LASS violation check for instructions emulated by KVM. Note that for
> instructions executed in the guest directly, hardware will perform the
> check.
>
> Not all instruction emulation leads to accesses to guest linear addresses
> because 1) some instrutions like CPUID, RDMSR, don't take memory as
> operands 2) instruction fetch in most cases is already done inside the
> guest.
>
> Four cases in which kvm may access guest linear addresses are identified
> by code inspection:
> - KVM emulator uses segmented address for instruction fetches or data
>   accesses.
> - For implicit data access, KVM emulator gets address to a system data
>   structure(GDT/LDT/IDT/TR).
> - For VMX instruction emulation, KVM gets the address from "VM-exit
>   instruction information" field in VMCS.
> - For SGX ENCLS instruction emulation, KVM gets the address from registers.
>
> LASS violation check applies to these linear address so as to enforce
> mode-based protections as hardware behaves.
>
> As exceptions, the target memory address of emulation of invlpg, branch
> and call instructions doesn't require LASS violation check.
>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/emulate.c    | 36 +++++++++++++++++++++++++++++++-----
>  arch/x86/kvm/vmx/nested.c |  3 +++
>  arch/x86/kvm/vmx/sgx.c    |  2 ++
>  3 files changed, 36 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5cc3efa0e21c..a9a022fd712e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -687,7 +687,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>  				       struct segmented_address addr,
>  				       unsigned *max_size, unsigned size,
>  				       bool write, bool fetch,
> -				       enum x86emul_mode mode, ulong *linear)
> +				       enum x86emul_mode mode, ulong *linear,
> +				       u64 flags)
>  {
>  	struct desc_struct desc;
>  	bool usable;
> @@ -695,6 +696,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>  	u32 lim;
>  	u16 sel;
>  	u8  va_bits;
> +	u64 access = fetch ? PFERR_FETCH_MASK : 0;
>
>  	la = seg_base(ctxt, addr.seg) + addr.ea;
>  	*max_size = 0;
> @@ -740,6 +742,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>  		}
>  		break;
>  	}
> +
> +	if (ctxt->ops->check_lass(ctxt, access, *linear, flags))
> +		goto bad;
> +
>  	if (la & (insn_alignment(ctxt, size) - 1))
>  		return emulate_gp(ctxt, 0);
>  	return X86EMUL_CONTINUE;
> @@ -757,7 +763,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
>  {
>  	unsigned max_size;
>  	return __linearize(ctxt, addr, &max_size, size, write, false,
> -			   ctxt->mode, linear);
> +			   ctxt->mode, linear, 0);
>  }
>
>  static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
> @@ -770,7 +776,10 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
>
>  	if (ctxt->op_bytes != sizeof(unsigned long))
>  		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
> -	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
> +
> +	/* LASS doesn't apply to address for branch and call instructions */
> +	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode,
> +	     &linear, KVM_X86_EMULFLAG_SKIP_LASS);

The emulator.c is common part of x86, so may more common
abstraction like permiession_check_before_paging better ?
Let's also wait other guy's input for this.

>  	if (rc == X86EMUL_CONTINUE)
>  		ctxt->_eip = addr.ea;
>  	return rc;
> @@ -845,6 +854,13 @@ static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
>  static int linear_read_system(struct x86_emulate_ctxt *ctxt, ulong linear,
>  			      void *data, unsigned size)
>  {
> +	if (ctxt->ops->check_lass(ctxt, PFERR_IMPLICIT_ACCESS, linear, 0)) {
> +		ctxt->exception.vector = GP_VECTOR;
> +		ctxt->exception.error_code = 0;
> +		ctxt->exception.error_code_valid = true;
> +		return X86EMUL_PROPAGATE_FAULT;
> +	}
> +
>  	return ctxt->ops->read_std(ctxt, linear, data, size, &ctxt->exception, true);
>  }
>
> @@ -852,6 +868,13 @@ static int linear_write_system(struct x86_emulate_ctxt *ctxt,
>  			       ulong linear, void *data,
>  			       unsigned int size)
>  {
> +	if (ctxt->ops->check_lass(ctxt, PFERR_IMPLICIT_ACCESS, linear, 0)) {
> +		ctxt->exception.vector = GP_VECTOR;
> +		ctxt->exception.error_code = 0;
> +		ctxt->exception.error_code_valid = true;
> +		return X86EMUL_PROPAGATE_FAULT;
> +	}
> +
>  	return ctxt->ops->write_std(ctxt, linear, data, size, &ctxt->exception, true);
>  }
>
> @@ -907,7 +930,7 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>  	 * against op_size.
>  	 */
>  	rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
> -			 &linear);
> +			 &linear, 0);
>  	if (unlikely(rc != X86EMUL_CONTINUE))
>  		return rc;
>
> @@ -3432,8 +3455,11 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
>  {
>  	int rc;
>  	ulong linear;
> +	unsigned max_size;
>
> -	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
> +	/* LASS doesn't apply to the memory address for invlpg */
> +	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, false, false,
> +	     ctxt->mode, &linear, KVM_X86_EMULFLAG_SKIP_LASS);
>  	if (rc == X86EMUL_CONTINUE)
>  		ctxt->ops->invlpg(ctxt, linear);
>  	/* Disable writeback. */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c8ae9d0e59b3..55c88c4593a6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4974,6 +4974,9 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>  		 * destination for long mode!
>  		 */
>  		exn = is_noncanonical_address(*ret, vcpu);
> +
> +		if (!exn)
> +			exn = __vmx_check_lass(vcpu, 0, *ret, 0);
>  	} else {
>  		/*
>  		 * When not in long mode, the virtual/linear address is
> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> index b12da2a6dec9..30cb5d0980be 100644
> --- a/arch/x86/kvm/vmx/sgx.c
> +++ b/arch/x86/kvm/vmx/sgx.c
> @@ -37,6 +37,8 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
>  		fault = true;
>  	} else if (likely(is_long_mode(vcpu))) {
>  		fault = is_noncanonical_address(*gva, vcpu);
> +		if (!fault)
> +			fault = __vmx_check_lass(vcpu, 0, *gva, 0);
>  	} else {
>  		*gva &= 0xffffffff;
>  		fault = (s.unusable) ||
> --
> 2.27.0
>
