Return-Path: <kvm+bounces-42730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BDA7A7C461
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6F961B6273A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC13B23718D;
	Fri,  4 Apr 2025 19:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="knO9S7xd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687EC23A986
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795664; cv=none; b=tKiA+XEMdys5v9oIx5fmkYDqIwRF4Kg9UOF4jMpTnWDgbkQq2+L5TJZ9qFMp1bCSybzKmfdWaox/A3bBwNJyXqL6XOc4JZTVwRSB6w5/O1akDtgbrRMgDnbuPgO6Q/fAfkwb0IeRPOaJt4E7CjIVVEzxMVYEhp2EVKVD2fK2OiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795664; c=relaxed/simple;
	bh=SdRm1GRIbm33d/nHibJXYjLPmG0T0NZRcamdnee5V5M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CVb3wTXZicGUyCzcePUskBEzgPN/nFC8TWtGQ1GsuJkbHgaVmw7Z91pvYCdg2hNT5ry9iI94IMhWuZJEs132MjAjeTrMnYJmki0ETK9YjtGEdDecOGV9QoNr0kT4398FDM/sgmhHnONdLR/sPfZRXXJ44jxzpNbOwsTmT64Hpho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=knO9S7xd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af5310c1ac1so1591817a12.2
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795663; x=1744400463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=h0hbazAE8dMJrPUHRRf7zZrCtHTbdiwGcNR7wF/0toU=;
        b=knO9S7xdlRKDfS59wDf7utU8YQSX72GO44xHN1ooyBKlpXzNGgwrAONSkQuRIT0mMi
         sqG7axwEAQiuQcDXHKTXsf7Qak6CM5aQLSpa3Y+pb8tPon0vx0dJ7bi7RyBkrrYr9PBv
         RmjuQKI53yMVhw3ige005ulk4rCw8Zgwf3QgLSRBOC0eTRhztYHHSPQjOZ9Gl6JIfIre
         euaRAzDRhdAKVaG/GXlV4hmYceoUM+NJtjgt/++FAHWKzwyO26+AwU4lLdigTQ/vtG+3
         YSnuUJXH2A64i5cvh1IHnvpeh2pbpl/AuAHsTCnXnX74c4+nNSZRYj1vVqm+HhYPL0Pq
         PB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795663; x=1744400463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h0hbazAE8dMJrPUHRRf7zZrCtHTbdiwGcNR7wF/0toU=;
        b=oVOD7aySQR8VBHPdNYsF4d83wD2DVxofRhguUx/OGLCnM98oFQi3wsNIJt3L2E0Wey
         jnLbb8wYHlePL1PYTkd80ggvAcYOxYwlEN4FXaNwzU2B22htMQ9hhDvSubijhBI+6UN+
         yMelyFTK3D/fcfPQGo9pBFlKfm+ZFuM9L/+inxeY/3ud9wIl3Btb85OVxCbitSBYP1nI
         a1I2AWXNC9SEfKKNVZOO7Pk8o9ca7XNZ2l//FatVLng8hjtgLfDmUujIHV8+KK6k4njT
         vAB8UqYVphejSHokwGS92UFp+EuBkEBrdGe7N7wSKwxwWQCWdK4Re7lz081W3H1HB+HB
         TXIQ==
X-Gm-Message-State: AOJu0YyQtOT+0kAATdEP8dXaGUUmtordgfY/fBlvslskiidZE6CHZybP
	HeTPwSBBTYGFUUkA7wiiexoEInB5Css+3v9ULb/o6BdUJhwjVt+fXiUA8Z+AROFCDTdWwRuTG8i
	xkg==
X-Google-Smtp-Source: AGHT+IGWtLpM72ibr6u8G3+P4C5G/mdxZQlLn+wbJokB4hzvBLYZDfOpzpP/P7/kdQcTFYiTDJkPje5dvF0=
X-Received: from pfbdr9.prod.google.com ([2002:a05:6a00:4a89:b0:737:6e43:8e34])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6002:b0:1f5:7c6f:6c8a
 with SMTP id adf61e73a8af0-20104751ab1mr7764832637.35.1743795662762; Fri, 04
 Apr 2025 12:41:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:59 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-45-seanjc@google.com>
Subject: [PATCH 44/67] iommu/amd: KVM: SVM: Infer IsRun from validity of pCPU destination
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Infer whether or not a vCPU should be marked running from the validity of
the pCPU on which it is running.  amd_iommu_update_ga() already skips the
IRTE update if the pCPU is invalid, i.e. passing %true for is_run with an
invalid pCPU would be a blatant and egregrious KVM bug.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c   | 11 +++++------
 drivers/iommu/amd/iommu.c |  6 ++++--
 include/linux/amd-iommu.h |  6 ++----
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 4dbbb5a6cacc..3fcec297e3e3 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -842,7 +842,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		entry = svm->avic_physical_id_entry;
 		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
 			amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
-					    true, pi_data.ir_data);
+					    pi_data.ir_data);
 
 		irqfd->irq_bypass_data = pi_data.ir_data;
 		list_add(&irqfd->vcpu_list, &svm->ir_list);
@@ -851,8 +851,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 	return irq_set_vcpu_affinity(host_irq, NULL);
 }
 
-static inline int
-avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
+static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu)
 {
 	int ret = 0;
 	struct amd_svm_iommu_ir *ir;
@@ -871,7 +870,7 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 		return 0;
 
 	list_for_each_entry(ir, &svm->ir_list, node) {
-		ret = amd_iommu_update_ga(cpu, r, ir->data);
+		ret = amd_iommu_update_ga(cpu, ir->data);
 		if (ret)
 			return ret;
 	}
@@ -933,7 +932,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
-	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
+	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
@@ -973,7 +972,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
+	avic_update_iommu_vcpu_affinity(vcpu, -1);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	svm->avic_physical_id_entry = entry;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index bc6f7eb2f04b..ba3a1a403cb2 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3957,7 +3957,7 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 	return 0;
 }
 
-int amd_iommu_update_ga(int cpu, bool is_run, void *data)
+int amd_iommu_update_ga(int cpu, void *data)
 {
 	struct amd_ir_data *ir_data = (struct amd_ir_data *)data;
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
@@ -3974,8 +3974,10 @@ int amd_iommu_update_ga(int cpu, bool is_run, void *data)
 					APICID_TO_IRTE_DEST_LO(cpu);
 		entry->hi.fields.destination =
 					APICID_TO_IRTE_DEST_HI(cpu);
+		entry->lo.fields_vapic.is_run = true;
+	} else {
+		entry->lo.fields_vapic.is_run = false;
 	}
-	entry->lo.fields_vapic.is_run = is_run;
 
 	return __modify_irte_ga(ir_data->iommu, ir_data->irq_2_irte.devid,
 				ir_data->irq_2_irte.index, entry);
diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
index 99b4fa9a0296..fe0e16ffe0e5 100644
--- a/include/linux/amd-iommu.h
+++ b/include/linux/amd-iommu.h
@@ -30,8 +30,7 @@ static inline void amd_iommu_detect(void) { }
 /* IOMMU AVIC Function */
 extern int amd_iommu_register_ga_log_notifier(int (*notifier)(u32));
 
-extern int
-amd_iommu_update_ga(int cpu, bool is_run, void *data);
+extern int amd_iommu_update_ga(int cpu, void *data);
 
 extern int amd_iommu_activate_guest_mode(void *data);
 extern int amd_iommu_deactivate_guest_mode(void *data);
@@ -44,8 +43,7 @@ amd_iommu_register_ga_log_notifier(int (*notifier)(u32))
 	return 0;
 }
 
-static inline int
-amd_iommu_update_ga(int cpu, bool is_run, void *data)
+static inline int amd_iommu_update_ga(int cpu, void *data)
 {
 	return 0;
 }
-- 
2.49.0.504.g3bcea36a83-goog


