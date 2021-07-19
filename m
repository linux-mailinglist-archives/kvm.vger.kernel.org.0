Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881E73CEE51
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387527AbhGSUe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383721AbhGSSJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 14:09:21 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A46C061786
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:37:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g24so11995288pji.4
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xs0QjZTAxJ4hJWmqebyF0esmS5yFAGMicwR/GdEGj2c=;
        b=gnHG4ARHZtOcS3KynjUaW5BMR4pFmlGR6R81Q9pRmaNF/LzBno9XrxaoMNOTUjUF16
         NQvdnvfs6sOOIuJiZYqUSh+BVmEQuyk2L6GE/6M9medSMcCB6gb+G+V7jLFKvEPut6gr
         sg4tqMHMdh02cHG0pZzQpax+OpxaMR0VHK9RnG/2xQNeH63SxgNAvwmCpcsrIYEiW+cU
         1bZvztlNPa0pYzUSE61XskbZ3a8G0kgdDivxAqeHIGlr4rsGNmXmZ7FyW+oV7hQ3b8rJ
         9Kd0VjOMADXRtRDdl6g47w9LTNX/SmT8c7C4hCSYbeffEJcflraEacKpYWOjy2K6Erbm
         nHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xs0QjZTAxJ4hJWmqebyF0esmS5yFAGMicwR/GdEGj2c=;
        b=sQ6FwajFz9WJGkma4h/T7wqvphxcfvnE4Mwdpm9pupq4fJuDaCQCTqtgrO58UmjlLr
         JmXTVgcpwRTGFsD6UFFmytqxPSrS8mqjcURQnlq98MClvMt+oxl5pFBM2lIYV+Nz3Hao
         cC+bWVqpnIKSEpHf+CPlH96nm1JNsWjXZozuvbCVtORhv6Cqz3xmPveENo1KGymWEnt3
         wXtrA+CEXRLmDKiC/ovoADk6i0nkhvRydLWGy5D+KJWnahVlYDKc6QaNueFmqNbovMEN
         T1f0DiPJWWhr0sqwVBmzC/5EFEDmHyQltMbOmXBJ2nuKZEt0Y/6M/yVY/sN/6407R5ID
         tuPw==
X-Gm-Message-State: AOAM530whyI+ONHuGfW2NaPtZvCrA3AdQXQG4yek+WwvmWFcOFNyvb8k
        34aPRnr+MPHJ4NywkG5wdEk4K3ySo6f/vg==
X-Google-Smtp-Source: ABdhPJyhoFt4sUCN2ajarBa7UvBpTh5hkuUpsoUV1xzwnnJa437MyM26Q8Ace9LMYPUCkke+XACaig==
X-Received: by 2002:a17:902:f282:b029:12b:2b93:fbdd with SMTP id k2-20020a170902f282b029012b2b93fbddmr20432780plc.35.1626720584273;
        Mon, 19 Jul 2021 11:49:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b3sm21272139pfi.179.2021.07.19.11.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 11:49:43 -0700 (PDT)
Date:   Mon, 19 Jul 2021 18:49:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
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
Subject: Re: [PATCH v2 8/8] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
Message-ID: <YPXJQxLaJuoF6aXl@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
 <20210713142023.106183-9-mlevitsk@redhat.com>
 <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 18, 2021, Maxim Levitsky wrote:
> I am more inclined to fix this by just tracking if we hold the srcu
> lock on each VCPU manually, just as we track the srcu index anyway,
> and then kvm_request_apicv_update can use this to drop the srcu
> lock when needed.

The entire approach of dynamically adding/removing the memslot seems doomed to
failure, and is likely responsible for the performance issues with AVIC, e.g. a
single vCPU temporarily inhibiting AVIC will zap all SPTEs _twice_; on disable
and again on re-enable.

Rather than pile on more gunk, what about special casing the APIC access page
memslot in try_async_pf()?  E.g. zap the GFN in avic_update_access_page() when
disabling (and bounce through kvm_{inc,dec}_notifier_count()), and have the page
fault path skip directly to MMIO emulation without caching the MMIO info.  It'd
also give us a good excuse to rename try_async_pf() :-)

If lack of MMIO caching is a performance problem, an alternative solution would
be to allow caching but add a helper to zap the MMIO SPTE and request all vCPUs to
clear their cache.

It's all a bit gross, especially hijacking the mmu_notifier path, but IMO it'd be
less awful than the current memslot+SRCU mess.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f4d35289f59e..ea434d76cfb0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3767,9 +3767,9 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
                                  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }

-static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
-                        gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
-                        bool write, bool *writable)
+static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
+                           gpa_t cr2_or_gpa, kvm_pfn_t *pfn, hva_t *hva,
+                           bool write, bool *writable, int *r)
 {
        struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
        bool async;
@@ -3780,13 +3780,26 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
         * be zapped before KVM inserts a new MMIO SPTE for the gfn.
         */
        if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
-               return true;
+               goto out_retry;

-       /* Don't expose private memslots to L2. */
-       if (is_guest_mode(vcpu) && !kvm_is_visible_memslot(slot)) {
-               *pfn = KVM_PFN_NOSLOT;
-               *writable = false;
-               return false;
+       if (!kvm_is_visible_memslot(slot)) {
+               /* Don't expose private memslots to L2. */
+               if (is_guest_mode(vcpu)) {
+                       *pfn = KVM_PFN_NOSLOT;
+                       *writable = false;
+                       return false;
+               }
+               /*
+                * If the APIC access page exists but is disabled, go directly
+                * to emulation without caching the MMIO access or creating a
+                * MMIO SPTE.  That way the cache doesn't need to be purged
+                * when the AVIC is re-enabled.
+                */
+               if (slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
+                   !vcpu->kvm->arch.apic_access_memslot_enabled) {
+                       *r = RET_PF_EMULATE;
+                       return true;
+               }
        }

        async = false;
@@ -3800,14 +3813,19 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
                if (kvm_find_async_pf_gfn(vcpu, gfn)) {
                        trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
                        kvm_make_request(KVM_REQ_APF_HALT, vcpu);
-                       return true;
-               } else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn))
-                       return true;
+                       goto out_retry;
+               } else if (kvm_arch_setup_async_pf(vcpu, cr2_or_gpa, gfn)) {
+                       goto out_retry;
+               }
        }

        *pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
                                    write, writable, hva);
        return false;
+
+out_retry:
+       *r = RET_PF_RETRY;
+       return true;
 }

 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
@@ -3839,9 +3857,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
        mmu_seq = vcpu->kvm->mmu_notifier_seq;
        smp_rmb();

-       if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, &hva,
-                        write, &map_writable))
-               return RET_PF_RETRY;
+       if (kvm_faultin_pfn(vcpu, prefault, gfn, gpa, &pfn, &hva, write,
+                           &map_writable, &r))
+               return r;

        if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
                return r;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 490a028ddabe..9747124b877d 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -881,9 +881,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
        mmu_seq = vcpu->kvm->mmu_notifier_seq;
        smp_rmb();
 
-       if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
-                        write_fault, &map_writable))
-               return RET_PF_RETRY;
+       if (kvm_faultin_pfn(vcpu, prefault, walker.gfn, addr, &pfn, &hva,
+                           write_fault, &map_writable, &r))
+               return r;
 
        if (handle_abnormal_pfn(vcpu, addr, walker.gfn, pfn, walker.pte_access, &r))
                return r;
