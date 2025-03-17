Return-Path: <kvm+bounces-41322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EE79A66317
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38BFA3BAB8D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF31205E14;
	Mon, 17 Mar 2025 23:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g+X49lRw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D6420767C;
	Mon, 17 Mar 2025 23:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255519; cv=none; b=eJytdDjMQ2t5LpoIfo0qRUeeDeEmpeRmdmHbG1SgL7tDBjANJb7lnVDKt35gHnD2Zw2tIXvViaAdqhmACzh/dJbqJb4Z97W0pMfl+I/6jeU42t48oFzr0q0MuMtNmpyK/whDEysMiYXZraUuV1qG3/tesCcvH9Dm3lIVbcu65Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255519; c=relaxed/simple;
	bh=OgnMZRIb4KuaIR+yrkQTPRXaChBOh+ZERFiFvFxRyYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsrARMofb9Vf7wRyGmGANdayxj8qL/QwQMVLvU8ejoX7/S+drY1k1JEX555Bi7wHItdTtJnYvH+gmua9VB7BY1toWImuvO7ludQrtvkdvCY+ecwNiy/RL6MPIQLeYpyPfnEBuJoQ92Ger2bGc0Dhr6sWTQLI/XDB14UgKKp55jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g+X49lRw; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLuMBj015669;
	Mon, 17 Mar 2025 23:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=+XOTC
	9pz82P20Xg/2ro1a2zYqMb8dPZtzJNmUkuU634=; b=g+X49lRwTFC6k9Oc47CBA
	uoTXTcQnCuc/v1dTFueQrLLmzcVPt8T4oN3m2xR6bMyXqvnEufHYLKBtk0N3gSXa
	J6mjzUcT/ikdABEoE5tsi1tbs/hIULkZw0QfVJW5cXGflnWJM5gJFNrIfiwRAei4
	LGlNFiFNto54Mc8KUrN4+o6ycGQPM3aIXITCjN6JzGXJ2kpw3jv2CCvqkFCaY5VX
	26/xnbY7QFyj/8LgoZkfhlfuo82FEm1hRo6Ca4wCHpJHhlRjssDWAXLV+uGKGYux
	K0GA6Pa5BoTcsJ8Y5FRKuZTqUQ0elQAkEucv/fkIfaWrVVZouqHKerQnfHnZV4Ng
	Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1k9v3kt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HMpFrV022350;
	Mon, 17 Mar 2025 23:51:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeekfb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:51 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52HNpi2v016519;
	Mon, 17 Mar 2025 23:51:50 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeekf68-9;
	Mon, 17 Mar 2025 23:51:50 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/10] vhost-scsi: log control queue write descriptors
Date: Mon, 17 Mar 2025 16:55:16 -0700
Message-ID: <20250317235546.4546-9-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250317235546.4546-1-dongli.zhang@oracle.com>
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_10,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503170173
X-Proofpoint-GUID: qLU11NXZjyAKZCdscUKrPyDj3Raof1-W
X-Proofpoint-ORIG-GUID: qLU11NXZjyAKZCdscUKrPyDj3Raof1-W

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
index 8a1b0a19fe58..3cdc5c2fa60e 100644
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
@@ -431,6 +437,10 @@ static void vhost_scsi_release_tmf_res(struct vhost_scsi_tmf *tmf)
 {
 	struct vhost_scsi_inflight *inflight = tmf->inflight;
 
+	/*
+	 * tmf->tmf_log is default NULL unless VHOST_F_LOG_ALL is set.
+	 */
+	kfree(tmf->tmf_log);
 	kfree(tmf);
 	vhost_scsi_put_inflight(inflight);
 }
@@ -1516,6 +1526,8 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 	mutex_lock(&tmf->svq->vq.mutex);
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
+	vhost_scsi_log_write(&tmf->svq->vq, tmf->tmf_log,
+			     tmf->tmf_log_num);
 	mutex_unlock(&tmf->svq->vq.mutex);
 
 	vhost_scsi_release_tmf_res(tmf);
@@ -1539,7 +1551,8 @@ static void
 vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
 		      struct vhost_virtqueue *vq,
 		      struct virtio_scsi_ctrl_tmf_req *vtmf,
-		      struct vhost_scsi_ctx *vc)
+		      struct vhost_scsi_ctx *vc,
+		      struct vhost_log *log, unsigned int log_num)
 {
 	struct vhost_scsi_virtqueue *svq = container_of(vq,
 					struct vhost_scsi_virtqueue, vq);
@@ -1567,6 +1580,19 @@ vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
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
@@ -1580,6 +1606,7 @@ vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
 send_reject:
 	vhost_scsi_send_tmf_resp(vs, vq, vc->in, vc->head, &vq->iov[vc->out],
 				 VIRTIO_SCSI_S_FUNCTION_REJECTED);
+	vhost_scsi_log_write(vq, log, log_num);
 }
 
 static void
@@ -1616,6 +1643,8 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	struct vhost_scsi_ctx vc;
 	size_t typ_size;
 	int ret, c = 0;
+	struct vhost_log *vq_log;
+	unsigned int log_num;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1629,8 +1658,11 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	vhost_disable_notify(&vs->dev, vq);
 
+	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
+		vq->log : NULL;
+
 	do {
-		ret = vhost_scsi_get_desc(vs, vq, &vc, NULL, NULL);
+		ret = vhost_scsi_get_desc(vs, vq, &vc, vq_log, &log_num);
 		if (ret)
 			goto err;
 
@@ -1694,9 +1726,12 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
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
@@ -1706,11 +1741,13 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
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


