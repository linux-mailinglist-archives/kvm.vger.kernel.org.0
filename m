Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF2029911E
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 16:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783994AbgJZPfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 11:35:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16756 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1783981AbgJZPfl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 11:35:41 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QFXkYi065903;
        Mon, 26 Oct 2020 11:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=n56z3sbjljCyw/BiMScEVTojjrXz7t8FnzEBAJmYTpY=;
 b=nY1GfEbzS82wx0wELUFHDaNKYDiDt7SsyJJsdygeE1fyJI2sGMg9Yy7XUvGkohpJ7h6I
 AQd7FOXk9qkWoRKDKbARAkbtMhqGO0sYZtcAEtO1ujsY/jTXb1q/a80uj6nSo6U+MfiF
 C1f+PBShiJ2u21HZ8W5ZnC/OTynyGoJKhcMZ7L+/HtpreIEmoAoyF5/gST+B1eZb0d+V
 4U3O4JSZHi2Jlvm7fjYnw772ZXyHtEWfHBCd0eXMvqwTqXQagQ7yEwh4pbvSo5WJBcxN
 qMCE4Vmnm3Yo1eqbyDHKF7iMEl9QJJvQv06WKjcvhi58q897ndwxlxfNSJXfGTusNKrO rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dq9fhev0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:32 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QFYFiA068720;
        Mon, 26 Oct 2020 11:35:31 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dq9fheue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:30 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QFHSWN030702;
        Mon, 26 Oct 2020 15:35:30 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 34cbw8rn35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 15:35:30 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QFZT6324838448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 15:35:29 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8B66112061;
        Mon, 26 Oct 2020 15:35:29 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C63FF112064;
        Mon, 26 Oct 2020 15:35:26 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.49.29])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 15:35:26 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 12/13] vfio: Add routine for finding VFIO_DEVICE_GET_INFO capabilities
Date:   Mon, 26 Oct 2020 11:34:40 -0400
Message-Id: <1603726481-31824-13-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that VFIO_DEVICE_GET_INFO supports capability chains, add a helper
function to find specific capabilities in the chain.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/vfio/common.c              | 10 ++++++++++
 include/hw/vfio/vfio-common.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 20914bf..dca017d 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -859,6 +859,16 @@ vfio_get_iommu_type1_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
     return vfio_get_cap((void *)info, info->cap_offset, id);
 }
 
+struct vfio_info_cap_header *
+vfio_get_device_info_cap(struct vfio_device_info *info, uint16_t id)
+{
+    if (!(info->flags & VFIO_DEVICE_FLAGS_CAPS)) {
+        return NULL;
+    }
+
+    return vfio_get_cap((void *)info, info->cap_offset, id);
+}
+
 bool vfio_get_info_dma_avail(struct vfio_iommu_type1_info *info,
                              unsigned int *avail)
 {
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index 661a380..d2524f8 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -193,6 +193,8 @@ int vfio_get_dev_region_info(VFIODevice *vbasedev, uint32_t type,
 bool vfio_has_region_cap(VFIODevice *vbasedev, int region, uint16_t cap_type);
 struct vfio_info_cap_header *
 vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id);
+struct vfio_info_cap_header *
+vfio_get_device_info_cap(struct vfio_device_info *info, uint16_t id);
 #endif
 extern const MemoryListener vfio_prereg_listener;
 
-- 
1.8.3.1

