Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FB3233408
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 16:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgG3ONE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 10:13:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39980 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726275AbgG3ONE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 10:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596118381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xxBIENL/LoZt89TmQbxcwOuGTpfVQSq5CrXDxfuIriw=;
        b=JC/owPhKmIlcUjQusP8tPCkW4zvychYvGY+rWNuhQ2uW70ZRwxdR2l0Q3TtRlB2bK3F14M
        HAt6YT/+BfIl5xrXUO+ukiqrsOkcZ5LMDNkBsFUMGTMzHkXojPTkqaGWcYwe+ZYsOfXj/j
        AlSdQee+ajzcWJZx7nUm0M5LEiBLJ2A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-jMmzn4_eOLS7fUhGbuOqiw-1; Thu, 30 Jul 2020 10:13:00 -0400
X-MC-Unique: jMmzn4_eOLS7fUhGbuOqiw-1
Received: by mail-wm1-f69.google.com with SMTP id f74so2283206wmf.1
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 07:12:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xxBIENL/LoZt89TmQbxcwOuGTpfVQSq5CrXDxfuIriw=;
        b=k08KA6c0yE9C1En0+GYJlgjypez+BErKo7pB2W8HRBOSfVpRuCZI+LTOPT6C6/Tisi
         zClB5D1L1Ybj7qNfLahn3rO9JGHniwkbbnFIhT415kfMc7P/jMZaR3TQ4pwTTqePn6xt
         hC01SM6u6nGrsUd+WEjDq7Rk5/0vsVtkqu1nVY2VKkHHDgHfDc9txJWXsD8ADk2tQBn7
         VwHhjagEO7mC2TgdJ7mQytE4h8oP/x7W2g/+af1qlmCK48kRLnyKvvuU6X2SVUUJNEyL
         2roDZXZ5U9PEjM3g3GGpcHaEoyVbcWlWNQeUJSSPAdNdA936Vn66alURbvfy5rO1N6+I
         bhbg==
X-Gm-Message-State: AOAM530FRr5fPcNT+Ulx7sbjJueqmCa6z1TDAIggR2yF1nOsZfPuym9k
        KZ25xyvET3W0QTjbTivENHW2+v3cyGSrE5BTQsPV5upGipjAntp4r4yG5vvl0ojIhXOjfDq+6cZ
        SEp5K+54rC/pc
X-Received: by 2002:a5d:6288:: with SMTP id k8mr33268183wru.373.1596118378765;
        Thu, 30 Jul 2020 07:12:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOeB5bBzOPnj0Bc4q6B26KoFvfZtUWUvrxAgOD5MUXfYr2PHKsFTZdlbfZ38OAnxsnA9xt/w==
X-Received: by 2002:a5d:6288:: with SMTP id k8mr33268155wru.373.1596118378437;
        Thu, 30 Jul 2020 07:12:58 -0700 (PDT)
Received: from localhost.localdomain (214.red-88-21-68.staticip.rima-tde.net. [88.21.68.214])
        by smtp.gmail.com with ESMTPSA id v11sm10223890wrr.10.2020.07.30.07.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 07:12:57 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-block@nongnu.org, qemu-ppc@nongnu.org,
        Kaige Li <likaige@loongson.cn>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Bruce Rogers <brogers@suse.com>
Subject: [PATCH-for-5.1? v2 2/2] util/pagesize: Make qemu_real_host_page_size of type size_t
Date:   Thu, 30 Jul 2020 16:12:45 +0200
Message-Id: <20200730141245.21739-3-philmd@redhat.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200730141245.21739-1-philmd@redhat.com>
References: <20200730141245.21739-1-philmd@redhat.com>
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
index 085df8d508..77115a8270 100644
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

