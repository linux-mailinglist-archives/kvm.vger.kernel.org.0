Return-Path: <kvm+bounces-4815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ED8681896A
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE734287E07
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 14:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 820FF1D130;
	Tue, 19 Dec 2023 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V+PJZxFB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C731CA8E;
	Tue, 19 Dec 2023 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJDhXx2025287;
	Tue, 19 Dec 2023 14:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pJmENGeUiyvalQ6V1XUfovjGn96yhwRUFO3LLN+THKY=;
 b=V+PJZxFB2gyaTkLGIyu/a3waW+0Rd5Z93I/4HmL0JlpFvWgq6iS1c1OW6BbJqDYGYfyS
 w/dTLKFpr0D8qef36SRgOiA6Yb8ftz03pXA7PDVradLEVT32gDJhY+mEP1tkloemkcnK
 3wkDhXlKwkf1a665x+LhCu+JL9FESF7TKKqGvdmVUu4BqVlelnIGlYAYUb1quTeMTThA
 CxdORFhkc0hk7DadxEgkIFoRh7HBCd8h2vTtCMaNlIMWZF6GTmbKvv6KoCtCWAx0UAYK
 /lzmoYIfF+tXtsPap9uNJVi4bsF4hXtVOtGa7ef1jDO6FZ/2Zl73M76yS+WuN8YfSXtC 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v39nedfpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:09:00 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BJDheiV026103;
	Tue, 19 Dec 2023 14:08:59 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v39nedfp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:08:59 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJCZ4uK029801;
	Tue, 19 Dec 2023 14:08:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3v1p7sgbm4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:08:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BJE8u6N59113964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 14:08:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A30B2004B;
	Tue, 19 Dec 2023 14:08:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D234A20040;
	Tue, 19 Dec 2023 14:08:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Dec 2023 14:08:55 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH v4 2/4] KVM: s390: vsie: Fix length of facility list shadowed
Date: Tue, 19 Dec 2023 15:08:51 +0100
Message-Id: <20231219140854.1042599-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231219140854.1042599-1-nsg@linux.ibm.com>
References: <20231219140854.1042599-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: k3NxG5exGY-QHJBmmsaBFMMUyRLvoGI0
X-Proofpoint-ORIG-GUID: PXF319mIOfLVzeQpQDNIWMejMcj9jRC5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-19_08,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2312190105

The length of the facility list accessed when interpretively executing
STFLE is the same as the hosts facility list (in case of format-0)
The memory following the facility list doesn't need to be accessible.
The current VSIE implementation accesses a fixed length that exceeds the
guest/host facility list length and can therefore wrongly inject a
validity intercept.
Instead, find out the host facility list length by running STFLE and
copy only as much as necessary when shadowing.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/include/asm/facility.h |  6 ++++++
 arch/s390/kernel/Makefile        |  2 +-
 arch/s390/kernel/facility.c      | 21 +++++++++++++++++++++
 arch/s390/kvm/vsie.c             | 12 +++++++++++-
 4 files changed, 39 insertions(+), 2 deletions(-)
 create mode 100644 arch/s390/kernel/facility.c

diff --git a/arch/s390/include/asm/facility.h b/arch/s390/include/asm/facility.h
index 94b6919026df..796007125dff 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -111,4 +111,10 @@ static inline void stfle(u64 *stfle_fac_list, int size)
 	preempt_enable();
 }
 
+/**
+ * stfle_size - Actual size of the facility list as specified by stfle
+ * (number of double words)
+ */
+unsigned int stfle_size(void);
+
 #endif /* __ASM_FACILITY_H */
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 353def93973b..7a562b4199c8 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -41,7 +41,7 @@ obj-y	+= sysinfo.o lgr.o os_info.o ctlreg.o
 obj-y	+= runtime_instr.o cache.o fpu.o dumpstack.o guarded_storage.o sthyi.o
 obj-y	+= entry.o reipl.o kdebugfs.o alternative.o
 obj-y	+= nospec-branch.o ipl_vmparm.o machine_kexec_reloc.o unwind_bc.o
-obj-y	+= smp.o text_amode31.o stacktrace.o abs_lowcore.o
+obj-y	+= smp.o text_amode31.o stacktrace.o abs_lowcore.o facility.o
 
 extra-y				+= vmlinux.lds
 
diff --git a/arch/s390/kernel/facility.c b/arch/s390/kernel/facility.c
new file mode 100644
index 000000000000..f02127219a27
--- /dev/null
+++ b/arch/s390/kernel/facility.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright IBM Corp. 2023
+ */
+
+#include <asm/facility.h>
+
+unsigned int stfle_size(void)
+{
+	static unsigned int size;
+	unsigned int r;
+	u64 dummy;
+
+	r = READ_ONCE(size);
+	if (!r) {
+		r = __stfle_asm(&dummy, 1) + 1;
+		WRITE_ONCE(size, r);
+	}
+	return r;
+}
+EXPORT_SYMBOL(stfle_size);
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 35937911724e..fef42e2a80a2 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -19,6 +19,7 @@
 #include <asm/nmi.h>
 #include <asm/dis.h>
 #include <asm/fpu/api.h>
+#include <asm/facility.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 
@@ -986,6 +987,10 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
 	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
 
+	/*
+	 * Alternate-STFLE-Interpretive-Execution facilities are not supported
+	 * -> format-0 flcb
+	 */
 	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
 		retry_vsie_icpt(vsie_page);
 		/*
@@ -993,8 +998,13 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		 * so we need to mask here before reading.
 		 */
 		fac = fac & 0x7ffffff8U;
+		/*
+		 * format-0 -> size of nested guest's facility list == guest's size
+		 * guest's size == host's size, since STFLE is interpretatively executed
+		 * using a format-0 for the guest, too.
+		 */
 		if (read_guest_real(vcpu, fac, &vsie_page->fac,
-				    sizeof(vsie_page->fac)))
+				    stfle_size() * sizeof(u64)))
 			return set_validity_icpt(scb_s, 0x1090U);
 		scb_s->fac = (__u32)(__u64) &vsie_page->fac;
 	}
-- 
2.40.1


