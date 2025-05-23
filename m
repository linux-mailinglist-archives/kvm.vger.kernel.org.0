Return-Path: <kvm+bounces-47463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 089B5AC1921
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4334A1888364
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5064C23278D;
	Fri, 23 May 2025 01:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LZRhpwBt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D8C226D14
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962035; cv=none; b=rNvh+XHNfKieKgaNjZh3TqB9qq4oeJnhRozjbCPew3inJ3sjeGOTPn6d9AHVBcs3uKLP5fc2hVQ/NH5wHClXe82SUWyUzgWE7znM65B1tkO02iq4ZXTES+DJ1Ymyc3HSEq9fW6a9fYt5YTCF6sVu8Ty/wjO2uWtdH0dlpGW/evQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962035; c=relaxed/simple;
	bh=CI55+D0kEm5O6+xiEBD1DyHjTu/geN9Q80IyZ5PbyXI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rrB3aWgJQhX+ynG50oyw8A3YKQvnouuSSqdhf4EYMpuC3KLGk85AV9Ee5B8eBAuh2UdnY5sd0Nh+fwtP7rFNTcdvKLecodBMmnmrohxN5nFx/kWcPoFPeGq11dadNdIr24to0YjIaN9krG19ZHLgvQ9RdQIB5nl8VkyIMqVT5CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LZRhpwBt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30e896e116fso5606022a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962033; x=1748566833; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mgom0My0RXyxt3zGYxIwZj5mPyM4HyH/qZA3LIBxvLE=;
        b=LZRhpwBtd+KpkGdfkoo7EfQXrgfOkZ4Fm8rndgIRCxqmmMicsggfA1cXkx8nlw4yVm
         0zx1PKhO1WFqtXsz2awdDlXLc/+DQP/aXaD9oEw6rKOw01682VXWzRzFRi9zFDRVOCOX
         PffKDCwuokP25ihvdKvZVoNIuPbAX++3IYS4JRp6LrbTgGBcObPQYJNy+Q9rezU2iiWJ
         AzpPOg34LVophMVxGej9mH+pLbmRUBZZIa+54RgVf15n0dz2L3OyUxQgIrXovpDP8s31
         YAqFoEASbIFfI9sCJIjzfCKH0dC48jFnsILPp0vCtY6SAtgipghuHlhKLix3QbcC/6G3
         0HbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962033; x=1748566833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mgom0My0RXyxt3zGYxIwZj5mPyM4HyH/qZA3LIBxvLE=;
        b=QMwa0GzoCxhBXdiKbTjG+BHrsOYwxTRIUbz8jfqxOI3nYl9wbNH+JabWeqTTKevimF
         hoXg+guzVinxgAawbqgxfl+sTaoxeVkQE/JWaPvzdD5usKi00IZzwGq67U5lMHx4DquC
         gPjio1VZJrW7/99xUvt/GnQK5axZ7GHvK30J5wU9FOuVA1xLko/FX/YnSlx/tLHVkVlI
         RDKgRrtHVf3XeXxiBNiINYPni9W6wkQt/xEY8p/8MvOjLOSB/EUB/lPBXrSwglYrma0N
         M7TnyEgItCRKslG2m5l+vbeQCMklxYKSrvR4F5nJiNht8jKfXbNxg2wtlMX8ryTH2TYe
         3BJA==
X-Gm-Message-State: AOJu0YxHdrJO3yUSdIhZrZNnaHdLgsHzIBJ9WrWLmhljdP8iFb6PrA3q
	ytmvyQ88qmjenaFpI/REpUVfpOzqD0rZwPIdnUye7ya8h6GetiPfkVxvADq4wriidqBPgM/zpiM
	fe/F7ZA==
X-Google-Smtp-Source: AGHT+IGxjUT6ZTFdn1fL46e7uP64GFmrOiUImY5wsG9IiTzQ4jbxEpbauT01oNGyrrPeVaV1B6nroWQExuI=
X-Received: from pjuw7.prod.google.com ([2002:a17:90a:d607:b0:308:867e:1ced])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c90:b0:30a:a50e:349c
 with SMTP id 98e67ed59e1d1-30e83226f25mr38441643a91.30.1747962033065; Thu, 22
 May 2025 18:00:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:18 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-14-seanjc@google.com>
Subject: [PATCH v2 13/59] KVM: SVM: Drop superfluous "cache" of AVIC Physical
 ID entry pointer
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
2.49.0.1151.ga128411c76-goog


