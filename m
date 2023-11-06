Return-Path: <kvm+bounces-797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E907E2A07
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79EF2B20F73
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C58529D01;
	Mon,  6 Nov 2023 16:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kycODnrd"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41AE29420
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:37:48 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02C9D70;
	Mon,  6 Nov 2023 08:37:44 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6GFVhA004472;
	Mon, 6 Nov 2023 16:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fBA6IRIRcIKtlNL40lS4armRg8WANRkFOv9fEqU3KqA=;
 b=kycODnrdS0HN0lJHHuxuiNA7VoMmAOQ7Zh+XNVk3WJTMsWSOrepW15/TIZq0SxcQzbXx
 f6+cBk+GQyi1TgatS+nlz97/t9qxnG4ipvTAL0W5wPtvIvtQKNZLZezj0Aul9fBGsn3o
 DNXHhk0dUHkD7KaJZFZHMB4SGvTwih0xlddbUYnb645H+tmV08F1ZkyRCRd3Aqq2SBp0
 58UKNwPw+m7zphFOQIBiw0G3mYst2US4fbLdG7xb9QL3Sr+WAoHV+KVbgmF49iEWlRcL
 ycxaF4O0PBrHKHhie7UBBrzpvAuuV50MMUrZPpkTXqAj8yad73l04jUd+SFjR7bR5V3E rw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73gn0n6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:43 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6GSBsv021544;
	Mon, 6 Nov 2023 16:37:42 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u73gn0n6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:42 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Eo2ZD028276;
	Mon, 6 Nov 2023 16:37:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u62gjt90s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:37:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6GbdfI22151568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 16:37:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CBD120040;
	Mon,  6 Nov 2023 16:37:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 224FB2004E;
	Mon,  6 Nov 2023 16:37:39 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 16:37:39 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        hca@linux.ibm.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v8 2/8] s390x: add function to set DAT mode for all interrupts
Date: Mon,  6 Nov 2023 17:37:24 +0100
Message-ID: <20231106163738.1116942-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106163738.1116942-1-nrb@linux.ibm.com>
References: <20231106163738.1116942-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oXpJyHTim2MLtAKCy1Di91-X1DiESxvU
X-Proofpoint-GUID: w9fA0-3O75pYQQriZKD5ggv7yV4cjcG9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=506 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060134

When toggling DAT or switch address space modes, it is likely that
interrupts should be handled in the same DAT or address space mode.

Add a function which toggles DAT and address space mode for all
interruptions, except restart interrupts.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h  | 10 ++++++----
 lib/s390x/asm/interrupt.h |  2 ++
 lib/s390x/interrupt.c     | 35 +++++++++++++++++++++++++++++++++++
 lib/s390x/mmu.c           |  5 +++--
 4 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index f629b6d0a17f..5beaf15b57e7 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -84,10 +84,12 @@ struct cpu {
 	bool in_interrupt_handler;
 };
 
-#define AS_PRIM				0
-#define AS_ACCR				1
-#define AS_SECN				2
-#define AS_HOME				3
+enum address_space {
+	AS_PRIM = 0,
+	AS_ACCR = 1,
+	AS_SECN = 2,
+	AS_HOME = 3
+};
 
 #define PSW_MASK_DAT			0x0400000000000000UL
 #define PSW_MASK_IO			0x0200000000000000UL
diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 35c1145f0349..d01f8a89641a 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -83,6 +83,8 @@ void expect_ext_int(void);
 uint16_t clear_pgm_int(void);
 void check_pgm_int_code(uint16_t code);
 
+void irq_set_dat_mode(bool use_dat, enum address_space as);
+
 /* Activate low-address protection */
 static inline void low_prot_enable(void)
 {
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 3f993a363ae2..e990c1863630 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -9,6 +9,7 @@
  */
 #include <libcflat.h>
 #include <asm/barrier.h>
+#include <asm/mem.h>
 #include <asm/asm-offsets.h>
 #include <sclp.h>
 #include <interrupt.h>
@@ -104,6 +105,40 @@ void register_ext_cleanup_func(void (*f)(struct stack_frame_int *))
 	THIS_CPU->ext_cleanup_func = f;
 }
 
+/**
+ * irq_set_dat_mode - Set the DAT mode of all interrupt handlers, except for
+ * restart.
+ * @use_dat: specifies whether to use DAT or not
+ * @as: specifies the address space mode to use. Not set if use_dat is false.
+ *
+ * This will update the DAT mode and address space mode of all interrupt new
+ * PSWs.
+ *
+ * Since enabling DAT needs initialized CRs and the restart new PSW is often used
+ * to initialize CRs, the restart new PSW is never touched to avoid the chicken
+ * and egg situation.
+ */
+void irq_set_dat_mode(bool use_dat, enum address_space as)
+{
+	struct psw* irq_psws[] = {
+		OPAQUE_PTR(GEN_LC_EXT_NEW_PSW),
+		OPAQUE_PTR(GEN_LC_SVC_NEW_PSW),
+		OPAQUE_PTR(GEN_LC_PGM_NEW_PSW),
+		OPAQUE_PTR(GEN_LC_MCCK_NEW_PSW),
+		OPAQUE_PTR(GEN_LC_IO_NEW_PSW),
+	};
+	struct psw *psw;
+
+	assert(as == AS_PRIM || as == AS_ACCR || as == AS_SECN || as == AS_HOME);
+
+	for (size_t i = 0; i < ARRAY_SIZE(irq_psws); i++) {
+		psw = irq_psws[i];
+		psw->dat = use_dat;
+		if (use_dat)
+			psw->as = as;
+	}
+}
+
 static void fixup_pgm_int(struct stack_frame_int *stack)
 {
 	/* If we have an error on SIE we directly move to sie_exit */
diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
index b474d7021d3f..9a179d6b8ec5 100644
--- a/lib/s390x/mmu.c
+++ b/lib/s390x/mmu.c
@@ -12,6 +12,7 @@
 #include <asm/pgtable.h>
 #include <asm/arch_def.h>
 #include <asm/barrier.h>
+#include <asm/interrupt.h>
 #include <vmalloc.h>
 #include "mmu.h"
 
@@ -41,8 +42,8 @@ static void mmu_enable(pgd_t *pgtable)
 	/* enable dat (primary == 0 set as default) */
 	enable_dat();
 
-	/* we can now also use DAT unconditionally in our PGM handler */
-	lowcore.pgm_new_psw.mask |= PSW_MASK_DAT;
+	/* we can now also use DAT in all interrupt handlers */
+	irq_set_dat_mode(true, AS_PRIM);
 }
 
 /*
-- 
2.41.0


