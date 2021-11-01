Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7130442319
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhKAWMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21320 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232347AbhKAWMP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=unY7TGVSo3gAzWqEez72wIx+FCQs3PCeVqZ11RSh+wo=;
        b=DIR3jOa2Rt6lsKA/IXosHujRfaoKekMdh9ALbRGyEGrEmK/Xv8M37aQabSCeIruOl+fXKO
        epLd93IMRjb4HxvOd+xmeIA3BwAqS3IN2n72cKIFCIqgkWuS0rRvAY1xu1ksitkOSjQkZp
        e7c6MEVxqi5N0678e2p+f1/CV/944DI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-n8q5LivxOOmh_Cb-kXtDAQ-1; Mon, 01 Nov 2021 18:09:40 -0400
X-MC-Unique: n8q5LivxOOmh_Cb-kXtDAQ-1
Received: by mail-wr1-f69.google.com with SMTP id f1-20020a5d64c1000000b001611832aefeso6799423wri.17
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=unY7TGVSo3gAzWqEez72wIx+FCQs3PCeVqZ11RSh+wo=;
        b=hZopAk3yFpPRbzeRLRDPPo5aRo1HtdNROIVpLwEf0fJQEjOC2Mmbvklb0wL4i+qM+x
         Rs+X+IE0m4xzKPpkRELJyVwspNQC4h3a75k9N2KkFqs0d6b9zUOwrFFkPHZneHyKxk7q
         QeU8eScQt4gWMIEHKYDKNF0F16uBqSA1eHULjGQJ435rEn+mCYKTT5e+zbiVVGdDkeCp
         4Jqo7fvYVW7GM348emVZ6WIKLfjEEXpRvsrNWQEomMu6TBbX8CPCUkTqQ0W4mH09PP0/
         2Q3+o2huH+b07aSIGZaaSiKY4oyEnLl7zoP09UVZMpk2eSOR7Kx8pNIrquZ62QVKFJea
         dRiw==
X-Gm-Message-State: AOAM533SBfU4pHO1bJCiG3hj/lCTEG7aTiLIRv3cIgaEAjpeBmRJH/Fe
        ppJMe5TU7Ql4qz4c6agcTi9ANPTNMoetNfvpKYy6m8q6qXelb30Z+rz6+R0tBBqOsAdO4Bmv3gM
        Q380pJjfAcqZy
X-Received: by 2002:a5d:568c:: with SMTP id f12mr30759745wrv.240.1635804578729;
        Mon, 01 Nov 2021 15:09:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNZg4k6DRhmX852xk77R95Xufg4HlBWhkQxhZujNVoSP0nUJe8lhm/J27V+ocUqFpop+mG2g==
X-Received: by 2002:a5d:568c:: with SMTP id f12mr30759714wrv.240.1635804578506;
        Mon, 01 Nov 2021 15:09:38 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id o1sm7544314wrn.63.2021.11.01.15.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:38 -0700 (PDT)
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
Subject: [PULL 18/20] migration/ram: Handle RAMBlocks with a RamDiscardManager on background snapshots
Date:   Mon,  1 Nov 2021 23:09:10 +0100
Message-Id: <20211101220912.10039-19-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

We already don't ever migrate memory that corresponds to discarded ranges
as managed by a RamDiscardManager responsible for the mapped memory region
of the RAMBlock.

virtio-mem uses this mechanism to logically unplug parts of a RAMBlock.
Right now, we still populate zeropages for the whole usable part of the
RAMBlock, which is undesired because:

1. Even populating the shared zeropage will result in memory getting
   consumed for page tables.
2. Memory backends without a shared zeropage (like hugetlbfs and shmem)
   will populate an actual, fresh page, resulting in an unintended
   memory consumption.

Discarded ("logically unplugged") parts have to remain discarded. As
these pages are never part of the migration stream, there is no need to
track modifications via userfaultfd WP reliably for these parts.

Further, any writes to these ranges by the VM are invalid and the
behavior is undefined.

Note that Linux only supports userfaultfd WP on private anonymous memory
for now, which usually results in the shared zeropage getting populated.
The issue will become more relevant once userfaultfd WP supports shmem
and hugetlb.

Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 92c7b788ae..680a5158aa 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -1656,6 +1656,17 @@ static inline void populate_read_range(RAMBlock *block, ram_addr_t offset,
     }
 }
 
+static inline int populate_read_section(MemoryRegionSection *section,
+                                        void *opaque)
+{
+    const hwaddr size = int128_get64(section->size);
+    hwaddr offset = section->offset_within_region;
+    RAMBlock *block = section->mr->ram_block;
+
+    populate_read_range(block, offset, size);
+    return 0;
+}
+
 /*
  * ram_block_populate_read: preallocate page tables and populate pages in the
  *   RAM block by reading a byte of each page.
@@ -1665,9 +1676,32 @@ static inline void populate_read_range(RAMBlock *block, ram_addr_t offset,
  *
  * @block: RAM block to populate
  */
-static void ram_block_populate_read(RAMBlock *block)
+static void ram_block_populate_read(RAMBlock *rb)
 {
-    populate_read_range(block, 0, block->used_length);
+    /*
+     * Skip populating all pages that fall into a discarded range as managed by
+     * a RamDiscardManager responsible for the mapped memory region of the
+     * RAMBlock. Such discarded ("logically unplugged") parts of a RAMBlock
+     * must not get populated automatically. We don't have to track
+     * modifications via userfaultfd WP reliably, because these pages will
+     * not be part of the migration stream either way -- see
+     * ramblock_dirty_bitmap_exclude_discarded_pages().
+     *
+     * Note: The result is only stable while migrating (precopy/postcopy).
+     */
+    if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
+        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
+        MemoryRegionSection section = {
+            .mr = rb->mr,
+            .offset_within_region = 0,
+            .size = rb->mr->size,
+        };
+
+        ram_discard_manager_replay_populated(rdm, &section,
+                                             populate_read_section, NULL);
+    } else {
+        populate_read_range(rb, 0, rb->used_length);
+    }
 }
 
 /*
-- 
2.33.1

