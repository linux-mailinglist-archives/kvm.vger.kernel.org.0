Return-Path: <kvm+bounces-47457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA4BAC1917
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE8FA1BA38ED
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC944221557;
	Fri, 23 May 2025 01:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W1nKfFt9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D97C21D5BC
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962024; cv=none; b=X0QtSi3JB+dJbOVIhltcR6UhwAEvA384VvH/OhdZH7kh2LQc5zVJmez/zy7INop/Cu3EuSrAM89nz+Y1orq5MRQmEBMp8sVEC4WkQ+NDj4rSewggK+ri1esCKT8mqEGYTsJixpGmuJqQjacGWLGe+Om2LivjzriB1TOs+2sNM3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962024; c=relaxed/simple;
	bh=gqinHJl4ph8b7HfdeibMhW7beyjALh/UjkVTBB01jQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tac5Mhwlnotnvz2a9hlzAaFbY4Zat8NHlzrWrjaqAroVaZYmmiahkC3IH6yYnkfIuBQqokxXQzBDO+bbfa8vBZ4BikzB+IcDoIFd1nS6aRhWzNYRC9uGlAHPSk8jwhcPnAIisNvP+misQJSG+ERUCyIlUkTKYZ8uGnW5mNYywbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W1nKfFt9; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e86c46eadso6134152a91.2
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962022; x=1748566822; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9Cs4IdaV3ASNd4zhQE7PBc/8KU9AFgbUF8yCRvi0apU=;
        b=W1nKfFt9a/lAXIGyKXjq2I5os6RHamvBqBp+zuC2/AOa9JDaMFKfXiVXySx08ksDUE
         ryQHkT+sThPgeo7sCLNZhm2U0w1kdytO6JVSrFTSQ25cTnbdlAKlehrX7sWX73nH3Rm+
         y/IslzD2ixqO/exQQBfPyhFvvDVAqzr2DswhSDX0p7yywPKHuBfxqJXWKiKgx+E5NiNy
         sLDxDcVhbjPg2/Y9UiGhQXCGvWTgA7U3bjzb695cDZugPcBm1q/ZYTnLqEUpKA9Div4b
         fY0qtVYj2ysKrEdArfp+QZOldu4EYw82wYXrIW4qeioHHdEgG7Fy55YveiMZI6PXbsU8
         4Biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962022; x=1748566822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Cs4IdaV3ASNd4zhQE7PBc/8KU9AFgbUF8yCRvi0apU=;
        b=WjIYuqL3ScS8Y18CyOQPb+L6sNj5eKDw/w1RUOVXv3q/ZTmDGFTw30ci1V21baforw
         bg6hK31ADHAg6/++EZ8uWbZDwwzk3Iu5yetCFlxje4rhG4W4nCUraywCSqaPLBoZwxvS
         QTecZaewwfY9l0HC3VLLDmFDH1/Ni2y1dQVoMT/0liWBopRhh9dCgxGsvB0cePugU/+m
         H628T81uLWDhFYjpYihl+EjefngVaL9OeUzmf22vIdof/A6ueXr6dE3Tnru24RduxmPL
         PM+EZO9SQDBG7Abo2NQujxoBzCTPSjnzkQxzOJ9AOZ4OEegdFndP4sEI+49V9KLVxz+m
         gC6Q==
X-Gm-Message-State: AOJu0YzLtHoDFMnQ49YJNCD89ZgqqdMPvCoAUuPbwHIYItdHs/9+NYW6
	lg5EHWpHX0igr+9bTUFLU1vRnJuhdW7mgtbVE73BxpaqswZwyn/DWqTgoxRxtjFXDbKk8TvZZdA
	wYtVhzA==
X-Google-Smtp-Source: AGHT+IEq1yGKX3GT8g6xR16/Op9j5PmX+/amiR5/uKGcbJN98SDicWh7GG9+SGCFoQyaNG+rqASDrwH5FjU=
X-Received: from pjbph15.prod.google.com ([2002:a17:90b:3bcf:b0:2f9:dc36:b11])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1648:b0:30a:3dde:6af4
 with SMTP id 98e67ed59e1d1-30e7d5be456mr37760914a91.31.1747962022624; Thu, 22
 May 2025 18:00:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:12 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-8-seanjc@google.com>
Subject: [PATCH v2 07/59] KVM: SVM: Drop pointless masking of kernel page pa's
 with AVIC HPA masks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
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
2.49.0.1151.ga128411c76-goog


