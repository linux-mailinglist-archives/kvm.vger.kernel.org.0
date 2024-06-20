Return-Path: <kvm+bounces-20083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 842C79107E1
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A51DA1C20F3F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8745F1AE090;
	Thu, 20 Jun 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H5VJW8C2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD7F1ACE6D;
	Thu, 20 Jun 2024 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893036; cv=none; b=TkovNOQDUo41PNkLmvSI6eV7m9HKnPhndWUunkxDl6Tc/KcojHX7F76m13EmS6GvKJoFaiD1p/QAflObGy4kgx/Zs/aDmufJt+sJuIWxT7SdmlX3wcMYv9gdPqaF0jhh5dHDRVAG3fC8iF4erCqjye5/Lf0Kl7tB99JdFgpSezY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893036; c=relaxed/simple;
	bh=tSuUhkcHUBVbRGL87e/lPChC0DGLQIcQj3pvWlKjLdE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IHESOLVYsATUE8x4QgGmoVjML3JWdA4Gf6rFP08ymy3Ld7kYk0c+S42rslSi/Euv9mBk0HQBhltg2Gf0tL0BVMD5+Pb2e7t//b/AYHgWbaXippGqVKDPJQ21i1+Vpj86XzM0PH9jpQqnBvBzp2psrhb5XnokaE0KHdkIopLMNhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H5VJW8C2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KDSp0A032754;
	Thu, 20 Jun 2024 14:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=dFg3nn9gW2ttJ
	UmKtKI+Tz+VuErne/BlGOk8p/+6ahs=; b=H5VJW8C2YpeHlOgCGtY0zD8KtIkyq
	F5wBJAdhYC3x6jkgrRu7UQCkbclDbegNmLE0twVDeelheqU4s4YdgjN3h1Umz/t4
	TSoDEcHBBADwcZl8EqLGCfbHWPN1AmO9AQECXgJUqyhbj101JEV/7KHSQWoZAUPz
	C7DtvaUOo2A1J1mAvGxevhN4NPVdfn0vHSIuux/xQ9ah4CcRJXcbpgJmegPg68hB
	wfIkQC9FYC+oRKow/LHYCxbQsmULww73zAdFdifj7Ijojt3XQjZlN70nY6+iqjdo
	huaCLBq+8mBWXMJqr1rBazxPAKaHmoPMMzeXBwO8TNwdDr4eU7Ahd0QEw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnbf04xd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:10 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KEHAxo020771;
	Thu, 20 Jun 2024 14:17:10 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvnbf04xa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KD5TDh013389;
	Thu, 20 Jun 2024 14:17:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysr046fnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 14:17:09 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KEH4A748103786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 14:17:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBD4B2004F;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC37420063;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 14:17:03 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 5/7] s390x: Add library functions for exiting from snippet
Date: Thu, 20 Jun 2024 16:16:58 +0200
Message-Id: <20240620141700.4124157-6-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240620141700.4124157-1-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pZJPbJuVPniqsyRs-KGi51tLsLS214HN
X-Proofpoint-ORIG-GUID: K-NnlvfFzGSsJICbGJzqO7nMgtLpFCej
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=905 phishscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200096

It is useful to be able to force an exit to the host from the snippet,
as well as do so while returning a value.
Add this functionality, also add helper functions for the host to check
for an exit and get or check the value.
Use diag 0x44 and 0x9c for this.
Add a guest specific snippet header file and rename snippet.h to reflect
that it is host specific.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/Makefile                          |  1 +
 lib/s390x/asm/arch_def.h                | 13 ++++++++
 lib/s390x/snippet-guest.h               | 26 +++++++++++++++
 lib/s390x/{snippet.h => snippet-host.h} | 10 ++++--
 lib/s390x/snippet-host.c                | 42 +++++++++++++++++++++++++
 lib/s390x/uv.c                          |  2 +-
 s390x/mvpg-sie.c                        |  2 +-
 s390x/pv-diags.c                        |  2 +-
 s390x/pv-icptcode.c                     |  2 +-
 s390x/pv-ipl.c                          |  2 +-
 s390x/sie-dat.c                         |  2 +-
 s390x/spec_ex-sie.c                     |  2 +-
 s390x/uv-host.c                         |  2 +-
 13 files changed, 97 insertions(+), 11 deletions(-)
 create mode 100644 lib/s390x/snippet-guest.h
 rename lib/s390x/{snippet.h => snippet-host.h} (92%)
 create mode 100644 lib/s390x/snippet-host.c

diff --git a/s390x/Makefile b/s390x/Makefile
index 23342bd6..12445fb5 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -111,6 +111,7 @@ cflatobjs += lib/s390x/css_lib.o
 cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
 cflatobjs += lib/s390x/sie.o
+cflatobjs += lib/s390x/snippet-host.o
 cflatobjs += lib/s390x/fault.o
 
 OBJDIRS += lib/s390x
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 745a3387..db04deca 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -504,4 +504,17 @@ static inline uint32_t get_prefix(void)
 	return current_prefix;
 }
 
+static inline void diag44(void)
+{
+	asm volatile("diag	0,0,0x44\n");
+}
+
+static inline void diag9c(uint64_t val)
+{
+	asm volatile("diag	%[val],0,0x9c\n"
+		:
+		: [val] "d"(val)
+	);
+}
+
 #endif
diff --git a/lib/s390x/snippet-guest.h b/lib/s390x/snippet-guest.h
new file mode 100644
index 00000000..3cc098e1
--- /dev/null
+++ b/lib/s390x/snippet-guest.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Snippet functionality for the guest.
+ *
+ * Copyright IBM Corp. 2023
+ */
+
+#ifndef _S390X_SNIPPET_GUEST_H_
+#define _S390X_SNIPPET_GUEST_H_
+
+#include <asm/arch_def.h>
+#include <asm/barrier.h>
+
+static inline void force_exit(void)
+{
+	diag44();
+	mb(); /* allow host to modify guest memory */
+}
+
+static inline void force_exit_value(uint64_t val)
+{
+	diag9c(val);
+	mb(); /* allow host to modify guest memory */
+}
+
+#endif /* _S390X_SNIPPET_GUEST_H_ */
diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet-host.h
similarity index 92%
rename from lib/s390x/snippet.h
rename to lib/s390x/snippet-host.h
index 910849aa..230b25b0 100644
--- a/lib/s390x/snippet.h
+++ b/lib/s390x/snippet-host.h
@@ -1,13 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Snippet definitions
+ * Snippet functionality for the host.
  *
  * Copyright IBM Corp. 2021
  * Author: Janosch Frank <frankja@linux.ibm.com>
  */
 
-#ifndef _S390X_SNIPPET_H_
-#define _S390X_SNIPPET_H_
+#ifndef _S390X_SNIPPET_HOST_H_
+#define _S390X_SNIPPET_HOST_H_
 
 #include <sie.h>
 #include <uv.h>
@@ -144,4 +144,8 @@ static inline void snippet_setup_guest(struct vm *vm, bool is_pv)
 	}
 }
 
+bool snippet_is_force_exit(struct vm *vm);
+bool snippet_is_force_exit_value(struct vm *vm);
+uint64_t snippet_get_force_exit_value(struct vm *vm);
+void snippet_check_force_exit_value(struct vm *vm, uint64_t exit_exp);
 #endif
diff --git a/lib/s390x/snippet-host.c b/lib/s390x/snippet-host.c
new file mode 100644
index 00000000..44a60bb9
--- /dev/null
+++ b/lib/s390x/snippet-host.c
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Snippet functionality for the host.
+ *
+ * Copyright IBM Corp. 2023
+ */
+
+#include <libcflat.h>
+#include <snippet-host.h>
+#include <sie.h>
+
+bool snippet_is_force_exit(struct vm *vm)
+{
+	return sie_is_diag_icpt(vm, 0x44);
+}
+
+bool snippet_is_force_exit_value(struct vm *vm)
+{
+	return sie_is_diag_icpt(vm, 0x9c);
+}
+
+uint64_t snippet_get_force_exit_value(struct vm *vm)
+{
+	struct kvm_s390_sie_block *sblk = vm->sblk;
+
+	assert(snippet_is_force_exit_value(vm));
+
+	return vm->save_area.guest.grs[(sblk->ipa & 0xf0) >> 4];
+}
+
+void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
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
diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 723bb4f2..c9fffbfc 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -18,7 +18,7 @@
 #include <asm/uv.h>
 #include <uv.h>
 #include <sie.h>
-#include <snippet.h>
+#include <snippet-host.h>
 
 static struct uv_cb_qui uvcb_qui = {
 	.header.cmd = UVC_CMD_QUI,
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index d182b49a..3aec9d71 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -19,7 +19,7 @@
 #include <alloc_page.h>
 #include <sclp.h>
 #include <sie.h>
-#include <snippet.h>
+#include <snippet-host.h>
 
 static struct vm vm;
 
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index 6ebe469a..a686c688 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -8,7 +8,7 @@
  *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
-#include <snippet.h>
+#include <snippet-host.h>
 #include <sie.h>
 #include <sclp.h>
 #include <asm/facility.h>
diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
index bc90df1e..82fd4246 100644
--- a/s390x/pv-icptcode.c
+++ b/s390x/pv-icptcode.c
@@ -12,7 +12,7 @@
 #include <sie.h>
 #include <smp.h>
 #include <sclp.h>
-#include <snippet.h>
+#include <snippet-host.h>
 #include <asm/facility.h>
 #include <asm/barrier.h>
 #include <asm/sigp.h>
diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
index cd49bd95..2acf7d0a 100644
--- a/s390x/pv-ipl.c
+++ b/s390x/pv-ipl.c
@@ -10,7 +10,7 @@
 #include <libcflat.h>
 #include <sie.h>
 #include <sclp.h>
-#include <snippet.h>
+#include <snippet-host.h>
 #include <asm/facility.h>
 #include <asm/uv.h>
 
diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
index f0257770..9e60f26e 100644
--- a/s390x/sie-dat.c
+++ b/s390x/sie-dat.c
@@ -16,7 +16,7 @@
 #include <alloc_page.h>
 #include <sclp.h>
 #include <sie.h>
-#include <snippet.h>
+#include <snippet-host.h>
 #include "snippets/c/sie-dat.h"
 
 static struct vm vm;
diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
index fe2f23ee..0ad7ec08 100644
--- a/s390x/spec_ex-sie.c
+++ b/s390x/spec_ex-sie.c
@@ -13,7 +13,7 @@
 #include <asm/arch_def.h>
 #include <alloc_page.h>
 #include <sie.h>
-#include <snippet.h>
+#include <snippet-host.h>
 #include <hardware.h>
 
 static struct vm vm;
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 55b46446..87d108b6 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -15,7 +15,7 @@
 #include <sclp.h>
 #include <smp.h>
 #include <uv.h>
-#include <snippet.h>
+#include <snippet-host.h>
 #include <mmu.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-- 
2.44.0


