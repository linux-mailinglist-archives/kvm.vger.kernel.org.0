Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B99E4AA225
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348265AbiBDVR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:17:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241693AbiBDVQm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:42 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214KZ2o6006899;
        Fri, 4 Feb 2022 21:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=geW5tDJ/mjJpnu+nHkdNdvQlMidXOhTFHIvUZbI4T9c=;
 b=B0vImhAdYmky1Su6oY/NpJNhNE73WbYmo84plP8XuBFvBKY+wRN7e6Sr5NoBkjYIgHBu
 cxXx34Yfe/V7KrmzD7At42QQ517b6fdQeA7/fIMQsVun5N1DlSSCuDPYkGwdVwwaJOKA
 aTYNmfwfJo3BMP0SAlYre2/ehT3XD4thQrQlSWeA42CrwqpSMlswxlrZDfNXnxx8EGQe
 Btd/GdqYVOc2GZUuicZ5RrD+iyYydWLum3fFZNcSqM4MS7idNvkrUHmTfFLo1IWC9lSm
 2R/xzYrv5iT/fKC9AdC+kWZrPs5k0g3zqHUEPPePame0tN6obcQSlslFmqSgLe8jicCf GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx0xssx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:42 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LGg2M031331;
        Fri, 4 Feb 2022 21:16:42 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx0xsrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:42 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCbuU022181;
        Fri, 4 Feb 2022 21:16:40 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 3e0r0kavgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:40 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGdoQ33751498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:39 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11279136067;
        Fri,  4 Feb 2022 21:16:39 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39B9213606A;
        Fri,  4 Feb 2022 21:16:37 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:37 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 28/30] vfio-pci/zdev: add DTSM to clp group capability
Date:   Fri,  4 Feb 2022 16:15:34 -0500
Message-Id: <20220204211536.321475-29-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _2WOctQ82_wJ_o4bRkUS3wzboPNLoKF_
X-Proofpoint-ORIG-GUID: K4AwFV2SZJKDM3eA7y0UukPXQC3fPBUf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DTSM, or designation type supported mask, indicates what IOAT formats
are available to the guest.  For an interpreted device, userspace will not
know what format(s) the IOAT assist supports, so pass it via the
capability chain.  Since the value belongs to the Query PCI Function Group
clp, let's extend the existing capability with a new version.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 9 ++++++---
 include/uapi/linux/vfio_zdev.h   | 3 +++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index f0a6e0f0e4b0..046d91085358 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -45,19 +45,22 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
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
+		.dtsm = 0
 	};
 
 	/* Some values are different for interpreted devices */
-	if (zdev->kzdev && zdev->kzdev->interpretation)
+	if (zdev->kzdev && zdev->kzdev->interpretation) {
 		cap.maxstbl = zdev->maxstbl;
+		cap.dtsm = kvm_s390_pci_get_dtsm(zdev);
+	}
 
 	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
 }
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index b77e6ef355cb..133df1002ecb 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -47,6 +47,9 @@ struct vfio_device_info_cap_zpci_group {
 	__u16 noi;		/* Maximum number of MSIs */
 	__u16 maxstbl;		/* Maximum Store Block Length */
 	__u8 version;		/* Supported PCI Version */
+	/* End of version 1 */
+	__u8 dtsm;		/* Supported IOAT Designations */
+	/* End of version 2 */
 };
 
 /**
-- 
2.27.0

