Return-Path: <kvm+bounces-42745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CC24A7C41D
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 669B31B614E4
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDE124EF84;
	Fri,  4 Apr 2025 19:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m1gZrpLm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4244724C099
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795690; cv=none; b=ZPab5FY6RhmFkD+0VCYjvvemZxmA1zMVawqkc4mLjt7thBYadhvL+JT7QCzTjHQBSu6JXY4FVsjuTiDKgPsuJd8wLbM15Tjq9krJ/Tv/SaFGAeY78V9I4ZyHtuVUQ88AWfnUBILjYR+nUm8NXyT3n4Upw5TJhxFfJM/xcXlKXPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795690; c=relaxed/simple;
	bh=U7Bv3Mou19gPLSngEjr+1RsKLIdn0l5YTp9cdhCcRAg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NKUovkx1run3pRus8ZX5Ue9CKb/jgoXdZYIBpZSX1Yq1y4LBfTTDGCaC21zD/4NzAnutSl+54sicQOJXoznA/mTydS/uGiVHtLXOQ977+Y//l+S4ezy9TYIrcYxUcbZ+Q6ztU2fWBKPtAGUqdjXmcftM/NIZAvWkNAgOTOOQ7f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m1gZrpLm; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736d64c5e16so2097623b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795689; x=1744400489; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mt07Qxkb97s5FkZiQg7yKT2x8NR3KghJCfR+NZxwIRc=;
        b=m1gZrpLmuzLk2+Q7XZiElC4WNAo3q94iiOcWVxm9o009DCtc5TiPC5tGRvMHS3TkHP
         auwSvrur18wQbPFnY+s8NTtOWzHA9bNYyhgdp9u0WMnmrcJvLfLzh3TyO1W+c8Jxsng3
         4VT1APrBNGKz/PfDTYdTOd+MgsaZLL7tOgEkas88Q4VAOCZ411fe6gArtzo0rtOszYqq
         wahV17wVJdWrkDCdudDBrufQKi2ojDkMxe56H1zaOh1HO+EzidFU4RjnRQ8yt5Dr9GMC
         ij26bY6+HWaQNwD7FkOVjoousWF6kKImvXPmAFBRhMc4zLkh7a7pfFutnbNcM9plx/p+
         VF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795689; x=1744400489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mt07Qxkb97s5FkZiQg7yKT2x8NR3KghJCfR+NZxwIRc=;
        b=Pn3c9RHio2hfq9dPXMEWWw5E48H22zb/6nGOMxrJM8ehGgJXTl8+6U5o4IXv9+wori
         p1/jg8jA9wxDMDrPQNTMOwaqptYSk0RSyofLKHapR8h8Ots4nnRHT+U2/77W8nWcy/1J
         YJVa/l4ibcASWFPmddobZH0vXj+rxNXpWsHjQyeW6xXAkXpL9s9vVkdYSigz6yfBI96v
         1jUfbytMBRTfzCPxq2OcaN/gE3bVs163WS4Cr62FNEl5+O1ng3T17/bMNZPPOn4GMQBx
         8IFsM78yf8eeUcsQ1qr/7Ja6Z72xBx+xZAs3T5P+ZVNbbnxyIPMJXeh3wQQeNKSvrvwx
         NljA==
X-Gm-Message-State: AOJu0YyodSQRupSlj/ZETuvZRKte/japQDXbxaV2WY344/pSpheD3Zlg
	FjGwBGbe3K/REDq4b8kufRfTEJbHGkj96xF+erP8ue7p+p4lO9tlVoI/Cr0irM+J3O1mP99fd7h
	7fw==
X-Google-Smtp-Source: AGHT+IHKRRqtQ+5sxIr+azJfU1pTEj52X3kWKBhqR+uBWAf1O7lXz3snAlLOZvwHP7CdcZyeKm5xblX214Q=
X-Received: from pfbdf8.prod.google.com ([2002:a05:6a00:4708:b0:737:6b9f:8ab4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:10cb:b0:736:5486:7820
 with SMTP id d2e1a72fcca58-739e48573c2mr5416904b3a.13.1743795688779; Fri, 04
 Apr 2025 12:41:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:14 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-60-seanjc@google.com>
Subject: [PATCH 59/67] KVM: SVM: Use vcpu_idx, not vcpu_id, for GA log tag/metadata
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Use a vCPU's index, not its ID, for the GA log tag/metadata that's used to
find and kick vCPUs when a device posted interrupt serves as a wake event.
Lookups on a vCPU index are O(fast) (not sure what xa_load() actually
provides), whereas a vCPU ID lookup is O(n) if a vCPU's ID doesn't match
its index.

Unlike the Physical APIC Table, which is accessed by hardware when
virtualizing IPIs, hardware doesn't consume the GA tag, i.e. KVM _must_
use APIC IDs to fill the Physical APIC Table, but KVM has free rein over
the format/meaning of the GA tag.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d2cbb7ac91f4..d567d62463ac 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -29,36 +29,39 @@
 #include "svm.h"
 
 /*
- * Encode the arbitrary VM ID and the vCPU's default APIC ID, i.e the vCPU ID,
- * into the GATag so that KVM can retrieve the correct vCPU from a GALog entry
- * if an interrupt can't be delivered, e.g. because the vCPU isn't running.
+ * Encode the arbitrary VM ID and the vCPU's _index_ into the GATag so that
+ * KVM can retrieve the correct vCPU from a GALog entry if an interrupt can't
+ * be delivered, e.g. because the vCPU isn't running.  Use the vCPU's index
+ * instead of its ID (a.k.a. its default APIC ID), as KVM is guaranteed a fast
+ * lookup on the index, where as vCPUs whose index doesn't match their ID need
+ * to walk the entire xarray of vCPUs in the worst case scenario.
  *
- * For the vCPU ID, use however many bits are currently allowed for the max
+ * For the vCPU index, use however many bits are currently allowed for the max
  * guest physical APIC ID (limited by the size of the physical ID table), and
  * use whatever bits remain to assign arbitrary AVIC IDs to VMs.  Note, the
  * size of the GATag is defined by hardware (32 bits), but is an opaque value
  * as far as hardware is concerned.
  */
-#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
+#define AVIC_VCPU_IDX_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
 
 #define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
 #define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
 
 #define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
-#define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
+#define AVIC_GATAG_TO_VCPUIDX(x)	(x & AVIC_VCPU_IDX_MASK)
 
-#define __AVIC_GATAG(vm_id, vcpu_id)	((((vm_id) & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
-					 ((vcpu_id) & AVIC_VCPU_ID_MASK))
-#define AVIC_GATAG(vm_id, vcpu_id)					\
+#define __AVIC_GATAG(vm_id, vcpu_idx)	((((vm_id) & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
+					 ((vcpu_idx) & AVIC_VCPU_IDX_MASK))
+#define AVIC_GATAG(vm_id, vcpu_idx)					\
 ({									\
-	u32 ga_tag = __AVIC_GATAG(vm_id, vcpu_id);			\
+	u32 ga_tag = __AVIC_GATAG(vm_id, vcpu_idx);			\
 									\
-	WARN_ON_ONCE(AVIC_GATAG_TO_VCPUID(ga_tag) != (vcpu_id));	\
+	WARN_ON_ONCE(AVIC_GATAG_TO_VCPUIDX(ga_tag) != (vcpu_idx));	\
 	WARN_ON_ONCE(AVIC_GATAG_TO_VMID(ga_tag) != (vm_id));		\
 	ga_tag;								\
 })
 
-static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
+static_assert(__AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_IDX_MASK) == -1u);
 
 static bool force_avic;
 module_param_unsafe(force_avic, bool, 0444);
@@ -148,16 +151,16 @@ int avic_ga_log_notifier(u32 ga_tag)
 	struct kvm_svm *kvm_svm;
 	struct kvm_vcpu *vcpu = NULL;
 	u32 vm_id = AVIC_GATAG_TO_VMID(ga_tag);
-	u32 vcpu_id = AVIC_GATAG_TO_VCPUID(ga_tag);
+	u32 vcpu_idx = AVIC_GATAG_TO_VCPUIDX(ga_tag);
 
-	pr_debug("SVM: %s: vm_id=%#x, vcpu_id=%#x\n", __func__, vm_id, vcpu_id);
-	trace_kvm_avic_ga_log(vm_id, vcpu_id);
+	pr_debug("SVM: %s: vm_id=%#x, vcpu_idx=%#x\n", __func__, vm_id, vcpu_idx);
+	trace_kvm_avic_ga_log(vm_id, vcpu_idx);
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_for_each_possible(svm_vm_data_hash, kvm_svm, hnode, vm_id) {
 		if (kvm_svm->avic_vm_id != vm_id)
 			continue;
-		vcpu = kvm_get_vcpu_by_id(&kvm_svm->kvm, vcpu_id);
+		vcpu = kvm_get_vcpu(&kvm_svm->kvm, vcpu_idx);
 		break;
 	}
 	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
@@ -793,7 +796,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 		 */
 		struct amd_iommu_pi_data pi_data = {
 			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
-					     vcpu->vcpu_id),
+					     vcpu->vcpu_idx),
 			.is_guest_mode = kvm_vcpu_apicv_active(vcpu),
 			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
 			.vector = vector,
-- 
2.49.0.504.g3bcea36a83-goog


