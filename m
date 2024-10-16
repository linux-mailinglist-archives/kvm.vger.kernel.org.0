Return-Path: <kvm+bounces-29019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F0B9A1122
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:04:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26AECB24161
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B412141A8;
	Wed, 16 Oct 2024 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mjIEdmka"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C1C18870B;
	Wed, 16 Oct 2024 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729101812; cv=none; b=u3PrbxHOkYpcZwzFECquWy+MaZ4Ym1zD2kq+2pXtWiqvisKLKlrpGCtv4n+uEl77N4WfkEMsbTBkaXdCYwVsbs4Ty27HfmClOOwNByWLY4UtSotvGLy9KO1xuIl941jJa+RRqZfPqt5D5N16lX9h/NHBG43KEtd8MOWMy4Om2jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729101812; c=relaxed/simple;
	bh=QrTlFzgozfsgTmrFzczRVMFDynUAMYB+AawyLT7G68A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSbMsx5OXbobDdZ+lGerZ77d3ahQp20JSNgjIbsgnHZej5Fux3Fiq/rPv3HGfL2O3HkVIR8hgaj+ln02cPerKthtSAx54m29pN1Oi+xdSMzepGXDUOyKCWHIz2n6Sb1jWHXWrVLS4UdPikodcPi4MmLzXeQkO9XFyQ+tC4BK0l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mjIEdmka; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GGo32W027863;
	Wed, 16 Oct 2024 18:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=EUQUMhLFX9HYieRQc
	YxSI8JubAyu5h8khfCWnf/s7T8=; b=mjIEdmkajxTLreF3x1G8avFV4FzvFPJvb
	hmZ0NiGZMs1+P48r5G7v1RO2VP4idwiRjvVw171HGosBAOygS9ucXshBfJ7sFo6A
	0Mjw/jJgKT9kqbTyn5A6GA2QUWemwhky+qIwswtMK+Tec8F6FhJJjIB5snV0m/a7
	OIHhjJXssLSFc7OR2h5/4uBNCbh+1cpFaOynrrvFrRqnVElWWfCKAbPrhhA/nVuq
	UVGPHhk31o2zXt/xyq26iiFRoHU+Ua3DMP4jcKLq+ZmvGZSuthkE1GjjqcdYKDwt
	1K+GPd4fGD3turRc4jcYgMJck8ARFxtdIwsIM/c0RGjdiiDNGXUyw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ahbr09sm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:29 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49GI3Tp5020956;
	Wed, 16 Oct 2024 18:03:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42ahbr09sk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GH9QM6005218;
	Wed, 16 Oct 2024 18:03:28 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4285njagrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 18:03:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GI3P9H20513028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 18:03:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24C8D2004D;
	Wed, 16 Oct 2024 18:03:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B736E2004B;
	Wed, 16 Oct 2024 18:03:24 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 18:03:24 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 4/6] s390x: Add library functions for exiting from snippet
Date: Wed, 16 Oct 2024 20:03:15 +0200
Message-ID: <20241016180320.686132-5-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241016180320.686132-1-nsg@linux.ibm.com>
References: <20241016180320.686132-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Vjrq2Y_4bxoV2u-SkNceSbQdW_88hvpb
X-Proofpoint-ORIG-GUID: QtYUlh6MSGLex1j6nuvXAPtTtG1ljJPB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=782
 clxscore=1015 adultscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410160115

It is useful to be able to force an exit to the host from the snippet,
as well as do so while returning a value.
Add this functionality, also add helper functions for the host to check
for an exit and get or check the value.
Use diag 0x44 and 0x9c for this.
Add a guest specific snippet header file and rename snippet.h to reflect
that it is host specific.

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/Makefile                    |  4 ++-
 lib/s390x/asm/arch_def.h          | 13 +++++++++
 lib/s390x/snippet-exit.h          | 47 +++++++++++++++++++++++++++++++
 s390x/snippets/lib/snippet-exit.h | 28 ++++++++++++++++++
 4 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100644 lib/s390x/snippet-exit.h
 create mode 100644 s390x/snippets/lib/snippet-exit.h

diff --git a/s390x/Makefile b/s390x/Makefile
index 0ad8d021..1caf221d 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -70,7 +70,8 @@ test_cases: $(tests)
 test_cases_binary: $(tests_binary)
 test_cases_pv: $(tests_pv_binary)
 
-INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
+SNIPPET_INCLUDE :=
+INCLUDE_PATHS = $(SNIPPET_INCLUDE) $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
 # Include generated header files (e.g. in case of out-of-source builds)
 INCLUDE_PATHS += lib
 CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
@@ -151,6 +152,7 @@ endif
 $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
+$(SNIPPET_DIR)/c/%.o: SNIPPET_INCLUDE := $(SNIPPET_DIR)/lib
 $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
 	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
 
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
diff --git a/lib/s390x/snippet-exit.h b/lib/s390x/snippet-exit.h
new file mode 100644
index 00000000..f62f0068
--- /dev/null
+++ b/lib/s390x/snippet-exit.h
@@ -0,0 +1,47 @@
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
+	return sie_is_diag_icpt(vm, 0x9c);
+}
+
+static inline uint64_t snippet_get_force_exit_value(struct vm *vm)
+{
+	struct kvm_s390_sie_block *sblk = vm->sblk;
+
+	assert(snippet_is_force_exit_value(vm));
+
+	return vm->save_area.guest.grs[sblk_ip_as_diag(sblk).r_1];
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
index 00000000..0b483366
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
+	diag9c(val);
+	mb(); /* allow host to modify guest memory */
+}
+
+#endif /* _S390X_SNIPPET_LIB_EXIT_H_ */
-- 
2.44.0


