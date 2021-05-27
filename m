Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8F03929A5
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 10:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbhE0IhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 04:37:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235284AbhE0IhQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 04:37:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622104543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vBslrakqO+6W0zgSMz624pjA0p7Sqe872IJTzAdcodQ=;
        b=WGdF0qXLbaFyo9wBj7V3Elp9tRsGFnnXa4/h7BFT9/OsklxXhndXni9GH6YkRbzwxurXWU
        0qq79HiwTMPMhce/tn87r5MQg2UfQigr0k32sEyOOWvP+lr3yXaA4ftaaAZD4kZGo5F+xF
        pR+rj9kZhBDZJwri0Rkcd6N1gC/TUKE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-HGC21idbPWaooZzBcC9KrQ-1; Thu, 27 May 2021 04:35:41 -0400
X-MC-Unique: HGC21idbPWaooZzBcC9KrQ-1
Received: by mail-wm1-f70.google.com with SMTP id n20-20020a05600c4f94b029017f371265feso1228728wmq.5
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 01:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vBslrakqO+6W0zgSMz624pjA0p7Sqe872IJTzAdcodQ=;
        b=TRvY4ro7CDYuRGI9643SZChzjh6S45dG29YzIoWG9GYo8ltaKjOr4DO9XwACroSJ2C
         jw4Mzcrq6RTLTczBEwtbBqPWN8ZVuEpNDpKajKz/vcqvlprltw5pXr6d23/57aivgqfH
         0Z/RZbWV/XlfcsNPnvyH9OhInz4Vv2PnajD1HV6zS+C7FxDB0tB6/uqJditjYX4gxCHF
         04Az21FBd3Z9PedTj79NwwO7uGmctUmcJJ/SVK93Or80KCSZBuiR3+MuAiKqa/vuQDhb
         Yhm0ZMpha753Hm6u1lqeylwFJ/dZyeDo4tKKvC4xSUFiFkcVN38V8xymTsnU4HFaAKw0
         cYKQ==
X-Gm-Message-State: AOAM532ttOMZR3vA7ojqgIVR5SNBjv2LjeKOWhRP39ZRjnvqCIQV1IVF
        /WK1rBCnBfD2cdwsMyZINyTYZ32zmscpVrmoHYD79wAJMGanqjUqUlZxIr9ZjT9Z8sTW9r6oXQC
        ySrK0txCHtaDL
X-Received: by 2002:a7b:ce8d:: with SMTP id q13mr7132419wmj.109.1622104540069;
        Thu, 27 May 2021 01:35:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVmdZpdmJFQxFD7MlW5X9vtBcqu4gT4wNnF2sND/4u9whBcq2yYO3LxpBNDHnCL0iHOEyeIQ==
X-Received: by 2002:a7b:ce8d:: with SMTP id q13mr7132393wmj.109.1622104539818;
        Thu, 27 May 2021 01:35:39 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id t17sm1936561wrp.89.2021.05.27.01.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 01:35:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] KVM: x86: hyper-v: Conditionally allow SynIC
 with APICv/AVIC
In-Reply-To: <2409eb8593804eb879ae6fb961a709ca8c20f329.camel@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
 <2409eb8593804eb879ae6fb961a709ca8c20f329.camel@redhat.com>
Date:   Thu, 27 May 2021 10:35:38 +0200
Message-ID: <874keo7ew5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
>> Changes since v1 (Sean):
>> - Use common 'enable_apicv' variable for both APICv and AVIC instead of 
>>  adding a new hook to 'struct kvm_x86_ops'.
>> - Drop unneded CONFIG_X86_LOCAL_APIC checks from VMX/SVM code along the
>>  way.
>> 
>> Original description:
>> 
>> APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
>> SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
>> however, possible to track whether the feature was actually used by the
>> guest and only inhibit APICv/AVIC when needed.
>> 
>> The feature can be tested with QEMU's 'hv-passthrough' debug mode.
>> 
>> Note, 'avic' kvm-amd module parameter is '0' by default and thus needs to
>> be explicitly enabled.
>> 
>> Vitaly Kuznetsov (5):
>>   KVM: SVM: Drop unneeded CONFIG_X86_LOCAL_APIC check for AVIC
>>   KVM: VMX: Drop unneeded CONFIG_X86_LOCAL_APIC check from
>>     cpu_has_vmx_posted_intr()
>>   KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
>>   KVM: x86: Invert APICv/AVIC enablement check
>>   KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
>>     use
>> 
>>  arch/x86/include/asm/kvm_host.h |  5 ++++-
>>  arch/x86/kvm/hyperv.c           | 27 +++++++++++++++++++++------
>>  arch/x86/kvm/svm/avic.c         | 16 +++++-----------
>>  arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
>>  arch/x86/kvm/svm/svm.h          |  2 --
>>  arch/x86/kvm/vmx/capabilities.h |  4 +---
>>  arch/x86/kvm/vmx/vmx.c          |  2 --
>>  arch/x86/kvm/x86.c              |  9 ++++++---
>>  8 files changed, 50 insertions(+), 39 deletions(-)
>> 
>
> I tested this patch set and this is what I found.
>
> For reference,
> First of all, indeed to make AVIC work I need to:
>  
> 1. Disable SVM - I wonder if I can make this on demand
> too when the guest actually uses a nested guest or at least
> enables nesting in IA32_FEATURE_CONTROL.
> I naturally run most of my VMs with nesting enabled,
> thus I tend to not have avic enabled due to this.
> I'll prepare a patch soon for this.
>  
> 2. Disable x2apic, naturally x2apic can't be used with avic.
> In theory we can also disable avic when the guest switches on
> the x2apic mode, but in practice the guest will likely to pick the x2apic
> when it can.
>  
> 3. (for hyperv) Disable 'hv_vapic', because otherwise hyper-v
> uses its own PV APIC msrs which AVIC doesn't support.
>
> This HV enlightment turns on in the CPUID both the 
> HV_APIC_ACCESS_AVAILABLE which isn't that bad 
> (it only tells that we have the VP assist page),
> and HV_APIC_ACCESS_RECOMMENDED which hints the guest
> to use HyperV PV APIC MSRS and use PV EOI field in 
> the APIC access page, which means that the guest 
> won't use the real apic at all.
>
> 4. and of course enable SynIC autoeoi deprecation.
>
> Otherwise indeed windows enables autoeoi.
>
> hv-passthrough indeed can't be used to test this
> as it both enables autoeoi depreciation and *hv-vapic*. 
> I had to use the patch that you posted
> in 'About the performance of hyper-v' thread.
>  
> In addition to that when I don't use the autoeoi depreciation patch,
> then the guest indeed enables autoeoi, and this triggers a deadlock.
>  

Hm, why don't I see in my testing? I'm pretty sure I'm testing both
cases...

> The reason is that kvm_request_apicv_update must not be called with
> srcu lock held vcpu->kvm->srcu (there is a warning about that
> in kvm_request_apicv_update), but guest msr writes which come
> from vcpu thread do hold it.
>  
> The other place where we disable AVIC on demand is svm_toggle_avic_for_irq_window.
> And that code has a hack to drop this lock and take 
> it back around the call to kvm_request_apicv_update.
> This hack is safe as this code is called only from the vcpu thread.
>  
> Also for reference the reason for the fact that we need to
> disable AVIC on the interrupt window request, or more correctly
> why we still need to request interrupt windows with AVIC,
> is that the local apic can act sadly as a pass-through device 
> for legacy PIC, when one of its LINTn pins is configured in ExtINT mode.
> In this mode when such pin is raised, the local apic asks the PIC for
> the interrupt vector and then delivers it to the APIC
> without touching the IRR/ISR.
>
> The later means that if guest's interrupts are disabled,
> such interrupt can't be queued via IRR to VAPIC
> but instead the regular interrupt window has to be requested, 
> but on AMD, the only way to request interrupt window
> is to queue a VIRQ, and intercept its delivery,
> a feature that is disabled when AVIC is active.
>  
> Finally for SynIC this srcu lock drop hack can be extended to this gross hack:
> It seems to work though:
>
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index bedd9b6cc26a..925b76e7b45e 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -85,7 +85,7 @@ static bool synic_has_vector_auto_eoi(struct kvm_vcpu_hv_synic *synic,
>  }
>  
>  static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
> -				int vector)
> +				int vector, bool host)
>  {
>  	struct kvm_vcpu *vcpu = hv_synic_to_vcpu(synic);
>  	struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> @@ -109,6 +109,9 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
>  
>  	auto_eoi_new = bitmap_weight(synic->auto_eoi_bitmap, 256);
>  
> +	if (!host)
> +		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> +
>  	/* Hyper-V SynIC auto EOI SINTs are not compatible with APICV */
>  	if (!auto_eoi_old && auto_eoi_new) {
>  		printk("Synic: inhibiting avic %d %d\n", auto_eoi_old, auto_eoi_new);
> @@ -121,6 +124,10 @@ static void synic_update_vector(struct kvm_vcpu_hv_synic *synic,
>  			kvm_request_apicv_update(vcpu->kvm, true,
>  						 APICV_INHIBIT_REASON_HYPERV);
>  	}
> +
> +	if (!host)
> +		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
>  }
>  
>  static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
> @@ -149,9 +156,9 @@ static int synic_set_sint(struct kvm_vcpu_hv_synic *synic, int sint,
>  
>  	atomic64_set(&synic->sint[sint], data);
>  
> -	synic_update_vector(synic, old_vector);
> +	synic_update_vector(synic, old_vector, host);
>  
> -	synic_update_vector(synic, vector);
> +	synic_update_vector(synic, vector, host);
>  
>  	/* Load SynIC vectors into EOI exit bitmap */
>  	kvm_make_request(KVM_REQ_SCAN_IOAPIC, hv_synic_to_vcpu(synic));
>
>
> Assuming that we don't want this gross hack,  

Is it dangerous or just ugly?

> I wonder if we can avoid full blown memslot 
> update when we disable avic, but rather have some 
> smaller hack like only manually patching its
> NPT mapping to have RW permissions instead 
> of reserved bits which we use for MMIO. 
>
> The AVIC spec says that NPT is only used to check that
> guest has RW permission to the page, 
> while the HVA in the NPT entry itself is ignored.

Assuming kvm_request_apicv_update() is called very rarely, I'd rather
kicked all vCPUs out (similar to KVM_REQ_MCLOCK_INPROGRESS) and
schedule_work() to make memslot update happen ourside of sRCU lock.

>
> Best regards,
> 	Maxim Levitsky
>
>
>
>
>

-- 
Vitaly

