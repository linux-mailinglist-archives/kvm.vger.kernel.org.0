Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2A777DB82
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 09:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242593AbjHPH4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 03:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242586AbjHPHzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 03:55:39 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B631A8;
        Wed, 16 Aug 2023 00:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692172538; x=1723708538;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7WyUr2rVN56CnQzaBIVbKpU04od8JILDZPoiAIHge/M=;
  b=L9fLTlNhZB6i1Fo19QqvIMF6fhmx21F1JBmV7ksJLoARlsf11R1eyYOn
   4H/5VGH7r/geGs1UOoZ75zD4VLKBXQCqbV/y4+GJdVZHXB4XM51W9bH70
   dH9Jl+Nr6rLGMghJLeLvpeZ073YOqrcJnb/lDLPdl2/hRARs74ZdUl3Wz
   fAnAaaQUCDnr39T3dMPDOwDqnc1shJbDx0+XvSz9HBirWeVO9AzA/NwwW
   8VZq5O/3gloO0VyvQlu7eDagHFkPdzNLrMy1MKkA14Y/xt5PyOwtj74n+
   zNKnVYH+j7mzHR57N6FonX7EHmMODsodI1HThz6sXKRSePZXz6bVg0C5N
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="357444096"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="357444096"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 00:55:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="769093345"
X-IronPort-AV: E=Sophos;i="6.01,176,1684825200"; 
   d="scan'208";a="769093345"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 00:55:34 -0700
Message-ID: <a7ecab8d-a77c-77eb-68cb-383de569fe6d@linux.intel.com>
Date:   Wed, 16 Aug 2023 15:55:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2 4/8] KVM: x86: Add X86EMUL_F_INVTLB and pass it in
 em_invlpg()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20230719024558.8539-1-guang.zeng@intel.com>
 <20230719024558.8539-5-guang.zeng@intel.com> <ZNwGKPnTY7hRRy+S@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZNwGKPnTY7hRRy+S@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/16/2023 7:11 AM, Sean Christopherson wrote:
> On Wed, Jul 19, 2023, Zeng Guang wrote:
>> From: Binbin Wu <binbin.wu@linux.intel.com>
>>
>> Add an emulation flag X86EMUL_F_INVTLB, which is used to identify an
>> instruction that does TLB invalidation without true memory access.
>>
>> Only invlpg & invlpga implemented in emulator belong to this kind.
>> invlpga doesn't need additional information for emulation. Just pass
>> the flag to em_invlpg().
> Please add a paragraph explaining *why* this flag is being added.  Ideally, the
> previous patch would also explain the need for an IMPLICIT flag, but that one
> doesn't bug me all that much because implicit accesses are known to be special
> snowflakes, i.e. it's easy to imagine that KVM would need to identify such
> accesses.  But for INVLPG, without already knowing the details of LASS (or LAM),
> it's harder to think of why it needs to exist.
OK, will add the reason for this case and for IMPLICIT as well.
Thanks.


>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> ---
>>   arch/x86/kvm/emulate.c     | 4 +++-
>>   arch/x86/kvm/kvm_emulate.h | 1 +
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 8e706d19ae45..9b4b3ce6d52a 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -3443,8 +3443,10 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
>>   {
>>   	int rc;
>>   	ulong linear;
>> +	unsigned max_size;
> 	unsigned int
Let me think why I use 'unsigned'...
It's because the exist code uses 'unsigned'.
I suppose it is considered bad practice?
I will cleanup the exist code as well. Is it OK to cleanup it 
opportunistically inside this patch?


>> -	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
>> +	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, ctxt->mode,
>> +		&linear, X86EMUL_F_INVTLB);
> Align indentation:
Will update it.

>
> 	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, ctxt->mode,
> 			 &linear, X86EMUL_F_INVTLB);
>
>>   	if (rc == X86EMUL_CONTINUE)
>>   		ctxt->ops->invlpg(ctxt, linear);
>>   	/* Disable writeback. */
>> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
>> index c0e48f4fa7c4..c944055091e1 100644
>> --- a/arch/x86/kvm/kvm_emulate.h
>> +++ b/arch/x86/kvm/kvm_emulate.h
>> @@ -93,6 +93,7 @@ struct x86_instruction_info {
>>   #define X86EMUL_F_FETCH			BIT(1)
>>   #define X86EMUL_F_BRANCH		BIT(2)
>>   #define X86EMUL_F_IMPLICIT		BIT(3)
>> +#define X86EMUL_F_INVTLB		BIT(4)
> Why F_INVTLB instead of X86EMUL_F_INVLPG?  Ah, because LAM is ignored for the
> linear address in the INVPCID and INVVPID descriptors.  Hrm.
>
> I think my vote is to call this X86EMUL_F_INVLPG even though *in theory* it's not
> strictly limited to INVLPG.  Odds are good KVM's emulator will never support
> INVPCID or INVVPID,
One case is kvm_handle_invpcid() is in the common kvm x86 code.
LAM doesn't apply to the address in descriptor of invpcid though, but I 
am not sure if there will be the need for SVM in the future.
But for now, F_INVLPG is OK if you think F_INVTLB brings confusion.


> and IMO even though F_INVLPG would be somewhat of a misnomer,
> it's much more intuitive even for INVPCID and INVVPID descriptors.  F_INVTLB makes
> me think more of the actual act of invalidating the TLB.
>
> I'm not dead set against INVTLB if someone really likes it, but I did scratch my
> head for a second when I saw it.

