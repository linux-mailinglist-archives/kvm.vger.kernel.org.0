Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73965536E7
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352342AbiFUPwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353178AbiFUPwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:52:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B422CE32;
        Tue, 21 Jun 2022 08:51:59 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEpoYK012145;
        Tue, 21 Jun 2022 15:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fiCQefzDGOS6Z2Yq4Nby58tdoRI98P1py3D+WCHaDyw=;
 b=I22Y+NfB8+IYjggzsAyUG9aOvaW36OJDFdaXiAfBJvfXtGJkPaiSj/IvDCmSgLNSNj9K
 dviBRrwP02jmXJhY9cREfY6rPCL/uIa/Xv24PRMsNG6hRaAaW3mesJ8zKzZhGXBgeTPs
 xPdFnao3ZlgWDErSS+iIfrDqN0ZN3uZmX9MQy5XTya2ZBgR74WTjIFAwTpOcV1F903ww
 UEBXPol/jUmX/9uxIEt+ZlADtfYhLZuGzIQBbLGwwIpEHWDz7Pl7Mu6fqgvobU+JjFgC
 e8APPepokey00VdRtChOb/Mq/0H35qYrK/hyoe/M9hUfj6yWRftDBzJV2WZc67nr4Rg+ CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug489uhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:57 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LErh48015834;
        Tue, 21 Jun 2022 15:51:56 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gug489uh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:56 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LFZtjB005563;
        Tue, 21 Jun 2022 15:51:56 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04dal.us.ibm.com with ESMTP id 3gs6b9t501-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 15:51:56 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LFps0s30015820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 15:51:54 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DAFD136051;
        Tue, 21 Jun 2022 15:51:54 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8349E136059;
        Tue, 21 Jun 2022 15:51:53 +0000 (GMT)
Received: from li-fed795cc-2ab6-11b2-a85c-f0946e4a8dff.ibm.com.com (unknown [9.160.18.227])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 15:51:53 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH v20 16/20] s390/vfio-ap: sysfs attribute to display the guest's matrix
Date:   Tue, 21 Jun 2022 11:51:30 -0400
Message-Id: <20220621155134.1932383-17-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
References: <20220621155134.1932383-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EjJ83_8T_90QEevjkHRocLCGh0D8MHJW
X-Proofpoint-ORIG-GUID: zxVAagXMMuRrLS8O8KN872pSJ03W8xzG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_08,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 48 ++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index d6f60072c63f..41fc2072a77b 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1422,28 +1422,24 @@ static ssize_t control_domains_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(control_domains);
 
-static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
-			   char *buf)
+static ssize_t vfio_ap_mdev_matrix_show(struct ap_matrix *matrix, char *buf)
 {
-	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
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
-	mutex_lock(&matrix_dev->mdevs_lock);
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
@@ -1452,25 +1448,50 @@ static ssize_t matrix_show(struct device *dev, struct device_attribute *attr,
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
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
+
+	mutex_lock(&matrix_dev->mdevs_lock);
+	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->matrix, buf);
 	mutex_unlock(&matrix_dev->mdevs_lock);
 
 	return nchars;
 }
 static DEVICE_ATTR_RO(matrix);
 
+static ssize_t guest_matrix_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	ssize_t nchars;
+	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
+
+	mutex_lock(&matrix_dev->mdevs_lock);
+	nchars = vfio_ap_mdev_matrix_show(&matrix_mdev->shadow_apcb, buf);
+	mutex_unlock(&matrix_dev->mdevs_lock);
+
+	return nchars;
+}
+static DEVICE_ATTR_RO(guest_matrix);
+
 static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_assign_adapter.attr,
 	&dev_attr_unassign_adapter.attr,
@@ -1480,6 +1501,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
 	&dev_attr_unassign_control_domain.attr,
 	&dev_attr_control_domains.attr,
 	&dev_attr_matrix.attr,
+	&dev_attr_guest_matrix.attr,
 	NULL,
 };
 
-- 
2.35.3

