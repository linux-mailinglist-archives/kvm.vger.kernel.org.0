Return-Path: <kvm+bounces-49155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A669AD630D
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:51:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85D8D460024
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2640C28BA88;
	Wed, 11 Jun 2025 22:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uJ2eEBif"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36D5262FC8
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682036; cv=none; b=ieCyb02xfuPPnkaWpZaK6JyFajlKyvPwc3L9N2YAiwVeHU6iRBMPMCS0w9wAQ09c3jPBq/58Gq8znSy69sqaq5/UclgV6hxE64w/5EckV/92h0xHg48QrG4FsrH399uNOG0eHJKB4C0M1NlKCFMhAcDhj1juzYeTFvPdvfdkmQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682036; c=relaxed/simple;
	bh=hEiCQzEBv68hmHUNBF+zRpCEthWLf82WC5scO76qyP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dBw1TXuj7jsn+4ERplP7OoUEiFHBNtvdILSfTehjDJ69jn209zD5hgq2T1S8Jdf9cncVeo8mXjpbuBaYZwoZuxjCJhZJRYS+0aCVD6/BzjGH9Rn/HOlUlo6UbajUoG2YyNWGt/qWhraNqWrlWDDRCzxk4RzMZC4XPsKOc2KDzD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uJ2eEBif; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fb347b3e6so229393a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682032; x=1750286832; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I8oMP1EOncIUD9US+9qQ69z324nW43UQ9Vgx7SP4DmY=;
        b=uJ2eEBifG4aTVZqARlTYGMF/Jad4xApy5MNWj8o7hJM7VVGzfiK3ea5wgMrroFua30
         WOTSDDpErka2DjgcX97hdRfmum2P7JvoV3PCaNVdwfNKP/Y9voc0vUWDzwn+F9knSf2y
         iylJaJ/i0ooJOoYf14SzUjRR4iaXoyjcJkseHl4zkdfn3WWLl8ocbOWiz5Hl9ii/Ib/Z
         gut4ncm8Xj3AVYm0+33aqjZVG0EaLiN55fWpAJmRt9a2RVMtylHoZbvdk7asSHYLUzeR
         wES1qEDtJPYQvGec9qDQ+PfA5Ft+rJkeJG3O6GD0Ot6fnCROdIxVFc1PRv73/U9oiiMj
         2JUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682032; x=1750286832;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I8oMP1EOncIUD9US+9qQ69z324nW43UQ9Vgx7SP4DmY=;
        b=UqR7WSDjM25bBYn4LRm2sTkrRSxmaYiTJhPcSj5w4JoVHcIK3FeSMJs3fMia5UvgrX
         XHWFDp6F5qERwvg8r2RjhykVUqYzBnnf0AT4rq2BAZ/Az4hCvZVCnB7rcAJrc06561ub
         3lsKpRgKfPcYRjTu09ncv63D9kRvpCoG+HJaszpPebNnEg7LwWrHnypOUoxMnZJ0cQt2
         ZG9kW0PINzSZ34PjAcqmKYGKPpQCmh+3Exnziar49il9mvFmHNa38QMJ2WdybOB9Q8x9
         0ZQyBrpAW4J6aAp6q2ZLRrxYmaJEr/bbSPxAMsFe5Xb61qSI1bW9wIa7Natg0fCishoJ
         ErYw==
X-Forwarded-Encrypted: i=1; AJvYcCUox7iGiutCf8Q+PMg31GfH+82E1HVBZAJ1ph/ZiSzLvi8hlrcUhpxzHzCfHZFA0smd8RA=@vger.kernel.org
X-Gm-Message-State: AOJu0YySvXCjxDC+8sKF1vB93oZCAEfWrAq69ACMlbX6JkFaR1KNtowp
	y5JPdzFNeT3XuCs8ctjnuM9EO6DwChd0jkJVMucYnHPMdY+L/EVNM1MD/CriMSaluBXsKWpjyR/
	skb/1iQ==
X-Google-Smtp-Source: AGHT+IFCw4nm3TFxQYvAdNmh6gnDBKhiV2T9Iv4xzvZMX9NqKTRoM2Z40bqRwgvAKgtWr8chRpb35/3TV8M=
X-Received: from pgn7.prod.google.com ([2002:a63:d47:0:b0:b2e:ce0c:b3fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:728a:b0:1f5:8622:5ed5
 with SMTP id adf61e73a8af0-21f866001b6mr7401056637.3.1749682031934; Wed, 11
 Jun 2025 15:47:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:12 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-11-seanjc@google.com>
Subject: [PATCH v3 09/62] KVM: SVM: Drop pointless masking of kernel page pa's
 with AVIC HPA masks
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

Drop AVIC_HPA_MASK and all its users, the mask is just the 4KiB-aligned
maximum theoretical physical address for x86-64 CPUs, as x86-64 is
currently defined (going beyond PA52 would require an entirely new paging
mode, which would arguably create a new, different architecture).

All usage in KVM masks the result of page_to_phys(), which on x86-64 is
guaranteed to be 4KiB aligned and a legal physical address; if either of
those requirements doesn't hold true, KVM has far bigger problems.

Drop masking the avic_backing_page with
AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK for all the same reasons, but
keep the macro even though it's unused in functional code.  It's a
distinct architectural define, and having the definition in software
helps visualize the layout of an entry.  And to be hyper-paranoid about
MAXPA going beyond 52, add a compile-time assert to ensure the kernel's
maximum supported physical address stays in bounds.

The unnecessary masking in avic_init_vmcb() also incorrectly assumes that
SME's C-bit resides between bits 51:11; that holds true for current CPUs,
but isn't required by AMD's architecture:

  In some implementations, the bit used may be a physical address bit

Key word being "may".

Opportunistically use the GENMASK_ULL() version for
AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK, which is far more readable
than a set of repeating Fs.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/svm.h |  4 +---
 arch/x86/kvm/svm/avic.c    | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 89a666952b01..36f67c69ea66 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -253,7 +253,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
 #define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
-#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
+#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	GENMASK_ULL(51, 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
 #define AVIC_PHYSICAL_ID_TABLE_SIZE_MASK		(0xFFULL)
@@ -288,8 +288,6 @@ enum avic_ipi_failure_cause {
 static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
 static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
 
-#define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
-
 #define SVM_SEV_FEAT_SNP_ACTIVE				BIT(0)
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 5344ae76c590..4b882148f2c0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -241,9 +241,9 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
 	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
 
-	vmcb->control.avic_backing_page = bpa & AVIC_HPA_MASK;
-	vmcb->control.avic_logical_id = lpa & AVIC_HPA_MASK;
-	vmcb->control.avic_physical_id = ppa & AVIC_HPA_MASK;
+	vmcb->control.avic_backing_page = bpa;
+	vmcb->control.avic_logical_id = lpa;
+	vmcb->control.avic_physical_id = ppa;
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
@@ -301,9 +301,12 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	if (!entry)
 		return -EINVAL;
 
-	new_entry = __sme_set((page_to_phys(svm->avic_backing_page) &
-			      AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK) |
-			      AVIC_PHYSICAL_ID_ENTRY_VALID_MASK);
+	/* Note, fls64() returns the bit position, +1. */
+	BUILD_BUG_ON(__PHYSICAL_MASK_SHIFT >
+		     fls64(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK));
+
+	new_entry = __sme_set(page_to_phys(svm->avic_backing_page)) |
+		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
 	WRITE_ONCE(*entry, new_entry);
 
 	svm->avic_physical_id_cache = entry;
@@ -903,8 +906,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
 			enable_remapped_mode = false;
 
 			/* Try to enable guest_mode in IRTE */
-			pi.base = __sme_set(page_to_phys(svm->avic_backing_page) &
-					    AVIC_HPA_MASK);
+			pi.base = __sme_set(page_to_phys(svm->avic_backing_page));
 			pi.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
 						     svm->vcpu.vcpu_id);
 			pi.is_guest_mode = true;
-- 
2.50.0.rc1.591.g9c95f17f64-goog


