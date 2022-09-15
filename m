Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA8F5BA089
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 19:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiIORz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 13:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIORzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 13:55:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB17070E7F;
        Thu, 15 Sep 2022 10:55:21 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FHkSNx007730;
        Thu, 15 Sep 2022 17:55:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=CK82983AQWwZGNyj4I7pUVrzzAJGVtZjwDOpGqMAgDA=;
 b=de3PzOw3+GO0HtK+9tPUGn4euIoCbvM3dRvMqkL0hHx5RqAG7WChlRb8m5M+w4ncxrh4
 8ZPqbpjQmbPt3/3/zT97wL/yax3BGfkTFMU25yJwOzIiKRVYvpXQWFAkGm7Vism3JfvJ
 X1a1UvR8XSGe9tQo+GwLrRhUqpm7rcg/cRYbeTqRRDVhZZANUugB4sp9mCwJVtOLlhIN
 cGHC16XoPtRK0xDQpH5cxc32gpDUq0r1V9tylQr8m0VFw23aaSclOhNw+F5/V92r0YPe
 fw0xebT0fmbLvMa4JuLRKaexHQQqK4+mgeieOnHvrLlOltUFfvShUM52wxri4E3WGUvS mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm8rcg7uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 17:55:18 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28FHlZDW011170;
        Thu, 15 Sep 2022 17:55:18 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jm8rcg7ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 17:55:18 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28FHop5X016516;
        Thu, 15 Sep 2022 17:55:17 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3jjy2ng0w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 17:55:17 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28FHtFe760555714
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Sep 2022 17:55:16 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1764124052;
        Thu, 15 Sep 2022 17:55:15 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A73B124054;
        Thu, 15 Sep 2022 17:55:15 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.160.9.68])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 15 Sep 2022 17:55:15 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lkp@intel.com
Subject: [PATCH v2] KVM: s390: pci: fix plain integer as NULL pointer warnings
Date:   Thu, 15 Sep 2022 13:55:14 -0400
Message-Id: <20220915175514.167899-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QkcONJEOGCnFMLAyxxQrRRdXjDCky8Ne
X-Proofpoint-ORIG-GUID: MIoC4uf6Qf2HlRmlyRX317GBH9eax-4a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_10,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=833 bulkscore=0 malwarescore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix some sparse warnings that a plain integer 0 is being used instead of
NULL.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
v2 changes:
- checkpatch --strict fixes (Christian)
---
 arch/s390/kvm/pci.c | 4 ++--
 arch/s390/kvm/pci.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index bb8c335d17b9..3c12637ce08c 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -58,7 +58,7 @@ static int zpci_setup_aipb(u8 nisc)
 	if (!zpci_aipb)
 		return -ENOMEM;
 
-	aift->sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, 0);
+	aift->sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, NULL);
 	if (!aift->sbv) {
 		rc = -ENOMEM;
 		goto free_aipb;
@@ -373,7 +373,7 @@ static int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force)
 		gaite->gisc = 0;
 		gaite->aisbo = 0;
 		gaite->gisa = 0;
-		aift->kzdev[zdev->aisb] = 0;
+		aift->kzdev[zdev->aisb] = NULL;
 		/* Clear zdev info */
 		airq_iv_free_bit(aift->sbv, zdev->aisb);
 		airq_iv_release(zdev->aibv);
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 3a3606c3a0fe..486d06ef563f 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -46,9 +46,9 @@ extern struct zpci_aift *aift;
 static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
 						 unsigned long si)
 {
-	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == 0 ||
-	    aift->kzdev[si] == 0)
-		return 0;
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || !aift->kzdev ||
+	    !aift->kzdev[si])
+		return NULL;
 	return aift->kzdev[si]->kvm;
 };
 
-- 
2.37.3

