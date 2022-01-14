Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B25648F145
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239708AbiANUcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244417AbiANUch (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:37 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EHvi0B016956;
        Fri, 14 Jan 2022 20:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZETz3lMGZ/PghhK8/rOh0KNUYErZZ1W/AOw8q5ty+jo=;
 b=UevzxJPE0sHbF03E8yDJXJF6s3qYv1EXFq+nBpCOw710KQH48v+QpVixA7m8MVvVBW0d
 bjLWNxsn3N310MLNZttzFzVBF+gdTuiSj4FW1x72NzOvt0NHP6mkfryKCAC1ueLPqpAk
 Sj6S7tuHXophw1BbZ8XO/JIEz0I1Kf69r6tCt2Y4KOHMf4sJtYBrEU00r8ycJy2G5HI+
 VGJ3zUVgGYuMq2omfbqXQVFPUUQQ3/GJkFIepFX5m17xSUbF4xR/YTiVPO/wz0soPTuy
 fNhidn/oK8n6gr2DbWzlPNey2FK6ET9W1B4mY968wBozRIU6VESU3zXV0U2oK1LF8JUs 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dke1narrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:36 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EJXgb8014214;
        Fri, 14 Jan 2022 20:32:36 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dke1narrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:36 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLoVF020159;
        Fri, 14 Jan 2022 20:32:35 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 3df28de52e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:35 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWYXX19988840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:34 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEC42C6055;
        Fri, 14 Jan 2022 20:32:33 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A46FC605F;
        Fri, 14 Jan 2022 20:32:32 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:32 +0000 (GMT)
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
Subject: [PATCH v2 22/30] KVM: s390: intercept the rpcit instruction
Date:   Fri, 14 Jan 2022 15:31:37 -0500
Message-Id: <20220114203145.242984-23-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LVUL7VkIHUV2VlPrlrAlmF46NpYGV_vi
X-Proofpoint-ORIG-GUID: cqgTlFJTJKViJoTEkAhgyQJ2p7QlMyAT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For faster handling of PCI translation refreshes, intercept in KVM
and call the associated handler.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/priv.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 417154b314a6..5b65c1830de2 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -29,6 +29,7 @@
 #include <asm/ap.h>
 #include "gaccess.h"
 #include "kvm-s390.h"
+#include "pci.h"
 #include "trace.h"
 
 static int handle_ri(struct kvm_vcpu *vcpu)
@@ -335,6 +336,49 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
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
+	/* If the host doesn't support PCI, it must be an emulated device */
+	if (!IS_ENABLED(CONFIG_PCI))
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
+					vcpu->run->s.regs.gprs[reg2+1],
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
+		vcpu->run->s.regs.gprs[reg1] |= (u64) status << 24;
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
@@ -1275,6 +1319,8 @@ int kvm_s390_handle_b9(struct kvm_vcpu *vcpu)
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

