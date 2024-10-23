Return-Path: <kvm+bounces-29475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9A59AC38E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DFD0281263
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 09:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50F619CC04;
	Wed, 23 Oct 2024 09:19:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91F21991BF
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 09:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729675154; cv=none; b=IO+us5IxID6cfTQq6HW/i8re3fjGHnAIWlaXVnhHhjWnpdlZUl/m4NLtTViw+KhoaRiY5x2mfKuHC6hJHWVGgQ+Bin9QIzhrqH3++gaVBs6PE7Wla606x/bbmKkP243SNd5NPgQW/9FfJc7D+VDT4G+HzXDyVEFe6LEef5yHisI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729675154; c=relaxed/simple;
	bh=fF9G8FDgV6jfOkCZC3L2zuckGxN2PD1dlYDrow49Qp4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZkMLr/V6VZNrZ6jkb2GZPrc8/wMxMLJaUafd9RxcxyHRPQd0VtL7vfX6eSpCGEQd+JpT2atsBv67gSqOIMNXXO9QZMAHP3Qg3EsMu4EaBDrmdu+KM/EjLyLvLzccbfSofNMsBhZ3tLekv+hkCDBiqNLMNLMEjWpOfFk8kJmUyOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=silver.spittel.net; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=silver.spittel.net
Received: from [10.42.0.1] (helo=silver)
	by mediconcil.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <kauer@silver.spittel.net>)
	id 1t3XWF-004S85-1R;
	Wed, 23 Oct 2024 11:19:07 +0200
Received: from kauer by silver with local (Exim 4.98)
	(envelope-from <kauer@silver.spittel.net>)
	id 1t3XWF-00000009bfv-05wJ;
	Wed, 23 Oct 2024 11:19:07 +0200
From: Bernhard Kauer <bk@alpico.io>
To: kvm@vger.kernel.org
Cc: Bernhard Kauer <bk@alpico.io>
Subject: [PATCH] KVM: x86: Fast forward the iterator when zapping the TDP MMU
Date: Wed, 23 Oct 2024 11:18:38 +0200
Message-ID: <20241023091902.2289764-1-bk@alpico.io>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zapping a root means scanning for present entries in a page-table
hierarchy. This process is relatively slow since it needs to be
preemtible as millions of entries might be processed.

Furthermore the root-page is traversed multiple times as zapping
is done with increasing page-sizes.

Optimizing for the not-present case speeds up the hello microbenchmark
by 115 microseconds.

Signed-off-by: Bernhard Kauer <bk@alpico.io>
---
 arch/x86/kvm/mmu/tdp_iter.h | 21 +++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 2880fd392e0c..7ad28ac2c6b8 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -130,6 +130,27 @@ struct tdp_iter {
 #define for_each_tdp_pte(iter, root, start, end) \
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
 
+
+/*
+ * Skip up to count not present entries of the iterator. Returns true
+ * if the final entry is not present.
+ */
+static inline bool tdp_iter_skip_not_present(struct tdp_iter *iter, int count)
+{
+	int i;
+	int pos;
+
+	pos = SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
+	count = min(count, SPTE_ENT_PER_PAGE - 1 - pos);
+	for (i = 0; i < count && !is_shadow_present_pte(iter->old_spte); i++)
+		iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep + i + 1);
+
+	iter->gfn += i * KVM_PAGES_PER_HPAGE(iter->level);
+	iter->next_last_level_gfn = iter->gfn;
+	iter->sptep += i;
+	return !is_shadow_present_pte(iter->old_spte);
+}
+
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1951f76db657..404726511f95 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -750,7 +750,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte))
+		if (tdp_iter_skip_not_present(&iter, 32))
 			continue;
 
 		if (iter.level > zap_level)
-- 
2.45.2


