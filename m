Return-Path: <kvm+bounces-22408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 784B893DBDC
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 02:08:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED5831F2100B
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 00:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478EF1836C4;
	Fri, 26 Jul 2024 23:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BbLEAvNd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE7F18306A
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038053; cv=none; b=S5ZZ6Zo1czHJzTZGsCS9EhZFR0sZ3C074BX4f1CbwE7Rw4zXwjexKCToaIybaWcveMtPJdLWYNFhiapkz2NIKOhxzyb7f4ghrFbLvEvKqGJhvR69UEtsYbGZ64CIySidn84HxTdJbg7qMCLQwfqSW+UkEsyI1Smncrb8PlnZIpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038053; c=relaxed/simple;
	bh=zcdjUASvjU1GC4/VXSe0LKQpv6RC30O1h12GjU1AZAU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ovl9gxbDzn8Q+DwaeX5dfulgjS2K+nrpWnllYWm48atp6I3XmzKeNkXCmLB8VCivoiUJR2KeY7knZTV0ocI/H2W/qkncjkt8tVHc4tNO64WBK20JNwtZ54fWF8h4v86lI3oEekVqTutWnbB+7lyZx90uJ0BD3Bo2XN5mB1ULW8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BbLEAvNd; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc53227f21so12117095ad.2
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038051; x=1722642851; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RjeQeusXYf+NFoksbIMp6SJLG4xl7UVW4NR1eYCui2c=;
        b=BbLEAvNdaqogqLLo1NHabBSzth/9DkyEaKInFhQMAXfDWvmxh35EEFBkXNq5p9GvFS
         qcvDOcKpTetQfUeQzT8psdANz8oYmqYkFEoIPYtxkCXKsgbVtHaDJv+/+9eQQKnNdACb
         zF9n3gxLqZK0vsVohNLeaqWpY54u/h42ub/x5uHVgZl859tw3qTUnp4zK0+ZhLeTYzgs
         7TFyvDAB6zHCOfqf+F/B4PtVyyHrX6Efk0E9c4edA1DHAIxIHe76QdUe60HrVNaz3TgX
         lpMKJa62iZekZYXLVtxWwPvNrnndnQlFWB/qOuU3ARzXLo9FyyMvE+oqzSPSD0B26FJ/
         GQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038051; x=1722642851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RjeQeusXYf+NFoksbIMp6SJLG4xl7UVW4NR1eYCui2c=;
        b=EqMAvPHPioVZ0/kmVH4TUuKx68ldsfvOn+ObnHCxVRQXK1d8CjRR0nziT4bvkJgTgG
         9XmwfOkYVI40Nq3/9pkXiz2Cj63a4BUHJmd746NLtgidp5Qxws1Ddpa0cuxA4caRsYUy
         66omIPgWONXskyOKYFrcD9fvCbI4+ItEiMOFDueCwLQbGmf+E81nYOi8w+UaMirSuxUT
         68TyH9veblWw/GpUX2c4E9CrSAAplZSRxGANrXthPffyj2ZAURZ4E5S4MEWLShhkQOjk
         Bb6d8MX1I/epC3qgr+QxgkkKi/77eOL+c7dROtY1Ry5MIqzewliFE1wf7wbTxgbpBm4k
         PzaA==
X-Gm-Message-State: AOJu0YwNTNai4q0SexOleMqC58LNCdm1rw4P9P2CmPVuig02zoJirOAM
	eAeE5jW8U0xVUlGJ/QstiTBLgxeYIyjzzdhAJRTYuOykvyE+9liwIwa09iAS+lk4tyU3nhvnyzn
	odA==
X-Google-Smtp-Source: AGHT+IH9Sleax7HjGR/xKBhc5+sBB7ouHNPkUkQToWM2on12s7r2/JIy8m8cUdV6C+LgY7aIUstVbYLK+Ts=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:244b:b0:1fb:82f5:6631 with SMTP id
 d9443c01a7336-1ff04898c7dmr609255ad.9.1722038050968; Fri, 26 Jul 2024
 16:54:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:54 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-46-seanjc@google.com>
Subject: [PATCH v12 45/84] KVM: guest_memfd: Provide "struct page" as output
 from kvm_gmem_get_pfn()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Provide the "struct page" associated with a guest_memfd pfn as an output
from __kvm_gmem_get_pfn() so that KVM guest page fault handlers can
directly put the page instead of having to rely on
kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 arch/x86/kvm/svm/sev.c   | 10 ++++++----
 include/linux/kvm_host.h |  6 ++++--
 virt/kvm/guest_memfd.c   | 19 +++++++++++--------
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 53555ea5e5bb..146e57c9c86d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4353,7 +4353,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &max_order);
+			     &fault->refcounted_page, &max_order);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 62f63fd714df..5c125e4c1096 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3847,6 +3847,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
 		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
 		struct kvm_memory_slot *slot;
+		struct page *page;
 		kvm_pfn_t pfn;
 
 		slot = gfn_to_memslot(vcpu->kvm, gfn);
@@ -3857,7 +3858,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		 * The new VMSA will be private memory guest memory, so
 		 * retrieve the PFN from the gmem backend.
 		 */
-		if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
+		if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
 			return -EINVAL;
 
 		/*
@@ -3886,7 +3887,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		 * changes then care should be taken to ensure
 		 * svm->sev_es.vmsa is pinned through some other means.
 		 */
-		kvm_release_pfn_clean(pfn);
+		kvm_release_page_clean(page);
 	}
 
 	/*
@@ -4686,6 +4687,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	struct kvm_memory_slot *slot;
 	struct kvm *kvm = vcpu->kvm;
 	int order, rmp_level, ret;
+	struct page *page;
 	bool assigned;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
@@ -4712,7 +4714,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 		return;
 	}
 
-	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
 	if (ret) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
 				    gpa);
@@ -4770,7 +4772,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 out:
 	trace_kvm_rmp_fault(vcpu, gpa, pfn, error_code, rmp_level, ret);
 out_no_trace:
-	put_page(pfn_to_page(pfn));
+	kvm_release_page_unused(page);
 }
 
 static bool is_pfn_range_shared(kvm_pfn_t start, kvm_pfn_t end)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e0548ae92659..9d2a97eb30e4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2462,11 +2462,13 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
+		     int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-				   kvm_pfn_t *pfn, int *max_order)
+				   kvm_pfn_t *pfn, struct page **page,
+				   int *max_order)
 {
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1c509c351261..ad1f9e73cd13 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -542,12 +542,12 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 }
 
 static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
-		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
+			      gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
+			      int *max_order, bool prepare)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
-	struct page *page;
 	int r;
 
 	if (file != slot->gmem.file) {
@@ -571,9 +571,9 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 		return -EHWPOISON;
 	}
 
-	page = folio_file_page(folio, index);
+	*page = folio_file_page(folio, index);
 
-	*pfn = page_to_pfn(page);
+	*pfn = page_to_pfn(*page);
 	if (max_order)
 		*max_order = 0;
 
@@ -585,7 +585,8 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
+		     int *max_order)
 {
 	struct file *file = kvm_gmem_get_file(slot);
 	int r;
@@ -593,7 +594,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	r = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, true);
+	r = __kvm_gmem_get_pfn(file, slot, gfn, pfn, page, max_order, true);
 	fput(file);
 	return r;
 }
@@ -604,6 +605,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 {
 	struct file *file;
 	struct kvm_memory_slot *slot;
+	struct page *page;
 	void __user *p;
 
 	int ret = 0, max_order;
@@ -633,7 +635,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		ret = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &max_order, false);
+		ret = __kvm_gmem_get_pfn(file, slot, gfn, &pfn, &page,
+					  &max_order, false);
 		if (ret)
 			break;
 
@@ -644,7 +647,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
 
-		put_page(pfn_to_page(pfn));
+		put_page(page);
 		if (ret)
 			break;
 	}
-- 
2.46.0.rc1.232.g9752f9e123-goog


