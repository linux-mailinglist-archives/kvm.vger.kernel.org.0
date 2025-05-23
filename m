Return-Path: <kvm+bounces-47462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BB8AC1924
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A598154033E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9A822A4E0;
	Fri, 23 May 2025 01:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="14abEIiv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BE22253FB
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962033; cv=none; b=r6JEQwgL3yV2hxvgnQwODErUsMyhob4ZSBjltsc/cWx9OY2IwJthtSgcjDd22jdIWELsPeJsaHA2G3vW8E5NNXSwbxQcnNNtKWC3MR4fDRgfJZcUXFvm24HocC4X2BFvkZwxilhyHLm9GKLzs2sUzAJ1VcvLYj3jrGZddUJHnKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962033; c=relaxed/simple;
	bh=1u7yaWCSV8swor7EDb2Vzxng28EOGOs32xp2c0ARZ8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EHKRBsFbJ66DSI1vwgiyW+LspWV0xoFV1cKs2ZyqvirBJs5KhX3AgcRQiHe82muTZ2NT4amVkZQUbbtkxxpN0IDznuruCW8I+a8uninGtelXEG9lF+DtzdqII9dTp9EI7jecXIX9qvD8ItwAb8kEF848Xhfr/6cYU++IelCqzUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=14abEIiv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e810d6901so5670796a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962031; x=1748566831; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TWVWI0HB+j/yivqbFmMmYR1x9Y24z6jTPvGpz798n6o=;
        b=14abEIiv5opjbAde1BUd+QC3oZpNYvnuC8Ndzaq+7jIlDPbuWIrcuNvzZkrX6GFiih
         oNaN3+zg49OPGCxjVYekwPbdF0pMNNYE7IL81PerEJ4Y6k4MvM6bg1Wu8fois4aXjQZb
         kAl5Po0CWtLoYGCec6YQ6KTf7SHyOLAPU97Oxr1EHSNOMgKYlxpSBTS3XGhVQZ4qVr+F
         qGSR6XvxurB+zY5MDRpkLTjhaxQp9Xr3+jX+JkkCf9n5NQMJTwDsO7WCuB86McJ2izn5
         MBBkDS3JUgT04tfQBvaVYF13ZW72Bh7W/Y4FD7KjW3fOldmc33LOy9mvxMcFipUjhde6
         MWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962031; x=1748566831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TWVWI0HB+j/yivqbFmMmYR1x9Y24z6jTPvGpz798n6o=;
        b=ufgqfgycsEzydJhOZsK5ghy/YwbxRM9kCRGFWgv6Z9idl+7DebUtFK/km9psvxXTUT
         neAwF3TKLqFGUZW3EzGkTqPUwrDf24ztbUCktNIc8t/iPV/5xczxUIaHcPZXmCq8OOTu
         rxIEgA8mxJYRqJP69J19pfQFxbrBlQ51cc+g081SZba6+TrX38BcGEMuSbVopVendt5w
         AKqKXod+wc0XZdd8gI09wWJriiIIMr1QYN24nrfaYQRPWnR/7L8O8pGozCmfLRrA6zf3
         sneYP6Ar4JWcOrxmMgIWukPSxnDOnZwzT/NYE2JmLnyusbsykt3nyrK2evM2InXoym7E
         CuCA==
X-Gm-Message-State: AOJu0YxL8ao/lLsLGdfmR20PkJp5/UJv20yQhLZmiWvDZ+jCO8qo8w0E
	XBsfEycqzF6sVc94reEoKZrK97GngSbNDf3U7+gZ8FgO5WOuWaQCOsLl1vsu6zbIBZSehthhe0Q
	B2v0Atg==
X-Google-Smtp-Source: AGHT+IFAvtZwrOPujc8Jiezt5ZUqdB9goJmViesuN7rSLHyglpb7Gd0+oRTXrUjZLjFNcb4QeIdzixEWwiw=
X-Received: from pjf14.prod.google.com ([2002:a17:90b:3f0e:b0:2fc:d77:541])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1645:b0:2ee:94d1:7a89
 with SMTP id 98e67ed59e1d1-310e96b6096mr1702204a91.1.1747962031141; Thu, 22
 May 2025 18:00:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:17 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-13-seanjc@google.com>
Subject: [PATCH v2 12/59] KVM: SVM: Track AVIC tables as natively sized
 pointers, not "struct pages"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Allocate and track AVIC's logical and physical tables as u32 and u64
pointers respectively, as managing the pages as "struct page" pointers
adds an almost absurd amount of boilerplate and complexity.  E.g. with
page_address() out of the way, svm->avic_physical_id_cache becomes
completely superfluous, and will be removed in a future cleanup.

No functional change intended.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 49 ++++++++++++++---------------------------
 arch/x86/kvm/svm/svm.h  |  4 ++--
 2 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 948bab48083b..bf18b0b643d9 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -172,10 +172,8 @@ void avic_vm_destroy(struct kvm *kvm)
 	if (!enable_apicv)
 		return;
 
-	if (kvm_svm->avic_logical_id_table_page)
-		__free_page(kvm_svm->avic_logical_id_table_page);
-	if (kvm_svm->avic_physical_id_table_page)
-		__free_page(kvm_svm->avic_physical_id_table_page);
+	free_page((unsigned long)kvm_svm->avic_logical_id_table);
+	free_page((unsigned long)kvm_svm->avic_physical_id_table);
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_del(&kvm_svm->hnode);
@@ -188,27 +186,19 @@ int avic_vm_init(struct kvm *kvm)
 	int err = -ENOMEM;
 	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
 	struct kvm_svm *k2;
-	struct page *p_page;
-	struct page *l_page;
 	u32 vm_id;
 
 	if (!enable_apicv)
 		return 0;
 
-	/* Allocating physical APIC ID table (4KB) */
-	p_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!p_page)
+	kvm_svm->avic_physical_id_table = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (!kvm_svm->avic_physical_id_table)
 		goto free_avic;
 
-	kvm_svm->avic_physical_id_table_page = p_page;
-
-	/* Allocating logical APIC ID table (4KB) */
-	l_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!l_page)
+	kvm_svm->avic_logical_id_table = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (!kvm_svm->avic_logical_id_table)
 		goto free_avic;
 
-	kvm_svm->avic_logical_id_table_page = l_page;
-
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
  again:
 	vm_id = next_vm_id = (next_vm_id + 1) & AVIC_VM_ID_MASK;
@@ -242,12 +232,10 @@ static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
-	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
-	phys_addr_t ppa = __sme_set(page_to_phys(kvm_svm->avic_physical_id_table_page));
 
 	vmcb->control.avic_backing_page = avic_get_backing_page_address(svm);
-	vmcb->control.avic_logical_id = lpa;
-	vmcb->control.avic_physical_id = ppa;
+	vmcb->control.avic_logical_id = __sme_set(__pa(kvm_svm->avic_logical_id_table));
+	vmcb->control.avic_physical_id = __sme_set(__pa(kvm_svm->avic_physical_id_table));
 	vmcb->control.avic_vapic_bar = APIC_DEFAULT_PHYS_BASE;
 
 	if (kvm_apicv_activated(svm->vcpu.kvm))
@@ -261,7 +249,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 id = vcpu->vcpu_id;
-	u64 *table, new_entry;
+	u64 new_entry;
 
 	/*
 	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
@@ -277,8 +265,8 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE ||
-		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE);
+	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(new_entry) > PAGE_SIZE ||
+		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(new_entry) > PAGE_SIZE);
 
 	if (WARN_ON_ONCE(!vcpu->arch.apic->regs))
 		return -EINVAL;
@@ -297,18 +285,16 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	/* Setting AVIC backing page address in the phy APIC ID table */
-	table = page_address(kvm_svm->avic_physical_id_table_page);
-
 	/* Note, fls64() returns the bit position, +1. */
 	BUILD_BUG_ON(__PHYSICAL_MASK_SHIFT >
 		     fls64(AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK));
 
+	/* Setting AVIC backing page address in the phy APIC ID table */
 	new_entry = avic_get_backing_page_address(svm) |
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
-	WRITE_ONCE(table[id], new_entry);
+	WRITE_ONCE(kvm_svm->avic_physical_id_table[id], new_entry);
 
-	svm->avic_physical_id_cache = &table[id];
+	svm->avic_physical_id_cache = &kvm_svm->avic_physical_id_table[id];
 
 	return 0;
 }
@@ -442,7 +428,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
 		if (apic_x2apic_mode(source))
 			avic_logical_id_table = NULL;
 		else
-			avic_logical_id_table = page_address(kvm_svm->avic_logical_id_table_page);
+			avic_logical_id_table = kvm_svm->avic_logical_id_table;
 
 		/*
 		 * AVIC is inhibited if vCPUs aren't mapped 1:1 with logical
@@ -544,7 +530,6 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
 static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
-	u32 *logical_apic_id_table;
 	u32 cluster, index;
 
 	ldr = GET_APIC_LOGICAL_ID(ldr);
@@ -565,9 +550,7 @@ static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 		return NULL;
 	index += (cluster << 2);
 
-	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic_logical_id_table_page);
-
-	return &logical_apic_id_table[index];
+	return &kvm_svm->avic_logical_id_table[index];
 }
 
 static void avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 71e3c003580e..ec5d77d42a49 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -123,8 +123,8 @@ struct kvm_svm {
 
 	/* Struct members for AVIC */
 	u32 avic_vm_id;
-	struct page *avic_logical_id_table_page;
-	struct page *avic_physical_id_table_page;
+	u32 *avic_logical_id_table;
+	u64 *avic_physical_id_table;
 	struct hlist_node hnode;
 
 	struct kvm_sev_info sev_info;
-- 
2.49.0.1151.ga128411c76-goog


