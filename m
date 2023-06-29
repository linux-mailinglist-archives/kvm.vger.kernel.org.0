Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA164742921
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 17:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjF2PJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 11:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbjF2PI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 11:08:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0940F10CE;
        Thu, 29 Jun 2023 08:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688051337; x=1719587337;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qFbYUeBDAwmHSAN5zdmlbA5OxaHvaeNOgj0I3clyMJk=;
  b=OQHLVOrPoZbyxn5QT4ACTRJmZboKgEFPgIdmgzn1b0EPFR6xM/oOrgrh
   N0VMTgyi0FsJSL+rLWmKYTQg1womxAmgU2M5z4MzjOLjws83nUPnAI6Hj
   8llsU65q/Ihp6ZxSZUC8chGq1GPJD/wrqCzR6VWuvRSKzL9Ptyp48lqjZ
   eWyaki9pVLqT+AS3LJjUrUBTy4bNXxh09oEdaUrlBXuOBa/hnnuKO+3ks
   SwwXpKuWVU7amopfCeiwZDlTgbqvqEBWgQqZy2oTPJxoTBK22VMsOQKIa
   KhJnp8NLQ7j6B07C+zC8rOR9f7Y47/kbeindet3R5MPn/o51b39wya6sS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="365618017"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="365618017"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 08:06:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="717410205"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="717410205"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.254.209.154]) ([10.254.209.154])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 08:06:31 -0700
Message-ID: <d03a6324-c0e2-dfdb-7913-22f3d0e9555f@intel.com>
Date:   Thu, 29 Jun 2023 23:06:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v1 4/6] KVM: x86: Add emulator helper for LASS violation
 check
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-5-guang.zeng@intel.com> <ZJsqanMgqOp6M8j/@google.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZJsqanMgqOp6M8j/@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/28/2023 2:28 AM, Sean Christopherson wrote:
> On Thu, Jun 01, 2023, Zeng Guang wrote:
>> When LASS is enabled, KVM need apply LASS violation check to instruction
>> emulations. Add helper for the usage of x86 emulator to perform LASS
>> protection.
>>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>>   arch/x86/kvm/kvm_emulate.h |  1 +
>>   arch/x86/kvm/x86.c         | 12 ++++++++++++
>>   2 files changed, 13 insertions(+)
>>
>> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
>> index f1439ab7c14b..fd1c2b22867e 100644
>> --- a/arch/x86/kvm/kvm_emulate.h
>> +++ b/arch/x86/kvm/kvm_emulate.h
>> @@ -230,6 +230,7 @@ struct x86_emulate_ops {
>>   	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
>>   	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
>>   	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
>> +	bool (*check_lass)(struct x86_emulate_ctxt *ctxt, u64 access, u64 la, u32 flags);
>>   };
>>   
>>   /* Type, address-of, and value of an instruction's operand. */
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c0778ca39650..faf01fecc4ca 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8287,6 +8287,17 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
>>   		kvm_vm_bugged(kvm);
>>   }
>>   
>> +static bool emulator_check_lass(struct x86_emulate_ctxt *ctxt,
>> +				u64 access, u64 la, u32 flags)
>> +{
>> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
>> +
>> +	if (!is_long_mode(vcpu))
>> +		return false;
> Likely a moot point if we wrap ->gva_to_gpa(), but most this into the vendor
> implementation.
It's right way to move cpu mode check into is_lass_violation(). 
Previously I was struggling
to expect getting benefit from separate invocation. But it doesn't help 
much indeed.

>
> And if we keep these emulator hooks, massage the patch ordering:
>
>    1. Add plumbing to emulator to pass new flags
>    2. Add kvm_x86_ops definition and invocation from emulator
>    3. Implement and wire up vmx_is_lass_violation()
>
> That way the changes to each area of KVM are better isolated.
OK. Will reorganize the patch accordingly.
Thanks.
>> +	return static_call(kvm_x86_check_lass)(vcpu, access, la, flags);
>> +}
>> +
>>   static const struct x86_emulate_ops emulate_ops = {
>>   	.vm_bugged           = emulator_vm_bugged,
>>   	.read_gpr            = emulator_read_gpr,
>> @@ -8332,6 +8343,7 @@ static const struct x86_emulate_ops emulate_ops = {
>>   	.leave_smm           = emulator_leave_smm,
>>   	.triple_fault        = emulator_triple_fault,
>>   	.set_xcr             = emulator_set_xcr,
>> +	.check_lass          = emulator_check_lass,
>>   };
>>   
>>   static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>> -- 
>> 2.27.0
>>
