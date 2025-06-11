Return-Path: <kvm+bounces-49076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49051AD5913
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 16:41:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A5663A7ADD
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DB7E2BD5BB;
	Wed, 11 Jun 2025 14:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DINZXAat"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DABD2690F4;
	Wed, 11 Jun 2025 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749652784; cv=none; b=HcfCmXh7m2f80j9aMfaPq0SJ/uguQ5nbz8aFBgQLeSCU5qClvFHQfwkVX71cXncV3DFNfUTMLDQvLGckBpMeNUIBefkkh/OrThcivCuUcQEDy9yy6p1WQhlsLw5lBxoZoTdIIiF8NTfXtDIoVh0oP/DvSn5o7RJZmYycjoK+wiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749652784; c=relaxed/simple;
	bh=aqypGgqD5Z1GVJzaOtiUWHGS5FYKgTtrDXNfRtBkNVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kdKJXPYMaLL3PQ7OQ329m9CHruzzhAhpNckr7qfh9oDIKVV+UcPosCUHqvAfn98lESJMltfo42CgxaIlnyNOBxHiYBbNhv5gA7Np7Y98hDlPtrITwEdlJUPmt0URhfRIkXic+nft8M+z/zIMDMlZ+Rv7A35IciBSJaRiC3xI9L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DINZXAat; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BEdFdP010522;
	Wed, 11 Jun 2025 14:39:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=+MbQXWPeLML3LfbjNcfAYDmrMVvqa
	WCRa0dvaIisA3M=; b=DINZXAatO86U3hlxEdSrT/AP4kfGqwbv8Z1mx96Q+xSky
	NUFxqnlhNeU/6oe8r5ac/21i04SUm9QKIYkjgWHF1Ob48GTI0oHECPLftLsLuNcl
	9fAwju5rvZdy2//fWU4bwrB0yPywCSMnDvW7rYw4oEZePRXc0VKKq1BV2QE8oKW4
	AVppmjRnHRYTAX7yCu6uGD7KXIbsfKBTYxjIpmEdjyNtKuCD6eT5sYTNi3Db4U4T
	txhqfFGBAV80bIWiWiqLuIAXz6oNkLUqztPW2SN+IQrBsH3/B6rbzTDUZX76gHII
	hxEk4eCthKZkHEH0L1nxqtkQfZlT6Rdi7dH+uo4Mw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4752xjxyhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 14:39:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55BE1llZ021378;
	Wed, 11 Jun 2025 14:39:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvb0crr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 14:39:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55BEda1m013641;
	Wed, 11 Jun 2025 14:39:36 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 474bvb0cr1-1;
	Wed, 11 Jun 2025 14:39:35 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, darren.kenny@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vhost-scsi: Fix typos and formatting in comments and logs
Date: Wed, 11 Jun 2025 07:39:21 -0700
Message-ID: <20250611143932.2443796-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_05,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506110122
X-Authority-Analysis: v=2.4 cv=K4AiHzWI c=1 sm=1 tr=0 ts=68499529 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=C3Wo5I0qEXIME_MCgsYA:9 cc=ntf awl=host:13206
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDEyMyBTYWx0ZWRfX8QdIum7iYPdu YYxfQnC0Ddc5lXR1VFfIjnKFWFWa6IlT8vxweUYw9JAwjOqMVZXmRCoItNowjz7golvsFMwacEs 2f3DwTe2Pz42rKzoo3s6IYxD77lO/U+Vg5M3goHA+7ATb6tctCq8Ke9GpzVG8ZD94TeQhT1QcKF
 APa9uwP+i2SEyr+orNNVQMJoSyd54OSmt0qkvqoCxV8aNCA0o9CyPKCw3scIH77mOreRUG9EheD NQ6YDfwsLqzdf9XeJM7nji2DFqDKmuguQlu8Qy6e2mIC2GVbpTVhWHEKEM6MpHaHiBt3ZEfiva0 0qPI42IKTcjse3iL5qIOd9D+YRIsXaWgX4KSLP5mNxdax8kGH+zZSBa7VrLIosBzwskfhmVo2PK
 3w4VLbWeCdIo8eTIYbeyUluhh33fQuc+DCIM7Ia+a2UR62vRK028V7gbCKWOX9/buTY2fyNU
X-Proofpoint-ORIG-GUID: 72saJQB-Odq-BQtwRVcSZu6Kv3VxDEVK
X-Proofpoint-GUID: 72saJQB-Odq-BQtwRVcSZu6Kv3VxDEVK

This patch corrects several minor typos and formatting issues.
Changes include:

Fixing misspellings like in comments
- "explict" -> "explicit"
- "infight" -> "inflight",
- "with generate" -> "will generate"

formatting in logs
- Correcting log formatting specifier from "%dd" to "%d"
- Adding a missing space in the sysfs emit string to prevent
  misinterpreted output like "X86_64on ". changing to "X86_64 on "
- Cleaning up stray semicolons in struct definition endings

These changes improve code readability and consistency.
no functionality changes.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/vhost/scsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c12a0d4e6386..508ff3b29f39 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -152,7 +152,7 @@ struct vhost_scsi_nexus {
 struct vhost_scsi_tpg {
 	/* Vhost port target portal group tag for TCM */
 	u16 tport_tpgt;
-	/* Used to track number of TPG Port/Lun Links wrt to explict I_T Nexus shutdown */
+	/* Used to track number of TPG Port/Lun Links wrt to explicit I_T Nexus shutdown */
 	int tv_tpg_port_count;
 	/* Used for vhost_scsi device reference to tpg_nexus, protected by tv_tpg_mutex */
 	int tv_tpg_vhost_count;
@@ -311,12 +311,12 @@ static void vhost_scsi_init_inflight(struct vhost_scsi *vs,
 
 		mutex_lock(&vq->mutex);
 
-		/* store old infight */
+		/* store old inflight */
 		idx = vs->vqs[i].inflight_idx;
 		if (old_inflight)
 			old_inflight[i] = &vs->vqs[i].inflights[idx];
 
-		/* setup new infight */
+		/* setup new inflight */
 		vs->vqs[i].inflight_idx = idx ^ 1;
 		new_inflight = &vs->vqs[i].inflights[idx ^ 1];
 		kref_init(&new_inflight->kref);
@@ -1249,7 +1249,7 @@ vhost_scsi_setup_resp_iovs(struct vhost_scsi_cmd *cmd, struct iovec *in_iovs,
 	if (!in_iovs_cnt)
 		return 0;
 	/*
-	 * Initiator's normally just put the virtio_scsi_cmd_resp in the first
+	 * Initiators normally just put the virtio_scsi_cmd_resp in the first
 	 * iov, but just in case they wedged in some data with it we check for
 	 * greater than or equal to the response struct.
 	 */
@@ -1457,7 +1457,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		cmd = vhost_scsi_get_cmd(vq, tag);
 		if (IS_ERR(cmd)) {
 			ret = PTR_ERR(cmd);
-			vq_err(vq, "vhost_scsi_get_tag failed %dd\n", ret);
+			vq_err(vq, "vhost_scsi_get_tag failed %d\n", ret);
 			goto err;
 		}
 		cmd->tvc_vq = vq;
@@ -2609,7 +2609,7 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 		return -ENOMEM;
 	}
 	/*
-	 * Since we are running in 'demo mode' this call with generate a
+	 * Since we are running in 'demo mode' this call will generate a
 	 * struct se_node_acl for the vhost_scsi struct se_portal_group with
 	 * the SCSI Initiator port name of the passed configfs group 'name'.
 	 */
@@ -2915,7 +2915,7 @@ static ssize_t
 vhost_scsi_wwn_version_show(struct config_item *item, char *page)
 {
 	return sysfs_emit(page, "TCM_VHOST fabric module %s on %s/%s"
-		"on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sysname,
+		" on "UTS_RELEASE"\n", VHOST_SCSI_VERSION, utsname()->sysname,
 		utsname()->machine);
 }
 
@@ -2983,13 +2983,13 @@ static int __init vhost_scsi_init(void)
 	vhost_scsi_deregister();
 out:
 	return ret;
-};
+}
 
 static void vhost_scsi_exit(void)
 {
 	target_unregister_template(&vhost_scsi_ops);
 	vhost_scsi_deregister();
-};
+}
 
 MODULE_DESCRIPTION("VHOST_SCSI series fabric driver");
 MODULE_ALIAS("tcm_vhost");
-- 
2.47.1


