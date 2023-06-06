Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6115A72358A
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbjFFC60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbjFFC6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:58:24 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BA8102;
        Mon,  5 Jun 2023 19:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686020304; x=1717556304;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3F9BQZRrp7U5NBThQPls3NTVkF16pILUDrAZibdqNpA=;
  b=IfWZRelVZXZvdbd1gzAlktGm++IYH+4SHletb+1BX4V+3mR+Kvn+/9Iq
   W04n57NI9b2+gPx4EdcrJzVsOPFusIBPItUtnsxFtW8V/aRYC3geiJPn2
   EDVZGUv5TKRjWQVE9uR7lfOxBNZMeqO9qul7MuKHY+pyQdFnCU1f42gD8
   5Sr0uC7n9bjmu1gB5KITJSsZb5wnnD8KgHuLhdtS32pSCu2eIGWnoF/KG
   wCkfw7iKzGu9IKWvgyCcZjZ7RHcUt5TMS4u0EojCWEGonGTz6cmGjEvx1
   iun+DhoqJy/CahHxoyzn4r4hVV58NPKfkESfbGnv8pB/3FvcpeVJj2aDf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="354042207"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="354042207"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 19:58:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="773961498"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="773961498"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.249.170.218]) ([10.249.170.218])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 19:58:21 -0700
Message-ID: <dae60bcf-263a-14b5-12e8-c0038fadee25@intel.com>
Date:   Tue, 6 Jun 2023 10:57:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1 2/6] KVM: x86: Virtualize CR4.LASS
Content-Language: en-US
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-3-guang.zeng@intel.com>
 <7335a53b-5b6a-f186-d3b9-99569aa2559c@linux.intel.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <7335a53b-5b6a-f186-d3b9-99569aa2559c@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/5/2023 9:57 AM, Binbin Wu wrote:
>
> On 6/1/2023 10:23 PM, Zeng Guang wrote:
>> Virtualize CR4.LASS[bit 27] under KVM control instead of being guest-owned
>> as CR4.LASS generally set once for each vCPU at boot time and won't be
>> toggled at runtime. Besides, only if VM has LASS capability enumerated with
>> CPUID.(EAX=07H.ECX=1):EAX.LASS[bit 6], KVM allows guest software to be able
>> to set CR4.LASS.
>>
>> Updating cr4_fixed1 to set CR4.LASS bit in the emulated IA32_VMX_CR4_FIXED1
>> MSR for guests and allow guests to enable LASS in nested VMX operaion as well.
> s/operaion/operation
Thanks.
>
>> Notes: Setting CR4.LASS to 1 enable LASS in IA-32e mode. It doesn't take
>> effect in legacy mode even if CR4.LASS is set.
>>
>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> ---
>>    arch/x86/include/asm/kvm_host.h | 2 +-
>>    arch/x86/kvm/vmx/vmx.c          | 3 +++
>>    arch/x86/kvm/x86.h              | 2 ++
>>    3 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index fb9d1f2d6136..92d8e65fe88c 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -125,7 +125,7 @@
>>    			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
>>    			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>>    			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
>> -			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
>> +			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP | X86_CR4_LASS))
> Suppose there is some bare-matel linux patch to define the LASS related
> macros.
> May be better to describe the dependent patch(es) in cover letter.
>
Good suggestion.

