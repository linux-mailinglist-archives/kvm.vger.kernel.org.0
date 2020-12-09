Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97D82D4BDA
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 21:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388570AbgLIUaT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:30:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387663AbgLIU36 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 15:29:58 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9KCmPm171107;
        Wed, 9 Dec 2020 15:29:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Ll19ePRbwoEsUoHXPbtitX6SHMdAUB9AHe5X2OcjHU8=;
 b=J1419j+jfIh9qofTLjUfl/UKmjhRo27Sq/elTRn0Z0SjmZ7pb6ATHmubxTIr5+OYrvQt
 prn8a+u0CmhFvXfhI7++SYJVPlE0NEs6n+pvNzcPqysGQ6kXym2lJ6AY1n5wHO0OcO3d
 vFXSmvwmU6vFtC0oc+M7PP1tm73ASW9zta5YR6QBnp25kwhFn9onp0QPyF4sLAmyI23o
 yKjjQjpODm2QXfnqx73YDeJtt7qJJhimEcJZvx9gYETH2Rv+QQ0F70fXsf6WBtoH42Rq
 kvZ2rGP54/4HT9G6m6dfivQBSxoN3yr6jfTaCaO12C2a6iXwGOF7KSxw4y36rgKYGlcH lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35avp1pys3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:29:17 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9KLIMd007118;
        Wed, 9 Dec 2020 15:29:17 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35avp1pyrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:29:17 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9KMAL7015879;
        Wed, 9 Dec 2020 20:29:16 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3581u9gdy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 20:29:16 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9KRxWU29884698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 20:27:59 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CE64B2068;
        Wed,  9 Dec 2020 20:27:59 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE889B2066;
        Wed,  9 Dec 2020 20:27:56 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.37.122])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 20:27:56 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/4] s390/pci: track alignment/length strictness for zpci_dev
Date:   Wed,  9 Dec 2020 15:27:47 -0500
Message-Id: <1607545670-1557-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_16:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090140
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

