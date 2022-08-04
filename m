Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8132589FEC
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 19:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbiHDRgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 13:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiHDRgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 13:36:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3087AE0FC;
        Thu,  4 Aug 2022 10:36:00 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274HYOYE002612;
        Thu, 4 Aug 2022 17:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bHrzd4IORsCUFsxr6bF7gsPJpewPI6I31yQT1nNEqFk=;
 b=euFgz/rJ26wWYHptJglzbFqqWybh/0toyyeVwV4A3Aw/m7wlv9K8b0lIAtfvkiO0MtoZ
 L4RYxy1sofAY/j9uENB36goDsK+dgZEbiyQjASVp7b525yT8YsdhkDFHlqSskpPK2J7d
 J7yK+wPwuHRHgD7pZm6McpLrW96EpJeFvAAYsnIFxnw90GIk2fXRsjRTOuVBkWRCOLxP
 P9G+RewNvY9GgYTjoWXl5giN9XkFVd8O4ltU5W4bPLXCA5XuNymEc/N2Z70f8t9LX22e
 vGdlqH7EAgAEGe1pNbx90jAYaLyRXg4TJDoLKwplh0/vh2FcUVDw+QMXIOSXD+su8C9C /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hrjmkg23t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 17:35:56 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 274HYk5Q004240;
        Thu, 4 Aug 2022 17:35:55 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hrjmkg21w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 17:35:55 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 274H4rte010715;
        Thu, 4 Aug 2022 17:35:54 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 3hq6j009ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Aug 2022 17:35:54 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 274HZrUr51773804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Aug 2022 17:35:53 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0C2E28058;
        Thu,  4 Aug 2022 17:35:52 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53EA32805A;
        Thu,  4 Aug 2022 17:35:51 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.67.200])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  4 Aug 2022 17:35:51 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH 1/1] KVM: s390: pci: fix airq_iv_create sparse warning
Date:   Thu,  4 Aug 2022 13:35:46 -0400
Message-Id: <20220804173546.226968-2-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220804173546.226968-1-mjrosato@linux.ibm.com>
References: <20220804173546.226968-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nhnOarOiO2cGbvotrXYpaV2fUq0HRWBj
X-Proofpoint-GUID: z88Zu_N22C6d5XIoKmIBYdfDc8lMj6Ng
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=767 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the call to airq_iv_create to pass a NULL instead of 0.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 4946fb7757d6..92a6998d8904 100644
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
-- 
2.31.1

