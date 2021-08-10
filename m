Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7F33E852A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 23:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhHJVWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 17:22:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233895AbhHJVWB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 17:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628630498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WRig48A/Y5ELWIXGfc5pI8HkAOxX1i/Vg3HxN4KtJsk=;
        b=LHMUJKAYa8SMDck+wmLridOrrA2/YBsLdwH1UTWe0LO+rLjZZIlzuCgUC3QPht9kWpXA89
        p9teaoHeuZvjDKsmjOo6onnrnwSyJW5fkUSYS64/BFMdMaCMQXXxuwsKK3Z36tugyq7jPJ
        kRymr62O5s8X9qmtwb0DJT5rmOv1XMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-PvZ7OvBQN5q3Bq30GCpdAw-1; Tue, 10 Aug 2021 17:21:37 -0400
X-MC-Unique: PvZ7OvBQN5q3Bq30GCpdAw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0EED8799E0;
        Tue, 10 Aug 2021 21:21:35 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7172E620DE;
        Tue, 10 Aug 2021 21:21:32 +0000 (UTC)
Message-ID: <42cb19be1f6598e878b5b122e2152bdec27f62db.camel@redhat.com>
Subject: Re: [PATCH v4 00/16] My AVIC patch queue
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Date:   Wed, 11 Aug 2021 00:21:31 +0300
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-08-10 at 23:52 +0300, Maxim Levitsky wrote:
> Hi!
> 
> This is a series of bugfixes to the AVIC dynamic inhibition, which was
> made while trying to fix bugs as much as possible in this area and trying
> to make the AVIC+SYNIC conditional enablement work.
> 
> * Patches 1,3-8 are code from Sean Christopherson which

I mean patches 1,4-8. I forgot about patch 3 which I also added,
which just added a comment about parameters of the kvm_flush_remote_tlbs_with_address.

Best regards,
	Maxim Levitsky

>   implement an alternative approach of inhibiting AVIC without
>   disabling its memslot.
> 
>   V4: addressed review feedback.
> 
> * Patch 2 is new and it fixes a bug in kvm_flush_remote_tlbs_with_address
> 
> * Patches 9-10 in this series fix a race condition which can cause
>   a lost write from a guest to APIC when the APIC write races
>   the AVIC un-inhibition, and add a warning to catch this problem
>   if it re-emerges again.
> 
>   V4: applied review feedback from Paolo
> 
> * Patch 11 is the patch from Vitaly about allowing AVIC with SYNC
>   as long as the guest doesn’t use the AutoEOI feature. I only slightly
>   changed it to expose the AutoEOI cpuid bit regardless of AVIC enablement.
> 
>   V4: fixed a race that Paolo pointed out.
> 
> * Patch 12 is a refactoring that is now possible in SVM AVIC inhibition code,
>   because the RCU lock is not dropped anymore.
> 
> * Patch 13-15 fixes another issue I found in AVIC inhibit code:
> 
>   Currently avic_vcpu_load/avic_vcpu_put are called on userspace entry/exit
>   from KVM (aka kvm_vcpu_get/kvm_vcpu_put), and these functions update the
>   "is running" bit in the AVIC physical ID remap table and update the
>   target vCPU in iommu code.
> 
>   However both of these functions don't do anything when AVIC is inhibited
>   thus the "is running" bit will be kept enabled during the exit to userspace.
>   This shouldn't be a big issue as the caller
>   doesn't use the AVIC when inhibited but still inconsistent and can trigger
>   a warning about this in avic_vcpu_load.
> 
>   To be on the safe side I think it makes sense to call
>   avic_vcpu_put/avic_vcpu_load when inhibiting/uninhibiting the AVIC.
>   This will ensure that the work these functions do is matched.
> 
>   V4: I splitted a single patch to 3 patches to make it easier
>       to review, and applied Paolo's review feedback.
> 
> * Patch 16 removes the pointless APIC base
>   relocation from AVIC to make it consistent with the rest of KVM.
> 
>   (both AVIC and APICv only support default base, while regular KVM,
>   sort of support any APIC base as long as it is not RAM.
>   If guest attempts to relocate APIC base to non RAM area,
>   while APICv/AVIC are active, the new base will be non accelerated,
>   while the default base will continue to be AVIC/APICv backed).
> 
>   On top of that if guest uses different APIC bases on different vCPUs,
>   KVM doesn't honour the fact that the MMIO range should only be active
>   on that vCPU.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (14):
>   KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with_address
>   KVM: x86/mmu: add comment explaining arguments to kvm_zap_gfn_range
>   KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range
>   KVM: x86/mmu: rename try_async_pf to kvm_faultin_pfn
>   KVM: x86/mmu: allow kvm_faultin_pfn to return page fault handling code
>   KVM: x86/mmu: allow APICv memslot to be enabled but invisible
>   KVM: x86: don't disable APICv memslot when inhibited
>   KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM
>   KVM: SVM: add warning for mistmatch between AVIC vcpu state and AVIC
>     inhibition
>   KVM: SVM: remove svm_toggle_avic_for_irq_window
>   KVM: SVM: avoid refreshing avic if its state didn't change
>   KVM: SVM: move check for kvm_vcpu_apicv_active outside of
>     avic_vcpu_{put|load}
>   KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling
>     AVIC
>   KVM: SVM: AVIC: drop unsupported AVIC base relocation code
> 
> Sean Christopherson (1):
>   Revert "KVM: x86/mmu: Allow zap gfn range to operate under the mmu
>     read lock"
> 
> Vitaly Kuznetsov (1):
>   KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
>     use
> 
>  arch/x86/include/asm/kvm-x86-ops.h |  1 -
>  arch/x86/include/asm/kvm_host.h    | 13 +++++-
>  arch/x86/kvm/hyperv.c              | 32 ++++++++++---
>  arch/x86/kvm/mmu/mmu.c             | 75 ++++++++++++++++++++----------
>  arch/x86/kvm/mmu/paging_tmpl.h     |  6 +--
>  arch/x86/kvm/mmu/tdp_mmu.c         | 15 ++----
>  arch/x86/kvm/mmu/tdp_mmu.h         | 11 ++---
>  arch/x86/kvm/svm/avic.c            | 49 +++++++------------
>  arch/x86/kvm/svm/svm.c             | 21 ++++-----
>  arch/x86/kvm/svm/svm.h             |  8 ----
>  arch/x86/kvm/x86.c                 | 67 +++++++++++++++-----------
>  include/linux/kvm_host.h           |  5 ++
>  virt/kvm/kvm_main.c                |  7 ++-
>  13 files changed, 174 insertions(+), 136 deletions(-)
> 
> -- 
> 2.26.3
> 
> 


