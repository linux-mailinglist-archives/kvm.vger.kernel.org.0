Return-Path: <kvm+bounces-42545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07402A79C13
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:35:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F8C31666DA
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 06:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DED31EFFB5;
	Thu,  3 Apr 2025 06:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S7hEXB3D"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA1E1DE2BF;
	Thu,  3 Apr 2025 06:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743661963; cv=none; b=QgaRCwNwmvO1qasIbmjGBpJBNMtp6nfLyQTLnUrGe/Ivfqpupm4GS+ijFhn71/lDUjRZbVsJWsNtF3ab+CrXhHV1QvLy0EIQLT5z90kytGv7ArhuxuffX8Y9RsKRo4CO7Gk5fH8mFzMkjGC4nEBa1ieotqNJyAqBMuwrI8xs+SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743661963; c=relaxed/simple;
	bh=ESjrnkjN1KlWYcJXLAvBLlX+IycuvkgUs47cNAvMudI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHTWvBiYtZPoiumsi4vMwEDGOz4HC9cRkIE+zjCGf2E1QsBwxjsVtwCgXCaRFwK0ZS4lTE4yae4Q8xv54IoIaHH9KjgNvawm+A4Gz3+MZOQ7IO+OdmQI/YaEDsheL9IWIPXuAIDkbc8UmETdEK8wVt5n2dzOyCtddylDOQMzHwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S7hEXB3D; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 532NMpNe032001;
	Thu, 3 Apr 2025 06:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=mnAj5
	UBH6pC6WQS9XPV3FvOrhCZZK2KBwTaEagzFiR4=; b=S7hEXB3DmA7c+UMXw57Zx
	MPAhzXklMDsqMjwD1q8snJpv3sZMgvE+gs0khKmh6PmfK3q8yfUb0t36iCNBF4Yo
	uc6sVhuK5Fx+xH4Qyx84QadlFYJReOgSjrQWrCjic014dOyuWPvDZS0DFi66/BwC
	nvc3OcXNll3r0MGxd1E5N/wfyGpcF/SEJkapVngb7pOTanOz++GeLiv+ssM1rSNf
	NMc5Sj43AxDcG7Z387KFV+GUycpcACb4klYijPeUuxQAXv7OiN4MiEQl6VuFUsnh
	PrlT+DBI1NGP1QKIT8WkudVgmW1mmB0GEGM7L8+7LHluilwK8+AIrto/By6VU8+B
	A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p8fscgjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5336L1Ju003525;
	Thu, 3 Apr 2025 06:32:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45pr8stj88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:35 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5336WTxH032092;
	Thu, 3 Apr 2025 06:32:35 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45pr8stj4h-8;
	Thu, 03 Apr 2025 06:32:35 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/9] vhost-scsi: log control queue write descriptors
Date: Wed,  2 Apr 2025 23:29:52 -0700
Message-ID: <20250403063028.16045-8-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250403063028.16045-1-dongli.zhang@oracle.com>
References: <20250403063028.16045-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-03_02,2025-04-02_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504030033
X-Proofpoint-ORIG-GUID: rzqAmfnlV6MgS0TAwVWWsl5gMDR3KGx9
X-Proofpoint-GUID: rzqAmfnlV6MgS0TAwVWWsl5gMDR3KGx9

Log write descriptors for the control queue, leveraging
vhost_scsi_get_desc() and vhost_get_vq_desc() to retrieve the array of
write descriptors to obtain the log buffer.

For Task Management Requests, similar to the I/O queue, store the log
buffer during the submission path and log it in the completion or error
handling path.

For Asynchronous Notifications, only the submission path is involved.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - Call kfree(tmf->tmf_log) unconditionally.
  - Return VIRTIO_SCSI_S_FUNCTION_REJECTED on log buffer allocation failure.

 drivers/vhost/scsi.c | 47 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index af7b0ee42b6d..1a1a4cd95ace 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -263,6 +263,12 @@ struct vhost_scsi_tmf {
 	struct iovec resp_iov;
 	int in_iovs;
 	int vq_desc;
+
+	/*
+	 * Dirty write descriptors of this command.
+	 */
+	struct vhost_log *tmf_log;
+	unsigned int tmf_log_num;
 };
 
 /*
@@ -452,6 +458,10 @@ static void vhost_scsi_release_tmf_res(struct vhost_scsi_tmf *tmf)
 {
 	struct vhost_scsi_inflight *inflight = tmf->inflight;
 
+	/*
+	 * tmf->tmf_log is default NULL unless VHOST_F_LOG_ALL is set.
+	 */
+	kfree(tmf->tmf_log);
 	kfree(tmf);
 	vhost_scsi_put_inflight(inflight);
 }
@@ -1537,6 +1547,8 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 	mutex_lock(&tmf->svq->vq.mutex);
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
+	vhost_scsi_log_write(&tmf->svq->vq, tmf->tmf_log,
+			     tmf->tmf_log_num);
 	mutex_unlock(&tmf->svq->vq.mutex);
 
 	vhost_scsi_release_tmf_res(tmf);
@@ -1560,7 +1572,8 @@ static void
 vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
 		      struct vhost_virtqueue *vq,
 		      struct virtio_scsi_ctrl_tmf_req *vtmf,
-		      struct vhost_scsi_ctx *vc)
+		      struct vhost_scsi_ctx *vc,
+		      struct vhost_log *log, unsigned int log_num)
 {
 	struct vhost_scsi_virtqueue *svq = container_of(vq,
 					struct vhost_scsi_virtqueue, vq);
@@ -1588,6 +1601,19 @@ vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
 	tmf->in_iovs = vc->in;
 	tmf->inflight = vhost_scsi_get_inflight(vq);
 
+	if (unlikely(log && log_num)) {
+		tmf->tmf_log = kmalloc_array(log_num, sizeof(*tmf->tmf_log),
+					     GFP_KERNEL);
+		if (tmf->tmf_log) {
+			memcpy(tmf->tmf_log, log, sizeof(*tmf->tmf_log) * log_num);
+			tmf->tmf_log_num = log_num;
+		} else {
+			pr_err("vhost_scsi tmf log allocation error\n");
+			vhost_scsi_release_tmf_res(tmf);
+			goto send_reject;
+		}
+	}
+
 	if (target_submit_tmr(&tmf->se_cmd, tpg->tpg_nexus->tvn_se_sess, NULL,
 			      vhost_buf_to_lun(vtmf->lun), NULL,
 			      TMR_LUN_RESET, GFP_KERNEL, 0,
@@ -1601,6 +1627,7 @@ vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
 send_reject:
 	vhost_scsi_send_tmf_resp(vs, vq, vc->in, vc->head, &vq->iov[vc->out],
 				 VIRTIO_SCSI_S_FUNCTION_REJECTED);
+	vhost_scsi_log_write(vq, log, log_num);
 }
 
 static void
@@ -1637,6 +1664,8 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	struct vhost_scsi_ctx vc;
 	size_t typ_size;
 	int ret, c = 0;
+	struct vhost_log *vq_log;
+	unsigned int log_num;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1650,8 +1679,11 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	vhost_disable_notify(&vs->dev, vq);
 
+	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
+		vq->log : NULL;
+
 	do {
-		ret = vhost_scsi_get_desc(vs, vq, &vc, NULL, NULL);
+		ret = vhost_scsi_get_desc(vs, vq, &vc, vq_log, &log_num);
 		if (ret)
 			goto err;
 
@@ -1715,9 +1747,12 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			goto err;
 
 		if (v_req.type == VIRTIO_SCSI_T_TMF)
-			vhost_scsi_handle_tmf(vs, tpg, vq, &v_req.tmf, &vc);
-		else
+			vhost_scsi_handle_tmf(vs, tpg, vq, &v_req.tmf, &vc,
+					      vq_log, log_num);
+		else {
 			vhost_scsi_send_an_resp(vs, vq, &vc);
+			vhost_scsi_log_write(vq, vq_log, log_num);
+		}
 err:
 		/*
 		 * ENXIO:  No more requests, or read error, wait for next kick
@@ -1727,11 +1762,13 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 */
 		if (ret == -ENXIO)
 			break;
-		else if (ret == -EIO)
+		else if (ret == -EIO) {
 			vhost_scsi_send_bad_target(vs, vq, &vc,
 						   v_req.type == VIRTIO_SCSI_T_TMF ?
 						   TYPE_CTRL_TMF :
 						   TYPE_CTRL_AN);
+			vhost_scsi_log_write(vq, vq_log, log_num);
+		}
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
-- 
2.39.3


