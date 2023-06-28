Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717D1740B59
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbjF1I0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:26:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:64637 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233256AbjF1IXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687940585; x=1719476585;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Pn0urhmg5uhEUgRwx90xHAfJv9M1P7KA+1U3g8ePS30=;
  b=Dab4tOiPu2DToE564RUDSspaIVs0XwfwszWhEpNH9IQsW5xo340Fy3i6
   7FF+3eHUe46PWNsebMHe0LyUqKpkHjky1wlkqvjB2HD5Qspv4ZoVVf2bI
   SMnLC+qy9RJpdOc+RGyG3P77d3ByEoWY4Iya7wIBjUHVRXwtRFm5yWgbD
   gQpTYjSlfsEcLnEKnk/NUt0xX1m1sy/Iz79Samp7dBrKUo6ouqmyiWfpJ
   PMpKIw0d43Qta0yMksebJwTwldD698JXSBMKjSvELD6eZFz5R6CTwLqkH
   qSWKvJF5QkvLdNIC8uMFPB6DLOL7gYFyg8EmsdHMrU4KhUMGCGXNX8nt5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="342092496"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="342092496"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 22:13:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="666956324"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="666956324"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.27]) ([10.238.9.27])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 22:13:12 -0700
Message-ID: <b911d367-d000-1237-62fe-230c52e2842c@linux.intel.com>
Date:   Wed, 28 Jun 2023 13:13:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v1 1/6] KVM: x86: Consolidate flags for __linearize()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-2-guang.zeng@intel.com> <ZJsfIQqPQgRILn7o@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZJsfIQqPQgRILn7o@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/28/2023 1:40 AM, Sean Christopherson wrote:
> On Thu, Jun 01, 2023, Zeng Guang wrote:
>> From: Binbin Wu <binbin.wu@linux.intel.com>
>>
>> Define a 32-bit parameter and consolidate the two bools into it.
> Please write changelogs so that they make sense without the context of the shortlog.
> In isolation, the above provides zero context.  And there's no need to provide a
> play-by-play description of the change, e.g. this can be:
>
>    Consolidate __linearize()'s @write and @fetch into a set of flags so that
>    additional flags can be added without needing more/new boolean parameters,
>    e.g. to precisely identify the access type for LASS.
>
>> __linearize() has two bool parameters write and fetch. And new flag
>> will be needed to support new feature (e.g. LAM needs a flag to skip
> s/LAM/LASS
>
>> address untag under some conditions).
> Looks like this was copy+pasted LAM.  AIUI, there is no untagging in LASS.  Please,
> please take the time to proofread what you're posting.  To you it's a minor typo,
> to others, incorrect statements like this can create a lot of confusion.
>
>> No functional change intended.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>   arch/x86/kvm/emulate.c     | 19 +++++++++++++------
>>   arch/x86/kvm/kvm_emulate.h |  4 ++++
>>   2 files changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 936a397a08cd..9508836e8a35 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -687,8 +687,8 @@ static unsigned insn_alignment(struct x86_emulate_ctxt *ctxt, unsigned size)
>>   static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>>   				       struct segmented_address addr,
>>   				       unsigned *max_size, unsigned size,
>> -				       bool write, bool fetch,
>> -				       enum x86emul_mode mode, ulong *linear)
>> +				       u32 flags, enum x86emul_mode mode,
> "unsigned int", not "u32".  They're obviously the same effective thing, but using
> "unsigned int" captures that the number of bits doesn't truly matter, e.g. isn't
> reflected in hardware or anything.  This could just as easily be a u16, but there's
> obviously no reason to squeeze this into a u16.
OK. Thanks.

Except for the "u32" / "usigned int" thing, I have updated the patch in 
KVM LAM enabling patch series v9:
https://lore.kernel.org/kvm/20230606091842.13123-2-binbin.wu@linux.intel.com/
It has dropped the unnecessary local variables you mentioned below and 
improved the changelog a bit to be more informative.

Do you have any comment on this version?


>
>> +				       ulong *linear)
>>   {
>>   	struct desc_struct desc;
>>   	bool usable;
>> @@ -696,6 +696,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>>   	u32 lim;
>>   	u16 sel;
>>   	u8  va_bits;
>> +	bool fetch = !!(flags & X86EMUL_F_FETCH);
>> +	bool write = !!(flags & X86EMUL_F_WRITE);
>>   
>>   	la = seg_base(ctxt, addr.seg) + addr.ea;
>>   	*max_size = 0;
>> @@ -757,7 +759,11 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
>>   		     ulong *linear)
>>   {
>>   	unsigned max_size;
>> -	return __linearize(ctxt, addr, &max_size, size, write, false,
>> +	u32 flags = 0;
>> +
>> +	if (write)
>> +		flags |= X86EMUL_F_WRITE;
>> +	return __linearize(ctxt, addr, &max_size, size, flags,
>>   			   ctxt->mode, linear);
> I'm tempted to have this be:
>
> 	return __linearize(ctxt, addr, &max_size, size,
> 			   write ? X86EMUL_F_WRITE : 0, ctxt->mode, linear);
>
> Mostly so that it's obvious "flags" is constant.  The alterntive would e
>
> 	const unsigned int flags = write ? X86EMUL_F_WRITE : 0;
>
> But my preference is probably to omit "flags" entirely.
>
>>   }
>>   
>> @@ -768,10 +774,11 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
>>   	unsigned max_size;
>>   	struct segmented_address addr = { .seg = VCPU_SREG_CS,
>>   					   .ea = dst };
>> +	u32 flags = X86EMUL_F_FETCH;
>>   
>>   	if (ctxt->op_bytes != sizeof(unsigned long))
>>   		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
>> -	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
>> +	rc = __linearize(ctxt, addr, &max_size, 1, flags, ctxt->mode, &linear);
> Meh, just pass X86EMUL_F_FETCH directly, i.e. drop the local "flags".
>
>>   	if (rc == X86EMUL_CONTINUE)
>>   		ctxt->_eip = addr.ea;
>>   	return rc;
>> @@ -896,6 +903,7 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>>   	int cur_size = ctxt->fetch.end - ctxt->fetch.data;
>>   	struct segmented_address addr = { .seg = VCPU_SREG_CS,
>>   					   .ea = ctxt->eip + cur_size };
>> +	u32 flags = X86EMUL_F_FETCH;
>>   
>>   	/*
>>   	 * We do not know exactly how many bytes will be needed, and
>> @@ -907,8 +915,7 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
>>   	 * boundary check itself.  Instead, we use max_size to check
>>   	 * against op_size.
>>   	 */
>> -	rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
>> -			 &linear);
>> +	rc = __linearize(ctxt, addr, &max_size, 0, flags, ctxt->mode, &linear);
> And here.
>
>>   	if (unlikely(rc != X86EMUL_CONTINUE))
>>   		return rc;
>>   
>> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
>> index ab65f3a47dfd..5b9ec610b2cb 100644
>> --- a/arch/x86/kvm/kvm_emulate.h
>> +++ b/arch/x86/kvm/kvm_emulate.h
>> @@ -88,6 +88,10 @@ struct x86_instruction_info {
>>   #define X86EMUL_IO_NEEDED       5 /* IO is needed to complete emulation */
>>   #define X86EMUL_INTERCEPTED     6 /* Intercepted by nested VMCB/VMCS */
>>   
>> +/* x86-specific emulation flags */
>> +#define X86EMUL_F_FETCH			BIT(0)
>> +#define X86EMUL_F_WRITE			BIT(1)
>> +
>>   struct x86_emulate_ops {
>>   	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
>>   	/*
>> -- 
>> 2.27.0
>>

