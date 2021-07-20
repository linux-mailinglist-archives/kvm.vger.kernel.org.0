Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87453CF70B
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 11:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbhGTJBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 05:01:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235067AbhGTJAP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Jul 2021 05:00:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626774020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=psl/Y0YeDesDSvvX0K9O4PlMS+cXNrVUv/fdU9aleUg=;
        b=ZLsuwGsE9Xrdx7Fgqca8pKR8jSV496fhpHhTllJHtQAE+vkatfhxy0b7IsfS2GiMWmqxgM
        nJ2m5W8yLg81wyE8msMdO6kQNsJls5GCpYAYk2g2LlTHOEOQRfLJkjdFww2OAtOXxM+GYZ
        lE2NCGfW/TVMOnWzNWUR+8ctcuD/wDo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-hc-MjiX6N8WajY60t-5dmg-1; Tue, 20 Jul 2021 05:40:19 -0400
X-MC-Unique: hc-MjiX6N8WajY60t-5dmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2977D100C661;
        Tue, 20 Jul 2021 09:40:17 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEC7960C82;
        Tue, 20 Jul 2021 09:40:12 +0000 (UTC)
Message-ID: <3f1e8981b0c4bf19aedeeee79506e88fa886dc16.camel@redhat.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Date:   Tue, 20 Jul 2021 12:40:11 +0300
In-Reply-To: <YPXJQxLaJuoF6aXl@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
         <20210713142023.106183-9-mlevitsk@redhat.com>
         <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
         <YPXJQxLaJuoF6aXl@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-07-19 at 18:49 +0000, Sean Christopherson wrote:
> On Sun, Jul 18, 2021, Maxim Levitsky wrote:
> > I am more inclined to fix this by just tracking if we hold the srcu
> > lock on each VCPU manually, just as we track the srcu index anyway,
> > and then kvm_request_apicv_update can use this to drop the srcu
> > lock when needed.
> 
> The entire approach of dynamically adding/removing the memslot seems doomed to
> failure, and is likely responsible for the performance issues with AVIC, e.g. a
> single vCPU temporarily inhibiting AVIC will zap all SPTEs _twice_; on disable
> and again on re-enable.
100% agree, especially about the fact that this approach is doomed to fail.
 
There are two reasons why I didn't explore the direction you propose:
 
(when I talked about this on IRC with Paolo, I did suggest trying to explore 
this direction once)
 
One is that practically speaking AVIC inhibition is not something that happens often,
and in all of my tests it didn't happen after the VM had finished booting.
 
There are the following cases when AVIC is inhibited:
 
1.Not possible to support configuration
 
  (PIT reinject mode, x2apic mode, autoeoi mode of hyperv SYNIC)
 
  With the theoretical exception of the SYNIC autoeoi mode, it is something that happens
  only once when qemu configures the VM.
 
  In all of my tests the SYNIC autoeoi mode was also enabled once on each vCPU and 
  stayed that way.
 
 
2.Not yet supported configuration (nesting)
  Something that will go away eventually and also something that fires only once
  at least currently.
 
3.Dynamically when the guest dares to use local APIC's virtual wire mode to
  send PIC's connected interrupts via LAPIC, and since this can't be done using AVIC
  because in this mode, the interrupt must not affect local APIC registers (like IRR, ISR, etc),
  a normal EVENTINJ injection has to be done.
  This sometimes requires detection of the start of the interrupt window, which is something not 
  possible to do when AVIC is enabled because AVIC makes the CPU ignore the so called
  virtual interrupts, which we inject and intercept, to detect it.

  This case only happens on windows and in OVMF (both are silly enough to use this mode),
  and thankfully windows only uses this mode during boot. 

Thus even a gross performance issue isn't an issue yet, but it would be
indeed nice to eliminate it if we ever need to deal with a guest which
does somehow end up enabling and disabling AVIC many times per second.

> 
> Rather than pile on more gunk, what about special casing the APIC access page
> memslot in try_async_pf()?  E.g. zap the GFN in avic_update_access_page() when
> disabling (and bounce through kvm_{inc,dec}_notifier_count()), and have the page
> fault path skip directly to MMIO emulation without caching the MMIO info.  It'd
> also give us a good excuse to rename try_async_pf() :-)

I understand what you mean about renaming try_async_pf :-)
 
As for the other reason, the reason is simple: Fear ;-)
While I do know the KVM's MMU an order of magnitude better than I did a year ago,
I still don't have the confidence needed to add hacks to it.
 
I do agree that a special AVIC hack in the mmu as you propose is miles better than
dynamic disable hack of the AVIC memslot.

> 
> If lack of MMIO caching is a performance problem, an alternative solution would
> be to allow caching but add a helper to zap the MMIO SPTE and request all vCPUs to
> clear their cache.

In theory this can be an issue. LAPIC MMIO has the ICR register which is split in two,
Thus, lack of caching should hurt performance.

With that said, a management layer (e.g libvirt) these days always enables X2APIC
and KVM exposes it as supported in CPUID regardless of host support fo it,
as it still has better performance than unaccelerated xAPIC.
 
This means that it can be expected that a management layer will only disable X2APIC
when it enables AVIC and sets up everything such as it is actually used, and therefore
no performance impact will be felt.
 
(the time during which the AVIC could be dynamically inhibited is neglectable as I explained above).

> 
> It's all a bit gross, especially hijacking the mmu_notifier path, but IMO it'd be
> less awful than the current memslot+SRCU mess.
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f4d35289f59e..ea434d76cfb0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3767,9 +3767,9 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>                                   kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
>  }
> 
> -static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> -                        gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
> -                        bool write, bool *writable)
> +static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> +                           gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
> +                           bool write, bool *writable, int *r)
>  {
>         struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>         bool async;
> @@ -3780,13 +3780,26 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>          * be zapped before KVM inserts a new MMIO SPTE for the gfn.
>          */
>         if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
> -               return true;
> +               goto out_retry;
> 
> -       /* Don't expose private memslots to L2. */
> -       if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
> -               *pfn = KVM_PFN_NOSLOT;
> -               *writable = false;
> -               return false;
> +       if (!kvm_is_visible_memslot(slot)) {
> +               /* Don't expose private memslots to L2. */
> +               if (is_guest_mode(vcpu)) {
> +                       *pfn = KVM_PFN_NOSLOT;
> +                       *writable = false;
> +                       return false;
> +               }
> +               /*
> +                * If the APIC access page exists but is disabled, go directly
> +                * to emulation without caching the MMIO access or creating a
> +                * MMIO SPTE.  That way the cache doesn't need to be purged
> +                * when the AVIC is re-enabled.
> +                */
> +               if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> +                   !vcpu->kvm->arch.apic_access_memslot_enabled) {
> +                       *r = RET_PF_EMULATE;
> +                       return true;
> +               }
>         }
> 
>         async = false;
> @@ -3800,14 +3813,19 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>                 if (kvm_find_async_pf_gfn(vcpu, gfn)) {
>                         trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
>                         kvm_make_request(KVM_REQ_APF_HALT, vcpu);
> -                       return true;
> -               } else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn))
> -                       return true;
> +                       goto out_retry;
> +               } else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn)) {
> +                       goto out_retry;
> +               }
>         }
> 
>         *pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
>                                     write, writable, hva);
>         return false;
> +
> +out_retry:
> +       *r = RET_PF_RETRY;
> +       return true;
>  }
> 
>  static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> @@ -3839,9 +3857,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>         mmu_seq = vcpu->kvm->mmu_notifier_seq;
>         smp_rmb();
> 
> -       if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
> -                        write, &map_writable))
> -               return RET_PF_RETRY;
> +       if (kvm_faultin_pfn(vcpu, prefault, gfn, gpa, &pfn, &hva, write,
> +                           &map_writable, &r))
> +               return r;
> 
>         if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
>                 return r;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 490a028ddabe..9747124b877d 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -881,9 +881,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
>         mmu_seq = vcpu->kvm->mmu_notifier_seq;
>         smp_rmb();
>  
> -       if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
> -                        write_fault, &map_writable))
> -               return RET_PF_RETRY;
> +       if (kvm_faultin_pfn(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
> +                           write_fault, &map_writable, &r))
> +               return r;
>  
>         if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
>                 return r;
> 


The above approach looks very good.
Paolo what do you think?

Best regards,
	Maxim Levitsky


