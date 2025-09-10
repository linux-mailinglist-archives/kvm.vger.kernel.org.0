Return-Path: <kvm+bounces-57175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6795B50F14
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBF821C81692
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 07:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36B2D30B515;
	Wed, 10 Sep 2025 07:14:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A0123081D0;
	Wed, 10 Sep 2025 07:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757488483; cv=none; b=mOjD8PEQuC7sU6H2eP/7R8oawBAYD5Eh1pCZnuCMO29oFcUFQ8oNUWl819/n2CTX45LMhruY2wEkG2r07XorZQNWn0S6bt0jRt2y5KiX5nG8ACn3ZwqiM+wq9P1B4Z92ewRZ87jGfJnjDK4QdDIe95VLXX+bJYvbKo4MYoffxr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757488483; c=relaxed/simple;
	bh=xLA71r6c4GbYPtkzPxfvjMrHMJLa5QUEkYcbkv1pbkw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sjBcPZekcSgwFtb6CCniphhlSsGL8QYRhVdEzeff1Mk1WM2FKttLmlmacPouegXJvbVmRs1FZUpSujUiDRF/VxBo2YLJN+qfmCbrTVQtUv751g80Xkuy9P/gWhVajwRztT6EGTWqANl1FgmbaQIJ2sfA5szryriWqKmwjKxBEko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx5tBWJcFoc7MIAA--.18528S3;
	Wed, 10 Sep 2025 15:14:30 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxQMJVJcFot5+LAA--.44735S2;
	Wed, 10 Sep 2025 15:14:30 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Fix VM migration failure with PTW enabled
Date: Wed, 10 Sep 2025 15:14:29 +0800
Message-Id: <20250910071429.3925025-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxQMJVJcFot5+LAA--.44735S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With PTW disabled system, bit Dirty is HW bit for page writing, however
with PTW enabled system, bit Write is HW bit for page writing. Previously
bit Write is treated as SW bit to record page writable attribute for fast
page fault handling in the secondary MMU, however with PTW enabled machine,
this bit is used by HW already.

Here define KVM_PAGE_SOFT_WRITE with SW bit _PAGE_MODIFIED, so that it can
work on both PTW disabled and enabled machines. And with HW write bit, both
bit Dirty and Write is set or clear.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_mmu.h | 20 ++++++++++++++++----
 arch/loongarch/kvm/mmu.c             |  8 ++++----
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_mmu.h b/arch/loongarch/include/asm/kvm_mmu.h
index 099bafc6f797..efcd593c42b1 100644
--- a/arch/loongarch/include/asm/kvm_mmu.h
+++ b/arch/loongarch/include/asm/kvm_mmu.h
@@ -16,6 +16,13 @@
  */
 #define KVM_MMU_CACHE_MIN_PAGES	(CONFIG_PGTABLE_LEVELS - 1)
 
+/*
+ * _PAGE_MODIFIED is SW pte bit, it records page ever written on host
+ * kernel, on secondary MMU it records page writable in order to fast
+ * path handling
+ */
+#define KVM_PAGE_SOFT_WRITE	_PAGE_MODIFIED
+
 #define _KVM_FLUSH_PGTABLE	0x1
 #define _KVM_HAS_PGMASK		0x2
 #define kvm_pfn_pte(pfn, prot)	(((pfn) << PFN_PTE_SHIFT) | pgprot_val(prot))
@@ -52,11 +59,16 @@ static inline void kvm_set_pte(kvm_pte_t *ptep, kvm_pte_t val)
 	WRITE_ONCE(*ptep, val);
 }
 
-static inline int kvm_pte_write(kvm_pte_t pte) { return pte & _PAGE_WRITE; }
-static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & _PAGE_DIRTY; }
+static inline int kvm_pte_soft_write(kvm_pte_t pte) { return pte & KVM_PAGE_SOFT_WRITE; }
+static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & __WRITEABLE; }
 static inline int kvm_pte_young(kvm_pte_t pte) { return pte & _PAGE_ACCESSED; }
 static inline int kvm_pte_huge(kvm_pte_t pte) { return pte & _PAGE_HUGE; }
 
+static inline kvm_pte_t kvm_pte_mksoft_write(kvm_pte_t pte)
+{
+	return pte | KVM_PAGE_SOFT_WRITE;
+}
+
 static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
 {
 	return pte | _PAGE_ACCESSED;
@@ -69,12 +81,12 @@ static inline kvm_pte_t kvm_pte_mkold(kvm_pte_t pte)
 
 static inline kvm_pte_t kvm_pte_mkdirty(kvm_pte_t pte)
 {
-	return pte | _PAGE_DIRTY;
+	return pte | __WRITEABLE;
 }
 
 static inline kvm_pte_t kvm_pte_mkclean(kvm_pte_t pte)
 {
-	return pte & ~_PAGE_DIRTY;
+	return pte & ~__WRITEABLE;
 }
 
 static inline kvm_pte_t kvm_pte_mkhuge(kvm_pte_t pte)
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index ed956c5cf2cc..68749069290f 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -569,7 +569,7 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 	/* Track access to pages marked old */
 	new = kvm_pte_mkyoung(*ptep);
 	if (write && !kvm_pte_dirty(new)) {
-		if (!kvm_pte_write(new)) {
+		if (!kvm_pte_soft_write(new)) {
 			ret = -EFAULT;
 			goto out;
 		}
@@ -856,9 +856,9 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 		prot_bits |= _CACHE_SUC;
 
 	if (writeable) {
-		prot_bits |= _PAGE_WRITE;
+		prot_bits = kvm_pte_mksoft_write(prot_bits);
 		if (write)
-			prot_bits |= __WRITEABLE;
+			prot_bits = kvm_pte_mkdirty(prot_bits);
 	}
 
 	/* Disable dirty logging on HugePages */
@@ -904,7 +904,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	kvm_release_faultin_page(kvm, page, false, writeable);
 	spin_unlock(&kvm->mmu_lock);
 
-	if (prot_bits & _PAGE_DIRTY)
+	if (kvm_pte_dirty(prot_bits))
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
 out:

base-commit: 9dd1835ecda5b96ac88c166f4a87386f3e727bd9
-- 
2.39.3


