Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18896C1150
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 12:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjCTL5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 07:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjCTL5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 07:57:12 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B58244B3
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 04:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679313423; x=1710849423;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HvwXHTWXiCDBhGkdEQ03MCf9fKNhbvRdtRJpZQzJM9M=;
  b=mo+SrasCR0XQ2URUNaNTDSR9iyUsYJE2DjtPAd6OwH5Y23/4UHGCYH38
   if+cJWAzmfPbsZUQHSx8oJzJDLlOBkGFAyJpnaHLqVwrkVBZi1Avf11aF
   3827JEkgiTTmwsyMSWWnS73S/m3BlFtXebqL8d+WAg45VT5cx1c8k7VBf
   WFhk7d9XBQ6fmg8VxdG5P+jNTl1p0cK491I/AvFYwQnNvx6nUXbihHQna
   LUdBwKo4OMWmLLZ65ogq2Uv2lyiWYRx8Rr/FeZX3Oxgat3d4zCVW9T5aq
   SrTaNpev8/icBk8NK/V8r5gHDcsMilJyJ5Oa0g8ZV0XFcxwQd1c+cBdfm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="327012373"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="327012373"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 04:57:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="713538368"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="713538368"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.172.177]) ([10.249.172.177])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 04:56:59 -0700
Message-ID: <93ec85fc-1114-e066-ca1b-621d91eaaa5c@linux.intel.com>
Date:   Mon, 20 Mar 2023 19:56:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v6 6/7] KVM: x86: Untag address when LAM applicable
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-7-binbin.wu@linux.intel.com> <ZBhIwLfkBqwvas9d@gao-cwp>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZBhIwLfkBqwvas9d@gao-cwp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/20/2023 7:51 PM, Chao Gao wrote:
> On Sun, Mar 19, 2023 at 04:49:26PM +0800, Binbin Wu wrote:
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
>> ---
>> arch/x86/kvm/emulate.c    | 25 +++++++++++++++++--------
>> arch/x86/kvm/vmx/nested.c |  2 ++
>> arch/x86/kvm/vmx/sgx.c    |  1 +
>> arch/x86/kvm/x86.c        |  4 ++++
>> 4 files changed, 24 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index a630c5db971c..c46f0162498e 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -688,7 +688,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>> 				       struct segmented_address addr,
>> 				       unsigned *max_size, unsigned size,
>> 				       bool write, bool fetch,
>> -				       enum x86emul_mode mode, ulong *linear)
>> +				       enum x86emul_mode mode, ulong *linear,
>> +				       u64 untag_flags)
>> {
>> 	struct desc_struct desc;
>> 	bool usable;
>> @@ -701,9 +702,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>> 	*max_size = 0;
>> 	switch (mode) {
>> 	case X86EMUL_MODE_PROT64:
>> -		*linear = la;
>> +		*linear = static_call(kvm_x86_untag_addr)(ctxt->vcpu, la, untag_flags);
>> +
>> 		va_bits = ctxt_virt_addr_bits(ctxt);
>> -		if (!__is_canonical_address(la, va_bits))
>> +		if (!__is_canonical_address(*linear, va_bits))
>> 			goto bad;
>>
>> 		*max_size = min_t(u64, ~0u, (1ull << va_bits) - la);
>> @@ -757,8 +759,8 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
>> 		     ulong *linear)
>> {
>> 	unsigned max_size;
>> -	return __linearize(ctxt, addr, &max_size, size, write, false,
>> -			   ctxt->mode, linear);
>> +	return __linearize(ctxt, addr, &max_size, size, false, false,
> 							^^^^^
> 							Should be "write".

Oops, thanks for catching it.


>
>> +			   ctxt->mode, linear, 0);
>> }
>>
>> static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
>> @@ -771,7 +773,9 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
>>
>> 	if (ctxt->op_bytes != sizeof(unsigned long))
>> 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
>> -	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
>> +	/* skip LAM untag for instruction */
> I think it would be more accurate to quote the spec:
>
> LAM does not apply to addresses used for instruction fetches or to those
> that specify the targets of jump and call instructions


OK.

>
>> +	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode,
>> +		         &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
>> 	if (rc == X86EMUL_CONTINUE)
>> 		ctxt->_eip = addr.ea;
>> 	return rc;
>> @@ -906,9 +910,11 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>> 	 * __linearize is called with size 0 so that it does not do any
>> 	 * boundary check itself.  Instead, we use max_size to check
>> 	 * against op_size.
>> +	 *
>> +	 * skip LAM untag for instruction
> ditto
