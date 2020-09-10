Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA426501A
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 22:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIJUDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 16:03:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730839AbgIJPAo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 11:00:44 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AEoV17193541;
        Thu, 10 Sep 2020 11:00:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jqNGQIciDmR7JgvUza3J1lCUoceHki+R182Zm5QX6MA=;
 b=YGQerkI2TvXvCw1fpi9YBvNSSA4Pk34gdLImR//e7JVdlMsCESG0qNoGG/Lb4ccHwbqV
 17B0WPHU9P+ZUqjJJ18fH47QWT59WuD6D516SpTdLmNk7PGljvva/VMOHHoanfxd5Dgv
 n52y4hHBXZSmM5/7vI7lu2fOKbFT6rArCUCInuUr6I/9gThG1owBneqiJNtGqczkohXE
 9G2rVw4Bf1M5m5uTvtxMupLD4v72LenTwp7yNhavEZMeumaI+HmxdsEnit6bwX4nn0Co
 zV30YEhM0mzmRZIvI8XmRZGnA92m2K1lvKKSB3oIxYSfj9+15uQgNaIuGHK6AkEsDVAJ gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fp8wg7w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 11:00:10 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AEp9mm195235;
        Thu, 10 Sep 2020 11:00:09 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33fp8wg7vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 11:00:09 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AEqaYY018164;
        Thu, 10 Sep 2020 15:00:08 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 33c2a9t8h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 15:00:08 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AF02jo30802286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 15:00:02 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41B1178069;
        Thu, 10 Sep 2020 15:00:07 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED40778063;
        Thu, 10 Sep 2020 15:00:05 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.91.207])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 15:00:05 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v5 3/3] vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks from is_virtfn
Date:   Thu, 10 Sep 2020 10:59:57 -0400
Message-Id: <1599749997-30489-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1599749997-30489-1-git-send-email-mjrosato@linux.ibm.com>
References: <1599749997-30489-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_03:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While it is true that devices with is_virtfn=1 will have a Memory Space
Enable bit that is hard-wired to 0, this is not the only case where we
see this behavior -- For example some bare-metal hypervisors lack
Memory Space Enable bit emulation for devices not setting is_virtfn
(s390). Fix this by instead checking for the newly-added
no_command_memory bit which directly denotes the need for
PCI_COMMAND_MEMORY emulation in vfio.

Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index d98843f..5076d01 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -406,7 +406,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
 	 * PF SR-IOV capability, there's therefore no need to trigger
 	 * faults based on the virtual value.
 	 */
-	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
+	return pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY);
 }
 
 /*
@@ -520,8 +520,8 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
 
 	count = vfio_default_config_read(vdev, pos, count, perm, offset, val);
 
-	/* Mask in virtual memory enable for SR-IOV devices */
-	if (offset == PCI_COMMAND && vdev->pdev->is_virtfn) {
+	/* Mask in virtual memory enable */
+	if (offset == PCI_COMMAND && vdev->pdev->no_command_memory) {
 		u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 		u32 tmp_val = le32_to_cpu(*val);
 
@@ -589,9 +589,11 @@ static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
 		 * shows it disabled (phys_mem/io, then the device has
 		 * undergone some kind of backdoor reset and needs to be
 		 * restored before we allow it to enable the bars.
-		 * SR-IOV devices will trigger this, but we catch them later
+		 * SR-IOV devices will trigger this - for mem enable let's
+		 * catch this now and for io enable it will be caught later
 		 */
-		if ((new_mem && virt_mem && !phys_mem) ||
+		if ((new_mem && virt_mem && !phys_mem &&
+		     !pdev->no_command_memory) ||
 		    (new_io && virt_io && !phys_io) ||
 		    vfio_need_bar_restore(vdev))
 			vfio_bar_restore(vdev);
@@ -1734,12 +1736,14 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 				 vconfig[PCI_INTERRUPT_PIN]);
 
 		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
-
+	}
+	if (pdev->no_command_memory) {
 		/*
-		 * VFs do no implement the memory enable bit of the COMMAND
-		 * register therefore we'll not have it set in our initial
-		 * copy of config space after pci_enable_device().  For
-		 * consistency with PFs, set the virtual enable bit here.
+		 * VFs and devices that set pdev->no_command_memory do not
+		 * implement the memory enable bit of the COMMAND register
+		 * therefore we'll not have it set in our initial copy of
+		 * config space after pci_enable_device().  For consistency
+		 * with PFs, set the virtual enable bit here.
 		 */
 		*(__le16 *)&vconfig[PCI_COMMAND] |=
 					cpu_to_le16(PCI_COMMAND_MEMORY);
-- 
1.8.3.1

