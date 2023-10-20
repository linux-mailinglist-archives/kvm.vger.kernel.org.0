Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAED7D090D
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376402AbjJTHAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376435AbjJTHAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:00:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E24D65
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697785196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pAJTnVpdSndHpJHcO4Q9CXE/YX/zGK2bRQ4iuRIKTlg=;
        b=HZEHbPMvttU4IG7gMqLVPpuCd7lXaAcRrBVMeololpshIQw/B7BgT/Ui6tgQyNo0lUoXKG
        AEkB6kFeAwrS02mI4MgUJU33Uf2Qri4zXQKki8jEwWWaA/Un9wcMWcvI/mJL1WWL69pGz5
        3/h76eVjHKNu5HMqMPm1kIS1gYPnSsc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-mraWogRDOOm_TQ1VtIgBmQ-1; Fri, 20 Oct 2023 02:59:48 -0400
X-MC-Unique: mraWogRDOOm_TQ1VtIgBmQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94E9A1C05159;
        Fri, 20 Oct 2023 06:59:46 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE43025C1;
        Fri, 20 Oct 2023 06:59:39 +0000 (UTC)
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
Subject: [PULL 15/17] tests/qtest/migration: Support more than one QEMU binary
Date:   Fri, 20 Oct 2023 08:57:49 +0200
Message-ID: <20231020065751.26047-16-quintela@redhat.com>
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

We have strict rules around migration compatibility between different
QEMU versions but no test to validate the migration state between
different binaries.

Add infrastructure to allow running the migration tests with two
different QEMU binaries as migration source and destination.

The code now recognizes two new environment variables
QTEST_QEMU_BINARY_SRC and QTEST_QEMU_BINARY_DST. In the absence of
either of them, the test will use the QTEST_QEMU_BINARY variable. If
both are missing then the tests are run with single binary as
previously.

The machine type is selected automatically as the latest machine type
version that works with both binaries.

Usage (only one of SRC|DST is allowed):

QTEST_QEMU_BINARY_SRC=../build-8.2.0/qemu-system-x86_64 \
QTEST_QEMU_BINARY=../build-8.1.0/qemu-system-x86_64 \
./tests/qtest/migration-test

Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Fabiano Rosas <farosas@suse.de>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Message-ID: <20231018192741.25885-11-farosas@suse.de>
---
 tests/qtest/migration-test.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/tests/qtest/migration-test.c b/tests/qtest/migration-test.c
index 03f3feac7b..4a5d37317a 100644
--- a/tests/qtest/migration-test.c
+++ b/tests/qtest/migration-test.c
@@ -71,6 +71,8 @@ static bool got_dst_resume;
 #define QEMU_VM_FILE_MAGIC 0x5145564d
 #define FILE_TEST_FILENAME "migfile"
 #define FILE_TEST_OFFSET 0x1000
+#define QEMU_ENV_SRC "QTEST_QEMU_BINARY_SRC"
+#define QEMU_ENV_DST "QTEST_QEMU_BINARY_DST"
 
 #if defined(__linux__)
 #include <sys/syscall.h>
@@ -744,6 +746,7 @@ static int test_migrate_start(QTestState **from, QTestState **to,
     const char *arch = qtest_get_arch();
     const char *memory_size;
     const char *machine_alias, *machine_opts = "";
+    g_autofree char *machine = NULL;
 
     if (args->use_shmem) {
         if (!g_file_test("/dev/shm", G_FILE_TEST_IS_DIR)) {
@@ -822,6 +825,10 @@ static int test_migrate_start(QTestState **from, QTestState **to,
         kvm_opts = ",dirty-ring-size=4096";
     }
 
+    machine = find_common_machine_version(machine_alias, QEMU_ENV_SRC,
+                                          QEMU_ENV_DST);
+    g_test_message("Using machine type: %s", machine);
+
     cmd_source = g_strdup_printf("-accel kvm%s -accel tcg "
                                  "-machine %s,%s "
                                  "-name source,debug-threads=on "
@@ -829,7 +836,7 @@ static int test_migrate_start(QTestState **from, QTestState **to,
                                  "-serial file:%s/src_serial "
                                  "%s %s %s %s %s",
                                  kvm_opts ? kvm_opts : "",
-                                 machine_alias, machine_opts,
+                                 machine, machine_opts,
                                  memory_size, tmpfs,
                                  arch_opts ? arch_opts : "",
                                  arch_source ? arch_source : "",
@@ -837,7 +844,7 @@ static int test_migrate_start(QTestState **from, QTestState **to,
                                  args->opts_source ? args->opts_source : "",
                                  ignore_stderr);
     if (!args->only_target) {
-        *from = qtest_init(cmd_source);
+        *from = qtest_init_with_env(QEMU_ENV_SRC, cmd_source);
         qtest_qmp_set_event_callback(*from,
                                      migrate_watch_for_stop,
                                      &got_src_stop);
@@ -851,14 +858,14 @@ static int test_migrate_start(QTestState **from, QTestState **to,
                                  "-incoming %s "
                                  "%s %s %s %s %s",
                                  kvm_opts ? kvm_opts : "",
-                                 machine_alias, machine_opts,
+                                 machine, machine_opts,
                                  memory_size, tmpfs, uri,
                                  arch_opts ? arch_opts : "",
                                  arch_target ? arch_target : "",
                                  shmem_opts ? shmem_opts : "",
                                  args->opts_target ? args->opts_target : "",
                                  ignore_stderr);
-    *to = qtest_init(cmd_target);
+    *to = qtest_init_with_env(QEMU_ENV_DST, cmd_target);
     qtest_qmp_set_event_callback(*to,
                                  migrate_watch_for_resume,
                                  &got_dst_resume);
@@ -2989,10 +2996,23 @@ int main(int argc, char **argv)
     bool has_uffd;
     const char *arch;
     g_autoptr(GError) err = NULL;
+    const char *qemu_src = getenv(QEMU_ENV_SRC);
+    const char *qemu_dst = getenv(QEMU_ENV_DST);
     int ret;
 
     g_test_init(&argc, &argv, NULL);
 
+    /*
+     * The default QTEST_QEMU_BINARY must always be provided because
+     * that is what helpers use to query the accel type and
+     * architecture.
+     */
+    if (qemu_src && qemu_dst) {
+        g_test_message("Only one of %s, %s is allowed",
+                       QEMU_ENV_SRC, QEMU_ENV_DST);
+        exit(1);
+    }
+
     has_kvm = qtest_has_accel("kvm");
     has_tcg = qtest_has_accel("tcg");
 
-- 
2.41.0

