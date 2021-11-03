Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B264442F1
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 15:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhKCODF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 10:03:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230527AbhKCODE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 10:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635948027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bkPllbGEaNokgSQGekCjbxHVsi6h/8ZMYmMh35cbn+8=;
        b=U7A8hablSpZ7BL08OlFSYak2o/jjGBPWhH8/p6jG0w/BCuNqlmJKdAo/RprVd5CW23ubP2
        qfpLBbRePY3x0i29OyXIPKSoL6g3o9WCywu/KbWfZsa+xDZ+yIZGffAA+ikfT4wTBgroZW
        p9ZnH77U0SM2Lhb2ITTk3/i41AFZOVw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-m6lje74lNTyb6D28eqEXZg-1; Wed, 03 Nov 2021 10:00:26 -0400
X-MC-Unique: m6lje74lNTyb6D28eqEXZg-1
Received: by mail-wm1-f69.google.com with SMTP id m1-20020a1ca301000000b003231d5b3c4cso2793693wme.5
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 07:00:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bkPllbGEaNokgSQGekCjbxHVsi6h/8ZMYmMh35cbn+8=;
        b=5bSf2yaFOA3FhQ5xMZSXMqyGO75vao6VcqiPKiIeMU5kaJW1tyYSIsY6OyeTfC5y7z
         zEdtwt3A5juhdH/Pqp5SgS1QkN3+cNYKrEmqGt2pq42NmEHeMGyVLZi3N1EEvO9FuYnp
         6W2ADUC2zxMUAGtE10r8QmHx8TZhNiBUQDLdmxvlZJjutInQymgZ/b0BDjw6JthRyRG+
         rtEc3S0cawoB/5zdGG3aj5o2vuECqgSGu1hjJrnAhyh+AjjRPhdCvwcBPtjZ3Yw15F4N
         sMwlZL4WZUYIilKpK4KBTytaUZl3Fcndarw8eWOiICv3BO4ezoGBNWBb+G9kGG0oJ4S1
         WcMw==
X-Gm-Message-State: AOAM5329yJ0YvU+w8cBVyluNDpp1HUUNtVRXkyaQAlg8Kb8YxWzYCdCH
        jkAjE33IuBhGsIIKOy/fVw2XCI+Cz3EnMoz1N0geRNsWIDwPo03CoTMdCTtGdjhYoB//RiVYR+o
        /ku+k2yDgJR2Z
X-Received: by 2002:a7b:c85a:: with SMTP id c26mr15746946wml.53.1635948025570;
        Wed, 03 Nov 2021 07:00:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMgTwPIYzqxHNj8sMq40jDbXoD8WnUEgxL3EAOD/McYtpojcrSyhMW5d8ces/LFemnLUqSZw==
X-Received: by 2002:a7b:c85a:: with SMTP id c26mr15746904wml.53.1635948025269;
        Wed, 03 Nov 2021 07:00:25 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o26sm5489583wmc.17.2021.11.03.07.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 07:00:24 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ
 active
In-Reply-To: <8b7949ae8094217c92b714cfd193fc571654cea7.camel@redhat.com>
References: <20211103094255.426573-1-mlevitsk@redhat.com>
 <871r3xnzaw.fsf@vitty.brq.redhat.com>
 <8b7949ae8094217c92b714cfd193fc571654cea7.camel@redhat.com>
Date:   Wed, 03 Nov 2021 15:00:23 +0100
Message-ID: <87y265mj9k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Wed, 2021-11-03 at 14:28 +0100, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>> 
>> > KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
>> > standard kvm's inject_pending_event, and not via APICv/AVIC.
>> > 
>> > Since this is a debug feature, just inhibit it while it
>> > is in use.
>> > 
>> > Fixes: 61e5f69ef0837 ("KVM: x86: implement KVM_GUESTDBG_BLOCKIRQ")
>> > 
>> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>> > ---
>> >  arch/x86/include/asm/kvm_host.h | 1 +
>> >  arch/x86/kvm/svm/avic.c         | 3 ++-
>> >  arch/x86/kvm/vmx/vmx.c          | 3 ++-
>> >  arch/x86/kvm/x86.c              | 3 +++
>> >  4 files changed, 8 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> > index 88fce6ab4bbd7..8f6e15b95a4d8 100644
>> > --- a/arch/x86/include/asm/kvm_host.h
>> > +++ b/arch/x86/include/asm/kvm_host.h
>> > @@ -1034,6 +1034,7 @@ struct kvm_x86_msr_filter {
>> >  #define APICV_INHIBIT_REASON_IRQWIN     3
>> >  #define APICV_INHIBIT_REASON_PIT_REINJ  4
>> >  #define APICV_INHIBIT_REASON_X2APIC	5
>> > +#define APICV_INHIBIT_REASON_BLOCKIRQ	6
>> >  
>> >  struct kvm_arch {
>> >  	unsigned long n_used_mmu_pages;
>> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> > index 8052d92069e01..affc0ea98d302 100644
>> > --- a/arch/x86/kvm/svm/avic.c
>> > +++ b/arch/x86/kvm/svm/avic.c
>> > @@ -904,7 +904,8 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
>> >  			  BIT(APICV_INHIBIT_REASON_NESTED) |
>> >  			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
>> >  			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
>> > -			  BIT(APICV_INHIBIT_REASON_X2APIC);
>> > +			  BIT(APICV_INHIBIT_REASON_X2APIC) |
>> > +			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
>> >  
>> >  	return supported & BIT(bit);
>> >  }
>> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> > index 71f54d85f104c..e4fc9ff7cd944 100644
>> > --- a/arch/x86/kvm/vmx/vmx.c
>> > +++ b/arch/x86/kvm/vmx/vmx.c
>> > @@ -7565,7 +7565,8 @@ static void hardware_unsetup(void)
>> >  static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>> >  {
>> >  	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
>> > -			  BIT(APICV_INHIBIT_REASON_HYPERV);
>> > +			  BIT(APICV_INHIBIT_REASON_HYPERV) |
>> > +			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
>> >  
>> >  	return supported & BIT(bit);
>> >  }
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index ac83d873d65b0..dccf927baa4dd 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -10747,6 +10747,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>> >  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
>> >  		vcpu->arch.singlestep_rip = kvm_get_linear_rip(vcpu);
>> >  
>> > +	kvm_request_apicv_update(vcpu->kvm,
>> > +				 !(vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ),
>> > +				 APICV_INHIBIT_REASON_BLOCKIRQ);
>> >  	/*
>> >  	 * Trigger an rflags update that will inject or remove the trace
>> >  	 * flags.
>> 
>> This fixes the problem for me!
>> 
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Cool!
>> 
>
> Now that I think about it, since guest debug flags are per-vcpu, this code won't
> work if there are multiple vCPUs and you enable KVM_GUESTDBG_BLOCKIRQ on all of them
> and then disable on this flag on just one of vCPUs, because this code will re-enable APICv/AVIC in this case.
> A counter is needed, like you did in synic/autoeoi case.
>

Right, I completely forgot about this peculiarity!

-- 
Vitaly

