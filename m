Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32DC6914A6
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjBIXge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjBIXgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:36:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66F36D8F9
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 15:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675985691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sTufRhxd4BJwr0ynerupDDVisptQT4IB/pKAbzWpYf8=;
        b=QZkx50G28pu66h9Nu+qycXCpscrKbO0Z9/YJGON1oWJIJdKq2YX8NBJGDO66DW29/Zv+R3
        hJhPvKOfUcvYUw/PZ+qRB9DK5ToyvhuxseOboEHCFtFs6S7xsxMixhI/8RPxyo/XkmTdRy
        SrBWxJS3jjCsp7n4vXhXxyvzcCVC8mc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-SayfY0jcN260Aj_2RcJjCg-1; Thu, 09 Feb 2023 18:34:47 -0500
X-MC-Unique: SayfY0jcN260Aj_2RcJjCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F17A85C6F4;
        Thu,  9 Feb 2023 23:34:47 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.192.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92317175AD;
        Thu,  9 Feb 2023 23:34:45 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PULL 08/17] migration: Split ram_bytes_total_common() in two functions
Date:   Fri, 10 Feb 2023 00:34:17 +0100
Message-Id: <20230209233426.37811-9-quintela@redhat.com>
In-Reply-To: <20230209233426.37811-1-quintela@redhat.com>
References: <20230209233426.37811-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is just a big if in the middle of the function, and we need two
functions anways.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Juan Quintela <quintela@redhat.com>

---

Reindent to make Phillipe happy (and CODING_STYLE)
---
 migration/ram.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 3aea86c8ab..4dd9cf87ea 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -2601,28 +2601,30 @@ void acct_update_position(QEMUFile *f, size_t size, bool zero)
     }
 }
 
-static uint64_t ram_bytes_total_common(bool count_ignored)
+static uint64_t ram_bytes_total_with_ignored(void)
 {
     RAMBlock *block;
     uint64_t total = 0;
 
     RCU_READ_LOCK_GUARD();
 
-    if (count_ignored) {
-        RAMBLOCK_FOREACH_MIGRATABLE(block) {
-            total += block->used_length;
-        }
-    } else {
-        RAMBLOCK_FOREACH_NOT_IGNORED(block) {
-            total += block->used_length;
-        }
+    RAMBLOCK_FOREACH_MIGRATABLE(block) {
+        total += block->used_length;
     }
     return total;
 }
 
 uint64_t ram_bytes_total(void)
 {
-    return ram_bytes_total_common(false);
+    RAMBlock *block;
+    uint64_t total = 0;
+
+    RCU_READ_LOCK_GUARD();
+
+    RAMBLOCK_FOREACH_NOT_IGNORED(block) {
+        total += block->used_length;
+    }
+    return total;
 }
 
 static void xbzrle_load_setup(void)
@@ -3227,7 +3229,8 @@ static int ram_save_setup(QEMUFile *f, void *opaque)
     (*rsp)->pss[RAM_CHANNEL_PRECOPY].pss_channel = f;
 
     WITH_RCU_READ_LOCK_GUARD() {
-        qemu_put_be64(f, ram_bytes_total_common(true) | RAM_SAVE_FLAG_MEM_SIZE);
+        qemu_put_be64(f, ram_bytes_total_with_ignored()
+                         | RAM_SAVE_FLAG_MEM_SIZE);
 
         RAMBLOCK_FOREACH_MIGRATABLE(block) {
             qemu_put_byte(f, strlen(block->idstr));
-- 
2.39.1

