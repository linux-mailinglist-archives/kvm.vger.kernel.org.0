Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5336459ED00
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 22:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiHWUDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 16:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbiHWUCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 16:02:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1847659CC;
        Tue, 23 Aug 2022 12:15:56 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NJ80L4002055;
        Tue, 23 Aug 2022 19:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Z7PPnzf5UZUCsiIde7u3HQqbRxYcT3GG1b46xAdBYag=;
 b=Hpx6PHNA0aPZii/HuZTPBX65z+/3SwgaoypGQM126ai43Sgowny6AwWhRJSilpxwyUyY
 dv/iRbnxqq8KIGvid4qdG4FuQWkq8ry0eFErHXIi4OBbjmqpapA05hAx3TDkIOWBvlYK
 O2H/LjAptf3XRhgm8Y/9ZJJnJ/YJ9fJVVSpG/m7X56GUBYvjWFptZQjxMhLauD0UvqjP
 WI5FdyybdqY9hptafeSw29tTEXz4+BGpe3wNJVY0kACnrKNpeJeciZQQB8VJZS4tsFOg
 hMZ2QnsxCUkiFq9JpOjCdZQg79U/mKrWCdlggsholThm8iJnoq1i7tcqs7jq0+KP08gE LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j54sg87fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 19:15:55 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27NJ82U4002263;
        Tue, 23 Aug 2022 19:15:55 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j54sg87ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 19:15:55 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27NIox1B027102;
        Tue, 23 Aug 2022 19:15:53 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 3j2q89cvd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 19:15:53 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27NJFqAe40239640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 19:15:52 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF05CC6059;
        Tue, 23 Aug 2022 19:15:52 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 588ABC6055;
        Tue, 23 Aug 2022 19:15:51 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.112.122])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 23 Aug 2022 19:15:51 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     farman@linux.ibm.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: s390: pci: fix plain integer as NULL pointer warnings
Date:   Tue, 23 Aug 2022 15:15:48 -0400
Message-Id: <20220823191548.77526-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LrgG7JGjKvAxGeQOt_tE1jZgLm1gljv_
X-Proofpoint-GUID: Dl0sUvzjmqbPUQJHA4M6lAPP796x8tK8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=920
 mlxscore=0 phishscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 3a3606c3a0fe..7be5568d8bd2 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -46,9 +46,9 @@ extern struct zpci_aift *aift;
 static inline struct kvm *kvm_s390_pci_si_to_kvm(struct zpci_aift *aift,
 						 unsigned long si)
 {
-	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == 0 ||
-	    aift->kzdev[si] == 0)
-		return 0;
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || aift->kzdev == NULL ||
+	    aift->kzdev[si] == NULL)
+		return NULL;
 	return aift->kzdev[si]->kvm;
 };
 
-- 
2.31.1

