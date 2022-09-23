Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B745E7A3A
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 14:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiIWMKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 08:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiIWMIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 08:08:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D1622B36;
        Fri, 23 Sep 2022 05:04:41 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28NARL5S010625;
        Fri, 23 Sep 2022 12:04:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=l6jZ1NHdnQJ1J/pj/3nB/Nz3wXwZjjzdqjOMvVgjUf4=;
 b=r+hDKSwZHb5t0AXcGvZC34Q81tP+w1BcQvx+LxRazWlZSv7MyM7GeC0GHTY4jQFc6cfH
 Lo9F7TngoO80GS9EIAiGXQpMVudmVlNxIjaaZB0tw989ijnkVCbodXgoiocQJ+bXC32R
 rojEU+r8Rs13yurpQIIOn8d8DZufRHJ7sv9bv75SARyI+bx20tyOGqYMmnTvn2jccwiC
 l7FKZBXyxofDQEk5RcMiN5c1Wp7Ve2u9EkFPhjLNiSAtgTRWj7tJZSbIziHJ3hi2jftP
 SGUpjxyPBVDNLTDldzv3zpnmFZw+9PzFGfYHpC3m9Aprca+jceQKD96/DSBFhhzooJe1 Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsb29jmrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:40 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28NBcFHr026559;
        Fri, 23 Sep 2022 12:04:40 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsb29jmq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:40 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28NBqWif007170;
        Fri, 23 Sep 2022 12:04:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3jn5ghnxc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28NC4YQe6947178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 12:04:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44BD3AE055;
        Fri, 23 Sep 2022 12:04:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD84DAE045;
        Fri, 23 Sep 2022 12:04:33 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.171.28.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Sep 2022 12:04:33 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 4/4] KVM: s390: pci: register pci hooks without interpretation
Date:   Fri, 23 Sep 2022 14:04:12 +0200
Message-Id: <20220923120412.15294-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220923120412.15294-1-frankja@linux.ibm.com>
References: <20220923120412.15294-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XzP1Se8W-aalf3IpaHcDaczjiVGXxOP1
X-Proofpoint-GUID: AZwVBU7u6iriT18s3Ne4Q3AbXc3-Ems_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_04,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209230079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

The kvm registration hooks must be registered even if the facilities
necessary for zPCI interpretation are unavailable, as vfio-pci-zdev will
expect to use the hooks regardless.
This fixes an issue where vfio-pci-zdev will fail its open function
because of a missing kvm_register when running on hardware that does not
support zPCI interpretation.

Fixes: ca922fecda6c ("KVM: s390: pci: Hook to access KVM lowlevel from VFIO")
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Link: https://lore.kernel.org/r/20220920193025.135655-1-mjrosato@linux.ibm.com
Message-Id: <20220920193025.135655-1-mjrosato@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c |  4 ++--
 arch/s390/kvm/pci.c      | 14 +++++++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index edfd4bbd0cba..b7ef0b71014d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -505,7 +505,7 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
-	if (kvm_s390_pci_interp_allowed()) {
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
 		rc = kvm_s390_pci_init();
 		if (rc) {
 			pr_err("Unable to allocate AIFT for PCI\n");
@@ -527,7 +527,7 @@ int kvm_arch_init(void *opaque)
 void kvm_arch_exit(void)
 {
 	kvm_s390_gib_destroy();
-	if (kvm_s390_pci_interp_allowed())
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
 		kvm_s390_pci_exit();
 	debug_unregister(kvm_s390_dbf);
 	debug_unregister(kvm_s390_dbf_uv);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 90aaba80696a..c50c1645c0ae 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -672,23 +672,31 @@ int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
 
 int kvm_s390_pci_init(void)
 {
+	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
+	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
+
+	if (!kvm_s390_pci_interp_allowed())
+		return 0;
+
 	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
 	if (!aift)
 		return -ENOMEM;
 
 	spin_lock_init(&aift->gait_lock);
 	mutex_init(&aift->aift_lock);
-	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
-	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
 
 	return 0;
 }
 
 void kvm_s390_pci_exit(void)
 {
-	mutex_destroy(&aift->aift_lock);
 	zpci_kvm_hook.kvm_register = NULL;
 	zpci_kvm_hook.kvm_unregister = NULL;
 
+	if (!kvm_s390_pci_interp_allowed())
+		return;
+
+	mutex_destroy(&aift->aift_lock);
+
 	kfree(aift);
 }
-- 
2.37.3

