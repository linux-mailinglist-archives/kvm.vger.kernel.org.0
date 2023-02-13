Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98619693C5B
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjBMCb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjBMCbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:31:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC941024F
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wri2CO6/ED+3PLHQRO4xHrfVHwULI1GD8MLKUb731II=;
        b=JlqRnJB3XovB5xEvly2yFr4QbLRF8FOiiS3RgT21oruNsztTlq2SsE1ar1J2tlcX9dna1o
        qBHagMAhVvDkNi8/r1bco4+uuz38AA1vruu+ugvkjYAas1/r9qQEIgzxzfc6tr7tqyoCxw
        uF+JGUZ9jr7Cve9L1tJM/ZpNmOW9j/0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-uGqaHkl3N_SPbLHw2-g7KA-1; Sun, 12 Feb 2023 21:29:52 -0500
X-MC-Unique: uGqaHkl3N_SPbLHw2-g7KA-1
Received: by mail-wm1-f69.google.com with SMTP id l38-20020a05600c1d2600b003ddff4b9a40so6033441wms.9
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wri2CO6/ED+3PLHQRO4xHrfVHwULI1GD8MLKUb731II=;
        b=mO1h69b72Jg5dd2gODn3RcFH9rihFohPJ8jCrYnqCrkTzPFSp54ApyOBG1QnufAZuu
         i8tUmKjhcnTW9akp8njhK9/SgYTIwZcJ+Ugds4a90I1jZaxZpquM8vHjb19FHPvZ7fJY
         qH/ntZ/q+5h7M/k20TQq0Jy+mlT3DZAw19LGUDmwJVM3a14KBIvpUCMF25rWXXyJ4qg7
         m/fcwqJLSJsnQdh1zOhDxWdK62OD9wacSkO2qCuwMDzix/uwkai3jUg4JeleChYTX/1r
         a507Kb2vMRWft8y0f0JcTHx1qC2YWuEsLl4Eo8qA/N15NHFk5Ii/kPHx/esbz+Z4Zhjd
         AJEg==
X-Gm-Message-State: AO0yUKV3kl9pAvKo1zV+Ws/v4hGx9085A5l2pzR5lYCKQ1TRuFjH2pRy
        hbaGyH2n2l77fl2EaKDBwcVhZy46EUZACOLnu/dNfyOUWov7d0tN3bFjsa50dSrxxcHyLWv2jDB
        XJy5OlDYRSCvE
X-Received: by 2002:a5d:6845:0:b0:2c3:e0a0:94f with SMTP id o5-20020a5d6845000000b002c3e0a0094fmr18388365wrw.37.1676255391017;
        Sun, 12 Feb 2023 18:29:51 -0800 (PST)
X-Google-Smtp-Source: AK7set9w/r02MOuyNF6ZqzSL2cS4DS8i6O5G9fomfHgKEJeNVNkj+CcjrykNGeyX93lI34+24dt6Yg==
X-Received: by 2002:a5d:6845:0:b0:2c3:e0a0:94f with SMTP id o5-20020a5d6845000000b002c3e0a0094fmr18388350wrw.37.1676255390787;
        Sun, 12 Feb 2023 18:29:50 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id t9-20020adfeb89000000b002be0b1e556esm9231583wrn.59.2023.02.12.18.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:50 -0800 (PST)
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
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [PULL 22/22] ram: Document migration ram flags
Date:   Mon, 13 Feb 2023 03:29:11 +0100
Message-Id: <20230213022911.68490-23-xxx.xx@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213022911.68490-1-xxx.xx@gmail.com>
References: <20230213022911.68490-1-xxx.xx@gmail.com>
MIME-Version: 1.0
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

0x80 is RAM_SAVE_FLAG_HOOK, it is in qemu-file now.
Bigger usable flag is 0x200, noticing that.
We can reuse RAM_SAVe_FLAG_FULL.

Reviewed-by: Eric Blake <eblake@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 18ac68b181..521912385d 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -67,21 +67,25 @@
 /***********************************************************/
 /* ram save/restore */
 
-/* RAM_SAVE_FLAG_ZERO used to be named RAM_SAVE_FLAG_COMPRESS, it
- * worked for pages that where filled with the same char.  We switched
+/*
+ * RAM_SAVE_FLAG_ZERO used to be named RAM_SAVE_FLAG_COMPRESS, it
+ * worked for pages that were filled with the same char.  We switched
  * it to only search for the zero value.  And to avoid confusion with
- * RAM_SSAVE_FLAG_COMPRESS_PAGE just rename it.
+ * RAM_SAVE_FLAG_COMPRESS_PAGE just rename it.
  */
-
-#define RAM_SAVE_FLAG_FULL     0x01 /* Obsolete, not used anymore */
+/*
+ * RAM_SAVE_FLAG_FULL was obsoleted in 2009, it can be reused now
+ */
+#define RAM_SAVE_FLAG_FULL     0x01
 #define RAM_SAVE_FLAG_ZERO     0x02
 #define RAM_SAVE_FLAG_MEM_SIZE 0x04
 #define RAM_SAVE_FLAG_PAGE     0x08
 #define RAM_SAVE_FLAG_EOS      0x10
 #define RAM_SAVE_FLAG_CONTINUE 0x20
 #define RAM_SAVE_FLAG_XBZRLE   0x40
-/* 0x80 is reserved in migration.h start with 0x100 next */
+/* 0x80 is reserved in qemu-file.h for RAM_SAVE_FLAG_HOOK */
 #define RAM_SAVE_FLAG_COMPRESS_PAGE    0x100
+/* We can't use any flag that is bigger than 0x200 */
 
 int (*xbzrle_encode_buffer_func)(uint8_t *, uint8_t *, int,
      uint8_t *, int) = xbzrle_encode_buffer;
-- 
2.39.1

