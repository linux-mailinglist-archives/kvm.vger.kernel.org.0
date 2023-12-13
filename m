Return-Path: <kvm+bounces-4327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B958111B2
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:50:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45B2F281E47
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 12:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2A22C872;
	Wed, 13 Dec 2023 12:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bbQKhCdS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C10114;
	Wed, 13 Dec 2023 04:49:55 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDARbdn008379;
	Wed, 13 Dec 2023 12:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KPLxJ9ucc1tIvxepfZTG5Oz8YahSf1qKHc1DzFFo+fk=;
 b=bbQKhCdSqLIKfrqCU3m86a8fTs4/NADijXW2jgXUgNmxOVCcrh3auRCLnekGDg+V0fGY
 5QUuCyA5z4EEg87DRqDMqHfADfW+29gijL6eCf7Bd4hQKxa5NsRYfP1JEsrZq7zoo+ph
 DH4+jU6MwaUk7hE0Tsq+BycsKPRK1DmP2Wdqq2GZeN0VSuaYy5UUVZJ8DG23yfWRB64X
 bvu4EXbNfUS+nr9DG6mFDq04G/2nLwCimEMQrSs7o7p4qNRUtGf0c+ag+M9x78y/YU4b
 4G57KUyWQ9eM3ZZPMP9MuWmMMJ0keFMhHmUJdyVnUB3764kghov+NcvDXi/j+Yt1xTTG CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyavkv70u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:49 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDCUgN5002825;
	Wed, 13 Dec 2023 12:49:48 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyavkv70m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:48 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDBBeGN008455;
	Wed, 13 Dec 2023 12:49:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw2jth14q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 12:49:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDCnjE117302214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 12:49:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 044B820040;
	Wed, 13 Dec 2023 12:49:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF94520043;
	Wed, 13 Dec 2023 12:49:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 12:49:44 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH 3/5] s390x: Add library functions for exiting from snippet
Date: Wed, 13 Dec 2023 13:49:40 +0100
Message-Id: <20231213124942.604109-4-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231213124942.604109-1-nsg@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: T2qwzIsKkQTS6kId-hHHHWyMojZi0egF
X-Proofpoint-GUID: 2PSrxpteVeNECsHrn7DYgTC8olEfQSic
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_05,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=898 spamscore=0
 bulkscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130093

It is useful to be able to force an exit to the host from the snippet,
as well as do so while returning a value.
Add this functionality, also add helper functions for the host to check
for an exit and get or check the value.
Use diag 0x44 and 0x9c for this.
Add a guest specific snippet header file and rename the host's.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/Makefile                          |  1 +
 lib/s390x/asm/arch_def.h                | 13 ++++++++
 lib/s390x/sie.h                         |  1 +
 lib/s390x/snippet-guest.h               | 26 ++++++++++++++++
 lib/s390x/{snippet.h => snippet-host.h} |  9 ++++--
 lib/s390x/sie.c                         | 28 +++++++++++++++++
 lib/s390x/snippet-host.c                | 40 +++++++++++++++++++++++++
 lib/s390x/uv.c                          |  2 +-
 s390x/mvpg-sie.c                        |  2 +-
 s390x/pv-diags.c                        |  2 +-
 s390x/pv-icptcode.c                     |  2 +-
 s390x/pv-ipl.c                          |  2 +-
 s390x/sie-dat.c                         |  2 +-
 s390x/spec_ex-sie.c                     |  2 +-
 s390x/uv-host.c                         |  2 +-
 15 files changed, 123 insertions(+), 11 deletions(-)
 create mode 100644 lib/s390x/snippet-guest.h
 rename lib/s390x/{snippet.h => snippet-host.h} (93%)
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
similarity index 93%
rename from lib/s390x/snippet.h
rename to lib/s390x/snippet-host.h
index 910849aa..d21dd958 100644
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
@@ -144,4 +144,7 @@ static inline void snippet_setup_guest(struct vm *vm, bool is_pv)
 	}
 }
 
+bool snippet_check_force_exit(struct vm *vm);
+bool snippet_get_force_exit_value(struct vm *vm, uint64_t *value);
+void snippet_check_force_exit_value(struct vm *vm, uint64_t exit_exp);
 #endif
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 40936bd2..908b0130 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -42,6 +42,34 @@ void sie_check_validity(struct vm *vm, uint16_t vir_exp)
 	report(vir_exp == vir, "VALIDITY: %x", vir);
 }
 
+bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
+{
+	uint32_t ipb = vm->sblk->ipb;
+	uint64_t code;
+	uint16_t displace;
+	uint8_t base;
+	bool ret = true;
+
+	ret = ret && vm->sblk->icptcode == ICPT_INST;
+	ret = ret && (vm->sblk->ipa & 0xff00) == 0x8300;
+	switch (diag) {
+	case 0x44:
+	case 0x9c:
+		ret = ret && !(ipb & 0xffff);
+		ipb >>= 16;
+		displace = ipb & 0xfff;
+		ipb >>= 12;
+		base = ipb & 0xf;
+		code = base ? vm->save_area.guest.grs[base] + displace : displace;
+		code &= 0xffff;
+		ret = ret && (code == diag);
+		break;
+	default:
+		abort(); /* not implemented */
+	}
+	return ret;
+}
+
 void sie_handle_validity(struct vm *vm)
 {
 	if (vm->sblk->icptcode != ICPT_VALIDITY)
diff --git a/lib/s390x/snippet-host.c b/lib/s390x/snippet-host.c
new file mode 100644
index 00000000..a829c1d5
--- /dev/null
+++ b/lib/s390x/snippet-host.c
@@ -0,0 +1,40 @@
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
+bool snippet_check_force_exit(struct vm *vm)
+{
+	bool r;
+
+	r = sie_is_diag_icpt(vm, 0x44);
+	report(r, "guest forced exit");
+	return r;
+}
+
+bool snippet_get_force_exit_value(struct vm *vm, uint64_t *value)
+{
+	struct kvm_s390_sie_block *sblk = vm->sblk;
+
+	if (sie_is_diag_icpt(vm, 0x9c)) {
+		*value = vm->save_area.guest.grs[(sblk->ipa & 0xf0) >> 4];
+		report_pass("guest forced exit with value: 0x%lx", *value);
+		return true;
+	}
+	report_fail("guest forced exit with value");
+	return false;
+}
+
+void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
+{
+	uint64_t value;
+
+	if (snippet_get_force_exit_value(vm, &value))
+		report(value == value_exp, "guest exit value matches 0x%lx", value_exp);
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
2.41.0


