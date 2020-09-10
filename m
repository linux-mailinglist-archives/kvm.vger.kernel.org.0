Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83143265043
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 22:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgIJUKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 16:10:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730755AbgIJPAR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 11:00:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AErXwr051799;
        Thu, 10 Sep 2020 11:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=dVMFg9+bK8Cb9Fye9CtZPzaAUIyAfJyRqWJAOVERmYM=;
 b=ZVaxKvItkgfuJzTDkNOYa6I0UPeQ554+NHg9lEw5v5Ve+Neugqkz9MRqE6ATgictdjLk
 fIsZ3H2YSnSPRJmBtT1ma+M3Ccs+oI/UiIuQr4kqWJPHfpxuW/ujrQ390OZZCzuUngj1
 /QEZL+djoF48Bf97crkVYLWNUCZPICzAcJZHdp2hgInHKlZdYS6adaxMM8mQjA4KY4ck
 Is5L+KqRiRGsxzUt7F6BR2vJhWHQDCNSeSV2cHMUCL/M30/5pjBLds2o9KgHavloUBOk
 4jCzdUDvXPg7hch2uF4afO/p6Z3jukxwpXm/6m+J2+szeVI7WMh+Fwh1boq4a6ZJ3tG3 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fpa8r6jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 11:00:09 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AErYwj051844;
        Thu, 10 Sep 2020 11:00:08 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fpa8r6h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 11:00:08 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AEuVUC029834;
        Thu, 10 Sep 2020 15:00:07 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04dal.us.ibm.com with ESMTP id 33c2a9t8ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 15:00:07 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AF020j37880088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 15:00:02 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD6687806D;
        Thu, 10 Sep 2020 15:00:05 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 640FD78060;
        Thu, 10 Sep 2020 15:00:04 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.91.207])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 15:00:04 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, bhelgaas@google.com
Cc:     schnelle@linux.ibm.com, pmorel@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v5 2/3] s390/pci: Mark all VFs as not implementing PCI_COMMAND_MEMORY
Date:   Thu, 10 Sep 2020 10:59:56 -0400
Message-Id: <1599749997-30489-3-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1599749997-30489-1-git-send-email-mjrosato@linux.ibm.com>
References: <1599749997-30489-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_03:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 adultscore=0 mlxlogscore=682
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100130
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For s390 we can have VFs that are passed-through without the associated
PF. Firmware provides an emulation layer to allow these devices to
operate independently, but is missing emulation of the Memory Space
Enable bit.  For these as well as linked VFs, set no_command_memory
which specifies these devices do not implement PCI_COMMAND_MEMORY.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/pci/pci_bus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
index 5967f30..c93486a 100644
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
+		pdev->no_command_memory = 1;
+	}
 }
 
 static int zpci_bus_add_device(struct zpci_bus *zbus, struct zpci_dev *zdev)
-- 
1.8.3.1

