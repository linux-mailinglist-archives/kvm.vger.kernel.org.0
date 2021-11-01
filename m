Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA5B44231A
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhKAWMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232302AbhKAWMQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2DiI4EfnW7YWT1ASaakXUWvRZyN7+/5k2450FBy0sI4=;
        b=de7Q1lob8fEuDpGz4btqF8OXeMLKOZqegQhSq7PmRPUpfzweKZ9aneIzihTtvQzjY3IbBh
        ljVjH/fDBJ8ujskN+m/rgo85/+fRyWCuyyf5jjtE27vaMnF9DFLpg2dXLKCTt1UgIIfjl8
        Vy4VYVoYxNdE0Qmziouu8/SeX7RYnqU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-wDOpzYLsNfSJbWk9WqzPRw-1; Mon, 01 Nov 2021 18:09:41 -0400
X-MC-Unique: wDOpzYLsNfSJbWk9WqzPRw-1
Received: by mail-wm1-f72.google.com with SMTP id k5-20020a7bc3050000b02901e081f69d80so6351545wmj.8
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2DiI4EfnW7YWT1ASaakXUWvRZyN7+/5k2450FBy0sI4=;
        b=o7Gw43iyoy08m6LcAX1m6cT684CD1UY1zQ2kYivuvMk3Jm/KqRmNWrwdaUgUtWBtot
         UhDnV991pA9xy3pLO/DfKTzTh55dKeo04MB500pi1tPrKKmNd3xdZQ1yrt5GV48xMa0a
         nJmah33Xwyb7EwngB0BSC1FTORjd4u4KPnoQAE0Ulprln/TWqhRQ0JKCaXWXP21CY1zA
         iKgAiuqdC+vaSsUPGgyUSZSatOW9adESzY2iaL1JdKmfzvDiBns3VL0GWu13mGzF9rUz
         uaT7eBwoCfdOzm6U41xX2mdVgWZg9JD3m3swpiHujYqS0elEyyPXVsQxn+Vo8a8GBFkp
         o7rQ==
X-Gm-Message-State: AOAM531zlRCmL9ag/MW0bY1IrFi8wx6NYDTixTjFJFzEw4NbB46BnUtF
        Zaaf5sDD4aOKoVOylVcqtG7PjkIqPAO+vekiIlXT/yOTl9AKz0ozaO15WQZ/19cbIfYP9eQAhUv
        FB1yhOuNdaYpv
X-Received: by 2002:adf:e292:: with SMTP id v18mr39964926wri.369.1635804579985;
        Mon, 01 Nov 2021 15:09:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysID67lQG9xljT2Fw7myH50fBYiqoMMqtw2ZP9fgHwBDYxBz5RqDHeu2EAgEpnNBhOmOcEEQ==
X-Received: by 2002:adf:e292:: with SMTP id v18mr39964906wri.369.1635804579845;
        Mon, 01 Nov 2021 15:09:39 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id d24sm610262wmb.35.2021.11.01.15.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:39 -0700 (PDT)
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
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Hyman=20Huang=28=E9=BB=84=E5=8B=87=29?= 
        <huangy81@chinatelecom.cn>
Subject: [PULL 19/20] memory: introduce total_dirty_pages to stat dirty pages
Date:   Mon,  1 Nov 2021 23:09:11 +0100
Message-Id: <20211101220912.10039-20-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>

introduce global var total_dirty_pages to stat dirty pages
along with memory_global_dirty_log_sync.

Signed-off-by: Hyman Huang(黄勇) <huangy81@chinatelecom.cn>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 include/exec/ram_addr.h | 9 +++++++++
 migration/dirtyrate.c   | 7 +++++++
 2 files changed, 16 insertions(+)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 45c913264a..64fb936c7c 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -26,6 +26,8 @@
 #include "exec/ramlist.h"
 #include "exec/ramblock.h"
 
+extern uint64_t total_dirty_pages;
+
 /**
  * clear_bmap_size: calculate clear bitmap size
  *
@@ -373,6 +375,10 @@ static inline void cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
                         qatomic_or(
                                 &blocks[DIRTY_MEMORY_MIGRATION][idx][offset],
                                 temp);
+                        if (unlikely(
+                            global_dirty_tracking & GLOBAL_DIRTY_DIRTY_RATE)) {
+                            total_dirty_pages += ctpopl(temp);
+                        }
                     }
 
                     if (tcg_enabled()) {
@@ -403,6 +409,9 @@ static inline void cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
         for (i = 0; i < len; i++) {
             if (bitmap[i] != 0) {
                 c = leul_to_cpu(bitmap[i]);
+                if (unlikely(global_dirty_tracking & GLOBAL_DIRTY_DIRTY_RATE)) {
+                    total_dirty_pages += ctpopl(c);
+                }
                 do {
                     j = ctzl(c);
                     c &= ~(1ul << j);
diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index f92c4b498e..17b3d2cbb5 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -28,6 +28,13 @@
 #include "sysemu/runstate.h"
 #include "exec/memory.h"
 
+/*
+ * total_dirty_pages is procted by BQL and is used
+ * to stat dirty pages during the period of two
+ * memory_global_dirty_log_sync
+ */
+uint64_t total_dirty_pages;
+
 typedef struct DirtyPageRecord {
     uint64_t start_pages;
     uint64_t end_pages;
-- 
2.33.1

