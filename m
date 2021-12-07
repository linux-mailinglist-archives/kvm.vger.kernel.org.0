Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA22A46C5AD
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241622AbhLGVEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:04:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12536 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234018AbhLGVDi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:03:38 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JbfUK015288;
        Tue, 7 Dec 2021 21:00:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TAu9974mBQZLLiUBilsFR1Sl7cQUZCSPqFLDJ18RwP4=;
 b=F9a09fq99X3t5P2U4BetwTSy8hImLsGpS47gOt5A7oOecYkzJNqwSmcaLxY0RxKw44Js
 Pua/GTcp1jIBT55An1fV0GDA1E028w08h0reWZMu39B8RYNe5x2KyrTuJYpJJwKUlXYc
 YaikTIFsI8PpDRYwrfx7MKZbuPDQWtwYNr7pqA+WwCFSPZGh6eFOsgpzG2H8Mr621O8j
 HpvPWxHOxEAB1GcRu5JMWuK2M5b4Nisx/t1uemNq6GyWGmnup9jfc8bvzxQ4UzMmgJ81
 vYWjtfCqReEqRrcKNR8vhaD842E3hIxSb6SLQKJr28cfpXa9kMDembK5zUbM0i48moR9 tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctdcda36d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:06 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KeATm029519;
        Tue, 7 Dec 2021 21:00:06 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctdcda35k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:06 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KwOET001911;
        Tue, 7 Dec 2021 21:00:05 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 3cqyyamj6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:00:05 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L02jD60293480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:00:02 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A569AE06A;
        Tue,  7 Dec 2021 21:00:02 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07B40AE067;
        Tue,  7 Dec 2021 20:59:57 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:59:56 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/32] KVM: s390: intercept the rpcit instruction
Date:   Tue,  7 Dec 2021 15:57:35 -0500
Message-Id: <20211207205743.150299-25-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dhOt0PuitiyXdRBbkE50RW1IRNO_VWk6
X-Proofpoint-GUID: l_Sz5_GnSQg4rTaes6UUEz8c-qof8enV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For faster handling of PCI translation refreshes, intercept in KVM
and call the associated handler.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/pci.h  |  4 ++++
 arch/s390/kvm/priv.c | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index d252a631b693..3f96eff432aa 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -18,6 +18,10 @@
 
 #define KVM_S390_PCI_DTSM_MASK 0x40
 
+#define KVM_S390_RPCIT_STAT_MASK 0xffffffff00ffffffUL
+#define KVM_S390_RPCIT_INS_RES (0x10 << 24)
+#define KVM_S390_RPCIT_ERR (0x28 << 24)
+
 struct zpci_gaite {
 	unsigned int gisa;
 	u8 gisc;
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 417154b314a6..768ae92ecc59 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -29,6 +29,7 @@
 #include <asm/ap.h>
 #include "gaccess.h"
 #include "kvm-s390.h"
+#include "pci.h"
 #include "trace.h"
 
 static int handle_ri(struct kvm_vcpu *vcpu)
@@ -335,6 +336,44 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_rpcit(struct kvm_vcpu *vcpu)
+{
+	int reg1, reg2;
+	int rc;
+
+	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
+		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+
+	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
+
+	rc = kvm_s390_pci_refresh_trans(vcpu, vcpu->run->s.regs.gprs[reg1],
+					vcpu->run->s.regs.gprs[reg2],
+					vcpu->run->s.regs.gprs[reg2+1]);
+
+	switch (rc) {
+	case 0:
+		kvm_s390_set_psw_cc(vcpu, 0);
+		break;
+	case -EOPNOTSUPP:
+		return -EOPNOTSUPP;
+	case -EINVAL:
+		kvm_s390_set_psw_cc(vcpu, 3);
+		break;
+	case -ENOMEM:
+		vcpu->run->s.regs.gprs[reg1] &= KVM_S390_RPCIT_STAT_MASK;
+		vcpu->run->s.regs.gprs[reg1] |= KVM_S390_RPCIT_INS_RES;
+		kvm_s390_set_psw_cc(vcpu, 1);
+		break;
+	default:
+		vcpu->run->s.regs.gprs[reg1] &= KVM_S390_RPCIT_STAT_MASK;
+		vcpu->run->s.regs.gprs[reg1] |= KVM_S390_RPCIT_ERR;
+		kvm_s390_set_psw_cc(vcpu, 1);
+		break;
+	}
+
+	return 0;
+}
+
 #define SSKE_NQ 0x8
 #define SSKE_MR 0x4
 #define SSKE_MC 0x2
@@ -1275,6 +1314,8 @@ int kvm_s390_handle_b9(struct kvm_vcpu *vcpu)
 		return handle_essa(vcpu);
 	case 0xaf:
 		return handle_pfmf(vcpu);
+	case 0xd3:
+		return handle_rpcit(vcpu);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.27.0

