Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E05216A99
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 12:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgGGKmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 06:42:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47602 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726911AbgGGKmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 06:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594118535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=d/Cdj0P/nQnhxHtwDM4v2QMTaKgZjzQY/xCQv2QzIBo=;
        b=XMJguhhlRhUO/H8jdwliCb4EBO4kCK9wiOUNJXuzH5P7q7AqlFzt1rfCdcKWceAPCZ2cir
        wRVxIccVGRhhkBfktqqx9juzPTIRwzxXdEyXu3//BNo740sW7eGwCjTzxnnK/2u5buDBlH
        ZU/2EBYBBZwN6SyO7W3/bz2kFQRiXCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-6UQ-BGgAO-ucpzXuoZDGJg-1; Tue, 07 Jul 2020 06:42:13 -0400
X-MC-Unique: 6UQ-BGgAO-ucpzXuoZDGJg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E953319253CD;
        Tue,  7 Jul 2020 10:42:11 +0000 (UTC)
Received: from thuth.com (ovpn-112-77.ams2.redhat.com [10.36.112.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5046B5F7D8;
        Tue,  7 Jul 2020 10:42:07 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [kvm-unit-tests v2 PATCH] s390x/cpumodel: The missing DFP facility on TCG is expected
Date:   Tue,  7 Jul 2020 12:42:05 +0200
Message-Id: <20200707104205.25085-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 v2:
 - Rewrote the logic, introduced expected_tcg_fail flag
 - Use manufacturer string instead of VM name to detect TCG

 s390x/cpumodel.c | 49 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 5d232c6..190ceb2 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -11,14 +11,19 @@
  */
 
 #include <asm/facility.h>
+#include <alloc_page.h>
 
-static int dep[][2] = {
+static struct {
+	int facility;
+	int implied;
+	bool expected_tcg_fail;
+} dep[] = {
 	/* from SA22-7832-11 4-98 facility indications */
 	{   4,   3 },
 	{   5,   3 },
 	{   5,   4 },
 	{  19,  18 },
-	{  37,  42 },
+	{  37,  42, true },  /* TCG does not have DFP and won't get it soon */
 	{  43,  42 },
 	{  73,  49 },
 	{ 134, 129 },
@@ -38,6 +43,36 @@ static int dep[][2] = {
 	{ 155,  77 },
 };
 
+/*
+ * A hack to detect TCG (instead of KVM): QEMU uses "TCGguest" as guest
+ * name by default when we are running with TCG (otherwise it's "KVMguest")
+ */
+static bool is_tcg(void)
+{
+	const char qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
+	bool ret = false;
+	uint8_t *buf;
+
+	buf = alloc_page();
+	if (!buf)
+		return false;
+
+	if (stsi(buf, 1, 1, 1)) {
+		goto out;
+	}
+
+	/*
+	 * If the manufacturer string is "QEMU" in EBCDIC, then we are on TCG
+	 * (otherwise the string is "IBM" in EBCDIC)
+	 */
+	if (!memcmp(&buf[32], qemu_ebcdic, sizeof(qemu_ebcdic)))
+		ret =  true;
+out:
+	free_page(buf);
+	return ret;
+}
+
+
 int main(void)
 {
 	int i;
@@ -46,11 +81,13 @@ int main(void)
 
 	report_prefix_push("dependency");
 	for (i = 0; i < ARRAY_SIZE(dep); i++) {
-		if (test_facility(dep[i][0])) {
-			report(test_facility(dep[i][1]), "%d implies %d",
-				dep[i][0], dep[i][1]);
+		if (test_facility(dep[i].facility)) {
+			report_xfail(dep[i].expected_tcg_fail && is_tcg(),
+				     test_facility(dep[i].implied),
+				     "%d implies %d",
+				     dep[i].facility, dep[i].implied);
 		} else {
-			report_skip("facility %d not present", dep[i][0]);
+			report_skip("facility %d not present", dep[i].facility);
 		}
 	}
 	report_prefix_pop();
-- 
2.18.1

