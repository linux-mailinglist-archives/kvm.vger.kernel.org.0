Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D46D1A15D9
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 21:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgDGTVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 15:21:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727136AbgDGTUh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 15:20:37 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037J38sr034767;
        Tue, 7 Apr 2020 15:20:36 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082nx3408-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:36 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 037J3k4G038238;
        Tue, 7 Apr 2020 15:20:36 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082nx33ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 15:20:36 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 037JKRAP027262;
        Tue, 7 Apr 2020 19:20:35 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 306hv71389-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Apr 2020 19:20:35 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037JKXW350790726
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 19:20:33 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 432F22805E;
        Tue,  7 Apr 2020 19:20:33 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89B642805A;
        Tue,  7 Apr 2020 19:20:32 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com.com (unknown [9.85.207.206])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 19:20:32 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v7 06/15] s390/vfio-ap: sysfs attribute to display the guest CRYCB
Date:   Tue,  7 Apr 2020 15:20:06 -0400
Message-Id: <20200407192015.19887-7-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200407192015.19887-1-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_08:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 suspectscore=3 adultscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004070153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The matrix of adapters and domains configured in a guest's CRYCB may
differ from the matrix of adapters and domains assigned to the matrix mdev,
so this patch introduces a sysfs attribute to display the CRYCB of a guest
using the matrix mdev. For a matrix mdev denoted by $uuid, the crycb for a
guest using the matrix mdev can be displayed as follows:

   cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix

If a guest is not using the matrix mdev at the time the crycb is displayed,
an error (ENODEV) will be returned.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 58 +++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index b8b678032ab7..beb2e68a2b1c 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1041,6 +1041,63 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(matrix);
 
+static ssize_t guest_matrix_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
+	char *bufpos = buf;
+	unsigned long apid;
+	unsigned long apqi;
+	unsigned long apid1;
+	unsigned long apqi1;
+	unsigned long napm_bits = matrix_mdev->shadow_crycb.apm_max + 1;
+	unsigned long naqm_bits = matrix_mdev->shadow_crycb.aqm_max + 1;
+	int nchars = 0;
+	int n;
+
+	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
+		return -ENODEV;
+
+	apid1 = find_first_bit_inv(matrix_mdev->shadow_crycb.apm, napm_bits);
+	apqi1 = find_first_bit_inv(matrix_mdev->shadow_crycb.aqm, naqm_bits);
+
+	mutex_lock(&matrix_dev->lock);
+
+	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
+		for_each_set_bit_inv(apid, matrix_mdev->shadow_crycb.apm,
+				     napm_bits) {
+			for_each_set_bit_inv(apqi,
+					     matrix_mdev->shadow_crycb.aqm,
+					     naqm_bits) {
+				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
+					    apqi);
+				bufpos += n;
+				nchars += n;
+			}
+		}
+	} else if (apid1 < napm_bits) {
+		for_each_set_bit_inv(apid, matrix_mdev->shadow_crycb.apm,
+				     napm_bits) {
+			n = sprintf(bufpos, "%02lx.\n", apid);
+			bufpos += n;
+			nchars += n;
+		}
+	} else if (apqi1 < naqm_bits) {
+		for_each_set_bit_inv(apqi, matrix_mdev->shadow_crycb.aqm,
+				     naqm_bits) {
+			n = sprintf(bufpos, ".%04lx\n", apqi);
+			bufpos += n;
+			nchars += n;
+		}
+	}
+
+	mutex_unlock(&matrix_dev->lock);
+
+	return nchars;
+}
+static DEVICE_ATTR_RO(guest_matrix);
+
 static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_assign_adapter.attr,
 	&dev_attr_unassign_adapter.attr,
@@ -1050,6 +1107,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_unassign_control_domain.attr,
 	&dev_attr_control_domains.attr,
 	&dev_attr_matrix.attr,
+	&dev_attr_guest_matrix.attr,
 	NULL,
 };
 
-- 
2.21.1

