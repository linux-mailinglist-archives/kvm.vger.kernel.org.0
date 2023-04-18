Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C216E57E5
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 05:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjDRDjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 23:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjDRDjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 23:39:01 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE49D3594
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 20:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681789138; x=1713325138;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Uxvj23jD7k/sARpP4dCl/Dt2A122paNqEtn0lkZMlsA=;
  b=l2ihwnA2FchD6rCspZZgzv10jWN0YFmWh0iSpBd/O+tBr0kq5Jh2lhwo
   UMW8beYGHZjgnK7LlSbEz2tlYuDsny2ZIL1mf0uRIl3ib25f7ko2emaS3
   ngQWSb1cFhUYJtvPzJl+cpuUcw0SN6GZ/BF9XsTaXqHPyIgMVCMysB/Cm
   2hSB1V5+wJCMKBE3b+Wic2q06hmPwrYjcv5ftkX29iE9boApZCnarYLiC
   Uca3/7bmjBdxldjqL7XuH12JKQglKEpe/cFNBqHwXRgXEnD6WZRnoXwSG
   gZ4h4nVFDn55MFfU7gOr3tdpwCvV+LsuP2gm0G4xXENiQMdld2YfNheSz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="345064420"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="345064420"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 20:38:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="684409584"
X-IronPort-AV: E=Sophos;i="5.99,206,1677571200"; 
   d="scan'208";a="684409584"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.174.28]) ([10.249.174.28])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 20:38:56 -0700
Message-ID: <846d54b3-6512-1846-959b-e6489f51cc98@linux.intel.com>
Date:   Tue, 18 Apr 2023 11:38:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 4/5] KVM: x86: Untag address when LAM applicable
To:     Zeng Guang <guang.zeng@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Guo, Xuelian" <Xuelian.Guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-5-binbin.wu@linux.intel.com>
 <4d9ea8b5-1299-4b3f-9cdc-f19116ad2ef6@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <4d9ea8b5-1299-4b3f-9cdc-f19116ad2ef6@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/18/2023 11:28 AM, Zeng Guang wrote:
>
> On 4/4/2023 9:09 PM, Binbin Wu wrote:
>> Untag address for 64-bit memory/mmio operand in instruction emulations
>> and vmexit handlers when LAM is applicable.
>>
>> For instruction emulation, untag address in __linearize() before
>> canonical check. LAM doesn't apply to instruction fetch and invlpg,
>> use KVM_X86_UNTAG_ADDR_SKIP_LAM to skip LAM untag.
>>
>> For vmexit handlings related to 64-bit linear address:
>> - Cases need to untag address
>>    Operand(s) of VMX instructions and INVPCID
>>    Operand(s) of SGX ENCLS
>>    Linear address in INVVPID descriptor.
>> - Cases LAM doesn't apply to (no change needed)
>>    Operand of INVLPG
>>    Linear address in INVPCID descriptor
>>
>> Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
>> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>>   arch/x86/kvm/emulate.c     | 23 ++++++++++++++++++-----
>>   arch/x86/kvm/kvm_emulate.h |  2 ++
>>   arch/x86/kvm/vmx/nested.c  |  4 ++++
>>   arch/x86/kvm/vmx/sgx.c     |  1 +
>>   arch/x86/kvm/x86.c         | 10 ++++++++++
>>   5 files changed, 35 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index a20bec931764..b7df465eccf2 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -688,7 +688,8 @@ static __always_inline int __linearize(struct 
>> x86_emulate_ctxt *ctxt,
>>                          struct segmented_address addr,
>>                          unsigned *max_size, unsigned size,
>>                          bool write, bool fetch,
>> -                       enum x86emul_mode mode, ulong *linear)
>> +                       enum x86emul_mode mode, ulong *linear,
>> +                       u64 untag_flags)
>
> IMO, here should be "u64 flags" instead of "u64 untag_flags". Emulator 
> can
> use it as flag combination for other purpose.

yes, make sense with the advise you suggested in patch 3.


>
>
>>   {
>>       struct desc_struct desc;
>>       bool usable;
>> @@ -701,6 +702,7 @@ static __always_inline int __linearize(struct 
>> x86_emulate_ctxt *ctxt,
>>       *max_size = 0;
>>       switch (mode) {
>>       case X86EMUL_MODE_PROT64:
>> +        la = ctxt->ops->untag_addr(ctxt, la, untag_flags);
>>           *linear = la;
>>           va_bits = ctxt_virt_addr_bits(ctxt);
>>           if (!__is_canonical_address(la, va_bits))
>> @@ -758,7 +760,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
>>   {
>>       unsigned max_size;
>>       return __linearize(ctxt, addr, &max_size, size, write, false,
>> -               ctxt->mode, linear);
>> +               ctxt->mode, linear, 0);
>>   }
>>     static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong 
>> dst)
>> @@ -771,7 +773,12 @@ static inline int assign_eip(struct 
>> x86_emulate_ctxt *ctxt, ulong dst)
>>         if (ctxt->op_bytes != sizeof(unsigned long))
>>           addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
>> -    rc = __linearize(ctxt, addr, &max_size, 1, false, true, 
>> ctxt->mode, &linear);
>> +    /*
>> +     * LAM does not apply to addresses used for instruction fetches
>> +     * or to those that specify the targets of jump and call 
>> instructions
>> +     */
>
> This api handles the target address of branch and call instructions. I 
> think it enough to only explain the exact case.


OK, will make it specific.

>
>> +    rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode,
>> +                     &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
>>       if (rc == X86EMUL_CONTINUE)
>>           ctxt->_eip = addr.ea;
>>       return rc;
>> @@ -906,9 +913,12 @@ static int __do_insn_fetch_bytes(struct 
>> x86_emulate_ctxt *ctxt, int op_size)
>>        * __linearize is called with size 0 so that it does not do any
>>        * boundary check itself.  Instead, we use max_size to check
>>        * against op_size.
>> +     *
>> +     * LAM does not apply to addresses used for instruction fetches
>> +     * or to those that specify the targets of jump and call 
>> instructions
>
> Ditto.
>
>>        */
>>       rc = __linearize(ctxt, addr, &max_size, 0, false, true, 
>> ctxt->mode,
>> -             &linear);
>> +             &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
>>       if (unlikely(rc != X86EMUL_CONTINUE))
>>           return rc;
>>
