Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F77693C88
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjBMCxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjBMCxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A25DFF1A
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSap7rP2yuIXzjR89/H20UJYqGivlGaX/5tcXAgoyrk=;
        b=VIIXdAGOcoVAEue3AXa1oDb/Qv/PROv275hGCNYlRYT90UiL/5AvbaLM9obDMHcrQB1BHz
        9d7dljg8Lnq8O+BUpsfkz2GwcoVN/2lpsjUvQHAq755wjAt0p2OdhgKrRslBc6JhsqJpGO
        JqetiJVh8g9gAwqGXBOoLBm/xHClNoI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-304-RcIkTeLuPaCI3ZwOZafRUA-1; Sun, 12 Feb 2023 21:52:07 -0500
X-MC-Unique: RcIkTeLuPaCI3ZwOZafRUA-1
Received: by mail-wm1-f72.google.com with SMTP id x10-20020a05600c21ca00b003dc5584b516so8385174wmj.7
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cSap7rP2yuIXzjR89/H20UJYqGivlGaX/5tcXAgoyrk=;
        b=bjCTh2kQ0pgvoNOhI0GWZF9jN3Bc29Dr4k2yMNnhKbzm4wOF/HgizxGNU0uNrsAXQr
         cuO+DKpXAxmzZnDtknBMMcHzoDxS4LL4sI+Dun0soQ0ZAmsFPo5uejvcjFnJCJQ1pFAp
         GSM2x8fH/zObXMJzeDju5tS0imw9GPq10w4Lk/31d1avaqBEIYRpw1KUjuLE0yIvgvr9
         qM3AZepY6SqfjJdmdvfGiZmLg6t4uI2tsNO+lpUfJs04Hl+vqULKU9EQ1u6g9HmGDGPo
         +9GjW40uXiTr/Z3re41hOmB/hgUYfp2yP7qB+Bl7ll29gxfV4NB8sMHTb1ncHAMUUerR
         cOhg==
X-Gm-Message-State: AO0yUKVZLx1RQOp1RJe+BRVcBAKaDJpyRuMh44zQvHlbGXbbdUf+caJR
        8V7fPCGvZpbMutbdKD3lncgzstAEkbTQ9Fonb6G2SOasVf783uV8ooWPTkg5e5p/8CSvLDgKVOv
        3Ew8mlDCMfNFJ
X-Received: by 2002:a05:600c:601a:b0:3dc:42e7:f626 with SMTP id az26-20020a05600c601a00b003dc42e7f626mr17776277wmb.26.1676256726224;
        Sun, 12 Feb 2023 18:52:06 -0800 (PST)
X-Google-Smtp-Source: AK7set++Nz7Kw+x589SL8UIfDxL0cbrEnisnDps7RxWyA0tA+XJNjZ542wFXvB0qp2bn7kIubCboBw==
X-Received: by 2002:a05:600c:601a:b0:3dc:42e7:f626 with SMTP id az26-20020a05600c601a00b003dc42e7f626mr17776270wmb.26.1676256726013;
        Sun, 12 Feb 2023 18:52:06 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id b18-20020a05600c4e1200b003e00c453447sm15887254wmq.48.2023.02.12.18.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:05 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PULL 08/22] migration: Split ram_bytes_total_common() in two functions
Date:   Mon, 13 Feb 2023 03:51:36 +0100
Message-Id: <20230213025150.71537-9-quintela@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213025150.71537-1-quintela@redhat.com>
References: <20230213025150.71537-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index cf577fce5c..1727fe5ef6 100644
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

