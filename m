Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB322FC091
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 21:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbhASUD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 15:03:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730011AbhASUDZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 15:03:25 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JJqFAR140713;
        Tue, 19 Jan 2021 15:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=0u9A1QuSjmbJ/rAaQOhcdu29Aoy0Lx70TAbNYINn/vc=;
 b=HxAEHm0+pcIGLUcfmvqC1ocr8s9HeQ0oDrxj22soqEKJkx0V0jSSTCP3Fal3fCzToFpW
 CJPFDi46anjZG7hpH3ZNoRJz+6bXyiXXEyve3fm6gziV+ArH+FMx9lC+9TnlN8dCOgYg
 OXsFPM6QqZNn2BzNho74zr37158Zw/LwYxFwDA6JrrwWYliuNPZhp8brgRD/ZcdDBEZX
 6sOpAku7UYHdBkkT11LRO1XXmpqgivYGF1E/kZlJIsmUjYwUEU5BogZC82+/MjL2PsJm
 XMUMkbouJU5J/z2xT1NqCnEJfnjwInytlt9G4CiTOEOi4SEI+JZRItgtbQXZ4KJ4ATCk fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3665y307qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:02:45 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JJsaCD147680;
        Tue, 19 Jan 2021 15:02:45 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3665y307qd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:02:44 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JJpV1K030023;
        Tue, 19 Jan 2021 20:02:43 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 363qs90pe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 20:02:43 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JK2g5G30146978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 20:02:42 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23C8DAC060;
        Tue, 19 Jan 2021 20:02:42 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26AB3AC059;
        Tue, 19 Jan 2021 20:02:40 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.56.144])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 20:02:39 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] s390/pci: Get hardware-reported max store block length
Date:   Tue, 19 Jan 2021 15:02:29 -0500
Message-Id: <1611086550-32765-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_09:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190106
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

