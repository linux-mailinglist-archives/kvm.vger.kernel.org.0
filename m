Return-Path: <kvm+bounces-3926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D1280A8BC
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8F6C2817F8
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FE5338FA8;
	Fri,  8 Dec 2023 16:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EUocNr8f"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8121199D;
	Fri,  8 Dec 2023 08:23:05 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8GIEBS020700;
	Fri, 8 Dec 2023 16:23:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OMt9lUxteJ3PnJ8WN1U5G+vp9nxVLOAH2K9zcnmF8oI=;
 b=EUocNr8f015GB/7JpPZNcCbntuwkg/9g92iQOky4fAjXNgt4fk6+HOvMxnBQ6IjKV0L7
 p4OEbA/iXCefmac4IH5JYTac35FrJg7YFT1+oUeTCxoZY6YRdspV4GPRuFAbJa8iPk3s
 lAZeTDyjZlPAS2EKkhqcjKzhPDlWFSSmJFzBQmQU/5GHM39OkKGf7FuzkEvT//K5D1ZK
 uXrcLMT+w1DipZuTLPcuHgS10bt0bV1SRPoLPyHlPWBvPWQTFq67M0Y8Qw5jxT9mX8cw
 ugKX5jywDFUyhE2faqMs78I8aNLsjtLG8MI6Hr31B1DAu8jJJSqIRyY7uUbgOydMoDSt Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv6htr69g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:02 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B8GJbLX026875;
	Fri, 8 Dec 2023 16:23:02 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv6htr697-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:02 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8GGTeJ013775;
	Fri, 8 Dec 2023 16:23:01 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3utau4jhwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:01 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B8GN02366388470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Dec 2023 16:23:00 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A1EF58054;
	Fri,  8 Dec 2023 16:23:00 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F2355803F;
	Fri,  8 Dec 2023 16:22:59 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.47.9])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 Dec 2023 16:22:59 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH v1 1/6] s390/vfio-ap: always filter entire AP matrix
Date: Fri,  8 Dec 2023 11:22:46 -0500
Message-ID: <20231208162256.10633-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231208162256.10633-1-akrowiak@linux.ibm.com>
References: <20231208162256.10633-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qUSVKKoVjqtKdkQZUcqsTsJXkSvjIffa
X-Proofpoint-ORIG-GUID: m1PGbWmuOwuuoXgTVb3MtT8QitWPbwDg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_11,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080135

The vfio_ap_mdev_filter_matrix function is called whenever a new adapter or
domain is assigned to the mdev. The purpose of the function is to update
the guest's AP configuration by filtering the matrix of adapters and
domains assigned to the mdev. When an adapter or domain is assigned, only
the APQNs associated with the APID of the new adapter or APQI of the new
domain are inspected. If an APQN does not reference a queue device bound to
the vfio_ap device driver, then it's APID will be filtered from the mdev's
matrix when updating the guest's AP configuration.

Inspecting only the APID of the new adapter or APQI of the new domain will
result in passing AP queues through to a guest that are not bound to the
vfio_ap device driver under certain circumstances. Consider the following:

guest's AP configuration (all also assigned to the mdev's matrix):
14.0004
14.0005
14.0006
16.0004
16.0005
16.0006

unassign domain 4
unbind queue 16.0005
assign domain 4

When domain 4 is re-assigned, since only domain 4 will be inspected, the
APQNs that will be examined will be:
14.0004
16.0004

Since both of those APQNs reference queue devices that are bound to the
vfio_ap device driver, nothing will get filtered from the mdev's matrix
when updating the guest's AP configuration. Consequently, queue 16.0005
will get passed through despite not being bound to the driver. This
violates the linux device model requirement that a guest shall only be
given access to devices bound to the device driver facilitating their
pass-through.

To resolve this problem, every adapter and domain assigned to the mdev will
be inspected when filtering the mdev's matrix.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Fixes: 48cae940c31d ("s390/vfio-ap: refresh guest's APCB by filtering AP resources assigned to mdev")
Cc: <stable@vger.kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 57 +++++++++----------------------
 1 file changed, 17 insertions(+), 40 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 4db538a55192..9382b32e5bd1 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -670,8 +670,7 @@ static bool vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
  * Return: a boolean value indicating whether the KVM guest's APCB was changed
  *	   by the filtering or not.
  */
-static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
-				       struct ap_matrix_mdev *matrix_mdev)
+static bool vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
 {
 	unsigned long apid, apqi, apqn;
 	DECLARE_BITMAP(prev_shadow_apm, AP_DEVICES);
@@ -692,8 +691,8 @@ static bool vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned long *aqm,
 	bitmap_and(matrix_mdev->shadow_apcb.aqm, matrix_mdev->matrix.aqm,
 		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
 
-	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
-		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
+	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
 			/*
 			 * If the APQN is not bound to the vfio_ap device
 			 * driver, then we can't assign it to the guest's
@@ -958,7 +957,6 @@ static ssize_t assign_adapter_store(struct device *dev,
 {
 	int ret;
 	unsigned long apid;
-	DECLARE_BITMAP(apm_delta, AP_DEVICES);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&ap_perms_mutex);
@@ -987,11 +985,8 @@ static ssize_t assign_adapter_store(struct device *dev,
 	}
 
 	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
-	memset(apm_delta, 0, sizeof(apm_delta));
-	set_bit_inv(apid, apm_delta);
 
-	if (vfio_ap_mdev_filter_matrix(apm_delta,
-				       matrix_mdev->matrix.aqm, matrix_mdev))
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
 		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
 
 	ret = count;
@@ -1167,7 +1162,6 @@ static ssize_t assign_domain_store(struct device *dev,
 {
 	int ret;
 	unsigned long apqi;
-	DECLARE_BITMAP(aqm_delta, AP_DOMAINS);
 	struct ap_matrix_mdev *matrix_mdev = dev_get_drvdata(dev);
 
 	mutex_lock(&ap_perms_mutex);
@@ -1196,11 +1190,8 @@ static ssize_t assign_domain_store(struct device *dev,
 	}
 
 	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
-	memset(aqm_delta, 0, sizeof(aqm_delta));
-	set_bit_inv(apqi, aqm_delta);
 
-	if (vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm, aqm_delta,
-				       matrix_mdev))
+	if (vfio_ap_mdev_filter_matrix(matrix_mdev))
 		vfio_ap_mdev_update_guest_apcb(matrix_mdev);
 
 	ret = count;
@@ -2091,9 +2082,7 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
 	if (matrix_mdev) {
 		vfio_ap_mdev_link_queue(matrix_mdev, q);
 
-		if (vfio_ap_mdev_filter_matrix(matrix_mdev->matrix.apm,
-					       matrix_mdev->matrix.aqm,
-					       matrix_mdev))
+		if (vfio_ap_mdev_filter_matrix(matrix_mdev))
 			vfio_ap_mdev_update_guest_apcb(matrix_mdev);
 	}
 	dev_set_drvdata(&apdev->device, q);
@@ -2443,34 +2432,22 @@ void vfio_ap_on_cfg_changed(struct ap_config_info *cur_cfg_info,
 
 static void vfio_ap_mdev_hot_plug_cfg(struct ap_matrix_mdev *matrix_mdev)
 {
-	bool do_hotplug = false;
-	int filter_domains = 0;
-	int filter_adapters = 0;
-	DECLARE_BITMAP(apm, AP_DEVICES);
-	DECLARE_BITMAP(aqm, AP_DOMAINS);
+	bool filter_domains, filter_adapters, filter_cdoms, do_hotplug = false;
 
 	mutex_lock(&matrix_mdev->kvm->lock);
 	mutex_lock(&matrix_dev->mdevs_lock);
 
-	filter_adapters = bitmap_and(apm, matrix_mdev->matrix.apm,
-				     matrix_mdev->apm_add, AP_DEVICES);
-	filter_domains = bitmap_and(aqm, matrix_mdev->matrix.aqm,
-				    matrix_mdev->aqm_add, AP_DOMAINS);
-
-	if (filter_adapters && filter_domains)
-		do_hotplug |= vfio_ap_mdev_filter_matrix(apm, aqm, matrix_mdev);
-	else if (filter_adapters)
-		do_hotplug |=
-			vfio_ap_mdev_filter_matrix(apm,
-						   matrix_mdev->shadow_apcb.aqm,
-						   matrix_mdev);
-	else
-		do_hotplug |=
-			vfio_ap_mdev_filter_matrix(matrix_mdev->shadow_apcb.apm,
-						   aqm, matrix_mdev);
+	filter_adapters = bitmap_intersects(matrix_mdev->matrix.apm,
+					    matrix_mdev->apm_add, AP_DEVICES);
+	filter_domains = bitmap_intersects(matrix_mdev->matrix.aqm,
+					   matrix_mdev->aqm_add, AP_DOMAINS);
+	filter_cdoms = bitmap_intersects(matrix_mdev->matrix.adm,
+					 matrix_mdev->adm_add, AP_DOMAINS);
+
+	if (filter_adapters || filter_domains)
+		do_hotplug = vfio_ap_mdev_filter_matrix(matrix_mdev);
 
-	if (bitmap_intersects(matrix_mdev->matrix.adm, matrix_mdev->adm_add,
-			      AP_DOMAINS))
+	if (filter_cdoms)
 		do_hotplug |= vfio_ap_mdev_filter_cdoms(matrix_mdev);
 
 	if (do_hotplug)
-- 
2.43.0


