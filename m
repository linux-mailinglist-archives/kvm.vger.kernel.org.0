Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D673510998
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354493AbiDZUMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354472AbiDZUMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:12:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE83169E59;
        Tue, 26 Apr 2022 13:09:06 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QK481Z017096;
        Tue, 26 Apr 2022 20:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H6p70Z1YMgrjJTkx+Yf17li7R+Rru0mRUfffXX/t7wc=;
 b=Zi/CsuR1TEIPvknXmMFysmCXkrOmuHlYJIYa1kxNWLc4xtF73yg967HARvB480GtGBrZ
 SA+QWMTPAFexLxQipgAxjHLVfJWOovSnkMOg/VnEw2kfqAHmOOIAaWVuRLT32Qw6IYiJ
 hZdsA2fmS/Nh0sb7Qq2XePYBiahHtjRWlwPVfVPpRuMkI5h/jR3eEWQPVLKT7NXhdDN5
 /Prwe+seiZgv3yxQkL1Z/z2uyqBh/r3hf6BGZRX1yefjxVoLwMCay5H00O323w9tJBmD
 2r2NP4bOQQRib1/OIdfSeBK4mi584SPx4tQhxROI5j7x3D9MJ9zUPuxVy1M2IdJUuklz 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpn3sjwpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:09:04 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23QK8pPg036882;
        Tue, 26 Apr 2022 20:09:04 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpn3sjwp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:09:04 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QK8NEI030353;
        Tue, 26 Apr 2022 20:09:03 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 3fm93a59dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:09:03 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QK92ZA46530882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 20:09:02 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00CC1B2068;
        Tue, 26 Apr 2022 20:09:02 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 758C8B205F;
        Tue, 26 Apr 2022 20:08:56 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.73.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 20:08:56 +0000 (GMT)
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
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v6 02/21] s390/sclp: detect the AISII facility
Date:   Tue, 26 Apr 2022 16:08:23 -0400
Message-Id: <20220426200842.98655-3-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220426200842.98655-1-mjrosato@linux.ibm.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wJUD9Oo58P-doFB1PH-zvI9fnSV3k4ky
X-Proofpoint-GUID: noDyfbuuB1T244xWNEQGpTAY1Se5oVBE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_06,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 mlxlogscore=773 clxscore=1015
 phishscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Detect the Adapter Interruption Source ID Interpretation facility.

Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/sclp.h   | 1 +
 drivers/s390/char/sclp_early.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index 06c0b5eb8ef5..be14644fe113 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -88,6 +88,7 @@ struct sclp_info {
 	unsigned char has_sipl : 1;
 	unsigned char has_dirq : 1;
 	unsigned char has_zpci_lsi : 1;
+	unsigned char has_aisii : 1;
 	unsigned int ibc;
 	unsigned int mtid;
 	unsigned int mtid_cp;
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index b88dd0da1231..29fee179e197 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -45,6 +45,7 @@ static void __init sclp_early_facilities_detect(void)
 	sclp.has_gisaf = !!(sccb->fac118 & 0x08);
 	sclp.has_hvs = !!(sccb->fac119 & 0x80);
 	sclp.has_kss = !!(sccb->fac98 & 0x01);
+	sclp.has_aisii = !!(sccb->fac118 & 0x40);
 	sclp.has_zpci_lsi = !!(sccb->fac118 & 0x01);
 	if (sccb->fac85 & 0x02)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
-- 
2.27.0

