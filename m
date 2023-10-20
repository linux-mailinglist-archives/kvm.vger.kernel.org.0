Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFED7D090E
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376416AbjJTHAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376395AbjJTHAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:00:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E81BD5D
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697785199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sM/0UQ5xBCWfmnH5VTYXfvCTYeIJ1ZcbMPhmzQIzyg0=;
        b=GAwJDTkEM8HFpEmAcxivaOKZDnhP9OF7DltHu2nElqy7zBYP1825Fotq8F04ciVMuzxWc3
        FEKUvu4CNYQdonMjgeU5onD+swXc/kiJCplKJn0tz54lF9VWAmxDo7Vz7TQVGGdWYo1A46
        mguW4LZqWSBLE4Nsy9Fp5t50a6puAS4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-bGAuUPiJO-ubat5-GAy0Gw-1; Fri, 20 Oct 2023 02:59:55 -0400
X-MC-Unique: bGAuUPiJO-ubat5-GAy0Gw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A35D988B76E;
        Fri, 20 Oct 2023 06:59:53 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEC5825C0;
        Fri, 20 Oct 2023 06:59:46 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Denis V. Lunev" <den@openvz.org>,
        Juan Quintela <quintela@redhat.com>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, qemu-arm@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        qemu-ppc@nongnu.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Stefan Weil <sw@weilnetz.de>, Peter Xu <peterx@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Jeff Cody <codyprime@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Fabiano Rosas <farosas@suse.de>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Greg Kurz <groug@kaod.org>, qemu-block@nongnu.org
Subject: [PULL 16/17] tests/qtest/migration: Allow user to specify a machine type
Date:   Fri, 20 Oct 2023 08:57:50 +0200
Message-ID: <20231020065751.26047-17-quintela@redhat.com>
In-Reply-To: <20231020065751.26047-1-quintela@redhat.com>
References: <20231020065751.26047-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fabiano Rosas <farosas@suse.de>

Accept the QTEST_QEMU_MACHINE_TYPE environment variable to take a
machine type to use in the tests.

The full machine type is recognized (e.g. pc-q35-8.2). Aliases
(e.g. pc) are also allowed and resolve to the latest machine version
for that alias, or, if using two QEMU binaries, to the latest common
machine version between the two.

Signed-off-by: Fabiano Rosas <farosas@suse.de>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Message-ID: <20231018192741.25885-12-farosas@suse.de>
---
 tests/qtest/migration-helpers.h |  2 ++
 tests/qtest/migration-helpers.c | 26 ++++++++++++++++++++++++++
 tests/qtest/migration-test.c    |  5 +++--
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/tests/qtest/migration-helpers.h b/tests/qtest/migration-helpers.h
index d1c2351d33..e31dc85cc7 100644
--- a/tests/qtest/migration-helpers.h
+++ b/tests/qtest/migration-helpers.h
@@ -45,4 +45,6 @@ void wait_for_migration_fail(QTestState *from, bool allow_active);
 
 char *find_common_machine_version(const char *mtype, const char *var1,
                                   const char *var2);
+char *resolve_machine_version(const char *alias, const char *var1,
+                              const char *var2);
 #endif /* MIGRATION_HELPERS_H */
diff --git a/tests/qtest/migration-helpers.c b/tests/qtest/migration-helpers.c
index 13449c1fe1..24fb7b3525 100644
--- a/tests/qtest/migration-helpers.c
+++ b/tests/qtest/migration-helpers.c
@@ -11,6 +11,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/ctype.h"
 #include "qapi/qmp/qjson.h"
 
 #include "migration-helpers.h"
@@ -266,3 +267,28 @@ char *find_common_machine_version(const char *mtype, const char *var1,
                    "binaries %s and %s", mtype, getenv(var1), getenv(var2));
     g_assert_not_reached();
 }
+
+char *resolve_machine_version(const char *alias, const char *var1,
+                              const char *var2)
+{
+    const char *mname = g_getenv("QTEST_QEMU_MACHINE_TYPE");
+    g_autofree char *machine_name = NULL;
+
+    if (mname) {
+        const char *dash = strrchr(mname, '-');
+        const char *dot = strrchr(mname, '.');
+
+        machine_name = g_strdup(mname);
+
+        if (dash && dot) {
+            assert(qtest_has_machine(machine_name));
+            return g_steal_pointer(&machine_name);
+        }
+        /* else: probably an alias, let it be resolved below */
+    } else {
+        /* use the hardcoded alias */
+        machine_name = g_strdup(alias);
+    }
+
+    return find_common_machine_version(machine_name, var1, var2);
+}
diff --git a/tests/qtest/migration-test.c b/tests/qtest/migration-test.c
index 4a5d37317a..bc70a14642 100644
--- a/tests/qtest/migration-test.c
+++ b/tests/qtest/migration-test.c
@@ -825,8 +825,9 @@ static int test_migrate_start(QTestState **from, QTestState **to,
         kvm_opts = ",dirty-ring-size=4096";
     }
 
-    machine = find_common_machine_version(machine_alias, QEMU_ENV_SRC,
-                                          QEMU_ENV_DST);
+    machine = resolve_machine_version(machine_alias, QEMU_ENV_SRC,
+                                      QEMU_ENV_DST);
+
     g_test_message("Using machine type: %s", machine);
 
     cmd_source = g_strdup_printf("-accel kvm%s -accel tcg "
-- 
2.41.0

