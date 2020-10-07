Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A03286807
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 21:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgJGTFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 15:05:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15538 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728353AbgJGTFA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 15:05:00 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097J2WwK002851;
        Wed, 7 Oct 2020 15:04:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=41919ZYcUtzZsyRo0Z/E4r1Trw7GJFVpMTEJltbAuBk=;
 b=aYmndi71aeEHpqEEvbLRkJjm8ullLHh66NtWU21mNyWbX6tF6nmmsb6eM9VyMd8wmm9/
 UNbwzKubSs3IPjCc4yvVxJm4MAxuzuCkQE5WR3FZO9jndY+fgtHfyfpkYsXlBP4PXp4+
 YJtznATSBJEeMkYaz0yJ+wKwklpxewt19mPQlrpDdn1/acZPV2Xt3FIdaDc1Xr7MMJI6
 e0duTwTdmXy+3KAfm6t6RYvaDF8ZR8mzxKy080DmfeDcQ8VcnNSbF7Xnuy4BhHMzr7s9
 p8tgpSl3bhQt3KhoFRd6kzXXHxNP3UfB8N7kXWgaW2C0VASHhrt1L76Q60m0bIjNYe60 pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341jwr0yhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:04:45 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097J2glB003330;
        Wed, 7 Oct 2020 15:04:45 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 341jwr0yhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:04:45 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097IkiK1025460;
        Wed, 7 Oct 2020 19:04:44 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 33xgx9haex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 19:04:44 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097J4i4438470068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 19:04:44 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D488CAC05F;
        Wed,  7 Oct 2020 19:04:43 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BE8DAC060;
        Wed,  7 Oct 2020 19:04:41 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 19:04:41 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v3 09/10] vfio: Add routine for finding VFIO_DEVICE_GET_INFO capabilities
Date:   Wed,  7 Oct 2020 15:04:14 -0400
Message-Id: <1602097455-15658-10-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
References: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that VFIO_DEVICE_GET_INFO supports capability chains, add a helper
function to find specific capabilities in the chain.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/vfio/common.c              | 10 ++++++++++
 include/hw/vfio/vfio-common.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index e47a4d7..7cda9d2 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -849,6 +849,16 @@ vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
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
 static int vfio_setup_region_sparse_mmaps(VFIORegion *region,
                                           struct vfio_region_info *info)
 {
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index c78f3ff..3c236ed 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -191,6 +191,8 @@ int vfio_get_dev_region_info(VFIODevice *vbasedev, uint32_t type,
 bool vfio_has_region_cap(VFIODevice *vbasedev, int region, uint16_t cap_type);
 struct vfio_info_cap_header *
 vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id);
+struct vfio_info_cap_header *
+vfio_get_device_info_cap(struct vfio_device_info *info, uint16_t id);
 #endif
 extern const MemoryListener vfio_prereg_listener;
 
-- 
1.8.3.1

