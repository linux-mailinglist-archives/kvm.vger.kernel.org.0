Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860031F556A
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 15:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgFJNMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 09:12:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728826AbgFJNMA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 09:12:00 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05AD3D1S038699;
        Wed, 10 Jun 2020 09:11:58 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31k02k8aaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 09:11:58 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05AD4fTd050863;
        Wed, 10 Jun 2020 09:11:57 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31k02k8a98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 09:11:57 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05AD0Rpt008390;
        Wed, 10 Jun 2020 13:11:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 31jf1grhpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 13:11:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05ADBrZY29491288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 13:11:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA9584C050;
        Wed, 10 Jun 2020 13:11:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D3544C04E;
        Wed, 10 Jun 2020 13:11:52 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.158.19])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Jun 2020 13:11:52 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
Date:   Wed, 10 Jun 2020 15:11:51 +0200
Message-Id: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-10_07:2020-06-10,2020-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 clxscore=1011 cotscore=-2147483648 mlxscore=0
 malwarescore=0 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=779 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protected Virtualisation protects the memory of the guest and
do not allow a the host to access all of its memory.

Let's refuse a VIRTIO device which does not use IOMMU
protected access.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/s390/virtio/virtio_ccw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 5730572b52cd..06ffbc96587a 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -986,6 +986,11 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
 	if (!ccw)
 		return;
 
+	/* Protected Virtualisation guest needs IOMMU */
+	if (is_prot_virt_guest() &&
+	    !__virtio_test_bit(vdev, VIRTIO_F_IOMMU_PLATFORM))
+			status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
+
 	/* Write the status to the host. */
 	vcdev->dma_area->status = status;
 	ccw->cmd_code = CCW_CMD_WRITE_STATUS;
-- 
2.25.1

