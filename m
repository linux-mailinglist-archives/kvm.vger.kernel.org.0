Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DD248F15F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244918AbiANUdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:33:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244672AbiANUct (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:49 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EJuiVe001306;
        Fri, 14 Jan 2022 20:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FwxZ0lgRJEaoHst4/0vke0v4HRpWeXJ/4IAsiQH2yzs=;
 b=g/1/d9/rS2shtzg966VWT3kO3xCCH/6H3QgxZDJKvPZzMtc9mfjiLirYDYUCloUKnPzm
 Fz6uoeJHlxNuMnm44zAHFIYOXg8GiJeIVW20GehnU34fhqf2JSjgHtRKgnn+/QWgZb1n
 nqsVjGuqT+AYCPAgbD4oyBGoZSuGRdfa4fDMO65E8tUNK5H1wgg/aOomEs4x0pnWkwog
 WWt2qZeQNjaTiOvM/rccF0mJcyjoWkQQWNutsU+5m6k4pns49DGmIyk7Mg+p+v8WBHNF
 HXwCdAmwIL56JkklBgiv5PjdHqI5rPvzYwJ3JYwVAv1pQcEFRKIJsj3aulhMw7ax4NSn dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfsd8m9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:48 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKGXWc021566;
        Fri, 14 Jan 2022 20:32:48 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfsd8m9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:48 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLpoB020166;
        Fri, 14 Jan 2022 20:32:47 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 3df28de556-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:47 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWjCU17564004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:45 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6734AC6069;
        Fri, 14 Jan 2022 20:32:45 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B80EAC6065;
        Fri, 14 Jan 2022 20:32:43 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:43 +0000 (GMT)
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
Subject: [PATCH v2 28/30] vfio-pci/zdev: add DTSM to clp group capability
Date:   Fri, 14 Jan 2022 15:31:43 -0500
Message-Id: <20220114203145.242984-29-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: E6SdFyKf-auuecd3dhbim_Pn3-TVYTUC
X-Proofpoint-GUID: k4eV4GeOEZzhObcVDiFN8ItU7ZSHtzVD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DTSM, or designation type supported mask, indicates what IOAT formats
are available to the guest.  For an interpreted device, userspace will not
know what format(s) the IOAT assist supports, so pass it via the
capability chain.  Since the value belongs to the Query PCI Function Group
clp, let's extend the existing capability with a new version.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 9 ++++++---
 include/uapi/linux/vfio_zdev.h   | 3 +++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 2b169d688937..aa2ef9067c7d 100644
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
-	if (zdev->kzdev && zdev->kzdev->interp)
+	if (zdev->kzdev && zdev->kzdev->interp) {
 		cap.maxstbl = zdev->maxstbl;
+		cap.dtsm = kvm_s390_pci_get_dtsm(zdev);
+	}
 
 	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
 }
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index 1a5229b7bb18..b4c2ba8e71f0 100644
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

