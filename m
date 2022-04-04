Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9004F1C07
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351173AbiDDVVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379668AbiDDRqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:46:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE6A13EBA;
        Mon,  4 Apr 2022 10:44:42 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234Ge0KG016546;
        Mon, 4 Apr 2022 17:44:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pLpK+tEpeWb6HbS5e3cPLiZx014T4uD87VJyuP9P5fo=;
 b=Gy8CprMQW4NW74Q5b0SgxcteDnmtZDwCFEGEEx/O4mkaJUnYk+ZnxNBg24ZZY/VZPndD
 ZQA3m9IAKGAGXm5XW0qbUPHBfGH9wsUgABAg1g9opKqvzxAtwrgqi0Bz/LKDMlioig5O
 o2rsWQvVeiIC7g+nm3gtep/x5Hjvr7fRjMDEFr2fO2jxfxh83HHzeO+SY9MUKJ/3R2k2
 d8WDIj8xQSXTizobte611NSbEy+Qi0m1Gp6gsHQHCZwm3Zv8jA+v7RgPmm3UgS0GJQeJ
 MH3w8P4d5eCGRCT/Y92JFer2ycrEHDLEn8sbFRY1b2E8A8nYu33ZhKISNIfHrhJQ6lkz 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6ywj3c46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:40 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234Gh41D029434;
        Mon, 4 Apr 2022 17:44:40 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6ywj3c35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:39 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Hh7dm010703;
        Mon, 4 Apr 2022 17:44:39 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04wdc.us.ibm.com with ESMTP id 3f6e49h75j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:39 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234HicZY32309608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 17:44:38 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 212AA136051;
        Mon,  4 Apr 2022 17:44:38 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05ABC13604F;
        Mon,  4 Apr 2022 17:44:36 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 17:44:35 +0000 (GMT)
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v5 18/21] vfio-pci/zdev: different maxstbl for interpreted devices
Date:   Mon,  4 Apr 2022 13:43:46 -0400
Message-Id: <20220404174349.58530-19-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220404174349.58530-1-mjrosato@linux.ibm.com>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mZyiUFYSlim30QOgceMym7_96AiPl-s3
X-Proofpoint-ORIG-GUID: lB5fQBpHwPhQsNCHpPzGRSDEsxUZUvgx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 6 ++++--
 include/uapi/linux/vfio_zdev.h   | 4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 4a653ce480c7..d3ca58d9d8ec 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -44,14 +44,16 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
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

