Return-Path: <kvm+bounces-49160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C54AD631B
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 00:53:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3D073AD084
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 22:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A150A2BDC28;
	Wed, 11 Jun 2025 22:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ugbQdSwH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E7C2C326A
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682043; cv=none; b=Tm9zYHTWCsBLyAlBjxoglOGLor2Q5FdcAgFtdWPkOJnAhlb+8pC4R+SyMdN1RHGw8UsG7Wd34z3MXkAb9z6l7+TsR4FAXXvPzLMKhEz/SyBKJ5zuQU6Ghv3x+JfKBVR25CnFXHaq/kl/HQxOpYv8eFchrqH/4Enwut88I7g7tAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682043; c=relaxed/simple;
	bh=2qGacpjWOqGXCydBdqQhvBSAIJOXNOYV4LljHdOsKcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U9PL7VEDkQKMmaDjiEWKNbYVDGCJKGhIIFT759BfvSImDy7xeve9LXnPn3yCVPf0pLQmM6hqh/h8Po4O1QQS8I9Q+32z6ATR/MmBuM8E9XPOkxiMQWGzPny75qiVSnCOzIR+SabZwjL7JqwTwHKWugUBySALvgCOfZ3al53MftI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ugbQdSwH; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742c03c0272so396275b3a.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682040; x=1750286840; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fjGDTFzoOPTHOIiqFgNMI96VBH4N7QEJybjbvNpN00c=;
        b=ugbQdSwHXylRvh2DXNjr/gnX5+d+LHF/tcH+uDAeYFryWZfQjxI+52PC3+d/QP6Ia+
         arsKzMY5NcD+XgIWQ8eJTC5Mfx4r2b0CqVs2QhUk1RWh+/+gGitYA6+AlDd47NTU94Sr
         L/BHNZVQk8KisulIsm9WYK4xpp6aPCAwY1lFknyT2pAb5a0WlZyOANU9DZ7aebZxBsXn
         N1cRRct2CiBQQFqozBEfdxggerOFBU+GfTG59odG51Yp9nTKY3KvZ1i1Izrh+Ip4ZFT0
         46r4cni/Wcu582O6jhfnuM6JErX8xsFQwAaeJqL0r1oHb95UGl/MxSuwUl0MDxNK1LLW
         8F+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682040; x=1750286840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fjGDTFzoOPTHOIiqFgNMI96VBH4N7QEJybjbvNpN00c=;
        b=jRbE5Evrn0TRcCs4wQ+jE3ZGJlAskf/6r/UGIubZ5A5d/z5vHu8eLHPOB1/Vim9gkV
         QhO4oghzAvcoTGIPdghpzSGwz9Dj23cWF0NGxF7xyFPK/UPfNWiC+ujn+FvusBGY25tA
         oQ4mjp5eyJWtaXrwQzPWMb+Thv+lRa9bKm8xjjNtDI5jRTZzrKSKZI5qsEMWew9NA7x8
         MDsgSCghgzhGcoSYMc/88rK4zQT6dkqYvD6wz6cH9Y9ff3kuyzu4THSkU87uOPIBDWJe
         vCHuFQ6w/MzPg+odvW5JFjqzkPvuCSe/7IHnw1Oc2NiAMp647LK1+yhH+yRQqLsTZkcR
         XrVA==
X-Forwarded-Encrypted: i=1; AJvYcCUM4kVXh3REghuXtfJrWDY4jZEJ2mXJgVhr/qlzTWrOfwm5qMFQdYmp/R/080GskWufB1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN2P3+DM0ewxaE21WUe0qqOr9taZ6fbvFr5l5KtvJV78ndRsyd
	UjBJppHtuVKZ5ajYEmpfwJgw2BeoHZpJdskXxtn7auEauZFHvcCEStM7jmEmo6x7Vx4ZnpQ7jGq
	c0S7ErQ==
X-Google-Smtp-Source: AGHT+IGecZq8RM5h9tJ+sa6mCIHJXtBSp+Ntypd+iUzFZkPpDRHr5SZ8PChIvutcjWxMiCNgxwsIm8TNC5o=
X-Received: from pfbay26.prod.google.com ([2002:a05:6a00:301a:b0:746:223d:ebdc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:9a3:b0:736:43d6:f008
 with SMTP id d2e1a72fcca58-7486cdf41e9mr7104627b3a.12.1749682040461; Wed, 11
 Jun 2025 15:47:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:17 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-16-seanjc@google.com>
Subject: [PATCH v3 14/62] KVM: SVM: Track AVIC tables as natively sized
 pointers, not "struct pages"
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
2.50.0.rc1.591.g9c95f17f64-goog


