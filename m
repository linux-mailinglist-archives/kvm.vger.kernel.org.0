Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0034216887
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 10:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgGGIpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 04:45:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgGGIo7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 04:44:59 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0678YD1h105513;
        Tue, 7 Jul 2020 04:44:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32482kn0pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 04:44:54 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0678YMRP106482;
        Tue, 7 Jul 2020 04:44:51 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32482kn0k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 04:44:50 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0678eADI020543;
        Tue, 7 Jul 2020 08:44:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 322hd7u6xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Jul 2020 08:44:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0678ifnv56033414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Jul 2020 08:44:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D84CA4055;
        Tue,  7 Jul 2020 08:44:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E693A4040;
        Tue,  7 Jul 2020 08:44:40 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.29.12])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Jul 2020 08:44:40 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: [PATCH v4 2/2] s390: virtio: PV needs VIRTIO I/O device protection
Date:   Tue,  7 Jul 2020 10:44:37 +0200
Message-Id: <1594111477-15401-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594111477-15401-1-git-send-email-pmorel@linux.ibm.com>
References: <1594111477-15401-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_05:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 phishscore=0 suspectscore=1 cotscore=-2147483648
 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007070066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

S390, protecting the guest memory against unauthorized host access
needs to enforce VIRTIO I/O device protection through the use of
VIRTIO_F_VERSION_1 and VIRTIO_F_IOMMU_PLATFORM.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/kernel/uv.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index c296e5c8dbf9..106330f6eda1 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -14,6 +14,7 @@
 #include <linux/memblock.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/virtio_config.h>
 #include <asm/facility.h>
 #include <asm/sections.h>
 #include <asm/uv.h>
@@ -413,3 +414,27 @@ static int __init uv_info_init(void)
 }
 device_initcall(uv_info_init);
 #endif
+
+/*
+ * arch_validate_virtio_iommu_platform
+ * @dev: the VIRTIO device being added
+ *
+ * Return value: returns -ENODEV if any features of the
+ *               device breaks the protected virtualization
+ *               0 otherwise.
+ */
+int arch_validate_virtio_features(struct virtio_device *dev)
+{
+	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
+		dev_warn(&dev->dev, "device must provide VIRTIO_F_VERSION_1\n");
+		return is_prot_virt_guest() ? -ENODEV : 0;
+	}
+
+	if (!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
+		dev_warn(&dev->dev,
+			 "device must provide VIRTIO_F_IOMMU_PLATFORM\n");
+		return is_prot_virt_guest() ? -ENODEV : 0;
+	}
+
+	return 0;
+}
-- 
2.25.1

