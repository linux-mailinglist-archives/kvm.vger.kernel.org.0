Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F5E218AA5
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 17:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbgGHPBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 11:01:03 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52853 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729863AbgGHPBD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 11:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594220461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=xyg56AEaWg6EcPRPyzmB7YBwfS46RhbTFTWb5hVryyY=;
        b=DjrQhtU0+PdysxvU+UeNBExngRKp5+qFBT8adVZn0AwpYeix2aDf7FoJSSJZ0OOb9Fqnhd
        toi8pwb9syJlCEFgbKHtItUEcc69E7kYCQ8elf0W9nlkn9TzpkaVQpj025JcYZWeSjeISL
        FsMenuiesZyvWFz/RlAAxWK/3X5YmY4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-aMk1_cTXM1-f_24Y2BcanQ-1; Wed, 08 Jul 2020 11:00:59 -0400
X-MC-Unique: aMk1_cTXM1-f_24Y2BcanQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F8E2189E55F;
        Wed,  8 Jul 2020 15:00:32 +0000 (UTC)
Received: from thuth.com (ovpn-114-90.ams2.redhat.com [10.36.114.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B85A05BAC3;
        Wed,  8 Jul 2020 15:00:27 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, david@redhat.com,
        kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [kvm-unit-tests v3 PATCH] s390x/cpumodel: The missing DFP facility on TCG is expected
Date:   Wed,  8 Jul 2020 17:00:25 +0200
Message-Id: <20200708150025.20631-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 v3:
 - Moved the is_tcg() function to the library so that it can be used
   later by other tests, too
 - Make sure to call alloc_page() and stsi() only once

 v2:
 - Rewrote the logic, introduced expected_tcg_fail flag
 - Use manufacturer string instead of VM name to detect TCG

 lib/s390x/vm.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/vm.h   | 14 ++++++++++++++
 s390x/Makefile   |  1 +
 s390x/cpumodel.c | 19 +++++++++++++------
 4 files changed, 74 insertions(+), 6 deletions(-)
 create mode 100644 lib/s390x/vm.c
 create mode 100644 lib/s390x/vm.h

diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
new file mode 100644
index 0000000..c852713
--- /dev/null
+++ b/lib/s390x/vm.c
@@ -0,0 +1,46 @@
+/*
+ * Functions to retrieve VM-specific information
+ *
+ * Copyright (c) 2020 Red Hat Inc
+ *
+ * Authors:
+ *  Thomas Huth <thuth@redhat.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <asm/arch_def.h>
+#include "vm.h"
+
+/**
+ * Detect whether we are running with TCG (instead of KVM)
+ */
+bool vm_is_tcg(void)
+{
+	const char qemu_ebcdic[] = { 0xd8, 0xc5, 0xd4, 0xe4 };
+	static bool initialized = false;
+	static bool is_tcg = false;
+	uint8_t *buf;
+
+	if (initialized)
+		return is_tcg;
+
+	buf = alloc_page();
+	if (!buf)
+		return false;
+
+	if (stsi(buf, 1, 1, 1))
+		goto out;
+
+	/*
+	 * If the manufacturer string is "QEMU" in EBCDIC, then we
+	 * are on TCG (otherwise the string is "IBM" in EBCDIC)
+	 */
+	is_tcg = !memcmp(&buf[32], qemu_ebcdic, sizeof(qemu_ebcdic));
+	initialized = true;
+out:
+	free_page(buf);
+	return is_tcg;
+}
diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
new file mode 100644
index 0000000..33008d8
--- /dev/null
+++ b/lib/s390x/vm.h
@@ -0,0 +1,14 @@
+/*
+ * Functions to retrieve VM-specific information
+ *
+ * Copyright (c) 2020 Red Hat Inc
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+
+#ifndef S390X_VM_H
+#define S390X_VM_H
+
+bool vm_is_tcg(void);
+
+#endif  /* S390X_VM_H */
diff --git a/s390x/Makefile b/s390x/Makefile
index ddb4b48..98ac29e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -51,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
 cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
+cflatobjs += lib/s390x/vm.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 5d232c6..116a966 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -11,14 +11,19 @@
  */
 
 #include <asm/facility.h>
+#include <vm.h>
 
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
@@ -46,11 +51,13 @@ int main(void)
 
 	report_prefix_push("dependency");
 	for (i = 0; i < ARRAY_SIZE(dep); i++) {
-		if (test_facility(dep[i][0])) {
-			report(test_facility(dep[i][1]), "%d implies %d",
-				dep[i][0], dep[i][1]);
+		if (test_facility(dep[i].facility)) {
+			report_xfail(dep[i].expected_tcg_fail && vm_is_tcg(),
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

