Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2F270EF4
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 17:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgISP2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Sep 2020 11:28:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39920 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbgISP2s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 19 Sep 2020 11:28:48 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08JF2WE9189365;
        Sat, 19 Sep 2020 11:28:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Zlwp6w1I0aP10xjqqHZZM9lxlCxlhdIk2wX+FJwZSd0=;
 b=b6BjJfuLY5Gy3xmnfFV+a0+ZSB3DhZIQZmwi7FVfXtyqFxY7INFCegcy5WfQlSJxWwFP
 0VSTcTB8VG47YrKjxm4yzXERedPaAjGG7WbBivLDNafzGM8gJgQgppRjtLHIEQ7zkCHN
 0+ow9BYgQIb04SsFFS6tsxVqNgQF1oJswWCZA31SO5m8I88tLjrCMfL9k8Sh4osAmhYv
 M4zZtGnw2AWiuOwTKPk/TC/BkNbBod/zx49T1Xn52lj3MY79H8UP3V7OSroSdmyX7JXz
 2kLshOBOZzM53yupsryAdWJF1qmWYwuM2Wbr5+ir23LT4KobKauSi8HNOzl3AneNtw46 TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33nkqdh0sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:28:47 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08JF5YbG000606;
        Sat, 19 Sep 2020 11:28:47 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33nkqdh0s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:28:47 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08JFQYY6019127;
        Sat, 19 Sep 2020 15:28:46 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 33n9m8b6sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 15:28:46 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08JFSdxn28705310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Sep 2020 15:28:39 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F6CDBE051;
        Sat, 19 Sep 2020 15:28:43 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA1D2BE04F;
        Sat, 19 Sep 2020 15:28:41 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.74.107])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 19 Sep 2020 15:28:41 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] s390/pci: stash version in the zpci_dev
Date:   Sat, 19 Sep 2020 11:28:35 -0400
Message-Id: <1600529318-8996-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-19_05:2020-09-16,2020-09-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009190131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for passing the info on to vfio-pci devices, stash the
supported PCI version for the target device in the zpci_dev.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h | 1 +
 arch/s390/pci/pci_clp.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 99b92c3..882e233 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -179,6 +179,7 @@ struct zpci_dev {
 	atomic64_t mapped_pages;
 	atomic64_t unmapped_pages;
 
+	u8		version;
 	enum pci_bus_speed max_bus_speed;
 
 	struct dentry	*debugfs_dev;
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 7e735f4..48bf316 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -102,6 +102,7 @@ static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
 	zdev->msi_addr = response->msia;
 	zdev->max_msi = response->noi;
 	zdev->fmb_update = response->mui;
+	zdev->version = response->version;
 
 	switch (response->version) {
 	case 1:
-- 
1.8.3.1

