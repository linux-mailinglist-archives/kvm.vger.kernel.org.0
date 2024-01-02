Return-Path: <kvm+bounces-5419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BD5821CE9
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 14:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3E8B1C22167
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 13:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BB9156C9;
	Tue,  2 Jan 2024 13:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c8DvgKYh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D341212E70;
	Tue,  2 Jan 2024 13:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 402DHkpa010600;
	Tue, 2 Jan 2024 13:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=+MJnBFI4o1XUN1TyxUVagcosvNNkHMBHiL6S2yBwCKU=;
 b=c8DvgKYhcUtYtZ2/iLmT7N/q8rwswtaTx51syanMQMA9OG59gPKvmzjWYXSNzYiyHAOS
 q7ImLF1IrkCo0mr2ngb/MiwRjUXdTleJGy4R+dqYD5scZ3Ns9pHpnC9tDhaitQlXjpMc
 kCvw3JRZS4sOqtQgcUB8LQxSHvWBJaKQB8sbqF+RRTRdJSDRQZ2rtZ84ef75UG6RjBVy
 VRjP97XLZea6DPEWIXoX7vpIYTu5KNXHX1nN1UYlGnhuBLM4emujY/ViC9HHNSfYyUHt
 8bmZll37DBqSv2CQiEULRAfK05e32i9VL+OamQu87OL9NuMuPHxCJuGwcjt22jv/OIya 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vck830csh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 13:37:41 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 402DKRWE018475;
	Tue, 2 Jan 2024 13:37:41 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vck830cs8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 13:37:41 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 402AYEaf007298;
	Tue, 2 Jan 2024 13:37:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vaxhnw0k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 13:37:39 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 402Dba3r10814188
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jan 2024 13:37:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8820D20040;
	Tue,  2 Jan 2024 13:37:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2E642004D;
	Tue,  2 Jan 2024 13:37:35 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.18.26])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Jan 2024 13:37:35 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com
Subject: [GIT PULL 3/4] KVM: s390: vsie: Fix length of facility list shadowed
Date: Tue,  2 Jan 2024 14:34:54 +0100
Message-ID: <20240102133629.108405-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240102133629.108405-1-frankja@linux.ibm.com>
References: <20240102133629.108405-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zKz7i36FcFTdflXpZq2RFu38VbbpZcDT
X-Proofpoint-ORIG-GUID: 2eLvgo7GtsoMRM8ve6LI5gEaP0T5Pu0d
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-02_04,2024-01-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 phishscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401020104

From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

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
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20231219140854.1042599-3-nsg@linux.ibm.com
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20231219140854.1042599-3-nsg@linux.ibm.com>
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
index 3cf95bc0401d..aa8f4ab11e33 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -19,6 +19,7 @@
 #include <asm/nmi.h>
 #include <asm/dis.h>
 #include <asm/fpu/api.h>
+#include <asm/facility.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 
@@ -990,6 +991,10 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
 	__u32 fac = READ_ONCE(vsie_page->scb_o->fac);
 
+	/*
+	 * Alternate-STFLE-Interpretive-Execution facilities are not supported
+	 * -> format-0 flcb
+	 */
 	if (fac && test_kvm_facility(vcpu->kvm, 7)) {
 		retry_vsie_icpt(vsie_page);
 		/*
@@ -997,8 +1002,13 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
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
2.43.0


