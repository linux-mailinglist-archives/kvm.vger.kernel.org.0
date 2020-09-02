Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E3725B4B7
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 21:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgIBTrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 15:47:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52476 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726559AbgIBTq5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Sep 2020 15:46:57 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082JcYob065379;
        Wed, 2 Sep 2020 15:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=3j4XZDz4uoaxmgyG0wlR62Vxy62lEGp1UQSVgMxOxgw=;
 b=cS6v6/KWIdkwMmgM++lfCSAe3DSUrwzW+a2yUmp3A64nbLMdPG4qtHI43Fn30/8d6yVk
 KtXtThwcoaaCcH4Gqis1WcLKGngqy+cwoScb72n/CskDH3T0YQ64e//tYSvCMXcmSpwt
 bAVQ2Aeiqw7eWXOyu2b93Zd+tS2+uEz6Q1u9syEShCwtCWA/OnVZSg4ey4xmnawi4E4S
 4XQkK9vIca+E2wVZUvtWSsooMnQ+XmVJtWl1MYvYMtEgQkBIBY3cL3tEYgm6KVJczmsY
 Bi4png/VRC4E9DKQoaRUKMpAUVH8Mhikx9MCSiMcQ/UHAGs5t+Cse9wh0sR8CvMmY3+0 Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33afmakydu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 15:46:50 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 082JcfgV066038;
        Wed, 2 Sep 2020 15:46:49 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33afmakyd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 15:46:49 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 082JfQhd030151;
        Wed, 2 Sep 2020 19:46:48 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 337en9tc0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Sep 2020 19:46:48 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 082JkmNn40567108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Sep 2020 19:46:48 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B5142805A;
        Wed,  2 Sep 2020 19:46:48 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C48AF28059;
        Wed,  2 Sep 2020 19:46:45 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.10.164])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Sep 2020 19:46:45 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v4 2/3] s390/pci: Mark all VFs as not implementing MSE bit
Date:   Wed,  2 Sep 2020 15:46:35 -0400
Message-Id: <1599075996-9826-3-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1599075996-9826-1-git-send-email-mjrosato@linux.ibm.com>
References: <1599075996-9826-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_14:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 impostorscore=0 mlxlogscore=756
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For s390 we can have VFs that are passed-through without
the associated PF.  Firmware provides an emulation layer
to allow these devices to operate independently, but is
missing emulation of the MSE bit.  For these as well as
linked VFs, mark a dev_flags bit that specifies these
devices do not implement the MSE bit.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/pci/pci_bus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
index 5967f30..73789a7 100644
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -197,9 +197,10 @@ void pcibios_bus_add_device(struct pci_dev *pdev)
 	 * With pdev->no_vf_scan the common PCI probing code does not
 	 * perform PF/VF linking.
 	 */
-	if (zdev->vfn)
+	if (zdev->vfn) {
 		zpci_bus_setup_virtfn(zdev->zbus, pdev, zdev->vfn);
-
+		pdev->dev_flags |= PCI_DEV_FLAGS_FORCE_COMMAND_MEM;
+	}
 }
 
 static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
-- 
1.8.3.1

