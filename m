Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83D742F91A
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 18:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237693AbhJOQ5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 12:57:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237621AbhJOQ5a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 12:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634316923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Hc2aYnwlYlq/me8gyUtv3dxMsXiZ853XX+/fDSvon+k=;
        b=YbBkvggM1FibKA7C19XVlg45lV26xtmYekIv3CU0MqUcLHBEbpUS8vd5bjZAV770mhUZsY
        WZ/gaqj8MjBL9jCD6adQFGZgCuiGBbSCwBBK7rHxbxc+OHDor1CqVyxArhwixf3VywK+fe
        gzSef4L2gbuBgv5zA269yStglzLEgcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-OCsP1-ydOCa-dESX-B3wig-1; Fri, 15 Oct 2021 12:55:21 -0400
X-MC-Unique: OCsP1-ydOCa-dESX-B3wig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61CD4100D680;
        Fri, 15 Oct 2021 16:55:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0A86B8540;
        Fri, 15 Oct 2021 16:55:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Subject: [PATCH] KVM: replace large kvmalloc allocation with vmalloc
Date:   Fri, 15 Oct 2021 12:55:19 -0400
Message-Id: <20211015165519.135670-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM's paging data structures (especially the rmaps) can be made as
large as possible by userspace simply by creating large-enough memslots.
Since commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
these huge allocations cause a warning, assuming that they could be the
result of an integer overflow or underflow.

Since there are configurations in the wild creating a multi-TiB memslot,
and in fact it is more likely than not that these allocations end up not
using kmalloc-ed memory.  For example, the dirty bitmap for a 64 GiB
memslot would cause a 4 MiB allocation, since each 32 KiB of guest
address space corresponds to 2 bytes in the dirty bitmap.  Therefore,
just use vmalloc directly.  Introduce a new helper vcalloc to check for
overflow for extra paranoia, even though it should not be a problem here
even on 32-bit systems.

Reported-by: syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/page_track.c |  3 +--
 arch/x86/kvm/x86.c            |  4 ++--
 include/linux/vmalloc.h       | 10 ++++++++++
 virt/kvm/kvm_main.c           |  4 ++--
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 21427e84a82e..0d9842472288 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -36,8 +36,7 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
 		slot->arch.gfn_track[i] =
-			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
-				 GFP_KERNEL_ACCOUNT);
+			vcalloc(npages, sizeof(*slot->arch.gfn_track[i]));
 		if (!slot->arch.gfn_track[i])
 			goto track_free;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aabd3a2ec1bc..07f5760ea30c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11394,7 +11394,7 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 
 		WARN_ON(slot->arch.rmap[i]);
 
-		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
+		slot->arch.rmap[i] = vcalloc(lpages, sz);
 		if (!slot->arch.rmap[i]) {
 			memslot_rmap_free(slot);
 			return -ENOMEM;
@@ -11475,7 +11475,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 
 		lpages = __kvm_mmu_slot_lpages(slot, npages, level);
 
-		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
+		linfo = vcalloc(lpages, sizeof(*linfo));
 		if (!linfo)
 			goto out_free;
 
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 671d402c3778..6d51c83c2b0e 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -167,6 +167,16 @@ extern int remap_vmalloc_range_partial(struct vm_area_struct *vma,
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
 
+static inline void *vcalloc(size_t n, size_t size)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+
+	return vzalloc(bytes);
+}
+
 /*
  * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
  * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7851f3a1b5f7..0295d89f5445 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1242,9 +1242,9 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
  */
 static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
-	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
+	unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(memslot);
 
-	memslot->dirty_bitmap = kvzalloc(dirty_bytes, GFP_KERNEL_ACCOUNT);
+	memslot->dirty_bitmap = vcalloc(2, dirty_bytes);
 	if (!memslot->dirty_bitmap)
 		return -ENOMEM;
 
-- 
2.27.0

