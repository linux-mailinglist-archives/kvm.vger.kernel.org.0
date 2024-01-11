Return-Path: <kvm+bounces-6093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B8C82B0E2
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 15:43:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A65B283892
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 14:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418634CB4D;
	Thu, 11 Jan 2024 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a1MFfxgh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A814C609;
	Thu, 11 Jan 2024 14:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40BEgDC8001664;
	Thu, 11 Jan 2024 14:42:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dcx+fQlNvklHss1smKNW/OV7lDvnCE6ScxETeVWqgh4=;
 b=a1MFfxgh8WGzF5PCgIcgKeXWdievSacns+YE4b6220XP6YNv+ZeSA6HmQTu+8HQPY05E
 LxxV3t/22BfMOvcxTGJo5HQtDTJl3KCQxcuQ3vK4K1BZjwd+Zq+p7q+W4bGY5U1btt/J
 MLn07cpX8aMVjmY6uCtcaib6xYv9sDy9dXoWcmq3BFKtqDr3fpYaKaEWiAfD8TWM/0cW
 xdjfJopD90TwoQ1G7LIlMf7+PQrKm2r+FdQD3h17DBS6FqK3/BAB1GO7lM+2xWYDRf4J
 TneQxwz1fKq+maGLyF3xCcXHNEqKcg8NWszHqNUrmWzVDJvoVFTX2170atxbrTu+Qrgz PA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vjbejtynd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:42:21 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40BEgK5t002233;
	Thu, 11 Jan 2024 14:42:20 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vjbejtyek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:42:20 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40BCZ6cX004407;
	Thu, 11 Jan 2024 14:38:52 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfjpm3tv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:38:52 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40BEcoHe36372808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jan 2024 14:38:50 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A28045805F;
	Thu, 11 Jan 2024 14:38:50 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB29758059;
	Thu, 11 Jan 2024 14:38:49 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.174.181])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jan 2024 14:38:49 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org
Subject: [PATCH v3 2/6] s390/vfio-ap: loop over the shadow APCB when filtering guest's AP configuration
Date: Thu, 11 Jan 2024 09:38:36 -0500
Message-ID: <20240111143846.8801-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240111143846.8801-1-akrowiak@linux.ibm.com>
References: <20240111143846.8801-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QGi6iCLRRzr9qFfhbWi_BQw1KbWfhcDt
X-Proofpoint-ORIG-GUID: UaHmhr1pUBiWCYr9LrT0OttSC9WVBg_U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_07,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401110116

While filtering the mdev matrix, it doesn't make sense - and will have
unexpected results - to filter an APID from the matrix if the APID or one
of the associated APQIs is not in the host's AP configuration. There are
two reasons for this:

1. An adapter or domain that is not in the host's AP configuration can be
   assigned to the matrix; this is known as over-provisioning. Queue
   devices, however, are only created for adapters and domains in the
   host's AP configuration, so there will be no queues associated with an
   over-provisioned adapter or domain to filter.

2. The adapter or domain may have been externally removed from the host's
   configuration via an SE or HMC attached to a DPM enabled LPAR. In this
   case, the vfio_ap device driver would have been notified by the AP bus
   via the on_config_changed callback and the adapter or domain would
   have already been filtered.

Since the matrix_mdev->shadow_apcb.apm and matrix_mdev->shadow_apcb.aqm are
copied from the mdev matrix sans the APIDs and APQIs not in the host's AP
configuration, let's loop over those bitmaps instead of those assigned to
the matrix.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Fixes: 48cae940c31d ("s390/vfio-ap: refresh guest's APCB by filtering AP resources assigned to mdev")
Cc: <stable@vger.kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 9382b32e5bd1..47232e19a50e 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -691,8 +691,9 @@ static bool vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
 	bitmap_and(matrix_mdev->shadow_apcb.aqm, matrix_mdev->matrix.aqm,
 		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
 
-	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES) {
-		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS) {
+	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
+				     AP_DOMAINS) {
 			/*
 			 * If the APQN is not bound to the vfio_ap device
 			 * driver, then we can't assign it to the guest's
-- 
2.43.0


