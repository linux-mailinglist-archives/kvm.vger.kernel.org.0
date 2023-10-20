Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166FD7D0906
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376408AbjJTHAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376396AbjJTHAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:00:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB1C1BF
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697785167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NSgHyHEZfPE9cd1uGtechBOjRxN9vNPYJYi2OtzuiQ0=;
        b=EKXfj/P24IleonGVrlwyaSRLhmjMjWg0gmYr1qP980ethvAnQSx4V2w7qBVWyQWn9F3m58
        y4WvpWLrPVbJ3DJPQyAFf25cJjlXa+H7NrvyoMZljKQWs2B5ZVOnBglpBgsRQgTX3ZX+Gc
        hdw4zN8m1Xp3Kmoa46Mxi4rl189O/u4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-A4rH87AqMS-35XtixiB6ZQ-1; Fri, 20 Oct 2023 02:59:13 -0400
X-MC-Unique: A4rH87AqMS-35XtixiB6ZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C07C29AA2C2;
        Fri, 20 Oct 2023 06:59:11 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06B3725C0;
        Fri, 20 Oct 2023 06:59:04 +0000 (UTC)
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
Subject: [PULL 10/17] tests/qtest: Introduce qtest_resolve_machine_alias
Date:   Fri, 20 Oct 2023 08:57:44 +0200
Message-ID: <20231020065751.26047-11-quintela@redhat.com>
In-Reply-To: <20231020065751.26047-1-quintela@redhat.com>
References: <20231020065751.26047-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Fabiano Rosas <farosas@suse.de>

The migration tests are being enhanced to test migration between
different QEMU versions. A requirement of migration is that the
machine type between source and destination matches, including the
version.

We cannot hardcode machine types in the tests because those change
with each release. QEMU provides a machine type alias that has a fixed
name, but points to the latest machine type at each release.

Add a helper to resolve the alias into the exact machine
type. E.g. "-machine pc" resolves to "pc-i440fx-8.2"

Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Fabiano Rosas <farosas@suse.de>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Message-ID: <20231018192741.25885-6-farosas@suse.de>
---
 tests/qtest/libqtest.h | 10 ++++++++++
 tests/qtest/libqtest.c | 16 ++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/tests/qtest/libqtest.h b/tests/qtest/libqtest.h
index d16deb9891..6e3d3525bf 100644
--- a/tests/qtest/libqtest.h
+++ b/tests/qtest/libqtest.h
@@ -922,6 +922,16 @@ void qtest_qmp_fds_assert_success(QTestState *qts, int *fds, size_t nfds,
 void qtest_cb_for_every_machine(void (*cb)(const char *machine),
                                 bool skip_old_versioned);
 
+/**
+ * qtest_resolve_machine_alias:
+ * @var: Environment variable from where to take the QEMU binary
+ * @alias: The alias to resolve
+ *
+ * Returns: the machine type corresponding to the alias if any,
+ * otherwise NULL.
+ */
+char *qtest_resolve_machine_alias(const char *var, const char *alias);
+
 /**
  * qtest_has_machine:
  * @machine: The machine to look for
diff --git a/tests/qtest/libqtest.c b/tests/qtest/libqtest.c
index 603d900e7d..c843c41188 100644
--- a/tests/qtest/libqtest.c
+++ b/tests/qtest/libqtest.c
@@ -1565,6 +1565,22 @@ void qtest_cb_for_every_machine(void (*cb)(const char *machine),
     }
 }
 
+char *qtest_resolve_machine_alias(const char *var, const char *alias)
+{
+    struct MachInfo *machines;
+    int i;
+
+    machines = qtest_get_machines(var);
+
+    for (i = 0; machines[i].name != NULL; i++) {
+        if (machines[i].alias && g_str_equal(alias, machines[i].alias)) {
+            return g_strdup(machines[i].name);
+        }
+    }
+
+    return NULL;
+}
+
 bool qtest_has_machine_with_env(const char *var, const char *machine)
 {
     struct MachInfo *machines;
-- 
2.41.0

