Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B43A379477
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhEJQqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:46:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232122AbhEJQp5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 12:45:57 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AGiTKo060163;
        Mon, 10 May 2021 12:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qUGK7Fw1L+N4K36Zwn5/7vE4yr0uYB3s0PJd5u1GPfs=;
 b=M2MyXQ+96qVYTFmrZOCNq+AvQfrfusGlCN76khQ/0PF6XQB3pEkaGMhSVN8feAJ2kzrC
 AknQrB5ADp3sO1ptZfmep78bSOmhJ/Bv6pF8sBUDqwKuym3H1hndvFvsL8+22XDhBmUe
 PekP/R5kQgaaTOHKQaRimT+/o6CdA9SoEcyz85SSOE4k5hhwmhG8DzAZ0vBx9oOfJhO1
 ufRfLH40eXmqs3aClX1p6KebxzMEhepa0l4Jj9O8XENiFBzvqgyGKyMNViU1/V5gRFN2
 FF2010ekR2l1iGJLowBBIBv+2SjVLrgp3Ib3qvYbqzFnUOCl5By7qEUdGusd96QqRpDd Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f8m6r06c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:49 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AGinuq061350;
        Mon, 10 May 2021 12:44:49 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f8m6r064-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 12:44:49 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AGgYwR000736;
        Mon, 10 May 2021 16:44:48 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma02dal.us.ibm.com with ESMTP id 38dj98ugxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 16:44:48 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AGik9e20119974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 16:44:46 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 898E6AE063;
        Mon, 10 May 2021 16:44:46 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8FA0AE062;
        Mon, 10 May 2021 16:44:44 +0000 (GMT)
Received: from cpe-172-100-179-72.stny.res.rr.com.com (unknown [9.85.140.234])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 16:44:44 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v16 12/14] s390/vfio-ap: sysfs attribute to display the guest's matrix
Date:   Mon, 10 May 2021 12:44:21 -0400
Message-Id: <20210510164423.346858-13-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510164423.346858-1-akrowiak@linux.ibm.com>
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qu2e3ZvjWec2in8dhG_qsioNotvwnp1B
X-Proofpoint-ORIG-GUID: p8LDXRAfWNrPh7dCu03Cata9NFkr06aR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The matrix of adapters and domains configured in a guest's APCB may
differ from the matrix of adapters and domains assigned to the matrix mdev,
so this patch introduces a sysfs attribute to display the matrix of
adapters and domains that are or will be assigned to the APCB of a guest
that is or will be using the matrix mdev. For a matrix mdev denoted by
$uuid, the guest matrix can be displayed as follows:

   cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 51 ++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 3d6c6c2b3b4f..49e0111a91f4 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1256,29 +1256,24 @@ static ssize_t control_domains_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(control_domains);
 
-static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
-			   char *buf)
+static ssize_t vfio_ap_mdev_matrix_show(struct ap_matrix *matrix, char *buf)
 {
-	struct mdev_device *mdev = mdev_from_dev(dev);
-	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	char *bufpos = buf;
 	unsigned long apid;
 	unsigned long apqi;
 	unsigned long apid1;
 	unsigned long apqi1;
-	unsigned long napm_bits = matrix_mdev->matrix.apm_max + 1;
-	unsigned long naqm_bits = matrix_mdev->matrix.aqm_max + 1;
+	unsigned long napm_bits = matrix->apm_max + 1;
+	unsigned long naqm_bits = matrix->aqm_max + 1;
 	int nchars = 0;
 	int n;
 
-	apid1 = find_first_bit_inv(matrix_mdev->matrix.apm, napm_bits);
-	apqi1 = find_first_bit_inv(matrix_mdev->matrix.aqm, naqm_bits);
-
-	mutex_lock(&matrix_dev->lock);
+	apid1 = find_first_bit_inv(matrix->apm, napm_bits);
+	apqi1 = find_first_bit_inv(matrix->aqm, naqm_bits);
 
 	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
-		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
-			for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
+		for_each_set_bit_inv(apid, matrix->apm, napm_bits) {
+			for_each_set_bit_inv(apqi, matrix->aqm,
 					     naqm_bits) {
 				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
 					    apqi);
@@ -1287,25 +1282,52 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 			}
 		}
 	} else if (apid1 < napm_bits) {
-		for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, napm_bits) {
+		for_each_set_bit_inv(apid, matrix->apm, napm_bits) {
 			n = sprintf(bufpos, "%02lx.\n", apid);
 			bufpos += n;
 			nchars += n;
 		}
 	} else if (apqi1 < naqm_bits) {
-		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, naqm_bits) {
+		for_each_set_bit_inv(apqi, matrix->aqm, naqm_bits) {
 			n = sprintf(bufpos, ".%04lx\n", apqi);
 			bufpos += n;
 			nchars += n;
 		}
 	}
 
+	return nchars;
+}
+
+static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	ssize_t nchars;
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+
+	mutex_lock(&matrix_dev->lock);
+	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->matrix, buf);
 	mutex_unlock(&matrix_dev->lock);
 
 	return nchars;
 }
 static DEVICE_ATTR_RO(matrix);
 
+static ssize_t guest_matrix_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	ssize_t nchars;
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+
+	mutex_lock(&matrix_dev->lock);
+	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->shadow_apcb, buf);
+	mutex_unlock(&matrix_dev->lock);
+
+	return nchars;
+}
+static DEVICE_ATTR_RO(guest_matrix);
+
 static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_assign_adapter.attr,
 	&dev_attr_unassign_adapter.attr,
@@ -1315,6 +1337,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_unassign_control_domain.attr,
 	&dev_attr_control_domains.attr,
 	&dev_attr_matrix.attr,
+	&dev_attr_guest_matrix.attr,
 	NULL,
 };
 
-- 
2.30.2

