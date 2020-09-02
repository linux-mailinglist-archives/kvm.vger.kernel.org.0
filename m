Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F056225B4B8
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 21:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIBTrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 15:47:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64852 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbgIBTq7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Sep 2020 15:46:59 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082JcWUp140331;
        Wed, 2 Sep 2020 15:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=8/C8JQ3wK5JYnjDHq/mtYiEA53PNcTVmNBtBJewdsaA=;
 b=ZgvexCUhDobDdKuX1e1Pl1rTte9uWkNrSMLeH3IdmCERNWlSr3J4ouKWx6zzNMBQ4qoJ
 8E0SIwo55SJgqS/qM+iWolNs8EVjU3B1aIZ3OTRMM8HpqBIc+eZQkTC/Cn1JJrDmn8a6
 F8peUobEJ3++dMCUY49ANvmOd6e9THLk7dd34d7POROxWt/pqEEjIVaEsJQoCtHvP0FM
 Z5m03mB3k5LlcZ9aVrQYsVuKjiIRMgvfxLtq28hRroHscK7XganHXYYYpX4M6+DdxqXJ
 hCU/Wtgb/MolVY7qC8ZfINkFUM0uU1N5MLCd+hnAgbrXBDDx6nOqoQMC3ygayOZhoee2 XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33agm4syr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 15:46:53 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 082Jct4e141352;
        Wed, 2 Sep 2020 15:46:52 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33agm4syqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 15:46:52 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 082JfMAB012026;
        Wed, 2 Sep 2020 19:46:51 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 337en9aek1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 19:46:51 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 082JkoJX54722922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Sep 2020 19:46:51 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D914F28058;
        Wed,  2 Sep 2020 19:46:50 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDDC928064;
        Wed,  2 Sep 2020 19:46:48 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.10.164])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Sep 2020 19:46:48 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v4 3/3] vfio/pci: Decouple MSE bit checks from is_virtfn
Date:   Wed,  2 Sep 2020 15:46:36 -0400
Message-Id: <1599075996-9826-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1599075996-9826-1-git-send-email-mjrosato@linux.ibm.com>
References: <1599075996-9826-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_14:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While it is true that devices with is_virtfn=1 will have an
MSE that is hard-wired to 0, this is not the only case where
we see this behavior -- For example some bare-metal hypervisors
lack MSE bit emulation for devices not setting is_virtfn (s390).
Fix this by instead checking for the newly-added
PCI_DEV_FLAGS_FORCE_COMMAND_MEM flag which directly denotes the
need for MSE bit emulation in vfio.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index d98843f..47fb3c7 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -406,7 +406,8 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
 	 * PF SR-IOV capability, there's therefore no need to trigger
 	 * faults based on the virtual value.
 	 */
-	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
+	return (pdev->dev_flags & PCI_DEV_FLAGS_FORCE_COMMAND_MEM) ||
+	       (cmd & PCI_COMMAND_MEMORY);
 }
 
 /*
@@ -520,8 +521,9 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
 
 	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
 
-	/* Mask in virtual memory enable for SR-IOV devices */
-	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
+	/* Mask in virtual memory enable */
+	if ((offset == PCI_COMMAND) &&
+	    (vdev->pdev->dev_flags & PCI_DEV_FLAGS_FORCE_COMMAND_MEM)) {
 		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 		u32 tmp_val = le32_to_cpu(*val);
 
@@ -589,9 +591,11 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 		 * shows it disabled (phys_mem/io, then the device has
 		 * undergone some kind of backdoor reset and needs to be
 		 * restored before we allow it to enable the bars.
-		 * SR-IOV devices will trigger this, but we catch them later
+		 * SR-IOV devices will trigger this - for mem enable let's
+		 * catch this now and for io enable it will be caught later
 		 */
-		if ((new_mem && virt_mem && !phys_mem) ||
+		if ((new_mem && virt_mem && !phys_mem &&
+		    !(pdev->dev_flags & PCI_DEV_FLAGS_FORCE_COMMAND_MEM)) ||
 		    (new_io && virt_io && !phys_io) ||
 		    vfio_need_bar_restore(vdev))
 			vfio_bar_restore(vdev);
@@ -1734,9 +1738,11 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 				 vconfig[PCI_INTERRUPT_PIN]);
 
 		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
-
+	}
+	if (pdev->dev_flags & PCI_DEV_FLAGS_FORCE_COMMAND_MEM) {
 		/*
-		 * VFs do no implement the memory enable bit of the COMMAND
+		 * VFs and devices that set PCI_DEV_FLAGS_FORCE_COMMAND_MEM
+		 * do not implement the memory enable bit of the COMMAND
 		 * register therefore we'll not have it set in our initial
 		 * copy of config space after pci_enable_device().  For
 		 * consistency with PFs, set the virtual enable bit here.
-- 
1.8.3.1

