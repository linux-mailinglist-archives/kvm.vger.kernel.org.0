Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5060A32C61B
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348200AbhCDA1j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348645AbhCCNLG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 08:11:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614776975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6o2+E2BUPKP6kKhfuCvRH5DKgGqm/6fupzoCnbubwEA=;
        b=dQ1QDp4kKtlizVj47I/r7fDNr8rdBZY7xIxZpVfJJ4lVWQTxA0pvbC5zgwbJ8pVQoJzcvu
        OL4PwTiX4l4O6eJUpeFKTOspWPnFCGebnEW477uY9S6d3xJb+hIxF1dObPCHwOcw4m5m7X
        4F8srltTzQznK3iObNUpdrq15T5O8RY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-gcrjp9bGPkah14ORd7l0XQ-1; Wed, 03 Mar 2021 08:09:33 -0500
X-MC-Unique: gcrjp9bGPkah14ORd7l0XQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54759195D561;
        Wed,  3 Mar 2021 13:09:32 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 065D360BFA;
        Wed,  3 Mar 2021 13:09:29 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH v1 2/2] exec: Get rid of phys_mem_set_alloc()
Date:   Wed,  3 Mar 2021 14:09:16 +0100
Message-Id: <20210303130916.22553-3-david@redhat.com>
In-Reply-To: <20210303130916.22553-1-david@redhat.com>
References: <20210303130916.22553-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the last user is gone, we can get rid of phys_mem_set_alloc() and
simplify.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/sysemu/kvm.h |  4 ----
 softmmu/physmem.c    | 36 +++---------------------------------
 2 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 687c598be9..a1ab1ee12d 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -249,10 +249,6 @@ int kvm_update_guest_debug(CPUState *cpu, unsigned long reinject_trap);
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 int kvm_on_sigbus(int code, void *addr);
 
-/* interface with exec.c */
-
-void phys_mem_set_alloc(void *(*alloc)(size_t, uint64_t *align, bool shared));
-
 /* internal API */
 
 int kvm_ioctl(KVMState *s, int type, ...);
diff --git a/softmmu/physmem.c b/softmmu/physmem.c
index 19e0aa9836..141fce79e8 100644
--- a/softmmu/physmem.c
+++ b/softmmu/physmem.c
@@ -1144,19 +1144,6 @@ static int subpage_register(subpage_t *mmio, uint32_t start, uint32_t end,
                             uint16_t section);
 static subpage_t *subpage_init(FlatView *fv, hwaddr base);
 
-static void *(*phys_mem_alloc)(size_t size, uint64_t *align, bool shared) =
-                               qemu_anon_ram_alloc;
-
-/*
- * Set a custom physical guest memory alloator.
- * Accelerators with unusual needs may need this.  Hopefully, we can
- * get rid of it eventually.
- */
-void phys_mem_set_alloc(void *(*alloc)(size_t, uint64_t *align, bool shared))
-{
-    phys_mem_alloc = alloc;
-}
-
 static uint16_t phys_section_add(PhysPageMap *map,
                                  MemoryRegionSection *section)
 {
@@ -1962,8 +1949,9 @@ static void ram_block_add(RAMBlock *new_block, Error **errp, bool shared)
                 return;
             }
         } else {
-            new_block->host = phys_mem_alloc(new_block->max_length,
-                                             &new_block->mr->align, shared);
+            new_block->host = qemu_anon_ram_alloc(new_block->max_length,
+                                                  &new_block->mr->align,
+                                                  shared);
             if (!new_block->host) {
                 error_setg_errno(errp, errno,
                                  "cannot set up guest memory '%s'",
@@ -2047,17 +2035,6 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
         return NULL;
     }
 
-    if (phys_mem_alloc != qemu_anon_ram_alloc) {
-        /*
-         * file_ram_alloc() needs to allocate just like
-         * phys_mem_alloc, but we haven't bothered to provide
-         * a hook there.
-         */
-        error_setg(errp,
-                   "-mem-path not supported with this accelerator");
-        return NULL;
-    }
-
     size = HOST_PAGE_ALIGN(size);
     file_size = get_file_size(fd);
     if (file_size > 0 && file_size < size) {
@@ -2247,13 +2224,6 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                     area = mmap(vaddr, length, PROT_READ | PROT_WRITE,
                                 flags, block->fd, offset);
                 } else {
-                    /*
-                     * Remap needs to match alloc.  Accelerators that
-                     * set phys_mem_alloc never remap.  If they did,
-                     * we'd need a remap hook here.
-                     */
-                    assert(phys_mem_alloc == qemu_anon_ram_alloc);
-
                     flags |= MAP_PRIVATE | MAP_ANONYMOUS;
                     area = mmap(vaddr, length, PROT_READ | PROT_WRITE,
                                 flags, -1, 0);
-- 
2.29.2

