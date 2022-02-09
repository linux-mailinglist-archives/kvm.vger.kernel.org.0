Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ED14AF776
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbiBIRBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237713AbiBIRA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:00:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C634C05CB8C
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N3kTVV9G0T5QAqpQwcJtBoAGDXQI3g2qBn7ZlIGXs3M=;
        b=X+LNyT1f/MKmiLBNXAoft6/F+ocJcwFw5T6U/2+gMK485q0NIznzJ+5G5jximtKyjmyDOE
        3JAuJUWzKguFv4gIDce93egNbBiBZFJ3wHdxBJ0bh3MVi7EDxt24Mr4Vp5E6sLCWbpNsuZ
        +oLFm6ssTOW6WDMIi56wmasWopBAac4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-d-POX9QgMvCtU3wFX26-Cw-1; Wed, 09 Feb 2022 12:00:57 -0500
X-MC-Unique: d-POX9QgMvCtU3wFX26-Cw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2269818397D4;
        Wed,  9 Feb 2022 17:00:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 998C5708F1;
        Wed,  9 Feb 2022 17:00:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com
Subject: [PATCH 12/12] KVM: x86: do not unload MMU roots on all role changes
Date:   Wed,  9 Feb 2022 12:00:20 -0500
Message-Id: <20220209170020.1775368-13-pbonzini@redhat.com>
In-Reply-To: <20220209170020.1775368-1-pbonzini@redhat.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_mmu_reset_context is called on all role changes and right now it
calls kvm_mmu_unload.  With the legacy MMU this is a relatively cheap
operation; the previous PGDs remains in the hash table and is picked
up immediately on the next page fault.  With the TDP MMU, however, the
roots are thrown away for good and a full rebuild of the page tables is
necessary, which is many times more expensive.

Fortunately, throwing away the roots is not necessary except when
the manual says a TLB flush is required:

- changing CR0.PG from 1 to 0 (because it flushes the TLB according to
  the x86 architecture specification)

- changing CPUID (which changes the interpretation of page tables in
  ways not reflected by the role).

- changing CR4.SMEP from 0 to 1 (not doing so actually breaks access.c!)

Except for these cases, once the MMU has updated the CPU/MMU roles
and metadata it is enough to force-reload the current value of CR3.
KVM will look up the cached roots for an entry with the right role and
PGD, and only if the cache misses a new root will be created.

Measuring with vmexit.flat from kvm-unit-tests shows the following
improvement:

             TDP         legacy       shadow
   before    46754       5096         5150
   after     4879        4875         5006

which is for very small page tables.  The impact is however much larger
when running as an L1 hypervisor, because the new page tables cause
extra work for L0 to shadow them.

Reported-by: Brad Spengler <spender@grsecurity.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c |  7 ++++---
 arch/x86/kvm/x86.c     | 27 ++++++++++++++++++---------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 38b40ddcaad7..dbd4e98ba426 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5020,8 +5020,8 @@ EXPORT_SYMBOL_GPL(kvm_init_mmu);
 void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * Invalidate all MMU roles to force them to reinitialize as CPUID
-	 * information is factored into reserved bit calculations.
+	 * Invalidate all MMU roles and roots to force them to reinitialize,
+	 * as CPUID information is factored into reserved bit calculations.
 	 *
 	 * Correctly handling multiple vCPU models with respect to paging and
 	 * physical address properties) in a single VM would require tracking
@@ -5034,6 +5034,7 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
 	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
+	kvm_mmu_unload(vcpu);
 	kvm_mmu_reset_context(vcpu);
 
 	/*
@@ -5045,8 +5046,8 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_unload(vcpu);
 	kvm_init_mmu(vcpu);
+	kvm_mmu_new_pgd(vcpu, vcpu->arch.cr3);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d3646535cc5..97c4f5fc291f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -873,8 +873,12 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 		kvm_async_pf_hash_reset(vcpu);
 	}
 
-	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
+	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS) {
+		/* Flush the TLB if CR0 is changed 1 -> 0.  */
+		if ((old_cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PG))
+			kvm_mmu_unload(vcpu);
 		kvm_mmu_reset_context(vcpu);
+	}
 
 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
 	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
@@ -1067,15 +1071,18 @@ void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned lon
 	 * free them all.  KVM_REQ_MMU_RELOAD is fit for the both cases; it
 	 * is slow, but changing CR4.PCIDE is a rare case.
 	 *
-	 * If CR4.PGE is changed, the guest TLB must be flushed.
+	 * Setting SMEP also needs to flush the TLB, in addition to resetting
+	 * the MMU.
 	 *
-	 * Note: resetting MMU is a superset of KVM_REQ_MMU_RELOAD and
-	 * KVM_REQ_MMU_RELOAD is a superset of KVM_REQ_TLB_FLUSH_GUEST, hence
-	 * the usage of "else if".
+	 * If CR4.PGE is changed, the guest TLB must be flushed.  Because
+	 * the shadow MMU ignores global pages, this bit is not part of
+	 * KVM_MMU_CR4_ROLE_BITS.
 	 */
-	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
+	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS) {
 		kvm_mmu_reset_context(vcpu);
-	else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
+		if ((cr4 & X86_CR4_SMEP) && !(old_cr4 & X86_CR4_SMEP))
+			kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+	} else if ((cr4 ^ old_cr4) & X86_CR4_PCIDE)
 		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 	else if ((cr4 ^ old_cr4) & X86_CR4_PGE)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
@@ -11329,8 +11336,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 * paging related bits are ignored if paging is disabled, i.e. CR0.WP,
 	 * CR4, and EFER changes are all irrelevant if CR0.PG was '0'.
 	 */
-	if (old_cr0 & X86_CR0_PG)
-		kvm_mmu_reset_context(vcpu);
+	if (old_cr0 & X86_CR0_PG) {
+		kvm_mmu_unload(vcpu);
+		kvm_init_mmu(vcpu);
+	}
 
 	/*
 	 * Intel's SDM states that all TLB entries are flushed on INIT.  AMD's
-- 
2.31.1

