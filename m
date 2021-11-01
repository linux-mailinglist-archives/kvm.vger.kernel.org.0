Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB53442318
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhKAWMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232320AbhKAWMN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ut0I0bOpeQjRvVatojvb4Hc5X8NOzmNkKKtiHDMU41A=;
        b=Ve1upKNxyC66ZBx9CtFhL7Q6/Al2o3ZTvSRJtSdsQw/GE9IN3pU9OmXRCcqcoenQaczbiF
        TBEpdZVY41gevtSqQaPM5Vmtabg0l2wNCpdfjqNIe/pUYnjAukD/MP8xKcFe9+Px3mmo9w
        grFKC8I3gKU3+/0qzuQdI+ts9xrWn3A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-1K7B_GF7OkCKskqjJQqLYQ-1; Mon, 01 Nov 2021 18:09:38 -0400
X-MC-Unique: 1K7B_GF7OkCKskqjJQqLYQ-1
Received: by mail-wr1-f72.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso6776810wrc.2
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ut0I0bOpeQjRvVatojvb4Hc5X8NOzmNkKKtiHDMU41A=;
        b=AxDN3lgE/YjwjqsyTLKD6ntFltXaZfNh+ljoNyqujO/ncYrzBOn1ThfLqweESOKG++
         sVnTkoOTaZ6YruZgx0GrDbWRImltiwVfNqWwxiugqTvbQB5y85a22+6gusC84doSMcWh
         q6eouem5RMwloBDPw2BuZ4kH9jvV/PQq2cvvnSJlWIfZKIJQ/qxXtP0AcCC5IKsGR8Ux
         oJV99tJYxXS2tgaFg+sh90WUuv7EqfO3I9ZPa4+ghRfLiFx9NEPAXXxx8WCcYzywcas/
         H6MRRdPdHREvBPSlu59RiPFadJ9D40DIwa2XGCtjhQJnhEOQktgBcwFBnR0kC28J+gO0
         guRA==
X-Gm-Message-State: AOAM5317hWZbMDceiuZxZgzNQhpXZMziDLrD+IhlXV1erK7TD7Sg3/0C
        8zSv2u2iDWhTUHjonfLe5vUH4q99L6A35Kyer9hszM3HvEhw/GRhtc4hf9cjzWWq+6IBg5a+duw
        oIkqLWZNTQ60i
X-Received: by 2002:a05:600c:4f92:: with SMTP id n18mr1960062wmq.22.1635804577428;
        Mon, 01 Nov 2021 15:09:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzk1mlsAWBnPV3UAdQaOyBp79mHrO95iLydgSFEaD+slGORmkvNAM202r9ngtyh0byPMnYLqg==
X-Received: by 2002:a05:600c:4f92:: with SMTP id n18mr1960047wmq.22.1635804577205;
        Mon, 01 Nov 2021 15:09:37 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id f1sm14841974wrc.74.2021.11.01.15.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:36 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>
Subject: [PULL 17/20] migration/ram: Factor out populating pages readable in ram_block_populate_pages()
Date:   Mon,  1 Nov 2021 23:09:09 +0100
Message-Id: <20211101220912.10039-18-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

Let's factor out prefaulting/populating to make further changes easier to
review and add a comment what we are actually expecting to happen. While at
it, use the actual page size of the ramblock, which defaults to
qemu_real_host_page_size for anonymous memory. Further, rename
ram_block_populate_pages() to ram_block_populate_read() as well, to make
it clearer what we are doing.

In the future, we might want to use MADV_POPULATE_READ to speed up
population.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 54df5dc0fc..92c7b788ae 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -1639,26 +1639,35 @@ out:
     return ret;
 }
 
+static inline void populate_read_range(RAMBlock *block, ram_addr_t offset,
+                                       ram_addr_t size)
+{
+    /*
+     * We read one byte of each page; this will preallocate page tables if
+     * required and populate the shared zeropage on MAP_PRIVATE anonymous memory
+     * where no page was populated yet. This might require adaption when
+     * supporting other mappings, like shmem.
+     */
+    for (; offset < size; offset += block->page_size) {
+        char tmp = *((char *)block->host + offset);
+
+        /* Don't optimize the read out */
+        asm volatile("" : "+r" (tmp));
+    }
+}
+
 /*
- * ram_block_populate_pages: populate memory in the RAM block by reading
- *   an integer from the beginning of each page.
+ * ram_block_populate_read: preallocate page tables and populate pages in the
+ *   RAM block by reading a byte of each page.
  *
  * Since it's solely used for userfault_fd WP feature, here we just
  *   hardcode page size to qemu_real_host_page_size.
  *
  * @block: RAM block to populate
  */
-static void ram_block_populate_pages(RAMBlock *block)
+static void ram_block_populate_read(RAMBlock *block)
 {
-    char *ptr = (char *) block->host;
-
-    for (ram_addr_t offset = 0; offset < block->used_length;
-            offset += qemu_real_host_page_size) {
-        char tmp = *(ptr + offset);
-
-        /* Don't optimize the read out */
-        asm volatile("" : "+r" (tmp));
-    }
+    populate_read_range(block, 0, block->used_length);
 }
 
 /*
@@ -1684,7 +1693,7 @@ void ram_write_tracking_prepare(void)
          * UFFDIO_WRITEPROTECT_MODE_WP mode setting would silently skip
          * pages with pte_none() entries in page table.
          */
-        ram_block_populate_pages(block);
+        ram_block_populate_read(block);
     }
 }
 
-- 
2.33.1

