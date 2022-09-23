Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146D35E7A41
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 14:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiIWMKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 08:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiIWMIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 08:08:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A621BEA3;
        Fri, 23 Sep 2022 05:04:39 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28N9vKvl011324;
        Fri, 23 Sep 2022 12:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=OzUEcDhu0qh2YqCTkRvKPPXqpFu/inhXQHKlpTgMd0o=;
 b=BBkUmJMwHV3dTbaWHtn9lMCNBunREUGZ9dWi5H+Nmqk67YGL4SJUhl8JXsv6HM0Y7404
 4yAQICUGDTIFQ0/yryz8pUg+EANQPw/V9SCqB7QEJY+G9doqNJ57YAbU2UgxtT13M+qw
 f4A+kuSLE3eBndsLk079VmoxZizSwi4IYHlQgJQ7yDAR8YNr+jyesD3szPts9z9arPfL
 LKLkDDkmRyMbPwkg+J4LKJhgLRIzfmBSKZvAZ53rWIrmbTC3ElScb1S3j2enFEHl/s+Q
 L3j5d+CVJtmP7NnWNjpNsO/EMs36cl5rJFTNfygCNGBF/C8SkF5GgXPKodAMkqz1vddz OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsam5b59w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:39 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28NBpVlY008887;
        Fri, 23 Sep 2022 12:04:38 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jsam5b58s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:38 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28NBqPEq015249;
        Fri, 23 Sep 2022 12:04:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3jn5v95xb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Sep 2022 12:04:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28NC4Xpu34341258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Sep 2022 12:04:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E93DEAE051;
        Fri, 23 Sep 2022 12:04:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CAB4AE045;
        Fri, 23 Sep 2022 12:04:32 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.171.28.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 23 Sep 2022 12:04:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 1/4] KVM: s390: pci: fix plain integer as NULL pointer warnings
Date:   Fri, 23 Sep 2022 14:04:09 +0200
Message-Id: <20220923120412.15294-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220923120412.15294-1-frankja@linux.ibm.com>
References: <20220923120412.15294-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pv9UdWZVOc2gfaSnvDnpyhZ3EdR1vQ7J
X-Proofpoint-ORIG-GUID: anYPPpFe6s7koCpDywv3R80t6OP4-tc_
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-23_04,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=878
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2209230079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

Fix some sparse warnings that a plain integer 0 is being used instead of
NULL.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20220915175514.167899-1-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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

