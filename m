Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AED7ED5B
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389526AbfHBHXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbfHBHXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:23:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E38C6F0CFF;
        Fri,  2 Aug 2019 07:23:37 +0000 (UTC)
Received: from thuth.com (dhcp-200-228.str.redhat.com [10.33.200.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADAA960605;
        Fri,  2 Aug 2019 07:23:36 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [kvm-unit-tests PULL 1/2] kvm-unit-tests: s390: add cpu model checks
Date:   Fri,  2 Aug 2019 09:23:28 +0200
Message-Id: <20190802072329.8276-2-thuth@redhat.com>
In-Reply-To: <20190802072329.8276-1-thuth@redhat.com>
References: <20190802072329.8276-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 02 Aug 2019 07:23:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

This adds a check for documented stfle dependencies.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
[thuth: Added missing report_prefix_pop() at the end]
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/Makefile      |  1 +
 s390x/cpumodel.c    | 60 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  3 +++
 3 files changed, 64 insertions(+)
 create mode 100644 s390x/cpumodel.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 1f21ddb..574a9a2 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -11,6 +11,7 @@ tests += $(TEST_DIR)/cmm.elf
 tests += $(TEST_DIR)/vector.elf
 tests += $(TEST_DIR)/gs.elf
 tests += $(TEST_DIR)/iep.elf
+tests += $(TEST_DIR)/cpumodel.elf
 tests_binary = $(patsubst %.elf,%.bin,$(tests))
 
 all: directories test_cases test_cases_binary
diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
new file mode 100644
index 0000000..3811ee1
--- /dev/null
+++ b/s390x/cpumodel.c
@@ -0,0 +1,60 @@
+/*
+ * Test the known dependencies for facilities
+ *
+ * Copyright 2019 IBM Corp.
+ *
+ * Authors:
+ *    Christian Borntraeger <borntraeger@de.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Library General Public License version 2.
+ */
+
+#include <asm/facility.h>
+
+static int dep[][2] = {
+	/* from SA22-7832-11 4-98 facility indications */
+	{   4,   3 },
+	{   5,   3 },
+	{   5,   4 },
+	{  19,  18 },
+	{  37,  42 },
+	{  43,  42 },
+	{  73,  49 },
+	{ 134, 129 },
+	{ 135, 129 },
+	{ 139,  25 },
+	{ 139,  28 },
+	{ 146,  76 },
+	/* indirectly documented in description */
+	{  78,   8 },  /* EDAT */
+	/* new dependencies from gen15 */
+	{  61,  45 },
+	{ 148, 129 },
+	{ 148, 135 },
+	{ 152, 129 },
+	{ 152, 134 },
+	{ 155,  76 },
+	{ 155,  77 },
+};
+
+int main(void)
+{
+	int i;
+
+	report_prefix_push("cpumodel");
+
+	report_prefix_push("dependency");
+	for (i = 0; i < ARRAY_SIZE(dep); i++) {
+		if (test_facility(dep[i][0])) {
+			report("%d implies %d", test_facility(dep[i][1]),
+				dep[i][0], dep[i][1]);
+		} else {
+			report_skip("facility %d not present", dep[i][0]);
+		}
+	}
+	report_prefix_pop();
+
+	report_prefix_pop();
+	return report_summary();
+}
diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
index 546b1f2..db58bad 100644
--- a/s390x/unittests.cfg
+++ b/s390x/unittests.cfg
@@ -61,3 +61,6 @@ file = gs.elf
 
 [iep]
 file = iep.elf
+
+[cpumodel]
+file = cpumodel.elf
-- 
2.21.0

