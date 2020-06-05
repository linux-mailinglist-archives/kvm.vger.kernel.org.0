Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E861F0235
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgFEVlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:41:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728865AbgFEVkU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:40:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LY98S187497;
        Fri, 5 Jun 2020 17:40:16 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f903vgt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:15 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055LYG8T188144;
        Fri, 5 Jun 2020 17:40:15 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f903vgsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:40:15 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055LYdm8020857;
        Fri, 5 Jun 2020 21:40:14 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 31bwg41m08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:40:14 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055LeCAv54788382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:13 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E24ABAC059;
        Fri,  5 Jun 2020 21:40:12 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79883AC060;
        Fri,  5 Jun 2020 21:40:12 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.146.208])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 21:40:12 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v8 07/16] s390/vfio-ap: sysfs attribute to display the guest's matrix
Date:   Fri,  5 Jun 2020 17:39:55 -0400
Message-Id: <20200605214004.14270-8-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 cotscore=-2147483648
 phishscore=0 suspectscore=3 impostorscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050159
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The matrix of adapters and domains configured in a guest's CRYCB may
differ from the matrix of adapters and domains assigned to the matrix mdev,
so this patch introduces a sysfs attribute to display the matrix of a guest
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
index b5ed36e2c948..779659074776 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1086,6 +1086,63 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
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
+	unsigned long napm_bits = matrix_mdev->shadow_apcb.apm_max + 1;
+	unsigned long naqm_bits = matrix_mdev->shadow_apcb.aqm_max + 1;
+	int nchars = 0;
+	int n;
+
+	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
+		return -ENODEV;
+
+	apid1 = find_first_bit_inv(matrix_mdev->shadow_apcb.apm, napm_bits);
+	apqi1 = find_first_bit_inv(matrix_mdev->shadow_apcb.aqm, naqm_bits);
+
+	mutex_lock(&matrix_dev->lock);
+
+	if ((apid1 < napm_bits) && (apqi1 < naqm_bits)) {
+		for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
+				     napm_bits) {
+			for_each_set_bit_inv(apqi,
+					     matrix_mdev->shadow_apcb.aqm,
+					     naqm_bits) {
+				n = sprintf(bufpos, "%02lx.%04lx\n", apid,
+					    apqi);
+				bufpos += n;
+				nchars += n;
+			}
+		}
+	} else if (apid1 < napm_bits) {
+		for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm,
+				     napm_bits) {
+			n = sprintf(bufpos, "%02lx.\n", apid);
+			bufpos += n;
+			nchars += n;
+		}
+	} else if (apqi1 < naqm_bits) {
+		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
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
@@ -1095,6 +1152,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_unassign_control_domain.attr,
 	&dev_attr_control_domains.attr,
 	&dev_attr_matrix.attr,
+	&dev_attr_guest_matrix.attr,
 	NULL,
 };
 
-- 
2.21.1

