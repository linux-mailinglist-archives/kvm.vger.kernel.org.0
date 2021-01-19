Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725C02FC097
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 21:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbhASUHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 15:07:30 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52826 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728613AbhASUDW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 15:03:22 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JK2WFA177644;
        Tue, 19 Jan 2021 15:02:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Ll19ePRbwoEsUoHXPbtitX6SHMdAUB9AHe5X2OcjHU8=;
 b=ohL4nccilAUlyQ016hVzZFb16hXWwJmdELJEsFv/ZMNGmOd5J60ao+MAidVdzXvTY2DW
 6eipx2VcitJQcgNXp55TrzcAH+6w+/zMEVFUcHT95iwRgbWTTfXI2hLeVtishY4+ACB0
 g/6So5+dYgvW4Av+3IVUne+Tw7fWBOX6jk2Y2U0XAd7qqaGv1duwePk5qUHxNL+s4Khk
 GSltmzZhkiy/mHjeGzikmRcYEzwtPt2+DKYsGDh5J03Pndk/PbpKeY/naafpfT0aZcgM
 o3+MyLoObbBAbRKpp7KtXRO/1tfuhWW594iBF3f5BWvNnFzY3wPlmF9QJcBmJEeMNGFH uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366607g5tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:02:40 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JK2aeN178104;
        Tue, 19 Jan 2021 15:02:39 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 366607g5tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:02:39 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JK2U4X025577;
        Tue, 19 Jan 2021 20:02:39 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 363qs90q6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 20:02:39 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JK2b9630933286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 20:02:37 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7783EAC05B;
        Tue, 19 Jan 2021 20:02:37 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87A93AC059;
        Tue, 19 Jan 2021 20:02:35 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.56.144])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 20:02:35 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] s390/pci: track alignment/length strictness for zpci_dev
Date:   Tue, 19 Jan 2021 15:02:27 -0500
Message-Id: <1611086550-32765-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_09:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0 impostorscore=0
 spamscore=0 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some zpci device types (e.g., ISM) follow different rules for length
and alignment of pci instructions.  Recognize this and keep track of
it in the zpci_dev.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     | 3 ++-
 arch/s390/include/asm/pci_clp.h | 4 +++-
 arch/s390/pci/pci_clp.c         | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 2126289..f16ffba 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -133,7 +133,8 @@ struct zpci_dev {
 	u8		has_hp_slot	: 1;
 	u8		is_physfn	: 1;
 	u8		util_str_avail	: 1;
-	u8		reserved	: 4;
+	u8		relaxed_align	: 1;
+	u8		reserved	: 3;
 	unsigned int	devfn;		/* DEVFN part of the RID*/
 
 	struct mutex lock;
diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
index 1f4b666..9fb7cbf 100644
--- a/arch/s390/include/asm/pci_clp.h
+++ b/arch/s390/include/asm/pci_clp.h
@@ -150,7 +150,9 @@ struct clp_rsp_query_pci_grp {
 	u16			:  4;
 	u16 noi			: 12;	/* number of interrupts */
 	u8 version;
-	u8			:  6;
+	u8			:  4;
+	u8 relaxed_align	:  1;	/* Relax length and alignment rules */
+	u8			:  1;
 	u8 frame		:  1;
 	u8 refresh		:  1;	/* TLB refresh mode */
 	u16 reserved2;
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 153720d..630f8fc 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -103,6 +103,7 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
 	zdev->max_msi = response->noi;
 	zdev->fmb_update = response->mui;
 	zdev->version = response->version;
+	zdev->relaxed_align = response->relaxed_align;
 
 	switch (response->version) {
 	case 1:
-- 
1.8.3.1

