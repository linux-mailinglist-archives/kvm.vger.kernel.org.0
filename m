Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5ED526A28
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383733AbiEMTQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383659AbiEMTQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:16:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A70B3917A;
        Fri, 13 May 2022 12:16:16 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DHr12Z016413;
        Fri, 13 May 2022 19:16:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=M74r3Ua+EIq+K9RU4M+8Ajfg0WOUgyyO3dS1VNZKXEw=;
 b=rvyV2oE5EBddauq0mdyf10fNvnqsXY+VBXMqh79vQuGb7xFvyI4pxUjpWuga29MeQYik
 2A4J4zKX/fgGDfv3Pfr3I0TZgpyJKYJ8DVyljpsgFODR+6zYhNK5BpiKvnwteIT4fo8t
 rwK1Hoq8kouQpkEFtyx8EfwIp5/viXfI9KZ7OSM0n/70GvWjyFYSg0JfUvaTNYwSQanM
 4amnJJX4AslZXzSszvtF+UK+eZD2RRv+HeWsoMyid61WafDTdIPWbHyeO/pCGhw+6gsc
 3AjObih0dHfrjqPC5sKDk0IJJ4x1hQMm8vHg9E7l0IphpvW/B2TqMkE+31N8KpTdZmtz rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1qusff1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:12 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DJ6hC5013778;
        Fri, 13 May 2022 19:16:11 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1qusff13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:11 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DJDTlT007648;
        Fri, 13 May 2022 19:16:11 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 3fwgdacery-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:11 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DJGA0S29426036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 19:16:10 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67325124054;
        Fri, 13 May 2022 19:16:10 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 122D3124053;
        Fri, 13 May 2022 19:16:05 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.49.28])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 19:16:04 +0000 (GMT)
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
Subject: [PATCH v7 09/22] s390/pci: stash dtsm and maxstbl
Date:   Fri, 13 May 2022 15:14:56 -0400
Message-Id: <20220513191509.272897-10-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220513191509.272897-1-mjrosato@linux.ibm.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AUb6GjoiRt6C1QVb6HuWZzZG1I6GL9Ed
X-Proofpoint-GUID: uQCDFth-aYShAfBMmmZwc2fsukDD7H6Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_11,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store information about what IOAT designation types are supported by
underlying hardware as well as the largest store block size allowed.
These values will be needed by passthrough.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     | 2 ++
 arch/s390/include/asm/pci_clp.h | 6 ++++--
 arch/s390/pci/pci_clp.c         | 2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 42a4a312a6dd..4c5b8fbc2079 100644
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
index deed35edea14..1edb07ceb766 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -106,6 +106,8 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
 	zdev->max_msi = response->noi;
 	zdev->fmb_update = response->mui;
 	zdev->version = response->version;
+	zdev->maxstbl = response->maxstbl;
+	zdev->dtsm = response->dtsm;
 
 	switch (response->version) {
 	case 1:
-- 
2.27.0

