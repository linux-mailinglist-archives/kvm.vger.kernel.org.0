Return-Path: <kvm+bounces-20367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D4BE291435B
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:15:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8ACDE1F23EA0
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 07:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36A2761FD0;
	Mon, 24 Jun 2024 07:14:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CA03C684;
	Mon, 24 Jun 2024 07:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719213269; cv=none; b=f7/KPaiuD42TNoI2tpGsnFxDdZ1jitwvJ1MtMiUFP9m1ZocRrmz7QlZIt3cSrxKIJUpLWQZaovHB1G1cRNZs+6oSihbrr6oPESGt/ixEBDa6+d3hQjGJOsY1X2kBy/6eNarIkdlyMaVm9e4rLjyjOxc2WZegicORs8Cjr1BrqUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719213269; c=relaxed/simple;
	bh=p4K7YFd9BlwS4GqQ12d7WLwQ1xvfFQEqslZSuqL+560=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XSBjbGkIyguy9kCiHVUeZMYxqmaPE9emmtrmEQfA47CKI0+vKxcLHP9NcRf0K6LbGCcatFkCqDNPgVz/zuOAuSFggA2ol5fcfCBGg94jglSrRcBEo/Hw0jVyXPc4Hdfq7sPf1yHrn1nfuo3ft3fHMIcUke8eZuVLZ5DSjhB29Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Ax3erQHHlmEXEJAA--.38154S3;
	Mon, 24 Jun 2024 15:14:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxMMTPHHlmftsuAA--.9847S5;
	Mon, 24 Jun 2024 15:14:24 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Rui <wangrui@loongson.cn>
Subject: [PATCH v3 3/7] LoongArch: KVM: Discard dirty page tracking on readonly memslot
Date: Mon, 24 Jun 2024 15:14:18 +0800
Message-Id: <20240624071422.3473789-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240624071422.3473789-1-maobibo@loongson.cn>
References: <20240624071422.3473789-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxMMTPHHlmftsuAA--.9847S5
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
index c6351d13ca1b..1690828bd44b 100644
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
-- 
2.39.3


