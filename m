Return-Path: <kvm+bounces-1483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7327E7CC2
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 14:56:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A712B21C69
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 13:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636FC39877;
	Fri, 10 Nov 2023 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LsmibvDY"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5DB38DD4
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 13:54:48 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C0438227
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 05:54:45 -0800 (PST)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADkVe0032073;
	Fri, 10 Nov 2023 13:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Mf31TBn2V32VsY0kO2HWr2kDiq809fa6aFCz2iP/rmY=;
 b=LsmibvDYPF6iYRZ6r8iw91Oi6m7v2ci6xWMfjZR2UrgI8HO3qgn4LMIGnsYW55C8xULU
 IxU+531T5ZSEhtJ33VveQ6a6gLAQYxPAk4a7v51Mh0bvkgXuYt1fYnpbri8tzRTRQng/
 k7rovzb7v7My+XX6kffeS95GSPQ4ORyJ0ouyFqq2mrllud5iqnSe8s8qd/Ma/9Whq1HV
 7/aESVMwwM/18qysc/N7X5z7NBzWCcOYyo/fzg0ItyHA0uHSjPWNS7J8bwBvyu/foF70
 W4NFftZWfJ3muxMKNnlJm4qnsZCFlTpGiwHeXkMUU7uiPcx3IpDuVtR3I5H6ZJ1MZhwb /A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mpbaetc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:42 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AADlsRv005652;
	Fri, 10 Nov 2023 13:54:42 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u9mpbaesn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:42 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AADlK65003529;
	Fri, 10 Nov 2023 13:54:41 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w22b6ra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Nov 2023 13:54:41 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AADscGv18875130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 13:54:38 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E4ED02004B;
	Fri, 10 Nov 2023 13:54:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CA0320043;
	Fri, 10 Nov 2023 13:54:37 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.179.18.113])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Nov 2023 13:54:37 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 23/26] s390x: lib: sie: don't reenter SIE on pgm int
Date: Fri, 10 Nov 2023 14:52:32 +0100
Message-ID: <20231110135348.245156-24-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231110135348.245156-1-nrb@linux.ibm.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: egr29FAoK6H7A4XLrNC4FQ9Zg09tVxb5
X-Proofpoint-ORIG-GUID: 6yga1e5uvDClt9VbKvoUDMbeMHfZE3MJ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=36 mlxscore=36 adultscore=0
 mlxlogscore=25 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 spamscore=36 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100114

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

Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20231106163738.1116942-6-nrb@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 14 ++++++++++++++
 lib/s390x/asm/mem.h       |  1 +
 lib/s390x/sie.c           |  7 ++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index d01f8a8..39b43b6 100644
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
+ * Return: 0 when none occurred.
+ */
+static inline uint16_t read_pgm_int_code(void)
+{
+	return lowcore.pgm_int_code;
+}
+
 #endif
diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 64ef59b..94d58c3 100644
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
index b8ee43e..28fbf14 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -13,6 +13,7 @@
 #include <libcflat.h>
 #include <sie.h>
 #include <asm/page.h>
+#include <asm/interrupt.h>
 #include <libcflat.h>
 #include <alloc_page.h>
 #include <vmalloc.h>
@@ -56,6 +57,9 @@ void sie(struct vm *vm)
 {
 	uint64_t old_cr13;
 
+	/* When a pgm int code is set, we'll never enter SIE below. */
+	assert(!read_pgm_int_code());
+
 	if (vm->sblk->sdf == 2)
 		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
 		       sizeof(vm->save_area.guest.grs));
@@ -81,7 +85,8 @@ void sie(struct vm *vm)
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


