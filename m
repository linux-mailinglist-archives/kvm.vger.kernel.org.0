Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0501DED3
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfD2JLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:11:09 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727454AbfD2JLI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Apr 2019 05:11:08 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3T9Awtg031397
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:11:07 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s5w2bk68x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:11:01 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 29 Apr 2019 10:10:10 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 29 Apr 2019 10:10:06 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3T9A5q060227810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 09:10:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C32652073;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 4B5365206D;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 0CFCB20F606; Mon, 29 Apr 2019 11:10:05 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 07/12] KVM: s390: add deflate conversion facilty to cpu model
Date:   Mon, 29 Apr 2019 11:09:57 +0200
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190429091002.71164-1-borntraeger@de.ibm.com>
References: <20190429091002.71164-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042909-0020-0000-0000-000003376725
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042909-0021-0000-0000-00002189DF16
Message-Id: <20190429091002.71164-8-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This enables stfle.151 and adds the subfunctions for DFLTCC. Bit 151 is
added to the list of facilities that will be enabled when there is no
cpu model involved as DFLTCC requires no additional handling from
userspace, e.g. for migration.

Please note that a cpu model enabled user space can and will have the
final decision on the facility bits for a guests.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Collin Walling <walling@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/uapi/asm/kvm.h |  3 ++-
 arch/s390/kvm/kvm-s390.c         | 19 +++++++++++++++++++
 arch/s390/tools/gen_facilities.c |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index eba5bac08348..47104e5b47fd 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -154,7 +154,8 @@ struct kvm_s390_vm_cpu_subfunc {
 	__u8 kma[16];		/* with MSA8 */
 	__u8 kdsa[16];		/* with MSA9 */
 	__u8 sortl[32];		/* with STFLE.150 */
-	__u8 reserved[1760];
+	__u8 dfltcc[32];	/* with STFLE.151 */
+	__u8 reserved[1728];
 };
 
 /* kvm attributes for crypto */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 757f76bba9ea..38ca8324a91a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -335,6 +335,7 @@ static inline void __insn32_query(unsigned int opcode, u8 query[32])
 }
 
 #define INSN_SORTL 0xb938
+#define INSN_DFLTCC 0xb939
 
 static void kvm_s390_cpu_feat_init(void)
 {
@@ -390,6 +391,9 @@ static void kvm_s390_cpu_feat_init(void)
 	if (test_facility(150)) /* SORTL */
 		__insn32_query(INSN_SORTL, kvm_s390_available_subfunc.sortl);
 
+	if (test_facility(151)) /* DFLTCC */
+		__insn32_query(INSN_DFLTCC, kvm_s390_available_subfunc.dfltcc);
+
 	if (MACHINE_HAS_ESOP)
 		allow_cpu_feat(KVM_S390_VM_CPU_FEAT_ESOP);
 	/*
@@ -1361,6 +1365,11 @@ static int kvm_s390_set_processor_subfunc(struct kvm *kvm,
 		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[1],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[2],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[3]);
+	VM_EVENT(kvm, 3, "SET: guest DFLTCC subfunc 0x%16.16lx.%16.16lx.%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[0],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[1],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[2],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[3]);
 
 	return 0;
 }
@@ -1537,6 +1546,11 @@ static int kvm_s390_get_processor_subfunc(struct kvm *kvm,
 		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[1],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[2],
 		 ((unsigned long *) &kvm->arch.model.subfuncs.sortl)[3]);
+	VM_EVENT(kvm, 3, "GET: guest DFLTCC subfunc 0x%16.16lx.%16.16lx.%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[0],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[1],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[2],
+		 ((unsigned long *) &kvm->arch.model.subfuncs.dfltcc)[3]);
 
 	return 0;
 }
@@ -1600,6 +1614,11 @@ static int kvm_s390_get_machine_subfunc(struct kvm *kvm,
 		 ((unsigned long *) &kvm_s390_available_subfunc.sortl)[1],
 		 ((unsigned long *) &kvm_s390_available_subfunc.sortl)[2],
 		 ((unsigned long *) &kvm_s390_available_subfunc.sortl)[3]);
+	VM_EVENT(kvm, 3, "GET: host  DFLTCC subfunc 0x%16.16lx.%16.16lx.%16.16lx.%16.16lx",
+		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[0],
+		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[1],
+		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[2],
+		 ((unsigned long *) &kvm_s390_available_subfunc.dfltcc)[3]);
 
 	return 0;
 }
diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index 1ec6bed785e8..cead9e0dcffb 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -94,6 +94,7 @@ static struct facility_def facility_defs[] = {
 			139, /* multiple epoch facility */
 			146, /* msa extension 8 */
 			150, /* enhanced sort */
+			151, /* deflate conversion */
 			155, /* msa extension 9 */
 			-1  /* END */
 		}
-- 
2.19.1

