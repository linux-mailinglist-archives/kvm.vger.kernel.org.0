Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AEA2333B1
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 16:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgG3N7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 09:59:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28700 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728462AbgG3N7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 09:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596117581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QVsnilQZ1vhpy0OO9SwSmJY9XUdq3f2mYSRQhQYQpd0=;
        b=YdYLuZT6wlqDhaAorL1Aq2nTfmIhFddkSBZ0OTTRA6tJ6oAxJ09IQtT6xbbP5tvzRqtAij
        Lxveh6O2SbQrbcoIIhWm4kTopSDaWbRbWB03Yn188IBfZGH2NKsmxhcte0aWQoPByfoGrh
        +NANnXR9k9BEVEgwiW/ThjDLeAtuzjY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-1Mc-v9YmPR-LOu4Co5zOLA-1; Thu, 30 Jul 2020 09:59:39 -0400
X-MC-Unique: 1Mc-v9YmPR-LOu4Co5zOLA-1
Received: by mail-wm1-f72.google.com with SMTP id a5so2266663wmj.5
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 06:59:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QVsnilQZ1vhpy0OO9SwSmJY9XUdq3f2mYSRQhQYQpd0=;
        b=ab2Rlvc7EPsEfXOdG7h6mZxi8pUdtW0LZ+7s4LV1uW/0tZ/RhyfcVzngVZsRzfRNrr
         xhOBtbW6ZPTUT31KeubfYLaeIo2laXwTtp3D0SGAPPtLSW8mSHacgE5V2oexdMCo0aVi
         lNxam0eNkIWmmbAhQ0i85oKhgscVcsiTbphivTIj0EWVtaRvFbGH5tsuhzut7G2elRzl
         pwBEpy1Gks6e8ivsi0PHhnvUcjQBKU3kJ6/n0aXoMuCjkFRYI9lnfiec0Bk0eBnlqwk7
         WiQSu2FlhOoP5BwbBu2q/wmK+nkqT0dFeVz2B8xk+k+adhPCqAezQjeyI3KgW63RULL6
         UfcQ==
X-Gm-Message-State: AOAM5338uqyyCzijDF2uP/lzvVYY9xd+T5N0xUT+7AP1ZTGarpEtIU2a
        PnAmUb3j1Ksw0o3U/ZxoIgAF8dfFnXuQcTBcoshABjFCnkSkZMMLPA1iwHWBgwiXHUurr8jYA4W
        wKsvaI0DSK6NF
X-Received: by 2002:adf:f7c3:: with SMTP id a3mr2889844wrq.162.1596117578422;
        Thu, 30 Jul 2020 06:59:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTXtEmmLwOZCBchzadGbKx9FHz1Av/y+TsvELbV7aOdz4Ua8L9CsS4+c2FcuHNw7nHHW9XBQ==
X-Received: by 2002:adf:f7c3:: with SMTP id a3mr2889823wrq.162.1596117578170;
        Thu, 30 Jul 2020 06:59:38 -0700 (PDT)
Received: from localhost.localdomain (214.red-88-21-68.staticip.rima-tde.net. [88.21.68.214])
        by smtp.gmail.com with ESMTPSA id y11sm10120598wrs.80.2020.07.30.06.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 06:59:37 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Kaige Li <likaige@loongson.cn>, qemu-block@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Bruce Rogers <brogers@suse.com>
Subject: [PATCH-for-5.1?] util/pagesize: Make qemu_real_host_page_size of type size_t
Date:   Thu, 30 Jul 2020 15:59:35 +0200
Message-Id: <20200730135935.23968-1-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We use different types to hold 'qemu_real_host_page_size'.
Unify picking 'size_t' which seems the best candidate.

Doing so fix a format string issue in hw/virtio/virtio-mem.c
reported when building with GCC 4.9.4:

  hw/virtio/virtio-mem.c: In function ‘virtio_mem_set_block_size’:
  hw/virtio/virtio-mem.c:756:9: error: format ‘%x’ expects argument of type ‘unsigned int’, but argument 7 has type ‘uintptr_t’ [-Werror=format=]
         error_setg(errp, "'%s' property has to be at least 0x%" PRIx32, name,
         ^

Fixes: 910b25766b ("virtio-mem: Paravirtualized memory hot(un)plug")
Reported-by: Bruce Rogers <brogers@suse.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/exec/ram_addr.h  | 4 ++--
 include/qemu/osdep.h     | 2 +-
 accel/kvm/kvm-all.c      | 3 ++-
 block/qcow2-cache.c      | 2 +-
 exec.c                   | 8 ++++----
 hw/ppc/spapr_pci.c       | 2 +-
 hw/virtio/virtio-mem.c   | 2 +-
 migration/migration.c    | 2 +-
 migration/postcopy-ram.c | 2 +-
 monitor/misc.c           | 2 +-
 util/pagesize.c          | 2 +-
 11 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 3ef729a23c..e07532266e 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -93,8 +93,8 @@ static inline unsigned long int ramblock_recv_bitmap_offset(void *host_addr,
 
 bool ramblock_is_pmem(RAMBlock *rb);
 
-long qemu_minrampagesize(void);
-long qemu_maxrampagesize(void);
+size_t qemu_minrampagesize(void);
+size_t qemu_maxrampagesize(void);
 
 /**
  * qemu_ram_alloc_from_file,
diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index 20872e793e..619b8a7a8c 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -635,10 +635,10 @@ char *qemu_get_pid_name(pid_t pid);
  */
 pid_t qemu_fork(Error **errp);
 
+extern size_t qemu_real_host_page_size;
 /* Using intptr_t ensures that qemu_*_page_mask is sign-extended even
  * when intptr_t is 32-bit and we are aligning a long long.
  */
-extern uintptr_t qemu_real_host_page_size;
 extern intptr_t qemu_real_host_page_mask;
 
 extern int qemu_icache_linesize;
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 63ef6af9a1..59becfbd6c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -674,7 +674,8 @@ static int kvm_log_clear_one_slot(KVMSlot *mem, int as_id, uint64_t start,
     KVMState *s = kvm_state;
     uint64_t end, bmap_start, start_delta, bmap_npages;
     struct kvm_clear_dirty_log d;
-    unsigned long *bmap_clear = NULL, psize = qemu_real_host_page_size;
+    unsigned long *bmap_clear = NULL;
+    size_t psize = qemu_real_host_page_size;
     int ret;
 
     /*
diff --git a/block/qcow2-cache.c b/block/qcow2-cache.c
index 7444b9c4ab..4ad9f5929f 100644
--- a/block/qcow2-cache.c
+++ b/block/qcow2-cache.c
@@ -74,7 +74,7 @@ static void qcow2_cache_table_release(Qcow2Cache *c, int i, int num_tables)
 /* Using MADV_DONTNEED to discard memory is a Linux-specific feature */
 #ifdef CONFIG_LINUX
     void *t = qcow2_cache_get_table_addr(c, i);
-    int align = qemu_real_host_page_size;
+    size_t align = qemu_real_host_page_size;
     size_t mem_size = (size_t) c->table_size * num_tables;
     size_t offset = QEMU_ALIGN_UP((uintptr_t) t, align) - (uintptr_t) t;
     size_t length = QEMU_ALIGN_DOWN(mem_size - offset, align);
diff --git a/exec.c b/exec.c
index 6f381f98e2..4b6d52e01f 100644
--- a/exec.c
+++ b/exec.c
@@ -1657,7 +1657,7 @@ static int find_max_backend_pagesize(Object *obj, void *opaque)
  * TODO: We assume right now that all mapped host memory backends are
  * used as RAM, however some might be used for different purposes.
  */
-long qemu_minrampagesize(void)
+size_t qemu_minrampagesize(void)
 {
     long hpsize = LONG_MAX;
     Object *memdev_root = object_resolve_path("/objects", NULL);
@@ -1666,7 +1666,7 @@ long qemu_minrampagesize(void)
     return hpsize;
 }
 
-long qemu_maxrampagesize(void)
+size_t qemu_maxrampagesize(void)
 {
     long pagesize = 0;
     Object *memdev_root = object_resolve_path("/objects", NULL);
@@ -1675,11 +1675,11 @@ long qemu_maxrampagesize(void)
     return pagesize;
 }
 #else
-long qemu_minrampagesize(void)
+size_t qemu_minrampagesize(void)
 {
     return qemu_real_host_page_size;
 }
-long qemu_maxrampagesize(void)
+size_t qemu_maxrampagesize(void)
 {
     return qemu_real_host_page_size;
 }
diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
index 363cdb3f7b..a9da84fe30 100644
--- a/hw/ppc/spapr_pci.c
+++ b/hw/ppc/spapr_pci.c
@@ -1810,7 +1810,7 @@ static void spapr_phb_realize(DeviceState *dev, Error **errp)
     char *namebuf;
     int i;
     PCIBus *bus;
-    uint64_t msi_window_size = 4096;
+    size_t msi_window_size = 4096;
     SpaprTceTable *tcet;
     const unsigned windows_supported = spapr_phb_windows_supported(sphb);
     Error *local_err = NULL;
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index c12e9f79b0..34344cec39 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -753,7 +753,7 @@ static void virtio_mem_set_block_size(Object *obj, Visitor *v, const char *name,
     }
 
     if (value < VIRTIO_MEM_MIN_BLOCK_SIZE) {
-        error_setg(errp, "'%s' property has to be at least 0x%" PRIx32, name,
+        error_setg(errp, "'%s' property has to be at least 0x%zx", name,
                    VIRTIO_MEM_MIN_BLOCK_SIZE);
         return;
     } else if (!is_power_of_2(value)) {
diff --git a/migration/migration.c b/migration/migration.c
index 8fe36339db..b8abbbeabb 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -2433,7 +2433,7 @@ static struct rp_cmd_args {
 static void migrate_handle_rp_req_pages(MigrationState *ms, const char* rbname,
                                        ram_addr_t start, size_t len)
 {
-    long our_host_ps = qemu_real_host_page_size;
+    size_t our_host_ps = qemu_real_host_page_size;
 
     trace_migrate_handle_rp_req_pages(rbname, start, len);
 
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index 1bb22f2b6c..f296efd612 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -345,7 +345,7 @@ static int test_ramblock_postcopiable(RAMBlock *rb, void *opaque)
  */
 bool postcopy_ram_supported_by_host(MigrationIncomingState *mis)
 {
-    long pagesize = qemu_real_host_page_size;
+    size_t pagesize = qemu_real_host_page_size;
     int ufd = -1;
     bool ret = false; /* Error unless we change it */
     void *testarea = NULL;
diff --git a/monitor/misc.c b/monitor/misc.c
index e847b58a8c..7970f4ff72 100644
--- a/monitor/misc.c
+++ b/monitor/misc.c
@@ -740,7 +740,7 @@ static uint64_t vtop(void *ptr, Error **errp)
     uint64_t pinfo;
     uint64_t ret = -1;
     uintptr_t addr = (uintptr_t) ptr;
-    uintptr_t pagesize = qemu_real_host_page_size;
+    size_t pagesize = qemu_real_host_page_size;
     off_t offset = addr / pagesize * sizeof(pinfo);
     int fd;
 
diff --git a/util/pagesize.c b/util/pagesize.c
index 998632cf6e..a08bf1717a 100644
--- a/util/pagesize.c
+++ b/util/pagesize.c
@@ -8,7 +8,7 @@
 
 #include "qemu/osdep.h"
 
-uintptr_t qemu_real_host_page_size;
+size_t qemu_real_host_page_size;
 intptr_t qemu_real_host_page_mask;
 
 static void __attribute__((constructor)) init_real_host_page_size(void)
-- 
2.21.3

