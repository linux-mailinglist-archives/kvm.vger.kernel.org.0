Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844D27D08FA
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376392AbjJTG7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376412AbjJTG7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:59:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68EFD5A
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697785138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aTn9veGAxLAYJslyZIyZzW0sClB0zJRQrXIWfbzdZi4=;
        b=heKB+I8/sUKXp2RSa39HARTHD/fiHd56+TIiAVyKgrTvsLMajTDpAcf0W15+59tk7+DI9Z
        4rwc9PdgQDMtFIQiXHelOnNp5hYkEiZOORY6ZN7lzbsoDtoyXaH6bETnGX9HrR7NIe7134
        qYR9G21ZcMmr5Lx1Tkxx0NEvHdF41TQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-a7AaMWqrOZumdOKVwB96Vw-1; Fri, 20 Oct 2023 02:58:51 -0400
X-MC-Unique: a7AaMWqrOZumdOKVwB96Vw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5580010201E3;
        Fri, 20 Oct 2023 06:58:50 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9A5625C0;
        Fri, 20 Oct 2023 06:58:43 +0000 (UTC)
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
Subject: [PULL 07/17] tests/qtest: Introduce qtest_init_with_env
Date:   Fri, 20 Oct 2023 08:57:41 +0200
Message-ID: <20231020065751.26047-8-quintela@redhat.com>
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

Add a version of qtest_init() that takes an environment variable
containing the path of the QEMU binary. This allows tests to use more
than one QEMU binary.

If no variable is provided or the environment variable does not exist,
that is not an error. Fallback to using QTEST_QEMU_BINARY.

Signed-off-by: Fabiano Rosas <farosas@suse.de>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Message-ID: <20231018192741.25885-3-farosas@suse.de>
---
 tests/qtest/libqtest.h | 13 +++++++++++++
 tests/qtest/libqtest.c | 26 +++++++++++++++++++-------
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/tests/qtest/libqtest.h b/tests/qtest/libqtest.h
index 5fe3d13466..76fc195f1c 100644
--- a/tests/qtest/libqtest.h
+++ b/tests/qtest/libqtest.h
@@ -55,6 +55,19 @@ QTestState *qtest_vinitf(const char *fmt, va_list ap) G_GNUC_PRINTF(1, 0);
  */
 QTestState *qtest_init(const char *extra_args);
 
+/**
+ * qtest_init_with_env:
+ * @var: Environment variable from where to take the QEMU binary
+ * @extra_args: Other arguments to pass to QEMU.  CAUTION: these
+ * arguments are subject to word splitting and shell evaluation.
+ *
+ * Like qtest_init(), but use a different environment variable for the
+ * QEMU binary.
+ *
+ * Returns: #QTestState instance.
+ */
+QTestState *qtest_init_with_env(const char *var, const char *extra_args);
+
 /**
  * qtest_init_without_qmp_handshake:
  * @extra_args: other arguments to pass to QEMU.  CAUTION: these
diff --git a/tests/qtest/libqtest.c b/tests/qtest/libqtest.c
index 03fa644663..9eebba8767 100644
--- a/tests/qtest/libqtest.c
+++ b/tests/qtest/libqtest.c
@@ -388,7 +388,8 @@ static pid_t qtest_create_process(char *cmd)
 }
 #endif /* _WIN32 */
 
-static QTestState *G_GNUC_PRINTF(1, 2) qtest_spawn_qemu(const char *fmt, ...)
+static QTestState *G_GNUC_PRINTF(2, 3) qtest_spawn_qemu(const char *qemu_bin,
+                                                        const char *fmt, ...)
 {
     va_list ap;
     QTestState *s = g_new0(QTestState, 1);
@@ -398,8 +399,7 @@ static QTestState *G_GNUC_PRINTF(1, 2) qtest_spawn_qemu(const char *fmt, ...)
     g_autoptr(GString) command = g_string_new("");
 
     va_start(ap, fmt);
-    g_string_append_printf(command, CMD_EXEC "%s %s",
-                           qtest_qemu_binary(NULL), tracearg);
+    g_string_append_printf(command, CMD_EXEC "%s %s", qemu_bin, tracearg);
     g_string_append_vprintf(command, fmt, ap);
     va_end(ap);
 
@@ -438,7 +438,8 @@ static QTestState *G_GNUC_PRINTF(1, 2) qtest_spawn_qemu(const char *fmt, ...)
     return s;
 }
 
-QTestState *qtest_init_without_qmp_handshake(const char *extra_args)
+static QTestState *qtest_init_internal(const char *qemu_bin,
+                                       const char *extra_args)
 {
     QTestState *s;
     int sock, qmpsock, i;
@@ -463,7 +464,8 @@ QTestState *qtest_init_without_qmp_handshake(const char *extra_args)
     sock = init_socket(socket_path);
     qmpsock = init_socket(qmp_socket_path);
 
-    s = qtest_spawn_qemu("-qtest unix:%s "
+    s = qtest_spawn_qemu(qemu_bin,
+                         "-qtest unix:%s "
                          "-qtest-log %s "
                          "-chardev socket,path=%s,id=char0 "
                          "-mon chardev=char0,mode=control "
@@ -516,9 +518,14 @@ QTestState *qtest_init_without_qmp_handshake(const char *extra_args)
     return s;
 }
 
-QTestState *qtest_init(const char *extra_args)
+QTestState *qtest_init_without_qmp_handshake(const char *extra_args)
 {
-    QTestState *s = qtest_init_without_qmp_handshake(extra_args);
+    return qtest_init_internal(qtest_qemu_binary(NULL), extra_args);
+}
+
+QTestState *qtest_init_with_env(const char *var, const char *extra_args)
+{
+    QTestState *s = qtest_init_internal(qtest_qemu_binary(var), extra_args);
     QDict *greeting;
 
     /* Read the QMP greeting and then do the handshake */
@@ -529,6 +536,11 @@ QTestState *qtest_init(const char *extra_args)
     return s;
 }
 
+QTestState *qtest_init(const char *extra_args)
+{
+    return qtest_init_with_env(NULL, extra_args);
+}
+
 QTestState *qtest_vinitf(const char *fmt, va_list ap)
 {
     char *args = g_strdup_vprintf(fmt, ap);
-- 
2.41.0

