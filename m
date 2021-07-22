Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6B13D2099
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 11:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhGVIcS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 04:32:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231355AbhGVIcR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 04:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626945172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LHB99QQaMZardK9UK+e9K5UaHg4KNzxvFPUevQaZZsM=;
        b=dnafXX6FX10MmyZiN/r7ZFG18wkwq5bQmokg0ztnOX4ksEjft8X90HZqLPnrNKB7g+tafW
        ky4WssdiuXvLXSI+21yTvbElmz53JVUEtFno2xt09zV6l1XyfnTEUOylN3fOHOKypQPLRR
        IjnfUK7vWiPWk3SOd5aSIpfe7WY/Pjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-frr_6tsXPaSZpkJny4SU8w-1; Thu, 22 Jul 2021 05:12:51 -0400
X-MC-Unique: frr_6tsXPaSZpkJny4SU8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BA7B107465F;
        Thu, 22 Jul 2021 09:12:49 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D149919D9B;
        Thu, 22 Jul 2021 09:12:44 +0000 (UTC)
Message-ID: <564fd4461c73a4ec08d68e2364401db981ecba3a.camel@redhat.com>
Subject: KVM's support for non default APIC base
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
Date:   Thu, 22 Jul 2021 12:12:43 +0300
In-Reply-To: <YPXJQxLaJuoF6aXl@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
         <20210713142023.106183-9-mlevitsk@redhat.com>
         <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
         <YPXJQxLaJuoF6aXl@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
> less awful than the current memslot+SRCU mess

Hi Sean, Paolo and everyone else:

I am exploring the approach that you proposed and I noticed that we have very inconsistient
code that handles the APIC base relocation for in-kernel local apic.
I do know that APIC base relocation is not supported, and I don't have anything against
this as long as VMs don't use that feature, but I do want this to be consistent.

I did a study of the code that is involved in this mess and I would like to hear your opinion:

There are basically 3 modes of operation of in kernel local apic:

Regular unaccelerated local apic:

-> APIC MMIO base address is stored at 'apic->base_address', and updated in 
   kvm_lapic_set_base which is called from  msr write of 'MSR_IA32_APICBASE'
   (both by SVM and VMX).
   The value is even migrated.

-> APIC mmio read/write is done from MMU, when we access MMIO page:
	vcpu_mmio_write always calls apic_mmio_write which checks if the write is in 
	apic->base_address page and if so forwards the write local apic with offset
	in this page.

-> APIC MMIO area has to be MMIO for 'apic_mmio_write' to be called,
   thus must contain no guest memslots.
   If the guest relocates the APIC base somewhere where we have a memslot, 
   memslot will take priority, while on real hardware, LAPIC is likely to
   take priority.

APICv:

-> The default apic MMIO base (0xfee00000) is covered by a dummy page which is
   allocated from qemu's process  using __x86_set_memory_region.
   
   This is done once in alloc_apic_access_page which is called on vcpu creation,
   (but only once when the memslot is not yet enabled)

-> to avoid pinning this page into qemu's memory, reference to it
   is dropped in alloc_apic_access_page.
   (see commit c24ae0dcd3e8695efa43e71704d1fc4bc7e29e9b)

-> kvm_arch_mmu_notifier_invalidate_range -> checks if we invalidate GPA 0xfee00000 
   and if so, raises KVM_REQ_APIC_PAGE_RELOAD request.

-> kvm_vcpu_reload_apic_access_page handles the KVM_REQ_APIC_PAGE_RELOAD request by calling
   kvm_x86_ops.set_apic_access_page_addr which is only implemented on VMX
   (vmx_set_apic_access_page_addr)

-> vmx_set_apic_access_page_addr does gfn_to_page on 0xfee00000 GPA,
   and if the result is valid, writes the physical address of this page to APIC_ACCESS_ADDR vmcs field.

   (This is a major difference from the AVIC - AVIC's avic_vapic_bar is *GPA*, while APIC_ACCESS_ADDR
   is host physical address which the hypervisor is supposed to map at APIC MMIO GPA using EPT)

   Note that if we have an error here, we might end with invalid APIC_ACCESS_ADDR field.

-> writes to the  HPA of that special page (which has GPA of 0xfee00000, and mapped via EPT) go to
   APICv or cause special VM exits: (EXIT_REASON_APIC_ACCESS, EXIT_REASON_APIC_WRITE)

   * EXIT_REASON_APIC_ACCESS (which is used for older limited 'flexpriotiy' mode which only emulates TPR practically) 
     actually emulates the instruction to know the written value,
     but we have a special case in vcpu_is_mmio_gpa which makes the emulation treat the access to the default
     apic base as MMIO.
   
   * EXIT_REASON_APIC_WRITE is a trap VMexit which comes with full APICv, and since it also has offset
     qualification and the value is already in the apic page, this info is just passed to kvm_lapic_reg_write


-> If APIC base is relocated, the APICv isn't aware of it, and the writes to new APIC base,
   (assuming that we have no memslots covering it) will go through standard APIC MMIO emulation,
   and *might* create a mess.

AVIC:

-> The default apic MMIO base (0xfee00000) 
   is also covered by a dummy page which is allocated from qemu's process using __x86_set_memory_region 
   in avic_update_access_page which is called also on vcpu creation (also only once),
   and from SVM's dynamic AVIC inhibition.

-> The reference to this page is not dropped thus there is no KVM_REQ_APIC_PAGE_RELOAD handler.
   I think we should do the same we do for APICv here?

-> avic_vapic_bar is GPA and thus contains 0xfee00000 but writes to MSR_IA32_APICBASE do update it
   (avic_update_vapic_bar which is called from MSR_IA32_APICBASE write in SVM code)

   thus if the guest relocates the APIC base to a writable memory page, actually AVIC would happen to work.
   (opposite from the stock xAPIC handlilng, which only works when apic base is in MMIO area.)

-> writes to the GPA in avic_vapic_bar are first checked in NPT (but HPA written there ignored),
   and then either go to AVIC or cause SVM_EXIT_AVIC_UNACCELERATED_ACCESS which has offset of the write
   in the exit_info_1
   (there is also SVM_EXIT_AVIC_INCOMPLETE_IPI which is called on some ICR writes)


As far as I know the only good reason to relocate APIC base is to access it from the real mode
which is not something that is done these days by modern BIOSes.

I vote to make it read only (#GP on MSR_IA32_APICBASE write when non default base is set and apic enabled) 
and remove all remains of the support for variable APIC base.
(we already have a warning when APIC base is set to non default value)


Best regards,
	Maxim Levitsky


