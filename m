Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751E045E952
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 09:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359587AbhKZI1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 03:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359656AbhKZIZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 03:25:17 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B36C061746;
        Fri, 26 Nov 2021 00:19:14 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z5so35624067edd.3;
        Fri, 26 Nov 2021 00:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kjPIuejmixJMckieSdz7EIHII2l1faqnfhtqJyiLPM4=;
        b=fK9prnbv0PgpM0XPK1J1kI3fYoKY1EnF26gdp4hAdKZqzqcdAyMykY/pJuWeRfy/PP
         LFwYrs0duVCYpYc0xMUUNZAz5JvDemy+BxEV/+9NXgLcokMtKtbeh39HRqcL+Z9erQcs
         4SkRvNsIZgVh2z1Yzw4371DyMD8xz4ik2R0bHJV51vh/XI6SZgjweua1jgE79JFnaBgv
         jdx2vO9NNWbfnGeGak//yYO8h6LHfyDcNGktZNGnBY+UhySfucH9RBZI8gIylwYA/0WV
         S7DTWjrlyb3s/R73ktFJI2kBVDvoFk/UZtepflRPF6iBJqVjCnDaEWOYd8sEcHSjoR8g
         ie6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kjPIuejmixJMckieSdz7EIHII2l1faqnfhtqJyiLPM4=;
        b=ETJoYmQkNIQi1us71XWv4AlxPBi/jbAtknWl6RbmoB5pKmym/jT6eedr+5+/O9CsaT
         38NChhI3kmmDVj5AlMnvqBpSz/Faj0uCVc0lIR1PUBz4htVZm3NuxVG4BRKZ1Nakpdln
         s5LHwe6Z5wbrds///9quSOpY4IBaqV8fu6s8OciIQqxTwE/usQut1GUlVnlAoz2dLm7/
         bJfEJQ8td8NcCQjzq5qOHQ/tpdQtm+WP3gHKz+KotWkzA3XvolohZfmT5hJdvY8jQ9mC
         dBeS+xWrjcK+AEsT7pbxejpxPAF8HoqzZkT1If2B6B8WQLTO1CsZOEl/YJslqzEfW04e
         TbHQ==
X-Gm-Message-State: AOAM532Q819r3O306pISBN1t8uST1KF2vCxu3AZvji1jD1jhXMv5iys5
        1Bg37K/2llHNqemJi9mC1Ic=
X-Google-Smtp-Source: ABdhPJwWcSXj8uTzn0NQlmVjeVOpfI6OHn7sYLjajMwrHTgztjLUvEUmX3agGBpOD5IVUeNaFWwy0Q==
X-Received: by 2002:a17:906:6a1a:: with SMTP id qw26mr37453031ejc.489.1637914752497;
        Fri, 26 Nov 2021 00:19:12 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id m22sm3309711eda.97.2021.11.26.00.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 00:19:12 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d449a4c2-131d-5406-b7a2-7549bacc02f9@redhat.com>
Date:   Fri, 26 Nov 2021 09:18:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 23/59] KVM: x86: Allow host-initiated WRMSR to set
 X2APIC regardless of CPUID
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <63556f13e9608cbccf97d356be46a345772d76d3.1637799475.git.isaku.yamahata@intel.com>
 <87fsrkja4j.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87fsrkja4j.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 20:41, Thomas Gleixner wrote:
> On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
>> Let userspace, or in the case of TDX, KVM itself, enable X2APIC even if
>> X2APIC is not reported as supported in the guest's CPU model.  KVM
>> generally does not force specific ordering between ioctls(), e.g. this
>> forces userspace to configure CPUID before MSRs.  And for TDX, vCPUs
>> will always run with X2APIC enabled, e.g. KVM will want/need to enable
>> X2APIC from time zero.
> 
> This is complete crap. Fix the broken user space and do not add
> horrible hacks to the kernel.

tl;dr: I agree that it's a userspace issue but "configure CPUID before 
MSR" is not the issue (in fact QEMU calls KVM_SET_CPUID2 before any call 
to KVM_SET_MSRS).

We have quite a few other cases in which KVM_GET/SET_MSR is allowed to 
get/set MSRs in ways that the guests are not allowed to do.

In general, there are several reasons for this:

- simplifying userspace so that it can use the same list of MSRs for all 
guests (likely, the list that KVM provides with KVM_GET_MSR_INDEX_LIST). 
  For example MSR_TSC_AUX is only exposed to the guest if RDTSCP or 
RDPID are available, but the host can always access it.  This is usually 
the reason why host accesses to MSRs override CPUID.

- simplifying userspace so that it does not have to go through the 
various steps of a state machine; for example, it's okay if userspace 
goes DISABLED->X2APIC instead of having to do DISABLED->XAPIC->X2APIC.

- allowing userspace to set a reset value, for example overriding the 
lock bit in MSR_IA32_FEAT_CTL.

- read-only MSRs that are really "CPUID-like", i.e. they give the guest 
information about processor features (for example the VMX feature MSRs)

- MSRs had some weird limitations that were lifted later by introducing 
additional MSRs; for example KVM always allows the host to write to the 
full-width MSR_IA32_PMC0 counters, because they are a saner version of 
MSR_IA32_PERFCTR0 and there's no reason for userspace to inflict 
MSR_IA32_PERFCTR0 on userspace.

So the host_initiated check doesn't _necessarily_ count as a horrible 
hack in the kernel.  However, in this case we have a trusted domain 
without X2APIC.  I'm not sure this configuration is clearly bogus.  One 
could imagine special-purpose VMs that don't need interrupts at all. 
For full guests such as the ones that QEMU runs, I agree with Thomas 
that userspace must be fixed to enforce x2apic for TDX guests.

Paolo
