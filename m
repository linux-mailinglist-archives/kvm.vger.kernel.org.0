Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A29F693C9D
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjBMCxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjBMCxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779B4FF3F
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c995lDB1JAKlZY84gYHtgOp10ZlGZIqADTn8Uc7TQdI=;
        b=cFIGWyTjz9TnyG8/DtEd8mPH3W9Zu2HlvI5iQbHikBvtiYG30TH7D7yFPpIc6UAMdFQktx
        Gc0uIAkniFS6aYMSWuwGRTOGyi/NQAJJe4d8acXnEVolz2LIhZ8ZJxG6l28LhZASXxCxf5
        I16cZmFGJGI9Fzs4BdgYVlzSDdXdltU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-224-10DEpVyNMTO75oUHuErdAw-1; Sun, 12 Feb 2023 21:52:33 -0500
X-MC-Unique: 10DEpVyNMTO75oUHuErdAw-1
Received: by mail-wm1-f69.google.com with SMTP id o31-20020a05600c511f00b003dc53da325dso8379392wms.8
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c995lDB1JAKlZY84gYHtgOp10ZlGZIqADTn8Uc7TQdI=;
        b=ve21md6pr2A2sfHWWx4Z0PSOPIvt4N8Z1zFdd6F8n5Wf89qlRxQ/DitQyDoka1fl2p
         6Sb9FdTK3/N2PQm2lxaf2E7B8uxr5RFzpUUVO10Vm1QAFLu37ygm4ZxRxLT2hGqWC8Qo
         OgsXJfCm0d8SXEz1TguCJivW0pQ8rHkcl9fX6Qgnh6MNJpO9l7gyTor7vFEZyCpzX2AV
         0eFvTIESuyv/4Nq5fmyEqzsvFzpIHIm4+on8oh0kBquz+rDgHLzH2egdx8aT2St6q6C2
         uYVhIRIN2FyuqG0RjbLEvfNNws6Koube60NgD2650epDl7PSCvynkNhJHN4oReLlSD7p
         lUWQ==
X-Gm-Message-State: AO0yUKUu2478ZXC4u0HxNd4RJVFg1xu/ehJvdBY0semT8fkuHvVXx0n4
        aRPc1A9aHizZhWW/n/ztEvHD5s7lHKAogoH6LRyYZzpT8E0DuvuBa95SUQQ7v+ixZAiC5ujumM1
        DcY4uQ/CgPNQi
X-Received: by 2002:a05:600c:1688:b0:3dd:caa8:3ae2 with SMTP id k8-20020a05600c168800b003ddcaa83ae2mr18149182wmn.6.1676256750492;
        Sun, 12 Feb 2023 18:52:30 -0800 (PST)
X-Google-Smtp-Source: AK7set/dMZ2ZUSJfLWqLY2UApnuV78OOZJsuUZ90EHofczH2jOt/9V9vmU4+7z/snj4nrMRv4huVAg==
X-Received: by 2002:a05:600c:1688:b0:3dd:caa8:3ae2 with SMTP id k8-20020a05600c168800b003ddcaa83ae2mr18149171wmn.6.1676256750269;
        Sun, 12 Feb 2023 18:52:30 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id q14-20020a5d574e000000b002bfb02153d1sm9399532wrw.45.2023.02.12.18.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:29 -0800 (PST)
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
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [PULL 22/22] ram: Document migration ram flags
Date:   Mon, 13 Feb 2023 03:51:50 +0100
Message-Id: <20230213025150.71537-23-quintela@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213025150.71537-1-quintela@redhat.com>
References: <20230213025150.71537-1-quintela@redhat.com>
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

