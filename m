Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59975BEDBF
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 21:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiITT2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 15:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiITT1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 15:27:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50E676444;
        Tue, 20 Sep 2022 12:27:44 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KJRRN4004582;
        Tue, 20 Sep 2022 19:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8zHjW6nlfhTMB0k8x33TaWt4Tz+UyqK8G6yOykTXviI=;
 b=Lk9twSYAWOR0OveYJLozfNCg3vRMhdBJP/Ly6DGsIH/ytjaXbYztMQWKkI4Q03Aaw40z
 a0su8wKA5MsimXepIRGIzFyl3VYlq3EDYOWNbqz/4aqfB2UrHRok5oGcHxuKhZfjR0D6
 4A/OXnpAfi9udPUqoa4ZHzfmub6qzqen3rrnwi6ZyWUFzA2eSq+WY96ZNGSAqL+2FK5e
 e56FMy0d14U8vSTyUsHYDbHFUSHseDLyKBpvuh7M1Kxi05y4ao5WO26vSqcn8st/3mcw
 VjHr5POJ9A9UvOjn9h44vnMmUkrGEANEjE1BYZHjMLg53brgVqFQd8kHMqSiBtjMpuwR 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqkpd004u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:27:43 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28KJRhB5005272;
        Tue, 20 Sep 2022 19:27:43 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqkpd004q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:27:43 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28KJMQZu001903;
        Tue, 20 Sep 2022 19:27:42 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04wdc.us.ibm.com with ESMTP id 3jn5v9wncp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 19:27:42 +0000
Received: from smtpav04.dal12v.mail.ibm.com ([9.208.128.131])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28KJRfY315663820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 19:27:41 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1660558052;
        Tue, 20 Sep 2022 19:27:41 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E40BB5804E;
        Tue, 20 Sep 2022 19:27:39 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.65.230.56])
        by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 19:27:39 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] KVM: s390: pci: register pci hooks without interpretation
Date:   Tue, 20 Sep 2022 15:27:39 -0400
Message-Id: <20220920192739.135174-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N_1vBUfXUDKQm3e_gQ3hbZ0wU5ZI33er
X-Proofpoint-GUID: Wtx5JpLQxjwYS_7f1no9ZmHz-alFoJ2O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_09,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=905 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm registration hooks must be registered even if the facilities
necessary for zPCI interpretation are unavailable, as vfio-pci-zdev will
expect to use the hooks regardless.
This fixes an issue where vfio-pci-zdev will fail its open function
because of a missing kvm_register when running on hardware that does not
support zPCI interpretation.

Fixes: ca922fecda6c ("KVM: s390: pci: Hook to access KVM lowlevel from VFIO")
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c |  4 ++--
 arch/s390/kvm/pci.c      | 14 +++++++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e20e126944aa..5c7f5f97ea09 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -510,7 +510,7 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
-	if (kvm_s390_pci_interp_allowed()) {
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)) {
 		rc = kvm_s390_pci_init();
 		if (rc) {
 			pr_err("Unable to allocate AIFT for PCI\n");
@@ -532,7 +532,7 @@ int kvm_arch_init(void *opaque)
 void kvm_arch_exit(void)
 {
 	kvm_s390_gib_destroy();
-	if (kvm_s390_pci_interp_allowed())
+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
 		kvm_s390_pci_exit();
 	debug_unregister(kvm_s390_dbf);
 	debug_unregister(kvm_s390_dbf_uv);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 3c12637ce08c..81457dfeae91 100644
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

