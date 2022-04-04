Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A52D4F1BBF
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381150AbiDDVWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379666AbiDDRqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:46:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A55913EBA;
        Mon,  4 Apr 2022 10:44:37 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234H2Hkr018511;
        Mon, 4 Apr 2022 17:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qgtgYuMsbJbzVpHQdKu6lYWj+NBGkMa5mOitkgEJkBQ=;
 b=Pu6RL24T7FVtvt8INHEmces5EOSfjCk9cSNh0baOtlZonjQo1hLyjpYQ36Xla/9W2+Mx
 USs80vUY4GVX5x8j0bfmZAiMoQmPRP6fErkhXB//fGI0ZZWlYnisfOPNbsTqfahgU4Zj
 KKIWadn/DxypQQBDG2J1HfvpenxHRZ9gRtyuCpDyOy2EYZg8M0+QjVGYwOivz1x3h2YQ
 9iRUwlr6/qfsZqQAkFkcD7DtfFqE/SXvhX15X4IbS++RV7YI349nxNLAyo9s88kBO6e7
 lP3MYbOjoVE/nqA0I4OYgzvzICC5m3yoU4uGdG/EQWz8ZhbngVX1RT+GA5V5vxzsE3O3 hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f80hxj3rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:35 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234HP1Ij006082;
        Mon, 4 Apr 2022 17:44:35 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f80hxj3r1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:35 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Hh1kG003864;
        Mon, 4 Apr 2022 17:44:34 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 3f6e48s7f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:34 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234HiXZx13959652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 17:44:33 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64BCB136051;
        Mon,  4 Apr 2022 17:44:33 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2064613605E;
        Mon,  4 Apr 2022 17:44:31 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 17:44:31 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v5 16/21] KVM: vfio: add s390x hook to register KVM guest designation
Date:   Mon,  4 Apr 2022 13:43:44 -0400
Message-Id: <20220404174349.58530-17-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220404174349.58530-1-mjrosato@linux.ibm.com>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: umeWfGKREChKMCQXQCnboqh-OHG799lV
X-Proofpoint-ORIG-GUID: zvczu5mprSfycHxwd1h0Cf-eYxiiyTyx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the time a KVM is associated with a vfio group, s390x zPCI devices
must register a special guest indication (GISA designation) to allow
for the use of interpretive execution facilities.  This indication is
used to ensure that only the specified KVM can interact with the device.
Similarly, the indication must be removed once the KVM is no longer
associated with the device.

This patch adds an s390-specific hook to invoke a KVM registration routine
for each device associated with the iommu group; in reality, it will be a
NOP for all but zPCI devices on s390x.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 virt/kvm/vfio.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 8fcbc50221c2..2efe5be5a6ee 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -106,7 +106,7 @@ static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
 	return ret > 0;
 }
 
-#ifdef CONFIG_SPAPR_TCE_IOMMU
+#if defined(CONFIG_SPAPR_TCE_IOMMU) || defined(CONFIG_S390)
 static int kvm_vfio_external_user_iommu_id(struct vfio_group *vfio_group)
 {
 	int (*fn)(struct vfio_group *);
@@ -133,7 +133,9 @@ static struct iommu_group *kvm_vfio_group_get_iommu_group(
 
 	return iommu_group_get_by_id(group_id);
 }
+#endif
 
+#ifdef CONFIG_SPAPR_TCE_IOMMU
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 		struct vfio_group *vfio_group)
 {
@@ -147,6 +149,24 @@ static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 }
 #endif
 
+#ifdef CONFIG_S390
+static int kvm_s390_register_kvm(struct vfio_group *vfio_group,
+				  struct kvm *kvm)
+{
+	int rc;
+
+	struct iommu_group *grp = kvm_vfio_group_get_iommu_group(vfio_group);
+
+	if (WARN_ON_ONCE(!grp))
+		return -EPERM;
+
+	rc = iommu_group_for_each_dev(grp, kvm, kvm_s390_pci_register_kvm);
+	iommu_group_put(grp);
+
+	return rc;
+}
+#endif
+
 /*
  * Groups can use the same or different IOMMU domains.  If the same then
  * adding a new group may change the coherency of groups we've previously
@@ -223,6 +243,16 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 			return -ENOMEM;
 		}
 
+#ifdef CONFIG_S390
+		ret = kvm_s390_register_kvm(vfio_group, dev->kvm);
+		if (ret) {
+			kfree(kvg);
+			mutex_unlock(&kv->lock);
+			kvm_vfio_group_put_external_user(vfio_group);
+			return ret;
+		}
+#endif
+
 		list_add_tail(&kvg->node, &kv->group_list);
 		kvg->vfio_group = vfio_group;
 
@@ -258,6 +288,9 @@ static int kvm_vfio_set_group(struct kvm_device *dev, long attr, u64 arg)
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 			kvm_spapr_tce_release_vfio_group(dev->kvm,
 							 kvg->vfio_group);
+#endif
+#ifdef CONFIG_S390
+			kvm_s390_register_kvm(vfio_group, NULL);
 #endif
 			kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
 			kvm_vfio_group_put_external_user(kvg->vfio_group);
-- 
2.27.0

