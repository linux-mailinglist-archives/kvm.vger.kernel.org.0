Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88536242BA2
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 16:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgHLOuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 10:50:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726503AbgHLOuc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Aug 2020 10:50:32 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07CEX1S6118587;
        Wed, 12 Aug 2020 10:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=039f5qc7xIoBm0mLLd+ro4GakzTvU9FxjbxkKBFcWq4=;
 b=teV8h0UsYdgI4HNEedRDJddNbNxikRFFtFF1M5i2xyRxVt6mEvLDz9Q/YvHi72wCefM4
 zqVl+phDonHFY2H2vYMLaqiJ3sC8lXXi+ZwMTZOQbib64TntlGcvpPgVtA/kNsrREz8Z
 PBM/wM5IQm4t9QOLUb/FOqPwbha3meQQOElTsmdH5BXNA6EXuqjXc/Gg+1v0y6AI5DAR
 XkC3eTio3DiVpvnZBFEFZbrBlkUo/oDsDLuKmg3bRgYnck08eiFhAxfDFzn7LL4uDMQZ
 orBbQM5OPzuCLmnAGAdTc5fTvHytyN+f9mEjgwhmAYU6T0X/V6+Bq4593f4/Sif6NK97 WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32utn91asb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 10:50:30 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07CEX9pq119294;
        Wed, 12 Aug 2020 10:50:29 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32utn91arj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 10:50:29 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07CEjJVg011139;
        Wed, 12 Aug 2020 14:50:28 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 32skp9awwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Aug 2020 14:50:28 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07CEoR6K42795350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 14:50:27 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B978228058;
        Wed, 12 Aug 2020 14:50:27 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4723828064;
        Wed, 12 Aug 2020 14:50:25 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.7.238])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 12 Aug 2020 14:50:24 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH] PCI: Introduce flag for detached virtual functions
Date:   Wed, 12 Aug 2020 10:50:17 -0400
Message-Id: <1597243817-3468-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1597243817-3468-1-git-send-email-mjrosato@linux.ibm.com>
References: <1597243817-3468-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_06:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390x has the notion of providing VFs to the kernel in a manner
where the associated PF is inaccessible other than via firmware.
These are not treated as typical VFs and access to them is emulated
by underlying firmware which can still access the PF.  After
abafbc55 however these detached VFs were no longer able to work
with vfio-pci as the firmware does not provide emulation of the
PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
these detached VFs so that vfio-pci can allow memory access to
them again.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/pci/pci.c                | 8 ++++++++
 drivers/vfio/pci/vfio_pci_config.c | 3 ++-
 include/linux/pci.h                | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 3902c9f..04ac76d 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
 {
 	struct zpci_dev *zdev = to_zpci(pdev);
 
+	/*
+	 * If we have a VF on a non-multifunction bus, it must be a VF that is
+	 * detached from its parent PF.  We rely on firmware emulation to
+	 * provide underlying PF details.
+	 */
+	if (zdev->vfn && !zdev->zbus->multifunction)
+		pdev->detached_vf = 1;
+
 	zpci_debug_init_device(zdev, dev_name(&pdev->dev));
 	zpci_fmb_enable_device(zdev);
 
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index d98843f..17845fc 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -406,7 +406,8 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
 	 * PF SR-IOV capability, there's therefore no need to trigger
 	 * faults based on the virtual value.
 	 */
-	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
+	return pdev->is_virtfn || pdev->detached_vf ||
+	       (cmd & PCI_COMMAND_MEMORY);
 }
 
 /*
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8355306..23a6972 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -445,6 +445,7 @@ struct pci_dev {
 	unsigned int	is_probed:1;		/* Device probing in progress */
 	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
 	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
+	unsigned int	detached_vf:1;		/* VF without local PF access */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
-- 
1.8.3.1

