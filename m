Return-Path: <kvm+bounces-512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B98AC7E0764
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 18:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2618CB215D1
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 17:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FDF21342;
	Fri,  3 Nov 2023 17:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="g1C2WPVL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940DB210E2
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:30:21 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD3313E;
	Fri,  3 Nov 2023 10:30:17 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3H7GSB002202;
	Fri, 3 Nov 2023 17:30:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rW1R49MZgm4F0aHWaNHbGSUo7bf0vAKQc//SxLmUw9Y=;
 b=g1C2WPVLZcVRnijp6gRdSMaWr5FPsbti5qUV2aGF11x4NNsUQq7Ysn88Axg0rFVGH/qW
 hcUk8lW06i8a4sdq0U+KU+xzpfmcxZ+a4YyPUc2v7W0ojcvAYrSxR/ADHx0p9kJD2f1n
 1kQe0Q//o5PX3a1QaZk3WXu/IkuxTcFZGTEqGTwF4/eEIpHOegz40fIlcba0t+hmIVPR
 Q9deYgig4P7lRzOKfk9WB3NoMwx8gV45+j3R0MayL2cxROfd+JgvQcUmWN6UEreDm8IZ
 KQv1ey4Qs4VdgS/PGswz1iHTqqViIb17OqO4mXLh88BeuH1m4agDDgyaBEDsiowcr+Cv og== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u54yws4sg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 17:30:16 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3H7iok003895;
	Fri, 3 Nov 2023 17:30:16 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u54yws4s4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 17:30:16 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3GUneB000588;
	Fri, 3 Nov 2023 17:30:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1cmtqt1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 17:30:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3HUAfv18612758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 17:30:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D1BA2004E;
	Fri,  3 Nov 2023 17:30:10 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 206822004B;
	Fri,  3 Nov 2023 17:30:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 17:30:10 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-s390@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        Michael Mueller <mimu@linux.vnet.ibm.com>
Subject: [PATCH 2/4] KVM: s390: vsie: Fix length of facility list shadowed
Date: Fri,  3 Nov 2023 18:30:06 +0100
Message-Id: <20231103173008.630217-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231103173008.630217-1-nsg@linux.ibm.com>
References: <20231103173008.630217-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 48ytNKaUiGovYjAqXkgiQLFaTULcgg8q
X-Proofpoint-ORIG-GUID: -z2QJDfpKsCF1d-9C8oeRphP6EqHBFSR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_16,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2311030146

The length of the facility list accessed when interpretively executing
STFLE is the same as the hosts facility list (in case of format-0)
When shadowing, copy only those bytes.
The memory following the facility list need not be accessible, in which
case we'd wrongly inject a validity intercept.

Fixes: 66b630d5b7f2 ("KVM: s390: vsie: support STFLE interpretation")
Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 arch/s390/include/asm/facility.h |  6 ++++++
 arch/s390/kernel/Makefile        |  2 +-
 arch/s390/kernel/facility.c      | 18 ++++++++++++++++++
 arch/s390/kvm/vsie.c             | 12 +++++++++++-
 4 files changed, 36 insertions(+), 2 deletions(-)
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
index 000000000000..c33a95a562da
--- /dev/null
+++ b/arch/s390/kernel/facility.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright IBM Corp. 2023
+ */
+
+#include <asm/facility.h>
+
+unsigned int stfle_size(void)
+{
+	static unsigned int size = 0;
+	u64 dummy;
+
+	if (!size) {
+		size = __stfle_asm(&dummy, 1) + 1;
+	}
+	return size;
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


