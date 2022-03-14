Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6504D8D28
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244643AbiCNTvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244614AbiCNTvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:51:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE90CD0;
        Mon, 14 Mar 2022 12:50:10 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlU6m028547;
        Mon, 14 Mar 2022 19:49:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=SWc6MuMSC9w8oU6vRRvUPONvCvFrwclXYK3FlPs/4gc=;
 b=EffB0VFihZDT+oRLFGBEmUbXQkVzLWSIlx2aT/89OSt58qm3DlHmeOKGryEmmM9IrS5m
 NfmVDL7ZxGcSPkw3xnRFe/4d1kELKnMbd/E/B/27RiWe89UAEBri74SL8zVo4FmFs6tB
 7jNxHKfJW4byfIWDMoWx63EZTuvw78e+QKlWo3U5VR0zp+R+GZtKtofv9OCGtUJ7UmRj
 fSLuzuWDPi6kinxrSSkJ1NNOlTRUCmpjwHA6AlZg1/GJybn2fRk9nQ+LaFRQcJQz8ixb
 RRLLYUC4YeDLkJ7FRozHNKmjVQjuUhncqxHeis+2wMC03ixQ7oTRfSEqC1TwV/Xzqazl Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6d7rpy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:34 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJm7LW030677;
        Mon, 14 Mar 2022 19:49:33 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6d7rpxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:33 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJl8Bd005348;
        Mon, 14 Mar 2022 19:49:33 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3erk5989fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:33 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJnV3T18874628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:49:31 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFCE6112062;
        Mon, 14 Mar 2022 19:49:31 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1672A11206F;
        Mon, 14 Mar 2022 19:49:25 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:49:24 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 27/32] KVM: s390: intercept the rpcit instruction
Date:   Mon, 14 Mar 2022 15:44:46 -0400
Message-Id: <20220314194451.58266-28-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: riGnR9-O1SW95wh5PuJ0eEFFQ_lVtcIH
X-Proofpoint-ORIG-GUID: 72FXc0OO0PISfWeRqbD5ARFbLQC2DMsU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 adultscore=0 mlxlogscore=845 malwarescore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 417154b314a6..546c99a0e0b6 100644
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
+	int rc;
+
+	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
+		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+
+	/* KVM can only handle if we support KVM-managed IOMMU */
+	if (!IS_ENABLED(CONFIG_S390_KVM_IOMMU))
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
+					vcpu->run->s.regs.gprs[reg2 + 1]);
+
+	switch (rc) {
+	case 0:
+		kvm_s390_set_psw_cc(vcpu, 0);
+		break;
+	case -ENOMEM:
+		vcpu->run->s.regs.gprs[reg1] &= 0xffffffff00ffffffUL;
+		vcpu->run->s.regs.gprs[reg1] |= (u64)4 << 24;
+		kvm_s390_set_psw_cc(vcpu, 1);
+		break;
+	case -EIO:
+		vcpu->run->s.regs.gprs[reg1] &= 0xffffffff00ffffffUL;
+		vcpu->run->s.regs.gprs[reg1] |= (u64)16 << 24;
+		kvm_s390_set_psw_cc(vcpu, 1);
+		break;
+	default:
+		kvm_s390_set_psw_cc(vcpu, 3);
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

