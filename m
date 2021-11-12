Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE3744E655
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 13:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhKLMas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 07:30:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231147AbhKLMar (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 07:30:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636720076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q4uFPAoO5AWHfo+LRFAFkm6iDam82E+wbNxuA8hZJbk=;
        b=UZKlQzAUITOqMmQN57aHwu41yXYUYH2R/02Mx/GEKTG8QtzJIvBTDRmLY+BO2GM5bnGfem
        P6xwE7vBlKza12rSHQEVAhbPlDt858cirOFholDw79LyCd2QS88WpGwEpxTmYbn6EALXHl
        Tu3v1D/x7/YSewpUyoHvxJ5KcYdCydA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-5uPnxEAHMW--1tAJQZ65tA-1; Fri, 12 Nov 2021 07:27:53 -0500
X-MC-Unique: 5uPnxEAHMW--1tAJQZ65tA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEA7284BA0B;
        Fri, 12 Nov 2021 12:27:44 +0000 (UTC)
Received: from [10.39.193.118] (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 090E21055005;
        Fri, 12 Nov 2021 12:27:41 +0000 (UTC)
Message-ID: <4c37db19-14ed-46b8-eabe-0381ba879e5c@redhat.com>
Date:   Fri, 12 Nov 2021 13:27:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] KVM: x86: Fix recording of guest steal time /
 preempted status
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, karahmed@amazon.com
References: <5d4002373c3ae614cb87b72ba5b7cdc161a0cd46.camel@infradead.org>
 <4369bbef7f0c2b239da419c917f9a9f2ca6a76f1.camel@infradead.org>
 <624bc910-1bec-e6dd-b09a-f86dc6cdbef0@redhat.com>
 <0372987a52b5f43963721b517664830e7e6f1818.camel@infradead.org>
 <1f326c33-3acf-911a-d1ef-c72f0a570761@redhat.com>
 <3645b9b889dac6438394194bb5586a46b68d581f.camel@infradead.org>
 <309f61f7-72fd-06a2-84b4-97dfc3fab587@redhat.com>
 <96cef64bf7927b6a0af2173b0521032f620551e4.camel@infradead.org>
 <40d7d808-dce6-a541-18dc-b0c7f4d6586c@redhat.com>
 <2b400dbb16818da49fb599b9182788ff9896dcda.camel@infradead.org>
 <32b00203-e093-8ffc-a75b-27557b5ee6b1@redhat.com>
 <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <28435688bab2dc1e272acc02ce92ba9a7589074f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/21 12:29, David Woodhouse wrote:
> We *could* use the rwlock thing for steal time reporting, but I still
> don't really think it's worth doing so. Again, if it was truly going to
> be a generic mechanism that would solve lots of other problems, I'd be
> up for it. But if steal time would be the *only* other user of a
> generic version of the rwlock thing, that just seems like
> overengineering. I'm still mostly inclined to stand by my original
> observation that it has a perfectly serviceable HVA that it can use
> instead.

Well yeah, I'd have to see the code to decide.  But maybe this is where
we disagree, what I want from generic KVM is a nice and easy-to-use API.
I only care to a certain extent how messy it is inside, because a nice
generic API means not reinventing the wheel across architectures.

That said, I think that your patch is much more complicated than it
should be, because it hooks in the wrong place.  There are two cases:

1) for kmap/kunmap, the invalidate_range() notifier is the right place
to remove any references taken after invalidate_range_start().  For the
APIC access page it needs a kvm_make_all_cpus_request, but for the
shinfo page it can be a simple back-to-back write_lock/write_unlock
(a super-poor-man RCU, if you wish).  And it can be extended to a
per-cache rwlock.

2) for memremap/memunmap, all you really care about is reacting to
changes in the memslots, so the MMU notifier integration has nothing
to do.  You still need to call the same hook as
kvm_mmu_notifier_invalidate_range() when memslots change, so that
the update is done outside atomic context.

So as far as short-term uses of the cache are concerned, all it
takes (if I'm right...) is a list_for_each_entry in
kvm_mmu_notifier_invalidate_range, visiting the list of
gfn-to-pfn caches and lock-unlock each cache's rwlock.  Plus
a way to inform the code of memslot changes before any atomic
code tries to use an invalid cache.

> It looks like they want their own way of handling it; if the GPA being
> invalidated matches posted_intr_desc_addr or virtual_apic_page_addr
> then the MMU notifier just needs to call kvm_make_all_cpus_request()
> with some suitable checking/WARN magic around the "we will never need
> to sleep when we shouldn't" assertion that you made above.

I was thinking of an extra flag to decide whether (in addition
to the write_lock/write_unlock) the MMU notifier also needs to do
the kvm_make_all_cpus_request:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b213ca966d41..f134db24b973 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -309,8 +309,8 @@ static void free_nested(struct kvm_vcpu *vcpu)
  		kvm_release_page_clean(vmx->nested.apic_access_page);
  		vmx->nested.apic_access_page = NULL;
  	}
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	vmx->nested.virtual_apic_map.guest_uses_pa = false;
+	vmx->nested.pi_desc_map.guest_uses_pa = false;
  	vmx->nested.pi_desc = NULL;
  
  	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
@@ -3183,6 +3184,10 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
  			 */
  			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, INVALID_GPA);
  		}
+		// on invalidation, this causes kvm_make_all_cpus_request
+		// and also dirties the page
+		map->guest_uses_pa = true;
+		kvm_vcpu_unmap(vcpu, map);
  	}
  
  	if (nested_cpu_has_posted_intr(vmcs12)) {
@@ -3204,6 +3207,8 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
  			vmx->nested.pi_desc = NULL;
  			pin_controls_clearbit(vmx, PIN_BASED_POSTED_INTR);
  		}
+		map->guest_uses_pa = true;
+		kvm_vcpu_unmap(vcpu, map);
  	}
  	if (nested_vmx_prepare_msr_bitmap(vcpu, vmcs12))
  		exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
@@ -4559,8 +4564,8 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
  		kvm_release_page_clean(vmx->nested.apic_access_page);
  		vmx->nested.apic_access_page = NULL;
  	}
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	vmx->nested.virtual_apic_map.guest_uses_pa = false;
+	vmx->nested.pi_desc_map.guest_uses_pa = false;
  	vmx->nested.pi_desc = NULL;
  
  	if (vmx->nested.reload_vmcs01_apic_access_page) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3b09ac93c86e..342f12321df7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6185,6 +6185,8 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
  
  	/* Defer reload until vmcs01 is the current VMCS. */
  	if (is_guest_mode(vcpu)) {
+		// TODO...
+		nested_vmx_update_vmcs02_phys_addrs(vcpu);
  		to_vmx(vcpu)->nested.reload_vmcs01_apic_access_page = true;
  		return;
  	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91f723f37b22..6d0b7d2f1465 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9670,9 +9670,6 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
  
  void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
  {
-	if (!lapic_in_kernel(vcpu))
-		return;
-
  	if (!kvm_x86_ops.set_apic_access_page_addr)
  		return;
  
With this infrastructure the APIC access page can be changed to a
gfn_to_pfn cache along the same lines (and whose guest_uses_pa is
always true).

Paolo

