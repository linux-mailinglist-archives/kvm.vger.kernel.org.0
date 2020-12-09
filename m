Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463C02D4BDE
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 21:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388501AbgLIU3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:29:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58175 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728450AbgLIU2t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 15:28:49 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9KDeAl133362;
        Wed, 9 Dec 2020 15:28:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=RNAgxCZ6LPLzPrY2Z1vCKZGyclLScwFuVytng/DHOrI=;
 b=BaNzHybLSyGcz2Sz614G/ZI94sRwAUslOKYZcl5LfDQyrRpAKCWJyokL+VNlBeU/N321
 hCaSRP0tHNgXFcVNpoyKpdBdnw+VOK0N2ao8g9AMqTWrlE/rXrrasZLjU/5E1UckyBqg
 3HicBlNrvVcoKp7HsT+TKUP9NyTC/j/R6w8e44JzAZCvV+NPvEdVZTbeGvkeSS0Wecr2
 9l1mo35QeC+SCTE49MiZiqCK7TQjRjN3/Bv1PmM/uxqOCSUwMtaOan7Ty9k+C+c0QaO/
 d9gL7TFHKmH+4CRmuverkIbHTBj12e6DE5Pyh+m/brFgf+yC3205XrTPmN0P0CZwGT5m Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35b3gdkgx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:28:05 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9KDlYl134069;
        Wed, 9 Dec 2020 15:28:04 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35b3gdkgx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:28:04 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9KM7iX015859;
        Wed, 9 Dec 2020 20:28:03 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 3581u9gds6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 20:28:03 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9KS1va26083762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 20:28:01 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD589B205F;
        Wed,  9 Dec 2020 20:28:01 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90053B2065;
        Wed,  9 Dec 2020 20:27:59 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.37.122])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 20:27:59 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 2/4] vfio-pci/zdev: Pass the relaxed alignment flag
Date:   Wed,  9 Dec 2020 15:27:48 -0500
Message-Id: <1607545670-1557-3-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_16:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=953 priorityscore=1501
 clxscore=1011 mlxscore=0 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090137
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use an additional bit of the VFIO_DEVICE_INFO_CAP_ZPCI_GROUP flags
field to pass whether or not the associated device supports relaxed
length and alignment for some I/O operations.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_zdev.c | 2 ++
 include/uapi/linux/vfio_zdev.h   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 2296856..57e19ff 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -60,6 +60,8 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
 		.version = zdev->version
 	};
 
+	if (zdev->relaxed_align)
+		cap.flags |= VFIO_DEVICE_INFO_ZPCI_FLAG_RELAXED;
 	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
 }
 
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
index b430939..b0b6596 100644
--- a/include/uapi/linux/vfio_zdev.h
+++ b/include/uapi/linux/vfio_zdev.h
@@ -43,6 +43,7 @@ struct vfio_device_info_cap_zpci_group {
 	__u64 msi_addr;		/* MSI address */
 	__u64 flags;
 #define VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH 1 /* Program-specified TLB refresh */
+#define VFIO_DEVICE_INFO_ZPCI_FLAG_RELAXED 2 /* Relaxed Length and Alignment */
 	__u16 mui;		/* Measurement Block Update Interval */
 	__u16 noi;		/* Maximum number of MSIs */
 	__u16 maxstbl;		/* Maximum Store Block Length */
-- 
1.8.3.1

