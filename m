Return-Path: <kvm+bounces-7134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A6C83D7BB
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 11:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F35531C2B5DA
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1096DD1F;
	Fri, 26 Jan 2024 09:41:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB94C1B7F9;
	Fri, 26 Jan 2024 09:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706262062; cv=none; b=pXG5EWwSlt4cQADIXWQkqjvbWJJXc3S8Mj7tF19WjwHQk3pdmnjpEpdUn+aSGraRYFvFztoOcV3tFNRCmCg5gIfpbumCRLvklpToQW0U/SwnbjZVmfXfttjMGoLdUiUClOtOcX4GTG9/32dHjbxs0azcsKw0AQRcBAkDX5XkeUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706262062; c=relaxed/simple;
	bh=TXRpBSVjCJUcc+Ou62Ur6MM+Di8M71iBf31d0N8EyxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCZ7edqunJ7PQ7NVv5rtxMJaXCLZCw1XX59qbHWdFQC/FoqjGO52QU87TQdIJEGiDUNgpp6oFTlTi7Xv5crzmp0URBa4yjT3t4R/jONTyQLBIDvp4cVkbK2Pz9n2ENRdeuSNZyes8X+cCpTv5xBYd1V8R4RZCn+Ky5yhg4xjfZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: by air.basealt.ru (Postfix, from userid 490)
	id DA8152F2023B; Fri, 26 Jan 2024 09:40:50 +0000 (UTC)
X-Spam-Level: 
Received: from shell.ipa.basealt.ru (unknown [176.12.98.74])
	by air.basealt.ru (Postfix) with ESMTPSA id 17CBB2F2024B;
	Fri, 26 Jan 2024 09:40:25 +0000 (UTC)
From: oficerovas@altlinux.org
To: oficerovas@altlinux.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kovalev@altlinux.org
Subject: [PATCH 2/2] KVM: use __vcalloc for very large allocations
Date: Fri, 26 Jan 2024 12:40:23 +0300
Message-ID: <20240126094023.2677376-3-oficerovas@altlinux.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240126094023.2677376-1-oficerovas@altlinux.org>
References: <20240126094023.2677376-1-oficerovas@altlinux.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexander Ofitserov <oficerovas@altlinux.org>

From: Paolo Bonzini <pbonzini@redhat.com>

commit 37b2a6510a48 ("KVM: use __vcalloc for very large allocations")

Allocations whose size is related to the memslot size can be arbitrarily
large.  Do not use kvzalloc/kvcalloc, as those are limited to "not crazy"
sizes that fit in 32 bits.

URL: https://lore.kernel.org/lkml/20220711090606.962822924@linuxfoundation.org/
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexander Ofitserov <oficerovas@altlinux.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 2 +-
 arch/x86/kvm/mmu/page_track.c      | 2 +-
 arch/x86/kvm/x86.c                 | 4 ++--
 virt/kvm/kvm_main.c                | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 3dd58b4ee33e5..5f6b3f80023de 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -250,7 +250,7 @@ int kvmppc_uvmem_slot_init(struct kvm *kvm, const struct kvm_memory_slot *slot)
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
-	p->pfns = vzalloc(array_size(slot->npages, sizeof(*p->pfns)));
+	p->pfns = vcalloc(slot->npages, sizeof(*p->pfns));
 	if (!p->pfns) {
 		kfree(p);
 		return -ENOMEM;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 81cf4babbd0b4..3c379335ea477 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -35,7 +35,7 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
 		slot->arch.gfn_track[i] =
-			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
+			__vcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
 				 GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.gfn_track[i])
 			goto track_free;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13e4699a0744f..6c2bf7cd7aec6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10826,14 +10826,14 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 				      slot->base_gfn, level) + 1;
 
 		slot->arch.rmap[i] =
-			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
+			__vcalloc(lpages, sizeof(*slot->arch.rmap[i]),
 				 GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i])
 			goto out_free;
 		if (i == 0)
 			continue;
 
-		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
+		linfo = __vcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
 			goto out_free;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 356fd5d1a4285..b7638c3c9eb7d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1008,9 +1008,9 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
  */
 static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
-	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
+	unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(memslot);
 
-	memslot->dirty_bitmap = kvzalloc(dirty_bytes, GFP_KERNEL_ACCOUNT);
+	memslot->dirty_bitmap = __vcalloc(2, dirty_bytes, GFP_KERNEL_ACCOUNT);
 	if (!memslot->dirty_bitmap)
 		return -ENOMEM;
 
-- 
2.42.1


