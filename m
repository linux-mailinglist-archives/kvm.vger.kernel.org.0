Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023FB693C8D
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjBMCxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjBMCxO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:53:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABA810271
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676256733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eSONnSCSQzL00YkXEaKWMv/0oOpN2PHY8jE8o91oEEs=;
        b=CSqY7n+CMzMU18Bh2hNhXwgS+qQ2Zb/qHK2MgtXRl/pLbWtJczKUesjh0Vid37sjxjdvCv
        aiMNtXCmW0ixcyjIkJyCoofZtV7AsaWCBrKkYN5/bo/5r6/qao0cA7Z7oxVD9PMZXUhnO/
        M/ujF4QXcI8kj/lkQe8o0VINbeCehDY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-368-pAx9d233PmS0cO4pA7XJvQ-1; Sun, 12 Feb 2023 21:52:12 -0500
X-MC-Unique: pAx9d233PmS0cO4pA7XJvQ-1
Received: by mail-wm1-f69.google.com with SMTP id s11-20020a05600c384b00b003dffc7343c3so5451295wmr.0
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:52:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eSONnSCSQzL00YkXEaKWMv/0oOpN2PHY8jE8o91oEEs=;
        b=i9p8hzuMIouZecS9HMCorwC4dUNwr9LPiKyrwV6oCxGHOu1FjyQhF/yPDZox53pKtm
         3F/kErodtxzwACleVLafoi1k93zEvlpG9NJLPJsQXMAh88+mYDzt0lKHDGHbMBAYVwf4
         leCuy9ncmgTK3ZnJIJw325I62tUPQLAxNphOIas2SW8WGtvxi3fUfhMoCNHIpKggwowJ
         RUX1r6a3qu4Z7D/GrmJsty1/EwgxBHeq0XC/zY9mZfc27IZvXd6uM6AaWCSZj4sWaIA2
         FLk3XHgBtulQB66Mrf74/oswifDOKSfmjyw9IlbDgtsHw54/crQLazv/xaFSm4b1fAV/
         2uOA==
X-Gm-Message-State: AO0yUKWsDloMEkrlVxxjW1Bmxa9A6QnIt+hecW4WJA+ugj/NsLow+5Hy
        ZibhbQyezs30BQ30tQL3y3Z38hz8lO0ik5DlEFVuT/hUNg5WLQco096lS5cTjtquLvWGRW4K20I
        bRMi2KTQg0qlE
X-Received: by 2002:a05:600c:1606:b0:3e0:39:ec9d with SMTP id m6-20020a05600c160600b003e00039ec9dmr17977554wmn.23.1676256731088;
        Sun, 12 Feb 2023 18:52:11 -0800 (PST)
X-Google-Smtp-Source: AK7set8385UsdxLhe6Lubligoz7bwZWXr0FJrEcwvoTK4P5+p3gm9zEpVWQGyOSmkN/kZN0gZ6ssYg==
X-Received: by 2002:a05:600c:1606:b0:3e0:39:ec9d with SMTP id m6-20020a05600c160600b003e00039ec9dmr17977547wmn.23.1676256730901;
        Sun, 12 Feb 2023 18:52:10 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c459200b003db03725e86sm13712002wmo.8.2023.02.12.18.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:52:10 -0800 (PST)
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
Subject: [PULL 11/22] migration: I messed state_pending_exact/estimate
Date:   Mon, 13 Feb 2023 03:51:39 +0100
Message-Id: <20230213025150.71537-12-quintela@redhat.com>
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

I called the helper function from the wrong top level function.

This code was introduced in:

commit c8df4a7aeffcb46020f610526eea621fa5b0cd47
Author: Juan Quintela <quintela@redhat.com>
Date:   Mon Oct 3 02:00:03 2022 +0200

    migration: Split save_live_pending() into state_pending_*

    We split the function into to:

    - state_pending_estimate: We estimate the remaining state size without
      stopping the machine.

    - state pending_exact: We calculate the exact amount of remaining
      state.

Thanks to Avihai Horon <avihaih@nvidia.com> for finding it.

Fixes:c8df4a7aeffcb46020f610526eea621fa5b0cd47

When we introduced that patch, we enden calling

state_pending_estimate() helper from qemu_savevm_statepending_exact()
and
state_pending_exact() helper from qemu_savevm_statepending_estimate()

This patch fixes it.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/savevm.c | 50 +++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/migration/savevm.c b/migration/savevm.c
index e9cf4999ad..ce181e21e1 100644
--- a/migration/savevm.c
+++ b/migration/savevm.c
@@ -1551,31 +1551,6 @@ void qemu_savevm_state_pending_estimate(uint64_t *res_precopy_only,
     *res_compatible = 0;
     *res_postcopy_only = 0;
 
-    QTAILQ_FOREACH(se, &savevm_state.handlers, entry) {
-        if (!se->ops || !se->ops->state_pending_exact) {
-            continue;
-        }
-        if (se->ops->is_active) {
-            if (!se->ops->is_active(se->opaque)) {
-                continue;
-            }
-        }
-        se->ops->state_pending_exact(se->opaque,
-                                     res_precopy_only, res_compatible,
-                                     res_postcopy_only);
-    }
-}
-
-void qemu_savevm_state_pending_exact(uint64_t *res_precopy_only,
-                                     uint64_t *res_compatible,
-                                     uint64_t *res_postcopy_only)
-{
-    SaveStateEntry *se;
-
-    *res_precopy_only = 0;
-    *res_compatible = 0;
-    *res_postcopy_only = 0;
-
     QTAILQ_FOREACH(se, &savevm_state.handlers, entry) {
         if (!se->ops || !se->ops->state_pending_estimate) {
             continue;
@@ -1591,6 +1566,31 @@ void qemu_savevm_state_pending_exact(uint64_t *res_precopy_only,
     }
 }
 
+void qemu_savevm_state_pending_exact(uint64_t *res_precopy_only,
+                                     uint64_t *res_compatible,
+                                     uint64_t *res_postcopy_only)
+{
+    SaveStateEntry *se;
+
+    *res_precopy_only = 0;
+    *res_compatible = 0;
+    *res_postcopy_only = 0;
+
+    QTAILQ_FOREACH(se, &savevm_state.handlers, entry) {
+        if (!se->ops || !se->ops->state_pending_exact) {
+            continue;
+        }
+        if (se->ops->is_active) {
+            if (!se->ops->is_active(se->opaque)) {
+                continue;
+            }
+        }
+        se->ops->state_pending_exact(se->opaque,
+                                     res_precopy_only, res_compatible,
+                                     res_postcopy_only);
+    }
+}
+
 void qemu_savevm_state_cleanup(void)
 {
     SaveStateEntry *se;
-- 
2.39.1

