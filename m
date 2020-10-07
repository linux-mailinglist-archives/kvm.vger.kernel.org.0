Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB45286802
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 21:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgJGTEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 15:04:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728268AbgJGTEo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 15:04:44 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097J2NTR035737;
        Wed, 7 Oct 2020 15:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6S2PkKO16g+NTMVJmmUS50xG/Pjax80JpxCq2Qlgokw=;
 b=nBTcs0C2nGyF2FXtecnvxOuiUjS4RNpcdQ+aDgfSdqixT0GoaDmFmdQwVjmze3bGDC9B
 +u7GJffj4g0VSfLdijcEXVz+ZrrAjJmeX/jbXq0b/AEn/JOfp3D8v8MmX1S1EzQfl0dK
 mp71GVaXR1YL3zRruJ/FzxUsQfLmprFvPxPIyf5ztgDzTnjcOjkNllcS+NbIKKkXlSqt
 sNxQGPnFYiAa0Uxx+DnKmmrcb61fJYLiBfrbbfrc2j1U8x0VAnzXfEEkEcglvaPi5GHz
 OXbDTEnF7f/Bts+j6hbF7tZjOTnNqs8TBp/7ThYPX2bQrfG6puqMn9yQwkbU1wc8vhAi Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341jak25xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:04:24 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097J2QXr036157;
        Wed, 7 Oct 2020 15:04:24 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341jak25x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:04:24 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097IllfS028843;
        Wed, 7 Oct 2020 19:04:23 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 3411xd81wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 19:04:23 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097J4MC213435520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 19:04:22 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 911CFAC05F;
        Wed,  7 Oct 2020 19:04:22 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 259C8AC059;
        Wed,  7 Oct 2020 19:04:20 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 19:04:19 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v3 01/10] s390x/pci: Move header files to include/hw/s390x
Date:   Wed,  7 Oct 2020 15:04:06 -0400
Message-Id: <1602097455-15658-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
References: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0
 mlxscore=0 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems a more appropriate location for them.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
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
index e9d85cc..0eb8a7f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1443,6 +1443,7 @@ S390 PCI
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
index 28266a3..f31ae2e 100644
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

