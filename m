Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893024AA1EE
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343832AbiBDVRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:17:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243339AbiBDVQd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:33 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214KwNtZ011886;
        Fri, 4 Feb 2022 21:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=T5ZAceHFx/43XZIeTUGrJt+q9LFObpveQIP+e7NjlYM=;
 b=Zh9hq0I/TYOuGsVcfBscyqIrzKzo9ayGistdvMc8huaeqWboqBRb576sQsRoLasflhs2
 LW43pm7xR6VUPqvkg3cgGq/mPSYxGC4ZmKL4cNSLX+QmiReO2rIbIuYDVJSpRZYctScc
 rONyCZXLqCr+fq07z2i9z8QdDZ7RZrw+xWP5dPk4GfIkCTQ1UksMrAX0UCOoMiR7hGUE
 MKQTyI986PD7tkJacYMcw4wvOxHdivjueku0cBHOL0ZrPMJoD9XTlmfr5Ox8idpRLRTn
 GoSKUXIUoKMjGzARQKFjrwq2d57KIn3gOGKmIEqfs+Uot1U36GnD7JG6gCtsRsXTCN2V Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0vrs2guc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:32 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LGWRQ004452;
        Fri, 4 Feb 2022 21:16:32 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0vrs2gtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:32 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCoEI008508;
        Fri, 4 Feb 2022 21:16:31 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 3e0r0pyfd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:31 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGTK719726636
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:29 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2958E13605D;
        Fri,  4 Feb 2022 21:16:29 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 428CA136053;
        Fri,  4 Feb 2022 21:16:27 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:27 +0000 (GMT)
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
Subject: [PATCH v3 23/30] KVM: s390: intercept the rpcit instruction
Date:   Fri,  4 Feb 2022 16:15:29 -0500
Message-Id: <20220204211536.321475-24-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1laRQgiM-Sj1rfn533qjOehWHIwsToGa
X-Proofpoint-ORIG-GUID: N6x5EjlZEqlDRtp_7C7UJU5hToZ8NIxc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=989 priorityscore=1501 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For faster handling of PCI translation refreshes, intercept in KVM
and call the associated handler.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/priv.c | 49 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 417154b314a6..d6a5784d8dde 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -29,6 +29,7 @@
 #include <asm/ap.h>
 #include "gaccess.h"
 #include "kvm-s390.h"
+#include "pci.h"
 #include "trace.h"
 
 static int handle_ri(struct kvm_vcpu *vcpu)
@@ -335,6 +336,52 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_rpcit(struct kvm_vcpu *vcpu)
+{
+	int reg1, reg2;
+	u8 status;
+	int rc;
+
+	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
+		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+
+	/*
+	 * If the host doesn't support PCI passthrough interpretation, it must
+	 * be an emulated device.
+	 */
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV))
+		return -EOPNOTSUPP;
+
+	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
+
+	/* If the device has a SHM bit on, let userspace take care of this */
+	if (((vcpu->run->s.regs.gprs[reg1] >> 32) & aift->mdd) != 0)
+		return -EOPNOTSUPP;
+
+	rc = kvm_s390_pci_refresh_trans(vcpu, vcpu->run->s.regs.gprs[reg1],
+					vcpu->run->s.regs.gprs[reg2],
+					vcpu->run->s.regs.gprs[reg2 + 1],
+					&status);
+
+	switch (rc) {
+	case 0:
+		kvm_s390_set_psw_cc(vcpu, 0);
+		break;
+	case -EOPNOTSUPP:
+		return -EOPNOTSUPP;
+	default:
+		vcpu->run->s.regs.gprs[reg1] &= 0xffffffff00ffffffUL;
+		vcpu->run->s.regs.gprs[reg1] |= (u64)status << 24;
+		if (status != 0)
+			kvm_s390_set_psw_cc(vcpu, 1);
+		else
+			kvm_s390_set_psw_cc(vcpu, 3);
+		break;
+	}
+
+	return 0;
+}
+
 #define SSKE_NQ 0x8
 #define SSKE_MR 0x4
 #define SSKE_MC 0x2
@@ -1275,6 +1322,8 @@ int kvm_s390_handle_b9(struct kvm_vcpu *vcpu)
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

