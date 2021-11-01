Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CA2442317
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhKAWMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232302AbhKAWMM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H80g6dMw2Mv72MY8J/rqWuWQm27PgZOf7gOHLz8JbhA=;
        b=bjsc1aWn+K8zk7qoHc4vHv+090mDJzTUnYChUKAmdLv0SI3mBliUZgb20OdxFMlFf33slq
        tvU7U65m0m686+XN+xWYoM0541HcdlNxQna19nV/cWk7jzOPxwxsamKH3I7HTZAQRPSsPj
        utRhPnLylBbhLvMj8FZFT+N8dg0YyjI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-JvmkSI43MaehjqV1RRQkJg-1; Mon, 01 Nov 2021 18:09:37 -0400
X-MC-Unique: JvmkSI43MaehjqV1RRQkJg-1
Received: by mail-wm1-f69.google.com with SMTP id a186-20020a1c7fc3000000b00332f1a308e7so180171wmd.3
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H80g6dMw2Mv72MY8J/rqWuWQm27PgZOf7gOHLz8JbhA=;
        b=dpSS6dxB7cQAqIPEcZdfcG0wq9YgENGuoF9GWEhdcKMlXvvUbiPVlgcdH+/LI45r83
         vGv8Zm9CnjiaNxUglNn4EhfE0jPKzO7Z0YLQrezG2VdaR5N9z44bcXN6JogcBXkBzkxa
         IGlkGm00dPmmoi8auY+zCcUKMJA6v3BqaVPyrihhkQmlTWimtLfO1hb2PPM1sYZbBTVf
         vgcJICkQZyl9Zg570lO5WUlhBym1s2KyLit0ANr2OWO7sKb+enrc9UMPIJwZMJNzY+kb
         Pwqv04XoIgiaLMEfOXfB4Ze54i9/OFn1MpDgg4lCmUmX/dWdmvWfxF+hKJTrnm8S7wxa
         vwIQ==
X-Gm-Message-State: AOAM533Nqh3xz9PZzTi0f9bgzZ9lKIpqYrAZv9JSRqgpjgdUh7mh7eKY
        yD7Ee0zbTobIPOip3Nb9de0XiW3Tki9G7oT2TLkTzlj/89R+k4zAZAnbLrx3wL2c0Tz1Fr8hpA+
        oDp/ZAZBqEAMU
X-Received: by 2002:a05:6000:54e:: with SMTP id b14mr40644781wrf.308.1635804575960;
        Mon, 01 Nov 2021 15:09:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeYrI4G4BKiXAB/InRvOnWTy+hbH8wuPZhOXw0coLYSKiQ6S2dlFWrOoqN5kf/uLhyOXH1Ww==
X-Received: by 2002:a05:6000:54e:: with SMTP id b14mr40644755wrf.308.1635804575814;
        Mon, 01 Nov 2021 15:09:35 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id l8sm667683wmc.40.2021.11.01.15.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:35 -0700 (PDT)
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
Subject: [PULL 16/20] migration: Simplify alignment and alignment checks
Date:   Mon,  1 Nov 2021 23:09:08 +0100
Message-Id: <20211101220912.10039-17-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

Let's use QEMU_ALIGN_DOWN() and friends to make the code a bit easier to
read.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/migration.c    | 6 +++---
 migration/postcopy-ram.c | 9 ++++-----
 migration/ram.c          | 2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/migration/migration.c b/migration/migration.c
index e1c0082530..53b9a8af96 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -391,7 +391,7 @@ int migrate_send_rp_message_req_pages(MigrationIncomingState *mis,
 int migrate_send_rp_req_pages(MigrationIncomingState *mis,
                               RAMBlock *rb, ram_addr_t start, uint64_t haddr)
 {
-    void *aligned = (void *)(uintptr_t)(haddr & (-qemu_ram_pagesize(rb)));
+    void *aligned = (void *)(uintptr_t)ROUND_DOWN(haddr, qemu_ram_pagesize(rb));
     bool received = false;
 
     WITH_QEMU_LOCK_GUARD(&mis->page_request_mutex) {
@@ -2637,8 +2637,8 @@ static void migrate_handle_rp_req_pages(MigrationState *ms, const char* rbname,
      * Since we currently insist on matching page sizes, just sanity check
      * we're being asked for whole host pages.
      */
-    if (start & (our_host_ps - 1) ||
-       (len & (our_host_ps - 1))) {
+    if (!QEMU_IS_ALIGNED(start, our_host_ps) ||
+        !QEMU_IS_ALIGNED(len, our_host_ps)) {
         error_report("%s: Misaligned page request, start: " RAM_ADDR_FMT
                      " len: %zd", __func__, start, len);
         mark_source_rp_bad(ms);
diff --git a/migration/postcopy-ram.c b/migration/postcopy-ram.c
index 3609ce7e52..e721f69d0f 100644
--- a/migration/postcopy-ram.c
+++ b/migration/postcopy-ram.c
@@ -402,7 +402,7 @@ bool postcopy_ram_supported_by_host(MigrationIncomingState *mis)
                      strerror(errno));
         goto out;
     }
-    g_assert(((size_t)testarea & (pagesize - 1)) == 0);
+    g_assert(QEMU_PTR_IS_ALIGNED(testarea, pagesize));
 
     reg_struct.range.start = (uintptr_t)testarea;
     reg_struct.range.len = pagesize;
@@ -660,7 +660,7 @@ int postcopy_wake_shared(struct PostCopyFD *pcfd,
     struct uffdio_range range;
     int ret;
     trace_postcopy_wake_shared(client_addr, qemu_ram_get_idstr(rb));
-    range.start = client_addr & ~(pagesize - 1);
+    range.start = ROUND_DOWN(client_addr, pagesize);
     range.len = pagesize;
     ret = ioctl(pcfd->fd, UFFDIO_WAKE, &range);
     if (ret) {
@@ -702,8 +702,7 @@ static int postcopy_request_page(MigrationIncomingState *mis, RAMBlock *rb,
 int postcopy_request_shared_page(struct PostCopyFD *pcfd, RAMBlock *rb,
                                  uint64_t client_addr, uint64_t rb_offset)
 {
-    size_t pagesize = qemu_ram_pagesize(rb);
-    uint64_t aligned_rbo = rb_offset & ~(pagesize - 1);
+    uint64_t aligned_rbo = ROUND_DOWN(rb_offset, qemu_ram_pagesize(rb));
     MigrationIncomingState *mis = migration_incoming_get_current();
 
     trace_postcopy_request_shared_page(pcfd->idstr, qemu_ram_get_idstr(rb),
@@ -993,7 +992,7 @@ static void *postcopy_ram_fault_thread(void *opaque)
                 break;
             }
 
-            rb_offset &= ~(qemu_ram_pagesize(rb) - 1);
+            rb_offset = ROUND_DOWN(rb_offset, qemu_ram_pagesize(rb));
             trace_postcopy_ram_fault_thread_request(msg.arg.pagefault.address,
                                                 qemu_ram_get_idstr(rb),
                                                 rb_offset,
diff --git a/migration/ram.c b/migration/ram.c
index 4f629de7d0..54df5dc0fc 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -811,7 +811,7 @@ static void migration_clear_memory_region_dirty_bitmap(RAMBlock *rb,
     assert(shift >= 6);
 
     size = 1ULL << (TARGET_PAGE_BITS + shift);
-    start = (((ram_addr_t)page) << TARGET_PAGE_BITS) & (-size);
+    start = QEMU_ALIGN_DOWN((ram_addr_t)page << TARGET_PAGE_BITS, size);
     trace_migration_bitmap_clear_dirty(rb->idstr, start, size, page);
     memory_region_clear_dirty_bitmap(rb->mr, start, size);
 }
-- 
2.33.1

