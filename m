Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9034AA1CA
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241199AbiBDVQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:16:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241566AbiBDVQI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:08 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214KcQiw016182;
        Fri, 4 Feb 2022 21:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DX9MZNZ18y3gzoPge8ogZkIpv/kD4afpB3w01BFLXBA=;
 b=fgf0tUyFPvMQ6ju8pFp1QquFTDoc/e3ImUvLM2x4hRznYDUJvIKFqgktKjHRNKr60fMN
 kh/whfgVajX0tHpD0ituNwmbAppCTb9Hh0SQLATbnIy9qxZRWjbmd3WiRNzRwS2qLzW9
 GxQEtWyWjOWJG0S6nRHvZ+tqYYh7mJHv24XK3/rczaUJHFDUIX1Zy8Qr/YXFV3U8zNUt
 uBe7aj7vqSkglyzMmfnrqfw7z8py/2QCHWJiOe9wikYWfwcVsnerqupFsIRvD1mZg5Bb
 GX/USmlEmtGC2UJ6gH32VkAo+miQeopPsHgreUV6ScSraTbaFsks4q9vpHjOWuwleDRe 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt5nmrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:07 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214KkdD1000672;
        Fri, 4 Feb 2022 21:16:07 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt5nmr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:07 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LDNI0003458;
        Fri, 4 Feb 2022 21:16:06 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01wdc.us.ibm.com with ESMTP id 3e0r0xtu27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:06 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LG3ZS22217156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:03 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B424C136060;
        Fri,  4 Feb 2022 21:16:03 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7993136063;
        Fri,  4 Feb 2022 21:16:01 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:01 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v3 10/30] s390/pci: stash dtsm and maxstbl
Date:   Fri,  4 Feb 2022 16:15:16 -0500
Message-Id: <20220204211536.321475-11-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XqYoI8sfqXvYYnHkBX5YH7fe3YviZrNm
X-Proofpoint-ORIG-GUID: sXaseCocX9kiWyEPGPG7nfrjfmRMJqPQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store information about what IOAT designation types are supported by
underlying hardware as well as the largest store block size allowed.
These values will be needed by passthrough.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     | 2 ++
 arch/s390/include/asm/pci_clp.h | 6 ++++--
 arch/s390/pci/pci_clp.c         | 2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index d07d7c3205de..7ee52a70a96f 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -126,9 +126,11 @@ struct zpci_dev {
 	u32		gisa;		/* GISA designation for passthrough */
 	u16		vfn;		/* virtual function number */
 	u16		pchid;		/* physical channel ID */
+	u16		maxstbl;	/* Maximum store block size */
 	u8		pfgid;		/* function group ID */
 	u8		pft;		/* pci function type */
 	u8		port;
+	u8		dtsm;		/* Supported DT mask */
 	u8		rid_available	: 1;
 	u8		has_hp_slot	: 1;
 	u8		has_resources	: 1;
diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
index f3286bc5ba6e..d6189ed14f84 100644
--- a/arch/s390/include/asm/pci_clp.h
+++ b/arch/s390/include/asm/pci_clp.h
@@ -153,9 +153,11 @@ struct clp_rsp_query_pci_grp {
 	u8			:  6;
 	u8 frame		:  1;
 	u8 refresh		:  1;	/* TLB refresh mode */
-	u16 reserved2;
+	u16			:  3;
+	u16 maxstbl		: 13;	/* Maximum store block size */
 	u16 mui;
-	u16			: 16;
+	u8 dtsm;			/* Supported DT mask */
+	u8 reserved3;
 	u16 maxfaal;
 	u16			:  4;
 	u16 dnoi		: 12;
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 4dcc37ddeeaf..dc733b58e74f 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -103,6 +103,8 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
 	zdev->max_msi = response->noi;
 	zdev->fmb_update = response->mui;
 	zdev->version = response->version;
+	zdev->maxstbl = response->maxstbl;
+	zdev->dtsm = response->dtsm;
 
 	switch (response->version) {
 	case 1:
-- 
2.27.0

