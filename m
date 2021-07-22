Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CABE3D2B43
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhGVQza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 12:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229575AbhGVQz3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 12:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626975363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=guCqBWpVTzP+Sew+BobhY6iLap7ab0MnRptplCU8QQc=;
        b=jRtsFGzCmRBQ2STBeCTmctsTj3OrOGAwNbnPKQqROHNylYSzcLO1BM+HHnk/REljmeqtkk
        MGqyEP2VVXWYZOvhjRi4zQJwGcRZ+LhNLPBqY325XM0exPXJClZzsQM0dIk8T3ek3oC5bQ
        jZ1NRq1Q3Z2BuJn3i0euUPI93udAmh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-B28Sw4rpOSKEUXVuW5qwIw-1; Thu, 22 Jul 2021 13:36:01 -0400
X-MC-Unique: B28Sw4rpOSKEUXVuW5qwIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA5EAC73A1;
        Thu, 22 Jul 2021 17:35:59 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EC9160936;
        Thu, 22 Jul 2021 17:35:55 +0000 (UTC)
Message-ID: <64ed28249c1895a59c9f2e2aa2e4c09a381f69e5.camel@redhat.com>
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
Date:   Thu, 22 Jul 2021 20:35:54 +0300
In-Reply-To: <YPXJQxLaJuoF6aXl@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
         <20210713142023.106183-9-mlevitsk@redhat.com>
         <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
         <YPXJQxLaJuoF6aXl@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
> 
> Rather than pile on more gunk, what about special casing the APIC access page
> memslot in try_async_pf()?  E.g. zap the GFN in avic_update_access_page() when
> disabling (and bounce through kvm_{inc,dec}_notifier_count()), and have the page
> fault path skip directly to MMIO emulation without caching the MMIO info.  It'd
> also give us a good excuse to rename try_async_pf() :-)
> 
> If lack of MMIO caching is a performance problem, an alternative solution would
> be to allow caching but add a helper to zap the MMIO SPTE and request all vCPUs to
> clear their cache.
> 
> It's all a bit gross, especially hijacking the mmu_notifier path, but IMO it'd be
> less awful than the current memslot+SRCU mess.

Hi!

I am testing your approach and it actually works very well! I can't seem to break it.

Could you explain why do I need to do something with kvm_{inc,dec}_notifier_count()) ?

I just use your patch as is, plus the changes that are needed in kvm_request_apicv_update.

On AVIC unlike APICv, the page in this memslot is pinned in the physical memory still
(AVIC misses the code that APICv has in this regard).
It should be done in the future though.

Best regards,
	Maxim Levitsky

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


