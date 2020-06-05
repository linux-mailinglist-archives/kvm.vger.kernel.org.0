Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EE31F022F
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgFEVlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:41:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729009AbgFEVlT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 17:41:19 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 055LVxYW083839;
        Fri, 5 Jun 2020 17:41:18 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f9dgbjaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:41:18 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 055LYnlj099159;
        Fri, 5 Jun 2020 17:41:17 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31f9dgbja2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 17:41:17 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 055La7A2019775;
        Fri, 5 Jun 2020 21:41:16 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 31bf4bje21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Jun 2020 21:41:16 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 055LeFf249086960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Jun 2020 21:40:15 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07140AC059;
        Fri,  5 Jun 2020 21:40:15 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EDFCAC069;
        Fri,  5 Jun 2020 21:40:14 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com.com (unknown [9.85.146.208])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  5 Jun 2020 21:40:14 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v8 11/16] s390/vfio-ap: allow configuration of matrix mdev in use by a KVM guest
Date:   Fri,  5 Jun 2020 17:39:59 -0400
Message-Id: <20200605214004.14270-12-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200605214004.14270-1-akrowiak@linux.ibm.com>
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-05_07:2020-06-04,2020-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 priorityscore=1501 suspectscore=3 bulkscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current support for pass-through crypto adapters does not allow
configuration of a matrix mdev when it is in use by a KVM guest. Let's
allow AP resources - i.e., adapters, domains and control domains - to be
assigned to or unassigned from a matrix mdev while it is in use by a guest.
This is in preparation for the introduction of support for dynamic
configuration of the AP matrix for a running KVM guest.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 68bdf80807c6..4f59f471b4d3 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -773,10 +773,6 @@ static ssize_t assign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -828,10 +824,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of adapter */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apid);
 	if (ret)
 		return ret;
@@ -891,10 +883,6 @@ static ssize_t assign_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_apqi = matrix_mdev->matrix.aqm_max;
 
-	/* If the guest is running, disallow assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -946,10 +934,6 @@ static ssize_t unassign_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow un-assignment of domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &apqi);
 	if (ret)
 		return ret;
@@ -991,10 +975,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	struct mdev_device *mdev = mdev_from_dev(dev);
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	/* If the guest is running, disallow assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &id);
 	if (ret)
 		return ret;
@@ -1036,10 +1016,6 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 	unsigned long max_domid =  matrix_mdev->matrix.adm_max;
 
-	/* If the guest is running, disallow un-assignment of control domain */
-	if (matrix_mdev->kvm)
-		return -EBUSY;
-
 	ret = kstrtoul(buf, 0, &domid);
 	if (ret)
 		return ret;
-- 
2.21.1

