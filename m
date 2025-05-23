Return-Path: <kvm+bounces-47491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E1EBAC1962
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D70C93A81C6
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932BB2BF3F5;
	Fri, 23 May 2025 01:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ii/K0F48"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA742296708
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962081; cv=none; b=BEYVxm/tvG649tBDXafSAsC4mIXItuyDLx/Ze1NeGI4l2NQRT0+1IriLzEJbnw9C+DTTIrClJWVoNaXQnxyG3i5csvH6FCMeV9DydVuTFAICVOtPG24dCxqLOFH2mpoJMJ4T4AFFBPtkvpf/ZBVz2RapFOTqW9TBFa/mFNg4OLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962081; c=relaxed/simple;
	bh=gFtnllkdHoK++kmV2uIN5igfGRjKb467ITbvyuZHPpg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=isTPwqjgf3NgUD6d1pdhOU/K/++DryOnTcaGDoUz2u61VqrE/RPByZSjIp/BGOGaiSBFZkThhRjKqLhNniLkMWIv2c7YIwlY43L2jtwpM++V+yFZt26+XrM5W6lYkpe/aya+ZQzezOrlR5WL1uJu8VZ1vWBctgf62Mn82OFONv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ii/K0F48; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e896e116fso5606680a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962077; x=1748566877; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hpBhApwrSh8aZyMZyjubfokkuVPDDm+wIxTVx+y5WkM=;
        b=ii/K0F48V+DnpMyf4bwJKMVHk0QZGDndFtrC3mPrOOikaadQ6pJduPSSPjpb0sBcD1
         +i4zYNljViYlrvnqnsMptFvTYayfzSiI6V+NlnRJbp/j1qlt8lE66TccjilGb0BBBTgt
         kNUNKar8JvKKhClGC3ndcYdry6621cPHU/thIFhowLACGxEZNeHm9BBTonL27mctm1CS
         IFqJP7Zor3LW5NrHhqzAuPqbfsvGnroXPh3K8VzcPALfss74in7cHbsrvvk7ySyIVWuq
         19DVKw6Ua5Ohp4cb5mfNTVhGYR39zTTc6RgHp+VT4Sn7+j38/bG3x183ouHiGbpVUiCA
         20ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962077; x=1748566877;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hpBhApwrSh8aZyMZyjubfokkuVPDDm+wIxTVx+y5WkM=;
        b=DeaiubWlXnF9XD+pVYAbb5DMQ6ZD86t8ndsGaPAkTbLZ4WK3AUACOY36ESYcbdxPjk
         FOpC1FZkoX1UXnmz/EifmXCwjpKMSPl3dMkEzlOr60uA+hzmliFbmeaCnuQmjPFg8ZWm
         pP1iAGTCg4eo2zqheTHG0GC0Fe6n0K9/qKdMhfhZKFy3aP4UjIxWwf9BkcDlq3fbO4QC
         nRCMD7D9r/b281bZ4FWKW6OygEw77UzGb6hb5UEc03Zu3hyzKKA/yJkQKVPS2ZZhxWIf
         Ga7DTIX6PkWQR7PrjSD+9pdnkN6m4P0G3UPYwuaYWkB+BA3+p9WenOS5DuWBN+XriDXj
         5+/A==
X-Gm-Message-State: AOJu0YzwTwjpqoIMD3ePsWlHoi53aQ3sXhNj0pzhC4HwXkhlDtv3VfMQ
	K8S/yRAgNtbFt9IcdCum8Bc3mbaA58OgCqZETFadQ0oHu+MX6rOYr1x998SzKP9hqY9g4Qtl63Y
	elysEqQ==
X-Google-Smtp-Source: AGHT+IGTYhCOjxbmKRXOrjbAavunsh63uzQMspWrxbHwEJtJhbbYao5aLSwUJ5OJG/DqIAodT2HfVFXoKXw=
X-Received: from pjb7.prod.google.com ([2002:a17:90b:2f07:b0:2ff:6132:8710])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4acf:b0:2ee:aa28:79aa
 with SMTP id 98e67ed59e1d1-30e830c772dmr35674777a91.6.1747962077355; Thu, 22
 May 2025 18:01:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:45 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-41-seanjc@google.com>
Subject: [PATCH v2 40/59] iommu/amd: KVM: SVM: Set pCPU info in IRTE when
 setting vCPU affinity
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that setting vCPU affinity is guarded with ir_list_lock, i.e. now that
avic_physical_id_entry can be safely accessed, set the pCPU info
straight-away when setting vCPU affinity.  Putting the IRTE into posted
mode, and then immediately updating the IRTE a second time if the target
vCPU is running is wasteful and confusing.

This also fixes a flaw where a posted IRQ that arrives between putting
the IRTE into guest_mode and setting the correct destination could cause
the IOMMU to ring the doorbell on the wrong pCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/irq_remapping.h |  1 +
 arch/x86/kvm/svm/avic.c              | 26 ++++++++++++++------------
 drivers/iommu/amd/iommu.c            |  6 ++++--
 include/linux/amd-iommu.h            |  4 ++--
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 2dbc9cb61c2f..4c75a17632f6 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -35,6 +35,7 @@ struct amd_iommu_pi_data {
 	u64 vapic_addr;		/* Physical address of the vCPU's vAPIC. */
 	u32 ga_tag;
 	u32 vector;		/* Guest vector of the interrupt */
+	int cpu;
 	bool is_guest_mode;
 	void *ir_data;
 };
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index c79648d96752..16557328aa58 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -726,6 +726,7 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
+	int apic_id = kvm_cpu_get_apicid(vcpu->cpu);
 	int ret = 0;
 	unsigned long flags;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -745,7 +746,7 @@ static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 
 	list_for_each_entry(irqfd, &svm->ir_list, vcpu_list) {
 		if (activate)
-			ret = amd_iommu_activate_guest_mode(irqfd->irq_bypass_data);
+			ret = amd_iommu_activate_guest_mode(irqfd->irq_bypass_data, apic_id);
 		else
 			ret = amd_iommu_deactivate_guest_mode(irqfd->irq_bypass_data);
 		if (ret)
@@ -809,6 +810,18 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 */
 		guard(spinlock_irqsave)(&svm->ir_list_lock);
 
+		/*
+		 * Update the target pCPU for IOMMU doorbells if the vCPU is
+		 * running.  If the vCPU is NOT running, i.e. is blocking or
+		 * scheduled out, KVM will update the pCPU info when the vCPU
+		 * is awakened and/or scheduled in.  See also avic_vcpu_load().
+		 */
+		entry = svm->avic_physical_id_entry;
+		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
+			pi_data.cpu = entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
+		else
+			pi_data.cpu = -1;
+
 		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
 		if (ret)
 			return ret;
@@ -823,17 +836,6 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			return -EIO;
 		}
 
-		/*
-		 * Update the target pCPU for IOMMU doorbells if the vCPU is
-		 * running.  If the vCPU is NOT running, i.e. is blocking or
-		 * scheduled out, KVM will update the pCPU info when the vCPU
-		 * is awakened and/or scheduled in.  See also avic_vcpu_load().
-		 */
-		entry = svm->avic_physical_id_entry;
-		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
-			amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
-					    pi_data.ir_data);
-
 		irqfd->irq_bypass_data = pi_data.ir_data;
 		list_add(&irqfd->vcpu_list, &svm->ir_list);
 		return 0;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 15718b7b8bd4..718bd9604f71 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3850,7 +3850,7 @@ int amd_iommu_update_ga(int cpu, void *data)
 }
 EXPORT_SYMBOL(amd_iommu_update_ga);
 
-int amd_iommu_activate_guest_mode(void *data)
+int amd_iommu_activate_guest_mode(void *data, int cpu)
 {
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
@@ -3871,6 +3871,8 @@ int amd_iommu_activate_guest_mode(void *data)
 	entry->hi.fields.vector            = ir_data->ga_vector;
 	entry->lo.fields_vapic.ga_tag      = ir_data->ga_tag;
 
+	__amd_iommu_update_ga(entry, cpu);
+
 	return modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
 			      ir_data->irq_2_irte.index, entry);
 }
@@ -3937,7 +3939,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
 		ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
 		ir_data->ga_vector = pi_data->vector;
 		ir_data->ga_tag = pi_data->ga_tag;
-		ret = amd_iommu_activate_guest_mode(ir_data);
+		ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu);
 	} else {
 		ret = amd_iommu_deactivate_guest_mode(ir_data);
 	}
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index fe0e16ffe0e5..c9f2df0c4596 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -32,7 +32,7 @@ extern int amd_iommu_register_ga_log_notifier(int (*notifier)(u32));
 
 extern int amd_iommu_update_ga(int cpu, void *data);
 
-extern int amd_iommu_activate_guest_mode(void *data);
+extern int amd_iommu_activate_guest_mode(void *data, int cpu);
 extern int amd_iommu_deactivate_guest_mode(void *data);
 
 #else /* defined(CONFIG_AMD_IOMMU) && defined(CONFIG_IRQ_REMAP) */
@@ -48,7 +48,7 @@ static inline int amd_iommu_update_ga(int cpu, void *data)
 	return 0;
 }
 
-static inline int amd_iommu_activate_guest_mode(void *data)
+static inline int amd_iommu_activate_guest_mode(void *data, int cpu)
 {
 	return 0;
 }
-- 
2.49.0.1151.ga128411c76-goog


