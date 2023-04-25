Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DDA6EDA5B
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 04:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjDYCwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 22:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjDYCwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 22:52:35 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7126049F8;
        Mon, 24 Apr 2023 19:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682391153; x=1713927153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xYB3Y4qQl0O4hmoYZvL3xT0WVRszCO80tbNb3JjWM7g=;
  b=H3yJmSLUZLhcnigpuo+ytpetbGKVs3bz7Hqt8HFSGPR++RLrxauF/ZLH
   Dcib7l6EK4Nv0HsSfT55pTfXXQJPml/fMbY0xMK2DC/1Qu4WUsoz2UdXt
   r9wmCe0/RP+X0YvpnOxqKvV1trAdKfR3jZMBQNlUKyMNo2Ubybbt3hc7Y
   riDvLh47YZ1PbwQx2Jbpq+3ep8+SzTHBJK+SxB24Kcadiq/qzZDGKZFB+
   bXWafTfkBEQS/beDHQ469KhJ3kyH+reBrbZsdzzPg5L1eElMfUZc0k5FG
   1IQrwW7sjdLohJdz+Gudgk2LonuHcMP+PjluAgJ9oWam9LEMnrlOUrBTf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="335531191"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="335531191"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 19:52:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="762692854"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="762692854"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.34]) ([10.238.10.34])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 19:52:25 -0700
Message-ID: <45b25ffe-8268-5efa-751b-c8cdd7b98988@linux.intel.com>
Date:   Tue, 25 Apr 2023 10:52:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/6] KVM: x86: LASS protection on KVM emulation when LASS
 enabled
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-5-guang.zeng@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230420133724.11398-5-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/20/2023 9:37 PM, Zeng Guang wrote:
> Do LASS violation check for instructions emulated by KVM. Note that for
> instructions executed in the guest directly, hardware will perform the
> check.
>
> Not all instruction emulation leads to accesses to guest linear addresses
> because 1) some instrutions like CPUID, RDMSR, don't take memory as

/s/instrutions/instructions
> operands 2) instruction fetch in most cases is already done inside the
> guest.
What are the instruction fetch cases not covered in non-root mode?
And IIUC, the patch actually doesn't distinguish them and alway checks 
LASS voilation
for instruction fetch in instruction emulation, right?

>
> Four cases in which kvm may access guest linear addresses are identified
> by code inspection:
> - KVM emulator uses segmented address for instruction fetches or data
>    accesses.
> - For implicit data access, KVM emulator gets address to a system data
to or from?

>    structure(GDT/LDT/IDT/TR).
> - For VMX instruction emulation, KVM gets the address from "VM-exit
>    instruction information" field in VMCS.
> - For SGX ENCLS instruction emulation, KVM gets the address from registers.
>
> LASS violation check applies to these linear address so as to enforce
address -> addresses

> mode-based protections as hardware behaves.
>
> As exceptions, the target memory address of emulation of invlpg, branch
> and call instructions doesn't require LASS violation check.
>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>   arch/x86/kvm/emulate.c    | 36 +++++++++++++++++++++++++++++++-----
>   arch/x86/kvm/vmx/nested.c |  3 +++
>   arch/x86/kvm/vmx/sgx.c    |  2 ++
>   3 files changed, 36 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5cc3efa0e21c..a9a022fd712e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -687,7 +687,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>   				       struct segmented_address addr,
>   				       unsigned *max_size, unsigned size,
>   				       bool write, bool fetch,
> -				       enum x86emul_mode mode, ulong *linear)
> +				       enum x86emul_mode mode, ulong *linear,
> +				       u64 flags)
>   {
>   	struct desc_struct desc;
>   	bool usable;
> @@ -695,6 +696,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>   	u32 lim;
>   	u16 sel;
>   	u8  va_bits;
> +	u64 access = fetch ? PFERR_FETCH_MASK : 0;
>   
>   	la = seg_base(ctxt, addr.seg) + addr.ea;
>   	*max_size = 0;
> @@ -740,6 +742,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>   		}
>   		break;
>   	}
> +
> +	if (ctxt->ops->check_lass(ctxt, access, *linear, flags))
> +		goto bad;
> +
>   	if (la & (insn_alignment(ctxt, size) - 1))
>   		return emulate_gp(ctxt, 0);
>   	return X86EMUL_CONTINUE;
> @@ -757,7 +763,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
>   {
>   	unsigned max_size;
>   	return __linearize(ctxt, addr, &max_size, size, write, false,
> -			   ctxt->mode, linear);
> +			   ctxt->mode, linear, 0);
>   }
>   
>   static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
> @@ -770,7 +776,10 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
>   
>   	if (ctxt->op_bytes != sizeof(unsigned long))
>   		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
> -	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
> +
> +	/* LASS doesn't apply to address for branch and call instructions */
> +	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode,
> +	     &linear, KVM_X86_EMULFLAG_SKIP_LASS);
>   	if (rc == X86EMUL_CONTINUE)
>   		ctxt->_eip = addr.ea;
>   	return rc;
> @@ -845,6 +854,13 @@ static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
>   static int linear_read_system(struct x86_emulate_ctxt *ctxt, ulong linear,
>   			      void *data, unsigned size)
>   {
> +	if (ctxt->ops->check_lass(ctxt, PFERR_IMPLICIT_ACCESS, linear, 0)) {
> +		ctxt->exception.vector = GP_VECTOR;
> +		ctxt->exception.error_code = 0;
> +		ctxt->exception.error_code_valid = true;
> +		return X86EMUL_PROPAGATE_FAULT;
> +	}
> +
>   	return ctxt->ops->read_std(ctxt, linear, data, size, &ctxt->exception, true);
>   }
>   
> @@ -852,6 +868,13 @@ static int linear_write_system(struct x86_emulate_ctxt *ctxt,
>   			       ulong linear, void *data,
>   			       unsigned int size)
>   {
> +	if (ctxt->ops->check_lass(ctxt, PFERR_IMPLICIT_ACCESS, linear, 0)) {
> +		ctxt->exception.vector = GP_VECTOR;
> +		ctxt->exception.error_code = 0;
> +		ctxt->exception.error_code_valid = true;
> +		return X86EMUL_PROPAGATE_FAULT;
> +	}
> +
>   	return ctxt->ops->write_std(ctxt, linear, data, size, &ctxt->exception, true);
>   }
>   
> @@ -907,7 +930,7 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>   	 * against op_size.
>   	 */
>   	rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
> -			 &linear);
> +			 &linear, 0);
>   	if (unlikely(rc != X86EMUL_CONTINUE))
>   		return rc;
>   
> @@ -3432,8 +3455,11 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
>   {
>   	int rc;
>   	ulong linear;
> +	unsigned max_size;
>   
> -	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
> +	/* LASS doesn't apply to the memory address for invlpg */
> +	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, false, false,
> +	     ctxt->mode, &linear, KVM_X86_EMULFLAG_SKIP_LASS);
>   	if (rc == X86EMUL_CONTINUE)
>   		ctxt->ops->invlpg(ctxt, linear);
>   	/* Disable writeback. */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c8ae9d0e59b3..55c88c4593a6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4974,6 +4974,9 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>   		 * destination for long mode!
>   		 */
>   		exn = is_noncanonical_address(*ret, vcpu);
> +
> +		if (!exn)
> +			exn = __vmx_check_lass(vcpu, 0, *ret, 0);
>   	} else {
>   		/*
>   		 * When not in long mode, the virtual/linear address is
> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> index b12da2a6dec9..30cb5d0980be 100644
> --- a/arch/x86/kvm/vmx/sgx.c
> +++ b/arch/x86/kvm/vmx/sgx.c
> @@ -37,6 +37,8 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
>   		fault = true;
>   	} else if (likely(is_long_mode(vcpu))) {
>   		fault = is_noncanonical_address(*gva, vcpu);
> +		if (!fault)
> +			fault = __vmx_check_lass(vcpu, 0, *gva, 0);
>   	} else {
>   		*gva &= 0xffffffff;
>   		fault = (s.unusable) ||

