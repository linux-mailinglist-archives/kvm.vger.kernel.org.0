Return-Path: <kvm+bounces-49161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CDB9AD631E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 681873AC0F3
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D22A2D320D;
	Wed, 11 Jun 2025 22:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c13GGK2k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018522BDC20
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682045; cv=none; b=Y+daEP6bn2QUggY//TMM1dK96hsBQg0i3E1ngNKccpEPFjY2y7vMKaIK/AFe1etkAe9efOzkhJ1/lE3x8lz/Mmhe8zdUcvwdDevgpVd6kVWUdw0yry6gIG4s9YwYChbj9rrXJ1jbggio2Pdj+N1NW/lILgIUZmo3SJKT7UpZz+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682045; c=relaxed/simple;
	bh=+hv/L1bIbXZPSlj1hiWZXItfDwwPTIV42fY47pjIvko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=elwcYtauDeyL9aIfyVQUJ9FpkfI3k3/aeMVZ9jnZPOISKTDtPsUuqSEOLuZyL7b/GD385aEasiKnRLMOpGPMX7lmAxUO7NeftPE7EjSVfgSnpbkbum7oHNl1r8RJiaOeq5F7tfKs4mkseRzXdqZllKki+9nB3mtD9wcMQDAdjeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c13GGK2k; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7377139d8b1so263095b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682042; x=1750286842; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uVzEHyBaRiJNDQh5a5Dx7H8kv7wjszZU3WXvYcKHvtU=;
        b=c13GGK2kPYyJ2BAUi2iyLhwVQXBHN3TyysTZeSeumO5pOKSxonFudIW+ENXfxYocMT
         Gv5bHVA7svt6Z7LTl2wcT4K38t1jjE01IAVK1DbMMhayQqL4UJqKSrIR1VMscRMuQDQp
         pAM7LlkXOwCfWqB8+ipZb3odrxegS2yGykQrhf7eynDTwgwpy5Gn5uQ2DnHVkqDVctDl
         QC13qA+BuXsCQAw62rcpWQRcji17AxI+Ke2QyrgFJq1W9QN8V0a6pJDSgRv82K0U1+3G
         465bWPEr+KPdpb37jQ7S4S3WjY2D/ovbInOXkWJDBjArZukt6PTnWIUDhGiFsRU3VN2E
         Vgww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682042; x=1750286842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uVzEHyBaRiJNDQh5a5Dx7H8kv7wjszZU3WXvYcKHvtU=;
        b=tiVIA7h5A9YVxxTpyw3aVYADUwLce4sOW2y+1HgqA+KJsVQ+bvV7BBy+2QCmF92Xl2
         b+PbnkjqsoOplIW3A0jZjDcKdtaHiLAKnlrK+uzpv4jtMl6f81bLlx8Qv6rxWk1ywWJT
         YdO9OpE5YSy+euZqkJDp6Zv+rmiPn0WbMfBm6X8++NAoV2vVTN+gOMZlJpG63Zl1hoTT
         j2WBEDwjp4wFFVlGDpQOxaccrl7zoJP0Zh/EElETVjNGsqkl6T4zYfrBq4NyM3UOr6tN
         xiBY1gmwBDU+tqKtiYtYcAsSM809dVTVkOGelh3qJ9+yTw59GNpovi1XTECVdzMTML7c
         pW1A==
X-Forwarded-Encrypted: i=1; AJvYcCVxv2MVsWsYr4d7Rlsdu4R7gZFdYdSa5fMym2xID1TRqCC1QARlUxwU9JwS+r4anskWnno=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/2HGROiTLlaJ4Jjn0CkTt0eIQVQxGE0IKeBO57Gg/aGhO1bWb
	pDfzJyN89uV6BvvbZDBYRyWDG2uZGZ7ZhJXPEwu8C/Rtd7yNiQtlekrL97PTdZ1S2szv343ICqB
	xhNGN4g==
X-Google-Smtp-Source: AGHT+IFakcvyKnqCueAUeZlAT109XlS9YCn8fDNscX2Sisdyt0t4bYMkEX6AxhE9x+pXQlvyQldIB86adbU=
X-Received: from pfnx17.prod.google.com ([2002:aa7:84d1:0:b0:746:27ff:87f8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a1:b0:210:1c3a:6804
 with SMTP id adf61e73a8af0-21f9bbb2da4mr712401637.31.1749682042326; Wed, 11
 Jun 2025 15:47:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:18 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-17-seanjc@google.com>
Subject: [PATCH v3 15/62] KVM: SVM: Drop superfluous "cache" of AVIC Physical
 ID entry pointer
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the vCPU's pointer to its AVIC Physical ID entry, and simply index
the table directly.  Caching a pointer address is completely unnecessary
for performance, and while the field technically caches the result of the
pointer calculation, it's all too easy to misinterpret the name and think
that the field somehow caches the _data_ in the table.

No functional change intended.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 27 +++++++++++++++------------
 arch/x86/kvm/svm/svm.h  |  1 -
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bf18b0b643d9..0c0be274d29e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -294,8 +294,6 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(kvm_svm->avic_physical_id_table[id], new_entry);
 
-	svm->avic_physical_id_cache = &kvm_svm->avic_physical_id_table[id];
-
 	return 0;
 }
 
@@ -770,13 +768,16 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 			   struct kvm_kernel_irqfd *irqfd,
 			   struct amd_iommu_pi_data *pi)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
 	unsigned long flags;
 	u64 entry;
 
 	if (WARN_ON_ONCE(!pi->ir_data))
 		return -EINVAL;
 
-	irqfd->irq_bypass_vcpu = &svm->vcpu;
+	irqfd->irq_bypass_vcpu = vcpu;
 	irqfd->irq_bypass_data = pi->ir_data;
 
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
@@ -787,7 +788,7 @@ static int svm_ir_list_add(struct vcpu_svm *svm,
 	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
 	 * See also avic_vcpu_load().
 	 */
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
 	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
 		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
 				    true, pi->ir_data);
@@ -964,17 +965,18 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	u64 entry;
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
+	u64 entry;
 
 	lockdep_assert_preemption_disabled();
 
 	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
-	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
+	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
 		return;
 
 	/*
@@ -996,14 +998,14 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	spin_lock_irqsave(&svm->ir_list_lock, flags);
 
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
 	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
 	entry |= AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
@@ -1011,13 +1013,14 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	u64 entry;
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long flags;
+	u64 entry;
 
 	lockdep_assert_preemption_disabled();
 
-	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
+	if (WARN_ON_ONCE(vcpu->vcpu_id * sizeof(entry) >= PAGE_SIZE))
 		return;
 
 	/*
@@ -1027,7 +1030,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
 	 * recursively.
 	 */
-	entry = READ_ONCE(*(svm->avic_physical_id_cache));
+	entry = READ_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id]);
 
 	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
@@ -1046,7 +1049,7 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
-	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+	WRITE_ONCE(kvm_svm->avic_physical_id_table[vcpu->vcpu_id], entry);
 
 	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ec5d77d42a49..f225d0bed152 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -306,7 +306,6 @@ struct vcpu_svm {
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-	u64 *avic_physical_id_cache;
 
 	/*
 	 * Per-vCPU list of irqfds that are eligible to post IRQs directly to
-- 
2.50.0.rc1.591.g9c95f17f64-goog


