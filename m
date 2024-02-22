Return-Path: <kvm+bounces-9403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCEE785FDBA
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 17:12:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AD04281B61
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 16:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8A71509AF;
	Thu, 22 Feb 2024 16:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NuTnCm0q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489DA153517
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618271; cv=none; b=JDCivvvhFjH8RTY+zTATbT6nRyvk0L0Vs82AszC22zDqf3PIZFVSBqwhjZSz4x9jM635Dekl4AbxHbJ2F5/JO2kgWip4Kdc2j90UuganklA9KE8PSPzjVOlqLDbeI+fi6hUOQDrddpTsbQcAio2zeuQM7CmFhKpgQ9MxAilhavc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618271; c=relaxed/simple;
	bh=307wRd3a0Gu+2jPkCXpx//8T+nAN9ErEfklgaiaAxPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cahQZpDI3/efpeAF07JqAgTSogNffVmShEvnCHl4rbCsc1gymlXnAazxk9YRVx3mLnLmaD4d84IoaWCt9CwC8qzify+bA3RQQIkz6CBimyvorJ1NbAhIA/lUZhbqd38vHHyCwZG2KP1BUzq6WG2ra7BYGln2qAPogNSfnJSHMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NuTnCm0q; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41082621642so42462885e9.1
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 08:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618267; x=1709223067; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FNzzZH63lKYNBuTHaseubTbAwMOeT2CF2+7V/cVEfrs=;
        b=NuTnCm0qCsxGHfLyug56dbIyHO9byCkpTYY3H7ypOcxmmfQUCsW3wQWZLo9YPmKFAr
         OQHT0IstmUg88X8HlmJjU+4CBy9xD6HWCvBdf3uaRZZ7uUBiJ+1EpbhFqXJxjaea70c3
         od2YNcbSQ7QRZVjO35B8lZ7QTidw+vx+9qw35JhlnlqNj4aTf/SCCHpXuDg5TTk5LrI9
         iUb0Ewf5XxOrn5kN9Osf2G6NVVQS5TP1bTi7o42nVJ+3hX1Ygtmq6uuG7PT9EkPa9oH+
         Zk2qzLnFG3Ke8cLZUNC/hFdn49wFQMTq+VeX1KBL1WIjSBkLrFtIKlO69kgL+uOTZeHF
         RCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618267; x=1709223067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FNzzZH63lKYNBuTHaseubTbAwMOeT2CF2+7V/cVEfrs=;
        b=uUKfnEwUEpayses2mmSqy9BTzkFQ8DS7QfMlp9KRmvI8+HGcwrSKX/iheb4V5lFswG
         Uetdn9iGKG/RRGXjVv6yUWwquv9HN0XdeVspKEDsrmRwnx3DHWhWAmycuKau1oJfaSdl
         K6GVU9E8pZ8dOsLsFDJKs8/nLdJzhYP7CqdGz7ftmvGmKH32KGE1BCpxoqxYA+XX8pU9
         hT+gzpBbXVhcjStU+pozMqSziZhIDB74lG02u1DQ+7PlT+u+Lv+4Jqi+tmKHS7GnqUz2
         4igPCf2xyNkPGeFZiDPkK7ipQ+HYz4vkuTsBRUTj1WMarutoT0CMBtkNHQni3hs3lWpp
         Ehxw==
X-Gm-Message-State: AOJu0Yw4RAccsuaQMZBUiejQ8RzrfS2KCgZ+7Aa5zHvw/WDs34RgC/Cs
	icSC4Hn/8LKT1KNtx2btPo3QsLdGk3URBl1n9frmD0i7XHyXUF492kfPTC0ZH871O37Gm0kbis7
	c28kwrRX4RVtajEQZRlSpNhB/npvUawyxsYRsDYEWtNhS89J278RaeHXqehHEZvdq7jjAhMSKp9
	GZ4Sp/xUDHBgVRmCcltX5olG8=
X-Google-Smtp-Source: AGHT+IF1jnkomd+1xe0eYCGjm0e0odW61OHzS3zTMn83kYMemPKodA3UWn5V1pKZgKWIx25dpZtQqBGvmw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:783:b0:33d:60c4:5f5f with SMTP id
 bu3-20020a056000078300b0033d60c45f5fmr29858wrb.7.1708618267415; Thu, 22 Feb
 2024 08:11:07 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:28 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-8-tabba@google.com>
Subject: [RFC PATCH v1 07/26] KVM: arm64: Turn llist of pinned pages into an rb-tree
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

Indexed by IPA, so we can efficiently lookup.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++--
 arch/arm64/kvm/mmu.c              | 30 ++++++++++++++++++++++++++----
 arch/arm64/kvm/pkvm.c             | 12 +++++++-----
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2777b0fe1b12..55de71791233 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -207,8 +207,9 @@ struct kvm_smccc_features {
 };
 
 struct kvm_pinned_page {
-	struct list_head	link;
+	struct rb_node		node;
 	struct page		*page;
+	u64			ipa;
 };
 
 typedef unsigned int pkvm_handle_t;
@@ -216,7 +217,7 @@ typedef unsigned int pkvm_handle_t;
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
 	struct kvm_hyp_memcache teardown_mc;
-	struct list_head pinned_pages;
+	struct rb_root pinned_pages;
 	bool enabled;
 };
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ac088dc198e6..f796e092a921 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -337,6 +337,7 @@ static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 si
 static void pkvm_stage2_flush(struct kvm *kvm)
 {
 	struct kvm_pinned_page *ppage;
+	struct rb_node *node;
 
 	/*
 	 * Contrary to stage2_apply_range(), we don't need to check
@@ -344,7 +345,8 @@ static void pkvm_stage2_flush(struct kvm *kvm)
 	 * from a vcpu thread, and the list is only ever freed on VM
 	 * destroy (which only occurs when all vcpu are gone).
 	 */
-	list_for_each_entry(ppage, &kvm->arch.pkvm.pinned_pages, link) {
+	for (node = rb_first(&kvm->arch.pkvm.pinned_pages); node; node = rb_next(node)) {
+		ppage = rb_entry(node, struct kvm_pinned_page, node);
 		__clean_dcache_guest_page(page_address(ppage->page), PAGE_SIZE);
 		cond_resched_rwlock_write(&kvm->mmu_lock);
 	}
@@ -913,7 +915,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	mmu->vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
-	INIT_LIST_HEAD(&kvm->arch.pkvm.pinned_pages);
+	kvm->arch.pkvm.pinned_pages = RB_ROOT;
 	mmu->arch = &kvm->arch;
 
 	if (is_protected_kvm_enabled())
@@ -1412,6 +1414,26 @@ static int pkvm_host_map_guest(u64 pfn, u64 gfn)
 	return (ret == -EPERM) ? -EAGAIN : ret;
 }
 
+static int cmp_ppages(struct rb_node *node, const struct rb_node *parent)
+{
+	struct kvm_pinned_page *a = container_of(node, struct kvm_pinned_page, node);
+	struct kvm_pinned_page *b = container_of(parent, struct kvm_pinned_page, node);
+
+	if (a->ipa < b->ipa)
+		return -1;
+	if (a->ipa > b->ipa)
+		return 1;
+	return 0;
+}
+
+static int insert_ppage(struct kvm *kvm, struct kvm_pinned_page *ppage)
+{
+	if (rb_find_add(&ppage->node, &kvm->arch.pkvm.pinned_pages, cmp_ppages))
+		return -EEXIST;
+
+	return 0;
+}
+
 static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot)
 {
@@ -1479,8 +1501,8 @@ static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	ppage->page = page;
-	INIT_LIST_HEAD(&ppage->link);
-	list_add(&ppage->link, &kvm->arch.pkvm.pinned_pages);
+	ppage->ipa = fault_ipa;
+	WARN_ON(insert_ppage(kvm, ppage));
 	write_unlock(&kvm->mmu_lock);
 
 	return 0;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 10a619b257c4..11355980e18d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -246,9 +246,9 @@ static bool pkvm_teardown_vm(struct kvm *host_kvm)
 
 void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 {
-	struct kvm_pinned_page *ppage, *tmp;
+	struct kvm_pinned_page *ppage;
 	struct mm_struct *mm = current->mm;
-	struct list_head *ppages;
+	struct rb_node *node;
 	unsigned long pages = 0;
 
 	if (!pkvm_teardown_vm(host_kvm))
@@ -256,14 +256,16 @@ void pkvm_destroy_hyp_vm(struct kvm *host_kvm)
 
 	free_hyp_memcache(&host_kvm->arch.pkvm.teardown_mc);
 
-	ppages = &host_kvm->arch.pkvm.pinned_pages;
-	list_for_each_entry_safe(ppage, tmp, ppages, link) {
+	node = rb_first(&host_kvm->arch.pkvm.pinned_pages);
+	while (node) {
+		ppage = rb_entry(node, struct kvm_pinned_page, node);
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_reclaim_page,
 					  page_to_pfn(ppage->page)));
 		cond_resched();
 
 		unpin_user_pages_dirty_lock(&ppage->page, 1, true);
-		list_del(&ppage->link);
+		node = rb_next(node);
+		rb_erase(&ppage->node, &host_kvm->arch.pkvm.pinned_pages);
 		kfree(ppage);
 		pages++;
 	}
-- 
2.44.0.rc1.240.g4c46232300-goog


