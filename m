Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EFC6EEC01
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 03:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbjDZBq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 21:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238025AbjDZBqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 21:46:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD50B447;
        Tue, 25 Apr 2023 18:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682473613; x=1714009613;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Rjgl7bPiOErkScXE8O3rM91FwNEKqt4Nku86OErD44A=;
  b=duU0K8PLbbZq+0kxx8i6gNm6SwRhnUFzNuRKNpHOpkatTjhWfEDaF09R
   Es7bn8z6hddc++JTbxxF39ovUhpphsBzOqQR1VwXppxx6LgjNGxaCZXV+
   7nIlM5Y8KG5jwrNMUsYdkrSKJVDucVFeVWJlQJe4bwgQSMMlMWrTKMkwO
   JilhxKk6fxGmjJCN1ZpbOQUsXwuFarjch3qkR5If4Jr9T05B8cjmabOzt
   X8PQIb+kiNzz9q/vkJRtCsyjQI7xvLvhfxC20TU6LDv6kOTWyk1ILJebX
   EtHCPQYIhLlXt/o7G5KIkbapknJUAnwR5PeZKBtgNSChOr6o5s+cIbJhX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="345711165"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="345711165"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 18:46:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="940013839"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="940013839"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.3.89]) ([10.238.3.89])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 18:46:49 -0700
Message-ID: <69c81e09-eb73-060d-2429-ea3a4e0c1e9a@linux.intel.com>
Date:   Wed, 26 Apr 2023 09:46:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-3-guang.zeng@intel.com>
 <735e3259-26d4-33f1-0e59-8171d1e832e9@linux.intel.com>
 <040a4d50-d25b-c6b9-960a-a85dda30b857@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <040a4d50-d25b-c6b9-960a-a85dda30b857@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/25/2023 11:26 AM, Zeng Guang wrote:
>
> On 4/24/2023 3:43 PM, Binbin Wu wrote:
>>
[...]
>> On 4/20/2023 9:37 PM, Zeng Guang wrote:
>>
>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h 
>> b/arch/x86/include/asm/kvm-x86-ops.h
>> index abccd51dcfca..f76c07f2674b 100644
>> --- a/arch/x86/include/asm/kvm-x86-ops.h
>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
>> @@ -131,6 +131,7 @@ KVM_X86_OP(msr_filter_changed)
>>    KVM_X86_OP(complete_emulated_msr)
>>    KVM_X86_OP(vcpu_deliver_sipi_vector)
>>    KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>> +KVM_X86_OP_OPTIONAL_RET0(check_lass);
>>       #undef KVM_X86_OP
>>    #undef KVM_X86_OP_OPTIONAL
>> diff --git a/arch/x86/include/asm/kvm_host.h 
>> b/arch/x86/include/asm/kvm_host.h
>> index 8ff89a52ef66..31fb8699a1ff 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -69,6 +69,9 @@
>>    #define KVM_X86_NOTIFY_VMEXIT_VALID_BITS 
>> (KVM_X86_NOTIFY_VMEXIT_ENABLED | \
>>                             KVM_X86_NOTIFY_VMEXIT_USER)
>>    +/* x86-specific emulation flags */
>> +#define KVM_X86_EMULFLAG_SKIP_LASS    _BITULL(1)
>> Do you use the flag outside of emulator?
>> For LAM patch, it's planned to move the flags inside emulator.
> IMO, the detailed flag is implementation specific. Is it necessary to 
> bind with emulator
> though it's only used inside emulator ?
For the rest part (i.e., VMExit handlings), the code is already in the 
vendor specific implementations.
The callers are aware of the information to skip LASS check or not.

I plan to do a cleanup to consolidate the flags into one parameter for 
__linearize().
And the consolidated flags value will be extended for LAM and other 
features (e.g. LASS).

I post the proposed patch as following, could you help to check wether 
it is OK for LASS to follow?



arch/x86/kvm/emulate.c     | 20 ++++++++++++++------
  arch/x86/kvm/kvm_emulate.h |  4 ++++
  2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a20bec931764..5fb516bc5731 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -687,8 +687,8 @@ static unsigned insn_alignment(struct 
x86_emulate_ctxt *ctxt, unsigned size)
  static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
                         struct segmented_address addr,
                         unsigned *max_size, unsigned size,
-                       bool write, bool fetch,
-                       enum x86emul_mode mode, ulong *linear)
+                       u64 flags, enum x86emul_mode mode,
+                       ulong *linear)
  {
      struct desc_struct desc;
      bool usable;
@@ -696,6 +696,8 @@ static __always_inline int __linearize(struct 
x86_emulate_ctxt *ctxt,
      u32 lim;
      u16 sel;
      u8  va_bits;
+    bool fetch = !!(flags & X86_EMULFLAG_FETCH);
+    bool write = !!(flags & X86_EMULFLAG_WRITE);

      la = seg_base(ctxt, addr.seg) + addr.ea;
      *max_size = 0;
@@ -757,7 +759,12 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
               ulong *linear)
  {
      unsigned max_size;
-    return __linearize(ctxt, addr, &max_size, size, write, false,
+    u64 flags = 0;
+
+    if (write)
+        flags |= X86_EMULFLAG_WRITE;
+
+    return __linearize(ctxt, addr, &max_size, size, flags,
                 ctxt->mode, linear);
  }

@@ -768,10 +775,11 @@ static inline int assign_eip(struct 
x86_emulate_ctxt *ctxt, ulong dst)
      unsigned max_size;
      struct segmented_address addr = { .seg = VCPU_SREG_CS,
                         .ea = dst };
+    u64 flags = X86_EMULFLAG_FETCH;

      if (ctxt->op_bytes != sizeof(unsigned long))
          addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
-    rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, 
&linear);
+    rc = __linearize(ctxt, addr, &max_size, 1, flags, ctxt->mode, &linear);
      if (rc == X86EMUL_CONTINUE)
          ctxt->_eip = addr.ea;
      return rc;
@@ -896,6 +904,7 @@ static int __do_insn_fetch_bytes(struct 
x86_emulate_ctxt *ctxt, int op_size)
      int cur_size = ctxt->fetch.end - ctxt->fetch.data;
      struct segmented_address addr = { .seg = VCPU_SREG_CS,
                         .ea = ctxt->eip + cur_size };
+    u64 flags = X86_EMULFLAG_FETCH;

      /*
       * We do not know exactly how many bytes will be needed, and
@@ -907,8 +916,7 @@ static int __do_insn_fetch_bytes(struct 
x86_emulate_ctxt *ctxt, int op_size)
       * boundary check itself.  Instead, we use max_size to check
       * against op_size.
       */
-    rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
-             &linear);
+    rc = __linearize(ctxt, addr, &max_size, 0, flags, ctxt->mode, &linear);
      if (unlikely(rc != X86EMUL_CONTINUE))
          return rc;

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index ab65f3a47dfd..5451a37f135f 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -88,6 +88,10 @@ struct x86_instruction_info {
  #define X86EMUL_IO_NEEDED       5 /* IO is needed to complete emulation */
  #define X86EMUL_INTERCEPTED     6 /* Intercepted by nested VMCB/VMCS */

+/* x86-specific emulation flags */
+#define X86_EMULFLAG_FETCH            _BITULL(0)
+#define X86_EMULFLAG_WRITE            _BITULL(1)
+
  struct x86_emulate_ops {
      void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
      /*

>>> +
>>>    /* x86-specific vcpu->requests bit members */
>>>    #define KVM_REQ_MIGRATE_TIMER        KVM_ARCH_REQ(0)
>>>    #define KVM_REQ_REPORT_TPR_ACCESS    KVM_ARCH_REQ(1)
>>> @@ -1706,6 +1709,8 @@ struct kvm_x86_ops {
>>>         * Returns vCPU specific APICv inhibit reasons
>>>         */
>>>        unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct 
>>> kvm_vcpu *vcpu);
>>> +
>>> +    bool (*check_lass)(struct kvm_vcpu *vcpu, u64 access, u64 la, 
>>> u64 flags);
>> The flags may be dropped if the caller knows to skip it or not.
> Probably I don't get you right. Do you mean it need define another 
> function without flags ?
>
>>>    };
>>>       struct kvm_x86_nested_ops {
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index c923d7599d71..581327ede66a 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -8070,6 +8070,59 @@ static void vmx_vm_destroy(struct kvm *kvm)
>>>        free_pages((unsigned long)kvm_vmx->pid_table, 
>>> vmx_get_pid_table_order(kvm));
>>>    }
>>>    +/*
>>> + * Determine whether an access to the linear address causes a LASS 
>>> violation.
>>> + * LASS protection is only effective in long mode. As a 
>>> prerequisite, caller
>>> + * should make sure VM
>> Should be vCPU？
> Similar meaning, I think. :)
>>> running in long mode and invoke this api to do LASS
>>> + * violation check.
>>> + */
>>> +bool __vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, 
>>> u64 flags)
>>> +{
>>> +    bool user_mode, user_as, rflags_ac;
>>> +
>>> +    if (!!(flags & KVM_X86_EMULFLAG_SKIP_LASS) ||
>>> +        !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS))
>>> +        return false;
>>> +
>>> +    WARN_ON_ONCE(!is_long_mode(vcpu));
>>> +
>>> +    user_as = !(la >> 63);
>>> +
>>> +    /*
>>> +     * An access is a supervisor-mode access if CPL < 3 or if it 
>>> implicitly
>>> +     * accesses a system data structure. For implicit accesses to 
>>> system
>>> +     * data structure, the processor acts as if RFLAGS.AC is clear.
>>> +     */
>>> +    if (access & PFERR_IMPLICIT_ACCESS) {
>>> +        user_mode = false;
>>> +        rflags_ac = false;
>>> +    } else {
>>> +        user_mode = vmx_get_cpl(vcpu) == 3;
>>> +        if (!user_mode)
>>> +            rflags_ac = !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
>>> +    }
>>> +
>>> +    if (user_mode != user_as) {
>>> +        /*
>>> +         * Supervisor-mode _data_ accesses to user address space
>>> +         * cause LASS violations only if SMAP is enabled.
>>> +         */
>>> +        if (!user_mode && !(access & PFERR_FETCH_MASK)) {
>>> +            return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) &&
>>> +                   !rflags_ac;
>>> +        } else {
>>> +            return true;
>>> +        }
>>> +    }
>>> +
>>> +    return false;
>>> +}
>>> +
>>> +static bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 
>>> la, u64 flags)
>>> +{
>>> +    return is_long_mode(vcpu) && __vmx_check_lass(vcpu, access, la, 
>>> flags);
>>> +}
>>> +
>>>    static struct kvm_x86_ops vmx_x86_ops __initdata = {
>>>        .name = "kvm_intel",
>>>    @@ -8207,6 +8260,8 @@ static struct kvm_x86_ops vmx_x86_ops 
>>> __initdata = {
>>>        .complete_emulated_msr = kvm_complete_insn_gp,
>>>           .vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>>> +
>>> +    .check_lass = vmx_check_lass,
>>>    };
>>>       static unsigned int vmx_handle_intel_pt_intr(void)
>>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
>>> index a3da84f4ea45..6569385a5978 100644
>>> --- a/arch/x86/kvm/vmx/vmx.h
>>> +++ b/arch/x86/kvm/vmx/vmx.h
>>> @@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct 
>>> kvm_vcpu *vcpu, u32 msr, int type);
>>>    u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>>>    u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>>>    +bool __vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, 
>>> u64 flags);
>>> +
>>>    static inline void vmx_set_intercept_for_msr(struct kvm_vcpu 
>>> *vcpu, u32 msr,
>>>                             int type, bool value)
>>>    {

