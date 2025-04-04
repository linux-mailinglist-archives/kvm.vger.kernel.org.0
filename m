Return-Path: <kvm+bounces-42752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 640FCA7C427
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 018FE1B6162C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E6D254861;
	Fri,  4 Apr 2025 19:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EVHorfie"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D04253F16
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795703; cv=none; b=QsUW7Qy7YJWUhrgE6MKuJgf5suWS7TWwehS0Bai2lhbDc9ec2NYvrJt29QqBdt2GfBRup8Wyz+Ja8iRTjhY7ZVMhq1+0s4xSrg8X3fcBihDyiJ+LZb8XE4pALGG3h2wV1pVxH0KGjIkkRSAO1Ca9DvwXGB8LzWIoQtbg/wutCEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795703; c=relaxed/simple;
	bh=p4lMpZzNOfopLHtzNwpOCYJrrKVo7rhURos1txCwlVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uo82yxeqSbOyOxhT52p5ayxmtAzwBaPWNlgC7fkTDmCTQh4AHkAuCa5rxA7Sn0ahfgXkVLOol2l7PD+5NHYuH3lXZVC+Or1sEXI9bWPVsNpUCSIWs7hnKApxMysrUhq7gdnopJ6PI1Lo365XPLjWqukF7uk85BoJ9hMBCMGIUEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EVHorfie; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af5310c1ac1so1592112a12.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795701; x=1744400501; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QUrU9L/DFULymetyem/EQ8okUR5K5rpIbjia6VAlcZA=;
        b=EVHorfie+lW0ARLOWD8X8MaWeXkHbsKCUv+wMdki7Z9lM53/OIo1/3cIHGiXa2+Jrp
         oRH/QcuptfOCpim7i8DDJSf0m5hGypys6MhGBeEfGeIWuNaJ1S8BT11Ls6c9ZyUzA8ur
         eYkj2e64owHRLLROPUwoyzg8KCNcIxHjz+5lvjV1i9tVDW/dQMzTnI9esD5DlJzq3S9v
         sSxPmPp6gUuAnAFJXhhxg5zNrk9vt5oWttmnRhkfg1OOwnCkRLJXgH6HfiYxbznX6iAd
         s1mlrEkWPVYFdQTftlouKTswiqp3LXhZr69JiDkZATlxCRh4zItzzIQEUC+LA3p8udrU
         P2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795701; x=1744400501;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QUrU9L/DFULymetyem/EQ8okUR5K5rpIbjia6VAlcZA=;
        b=HksvfSGVnbuxy6DGUFXn4hfOKxli6pfYJAZNsw5rTvUG3BkgsBsyb4eKjPiTNkqqKc
         mvbZFRt+dhLfxDikvwyH9PJaHTeQimeEWGLfdw9aDAxLpRozXsSeBs0YVvZxV9MipNl/
         frGZJHr239rmYDXeqiZ/a3H4gDlao9lWydU9xq4xUWPH3sOFU/f39aTr4Bnsg/Lki7DW
         3IdjvJd2RQa9IiwY3/bGuA6bhSfd5+Xk5OWOAuYbyJykYC0xv0f7K/aL+gngFF+PNHz9
         MW+k5+86K1HXLKdowiCvA05tVL2tqM8094nZp2ytBjp8cKNWhfUBe/liD7UOeAaWfH1a
         K2+g==
X-Gm-Message-State: AOJu0YwvG3jAkHgV+wfF8CCVzitW8GdjdSWEY9wyWSnrLtHixHADP9Wr
	/TqCwm8Tfxpr6K1OPy/en9CVEtzbjkoIc7I6yfWRtMDH+ERlAn0EbIQZ9xFN8aM60NPDcMvB72q
	GVw==
X-Google-Smtp-Source: AGHT+IH5SF1xKDOV0AlfkEHS8vEc8UnE03fOtnqwKFwUtSTDcFy4r+xX9b4aP/SLO3FeSmcsDhP1YeFdzC0=
X-Received: from pfoi21.prod.google.com ([2002:aa7:87d5:0:b0:732:6c92:3f75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:ce43:b0:1f3:41d5:6608
 with SMTP id adf61e73a8af0-2010472d8b1mr6203969637.26.1743795700728; Fri, 04
 Apr 2025 12:41:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:21 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-67-seanjc@google.com>
Subject: [PATCH 66/67] *** DO NOT MERGE *** iommu/amd: Hack to fake IRQ
 posting support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Hack the IOMMU half of AMD device posted IRQ support to allow testing a
decent chunk of the related code on systems with AVIC capable CPUs, but no
IOMMU virtual APIC support.  E.g. some Milan CPUs allow enabling AVIC even
though it's not advertised as being supported, but the IOMMU unfortunately
doesn't allow the same shenanigans.

Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 76 ++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/svm.c    |  2 ++
 drivers/iommu/amd/init.c  |  8 +++--
 drivers/iommu/amd/iommu.c | 50 +++++++++++++++++++++++++-
 4 files changed, 128 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0d2a17a74be6..425674e1a04c 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -28,6 +28,8 @@
 #include "irq.h"
 #include "svm.h"
 
+#include "../../../drivers/iommu/amd/amd_iommu_types.h"
+
 /*
  * Encode the arbitrary VM ID and the vCPU's _index_ into the GATag so that
  * KVM can retrieve the correct vCPU from a GALog entry if an interrupt can't
@@ -141,11 +143,7 @@ static void avic_deactivate_vmcb(struct vcpu_svm *svm)
 	svm_set_x2apic_msr_interception(svm, true);
 }
 
-/* Note:
- * This function is called from IOMMU driver to notify
- * SVM to schedule in a particular vCPU of a particular VM.
- */
-int avic_ga_log_notifier(u32 ga_tag)
+static struct kvm_vcpu *avic_ga_log_get_vcpu(u32 ga_tag)
 {
 	unsigned long flags;
 	struct kvm_svm *kvm_svm;
@@ -165,6 +163,17 @@ int avic_ga_log_notifier(u32 ga_tag)
 	}
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
 
+	return vcpu;
+}
+
+/* Note:
+ * This function is called from IOMMU driver to notify
+ * SVM to schedule in a particular vCPU of a particular VM.
+ */
+int avic_ga_log_notifier(u32 ga_tag)
+{
+	struct kvm_vcpu *vcpu = avic_ga_log_get_vcpu(ga_tag);
+
 	/* Note:
 	 * At this point, the IOMMU should have already set the pending
 	 * bit in the vAPIC backing page. So, we just need to schedule
@@ -750,6 +759,8 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
 	spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
 }
 
+extern struct amd_iommu_pi_data amd_iommu_fake_irte;
+
 int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			unsigned int host_irq, uint32_t guest_irq,
 			struct kvm_kernel_irq_routing_entry *new,
@@ -1055,6 +1066,58 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	avic_vcpu_load(vcpu, vcpu->cpu);
 }
 
+static void avic_pi_handler(void)
+{
+	struct amd_iommu_pi_data pi;
+	struct kvm_vcpu *vcpu;
+
+	memcpy(&pi, &amd_iommu_fake_irte, sizeof(pi));
+
+	if (!pi.is_guest_mode) {
+		pr_warn("IRQ %u arrived with !is_guest_mode\n", pi.vector);
+		return;
+	}
+
+	vcpu = avic_ga_log_get_vcpu(pi.ga_tag);
+	if (!vcpu) {
+		pr_warn("No vCPU for IRQ %u\n", pi.vector);
+		return;
+	}
+	WARN_ON_ONCE(pi.vapic_addr << 12 != avic_get_backing_page_address(to_svm(vcpu)));
+
+	/*
+	 * When updating a vCPU's IRTE, the fake posted IRQ can race with the
+	 * IRTE update.  Take ir_list_lock so that the IRQ can be processed
+	 * atomically.  In real hardware, the IOMMU will complete IRQ delivery
+	 * before accepting the new IRTE.
+	 */
+	guard(spinlock_irqsave)(&to_svm(vcpu)->ir_list_lock);
+
+	if (amd_iommu_fake_irte.ga_tag != pi.ga_tag) {
+		WARN_ON_ONCE(amd_iommu_fake_irte.is_guest_mode);
+		return;
+	}
+
+	memcpy(&pi, &amd_iommu_fake_irte, sizeof(pi));
+
+#if 0
+	pr_warn("In PI handler, guest = %u, cpu = %d, tag = %x, intr = %u, vector = %u\n",
+		pi.is_guest_mode, pi.cpu,
+		pi.ga_tag, pi.ga_log_intr, pi.vector);
+#endif
+
+	if (!pi.is_guest_mode)
+		return;
+
+	kvm_lapic_set_irr(pi.vector, vcpu->arch.apic);
+	smp_mb__after_atomic();
+
+	if (pi.cpu >= 0)
+		avic_ring_doorbell(vcpu);
+	else if (pi.ga_log_intr)
+		avic_ga_log_notifier(pi.ga_tag);
+}
+
 /*
  * Note:
  * - The module param avic enable both xAPIC and x2APIC mode.
@@ -1107,5 +1170,8 @@ bool avic_hardware_setup(void)
 
 	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 
+	pr_warn("Register AVIC PI wakeup handler\n");
+	kvm_set_posted_intr_wakeup_handler(avic_pi_handler);
+
 	return true;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 71b52ad13577..b8adeb87e800 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1122,6 +1122,8 @@ static void svm_hardware_unsetup(void)
 {
 	int cpu;
 
+	kvm_set_posted_intr_wakeup_handler(NULL);
+
 	sev_hardware_unsetup();
 
 	for_each_possible_cpu(cpu)
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index cb536d372b12..28cc8552ca95 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2863,8 +2863,12 @@ static void enable_iommus_vapic(void)
 			return;
 	}
 
-	if (AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) &&
-	    !check_feature(FEATURE_GAM_VAPIC)) {
+	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir))
+		return;
+
+	if (!check_feature(FEATURE_GAM_VAPIC)) {
+		pr_warn("IOMMU lacks GAM_VAPIC, fudging IRQ posting\n");
+		amd_iommu_irq_ops.capability |= (1 << IRQ_POSTING_CAP);
 		amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY_GA;
 		return;
 	}
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 27b03e718980..f2bd262330fa 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3775,6 +3775,15 @@ static const struct irq_domain_ops amd_ir_domain_ops = {
 	.deactivate = irq_remapping_deactivate,
 };
 
+struct amd_iommu_pi_data amd_iommu_fake_irte;
+EXPORT_SYMBOL_GPL(amd_iommu_fake_irte);
+
+static bool amd_iommu_fudge_pi(void)
+{
+	return irq_remapping_cap(IRQ_POSTING_CAP) &&
+	       !AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir);
+}
+
 static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu,
 				  bool ga_log_intr)
 {
@@ -3796,6 +3805,12 @@ int amd_iommu_update_ga(void *data, int cpu, bool ga_log_intr)
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 
+	if (amd_iommu_fudge_pi()) {
+		amd_iommu_fake_irte.cpu = cpu;
+		amd_iommu_fake_irte.ga_log_intr = ga_log_intr;
+		return 0;
+	}
+
 	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
 		return -EINVAL;
 
@@ -3818,6 +3833,26 @@ int amd_iommu_activate_guest_mode(void *data, int cpu, bool ga_log_intr)
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 	u64 valid;
 
+	if (amd_iommu_fudge_pi()) {
+		if (WARN_ON_ONCE(!entry->lo.fields_remap.valid))
+			return -EINVAL;
+
+		if (WARN_ON_ONCE(entry->lo.fields_remap.int_type != APIC_DELIVERY_MODE_FIXED))
+			return -EINVAL;
+
+		amd_iommu_fake_irte.cpu = cpu;
+		amd_iommu_fake_irte.vapic_addr = ir_data->ga_root_ptr;
+		amd_iommu_fake_irte.vector = ir_data->ga_vector;
+		amd_iommu_fake_irte.ga_tag = ir_data->ga_tag;
+		amd_iommu_fake_irte.ga_log_intr = ga_log_intr;
+		amd_iommu_fake_irte.is_guest_mode = true;
+
+		entry->hi.fields.vector = POSTED_INTR_WAKEUP_VECTOR;
+
+		return modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
+				      ir_data->irq_2_irte.index, entry);
+	}
+
 	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
 		return -EINVAL;
 
@@ -3849,12 +3884,18 @@ int amd_iommu_deactivate_guest_mode(void *data)
 	struct irq_cfg *cfg = ir_data->cfg;
 	u64 valid;
 
+	if (amd_iommu_fudge_pi() && entry) {
+		memset(&amd_iommu_fake_irte, 0, sizeof(amd_iommu_fake_irte));
+		goto fudge;
+	}
+
 	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
 		return -EINVAL;
 
 	if (!entry || !entry->lo.fields_vapic.guest_mode)
 		return 0;
 
+fudge:
 	valid = entry->lo.fields_remap.valid;
 
 	entry->lo.val = 0;
@@ -3891,12 +3932,19 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 	 * This device has never been set up for guest mode.
 	 * we should not modify the IRTE
 	 */
-	if (!dev_data || !dev_data->use_vapic)
+	if (!dev_data)
+		return -EINVAL;
+
+	if (amd_iommu_fudge_pi())
+		goto fudge;
+
+	if (!dev_data->use_vapic)
 		return -EINVAL;
 
 	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
 		return -EINVAL;
 
+fudge:
 	ir_data->cfg = irqd_cfg(data);
 
 	if (pi_data) {
-- 
2.49.0.504.g3bcea36a83-goog


