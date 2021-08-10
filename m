Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3D13E586F
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 12:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239846AbhHJKgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 06:36:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238459AbhHJKgJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 06:36:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628591747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dSRHzUxeiOWloToTL5jVawnUzFMQbB9b5yC/gXW30eI=;
        b=fvmvgacPmpyg2mUEIe+1kVY+D2BlfhiSN7ESiMsLuRdBZrsfJ96loeHta3jurwoCED92XQ
        3sorxlNaQBNSg5TXjibBVE6lyTnUcGswCWw6pKQxyClZnBAcKt7vgbABZkojmzImaDSICI
        0HFFfRgNmj23BrSRslhwWORTdpXfLd8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-S07tztqxP1aod-b60Q3PrA-1; Tue, 10 Aug 2021 06:35:45 -0400
X-MC-Unique: S07tztqxP1aod-b60Q3PrA-1
Received: by mail-ej1-f71.google.com with SMTP id ju25-20020a17090798b9b029058c24b55273so5473224ejc.8
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 03:35:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dSRHzUxeiOWloToTL5jVawnUzFMQbB9b5yC/gXW30eI=;
        b=UfkAnOamdg3sRm5hbg/jJGhMh/DE/Zwi3kAXfGbzX0MepLT3eBL9N0Ov804V/DAAfK
         YH8nsCJE0eokx+2cLYXV3SKl49QfBNTHhjFHqIg0GeKdJcGh2UE2k/6VTKIjFW3u8DRl
         94S362R13Uy46+wgWxRs7QoyG3Pjt9+O5snMNxvm9u6t4REOyAEUNIKDHBEMtJ/0wfUT
         9BrxBo5pIkKzQI98jMnqgg9Mx4p0zHTZh+cNWZlOizBQ9W2H1T+aY9SgWec085OEMuBl
         VrMwQum3A1w72dyU95iiENkl6odJY1jp4hAqN8E24B9/7YRBhNIBumrfUOmsuV/GWWAt
         q4zA==
X-Gm-Message-State: AOAM531FnwYH2eo/DqCDvnMnYW7lWg2rYlUBqPZn6KsKfQq9ItxpvfHZ
        LaCUHWWnLKpVVDeQPCrUfQYZWMMyjwcIvRyLw0QBUD6+H+HHIS+GDCW7GJ22vQM2s3/9xWiGDqn
        q45VJr1eAlJZe8snS3xx1qi6qo+bPmCW8uyyiOh9eoYcvrm0dIldQytSI/2Z7KbJg
X-Received: by 2002:a05:6402:d5c:: with SMTP id ec28mr4202767edb.3.1628591744380;
        Tue, 10 Aug 2021 03:35:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKDKCZofFWud8zXiwgF6GPyAkOYeVeyPqDN8hJUOh/WyaQSKUTMTGHRr7mr7n+keuKU2nRHw==
X-Received: by 2002:a05:6402:d5c:: with SMTP id ec28mr4202742edb.3.1628591744153;
        Tue, 10 Aug 2021 03:35:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id q11sm6710763ejb.10.2021.08.10.03.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 03:35:43 -0700 (PDT)
Subject: Re: [PATCH V2 2/3] KVM: X86: Set the hardware DR6 only when
 KVM_DEBUGREG_WONT_EXIT
To:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <YRFdq8sNuXYpgemU@google.com>
 <20210809174307.145263-1-jiangshanlai@gmail.com>
 <20210809174307.145263-2-jiangshanlai@gmail.com>
 <68ed0f5c-40f1-c240-4ad1-b435568cf753@redhat.com>
 <45fef019-8bd9-2acb-bd53-1243a8a07c4e@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f5967e16-3910-5604-7890-9a1741045ce8@redhat.com>
Date:   Tue, 10 Aug 2021 12:35:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <45fef019-8bd9-2acb-bd53-1243a8a07c4e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/21 12:30, Lai Jiangshan wrote:
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index ae8e62df16dd..21a3ef3012cf 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6625,6 +6625,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu 
>> *vcpu)
>>           vmx->loaded_vmcs->host_state.cr4 = cr4;
>>       }
>>
>> +    /* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
>> +    if (vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)
>> +        set_debugreg(vcpu->arch.dr6, 6);
> 
> 
> I also noticed the related code in svm.c, but I refrained myself
> to add a new branch in vmx_vcpu_run().  But after I see you put
> the code of resetting dr6 in vmx_sync_dirty_debug_regs(), the whole
> solution is much clean and better.
> 
> And if any chance you are also concern about the additional branch,
> could you add a new callback to set dr6 and call the callback from
> x86.c when KVM_DEBUGREG_WONT_EXIT.

The extra branch should be well predicted, and the idea you sketched 
below would cause DR6 to be marked uselessly as dirty in SVM, so I think 
this is cleaner.  Let's add an "unlikely" around it too.

Paolo

> The possible implementation of the callback:
> for vmx: set_debugreg(vcpu->arch.dr6, 6);
> for svm: svm_set_dr6(svm, vcpu->arch.dr6);
>           and always do svm_set_dr6(svm, DR6_ACTIVE_LOW); at the end of the
>           svm_handle_exit().
> 
> Thanks
> Lai
> 
>> +
>>       /* When single-stepping over STI and MOV SS, we must clear the
>>        * corresponding interruptibility bits in the guest state. 
>> Otherwise
>>        * vmentry fails as it then expects bit 14 (BS) in pending debug
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index a111899ab2b4..fbc536b21585 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9597,7 +9597,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>           set_debugreg(vcpu->arch.eff_db[1], 1);
>>           set_debugreg(vcpu->arch.eff_db[2], 2);
>>           set_debugreg(vcpu->arch.eff_db[3], 3);
>> -        set_debugreg(vcpu->arch.dr6, 6);
>>       } else if (unlikely(hw_breakpoint_active())) {
>>           set_debugreg(0, 7);
>>       }
>>
>> Paolo
> 

