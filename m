Return-Path: <kvm+bounces-475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B72D7E0005
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 10:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A54681C20FEB
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 09:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E752C15EBA;
	Fri,  3 Nov 2023 09:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jdAV6ajq"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8474125CC
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 09:30:02 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC15DD47;
	Fri,  3 Nov 2023 02:30:00 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A38nVos008485;
	Fri, 3 Nov 2023 09:30:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lr1aJMwtYhv0OXZc066uW45PypTmq3DPT04Ccw5LmZc=;
 b=jdAV6ajqujF9WYOl66hkYNo8h/qO7aDxvKWjqB+vrtrYpQgobzsBvG4UFQAJrFaePXs0
 WeJ5iqkO5yCOiTOjjD9m2qKnu88ziglvn1wDcDTgzwctwMLY2hnitzX1BjFaH9rzivmK
 HK7vJF2E8NtALm8/cp3vugz9vF+mFJz1JjxaQLIJepVONclbo/TXhkma7tTVNzaoBV7T
 QxfGybejrYW/F8O+uMC9XwT+zsoC/1rrz53i0As/jQOAeggzR1eNV8YfdALGVOW5D4vd
 ZYMjZ/E6SjOC43oNuHbDpi6Lxfw9mq8J8VFKfg0eCQEXxeYw4pWag75N4hKXb2ZaCpLH 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4wpf92wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:59 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A39D7IH014588;
	Fri, 3 Nov 2023 09:29:59 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4wpf92wg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:59 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A36hVdc011389;
	Fri, 3 Nov 2023 09:29:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1eukmjgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 09:29:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A39Ttmp42271374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 09:29:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83D0220040;
	Fri,  3 Nov 2023 09:29:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6200C2004F;
	Fri,  3 Nov 2023 09:29:55 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 09:29:55 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 5/8] s390x: lib: sie: don't reenter SIE on pgm int
Date: Fri,  3 Nov 2023 10:29:34 +0100
Message-ID: <20231103092954.238491-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231103092954.238491-1-nrb@linux.ibm.com>
References: <20231103092954.238491-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: w5ZXLS_BGxHRK--0z_fBHbDe3lvsXo9e
X-Proofpoint-ORIG-GUID: z3xLj_Awr-9dY6vmLDkDpa0Lk2xSx784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_09,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=67 phishscore=0 bulkscore=0
 spamscore=67 suspectscore=0 adultscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=-30 mlxscore=67 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030078

At the moment, when a PGM int occurs while in SIE, we will just reenter
SIE after the interrupt handler was called.

This is because sie() has a loop which checks icptcode and re-enters SIE
if it is zero.

However, this behaviour is quite undesirable for SIE tests, since it
doesn't give the host the chance to assert on the PGM int. Instead, we
will just re-enter SIE, on nullifing conditions even causing the
exception again.

In sie(), check whether a pgm int code is set in lowcore. If it has,
exit the loop so the test can react to the interrupt. Add a new function
read_pgm_int_code() to obtain the interrupt code.

Note that this introduces a slight oddity with sie and pgm int in
certain cases: If a PGM int occurs between a expect_pgm_int() and sie(),
we will now never enter SIE until the pgm_int_code is cleared by e.g.
clear_pgm_int().

Also add missing include of facility.h to mem.h.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/interrupt.h | 14 ++++++++++++++
 lib/s390x/asm/mem.h       |  1 +
 lib/s390x/sie.c           |  4 +++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index d01f8a89641a..7f73d473b346 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -97,4 +97,18 @@ static inline void low_prot_disable(void)
 	ctl_clear_bit(0, CTL0_LOW_ADDR_PROT);
 }
 
+/**
+ * read_pgm_int_code - Get the program interruption code of the last pgm int
+ * on the current CPU.
+ *
+ * This is similar to clear_pgm_int(), except that it doesn't clear the
+ * interruption information from lowcore.
+ *
+ * Returns 0 when none occurred.
+ */
+static inline uint16_t read_pgm_int_code(void)
+{
+	return lowcore.pgm_int_code;
+}
+
 #endif
diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 64ef59b546a4..94d58c34f53f 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -8,6 +8,7 @@
 #ifndef _ASMS390X_MEM_H_
 #define _ASMS390X_MEM_H_
 #include <asm/arch_def.h>
+#include <asm/facility.h>
 
 /* create pointer while avoiding compiler warnings */
 #define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 7f4474555ff7..a97096948460 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -13,6 +13,7 @@
 #include <libcflat.h>
 #include <sie.h>
 #include <asm/page.h>
+#include <asm/interrupt.h>
 #include <libcflat.h>
 #include <alloc_page.h>
 
@@ -79,7 +80,8 @@ void sie(struct vm *vm)
 	/* also handle all interruptions in home space while in SIE */
 	irq_set_dat_mode(true, AS_HOME);
 
-	while (vm->sblk->icptcode == 0) {
+	/* leave SIE when we have an intercept or an interrupt so the test can react to it */
+	while (vm->sblk->icptcode == 0 && !read_pgm_int_code()) {
 		sie64a(vm->sblk, &vm->save_area);
 		sie_handle_validity(vm);
 	}
-- 
2.41.0


