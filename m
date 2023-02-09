Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BE86914AC
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbjBIXgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjBIXgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:36:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1096E8B7
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 15:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675985697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eSONnSCSQzL00YkXEaKWMv/0oOpN2PHY8jE8o91oEEs=;
        b=IGhslA2n/G8c3uJeX+nBce+bujKQuh7xpKnZVHfoYd+DV5Xf0plWMOMwM6H+BJdnmX8MGe
        LWvt9UFkuDDjXzI1Ca56tqLCsgNBowRDJFel8jBMwzZbczrFa73Xwa4xZkOsaBGiGDzH3q
        nSBYa7H2stnFCLiZA1FNmmNBd150OgE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-LieolCfUM9mlmU8WvfAjNA-1; Thu, 09 Feb 2023 18:34:54 -0500
X-MC-Unique: LieolCfUM9mlmU8WvfAjNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E285338060FE;
        Thu,  9 Feb 2023 23:34:53 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.192.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 233C4175AD;
        Thu,  9 Feb 2023 23:34:52 +0000 (UTC)
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
Subject: [PULL 11/17] migration: I messed state_pending_exact/estimate
Date:   Fri, 10 Feb 2023 00:34:20 +0100
Message-Id: <20230209233426.37811-12-quintela@redhat.com>
In-Reply-To: <20230209233426.37811-1-quintela@redhat.com>
References: <20230209233426.37811-1-quintela@redhat.com>
MIME-Version: 1.0
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

