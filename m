Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E576846C56E
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241490AbhLGVCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:02:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241394AbhLGVCU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:02:20 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JbnFf034972;
        Tue, 7 Dec 2021 20:58:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DRKsT+dJXXlPXD1cJnAO3svioed7eIs46dnHC18dONo=;
 b=SI4Axr50sr6Ly9cronyw9LHUgH1QledmWC0vmaUiXMCZpY4wVUTZaGC59ggG/ug1T+hq
 mN6JKbBS82RliJeL1GrZZ+IeuJIXbDneC2vEA3sNARu/PoeT/L3jgyHnA590OTw7wOk+
 jYl9t0izXkHD7XCY4bi1CFl6VxHHMY9vkJIiZqru8YuyoPDDr8cilMm3N/ynOUxvMXvQ
 2IIQQbOKbA69TBfQF7++KVC7pGAGI0pKsN5NFPqEgeQwSciyee+o6t1rH/WSTNGOsv+b
 P83CRc6aJUaz3CUqyJSAty1EMTcHumpkxp/q8dZRbpsONzcekPvL1cll+rvjPOPCl1OS 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cta7cxu7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:49 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KaWdu020360;
        Tue, 7 Dec 2021 20:58:48 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cta7cxu74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:48 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvsC6010215;
        Tue, 7 Dec 2021 20:58:47 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 3cqyyamjpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:58:47 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KwkY022414206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:58:46 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36ABAAE05F;
        Tue,  7 Dec 2021 20:58:46 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16D6CAE063;
        Tue,  7 Dec 2021 20:58:41 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:58:40 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/32] s390/pci: stash dtsm and maxstbl
Date:   Tue,  7 Dec 2021 15:57:21 -0500
Message-Id: <20211207205743.150299-11-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _Jf-k70iFTjnqZJAuvUFrBjW8zhz_Tb-
X-Proofpoint-ORIG-GUID: r3XExSgwO5oZBlNLdr3hzKo-Dhkazr6V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store information about what IOAT designation types are supported by
underlying hardware as well as the largest store block size allowed.
These values will be needed by passthrough.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     | 2 ++
 arch/s390/include/asm/pci_clp.h | 6 ++++--
 arch/s390/pci/pci_clp.c         | 2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 2474b8d30f2a..1a8f9f42da3a 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -126,9 +126,11 @@ struct zpci_dev {
 	u32		gd;		/* GISA designation for passthrough */
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
index 3af8d196da74..124fadfb74b9 100644
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
index e9ed0e4a5cf0..bc7446566cbc 100644
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

