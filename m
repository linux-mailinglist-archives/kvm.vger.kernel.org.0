Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97686307D92
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhA1SOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbhA1SH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 13:07:26 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60D2C06178C;
        Thu, 28 Jan 2021 10:04:08 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id gx5so9120559ejb.7;
        Thu, 28 Jan 2021 10:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JYIcKDp3tq6KjFCoe7KRgOLFg5+oBqHlOawfom5+j9o=;
        b=VOn2MpLrXKaxK1WPLYqt26nt+g2L5eKbET1kCRHZkmbeuKo7RJRol4B9rWNCkYkZPy
         VZbzBtP+f9rdp7jS3WiGU/YqQBC9jLmsZRlHmpxdBpIr6+rlDo6LHkUAD/6F5B6fHLg3
         U1TMiU7XsVaDwwWF1ihGF/LjZoiZpgP5mkddf7D988kUeUwE06vUuzlH2JHTy3UXLexd
         FIS0O8pRssAGdqa1iCsKMt+jtIyNVifkmPx521d6h/2mjctswTszxVFH/FM2i4DEACvV
         9yBtf2ZfCtdxUOimfwwYiiZ22rkNpW+NisZEVAtZmPtRoDUPhoGcCQI3SLcheyep+sVF
         JKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JYIcKDp3tq6KjFCoe7KRgOLFg5+oBqHlOawfom5+j9o=;
        b=POCdvNOiQ3xk7pF2JPbpIe9UGgKT4DE23DzcunlAuTVYNdQd84vivo51ZDZEtIWkuC
         zUCK/lhCwBblCuV65FUXc8fyLg84i6I4aAZYuJz3mkWfeVqMNpv5iWK/Wr0s3G3MT/+W
         b+3d/Lh4V7O8M3XiDn97H8QhE97b5lDLonh+EvrG/EWUk44GZrTUTI4KAPH34E1owxHF
         Hkx1/qbJtx9WGN28lyuudBsyTsbl/wvhxflsbQRL0lDYdnL63UXef3FgjLvwkPeUEdqR
         8yodVhsOLOSGhTSdf4jBEQ+xw6eZLVJXm/FvBiNOppEw5PMX+kTId1AkSBqBKzQoPusX
         /6QA==
X-Gm-Message-State: AOAM5335ycGpgKFZTVcnOiA20k4CC8SaKbu6aKKDb16LEgbJNI7X+yVA
        fnHHhWGF8ErphQY3m6MjBtY=
X-Google-Smtp-Source: ABdhPJyMiDTAlloSahlJa1ZSKuwy4dEWHmgmekCvFGhbYz4eNpmvkTs0i0b71XQdwWpOudjXSWWGVw==
X-Received: by 2002:a17:906:9499:: with SMTP id t25mr576105ejx.339.1611857047723;
        Thu, 28 Jan 2021 10:04:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id pw28sm2623456ejb.115.2021.01.28.10.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 10:04:07 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH v14 11/13] KVM: VMX: Pass through CET MSRs to the guest
 when supported
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <20201106011637.14289-12-weijiang.yang@intel.com>
 <78948a28-2b6c-fccb-971a-550ea7e4da2c@redhat.com>
Message-ID: <e383a377-ee64-342d-b1dd-0f99186714e3@redhat.com>
Date:   Thu, 28 Jan 2021 19:04:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <78948a28-2b6c-fccb-971a-550ea7e4da2c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 18:54, Paolo Bonzini wrote:
> On 06/11/20 02:16, Yang Weijiang wrote:
>> Pass through all CET MSRs when the associated CET component (kernel vs.
>> user) is enabled to improve guest performance.  All CET MSRs are context
>> switched, either via dedicated VMCS fields or XSAVES.
>>
>> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 29 +++++++++++++++++++++++++++++
>>   1 file changed, 29 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c88a6e1721b1..6ba2027a3d44 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7366,6 +7366,32 @@ static void update_intel_pt_cfg(struct kvm_vcpu 
>> *vcpu)
>>           vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>>   }
>> +static bool is_cet_state_supported(struct kvm_vcpu *vcpu, u32 xss_state)
>> +{
>> +    return (vcpu->arch.guest_supported_xss & xss_state) &&
>> +           (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
>> +        guest_cpuid_has(vcpu, X86_FEATURE_IBT));
>> +}
>> +
>> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>> +{
>> +    bool incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_USER);
>> +
>> +    vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, incpt);
>> +
>> +    incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>> +    vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, 
>> incpt);
>> +
>> +    incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_KERNEL);
>> +    vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
>> +
>> +    incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>> +    vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB, 
>> MSR_TYPE_RW, incpt);
>> +    vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, 
>> incpt);
>> +    vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, 
>> incpt);
>> +    vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, 
>> incpt);
>> +}
>> +
>>   static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>>   {
>>       struct vcpu_vmx *vmx = to_vmx(vcpu);
>> @@ -7409,6 +7435,9 @@ static void vmx_vcpu_after_set_cpuid(struct 
>> kvm_vcpu *vcpu)
>>       /* Refresh #PF interception to account for MAXPHYADDR changes. */
>>       update_exception_bitmap(vcpu);
>> +
>> +    if (kvm_cet_supported())
>> +        vmx_update_intercept_for_cet_msr(vcpu);
>>   }
>>   static __init void vmx_set_cpu_caps(void)
>>
> 
> Can you do this only if CR4.CET=1?

Actually, considering this is XSAVES and not RDMSR/WRMSR state, this is 
okay as is.

Paolo
