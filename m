Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475B9350358
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 17:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbhCaPYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 11:24:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65204 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236370AbhCaPXk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 11:23:40 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12VF3HUC031068;
        Wed, 31 Mar 2021 11:23:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hGHniY7InEdaKKXjCPMUUTIZEce/F5zdx0O1qpjN+BQ=;
 b=sDWNeEzq5MfZHMEtYn/HwuyEcUs2eBsK5cPK8z+u2BiBAXbJ9qViyNE5ceC/9GfHRL7s
 aTsbAgrw2BQ45tnllV+RTxoJQEE+csutE5JNtY9MjXjaeZH6iL+g6JnrXkmW1svjoGM0
 KbW9JeZl72Lo/l6WKoOZSS0jb9KFywOCDQPZHgnlxRm9BSN17ruYFBC4ZugOTWt5o12h
 KL21c4J+hjqVgn58JnLRGhnmaC47ii59HHR6+X4G7i5nnycO1qiUXukkXckpsmjzWZ+L
 pOFpEw+WbRN31xhh1mLkMcmnjn17w7yZ2OQLalJjE/Uk8pKA/vevyz42y6TvOANjra1D pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mu4u9dhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 11:23:38 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12VF4pHg039260;
        Wed, 31 Mar 2021 11:23:37 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37mu4u9dfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 11:23:37 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12VF25cZ018215;
        Wed, 31 Mar 2021 15:23:36 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 37mb3ay2h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Mar 2021 15:23:36 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12VFNWbP25756094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 15:23:32 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2A1F6E050;
        Wed, 31 Mar 2021 15:23:32 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D67276E04E;
        Wed, 31 Mar 2021 15:23:30 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.146.149])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 31 Mar 2021 15:23:30 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v14 11/13] s390/vfio-ap: sysfs attribute to display the guest's matrix
Date:   Wed, 31 Mar 2021 11:22:54 -0400
Message-Id: <20210331152256.28129-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20210331152256.28129-1-akrowiak@linux.ibm.com>
References: <20210331152256.28129-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JFyYPsAsdNR7aNpdQMeZdI-hraHQmJ-D
X-Proofpoint-GUID: Zowk1QrDMEDjHgpLQUDlHwqgtQxFE472
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-31_06:2021-03-31,2021-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 mlxscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103300000
 definitions=main-2103310107
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
index 191807c10c23..c147e3f43ae4 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1089,29 +1089,24 @@ static ssize_t control_domains_show(struct device *dev,
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
@@ -1120,25 +1115,52 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
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
@@ -1148,6 +1170,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_unassign_control_domain.attr,
 	&dev_attr_control_domains.attr,
 	&dev_attr_matrix.attr,
+	&dev_attr_guest_matrix.attr,
 	NULL,
 };
 
-- 
2.21.3

