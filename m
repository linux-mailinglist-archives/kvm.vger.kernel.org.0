Return-Path: <kvm+bounces-1482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFCFF7E7CC1
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CECA280A80
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183BA3986C;
	Fri, 10 Nov 2023 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ls3dTuyV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE5B38DCD
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:46 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2780038225
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:44 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADeHnp027718;
	Fri, 10 Nov 2023 13:54:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=MQnjJ5a2gSsPI1cj+gv88R7ha4Ia2YBmoZqstaxV/nc=;
 b=Ls3dTuyVkeWld5GAK//JnyIhcRA3S3yxfHM5vdblwSjge6M9UczOWAs4NKx+Wli7pr8k
 15s6SNgDjR9jsERAiIBd+9NPlouenSQ5+6r1mbAhhyu+c1Wj/QziWqdCFcLss0P3Bga2
 XcEfrRg/R87fEzrncb6OrERYQHplTl85jjkRekZC5lBU+QGEAeRrW0clq6IMZGSNwVyE
 l5Cxi2lq9t9m5P6KuBWIawE7zEUliUpGlVBysS9QNMGGZ9HIXFC9bYSuEu+eiO/QiAgu
 F7A6hap9t1vhw4Lb0Kh976Xde49zNxKOi6PEz/9dsuXGX1FwECRS7fHuxjHIyz8ejNzW UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nkq0gtw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:41 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADf4nE029454;
	Fri, 10 Nov 2023 13:54:41 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9nkq0gtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:41 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AAAueFi014332;
	Fri, 10 Nov 2023 13:54:40 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b7xm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:40 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADsat764618926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A75720040;
	Fri, 10 Nov 2023 13:54:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4221820043;
	Fri, 10 Nov 2023 13:54:36 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:36 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 20/26] s390x: add function to set DAT mode for all interrupts
Date: Fri, 10 Nov 2023 14:52:29 +0100
Message-ID: <20231110135348.245156-21-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -YI-d04WPbF7FK4sWGZjLBxzPrcWHJUu
X-Proofpoint-ORIG-GUID: EDCM03pG2EVaIDbmw1rh5HqyluMszq7o
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 8 URL's were un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=456 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

When toggling DAT or switch address space modes, it is likely that
interrupts should be handled in the same DAT or address space mode.

Add a function which toggles DAT and address space mode for all
interruptions, except restart interrupts.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20231106163738.1116942-3-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h  | 10 ++++++----
 lib/s390x/asm/interrupt.h |  2 ++
 lib/s390x/interrupt.c     | 35 +++++++++++++++++++++++++++++++++++
 lib/s390x/mmu.c           |  5 +++--
 4 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index f629b6d..5beaf15 100644
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
index 35c1145..d01f8a8 100644
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
index 3f993a3..e990c18 100644
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
index b474d70..9a179d6 100644
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


