Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837324D8D3D
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244585AbiCNTve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244576AbiCNTv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:51:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0653F30B;
        Mon, 14 Mar 2022 12:50:00 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlYtZ025603;
        Mon, 14 Mar 2022 19:49:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jCJb3uoE4AvG/NwZYgfyajpNJCvah+v+Z6bhqln4G4c=;
 b=LIPz+MLLTikUhz4jKyNX34r6G3+PlSLQQYPHtG1+dJIitiQv3IvJJkX/cbWYQyKyJPxw
 seb6zXw8nEqCaKj+t+96fI5SY5XpxCjyzcgZBrHw/wyNkZS5E35OOk/XjEsbYYwCtf1Q
 1VWe9YlQfRw6uGK+rxyNZAuE/IK8t3l0X3r+x7VqbVFUwTMV/uz9ZW2xregdreQ/nsrj
 kh22YNUWj3dFlEyi0r8NhlE39AFLM5rcQDj0jOMJ/NJoa/ooG0iqs54o4hd2Y7FMNMRw
 +wD92e5g2ZMMmXTJccyF6/+eBrPxcWGlhT6Drs806PkJqNaiWqp7O9ML+uDarr36/vHc WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ag0yf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:19 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJlklJ026151;
        Mon, 14 Mar 2022 19:49:19 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ag0yej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:19 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJl8OK028282;
        Mon, 14 Mar 2022 19:49:18 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 3erk59cc8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:18 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJnG5i24445254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:49:16 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84CA2112062;
        Mon, 14 Mar 2022 19:49:16 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53A69112067;
        Mon, 14 Mar 2022 19:49:09 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:49:09 +0000 (GMT)
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
Subject: [PATCH v4 25/32] KVM: s390: pci: provide routines for enabling/disabling IOAT assist
Date:   Mon, 14 Mar 2022 15:44:44 -0400
Message-Id: <20220314194451.58266-26-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SPJUUOUAeJSXFD4EIEAL_MrgG_3QDlfG
X-Proofpoint-GUID: fHXz44E_9nQE3ex7ajBCv_hdg3OJLOGY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=789
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into a kvm ioctl in orer to respond to
requests to enable / disable a device for PCI I/O Address Translation
assistance via a KVM-managed IOMMU.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |  2 ++
 arch/s390/kvm/pci.c             | 25 +++++++++++++++++++++++++
 arch/s390/kvm/pci.h             |  2 ++
 3 files changed, 29 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index ed596880fb06..e27dbede723c 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -30,6 +30,8 @@ struct kvm_zdev {
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
 void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
 
+u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev);
+
 int zpci_iommu_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
 int zpci_iommu_kvm_assign_iota(struct zpci_dev *zdev, u64 iota);
 int zpci_iommu_kvm_remove_iota(struct zpci_dev *zdev);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 2287c1c6a3e5..1a8b82220b29 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -367,6 +367,28 @@ static int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force)
 	return rc;
 }
 
+static int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota)
+{
+	if (IS_ENABLED(CONFIG_S390_KVM_IOMMU))
+		return zpci_iommu_kvm_assign_iota(zdev, iota);
+	else
+		return -EINVAL;
+}
+
+static int kvm_s390_pci_ioat_disable(struct zpci_dev *zdev)
+{
+	if (IS_ENABLED(CONFIG_S390_KVM_IOMMU))
+		return zpci_iommu_kvm_remove_iota(zdev);
+	else
+		return -EINVAL;
+}
+
+u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev)
+{
+	return (zdev->dtsm & KVM_S390_PCI_DTSM_MASK);
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_get_dtsm);
+
 static int kvm_s390_pci_interp_enable(struct zpci_dev *zdev)
 {
 	u32 gisa;
@@ -432,6 +454,9 @@ static int kvm_s390_pci_interp_disable(struct zpci_dev *zdev, bool force)
 	if (zdev->kzdev->fib.fmt0.aibv != 0)
 		kvm_s390_pci_aif_disable(zdev, force);
 
+	/* If we are using the IOAT assist, disable it now */
+	kvm_s390_pci_ioat_disable(zdev);
+
 	/* Remove the host CLP guest designation */
 	zdev->gisa = 0;
 
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index a95d9fdc91be..867f04cae3a1 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -16,6 +16,8 @@
 #include <asm/airq.h>
 #include <asm/kvm_pci.h>
 
+#define KVM_S390_PCI_DTSM_MASK 0x40
+
 struct zpci_gaite {
 	u32 gisa;
 	u8 gisc;
-- 
2.27.0

