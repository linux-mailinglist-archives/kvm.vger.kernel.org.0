Return-Path: <kvm+bounces-18763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0CFB8FB1EC
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF8731C21148
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5918146004;
	Tue,  4 Jun 2024 12:15:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6489B145FF6;
	Tue,  4 Jun 2024 12:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717503307; cv=none; b=K5aqyTpAFLcMjhGRNshWsZ6FrbTdUHDphcg/E6fXacHcbAM0x/92aAeyK3Fthu8j2YNd+8+ZwDh1FDPK071Eoe71z2BrfpZw5gWtEmEYzY8I3bzw5lERXe4GJhtCvmojGJaEoCMRcxySlF8iG9wiFpwVKToHeVqwvxgUrZlzEuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717503307; c=relaxed/simple;
	bh=WFVQjWH0ZoiMDGK+S3K+zIY7KmR/jPZqZ71uWqigK70=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fW2+FXujkGYgRXKEEJQAlVYsShIBfA1d4QpvYe2vTVzU9SGdsRz9DQiG+kK01v9IbcjekghhKc0Hb4HLo/qLc9wknuYxrkFAW1SFxIji/dlKMN5/eAjSmuYpEk8zNBqrfVEu1pKswmbI0ou53jbSau/CdQFzmKGkQYFNybFdN3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxSupGBV9mXmEDAA--.14543S3;
	Tue, 04 Jun 2024 20:15:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDMdGBV9mFzkUAA--.50896S2;
	Tue, 04 Jun 2024 20:15:02 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: KVM: Discard dirty page tracking on readonly memslot
Date: Tue,  4 Jun 2024 20:15:02 +0800
Message-Id: <20240604121502.1985410-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxDMdGBV9mFzkUAA--.50896S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

For readonly memslot such as UEFI bios or UEFI var space, guest can
not write this memory space directly. So it is not necessary to track
dirty pages for readonly memslot. Here there is such optimization
in function kvm_arch_commit_memory_region().

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/mmu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 98883aa23ab8..ec8c43aad724 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -444,6 +444,17 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	int needs_flush;
+	u32 old_flags = old ? old->flags : 0;
+	u32 new_flags = new ? new->flags : 0;
+	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
+
+	/* only track memslot flags changed */
+	if (change != KVM_MR_FLAGS_ONLY)
+		return;
+
+	/* Discard dirty page tracking on readonly memslot */
+	if ((old_flags & new_flags) & KVM_MEM_READONLY)
+		return;
 
 	/*
 	 * If dirty page logging is enabled, write protect all pages in the slot
@@ -454,9 +465,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * MOVE/DELETE:	The old mappings will already have been cleaned up by
 	 *		kvm_arch_flush_shadow_memslot()
 	 */
-	if (change == KVM_MR_FLAGS_ONLY &&
-	    (!(old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
-	     new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
+	if (!(old_flags & KVM_MEM_LOG_DIRTY_PAGES) && log_dirty_pages) {
 		spin_lock(&kvm->mmu_lock);
 		/* Write protect GPA page table entries */
 		needs_flush = kvm_mkclean_gpa_pt(kvm, new->base_gfn,

base-commit: 2ab79514109578fc4b6df90633d500cf281eb689
-- 
2.39.3


