Return-Path: <kvm+bounces-19936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AAE690E540
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 10:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F4E21C21CCB
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB7B7D07E;
	Wed, 19 Jun 2024 08:09:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B122378B4E;
	Wed, 19 Jun 2024 08:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718784592; cv=none; b=cF0PMPyNocqNMBfjl+70yCPUqKNJigQePUSgPkHn5y8Qfi7pyR4zddCkGovOfBt4iROWU2t4dMr81KLi2LrN4dRCt58FGnxeP7fFkVzDWYgCte83c3PR+iXxwHiV0tj4qG9lMyMKwyrT1xu1eYsA7DGL5M3Zg3OoWRMVpGN60A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718784592; c=relaxed/simple;
	bh=VRGsuynlLOX3I/Mr6W6BKVr5Su0ws2ApaNc7yn8Faz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uq/Iqm62hEKaPzzGpFLsFE6b0fGLO+buNC7bv8Cl+ASlG3TOgf3Ar7tM7nO4swMphHStia3W1Njo/Hd7fSQAAEUrPXjGy7uWCdRVh9vFtL0KMW/8sjBlSeNRa6k7KTjuXM02U0i/lwPoDVWdf+RGADWjebk1QNFw72XCLiAU6A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxrOpGknJm5y4IAA--.32926S3;
	Wed, 19 Jun 2024 16:09:42 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxjsdEknJmFeMoAA--.32907S4;
	Wed, 19 Jun 2024 16:09:41 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] LoongArch: KVM: Select huge page only if secondary mmu supports it
Date: Wed, 19 Jun 2024 16:09:36 +0800
Message-Id: <20240619080940.2690756-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240619080940.2690756-1-maobibo@loongson.cn>
References: <20240619080940.2690756-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxjsdEknJmFeMoAA--.32907S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Currently page level selection about secondary mmu depends on memory
slot and page level about host mmu. There will be problem if page level
of secondary mmu is zero already. So page level selection should depend
on the following three conditions.
 1. Memslot is aligned for huge page and vm is not migrating.
 2. Page level of host mmu is huge page also.
 3. Page level of secondary mmu is suituable for huge page, it cannot
be normal page since it is not supported to merge normal pages into
huge page now.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/include/asm/kvm_mmu.h |  2 +-
 arch/loongarch/kvm/mmu.c             | 16 +++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/kvm_mmu.h b/arch/loongarch/include/asm/kvm_mmu.h
index 099bafc6f797..d06ae0e0dde5 100644
--- a/arch/loongarch/include/asm/kvm_mmu.h
+++ b/arch/loongarch/include/asm/kvm_mmu.h
@@ -55,7 +55,7 @@ static inline void kvm_set_pte(kvm_pte_t *ptep, kvm_pte_t val)
 static inline int kvm_pte_write(kvm_pte_t pte) { return pte & _PAGE_WRITE; }
 static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & _PAGE_DIRTY; }
 static inline int kvm_pte_young(kvm_pte_t pte) { return pte & _PAGE_ACCESSED; }
-static inline int kvm_pte_huge(kvm_pte_t pte) { return pte & _PAGE_HUGE; }
+static inline int kvm_pte_huge(kvm_pte_t pte)  { return !!(pte & _PAGE_HUGE); }
 
 static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
 {
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 9e39d28fec35..c6351d13ca1b 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -858,10 +858,20 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 
 	/* Disable dirty logging on HugePages */
 	level = 0;
-	if (!fault_supports_huge_mapping(memslot, hva, write)) {
-		level = 0;
-	} else {
+	if (fault_supports_huge_mapping(memslot, hva, write)) {
+		/* Check page level about host mmu*/
 		level = host_pfn_mapping_level(kvm, gfn, memslot);
+		if (level == 1) {
+			/*
+			 * Check page level about secondary mmu
+			 * Disable hugepage if it is normal page on
+			 * secondary mmu already
+			 */
+			ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
+			if (ptep && !kvm_pte_huge(*ptep))
+				level = 0;
+		}
+
 		if (level == 1) {
 			gfn = gfn & ~(PTRS_PER_PTE - 1);
 			pfn = pfn & ~(PTRS_PER_PTE - 1);
-- 
2.39.3


