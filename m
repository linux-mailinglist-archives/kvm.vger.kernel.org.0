Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D962D4BDF
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 21:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388497AbgLIU3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:29:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388480AbgLIU2t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 15:28:49 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9KBsar179225;
        Wed, 9 Dec 2020 15:28:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=0u9A1QuSjmbJ/rAaQOhcdu29Aoy0Lx70TAbNYINn/vc=;
 b=dSI5+1J2e7lMJBti3Y5U6i3/Iu8kZucyZ/zrGtITPFVLVAHT7g6Xs6XtHDwB0F8P/Dsj
 lKGdocBPMu/GDSBpADOSk1yNA5Ix1h6G03KXrCkOL8whNzR1YNjeZ6n/EIc6ZlCepENU
 DzXSxLom8aK/cVUMraRp9ILnbKKGiWeExDqwBYnU8PT2W6rS9r5rUFHSE6LI+RMuI6x6
 9kFwCmN3286LtLPfEFTpcEtEwn18ociJHRuvmgKf8vSzehPv1A48mOKeadk2ABvBillo
 qxwYYKCB8snKOTLcO6QkjBlYVmU5xs/jckZWF8EisysCNAplgsDykq3KleFipwI3nCqU og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35b5b9ge9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:28:07 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9KCCHP180949;
        Wed, 9 Dec 2020 15:28:07 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35b5b9ge9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:28:07 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9KM99t015871;
        Wed, 9 Dec 2020 20:28:05 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 3581u9gdsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 20:28:05 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9KS4Ti32834132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 20:28:04 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B487B206B;
        Wed,  9 Dec 2020 20:28:04 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2691EB2065;
        Wed,  9 Dec 2020 20:28:02 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.37.122])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 20:28:02 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 3/4] s390/pci: Get hardware-reported max store block length
Date:   Wed,  9 Dec 2020 15:27:49 -0500
Message-Id: <1607545670-1557-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_16:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090137
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We'll need to know this information for vfio passthrough.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/include/asm/pci.h     | 1 +
 arch/s390/include/asm/pci_clp.h | 3 ++-
 arch/s390/pci/pci_clp.c         | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index f16ffba..04f1f48 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -181,6 +181,7 @@ struct zpci_dev {
 	atomic64_t mapped_pages;
 	atomic64_t unmapped_pages;
 
+	u16		maxstbl;
 	u8		version;
 	enum pci_bus_speed max_bus_speed;
 
diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
index 9fb7cbf..ddd1604 100644
--- a/arch/s390/include/asm/pci_clp.h
+++ b/arch/s390/include/asm/pci_clp.h
@@ -155,7 +155,8 @@ struct clp_rsp_query_pci_grp {
 	u8			:  1;
 	u8 frame		:  1;
 	u8 refresh		:  1;	/* TLB refresh mode */
-	u16 reserved2;
+	u16			:  3;
+	u16 maxstbl		: 13;
 	u16 mui;
 	u16			: 16;
 	u16 maxfaal;
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 630f8fc..99b64fe 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -104,6 +104,7 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
 	zdev->fmb_update = response->mui;
 	zdev->version = response->version;
 	zdev->relaxed_align = response->relaxed_align;
+	zdev->maxstbl = response->maxstbl;
 
 	switch (response->version) {
 	case 1:
-- 
1.8.3.1

