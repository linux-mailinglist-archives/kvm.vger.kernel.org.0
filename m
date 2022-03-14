Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218F14D8CD8
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244363AbiCNTsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244543AbiCNTsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:48:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7DE3DA71;
        Mon, 14 Mar 2022 12:46:57 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EIkc3q027996;
        Mon, 14 Mar 2022 19:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bOT6AFdx4EkST/f5HbTGjO7sZpaqGqfBPIrrbaCkgVM=;
 b=ZIMvwJTB1Z/oaha7BW7ejqiiPj0DFWLkUle4W9FO3zntbgWUCXRFSRTJtmYtMQYukb0f
 BvIDXlyHgtH4LxgMP4osCFHsB5QiIttAyljocr/QK5If6QKGCXuB0+vhp32yKyREa+mE
 o5uNjafeGWMY3TKZKxzveo2He6ruaMYuIwGAEqtyKPHKJyzHCo6Z19ZfGs4bFRaMstd+
 rf/D7eroHPdBLB2+J0uXM4eVwGdBq7WbLhMB85Vv/NerZZkh1WFkwxMDtDRIhdfGy+WY
 QnTBltbLwFxugqLanUzXYWLMfaFQFVDEuk60vb6a/a6Qc0roqfbbKQ/ccOKzgsLDA8wC kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6mer263-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:46:49 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJkmLe003408;
        Mon, 14 Mar 2022 19:46:48 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6mer25r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:46:48 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJNBln009051;
        Mon, 14 Mar 2022 19:46:47 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02wdc.us.ibm.com with ESMTP id 3erk59g7tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:46:47 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJkjx840763734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:46:45 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58F75112061;
        Mon, 14 Mar 2022 19:46:45 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8F9E112062;
        Mon, 14 Mar 2022 19:46:35 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:46:35 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 10/32] s390/pci: stash dtsm and maxstbl
Date:   Mon, 14 Mar 2022 15:44:29 -0400
Message-Id: <20220314194451.58266-11-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x2-U0vZmpCnG78nt22lKrn5Py_yrZZb-
X-Proofpoint-ORIG-GUID: Q-y6QK80NWtEcyucDj2LeY2jXKxiFGxf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

