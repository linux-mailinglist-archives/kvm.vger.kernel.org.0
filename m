Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB97D7D08F9
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 08:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376390AbjJTG7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 02:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376392AbjJTG7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 02:59:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62FC1A3
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 23:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697785130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DXWEVBlIcLBd6yDALjVLIhuAbVizKeUEyowRi41q+m0=;
        b=OuGdscBbP2k+sxev+I5zEqQdrm00c/ZicXqQSS4yQI/xluQHEjLiqk0t4p3b3tS/1x9a1W
        w01voNbSmIJOxMyjLbBnrI+rBaWPFI3KpcwjVNlwOmSCJfLnoDyRniGqJgVpRiCyQ93KO8
        1i5ssy6hmaEE45xlk7GclDILT/dtgPc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-zbzUsfckNCi7Kw-aqmSPxQ-1; Fri, 20 Oct 2023 02:58:45 -0400
X-MC-Unique: zbzUsfckNCi7Kw-aqmSPxQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FC6C869ECC;
        Fri, 20 Oct 2023 06:58:43 +0000 (UTC)
Received: from secure.mitica (unknown [10.39.194.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EACA25C0;
        Fri, 20 Oct 2023 06:58:36 +0000 (UTC)
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
Subject: [PULL 06/17] tests/qtest: Allow qtest_qemu_binary to use a custom environment variable
Date:   Fri, 20 Oct 2023 08:57:40 +0200
Message-ID: <20231020065751.26047-7-quintela@redhat.com>
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

We're adding support for testing migration using two different QEMU
binaries. We'll provide the second binary in a new environment
variable.

Allow qtest_qemu_binary() to receive the name of the new variable. If
the new environment variable is not set, that's not an error, we use
QTEST_QEMU_BINARY as a fallback.

Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Fabiano Rosas <farosas@suse.de>
Signed-off-by: Juan Quintela <quintela@redhat.com>
Message-ID: <20231018192741.25885-2-farosas@suse.de>
---
 tests/qtest/libqtest.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tests/qtest/libqtest.c b/tests/qtest/libqtest.c
index dc7a55634c..03fa644663 100644
--- a/tests/qtest/libqtest.c
+++ b/tests/qtest/libqtest.c
@@ -336,10 +336,17 @@ void qtest_remove_abrt_handler(void *data)
     }
 }
 
-static const char *qtest_qemu_binary(void)
+static const char *qtest_qemu_binary(const char *var)
 {
     const char *qemu_bin;
 
+    if (var) {
+        qemu_bin = getenv(var);
+        if (qemu_bin) {
+            return qemu_bin;
+        }
+    }
+
     qemu_bin = getenv("QTEST_QEMU_BINARY");
     if (!qemu_bin) {
         fprintf(stderr, "Environment variable QTEST_QEMU_BINARY required\n");
@@ -392,7 +399,7 @@ static QTestState *G_GNUC_PRINTF(1, 2) qtest_spawn_qemu(const char *fmt, ...)
 
     va_start(ap, fmt);
     g_string_append_printf(command, CMD_EXEC "%s %s",
-                           qtest_qemu_binary(), tracearg);
+                           qtest_qemu_binary(NULL), tracearg);
     g_string_append_vprintf(command, fmt, ap);
     va_end(ap);
 
@@ -905,7 +912,7 @@ char *qtest_hmp(QTestState *s, const char *fmt, ...)
 
 const char *qtest_get_arch(void)
 {
-    const char *qemu = qtest_qemu_binary();
+    const char *qemu = qtest_qemu_binary(NULL);
     const char *end = strrchr(qemu, '-');
 
     if (!end) {
-- 
2.41.0

