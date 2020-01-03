Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4349B12FE57
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 22:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgACVYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 16:24:16 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46936 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbgACVYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 16:24:16 -0500
Received: by mail-pf1-f193.google.com with SMTP id n9so16173381pff.13;
        Fri, 03 Jan 2020 13:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=R+UOvEIvAKvV92s1Oao0n2zpHAWrzhC1LqeTb2UW2HA=;
        b=rXB1CvTJ6A9GhMN42hgYg/qS0Xy+3wuP23OMsdSchPUiu75AHNojATGXwFrAigRx6/
         qvZXOsLYwpJ5Ttf5dejWTslhzKpQocZjfk7+bpoKBW0KmYIYq6B5hVwujEt97/Q33sVf
         SnNJ2lZTNR/+aGDeNkR1mqkWxJFOv75Zlv32khd1Tx/okf+rDl8dxfpu1QFXncUtMxbr
         wxBKwTdl2xxpVe34MGN8TBeTY21dgptqgpQ/xWMKYUYgkXuEpi9P48qluxa9UTJ0Xy9c
         Xpq/y+E2f1AKxBeqKeD7/Br2IGioPQ5Ovxks6S4U7h2Q2IOvbKLewj4ggKujYeF5QYXI
         beWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R+UOvEIvAKvV92s1Oao0n2zpHAWrzhC1LqeTb2UW2HA=;
        b=XnkDtFc5ikBEuYxWf4FKKd8KWq2AHiUishVnCLOrkyC7HuRYSqWr/Y5tYYe8Gkn0E7
         oo5FM9pZAVlx2qr2YQT1OENe0ELbnj9LQUxnAa6n0Dbkhx1BxBySnANP7101F0xjSkRU
         Ypib/52Nv8K5uDaRpReIIzeKNjQsadFN0b4kf0+mquCXOjJKO9h2GsjM/kxSR1+kes0a
         GBssV1NCOuHsQmc1zwtB363XmiuFdg9tRmflrQ8Mtff5mUkAsBfqGlSnqr6Ioj8Vmjug
         RTw71weKpyt6KqVDggu6h6bgck05JUJZ47YjdpNgGbEJV0sVkvNybczMYdakGcIJqEyb
         K3kw==
X-Gm-Message-State: APjAAAWy/wuBjdpiETj/n5VvYrC8TwubNSBx8boF75pcRoJDN9cXVAUN
        y80ILmszj8o6SwY+6aVQr9o=
X-Google-Smtp-Source: APXvYqybTyKvXei4N7XcHa7h/QWfnTj20X/f0SCjkOdjAZ6X/HleMJe2ybbwn56JEMDhin5x0CRs4w==
X-Received: by 2002:a62:a206:: with SMTP id m6mr86696087pff.210.1578086655318;
        Fri, 03 Jan 2020 13:24:15 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id w123sm50624962pfb.167.2020.01.03.13.24.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 13:24:14 -0800 (PST)
Subject: [PATCH v16 QEMU 4/3 RFC] memory: Add support for MADV_FREE as
 mechanism to lazy discard pages
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Date:   Fri, 03 Jan 2020 13:24:14 -0800
Message-ID: <20200103212339.29849.99817.stgit@localhost.localdomain>
In-Reply-To: <20200103210509.29237.18426.stgit@localhost.localdomain>
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
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
index ffdb5185353b..14eda993058c 100644
--- a/exec.c
+++ b/exec.c
@@ -3843,15 +3843,8 @@ int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque)
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
 
@@ -3904,13 +3897,18 @@ int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length)
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
@@ -3938,6 +3936,23 @@ err:
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
index 47f253d016db..b904bdde8b1b 100644
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
 

