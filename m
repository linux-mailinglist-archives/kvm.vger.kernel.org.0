Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEF7693C42
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjBMCa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBMCay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B406FF18
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x9OoujK3z66uinkW5o8sulP0PBTebtU4f6y178F9c/w=;
        b=T+FXGQv5NQHA2fbOz73RHOCeSZKN8QoNzyufdq2qKYzDBaJdqy6T6is2lCkefIyx1KFJvY
        0S5l/d9M73zIxIQ+9lXm7n1AWJ11jPrP3Zh9aWYFYlJjAya8aaOSo5/D/Ss8XFANst0hHF
        6smQePp3Pm/53IdJ2HfNqmuA9N4dpLs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-462-8obMVYh2P0af52reGU2K3w-1; Sun, 12 Feb 2023 21:29:29 -0500
X-MC-Unique: 8obMVYh2P0af52reGU2K3w-1
Received: by mail-wm1-f70.google.com with SMTP id r14-20020a05600c35ce00b003e10bfcd160so6034551wmq.6
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x9OoujK3z66uinkW5o8sulP0PBTebtU4f6y178F9c/w=;
        b=ujJgrzjaBr3R7P8jk7T1qnJaoNzA+btDGIEfXOUlQTXBrk40/UlTVz/RMz8rNXlZgd
         XV0bIXxwqqn8aZJ/1+fqFRGMiJqUBED3o3nXxpp/1i5HuJXruxOsJ42UcEWYg+xnVE/j
         jQH3jJYZ4kMdW1SSt8PrZ57pBEuw1FU1hJbzoIENzDWtE4KF2sOK4J0hx8KFidZf0aH1
         ZK/xz6wNrvSLcKWbbbH+GpVuVQ4n8LrGtaHWufV3ubKknjtYwgt9m5BxXq9J8jvqIbGb
         Fmndhl5Ywyd4G1g/IFF7hrzWqa4C5upCvJmLop1ocQUI799S6BR69wQQELoBtd3ITunD
         cviQ==
X-Gm-Message-State: AO0yUKVyFmJSJQut/5WDCpD41i9qvOEwPjBWo70RavvNLpfmpkZ78lFV
        olc8WwrdtkQ0dE2w07GYp9rVpitrUGVEX4Rzs6UW1HEgMX4EFqSnubvb3HPBzqrcRROShsG7z03
        A9XEglvqhe5q9
X-Received: by 2002:adf:dc04:0:b0:2c3:ea92:3494 with SMTP id t4-20020adfdc04000000b002c3ea923494mr18343383wri.55.1676255368329;
        Sun, 12 Feb 2023 18:29:28 -0800 (PST)
X-Google-Smtp-Source: AK7set+I1g+CjQEsCE9I+sUqcpmuWn8GMN5Pg5a9hM8lnrQcitUKUf6RFY2A0VQFHTwHB+L4NfTg3g==
X-Received: by 2002:adf:dc04:0:b0:2c3:ea92:3494 with SMTP id t4-20020adfdc04000000b002c3ea923494mr18343372wri.55.1676255368146;
        Sun, 12 Feb 2023 18:29:28 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id a7-20020a056000050700b002c3e3ee7d1asm9338278wrf.79.2023.02.12.18.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:27 -0800 (PST)
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
Subject: [PULL 09/22] migration: Calculate ram size once
Date:   Mon, 13 Feb 2023 03:28:58 +0100
Message-Id: <20230213022911.68490-10-xxx.xx@gmail.com>
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

We are recalculating ram size continously, when we know that it don't
change during migration.  Create a field in RAMState to track it.

Signed-off-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 migration/ram.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/migration/ram.c b/migration/ram.c
index 1727fe5ef6..6abfe075f2 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -330,6 +330,8 @@ struct RAMState {
     PageSearchStatus pss[RAM_CHANNEL_MAX];
     /* UFFD file descriptor, used in 'write-tracking' migration */
     int uffdio_fd;
+    /* total ram size in bytes */
+    uint64_t ram_bytes_total;
     /* Last block that we have visited searching for dirty pages */
     RAMBlock *last_seen_block;
     /* Last dirty target page we have sent */
@@ -2546,7 +2548,7 @@ static int ram_find_and_save_block(RAMState *rs)
     int pages = 0;
 
     /* No dirty page as there is zero RAM */
-    if (!ram_bytes_total()) {
+    if (!rs->ram_bytes_total) {
         return pages;
     }
 
@@ -3009,13 +3011,14 @@ static int ram_state_init(RAMState **rsp)
     qemu_mutex_init(&(*rsp)->bitmap_mutex);
     qemu_mutex_init(&(*rsp)->src_page_req_mutex);
     QSIMPLEQ_INIT(&(*rsp)->src_page_requests);
+    (*rsp)->ram_bytes_total = ram_bytes_total();
 
     /*
      * Count the total number of pages used by ram blocks not including any
      * gaps due to alignment or unplugs.
      * This must match with the initial values of dirty bitmap.
      */
-    (*rsp)->migration_dirty_pages = ram_bytes_total() >> TARGET_PAGE_BITS;
+    (*rsp)->migration_dirty_pages = (*rsp)->ram_bytes_total >> TARGET_PAGE_BITS;
     ram_state_reset(*rsp);
 
     return 0;
-- 
2.39.1

