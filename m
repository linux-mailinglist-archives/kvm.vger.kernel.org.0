Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93AD7D090A
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376421AbjJTHAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376412AbjJTHAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF0AD51
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697785171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rbNbI20heWd00U5Y9TovTUKtsrNmucO4Gcl0M7WtmH8=;
        b=APMyUcvJe+SM2ydO+F3XULMgakK+uHmAvfJId3Ckz7+/t21APOMs1/IWSlMu/w46DGo1Wg
        /+Qa5ZnSvCbIh15hZ2qhFJ3fNs9sbwsqNG5I4ibcbAglVMMrscnWc7l3DAb25BR3l2z5iB
        cMmXXK5z3hWEpk+Wj+LKKEWvJ0vHnF8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-B_HUPvvDP0CLP862x3tfYw-1; Fri, 20 Oct 2023 02:59:27 -0400
X-MC-Unique: B_HUPvvDP0CLP862x3tfYw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C20688B7A2;
        Fri, 20 Oct 2023 06:59:25 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC06F25C0;
        Fri, 20 Oct 2023 06:59:18 +0000 (UTC)
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
Subject: [PULL 12/17] tests/qtest/migration: Define a machine for all architectures
Date:   Fri, 20 Oct 2023 08:57:46 +0200
Message-ID: <20231020065751.26047-13-quintela@redhat.com>
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

Stop relying on defaults and select a machine explicitly for every
architecture.

This is a prerequisite for being able to select machine types for
migration using different QEMU binaries for source and destination.

Signed-off-by: Fabiano Rosas <farosas@suse.de>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Message-ID: <20231018192741.25885-8-farosas@suse.de>
---
 tests/qtest/migration-test.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tests/qtest/migration-test.c b/tests/qtest/migration-test.c
index 241b409857..dfea75b76f 100644
--- a/tests/qtest/migration-test.c
+++ b/tests/qtest/migration-test.c
@@ -743,6 +743,7 @@ static int test_migrate_start(QTestState **from, QTestState **to,
     const char *kvm_opts = NULL;
     const char *arch = qtest_get_arch();
     const char *memory_size;
+    const char *machine_alias, *machine_opts = "";
 
     if (args->use_shmem) {
         if (!g_file_test("/dev/shm", G_FILE_TEST_IS_DIR)) {
@@ -755,11 +756,13 @@ static int test_migrate_start(QTestState **from, QTestState **to,
     got_dst_resume = false;
     if (strcmp(arch, "i386") == 0 || strcmp(arch, "x86_64") == 0) {
         memory_size = "150M";
+        machine_alias = "pc";
         arch_opts = g_strdup_printf("-drive file=%s,format=raw", bootpath);
         start_address = X86_TEST_MEM_START;
         end_address = X86_TEST_MEM_END;
     } else if (g_str_equal(arch, "s390x")) {
         memory_size = "128M";
+        machine_alias = "s390-ccw-virtio";
         arch_opts = g_strdup_printf("-bios %s", bootpath);
         start_address = S390_TEST_MEM_START;
         end_address = S390_TEST_MEM_END;
@@ -771,11 +774,14 @@ static int test_migrate_start(QTestState **from, QTestState **to,
                                       "'nvramrc=hex .\" _\" begin %x %x "
                                       "do i c@ 1 + i c! 1000 +loop .\" B\" 0 "
                                       "until'", end_address, start_address);
-        arch_opts = g_strdup("-nodefaults -machine vsmt=8");
+        machine_alias = "pseries";
+        machine_opts = "vsmt=8";
+        arch_opts = g_strdup("-nodefaults");
     } else if (strcmp(arch, "aarch64") == 0) {
         memory_size = "150M";
-        arch_opts = g_strdup_printf("-machine virt,gic-version=max -cpu max "
-                                    "-kernel %s", bootpath);
+        machine_alias = "virt";
+        machine_opts = "gic-version=max";
+        arch_opts = g_strdup_printf("-cpu max -kernel %s", bootpath);
         start_address = ARM_TEST_MEM_START;
         end_address = ARM_TEST_MEM_END;
     } else {
@@ -810,11 +816,13 @@ static int test_migrate_start(QTestState **from, QTestState **to,
     }
 
     cmd_source = g_strdup_printf("-accel kvm%s -accel tcg "
+                                 "-machine %s,%s "
                                  "-name source,debug-threads=on "
                                  "-m %s "
                                  "-serial file:%s/src_serial "
                                  "%s %s %s %s %s",
                                  kvm_opts ? kvm_opts : "",
+                                 machine_alias, machine_opts,
                                  memory_size, tmpfs,
                                  arch_opts ? arch_opts : "",
                                  arch_source ? arch_source : "",
@@ -829,12 +837,14 @@ static int test_migrate_start(QTestState **from, QTestState **to,
     }
 
     cmd_target = g_strdup_printf("-accel kvm%s -accel tcg "
+                                 "-machine %s,%s "
                                  "-name target,debug-threads=on "
                                  "-m %s "
                                  "-serial file:%s/dest_serial "
                                  "-incoming %s "
                                  "%s %s %s %s %s",
                                  kvm_opts ? kvm_opts : "",
+                                 machine_alias, machine_opts,
                                  memory_size, tmpfs, uri,
                                  arch_opts ? arch_opts : "",
                                  arch_target ? arch_target : "",
-- 
2.41.0

