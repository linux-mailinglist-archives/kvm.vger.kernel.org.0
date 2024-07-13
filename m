Return-Path: <kvm+bounces-21598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCD793046B
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 10:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08C161C23128
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 08:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E603B3FBA7;
	Sat, 13 Jul 2024 08:00:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cmccmta2.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5CDE1DFE3;
	Sat, 13 Jul 2024 08:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720857637; cv=none; b=tMpOvwMujun9u/bxSrCvXygiuXhWUYenVfodnlvEVvADS8PUN+p7OTCscZiWRajbefdYjQSV0+ZVVrUlczPjXBq6B5J/SJcQijycjUAeqAebAvH7liNJaAfO6Q+2a/Mr0tRyboPckBqpEPE8kQdfyD8ZuudmVk/J6nTZKwjt6ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720857637; c=relaxed/simple;
	bh=hfYPjA00LDasRjY3/gpjinYkFcjZGczV5jqxpJ8QJ1w=;
	h=From:To:Cc:Subject:Date:Message-Id; b=qbDodX7ZwWF/0bNsC0/WLwMzyRij/3Z/lAWUC8EnCwnvfeR+uHr1f2hlEIBuuzyQLkbxjJbJsK0e6co22LH/zRPbndTM9SZRfImabfZNS71S7piBzqffkfkGdc+Ibu4meU7qzUl2lX1vLCyOGvT5bcowufsEai1mGQExXylB7no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee866923415806-7e832;
	Sat, 13 Jul 2024 16:00:21 +0800 (CST)
X-RM-TRANSID:2ee866923415806-7e832
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain.localdomain (unknown[223.108.79.100])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee16692340ccff-6eea7;
	Sat, 13 Jul 2024 16:00:21 +0800 (CST)
X-RM-TRANSID:2ee16692340ccff-6eea7
From: tangbin <tangbin@cmss.chinamobile.com>
To: zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org,
	kernel@xen0n.name
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	tangbin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] LoongArch: KVM: Remove redundant assignment in kvm_map_page_fast
Date: Sat, 13 Jul 2024 11:59:37 -0400
Message-Id: <20240713155937.45261-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

In the function kvm_map_page_fast, the assignment of 'ret' is
redundant, so remove it.

Signed-off-by: tangbin <tangbin@cmss.chinamobile.com>
---
 arch/loongarch/kvm/mmu.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 2634a9e8d..d6c922a4a 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -551,7 +551,6 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
  */
 static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 {
-	int ret = 0;
 	kvm_pfn_t pfn = 0;
 	kvm_pte_t *ptep, changed, new;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
@@ -563,20 +562,16 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 
 	/* Fast path - just check GPA page table for an existing entry */
 	ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
-	if (!ptep || !kvm_pte_present(NULL, ptep)) {
-		ret = -EFAULT;
+	if (!ptep || !kvm_pte_present(NULL, ptep))
 		goto out;
-	}
 
 	/* Track access to pages marked old */
 	new = kvm_pte_mkyoung(*ptep);
 	/* call kvm_set_pfn_accessed() after unlock */
 
 	if (write && !kvm_pte_dirty(new)) {
-		if (!kvm_pte_write(new)) {
-			ret = -EFAULT;
+		if (!kvm_pte_write(new))
 			goto out;
-		}
 
 		if (kvm_pte_huge(new)) {
 			/*
@@ -584,10 +579,8 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 			 * enabled for HugePages
 			 */
 			slot = gfn_to_memslot(kvm, gfn);
-			if (kvm_slot_dirty_track_enabled(slot)) {
-				ret = -EFAULT;
+			if (kvm_slot_dirty_track_enabled(slot))
 				goto out;
-			}
 		}
 
 		/* Track dirtying of writeable pages */
@@ -615,10 +608,10 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 		if (page)
 			put_page(page);
 	}
-	return ret;
+	return 0;
 out:
 	spin_unlock(&kvm->mmu_lock);
-	return ret;
+	return -EFAULT;
 }
 
 static bool fault_supports_huge_mapping(struct kvm_memory_slot *memslot,
-- 
2.18.4




