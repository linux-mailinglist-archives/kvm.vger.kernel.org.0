Return-Path: <kvm+bounces-1229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 204527E5C22
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3810281717
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5535932C70;
	Wed,  8 Nov 2023 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U4X5zg2u"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8413035C
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 17:12:38 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8762D1FF9;
	Wed,  8 Nov 2023 09:12:37 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GjWrR000313;
	Wed, 8 Nov 2023 17:12:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cIMLIDofioo0tHlvYKDWa9BjvHXwFewVdPCLtnkS2XU=;
 b=U4X5zg2up9rTZ1Woh18kSWreX05mU+CZdxnWJgqx/22ElCPedODuftTC39650/FWArvo
 f4L1owjL8JUVxj90U6OZHj18qzfvm/ZxVKXFPBWP49cwG9dzYMuOpy139TjoChoIaGrc
 lTab4epwrqIz08Lbs/mcRV+9GnhaLQq1QiEpzhzLKRoHZAaxR4syADzXTmUpCGgrCn17
 A7u4kzuQfKiftEuRCLg1enYX4spMK/023ArTMq0o8nn+GImQVl+cs8t50OvF71F2gKKB
 lVA8T1XVarBtTB5YXWmL5ljPyu1LYz1gH6hcofR4BccOOcEd9NOQ5NP2lOtZV84nor3g ag== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8e4s99jn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:36 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8Gjwxn003814;
	Wed, 8 Nov 2023 17:12:35 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8e4s99ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:35 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GeMXX000644;
	Wed, 8 Nov 2023 17:12:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22x9su-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 17:12:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8HCVhg24511104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 17:12:31 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CAAD720043;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 996162004B;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 17:12:31 +0000 (GMT)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH v3 2/4] KVM: s390: vsie: Fix length of facility list shadowed
Date: Wed,  8 Nov 2023 18:12:27 +0100
Message-Id: <20231108171229.3404476-3-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231108171229.3404476-1-nsg@linux.ibm.com>
References: <20231108171229.3404476-1-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WRBtNgB7f-9UQvuUAa8GCm5qXBcSwoJr
X-Proofpoint-GUID: dF0mDbG4DGHD92aJew2LYFExO9ut7FTF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_05,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1015
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311080141

The length of the facility list accessed when interpretively executing
STFLE is the same as the hosts facility list (in case of format-0)
When shadowing, copy only those bytes.
The memory following the facility list need not be accessible, in which
case we'd wrongly inject a validity intercept.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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


