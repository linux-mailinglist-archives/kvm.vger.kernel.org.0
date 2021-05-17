Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59E53825A3
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 09:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbhEQHsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 03:48:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232909AbhEQHsU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 03:48:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621237624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pr+SsTDKN3t1n8i1sa/wBoRt+XTnEThJ5HCbyq0kBx8=;
        b=imEL/CWCpH8JehSfzermR39Fl6bjn+7L3pceZLMpIn94R7wVGB39kEO0V5Tj7AtsCfKz2d
        +JAbzai6FjVQjjIToRjweqqSbRXzCWXwi2cdQcnlZq/isA1tX1pgZ4+kX4how8eqEKw64+
        q0HGuob+R6k80OBkv402gZzMTPZKq/s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-usaxHoNDPKKyeALHtiwWgg-1; Mon, 17 May 2021 03:46:59 -0400
X-MC-Unique: usaxHoNDPKKyeALHtiwWgg-1
Received: by mail-wr1-f71.google.com with SMTP id u5-20020adf9e050000b029010df603f280so3414242wre.18
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 00:46:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pr+SsTDKN3t1n8i1sa/wBoRt+XTnEThJ5HCbyq0kBx8=;
        b=kPm7PeZ2UfbkDXGms39B2T6ZrWFnKCNC52Qk6GyokHseEITsR2CryHb0vdojTLXcAN
         lC6RpPmxCPVzxBYRHA3MK9gj4L5QTMYsLjxmCDuJGHBUtvhKw5831PlrzziItukyS+wr
         cQBY4IoAka8u05x0J+sWX/MJmSA09W2deXqdaTwmGZ8Ett7izXwWTb3OyvW0TjbdRuZ0
         eUWGeeMrwCrqYEMKHr78vH5BS4LI2Hv/oU5ZCV0XI9Xh2Ba+4PGd8DnmpekqU1cmWSLm
         SGrSH0CL4xjm8RvNhN7Ew9B/jiP1ioEQcK0Qe1ohZiM9SxpR4y5LEqZuFfMNE9IEmGg4
         ougw==
X-Gm-Message-State: AOAM530zzzvWD+F6oePwYtDgJ1wNXIT4BW5NZ1vgZrQmNCVDAniWaeFP
        hxP4kivfz6PHAPUQ8Zse4fPXypxbSlRU0mpYZBtxLxYh6MbPelSCw6L07u4vS36nYNv7bkD8pj7
        Fqal7PAfrvuqxWY1zR3yZWDIYMf8OZzZ5EacDRZa/DHhcqqYpd6dm0VqZP6ZIR1l8
X-Received: by 2002:a05:600c:410a:: with SMTP id j10mr16693591wmi.26.1621237617562;
        Mon, 17 May 2021 00:46:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzm4jiR+tISqpR6IaJiPZ+D+MPdL5pwgbbRsQbejqSDR/kgRrGrSsT+qLBVIWkGpvL5Gds3XA==
X-Received: by 2002:a05:600c:410a:: with SMTP id j10mr16693534wmi.26.1621237617222;
        Mon, 17 May 2021 00:46:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id s6sm23233419wms.0.2021.05.17.00.46.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 00:46:56 -0700 (PDT)
To:     Andy Lutomirski <luto@kernel.org>, Jon Kohler <jon@nutanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <20210507164456.1033-1-jon@nutanix.com>
 <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
Message-ID: <5e01d18b-123c-b91f-c7b4-7ec583dd1ec6@redhat.com>
Date:   Mon, 17 May 2021 09:46:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/21 07:11, Andy Lutomirski wrote:
> That's nice, but it fails to restore XINUSE[PKRU].  As far as I know,
> that bit is live, and the only way to restore it to 0 is with
> XRSTOR(S).

The manual says "It is possible for XINUSE[i] to be 1 even when state 
component i is in its initial configuration" so this is architecturally 
valid.  Does the XINUSE optimization matter for PKRU which is a single word?

>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index cebdaa1e3cf5..cd95adbd140c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -912,10 +912,10 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>>          }
>>
>>          if (static_cpu_has(X86_FEATURE_PKU) &&
>> -           (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
>> -            (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
>> -           vcpu->arch.pkru != vcpu->arch.host_pkru)
>> -               __write_pkru(vcpu->arch.pkru);
>> +           vcpu->arch.pkru != vcpu->arch.host_pkru &&
>> +           ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>> +            kvm_read_cr4_bits(vcpu, X86_CR4_PKE)))
>> +               __write_pkru(vcpu->arch.pkru, false);
> 
> Please tell me I'm missing something (e.g. KVM very cleverly managing
> the PKRU register using intercepts) that makes this reliably load the
> guest value.  An innocent or malicious guest could easily make that
> condition evaluate to false, thus allowing the host PKRU value to be
> live in guest mode.  (Or is something fancy going on here?)

RDPKRU/WRPKRU cannot be used unless CR4.PKE=1, but PKRU can still be 
accessed using XSAVE/XRSTOR.  However both CR4 and XCR0 have their 
writes trapped, so the guest will not use the host PKRU value before the 
next vmexit if CR4.PKE=0 and XCR0.PKRU=0.

> I don't even want to think about what happens if a perf NMI hits and
> accesses host user memory while the guest PKRU is live (on VMX -- I
> think this can't happen on SVM).

This is indeed a problem, which indeed cannot happen on SVM but is there 
on VMX.  Note that the function above is not handling all of the xstate, 
it's handling the *XSAVE state*, that is XCR0, XSS and PKRU.  Thus the 
window is small, but it's there.

Is it solvable at all, without having PKRU fields in the VMCS (and 
without masking NMIs in the LAPIC which would be too expensive)?  Dave, 
Sean, what do you think?

>>   }
>>   EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>>
>> @@ -925,11 +925,11 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>>                  return;
>>
>>          if (static_cpu_has(X86_FEATURE_PKU) &&
>> -           (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
>> -            (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
>> +           ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>> +            kvm_read_cr4_bits(vcpu, X86_CR4_PKE))) {
>>                  vcpu->arch.pkru = rdpkru();
>>                  if (vcpu->arch.pkru != vcpu->arch.host_pkru)
>> -                       __write_pkru(vcpu->arch.host_pkru);
>> +                       __write_pkru(vcpu->arch.host_pkru, true);
>>          }
> 
> Suppose the guest writes to PKRU and then, without exiting, sets PKE =
> 0 and XCR0[PKRU] = 0.  (Or are the intercepts such that this can't
> happen except on SEV where maybe SEV magic makes the problem go away?)

Yes, see above.  KVM needs to trap CR4 and XCR0 anyway (CR4 because you 
don't want the guest to clear e.g. MCE, XCR0 to forbid setting bits that 
the host kernel does not have in its own xstate).

> I admit I'm fairly mystified as to why KVM doesn't handle PKRU like
> the rest of guest XSTATE.
Because the rest of the guest XSTATE is live too early.  The problem you 
mention above with respect to perf, where you access host memory with 
the guest PKRU, would be very much amplified.

It is basically the opposite problem of what you have in 
switch_fpu_finish, which loads PKRU eagerly while delaying the rest to 
the switch to userland.

Paolo

