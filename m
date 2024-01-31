Return-Path: <kvm+bounces-7522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B93C8432AB
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 02:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 678921C24F60
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 01:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD9E15D0;
	Wed, 31 Jan 2024 01:24:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from njjs-sys-mailin01.njjs.baidu.com (mx314.baidu.com [180.101.52.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D7F136A
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 01:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.101.52.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706664257; cv=none; b=ipItUyABPYJARUevga7tc2q8YnslxWZ5R08hDfcRgi5dMJrjGIgnU7IDimJ+g1ajThgmOdk7JABg9Wt7W8/wIF6Jds7c+xx8fgQd55k33ZAzjiXEgBAEtlzyItgMQQYOTBXz1jKK+5NZsbXYpAI29hshv0vqBGZNbAtF86BtUpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706664257; c=relaxed/simple;
	bh=3/S6jZfIc/BGNxf7UMku7UyfaYbxr/qSvNGxLCQqCls=;
	h=From:To:Cc:Subject:Date:Message-Id; b=OWwROSEPYeVoUTa9l2k7GLAcyE+sjoPwS/tSYcUI7hRSBp2lE4HAwAyigHMI3lZ6tuwcyy7TerwQhe9m03sJhOL5fwWpg32kNw7HRF4IeW+zDj6p4mC1g5iXKd2qDeSWgxWcKtsDjemQZ1swfhjdYn4aotqqYhHOLUc5fnEEFmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=180.101.52.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Received: from localhost (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
	by njjs-sys-mailin01.njjs.baidu.com (Postfix) with ESMTP id 4D5877F00044;
	Wed, 31 Jan 2024 09:24:06 +0800 (CST)
From: Li RongQing <lirongqing@baidu.com>
To: kvm@vger.kernel.org
Cc: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] KVM: use vfree for memory allocated by vcalloc/__vcalloc
Date: Wed, 31 Jan 2024 09:23:57 +0800
Message-Id: <20240131012357.53563-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

commit 37b2a6510a48("KVM: use __vcalloc for very large allocations")
replaced kvzalloc/kvcalloc with vcalloc, but not replace kvfree with
vfree

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/mmu/page_track.c | 2 +-
 arch/x86/kvm/x86.c            | 6 +++---
 virt/kvm/kvm_main.c           | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index c87da11..6faed29 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -28,7 +28,7 @@ bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
 
 void kvm_page_track_free_memslot(struct kvm_memory_slot *slot)
 {
-	kvfree(slot->arch.gfn_write_track);
+	vfree(slot->arch.gfn_write_track);
 	slot->arch.gfn_write_track = NULL;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 363b1c080..a1f9fe6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12711,7 +12711,7 @@ static void memslot_rmap_free(struct kvm_memory_slot *slot)
 	int i;
 
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
-		kvfree(slot->arch.rmap[i]);
+		vfree(slot->arch.rmap[i]);
 		slot->arch.rmap[i] = NULL;
 	}
 }
@@ -12723,7 +12723,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	memslot_rmap_free(slot);
 
 	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
-		kvfree(slot->arch.lpage_info[i - 1]);
+		vfree(slot->arch.lpage_info[i - 1]);
 		slot->arch.lpage_info[i - 1] = NULL;
 	}
 
@@ -12815,7 +12815,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 	memslot_rmap_free(slot);
 
 	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
-		kvfree(slot->arch.lpage_info[i - 1]);
+		vfree(slot->arch.lpage_info[i - 1]);
 		slot->arch.lpage_info[i - 1] = NULL;
 	}
 	return -ENOMEM;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88..4f98557 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1018,7 +1018,7 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 	if (!memslot->dirty_bitmap)
 		return;
 
-	kvfree(memslot->dirty_bitmap);
+	vfree(memslot->dirty_bitmap);
 	memslot->dirty_bitmap = NULL;
 }
 
-- 
2.9.4


