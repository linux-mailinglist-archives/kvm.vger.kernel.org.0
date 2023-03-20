Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869176C116E
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 13:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCTMEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 08:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjCTMEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:04:33 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53F726585
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 05:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679313871; x=1710849871;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LnALe6gwwtSZGw1sQMNhWrIfiqezQPQwV4E2PqrI4P8=;
  b=nRfXneip1s2n4KPfQu4YzB5mbr9C6CMcuD2ukcnfn8rzKqtSqHIMRlQT
   9aQAOoEbHH79R+2vzV0sK/2+rNv7cmu4Jj+JJUIm/m6kuTVHzajE8GdkZ
   2lJRS/meAJo5FE3HIxOGXdNHKgDhzGbUkM0T48SLFT9nZUObGml1ZplKb
   IXCZjvzqLiV7haWbWpZefy0PqL4st3GBdjhbEtPnTI71HoLmKn+vsma+C
   t3im8XSQkswzIKfjBbjEgCsObukNRCh4z7lZzmnFHHoc7s43CRDpynnus
   4FJhs8PKPDBHMU7eMJztdHKwNSS1WVy948fOtCvZNP5DfNtbPCoF51ksh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="327014246"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="327014246"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:04:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="745350534"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="745350534"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.177]) ([10.249.172.177])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:04:26 -0700
Message-ID: <b5a90bf8-5f13-6250-1ecd-c42df9789aba@linux.intel.com>
Date:   Mon, 20 Mar 2023 20:04:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 6/7] KVM: x86: Untag address when LAM applicable
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     chao.gao@intel.com, robert.hu@linux.intel.com
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-7-binbin.wu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230319084927.29607-7-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/19/2023 4:49 PM, Binbin Wu wrote:
> Untag address for 64-bit memory/mmio operand in instruction emulations
> and vmexit handlers when LAM is applicable.
>
> For instruction emulation, untag address in __linearize() before
> canonical check. LAM doesn't apply to instruction fetch and invlpg,
> use KVM_X86_UNTAG_ADDR_SKIP_LAM to skip LAM untag.
>
> For vmexit handlings related to 64-bit linear address:
> - Cases need to untag address
>    Operand(s) of VMX instructions and INVPCID
>    Operand(s) of SGX ENCLS
>    Linear address in INVVPID descriptor.
> - Cases LAM doesn't apply to (no change needed)
>    Operand of INVLPG
>    Linear address in INVPCID descriptor
>
> Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
>   arch/x86/kvm/emulate.c    | 25 +++++++++++++++++--------
>   arch/x86/kvm/vmx/nested.c |  2 ++
>   arch/x86/kvm/vmx/sgx.c    |  1 +
>   arch/x86/kvm/x86.c        |  4 ++++
>   4 files changed, 24 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index a630c5db971c..c46f0162498e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -688,7 +688,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>   				       struct segmented_address addr,
>   				       unsigned *max_size, unsigned size,
>   				       bool write, bool fetch,
> -				       enum x86emul_mode mode, ulong *linear)
> +				       enum x86emul_mode mode, ulong *linear,
> +				       u64 untag_flags)
>   {
>   	struct desc_struct desc;
>   	bool usable;
> @@ -701,9 +702,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>   	*max_size = 0;
>   	switch (mode) {
>   	case X86EMUL_MODE_PROT64:
> -		*linear = la;
> +		*linear = static_call(kvm_x86_untag_addr)(ctxt->vcpu, la, untag_flags);

Per Sean's comment "Derefencing ctxt->vcpu in the emulator is not 
allowed" in V5, I will update this as following:

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c46f0162498e..5fbce7bb3bc8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -702,7 +702,7 @@ static __always_inline int __linearize(struct 
x86_emulate_ctxt *ctxt,
         *max_size = 0;
         switch (mode) {
         case X86EMUL_MODE_PROT64:
-               *linear = static_call(kvm_x86_untag_addr)(ctxt->vcpu, 
la, untag_flags);
+               *linear = ctxt->ops->untag_addr(ctxt, la, untag_flags);

                 va_bits = ctxt_virt_addr_bits(ctxt);
                 if (!__is_canonical_address(*linear, va_bits))
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 2d9662be8333..14b32c7c2abb 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -224,6 +224,8 @@ struct x86_emulate_ops {
         int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
         void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
         int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
+
+       u64 (*untag_addr)(struct x86_emulate_ctxt *ctxt, u64 addr, u64 
flags);
  };

  /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d85f87a19f58..a3560ea7560d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8190,6 +8190,11 @@ static void emulator_vm_bugged(struct 
x86_emulate_ctxt *ctxt)
                 kvm_vm_bugged(kvm);
  }

+static u64 emulator_untag_addr(struct x86_emulate_ctxt *ctxt, u64 addr, 
u64 flags)
+{
+       return static_call(kvm_x86_untag_addr)(emul_to_vcpu(ctxt), addr, 
flags);
+}
+
  static const struct x86_emulate_ops emulate_ops = {
         .vm_bugged           = emulator_vm_bugged,
         .read_gpr            = emulator_read_gpr,
@@ -8234,6 +8239,7 @@ static const struct x86_emulate_ops emulate_ops = {
         .leave_smm           = emulator_leave_smm,
         .triple_fault        = emulator_triple_fault,
         .set_xcr             = emulator_set_xcr,
+       .untag_addr          = emulator_untag_addr,
  };


> +
>   		va_bits = ctxt_virt_addr_bits(ctxt);
> -		if (!__is_canonical_address(la, va_bits))
> +		if (!__is_canonical_address(*linear, va_bits))
>   			goto bad;
>   
>   		*max_size = min_t(u64, ~0u, (1ull << va_bits) - la);
> @@ -757,8 +759,8 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
>   		     ulong *linear)
>   {
>   	unsigned max_size;
> -	return __linearize(ctxt, addr, &max_size, size, write, false,
> -			   ctxt->mode, linear);
> +	return __linearize(ctxt, addr, &max_size, size, false, false,
> +			   ctxt->mode, linear, 0);
>   }
>   
>   static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
> @@ -771,7 +773,9 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
>   
>   	if (ctxt->op_bytes != sizeof(unsigned long))
>   		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
> -	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
> +	/* skip LAM untag for instruction */
> +	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode,
> +		         &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
>   	if (rc == X86EMUL_CONTINUE)
>   		ctxt->_eip = addr.ea;
>   	return rc;
> @@ -906,9 +910,11 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>   	 * __linearize is called with size 0 so that it does not do any
>   	 * boundary check itself.  Instead, we use max_size to check
>   	 * against op_size.
> +	 *
> +	 * skip LAM untag for instruction
>   	 */
>   	rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
> -			 &linear);
> +			 &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
>   	if (unlikely(rc != X86EMUL_CONTINUE))
>   		return rc;
>   
> @@ -3433,8 +3439,11 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
>   {
>   	int rc;
>   	ulong linear;
> +	unsigned max_size;
>   
> -	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
> +	/* skip untag for invlpg since LAM is not applied to invlpg */
> +	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, false, false,
> +			 ctxt->mode, &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
>   	if (rc == X86EMUL_CONTINUE)
>   		ctxt->ops->invlpg(ctxt, linear);
>   	/* Disable writeback. */
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2eb258992d63..dd1d28a0d147 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4970,6 +4970,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
>   		else
>   			*ret = off;
>   
> +		*ret = vmx_untag_addr(vcpu, *ret, 0);
>   		/* Long mode: #GP(0)/#SS(0) if the memory address is in a
>   		 * non-canonical form. This is the only check on the memory
>   		 * destination for long mode!
> @@ -5787,6 +5788,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>   	vpid02 = nested_get_vpid02(vcpu);
>   	switch (type) {
>   	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
> +		operand.gla = vmx_untag_addr(vcpu, operand.gla, 0);
>   		if (!operand.vpid ||
>   		    is_noncanonical_address(operand.gla, vcpu))
>   			return nested_vmx_fail(vcpu,
> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> index 0574030b071f..527f1a902c65 100644
> --- a/arch/x86/kvm/vmx/sgx.c
> +++ b/arch/x86/kvm/vmx/sgx.c
> @@ -37,6 +37,7 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
>   	if (!IS_ALIGNED(*gva, alignment)) {
>   		fault = true;
>   	} else if (likely(is_64_bit_mode(vcpu))) {
> +		*gva = vmx_untag_addr(vcpu, *gva, 0);
>   		fault = is_noncanonical_address(*gva, vcpu);
>   	} else {
>   		*gva &= 0xffffffff;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e74af72f53ec..d85f87a19f58 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13233,6 +13233,10 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
>   
>   	switch (type) {
>   	case INVPCID_TYPE_INDIV_ADDR:
> +		/*
> +		 * LAM doesn't apply to the linear address in the descriptor,
> +		 * still need to be canonical
> +		 */
>   		if ((!pcid_enabled && (operand.pcid != 0)) ||
>   		    is_noncanonical_address(operand.gla, vcpu)) {
>   			kvm_inject_gp(vcpu, 0);
