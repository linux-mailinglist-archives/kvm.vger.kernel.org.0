Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE48693C40
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjBMCa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBMCax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBFBFF12
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UptCkJZZ1oFnZpYoUHipdojg2SHE5Vc15YVv+FVTq60=;
        b=Ox5PxUPEta/vEKhiTNtMtnYl47YHK31fGqgBZKvT26zJoRQK49M9DL9qQKG6LcdOmIrPVZ
        frYcmyNywjPwKFGpvV/7HAK5AcDj27EhYBqIi9oiJEByY553b50kwHej6N/32T8ene4jea
        ZOu1HX3SUyJmn/bbeeyQyP4haazrrZg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-237-nT3SYkHZNIqEHLDbDt-zhA-1; Sun, 12 Feb 2023 21:29:27 -0500
X-MC-Unique: nT3SYkHZNIqEHLDbDt-zhA-1
Received: by mail-wm1-f70.google.com with SMTP id a20-20020a05600c349400b003dfecb98d38so8389399wmq.0
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UptCkJZZ1oFnZpYoUHipdojg2SHE5Vc15YVv+FVTq60=;
        b=lJxDEBoQXk/d/l90rV9Ns30YDvMYXsKnQE0sqh33u/TvDhWADXqsi+raB92RkfktRG
         7OEu3ZJZRv1LiMQB8tOU9sVdZHHhHomdjX7OjIUiH7syB9pdlldvrhl0bHLjNPLvFH5q
         7H46+LP4N9Bg9FN8JJfmobLx+u8oHGS61kzjMYFWojfRrL11hQdoVrxlphj1AGgQFYGV
         sZ5kAz6o/IGvY7s4e5cR8vjc04edkbmlqFs9qKUxdkBrBRhr/X17yjDoyinsIxo06f84
         UCdxApsKZ14BCCOWn2uqdQmfUF82OGxDj+mtTN1Rtz/r0yoBXaueoGQdvoegOJWM0yVB
         W1Aw==
X-Gm-Message-State: AO0yUKVCwNfeYpk6idjRZ03axNB5um7OeKaUBfrI6+iqKLUcoZ7PbyE3
        B3f2EJVv+GqqQTHP8owA8wKLin6ZfSmWPy3wATAaYh6q5Js9absgJ0IttiPsIW6T/cUS+af/G49
        U8Dy6p+FHTbj7
X-Received: by 2002:a05:600c:920:b0:3df:d817:df98 with SMTP id m32-20020a05600c092000b003dfd817df98mr18108849wmp.10.1676255366837;
        Sun, 12 Feb 2023 18:29:26 -0800 (PST)
X-Google-Smtp-Source: AK7set/ZZNvjk2tGZ5tQzckq/asqm2AH0dpNmfP8JVO5494f3UTMZP5AV7bWiTgPrGjmhPGeypFXpw==
X-Received: by 2002:a05:600c:920:b0:3df:d817:df98 with SMTP id m32-20020a05600c092000b003dfd817df98mr18108841wmp.10.1676255366678;
        Sun, 12 Feb 2023 18:29:26 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id s21-20020a1cf215000000b003e001119927sm15091501wmc.24.2023.02.12.18.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:26 -0800 (PST)
From:   Xxx Xx <quintela@redhat.com>
X-Google-Original-From: Xxx Xx <xxx.xx@gmail.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PULL 08/22] migration: Split ram_bytes_total_common() in two functions
Date:   Mon, 13 Feb 2023 03:28:57 +0100
Message-Id: <20230213022911.68490-9-xxx.xx@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213022911.68490-1-xxx.xx@gmail.com>
References: <20230213022911.68490-1-xxx.xx@gmail.com>
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

From: Juan Quintela <quintela@redhat.com>

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

