Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E13693C44
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 03:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjBMCbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 21:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjBMCay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 21:30:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E37FF20
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676255374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOi00Pqh/ujyWTtG6wmGTly8NpXv3aJEdCMEVs3nCBo=;
        b=Aga7YYeNM8vo8byEXN9g0n8q9cCV6C8NxmB7xpkxU2RHYfI6FFfsa2wryDTOyD0zp2JXnU
        XlMyZrbExHD9iVVPJ7/hChqlXCn8EFKSnKeGf72ae+jiEn+ZJ1QpRR1Zrtz0KynAdMzjX+
        u7CpZpUaR1Il+ff+bn35VONYDbiAIm0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-5-PQTqWzjPN-iLmuFI7gNhZg-1; Sun, 12 Feb 2023 21:29:33 -0500
X-MC-Unique: PQTqWzjPN-iLmuFI7gNhZg-1
Received: by mail-wm1-f72.google.com with SMTP id l38-20020a05600c1d2600b003ddff4b9a40so6033113wms.9
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 18:29:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOi00Pqh/ujyWTtG6wmGTly8NpXv3aJEdCMEVs3nCBo=;
        b=qsg+F3SI2Mox3MpqXblgNufyfTTpl2L5V6plkmUgIVeGhXUvihYVsnXa7KmQXt3XQs
         C1cMg60yIyuMP/xFurg1KN2HRh0eg+hm2MRpLpveIWHDSNsLpUEGVtrr9ZSWvzurXf+e
         ZTMCm6cnNw7WA477+RxrTvzFmvV3tzSgFy6jxJcZzMkHcMSVc4lC5V420upd1wzhudJe
         OaXeJ+UNRLrwYBY0JqydyTrqk5F07C+IPZ7p8m6vXr5Qi9ClwPrKW6lsY347hupn+0AC
         9fU2bjcK8kLcXVk37B4Hqvcf0IwDUjvqjhjCLQOysscR5CDFIeaqAuCkVnOmpLyYs3tU
         aMpQ==
X-Gm-Message-State: AO0yUKU6uitHpZHpaOCuxz3OQumg0G7kaN/HP/d9in78JQa2rTox2AlZ
        YCup0eytqTUrdfQERzRXweX1aQpkIRlhhQ61R3HoO+kRMfYVeynOOsoU4I4TselXkDHuutwCwvg
        od2u4DNYO6yFL
X-Received: by 2002:adf:eb88:0:b0:2c5:4bd4:b3a8 with SMTP id t8-20020adfeb88000000b002c54bd4b3a8mr7133133wrn.4.1676255371942;
        Sun, 12 Feb 2023 18:29:31 -0800 (PST)
X-Google-Smtp-Source: AK7set93r9z3DMHPpOkkw0GymiD+Q9tAwTIKRBZwn0QmaSQgLXHYJg2jzv/gVIO1TxUcoI75MMe6/g==
X-Received: by 2002:adf:eb88:0:b0:2c5:4bd4:b3a8 with SMTP id t8-20020adfeb88000000b002c54bd4b3a8mr7133127wrn.4.1676255371764;
        Sun, 12 Feb 2023 18:29:31 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d6551000000b002c54c8e70b1sm6275033wrv.9.2023.02.12.18.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 18:29:31 -0800 (PST)
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
Subject: [PULL 11/22] migration: I messed state_pending_exact/estimate
Date:   Mon, 13 Feb 2023 03:29:00 +0100
Message-Id: <20230213022911.68490-12-xxx.xx@gmail.com>
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

