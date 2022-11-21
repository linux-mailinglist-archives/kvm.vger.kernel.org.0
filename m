Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C98E63279C
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 16:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbiKUPPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 10:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiKUPOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 10:14:14 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6890CFA68;
        Mon, 21 Nov 2022 07:09:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669043374; x=1700579374;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qtmw/gvKgo+DRFl13Q27alVKlG2VCnwPFg1T5edcqyo=;
  b=mYlcI6Q1O5RZvVg5ph7a89tsAUCmox32+InNqNETFE3oKAVcmna28sGG
   1GHswE08IxX/lPMEnIBl4vYr898YoP6uN9HEiVV+nzX4WABVV9S9am1/3
   +rVy07xXB31CxQKhnDczZqQt5IbT+8g1wAO9o/giWQaS0v1fotRRxJ8a/
   JFhPfQeV0/PJQNv5i+vig/4cwIncestNi070ErA4v0K0zhZTYJdu0FK/C
   BqMlQqGFl4brm+35r4ykZflxcWE8mZpDKVjo4IjQpPW1PwLtkZKi8Smco
   KQ9GFuJkJDKtyaegBgewrW+iUldlp2uhEwOBKpOGEHxkPFtnHS7MUsUt+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="314725774"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="314725774"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 07:06:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="618852238"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="618852238"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.254.209.33]) ([10.254.209.33])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 07:06:50 -0800
Message-ID: <76504a97-543a-c655-694c-4f3efb108673@linux.intel.com>
Date:   Mon, 21 Nov 2022 23:06:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4 4/6] x86: KVM: Advertise AVX-VNNI-INT8 CPUID to user
 space
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-5-jiaxi.chen@linux.intel.com>
 <Y3e+PNvvuuT3aCmb@google.com>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <Y3e+PNvvuuT3aCmb@google.com>
Content-Type: text/plain; charset=UTF-8
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



On 11/19/2022 1:17 AM, Sean Christopherson wrote:
> On Fri, Nov 18, 2022, Jiaxi Chen wrote:
>> AVX-VNNI-INT8 is a new set of instructions in the latest Intel platform
>> Sierra Forest, aims for the platform to have superior AI capabilities.
>> This instruction multiplies the individual bytes of two unsigned or
>> unsigned source operands, then adds and accumulates the results into the
>> destination dword element size operand.
>>
>> The bit definition:
>> CPUID.(EAX=7,ECX=1):EDX[bit 4]
>>
>> This CPUID is exposed to user space. Besides, there is no other VMX
>> control for this instruction.
>>
>> Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
>> ---
>>  arch/x86/kvm/cpuid.c         | 5 ++++-
>>  arch/x86/kvm/reverse_cpuid.h | 5 +++++
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 5726afb2d14c..e2b8e5485474 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -660,6 +660,9 @@ void kvm_set_cpu_caps(void)
>>  		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
>>  		F(AVX_IFMA));
>>  
>> +	kvm_cpu_cap_init_scattered(CPUID_7_1_EDX,
> 
> Ah, this is going to be confusing and potentially error prone.  AVX_VNNI_INT8
> isn't actually scattered, i.e. kvm_cpu_cap_init_scattered() is poorly named.  And
> using SF() would be _really_ broken as boot_cpu_has() would consume garbage and
> potentially leak kernel state to userspace.
> 
> To address these issue and also document how to add KVM-only features, can you
> slot in the two attached patches at the begining of this series?
> 
Sure. Thanks for your kind contribution.
> Thanks!
> 
>> +		F(AVX_VNNI_INT8));
> 
> Terminators on a separate line please.
> 
>>  	kvm_cpu_cap_mask(CPUID_D_1_EAX,
>>  		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
>>  	);

Got it. Thanks~
-- 
Regards,
Jiaxi
