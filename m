Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A37159C9B
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbgBKWx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:53:27 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53370 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgBKWx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:53:27 -0500
Received: by mail-wm1-f66.google.com with SMTP id s10so5817143wmh.3;
        Tue, 11 Feb 2020 14:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=S1eHB/ml3ctPQzFmJyOptm0m86oSEkXU1wRBmsiOhmM=;
        b=jSBrLcrAG1ltGRBRq4U2VE5u9yNE3cjbueJAk+fuoekSc36pMuMCbACNJV1w0tSNAF
         S1ONMJgbLb2a9GJV5tPUW6YKTQyYfcwa5dhdIjBJJg7YMV/DLtD1TqnFJo43lOkxJlAy
         crG0C/egrX4U+xGq5NSnyNGMdcZggAG8D16OX8PzzoST8qcF1+9F0Enj5K8qVRwn4wfj
         Fxkp2AFdbQuigpmFSoyEHKWAAOHkH1EB6oY3cwxzS/mm+3aacujad/Za1gkDNR/5rpv9
         1SIwobT7+uqgvdeCezpcWBpcaW8FV1YtQl7Q8e4QLTQs/NhCW0/BMrUqBGtdzpYQE4fF
         fXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=S1eHB/ml3ctPQzFmJyOptm0m86oSEkXU1wRBmsiOhmM=;
        b=pkAuBkJWEe/IA3znWvEtZYo/gsMu5Z/Annu46cvC5UlYPilUa6aMeqyIvH3UKo69t4
         aSSi2CaUzkAzNvW3Z0k5yp915dbufXWUk4Wlcj8DbFpRKkdtqNRc6jAhJ5y9YiDnHJJb
         FwnsiJTlz1gCbXhJvnKJR3HvEAbkkWdxVQJdaCk1EXDFep3LlPOdga2P8IwvXB5A2z0l
         WC+2htqjrPBVWRogU7h4CWi+8lY6bUDy9RKVKVUpw68OS94ycXjEXdn9XiSrKQXE4VWB
         hAyaX059Zkxr9PcUtlslMmukNTjueedM57m9Q9pO8/mrflg+Z3BoY5nkA4LvKrsQop99
         37sA==
X-Gm-Message-State: APjAAAUID2NycZDt6x3IfwB7JV/i1qTM5uRicohuy5X3VQicZ7Izk3LP
        y9hoB8zatF2P51Q+Bzgq27Q=
X-Google-Smtp-Source: APXvYqzqlf5oxNgk8th18WowzQtUb3awrK2YQcMVxb29DDDmi7fe37ioHUaSOFJ2r6tjOtRseRlyPg==
X-Received: by 2002:a1c:a5c7:: with SMTP id o190mr2079763wme.183.1581461604557;
        Tue, 11 Feb 2020 14:53:24 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id z11sm6981099wrv.96.2020.02.11.14.53.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:53:24 -0800 (PST)
Subject: [PATCH v17 QEMU 4/3 RFC] memory: Add support for MADV_FREE as
 mechanism to lazy discard pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org,
        mgorman@techsingularity.net, alexander.h.duyck@linux.intel.com,
        vbabka@suse.cz, osalvador@suse.de
Date:   Tue, 11 Feb 2020 14:53:18 -0800
Message-ID: <20200211225220.30596.80416.stgit@localhost.localdomain>
In-Reply-To: <20200211224416.29318.44077.stgit@localhost.localdomain>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add support for the MADV_FREE advice argument when discarding pages.
Specifically we add an option to perform a lazy discard for use with free
page reporting as this allows us to avoid expensive page zeroing in the
case that the system is not under memory pressure.

To enable this I simply extended the ram_block_discard_range function to
add an extra parameter for "lazy" freeing. I then renamed the function,
wrapped it in a function defined using the original name and defaulting
lazy to false. From there I created a second wrapper for
ram_block_free_range and updated the page reporting code to use that.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 exec.c                     |   39 +++++++++++++++++++++++++++------------
 hw/virtio/virtio-balloon.c |    2 +-
 include/exec/cpu-common.h  |    1 +
 3 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/exec.c b/exec.c
index 67e520d18ea5..2266574eb06e 100644
--- a/exec.c
+++ b/exec.c
@@ -3881,15 +3881,8 @@ int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
     return ret;
 }
 
-/*
- * Unmap pages of memory from start to start+length such that
- * they a) read as 0, b) Trigger whatever fault mechanism
- * the OS provides for postcopy.
- * The pages must be unmapped by the end of the function.
- * Returns: 0 on success, none-0 on failure
- *
- */
-int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
+static int __ram_block_discard_range(RAMBlock *rb, uint64_t start,
+                                     size_t length, bool lazy)
 {
     int ret = -1;
 
@@ -3941,13 +3934,18 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
 #endif
         }
         if (need_madvise) {
-            /* For normal RAM this causes it to be unmapped,
+#ifdef CONFIG_MADVISE
+#ifdef MADV_FREE
+            int advice = (lazy && !need_fallocate) ? MADV_FREE : MADV_DONTNEED;
+#else
+            int advice = MADV_DONTNEED;
+#endif
+            /* For normal RAM this causes it to be lazy freed or unmapped,
              * for shared memory it causes the local mapping to disappear
              * and to fall back on the file contents (which we just
              * fallocate'd away).
              */
-#if defined(CONFIG_MADVISE)
-            ret =  madvise(host_startaddr, length, MADV_DONTNEED);
+            ret =  madvise(host_startaddr, length, advice);
             if (ret) {
                 ret = -errno;
                 error_report("ram_block_discard_range: Failed to discard range "
@@ -3975,6 +3973,23 @@ err:
     return ret;
 }
 
+/*
+ * Unmap pages of memory from start to start+length such that
+ * they a) read as 0, b) Trigger whatever fault mechanism
+ * the OS provides for postcopy.
+ * The pages must be unmapped by the end of the function.
+ * Returns: 0 on success, none-0 on failure
+ *
+ */
+int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
+{
+    return __ram_block_discard_range(rb, start, length, false);
+}
+
+int ram_block_free_range(RAMBlock *rb, uint64_t start, size_t length)
+{
+    return __ram_block_discard_range(rb, start, length, true);
+}
 bool ramblock_is_pmem(RAMBlock *rb)
 {
     return rb->flags & RAM_PMEM;
diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index 5faafd2f62ac..7df92af73792 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -346,7 +346,7 @@ static void virtio_balloon_handle_report(VirtIODevice *vdev, VirtQueue *vq)
             if ((ram_offset | size) & (rb_page_size - 1))
                 continue;
 
-            ram_block_discard_range(rb, ram_offset, size);
+            ram_block_free_range(rb, ram_offset, size);
         }
 
         virtqueue_push(vq, elem, 0);
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 81753bbb3431..2bbd26784c63 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -104,6 +104,7 @@ typedef int (RAMBlockIterFunc)(RAMBlock *rb, void *opaque);
 
 int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
 int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
+int ram_block_free_range(RAMBlock *rb, uint64_t start, size_t length);
 
 #endif
 

