Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEC64D8D27
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244599AbiCNTvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244594AbiCNTvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:51:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B403FBC7;
        Mon, 14 Mar 2022 12:50:05 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlWp6001504;
        Mon, 14 Mar 2022 19:49:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ry3NbK8OjW+Q+ShaRu/ojqyHHa3JtAipA1RifCDi87I=;
 b=MxrxK74FzfgJcM9tbwO1rSMSLlPBK+0ly4cL37Se8M2u8PqwxKVffa238+chL7LdAfr0
 31gMx5+27rgbtT2P+pGez9nXQ7fTup1ZSiEyVh/nDkBPHo5LZGQcXjDh4NhyQQ84WDm1
 qVHT448J0QnS1gGemC8HvgsKKq83/LY0YtUIe7oPzzxaCAt4lPBIGyJBhOI5UDP45rqi
 pH175PyykoAiqf6yVKCFGGjHT4y/Q3OgQHTEXHQpU5Jxoa//6dSupXgtseEwR6tXNL5O
 UV9vl6LHGHBiSQ/Sr+AQyt1dqoczj7RdEJX0BpIAn8luaJ/tDV9o65TXWsrye//u8aeh 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ae14qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:28 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJlfTD002002;
        Mon, 14 Mar 2022 19:49:28 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ae14q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:27 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlA6G009546;
        Mon, 14 Mar 2022 19:49:26 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 3erk59cc9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:26 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJnOfH18874866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:49:24 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF09011206D;
        Mon, 14 Mar 2022 19:49:24 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32E8F112067;
        Mon, 14 Mar 2022 19:49:17 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:49:16 +0000 (GMT)
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
Subject: [PATCH v4 26/32] KVM: s390: pci: handle refresh of PCI translations
Date:   Mon, 14 Mar 2022 15:44:45 -0400
Message-Id: <20220314194451.58266-27-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9Ec6i66jadZq2zyy5JtpUS9nu1v6bBUL
X-Proofpoint-GUID: 7fweTxisU0AQQWE-kQ_rSZ42Dc-755GY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=748
 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
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

Add a routine that will perform a shadow operation between a guest
and host IOAT.  A subsequent patch will invoke this in response to
an 04 RPCIT instruction intercept.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |  1 +
 arch/s390/kvm/pci.c             | 31 ++++++++++++++++++++++++++++++-
 arch/s390/kvm/pci.h             |  3 +++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index e27dbede723c..9578b5dafb45 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -25,6 +25,7 @@ struct kvm_zdev {
 	struct zpci_fib fib;
 	struct notifier_block nb;
 	struct list_head entry;
+	u64 rpcit_count;
 };
 
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 1a8b82220b29..40d2fadbfbd5 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/iommu.h>
 #include <linux/pci.h>
 #include <linux/vfio.h>
 #include <asm/kvm_pci.h>
@@ -173,6 +174,30 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
+			       unsigned long start, unsigned long size)
+{
+	struct kvm_zdev *kzdev;
+	u32 fh = req >> 32;
+	int rc;
+
+	/* Make sure this is a valid device associated with this guest */
+	kzdev = get_kzdev_by_fh(vcpu->kvm, fh);
+	if (!kzdev)
+		return -EINVAL;
+
+	/*
+	 * The KVM-managed IOMMU map operation will synchronize the associated
+	 * guest IOAT tables with the host DMA tables.  A physical address is
+	 * not specified as it will be derived from pinned guest PTEs
+	 */
+	rc = iommu_map(kzdev->dom, start, 0, size, IOMMU_WRITE | IOMMU_READ);
+
+	kzdev->rpcit_count++;
+
+	return rc;
+}
+
 /* Modify PCI: Register floating adapter interruption forwarding */
 static int kvm_zpci_set_airq(struct zpci_dev *zdev)
 {
@@ -716,6 +741,8 @@ void kvm_s390_pci_clear_list(struct kvm *kvm)
 
 int kvm_s390_pci_init(void)
 {
+	int rc;
+
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
 	if (!aift)
 		return -ENOMEM;
@@ -723,5 +750,7 @@ int kvm_s390_pci_init(void)
 	spin_lock_init(&aift->gait_lock);
 	mutex_init(&aift->aift_lock);
 
-	return 0;
+	rc = zpci_get_mdd(&aift->mdd);
+
+	return rc;
 }
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 867f04cae3a1..2cb1b27396c1 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -33,6 +33,7 @@ struct zpci_aift {
 	struct kvm_zdev **kzdev;
 	spinlock_t gait_lock; /* Protects the gait, used during AEN forward */
 	struct mutex aift_lock; /* Protects the other structures in aift */
+	u32 mdd;
 };
 
 extern struct zpci_aift *aift;
@@ -48,6 +49,8 @@ static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
 
 int kvm_s390_pci_aen_init(u8 nisc);
 void kvm_s390_pci_aen_exit(void);
+int kvm_s390_pci_refresh_trans(struct kvm_vcpu *vcpu, unsigned long req,
+			       unsigned long start, unsigned long end);
 
 int kvm_s390_pci_zpci_start(struct kvm *kvm, struct zpci_dev *zdev);
 int kvm_s390_pci_zpci_stop(struct kvm *kvm, struct zpci_dev *zdev);
-- 
2.27.0

