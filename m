Return-Path: <kvm+bounces-876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89F537E3DEB
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 13:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 431BA281183
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 12:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B379D30D19;
	Tue,  7 Nov 2023 12:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y2ZHyCF6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E2E2FE2F
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:31:30 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4DF30155;
	Tue,  7 Nov 2023 04:31:28 -0800 (PST)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7CBWVx030399;
	Tue, 7 Nov 2023 12:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kgFhMN2vIjTVgixpluyiT0dz+jiE9LlFmU1r01/T0Js=;
 b=Y2ZHyCF6UhxWAHYfyHlFSBa8wQTn/FtEFh15YtbFJI/uGqn+94zMHF4ke9O4oi3SEZ2o
 p7E1B1W07z22LGsSN8T3Sq1208bEiOkjuhiDhRjd/TWziL2cMnifFHctFJQ0XMquUAhE
 gUltvcRmHQnxiTlZJFG6B+CcvG7cjFvfG4ZjAhteBfSeK+5XJ5KH8Ux63jyXxk1q65xS
 gCBZoZxwnBYpfKV9DCOfqExox+Q6OxoyoHzOr1c6+UNKSHIGEywGEiQDOvJJ39VFDZbz
 RVsmj7xpH51CeWRF3FSKAefNDP4haG/fLaM8MSE7E0Y3Rj180/5DNle5T2JP3nozJt/k Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7mknsctn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 12:31:27 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A7CC07L001582;
	Tue, 7 Nov 2023 12:31:27 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7mknscsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 12:31:27 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7AqTdq007971;
	Tue, 7 Nov 2023 12:31:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u61skgc3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 12:31:25 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A7CVMN413107776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Nov 2023 12:31:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C83DA2004B;
	Tue,  7 Nov 2023 12:31:22 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6AC7220040;
	Tue,  7 Nov 2023 12:31:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Nov 2023 12:31:22 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>
Subject: [PATCH v2 2/4] KVM: s390: vsie: Fix length of facility list shadowed
Date: Tue,  7 Nov 2023 13:31:16 +0100
Message-Id: <20231107123118.778364-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231107123118.778364-1-nsg@linux.ibm.com>
References: <20231107123118.778364-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JW9RN5y2pI6JaT4SK_Ze2U-F7XhHLdJu
X-Proofpoint-GUID: gGB1Qc7_0xyVtD14VF0gIlH_idEXQ1eA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_02,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070103

The length of the facility list accessed when interpretively executing
STFLE is the same as the hosts facility list (in case of format-0)
When shadowing, copy only those bytes.
The memory following the facility list need not be accessible, in which
case we'd wrongly inject a validity intercept.

Acked-by: David Hildenbrand <david@redhat.com>
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
index 0df2b88cc0da..0daa81439478 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -41,7 +41,7 @@ obj-y	+= sysinfo.o lgr.o os_info.o
 obj-y	+= runtime_instr.o cache.o fpu.o dumpstack.o guarded_storage.o sthyi.o
 obj-y	+= entry.o reipl.o kdebugfs.o alternative.o
 obj-y	+= nospec-branch.o ipl_vmparm.o machine_kexec_reloc.o unwind_bc.o
-obj-y	+= smp.o text_amode31.o stacktrace.o abs_lowcore.o
+obj-y	+= smp.o text_amode31.o stacktrace.o abs_lowcore.o facility.o
 
 extra-y				+= vmlinux.lds
 
diff --git a/arch/s390/kernel/facility.c b/arch/s390/kernel/facility.c
new file mode 100644
index 000000000000..5e80a4f65363
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
+	u64 dummy;
+	unsigned int r;
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
index d989772fe211..c168e88c64da 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -19,6 +19,7 @@
 #include <asm/nmi.h>
 #include <asm/dis.h>
 #include <asm/fpu/api.h>
+#include <asm/facility.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 
@@ -990,11 +991,20 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
 	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
 
+	/*
+	 * Alternate-STFLE-Interpretive-Execution facilities are not supported
+	 * -> format-0 flcb
+	 */
 	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
 		fac = fac & 0x7ffffff8U;
 		retry_vsie_icpt(vsie_page);
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
2.39.2


