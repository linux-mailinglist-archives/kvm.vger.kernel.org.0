Return-Path: <kvm+bounces-5759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 50980825CAA
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 23:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBC1BB2220E
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 22:55:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5214C364D4;
	Fri,  5 Jan 2024 22:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NcCTYKcJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17FA364A3;
	Fri,  5 Jan 2024 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 405LMZiC027055;
	Fri, 5 Jan 2024 22:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4DYS/nkWTa3TlYWZmu+ClvWFwSWsfv/CLELH7mGCz7I=;
 b=NcCTYKcJfgMJbP5PyOa0+xaMdemBK0X6/bAzwVmlclDVxUsr4149GgHyYP+kM5HV9C3S
 M2uqFYVYhrSGE8qdEB4CTo6kWhIzzAHPwuxJJHrrAEkIhSIPC9vp1ugQpeXJNnh09vwS
 L8IPD1CinP852y6mYPhVjEu5983/SIRhVW4WmE6PbLab9fC5Lhd1mBh7ED8u0n1RBrn3
 DAke9wyLw6EGV1eibIxLn3am8s1FoBS0QQy4XAG7kq3CyAWR2URE/s7yzRH5oYpYyBdH
 dZy0P5TBGcE84YxFo8mi5bzOq89vvUjKn8HC9/f1Aj2EAXO2/XApAd+PS120L7yKkb5j 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ves8kt9ft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:28 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 405MUnYD029878;
	Fri, 5 Jan 2024 22:54:28 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ves8kt9fg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:27 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 405MHjkF007335;
	Fri, 5 Jan 2024 22:54:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vaxhpjc5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Jan 2024 22:54:26 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 405MsNJm28377710
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Jan 2024 22:54:23 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89DAD20043;
	Fri,  5 Jan 2024 22:54:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4498B20040;
	Fri,  5 Jan 2024 22:54:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  5 Jan 2024 22:54:23 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 3/5] s390x: Add library functions for exiting from snippet
Date: Fri,  5 Jan 2024 23:54:17 +0100
Message-Id: <20240105225419.2841310-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240105225419.2841310-1-nsg@linux.ibm.com>
References: <20240105225419.2841310-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ay2sOXapFEylXwImCg2M8tkXZkNn22pI
X-Proofpoint-ORIG-GUID: wum636TjbmQg0iI7cuQJBa29lq0ZGwK6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-05_08,2024-01-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 mlxlogscore=838 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401050176

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
 lib/s390x/sie.h                         |  1 +
 lib/s390x/snippet-guest.h               | 26 +++++++++++++++
 lib/s390x/{snippet.h => snippet-host.h} | 10 ++++--
 lib/s390x/sie.c                         | 31 ++++++++++++++++++
 lib/s390x/snippet-host.c                | 42 +++++++++++++++++++++++++
 lib/s390x/uv.c                          |  2 +-
 s390x/mvpg-sie.c                        |  2 +-
 s390x/pv-diags.c                        |  2 +-
 s390x/pv-icptcode.c                     |  2 +-
 s390x/pv-ipl.c                          |  2 +-
 s390x/sie-dat.c                         |  2 +-
 s390x/spec_ex-sie.c                     |  2 +-
 s390x/uv-host.c                         |  2 +-
 15 files changed, 129 insertions(+), 11 deletions(-)
 create mode 100644 lib/s390x/snippet-guest.h
 rename lib/s390x/{snippet.h => snippet-host.h} (92%)
 create mode 100644 lib/s390x/snippet-host.c

diff --git a/s390x/Makefile b/s390x/Makefile
index f79fd009..a10695a2 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -109,6 +109,7 @@ cflatobjs += lib/s390x/css_lib.o
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
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index c1724cf2..18fdd72e 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -281,6 +281,7 @@ void sie_expect_validity(struct vm *vm);
 uint16_t sie_get_validity(struct vm *vm);
 void sie_check_validity(struct vm *vm, uint16_t vir_exp);
 void sie_handle_validity(struct vm *vm);
+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag);
 void sie_guest_sca_create(struct vm *vm);
 void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
 void sie_guest_destroy(struct vm *vm);
diff --git a/lib/s390x/snippet-guest.h b/lib/s390x/snippet-guest.h
new file mode 100644
index 00000000..e82e8e29
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
+#endif
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
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 40936bd2..6bda493d 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -42,6 +42,37 @@ void sie_check_validity(struct vm *vm, uint16_t vir_exp)
 	report(vir_exp == vir, "VALIDITY: %x", vir);
 }
 
+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
+{
+	union {
+		struct {
+			uint64_t     : 16;
+			uint64_t ipa : 16;
+			uint64_t ipb : 32;
+		};
+		struct {
+			uint64_t          : 16;
+			uint64_t opcode   :  8;
+			uint64_t r_1      :  4;
+			uint64_t r_2      :  4;
+			uint64_t r_base   :  4;
+			uint64_t displace : 12;
+			uint64_t zero     : 16;
+		};
+	} instr = { .ipa = vm->sblk->ipa, .ipb = vm->sblk->ipb };
+	uint64_t code;
+
+	assert(diag == 0x44 || diag == 0x9c);
+
+	if (vm->sblk->icptcode != ICPT_INST)
+		return false;
+	if (instr.opcode != 0x83 || instr.zero)
+		return false;
+	code = instr.r_base ? vm->save_area.guest.grs[instr.r_base] : 0;
+	code = (code + instr.displace) & 0xffff;
+	return code == diag;
+}
+
 void sie_handle_validity(struct vm *vm)
 {
 	if (vm->sblk->icptcode != ICPT_VALIDITY)
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
index 23a86179..81e9a71e 100644
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
index 3193ad99..7fb7f091 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -8,7 +8,7 @@
  *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
-#include <snippet.h>
+#include <snippet-host.h>
 #include <pv_icptdata.h>
 #include <sie.h>
 #include <sclp.h>
diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
index d7c47d6f..9a9c7357 100644
--- a/s390x/pv-icptcode.c
+++ b/s390x/pv-icptcode.c
@@ -12,7 +12,7 @@
 #include <sie.h>
 #include <smp.h>
 #include <sclp.h>
-#include <snippet.h>
+#include <snippet-host.h>
 #include <pv_icptdata.h>
 #include <asm/facility.h>
 #include <asm/barrier.h>
diff --git a/s390x/pv-ipl.c b/s390x/pv-ipl.c
index cc46e7f7..7d654b84 100644
--- a/s390x/pv-ipl.c
+++ b/s390x/pv-ipl.c
@@ -10,7 +10,7 @@
 #include <libcflat.h>
 #include <sie.h>
 #include <sclp.h>
-#include <snippet.h>
+#include <snippet-host.h>
 #include <pv_icptdata.h>
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
2.43.0


