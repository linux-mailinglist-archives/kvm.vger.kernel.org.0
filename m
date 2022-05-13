Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E842F526A3D
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383673AbiEMTSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383741AbiEMTRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:17:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE8739175;
        Fri, 13 May 2022 12:17:00 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DJBtmD018066;
        Fri, 13 May 2022 19:16:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wymyD1s+0NAP7BqmDdFRnU4dI/NRwDJAUtaUXAZ/qEY=;
 b=V+S5VfmcAx5LBlZXVTmq58z1qDrLc4E7UsszDHH5M+PEVYaKxyJ1hgf550tpPVkQ5TBY
 awehd2QdtOlgHTvEu/CAsSZIJXhHUVu5ul0nh0G0kDWdUhbcSKVVTnyqqGMaBWhpbZRg
 UXUU100b3YxULVW+2mcmTCkNmi5uueJs77ylbU8ABbO1u7RvUXQC0nCaABM19EHR5k4D
 F5J1GFndrZVyTQx0hcTL5q3gDIgrLsFrDYMaURFS/LyD5kyvfk275I2tR6Xaz6UdzoUN
 EUW61rFSTwLLx37uKb8DbqiPMJQUBkRBfZ9Oh30Q7tOZqEjCalDOkyJ8mROXwU2qvzCQ mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1w9ar2m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:58 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DJE99v027692;
        Fri, 13 May 2022 19:16:57 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1w9ar2kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:57 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DJCPvd005008;
        Fri, 13 May 2022 19:16:56 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 3fwgdb7cb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:16:56 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DJGt6o23658926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 19:16:55 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98003124054;
        Fri, 13 May 2022 19:16:55 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFF6B124053;
        Fri, 13 May 2022 19:16:49 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.49.28])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 19:16:49 +0000 (GMT)
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
Subject: [PATCH v7 18/22] vfio-pci/zdev: add function handle to clp base capability
Date:   Fri, 13 May 2022 15:15:05 -0400
Message-Id: <20220513191509.272897-19-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220513191509.272897-1-mjrosato@linux.ibm.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gMKn0bk_w1wTSd1VCCZ3bi74kLrWX4KY
X-Proofpoint-ORIG-GUID: -I-7SsZy7wFl_ni3t9TN4td93lgHFeD8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_11,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 mlxscore=0 mlxlogscore=919 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The function handle is a system-wide unique identifier for a zPCI
device.  With zPCI instruction interpretation, the host will no
longer be executing the zPCI instructions on behalf of the guest.
As a result, the guest needs to use the real function handle in
order for firmware to associate the instruction with the proper
PCI function.  Let's provide that handle to the guest.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 5 +++--
 include/uapi/linux/vfio_zdev.h   | 3 +++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 130ab298ab98..c7557f80ec64 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -24,14 +24,15 @@ static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
 {
 	struct vfio_device_info_cap_zpci_base cap = {
 		.header.id = VFIO_DEVICE_INFO_CAP_ZPCI_BASE,
-		.header.version = 1,
+		.header.version = 2,
 		.start_dma = zdev->start_dma,
 		.end_dma = zdev->end_dma,
 		.pchid = zdev->pchid,
 		.vfn = zdev->vfn,
 		.fmb_length = zdev->fmb_length,
 		.pft = zdev->pft,
-		.gid = zdev->pfgid
+		.gid = zdev->pfgid,
+		.fh = zdev->fh
 	};
 
 	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index b4309397b6b2..78c022af3d29 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -29,6 +29,9 @@ struct vfio_device_info_cap_zpci_base {
 	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
 	__u8 pft;		/* PCI Function Type */
 	__u8 gid;		/* PCI function group ID */
+	/* End of version 1 */
+	__u32 fh;		/* PCI function handle */
+	/* End of version 2 */
 };
 
 /**
-- 
2.27.0

