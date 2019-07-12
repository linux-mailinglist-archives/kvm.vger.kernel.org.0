Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5EE67162
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfGLOcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:32:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727180AbfGLOcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:32:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B0E630860A0;
        Fri, 12 Jul 2019 14:32:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 781F960920;
        Fri, 12 Jul 2019 14:32:17 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>
Subject: [PULL 03/19] migration-test: Add migration multifd test
Date:   Fri, 12 Jul 2019 16:31:51 +0200
Message-Id: <20190712143207.4214-4-quintela@redhat.com>
In-Reply-To: <20190712143207.4214-1-quintela@redhat.com>
References: <20190712143207.4214-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 12 Jul 2019 14:32:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We set multifd-channels.

Signed-off-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Tested-by: Wei Yang <richardw.yang@linux.intel.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 tests/migration-test.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tests/migration-test.c b/tests/migration-test.c
index a4feb9545d..0dcaad86b5 100644
--- a/tests/migration-test.c
+++ b/tests/migration-test.c
@@ -1121,6 +1121,53 @@ static void test_migrate_fd_proto(void)
     test_migrate_end(from, to, true);
 }
 
+static void test_multifd_tcp(void)
+{
+    char *uri;
+    QTestState *from, *to;
+
+    if (test_migrate_start(&from, &to, "tcp:127.0.0.1:0", false, false)) {
+        return;
+    }
+
+    /*
+     * We want to pick a speed slow enough that the test completes
+     * quickly, but that it doesn't complete precopy even on a slow
+     * machine, so also set the downtime.
+     */
+    /* 1 ms should make it not converge*/
+    migrate_set_parameter_int(from, "downtime-limit", 1);
+    /* 1GB/s */
+    migrate_set_parameter_int(from, "max-bandwidth", 1000000000);
+
+    migrate_set_parameter_int(from, "multifd-channels", 2);
+    migrate_set_parameter_int(to, "multifd-channels", 2);
+
+    migrate_set_capability(from, "multifd", "true");
+    migrate_set_capability(to, "multifd", "true");
+    /* Wait for the first serial output from the source */
+    wait_for_serial("src_serial");
+
+    uri = migrate_get_socket_address(to, "socket-address");
+
+    migrate(from, uri, "{}");
+
+    wait_for_migration_pass(from);
+
+    /* 300ms it should converge */
+    migrate_set_parameter_int(from, "downtime-limit", 600);
+
+    if (!got_stop) {
+        qtest_qmp_eventwait(from, "STOP");
+    }
+    qtest_qmp_eventwait(to, "RESUME");
+
+    wait_for_serial("dest_serial");
+    wait_for_migration_complete(from);
+    test_migrate_end(from, to, true);
+    free(uri);
+}
+
 int main(int argc, char **argv)
 {
     char template[] = "/tmp/migration-test-XXXXXX";
@@ -1176,6 +1223,7 @@ int main(int argc, char **argv)
     /* qtest_add_func("/migration/ignore_shared", test_ignore_shared); */
     qtest_add_func("/migration/xbzrle/unix", test_xbzrle_unix);
     qtest_add_func("/migration/fd_proto", test_migrate_fd_proto);
+    qtest_add_func("/migration/multifd/tcp", test_multifd_tcp);
 
     ret = g_test_run();
 
-- 
2.21.0

