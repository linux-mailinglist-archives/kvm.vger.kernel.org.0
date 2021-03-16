Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F1A33CF87
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbhCPIRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:17:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234323AbhCPIQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 04:16:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615882616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5NixAWo2L192GjS49CTRpMpnX6TxvYjn/CDZBxz3kWA=;
        b=Cexrur4loQO730JCYAeuIkx/ZkEkeTK4+etykm9PM1x0EQsy9R2cw9Z/tZN3QPFCtTcsbJ
        44kbduEYTOvoOJjZJOSPoUIeDvROM2z80r5YCYGBvGYXbhG2u6uvUbYxm1E3m3hda+kg2+
        UVpTw8D01WZr+EOIAYAzpKBHUpAHfU4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-q9VjAwrvM8C9CR24ZEuuHw-1; Tue, 16 Mar 2021 04:16:52 -0400
X-MC-Unique: q9VjAwrvM8C9CR24ZEuuHw-1
Received: by mail-ed1-f71.google.com with SMTP id k8so17193820edn.19
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 01:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5NixAWo2L192GjS49CTRpMpnX6TxvYjn/CDZBxz3kWA=;
        b=jV5QJzKThAZVy5vHfzWFZWcpuPSqANtO1bs6I3EBhZ9m8fvTK5MA/d+cxVMkSHpG3E
         JU3Y8+JYjtqzq4zCPYYTlKnOhIPxrvb9vyiIzm6e6jMnkZANAip8oNeNWaErLwuzyQ6d
         v+3+kHsIpf1aCRQF3cr63uRKkwWm7GBPSjXo30Ez/d4CT678iTQVs8xiCynOH84sIQxO
         F0/uom8dscsKHQXhIf2H0F+MjqKq4wEK5tH9u72lHHOvecjtgTrJ5vnaA3l/XSohjQWX
         yVK7Wi0EMynWu5tpxJ/0bULmXtXMbSWPwdFuKDqmDGK1IIoYWqi1CPChCkUpDSWljr1w
         toPw==
X-Gm-Message-State: AOAM533f5/KOHQ9ctYYZMZn65DrBuwZEqvLp223BV4NA3DQsGkFtGiS4
        hfnqoYajygMO78uBsKHQzj0dncsLkRRzW1Cp1TExDdFAWX7RoNRfQVbd0aMzTYqMBciaheI/Hok
        DUBSm7ZlO8LPN
X-Received: by 2002:a05:6402:4244:: with SMTP id g4mr23001137edb.204.1615882611040;
        Tue, 16 Mar 2021 01:16:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7t3H6KEhXgNFGrOMSYsDwObIjgAAGOnyeOOpn3KmGoF03QOd8bbqUwjVPSy85EYSfsd9kKQ==
X-Received: by 2002:a05:6402:4244:: with SMTP id g4mr23001122edb.204.1615882610883;
        Tue, 16 Mar 2021 01:16:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b18sm9024900ejb.77.2021.03.16.01.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 01:16:50 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: nSVM: improve SYSENTER emulation on AMD
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>
References: <20210315174316.477511-1-mlevitsk@redhat.com>
 <20210315174316.477511-3-mlevitsk@redhat.com>
 <0dbcff57-8197-8fbb-809d-b47a4f5e9e77@redhat.com>
 <1a4f35e356c50e38916acef6c86175b24efca0a3.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1ee6230-760e-b614-5290-663b44fe1436@redhat.com>
Date:   Tue, 16 Mar 2021 09:16:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1a4f35e356c50e38916acef6c86175b24efca0a3.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/21 19:19, Maxim Levitsky wrote:
> On Mon, 2021-03-15 at 18:56 +0100, Paolo Bonzini wrote:
>> On 15/03/21 18:43, Maxim Levitsky wrote:
>>> +	if (!guest_cpuid_is_intel(vcpu)) {
>>> +		/*
>>> +		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
>>> +		 * in VMCB and clear intercepts to avoid #VMEXIT.
>>> +		 */
>>> +		if (vls) {
>>> +			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
>>> +			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
>>> +			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
>>> +		}
>>> +		/* No need to intercept these msrs either */
>>> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
>>> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
>>> +	}
>>
>> An "else" is needed here to do the opposite setup (removing the "if
>> (vls)" from init_vmcb).
> 
> init_vmcb currently set the INTERCEPT_VMLOAD and INTERCEPT_VMSAVE and it doesn't enable vls

There's also this towards the end of the function:

         /*
          * If hardware supports Virtual VMLOAD VMSAVE then enable it
          * in VMCB and clear intercepts to avoid #VMEXIT.
          */
         if (vls) {
                 svm_clr_intercept(svm, INTERCEPT_VMLOAD);
                 svm_clr_intercept(svm, INTERCEPT_VMSAVE);
                 svm->vmcb->control.virt_ext |= 
VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
         }

> thus there is nothing to do if I don't want to enable vls.
> It seems reasonable to me.
> 
> Both msrs I marked as '.always = false' in the
> 'direct_access_msrs', which makes them be intercepted by the default.
> If I were to use '.always = true' it would feel a bit wrong as the intercept is not always
> enabled.

I agree that .always = false is correct.

> What do you think?

You can set the CPUID multiple times, so you could go from AMD to Intel 
and back.

Thanks,

Paolo

