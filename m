Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8344553EFAB
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiFFUee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiFFUeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:34:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A75986E0;
        Mon,  6 Jun 2022 13:34:02 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KTvsK015927;
        Mon, 6 Jun 2022 20:34:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=l3q7QDLLlfLjR6xuTRQwCj+/8sIkeoMWSCpC2Npxn+0=;
 b=hQv2InRW8nkTR6lz25Kn9HD8oI/NfyxaIu95KaVaso0juq8D2o6CXj7ax8MOHF1LPzsb
 SUVwsktfodKwI7IOBXAV2RtvHTIT1/p+dS9yYniJVjsoEEvhETpBNBi4GC9Hf6FYEC2H
 hpbljDuEWCR4xlq0WJCTHrtYbKsmmnYXjKtTEgRRtRqLHBwGUCT1S4ZTcX0DgJw+5WyW
 sR35CLmoD6/A3ur/MOFjPunIlr7HOWY5LwA3fPc5nji353lW7fEs09HQ9Jw9vp1hrByq
 ige5Cy2Hrm8gIptjGJ53iPhZQhd3r3Xcm0DuqPbf81yyvEwTwj26g9qAAACeTai75KGa ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghr0u0s11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:34:00 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KY02e009793;
        Mon, 6 Jun 2022 20:34:00 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghr0u0s0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:34:00 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KKxVx016379;
        Mon, 6 Jun 2022 20:33:59 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 3gfy19ut94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:33:59 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KXwYp10355100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:33:58 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3594928059;
        Mon,  6 Jun 2022 20:33:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FDC228058;
        Mon,  6 Jun 2022 20:33:51 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.20.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:33:51 +0000 (GMT)
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
Subject: [PATCH v9 03/21] s390/sclp: detect the AENI facility
Date:   Mon,  6 Jun 2022 16:33:07 -0400
Message-Id: <20220606203325.110625-4-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220606203325.110625-1-mjrosato@linux.ibm.com>
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Sx-Mg_nXOTh2-1o9LKK1bjnWzr-xbAUV
X-Proofpoint-ORIG-GUID: zcK-fjuZYieVcHfJNAFWxvueIWQ_-PoZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=857 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206060081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Detect the Adapter Event Notification Interpretation facility.

Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/sclp.h   | 1 +
 drivers/s390/char/sclp_early.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index d05fbffa7692..b0e67414c492 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -90,6 +90,7 @@ struct sclp_info {
 	unsigned char has_iplcc : 1;
 	unsigned char has_zpci_lsi : 1;
 	unsigned char has_aisii : 1;
+	unsigned char has_aeni : 1;
 	unsigned int ibc;
 	unsigned int mtid;
 	unsigned int mtid_cp;
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index 39c9bd7e1c26..aefdf0b17dbe 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -46,6 +46,7 @@ static void __init sclp_early_facilities_detect(void)
 	sclp.has_hvs = !!(sccb->fac119 & 0x80);
 	sclp.has_kss = !!(sccb->fac98 & 0x01);
 	sclp.has_aisii = !!(sccb->fac118 & 0x40);
+	sclp.has_aeni = !!(sccb->fac118 & 0x20);
 	sclp.has_zpci_lsi = !!(sccb->fac118 & 0x01);
 	if (sccb->fac85 & 0x02)
 		S390_lowcore.machine_flags |= MACHINE_FLAG_ESOP;
-- 
2.27.0

