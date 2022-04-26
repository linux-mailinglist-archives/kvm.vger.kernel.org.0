Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C715109FC
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354796AbiDZUPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354719AbiDZUN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:13:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D4413CDF;
        Tue, 26 Apr 2022 13:10:17 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QK4CjR001211;
        Tue, 26 Apr 2022 20:10:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cP7T2w8HWkFOokBMhvbDD9k7jmXurOGVozpNB0iBHpE=;
 b=EFfWD0yaCsibb0ghMDzR6Rl0YdRCnuEtCc+pHCq/KetyMl3hFkCwfbtbHc3pNxqc3iuS
 yd4WyU3+N3ioGwKSEsjgFDIO8ILy0B0htusKXPRcgpH7MHFiuWXaXljX56ZPlmOlvokP
 oc2VvMbSLB/3K1kez757etggYV6AU2leYk7qTffer62rpK6YjYf9GE5wUf8ffQ5blOR3
 H4eh0mG4khrg0gW+FUG8c1y13y/uINRjbdcEHp2UTW0c1HaEtgoR8Sk3BGFYhEcp2wj6
 5061S5d4Uv/iEsijjjIaZTeNWTi2SRPxpkPbUGCk1PePFJCgdg2CoUdRZnDi8yIrcVPB Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpmwyk4tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:14 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23QK4COJ001221;
        Tue, 26 Apr 2022 20:10:13 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpmwyk4sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:13 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QK8VEi026595;
        Tue, 26 Apr 2022 20:10:12 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3fm939w953-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:10:12 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QKABET26739140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 20:10:11 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECB69B206C;
        Tue, 26 Apr 2022 20:10:10 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F8F0B2067;
        Tue, 26 Apr 2022 20:10:07 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.73.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 20:10:07 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v6 18/21] vfio-pci/zdev: different maxstbl for interpreted devices
Date:   Tue, 26 Apr 2022 16:08:39 -0400
Message-Id: <20220426200842.98655-19-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220426200842.98655-1-mjrosato@linux.ibm.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1gwU2DlbfowFnSRbXuK0qIbORZ7LI1en
X-Proofpoint-ORIG-GUID: N8fB1nogQZtGVt-l5tQYmobNbrgBOZax
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_06,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 malwarescore=0 clxscore=1015 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When doing load/store interpretation, the maximum store block length is
determined by the underlying firmware, not the host kernel API.  Reflect
that in the associated Query PCI Function Group clp capability and let
userspace decide which is appropriate to present to the guest.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 6 ++++--
 include/uapi/linux/vfio_zdev.h   | 4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 00183e8aa393..ea20d4d36eef 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -45,14 +45,16 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
 {
 	struct vfio_device_info_cap_zpci_group cap = {
 		.header.id = VFIO_DEVICE_INFO_CAP_ZPCI_GROUP,
-		.header.version = 1,
+		.header.version = 2,
 		.dasm = zdev->dma_mask,
 		.msi_addr = zdev->msi_addr,
 		.flags = VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH,
 		.mui = zdev->fmb_update,
 		.noi = zdev->max_msi,
 		.maxstbl = ZPCI_MAX_WRITE_SIZE,
-		.version = zdev->version
+		.version = zdev->version,
+		.reserved = 0,
+		.imaxstbl = zdev->maxstbl
 	};
 
 	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index 78c022af3d29..77f2aff1f27e 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -50,6 +50,10 @@ struct vfio_device_info_cap_zpci_group {
 	__u16 noi;		/* Maximum number of MSIs */
 	__u16 maxstbl;		/* Maximum Store Block Length */
 	__u8 version;		/* Supported PCI Version */
+	/* End of version 1 */
+	__u8 reserved;
+	__u16 imaxstbl;		/* Maximum Interpreted Store Block Length */
+	/* End of version 2 */
 };
 
 /**
-- 
2.27.0

