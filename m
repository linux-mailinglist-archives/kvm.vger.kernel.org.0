Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A84E6EA56D
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjDUH5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbjDUH5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:57:22 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2F09020
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 00:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682063841; x=1713599841;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zISSwR/oFutXsofxbaxf9w7K+VS+6NnKlxMahDkXT38=;
  b=dKhTc6Cq40yMx9+q4+FVVsK1Ud6Cbh75GxqtdJvlwbPq1XvcOpGZUKEI
   iSR/8+Ac91bhhtk4OsWOiHu0d2+1OAu5nA0/V9JiUZ+rUKVVz5ygOxq47
   MuA46ZtNxgPpe/ETb8CuNz8p9Uv8bZ7E4kMNDWDDqzP7GZ+WxgAlDjXi2
   l2xA5r0sZjPwIqcRhHVlutBnNjMD59dvb6tJcCJmZAcjgx+40YpossDPH
   +KwrslLJXHkkuZEI7wFesz2Et7j4WzbtaJHF2AjIp6sgwbn6hZqIG4OnT
   lE14ANQYwDpiMNqz6YhKh/NDUuoYKxN6B2aoMA2aN/Z1XoBvGIG6RtW7k
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="348734078"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="348734078"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:57:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="938397896"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="938397896"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.158]) ([10.254.214.158])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:57:18 -0700
Message-ID: <f1d564d1-572e-75fc-aa68-05b52abc2914@linux.intel.com>
Date:   Fri, 21 Apr 2023 15:57:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 4/5] KVM: x86: Untag address when LAM applicable
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kai.huang@intel.com, xuelian.guo@intel.com,
        robert.hu@linux.intel.com
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-5-binbin.wu@linux.intel.com>
 <ZD+NiODiAiIY55Fx@chao-env>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZD+NiODiAiIY55Fx@chao-env>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/19/2023 2:43 PM, Chao Gao wrote:
> On Tue, Apr 04, 2023 at 09:09:22PM +0800, Binbin Wu wrote:
>> Untag address for 64-bit memory/mmio operand in instruction emulations
>> and vmexit handlers when LAM is applicable.
>>
>> For instruction emulation, untag address in __linearize() before
>> canonical check. LAM doesn't apply to instruction fetch and invlpg,
>> use KVM_X86_UNTAG_ADDR_SKIP_LAM to skip LAM untag.
>>
>> For vmexit handlings related to 64-bit linear address:
>> - Cases need to untag address
>>   Operand(s) of VMX instructions and INVPCID
>>   Operand(s) of SGX ENCLS
>>   Linear address in INVVPID descriptor.
>> - Cases LAM doesn't apply to (no change needed)
>>   Operand of INVLPG
>>   Linear address in INVPCID descriptor
>>
>> Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>> arch/x86/kvm/emulate.c     | 23 ++++++++++++++++++-----
>> arch/x86/kvm/kvm_emulate.h |  2 ++
>> arch/x86/kvm/vmx/nested.c  |  4 ++++
>> arch/x86/kvm/vmx/sgx.c     |  1 +
>> arch/x86/kvm/x86.c         | 10 ++++++++++
>> 5 files changed, 35 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index a20bec931764..b7df465eccf2 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -688,7 +688,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>> 				       struct segmented_address addr,
>> 				       unsigned *max_size, unsigned size,
>> 				       bool write, bool fetch,
>> -				       enum x86emul_mode mode, ulong *linear)
>> +				       enum x86emul_mode mode, ulong *linear,
>> +				       u64 untag_flags)
> @write and @fetch are like flags. I think we can consolidate them into
> the @flags first as a cleanup patch and then add a flag for LAM.

OK. Here is the proposed cleanup patch:


--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -687,8 +687,8 @@ static unsigned insn_alignment(struct 
x86_emulate_ctxt *ctxt, unsigned size)
  static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
                                        struct segmented_address addr,
                                        unsigned *max_size, unsigned size,
-                                      bool write, bool fetch,
-                                      enum x86emul_mode mode, ulong 
*linear)
+                                      u64 flags, enum x86emul_mode mode,
+                                      ulong *linear)
  {
         struct desc_struct desc;
         bool usable;
@@ -696,6 +696,8 @@ static __always_inline int __linearize(struct 
x86_emulate_ctxt *ctxt,
         u32 lim;
         u16 sel;
         u8  va_bits;
+       bool fetch = !!(flags & KVM_X86_EMULFLAG_FETCH);
+       bool write = !!(flags & KVM_X86_EMULFLAG_WRITE);

         la = seg_base(ctxt, addr.seg) + addr.ea;
         *max_size = 0;
@@ -757,7 +759,12 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
                      ulong *linear)
  {
         unsigned max_size;
-       return __linearize(ctxt, addr, &max_size, size, write, false,
+       u64 flags = 0;
+
+       if (write)
+               flags |= KVM_X86_EMULFLAG_WRITE;
+
+       return __linearize(ctxt, addr, &max_size, size, flags,
                            ctxt->mode, linear);
  }

@@ -768,10 +775,11 @@ static inline int assign_eip(struct 
x86_emulate_ctxt *ctxt, ulong dst)
         unsigned max_size;
         struct segmented_address addr = { .seg = VCPU_SREG_CS,
                                            .ea = dst };
+       u64 flags = KVM_X86_EMULFLAG_FETCH;

         if (ctxt->op_bytes != sizeof(unsigned long))
                 addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
-       rc = __linearize(ctxt, addr, &max_size, 1, false, true, 
ctxt->mode, &linear);
+       rc = __linearize(ctxt, addr, &max_size, 1, flags, ctxt->mode, 
&linear);
         if (rc == X86EMUL_CONTINUE)
                 ctxt->_eip = addr.ea;
         return rc;
@@ -896,6 +904,7 @@ static int __do_insn_fetch_bytes(struct 
x86_emulate_ctxt *ctxt, int op_size)
         int cur_size = ctxt->fetch.end - ctxt->fetch.data;
         struct segmented_address addr = { .seg = VCPU_SREG_CS,
                                            .ea = ctxt->eip + cur_size };
+       u64 flags = KVM_X86_EMULFLAG_FETCH;

         /*
          * We do not know exactly how many bytes will be needed, and
@@ -907,8 +916,7 @@ static int __do_insn_fetch_bytes(struct 
x86_emulate_ctxt *ctxt, int op_size)
          * boundary check itself.  Instead, we use max_size to check
          * against op_size.
          */
-       rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
-                        &linear);
+       rc = __linearize(ctxt, addr, &max_size, 0, flags, ctxt->mode, 
&linear);
         if (unlikely(rc != X86EMUL_CONTINUE))
                 return rc;

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8167b47b8c8..8076e013ff9f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -48,6 +48,15 @@ void kvm_spurious_fault(void);
  #define KVM_SVM_DEFAULT_PLE_WINDOW_MAX USHRT_MAX
  #define KVM_SVM_DEFAULT_PLE_WINDOW     3000

+/* x86-specific emulation flags */
+#define KVM_X86_EMULFLAG_FETCH                 _BITULL(0)
+#define KVM_X86_EMULFLAG_WRITE                 _BITULL(1)


And the following two will be defined for untag:

#define KVM_X86_EMULFLAG_SKIP_UNTAG_VMX     _BITULL(2)
#define KVM_X86_EMULFLAG_SKIP_UNTAG_SVM     _BITULL(3) /* reserved for 
SVM */


