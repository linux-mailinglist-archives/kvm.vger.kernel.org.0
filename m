Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAAC299117
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783968AbgJZPfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 11:35:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3606 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1782642AbgJZPfM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 11:35:12 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QFWoiI190353;
        Mon, 26 Oct 2020 11:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=k28jbXdnneohSaFEzbYku+LX108RqQpUJuiRR01AY+U=;
 b=pCe0m3j6zn0zfthtUne6Z6xx753Rxj0QGpB9pG5P8Rq8WPrypgi4DX+ZhIBg3Bze5gHP
 qwy2SSik7tCeShbQKQu0JwCMEtbjVnnBS0VwFXv9amX+IKIn82lxHvsCGBxJFA7vVvP9
 8uLdd15HkxF8q+9ebQxTomB8S853IEx+SfODKfz6sFf5JvHGKDvgqQ59TJbHIldhdOKW
 Gmn9tPU6QlTS5g4twmdqrtGcEej2eCltctF73LtN0eEbKi3UKCsBhbCAQdUYNMfKx0/6
 EffeR0KazBbRXhdWC4eFkSfv9br+AF7Emu64Z81MF4qF7HWeOODprWqyWospzXSxrx8b Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dxaxnuq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:04 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QFYpfR004189;
        Mon, 26 Oct 2020 11:35:03 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dxaxnups-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:03 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QFICpF028232;
        Mon, 26 Oct 2020 15:35:02 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 34cbw8vrqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 15:35:02 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QFZ2as44761380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 15:35:02 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03606112062;
        Mon, 26 Oct 2020 15:35:02 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 342A7112061;
        Mon, 26 Oct 2020 15:34:59 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.49.29])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 15:34:59 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 03/13] s390x/pci: Move header files to include/hw/s390x
Date:   Mon, 26 Oct 2020 11:34:31 -0400
Message-Id: <1603726481-31824-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems a more appropriate location for them.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 MAINTAINERS                              | 1 +
 hw/s390x/s390-pci-bus.c                  | 4 ++--
 hw/s390x/s390-pci-inst.c                 | 4 ++--
 hw/s390x/s390-virtio-ccw.c               | 2 +-
 {hw => include/hw}/s390x/s390-pci-bus.h  | 0
 {hw => include/hw}/s390x/s390-pci-inst.h | 0
 6 files changed, 6 insertions(+), 5 deletions(-)
 rename {hw => include/hw}/s390x/s390-pci-bus.h (100%)
 rename {hw => include/hw}/s390x/s390-pci-inst.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index ef6f5c7..e0c6595 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1435,6 +1435,7 @@ S390 PCI
 M: Matthew Rosato <mjrosato@linux.ibm.com>
 S: Supported
 F: hw/s390x/s390-pci*
+F: include/hw/s390x/s390-pci*
 L: qemu-s390x@nongnu.org
 
 UniCore32 Machines
diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index fb4cee8..a929340 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -15,8 +15,8 @@
 #include "qapi/error.h"
 #include "qapi/visitor.h"
 #include "cpu.h"
-#include "s390-pci-bus.h"
-#include "s390-pci-inst.h"
+#include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-inst.h"
 #include "hw/pci/pci_bus.h"
 #include "hw/qdev-properties.h"
 #include "hw/pci/pci_bridge.h"
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 2f7a7d7..639b13c 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -13,12 +13,12 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "s390-pci-inst.h"
-#include "s390-pci-bus.h"
 #include "exec/memop.h"
 #include "exec/memory-internal.h"
 #include "qemu/error-report.h"
 #include "sysemu/hw_accel.h"
+#include "hw/s390x/s390-pci-inst.h"
+#include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/tod.h"
 
 #ifndef DEBUG_S390PCI_INST
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index e52182f..9bf658d 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -28,7 +28,7 @@
 #include "qemu/error-report.h"
 #include "qemu/option.h"
 #include "qemu/qemu-print.h"
-#include "s390-pci-bus.h"
+#include "hw/s390x/s390-pci-bus.h"
 #include "sysemu/reset.h"
 #include "hw/s390x/storage-keys.h"
 #include "hw/s390x/storage-attributes.h"
diff --git a/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
similarity index 100%
rename from hw/s390x/s390-pci-bus.h
rename to include/hw/s390x/s390-pci-bus.h
diff --git a/hw/s390x/s390-pci-inst.h b/include/hw/s390x/s390-pci-inst.h
similarity index 100%
rename from hw/s390x/s390-pci-inst.h
rename to include/hw/s390x/s390-pci-inst.h
-- 
1.8.3.1

