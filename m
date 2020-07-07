Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7A221660B
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 07:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgGGF4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 01:56:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30820 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727827AbgGGF4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 01:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594101388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=KI7a2ClZlMwCFO1SBXPRqL8eILTZTxkGByXxhshBqFQ=;
        b=EAROSK1LohZqOuLZ8CpsyqoBxoiK9gfV+jGmit/veThXOD5RGmL+OnJ7GRCG4nY4TuinMJ
        ZbIsb0w2TsfpdIckO7cZvNr1f2GyHOcUFxlk8er29JiPi9d6x0NHfNyVx9EhF3MVpjvRDq
        SDk/PkXyQ7NW6NXqpKjVOOSdDemzDjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-s1z1ynX6NUKY6W_P2OnKEQ-1; Tue, 07 Jul 2020 01:56:26 -0400
X-MC-Unique: s1z1ynX6NUKY6W_P2OnKEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B946419067E3;
        Tue,  7 Jul 2020 05:56:25 +0000 (UTC)
Received: from thuth.com (ovpn-112-77.ams2.redhat.com [10.36.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A33E70100;
        Tue,  7 Jul 2020 05:56:21 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests PATCH] s390x/cpumodel: The missing DFP facility on TCG is expected
Date:   Tue,  7 Jul 2020 07:56:19 +0200
Message-Id: <20200707055619.6162-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running the kvm-unit-tests with TCG on s390x, the cpumodel test
always reports the error about the missing DFP (decimal floating point)
facility. This is kind of expected, since DFP is not required for
running Linux and thus nobody is really interested in implementing
this facility in TCG. Thus let's mark this as an expected error instead,
so that we can run the kvm-unit-tests also with TCG without getting
test failures that we do not care about.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/cpumodel.c | 51 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 5d232c6..4310b92 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -11,6 +11,7 @@
  */
 
 #include <asm/facility.h>
+#include <alloc_page.h>
 
 static int dep[][2] = {
 	/* from SA22-7832-11 4-98 facility indications */
@@ -38,6 +39,49 @@ static int dep[][2] = {
 	{ 155,  77 },
 };
 
+/*
+ * A hack to detect TCG (instead of KVM): QEMU uses "TCGguest" as guest
+ * name by default when we are running with TCG (otherwise it's "KVMguest")
+ */
+static bool is_tcg(void)
+{
+	bool ret = false;
+	uint8_t *buf;
+
+	buf = alloc_page();
+	if (!buf)
+		return false;
+
+	if (stsi(buf, 3, 2, 2)) {
+		goto out;
+	}
+
+	/* Does the name start with "TCG" in EBCDIC? */
+	if (buf[2048] == 0x54 && buf[2049] == 0x43 && buf[2050] == 0x47)
+		ret = true;
+
+out:
+	free_page(buf);
+	return ret;
+}
+
+static void check_dependency(int dep1, int dep2)
+{
+	if (test_facility(dep1)) {
+		if (dep1 == 37) {
+			/* TCG does not have DFP and is unlikely to
+			 * get it implemented soon. */
+			report_xfail(is_tcg(), test_facility(dep2),
+				     "%d implies %d", dep1, dep2);
+		} else {
+			report(test_facility(dep2), "%d implies %d",
+			       dep1, dep2);
+		}
+	} else {
+		report_skip("facility %d not present", dep1);
+	}
+}
+
 int main(void)
 {
 	int i;
@@ -46,12 +90,7 @@ int main(void)
 
 	report_prefix_push("dependency");
 	for (i = 0; i < ARRAY_SIZE(dep); i++) {
-		if (test_facility(dep[i][0])) {
-			report(test_facility(dep[i][1]), "%d implies %d",
-				dep[i][0], dep[i][1]);
-		} else {
-			report_skip("facility %d not present", dep[i][0]);
-		}
+		check_dependency(dep[i][0], dep[i][1]);
 	}
 	report_prefix_pop();
 
-- 
2.18.1

