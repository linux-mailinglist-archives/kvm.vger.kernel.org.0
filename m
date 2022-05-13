Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18084526A46
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 21:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383626AbiEMTSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 15:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383674AbiEMTR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 15:17:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F53A3BA79;
        Fri, 13 May 2022 12:17:07 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24DHeGT7016367;
        Fri, 13 May 2022 19:17:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EGIZXWmMpVWgHnjEyyIawZMaHLmCbwf6PXxtc63gIJY=;
 b=FkULY04PLvgHVHeQ0nq5iSUxJH95vC3vwr7gYmmoqDnBUyKppl1iMG8rlwnmJFVrR4xc
 AlK5YeTsVD1Hf46jRimG+3p3qCTHSSIqBIiJ1hU4WKeRafySAv+nTI9EvXv9E4bzNYXH
 EMG3+zNFNir3QCjfw9IvAQpuOEeayvB81rVQRvsgPU9crymuNGRnTs5if2bLUBS6ihYJ
 8KA8TYnCrqIB/WD0BH3seQgXnBib1KyB0wEnMEBRtPjXMc4IgBbaNXf2pDh1SADM4Yna
 SnEJsN8AwBODrRlBUIQvAkb5qubnXMpu+htssbyQ2k0oSMcSchkUWXy2UOu6w6xKemOm Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1qusfffk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:17:03 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24DJCV0U008065;
        Fri, 13 May 2022 19:17:03 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1qusfff4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:17:03 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24DJCWn2009438;
        Fri, 13 May 2022 19:17:02 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3fwgdaqc1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 19:17:02 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24DJH1MS7537290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 19:17:01 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49EC7124052;
        Fri, 13 May 2022 19:17:01 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EECE6124053;
        Fri, 13 May 2022 19:16:55 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.49.28])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 19:16:55 +0000 (GMT)
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
Subject: [PATCH v7 19/22] vfio-pci/zdev: different maxstbl for interpreted devices
Date:   Fri, 13 May 2022 15:15:06 -0400
Message-Id: <20220513191509.272897-20-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220513191509.272897-1-mjrosato@linux.ibm.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DbkY6lKnQZTijsUPnqpQSeTyae-Qtybj
X-Proofpoint-GUID: 8XN5T53yJkvask-9DV_mawLPNib91v1O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_11,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index c7557f80ec64..067383f84cd8 100644
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

