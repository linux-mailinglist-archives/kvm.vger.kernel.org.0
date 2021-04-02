Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF89352D39
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbhDBP6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbhDBP6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:58:14 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B605C0613E6;
        Fri,  2 Apr 2021 08:58:12 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j7so5129950wrd.1;
        Fri, 02 Apr 2021 08:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MaSyGg1oHuc+9Qj2LHQY6MYXXkqSQVsHMqnRNs608sw=;
        b=JnZ5tR2/hJNfkr1EPsGsgrtnOHVEqbNzR/9jbCXsYxR0L5WLmDvUB/eEkhVOq7dowH
         tDQZ2zRlj4gxlUSoNBiR95mV+GVQw8ymeTWn1/vjykX9QaxebIhh9i0ok1UzlWCSCgUy
         xst8STbt7QAidNhaSuxyUzt6gNXM/ClRxR37TEMLVygXNGyt0szbt8uj7m19FHVCT6LE
         314a0xyCNZ8BM9CDNCgM58koGDZWdFkF+gj6UQ4Crkla1SfncUHl0MOaPVDGoaMeBMX8
         2vuVPgCklXFaGlwR0TXSb+En5uDRJ5BhtXPUqjBHpBZ0Esdc38cN7e594YXqUOz1GJyt
         6bNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=MaSyGg1oHuc+9Qj2LHQY6MYXXkqSQVsHMqnRNs608sw=;
        b=KbBSBMyReM1PpDd2NPhkPKijza/kja81fZFGieMfZlT1RkHn0dCxZwKIy2vfDJ1/6F
         gQMM4g7yirQYu5xyYDrcxsh27ouNFdDeFmGsVGwNx8zSemvlO0NfYKhaHbRx99righiA
         bGX5B3u94VVlHi33HMm3Fgu4k8dPpbH7cxDyWc4r1Lyafz/GtMoUkDAbVrMPBD/17rM2
         48M1ABxAWjguh1uvBoACh5ndQ8DurGC2p566jMS4SeYQX3pUdnWbkV5H2uR/SC708YpX
         qRSL0r6N0bPRKAR5XCKHR3DUf0nj+YST3mgA4rQWBpfvn2WZTR6nTIGVDY3gNMtyzCys
         1bAQ==
X-Gm-Message-State: AOAM5307W95epwESh+ul54m6aqneN0+942/c0JCv9PrUCvO2mgfOzAqO
        MpZ0c8TslPitIp7V5Zb6HSaD9esGoJY=
X-Google-Smtp-Source: ABdhPJwW6nGRjcX3n9h4Gsg4U0I/2WUvRcQYa+fuWfP47rwqpAzQb/V+Sb6u8Hu1Evkj5gDq0IttHA==
X-Received: by 2002:a5d:49ca:: with SMTP id t10mr15911027wrs.76.1617379091218;
        Fri, 02 Apr 2021 08:58:11 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w11sm2293625wmb.35.2021.04.02.08.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:58:10 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        seanjc@google.com, linux-mips@vger.kernel.org
Subject: [PATCH 2/4] KVM: MIPS: rework flush_shadow_* callbacks into one that prepares the flush
Date:   Fri,  2 Apr 2021 17:58:05 +0200
Message-Id: <20210402155807.49976-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402155807.49976-1-pbonzini@redhat.com>
References: <20210402155807.49976-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both trap-and-emulate and VZ have a single implementation that covers
both .flush_shadow_all and .flush_shadow_memslot, and both of them end
with a call to kvm_flush_remote_tlbs.

Unify the callbacks into one and extract the call to kvm_flush_remote_tlbs.
The next patches will pull it further out of the the architecture-specific
MMU notifier functions kvm_unmap_hva_range and kvm_set_spte_hva.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/mips/include/asm/kvm_host.h |  9 +--------
 arch/mips/kvm/mips.c             | 12 ++++++------
 arch/mips/kvm/mmu.c              |  9 ++++++---
 arch/mips/kvm/trap_emul.c        | 13 ++-----------
 arch/mips/kvm/vz.c               | 19 ++++---------------
 5 files changed, 19 insertions(+), 43 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index feaa77036b67..6c8c0ab53be2 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -815,14 +815,7 @@ struct kvm_mips_callbacks {
 	int (*vcpu_init)(struct kvm_vcpu *vcpu);
 	void (*vcpu_uninit)(struct kvm_vcpu *vcpu);
 	int (*vcpu_setup)(struct kvm_vcpu *vcpu);
-	void (*flush_shadow_all)(struct kvm *kvm);
-	/*
-	 * Must take care of flushing any cached GPA PTEs (e.g. guest entries in
-	 * VZ root TLB, or T&E GVA page tables and corresponding root TLB
-	 * mappings).
-	 */
-	void (*flush_shadow_memslot)(struct kvm *kvm,
-				     const struct kvm_memory_slot *slot);
+	void (*prepare_flush_shadow)(struct kvm *kvm);
 	gpa_t (*gva_to_gpa)(gva_t gva);
 	void (*queue_timer_int)(struct kvm_vcpu *vcpu);
 	void (*dequeue_timer_int)(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 7db8234a4407..867b8de0fc07 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -206,7 +206,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvm_mips_flush_gpa_pt(kvm, 0, ~0);
 
 	/* Let implementation do the rest */
-	kvm_mips_callbacks->flush_shadow_all(kvm);
+	kvm_mips_callbacks->prepare_flush_shadow(kvm);
+	kvm_flush_remote_tlbs(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -221,8 +222,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	/* Flush slot from GPA */
 	kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
 			      slot->base_gfn + slot->npages - 1);
-	/* Let implementation do the rest */
-	kvm_mips_callbacks->flush_shadow_memslot(kvm, slot);
+	kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -262,9 +262,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		/* Write protect GPA page table entries */
 		needs_flush = kvm_mips_mkclean_gpa_pt(kvm, new->base_gfn,
 					new->base_gfn + new->npages - 1);
-		/* Let implementation do the rest */
 		if (needs_flush)
-			kvm_mips_callbacks->flush_shadow_memslot(kvm, new);
+			kvm_arch_flush_remote_tlbs_memslot(kvm, new);
 		spin_unlock(&kvm->mmu_lock);
 	}
 }
@@ -1000,7 +999,8 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 					const struct kvm_memory_slot *memslot)
 {
 	/* Let implementation handle TLB/GVA invalidation */
-	kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
+	kvm_mips_callbacks->prepare_flush_shadow(kvm);
+	kvm_flush_remote_tlbs(kvm);
 }
 
 long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 3dabeda82458..7e055e5dfd3c 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -491,7 +491,8 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 {
 	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
 
-	kvm_mips_callbacks->flush_shadow_all(kvm);
+	kvm_mips_callbacks->prepare_flush_shadow(kvm);
+	kvm_flush_remote_tlbs(kvm);
 	return 0;
 }
 
@@ -532,8 +533,10 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	int ret;
 
 	ret = handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
-	if (ret)
-		kvm_mips_callbacks->flush_shadow_all(kvm);
+	if (ret) {
+		kvm_mips_callbacks->prepare_flush_shadow(kvm);
+		kvm_flush_remote_tlbs(kvm);
+	}
 	return 0;
 }
 
diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
index 0788c00d7e94..5f2df497599c 100644
--- a/arch/mips/kvm/trap_emul.c
+++ b/arch/mips/kvm/trap_emul.c
@@ -687,16 +687,8 @@ static int kvm_trap_emul_vcpu_setup(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static void kvm_trap_emul_flush_shadow_all(struct kvm *kvm)
+static void kvm_trap_emul_prepare_flush_shadow(struct kvm *kvm)
 {
-	/* Flush GVA page tables and invalidate GVA ASIDs on all VCPUs */
-	kvm_flush_remote_tlbs(kvm);
-}
-
-static void kvm_trap_emul_flush_shadow_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *slot)
-{
-	kvm_trap_emul_flush_shadow_all(kvm);
 }
 
 static u64 kvm_trap_emul_get_one_regs[] = {
@@ -1280,8 +1272,7 @@ static struct kvm_mips_callbacks kvm_trap_emul_callbacks = {
 	.vcpu_init = kvm_trap_emul_vcpu_init,
 	.vcpu_uninit = kvm_trap_emul_vcpu_uninit,
 	.vcpu_setup = kvm_trap_emul_vcpu_setup,
-	.flush_shadow_all = kvm_trap_emul_flush_shadow_all,
-	.flush_shadow_memslot = kvm_trap_emul_flush_shadow_memslot,
+	.prepare_flush_shadow = kvm_trap_emul_prepare_flush_shadow,
 	.gva_to_gpa = kvm_trap_emul_gva_to_gpa_cb,
 	.queue_timer_int = kvm_mips_queue_timer_int_cb,
 	.dequeue_timer_int = kvm_mips_dequeue_timer_int_cb,
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 2ffbe9264a31..2c75571dc4a2 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -3211,32 +3211,22 @@ static int kvm_vz_vcpu_setup(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static void kvm_vz_flush_shadow_all(struct kvm *kvm)
+static void kvm_vz_prepare_flush_shadow(struct kvm *kvm)
 {
-	if (cpu_has_guestid) {
-		/* Flush GuestID for each VCPU individually */
-		kvm_flush_remote_tlbs(kvm);
-	} else {
+	if (!cpu_has_guestid) {
 		/*
 		 * For each CPU there is a single GPA ASID used by all VCPUs in
 		 * the VM, so it doesn't make sense for the VCPUs to handle
 		 * invalidation of these ASIDs individually.
 		 *
 		 * Instead mark all CPUs as needing ASID invalidation in
-		 * asid_flush_mask, and just use kvm_flush_remote_tlbs(kvm) to
+		 * asid_flush_mask, and kvm_flush_remote_tlbs(kvm) will
 		 * kick any running VCPUs so they check asid_flush_mask.
 		 */
 		cpumask_setall(&kvm->arch.asid_flush_mask);
-		kvm_flush_remote_tlbs(kvm);
 	}
 }
 
-static void kvm_vz_flush_shadow_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *slot)
-{
-	kvm_vz_flush_shadow_all(kvm);
-}
-
 static void kvm_vz_vcpu_reenter(struct kvm_vcpu *vcpu)
 {
 	int cpu = smp_processor_id();
@@ -3292,8 +3282,7 @@ static struct kvm_mips_callbacks kvm_vz_callbacks = {
 	.vcpu_init = kvm_vz_vcpu_init,
 	.vcpu_uninit = kvm_vz_vcpu_uninit,
 	.vcpu_setup = kvm_vz_vcpu_setup,
-	.flush_shadow_all = kvm_vz_flush_shadow_all,
-	.flush_shadow_memslot = kvm_vz_flush_shadow_memslot,
+	.prepare_flush_shadow = kvm_vz_prepare_flush_shadow,
 	.gva_to_gpa = kvm_vz_gva_to_gpa_cb,
 	.queue_timer_int = kvm_vz_queue_timer_int_cb,
 	.dequeue_timer_int = kvm_vz_dequeue_timer_int_cb,
-- 
2.30.1


