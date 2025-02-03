Return-Path: <kvm+bounces-37100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 110F8A25482
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 894F018833D1
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF81D1FE466;
	Mon,  3 Feb 2025 08:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MJmDrr9X"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0221FBC92
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571805; cv=none; b=WWtoEQ6FDtBKCPIqnvopA4BNMWRCI2PlnyohQwoQnUcoqAFjDQvzZG4MSM+egE1uzn+zfVEbYSTkzF2Kl1cJouch3AxkDiZg6XHG/lLUFC+XEPh8tnvMvpZ9vDUu/QU8yqZOqTQAmDgyneNr7X7lnQM8CX14mqdpk+hBOBH7Dsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571805; c=relaxed/simple;
	bh=6J2E+GafP9GP+EDU3mwFGlAbtSZDBQxjsHAovyykeA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th+iJPFwWhiClD6cKUEGeOkzr+P1LoOPdXi3vZw0Ovh2TIeDII3tZbEHE7nKDga69WnY34IIZtW6R26Hj6A2QGSyXNf4vwanrsDPyM/zCHnA7qPxO++gKrbAXk8kAclk0IAFvacYPqW2xFcU5LzprhgAX/OOhmOioY8r4am3Esk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MJmDrr9X; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5135Nj0B012875;
	Mon, 3 Feb 2025 08:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zWpbI07Qh1H179L5N
	ZcyLr/xpTr9x8G65Lj0lVc/pho=; b=MJmDrr9XkPoKux7+R1yxsaFQHaOCQ7TpQ
	fiirYCFF6qkicQFxM2JciowUx6r2C8rKLOZ7M6+coeiKg3TsS3V4GXpENORXSlmF
	O1m6NSttuUMI9OvuwkL2rGlL4zKNQ5pIJY3WqdbPYwlHlBT7QAWVw+0BiIkDQnWw
	Sr8YxHAmk/hXZOa2wvXoazJT82qUbq8YOUlD8BsYxc3sPVox8BAxdFsLLZIw2cCy
	IYvyt9DOm5ig6DFIo5oXz/xZt8Mm19+JYRSavQ/ZPJttSiUGmkly3sogQB6QNu4s
	T4tiRwLCDWhoI+f5+JLyHHkhCEVxk4zM5Mh0ja06T0bTDaDUKA4Pw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jqm78svf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:32 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5138aEFB005251;
	Mon, 3 Feb 2025 08:36:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j05jn6ap-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:32 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aSli48234752
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 822BE20040;
	Mon,  3 Feb 2025 08:36:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1472F2004D;
	Mon,  3 Feb 2025 08:36:28 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:28 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 08/18] s390x: Add library functions for exiting from snippet
Date: Mon,  3 Feb 2025 09:35:16 +0100
Message-ID: <20250203083606.22864-9-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RwGLNSxHw8bd4zE002Wc3qT9h5OR69iM
X-Proofpoint-ORIG-GUID: RwGLNSxHw8bd4zE002Wc3qT9h5OR69iM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=862 bulkscore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502030068

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

It is useful to be able to force an exit to the host from the snippet,
as well as do so while returning a value.
Add this functionality, also add helper functions for the host to check
for an exit and get or check the value.
Use diag 0x44 and 0x9c for this.
Add a guest specific snippet header file and rename snippet.h to reflect
that it is host specific.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Link: https://lore.kernel.org/r/20241016180320.686132-5-nsg@linux.ibm.com
[ nrb: fix out-of-tree builds ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile                    |  7 +++--
 lib/s390x/asm/arch_def.h          | 16 +++++++++++
 lib/s390x/snippet-exit.h          | 45 +++++++++++++++++++++++++++++++
 s390x/snippets/lib/snippet-exit.h | 28 +++++++++++++++++++
 4 files changed, 94 insertions(+), 2 deletions(-)
 create mode 100644 lib/s390x/snippet-exit.h
 create mode 100644 s390x/snippets/lib/snippet-exit.h

diff --git a/s390x/Makefile b/s390x/Makefile
index 907b3a04..9eeff198 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -71,7 +71,8 @@ test_cases: $(tests)
 test_cases_binary: $(tests_binary)
 test_cases_pv: $(tests_pv_binary)
 
-INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
+SNIPPET_INCLUDE :=
+INCLUDE_PATHS = $(SNIPPET_INCLUDE) $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
 # Include generated header files (e.g. in case of out-of-source builds)
 INCLUDE_PATHS += lib
 CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
@@ -122,6 +123,7 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
 FLATLIBS = $(libcflat)
 
 SNIPPET_DIR = $(TEST_DIR)/snippets
+SNIPPET_SRC_DIR = $(SRCDIR)/s390x/snippets
 snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
 snippet_lib = $(snippet_asmlib) lib/auxinfo.o
 
@@ -149,9 +151,10 @@ snippet-hdr-obj =
 endif
 
 # the asm/c snippets %.o have additional generated files as dependencies
-$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
+$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_SRC_DIR)/asm/%.S $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
+$(SNIPPET_DIR)/c/%.o: SNIPPET_INCLUDE := $(SNIPPET_SRC_DIR)/lib
 $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 5574a451..03adcd3c 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -505,4 +505,20 @@ static inline uint32_t get_prefix(void)
 	return current_prefix;
 }
 
+static inline void diag44(void)
+{
+	asm volatile("diag	0,0,0x44\n");
+}
+
+static inline void diag500(uint64_t val)
+{
+	asm volatile(
+		"lgr	2,%[val]\n"
+		"diag	0,0,0x500\n"
+		:
+		: [val] "d"(val)
+		: "r2"
+	);
+}
+
 #endif
diff --git a/lib/s390x/snippet-exit.h b/lib/s390x/snippet-exit.h
new file mode 100644
index 00000000..3ed4c22c
--- /dev/null
+++ b/lib/s390x/snippet-exit.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Functionality handling snippet exits
+ *
+ * Copyright IBM Corp. 2024
+ */
+
+#ifndef _S390X_SNIPPET_EXIT_H_
+#define _S390X_SNIPPET_EXIT_H_
+
+#include <libcflat.h>
+#include <sie.h>
+#include <sie-icpt.h>
+
+static inline bool snippet_is_force_exit(struct vm *vm)
+{
+	return sie_is_diag_icpt(vm, 0x44);
+}
+
+static inline bool snippet_is_force_exit_value(struct vm *vm)
+{
+	return sie_is_diag_icpt(vm, 0x500);
+}
+
+static inline uint64_t snippet_get_force_exit_value(struct vm *vm)
+{
+	assert(snippet_is_force_exit_value(vm));
+
+	return vm->save_area.guest.grs[2];
+}
+
+static inline void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
+{
+	uint64_t value;
+
+	if (snippet_is_force_exit_value(vm)) {
+		value = snippet_get_force_exit_value(vm);
+		report(value == value_exp, "guest forced exit with value (0x%lx == 0x%lx)",
+		       value, value_exp);
+	} else {
+		report_fail("guest forced exit with value");
+	}
+}
+
+#endif /* _S390X_SNIPPET_EXIT_H_ */
diff --git a/s390x/snippets/lib/snippet-exit.h b/s390x/snippets/lib/snippet-exit.h
new file mode 100644
index 00000000..ac00de3f
--- /dev/null
+++ b/s390x/snippets/lib/snippet-exit.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Functionality for exiting the snippet.
+ *
+ * Copyright IBM Corp. 2023
+ */
+
+#ifndef _S390X_SNIPPET_LIB_EXIT_H_
+#define _S390X_SNIPPET_LIB_EXIT_H_
+
+#include <asm/arch_def.h>
+#include <asm/barrier.h>
+
+static inline void force_exit(void)
+{
+	mb(); /* host may read any memory written by the guest before */
+	diag44();
+	mb(); /* allow host to modify guest memory */
+}
+
+static inline void force_exit_value(uint64_t val)
+{
+	mb(); /* host may read any memory written by the guest before */
+	diag500(val);
+	mb(); /* allow host to modify guest memory */
+}
+
+#endif /* _S390X_SNIPPET_LIB_EXIT_H_ */
-- 
2.47.1


