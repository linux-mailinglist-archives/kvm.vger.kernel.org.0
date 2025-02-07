Return-Path: <kvm+bounces-37627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE83A2CBBF
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 19:45:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 630AF16262D
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED351D5AAD;
	Fri,  7 Feb 2025 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F24tFhzt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5121A5BA6;
	Fri,  7 Feb 2025 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953786; cv=none; b=bys8+6NrTYxwEA7JLX6+NhK8Aqw1Xt5KQeh5Tc8OeBFq3jbAZIj2wdZfJVWgq89UZXgmYMvXw+J+wMrAn4Gb1M3jVUXvm4b96IW64gqu3t6HFH7A8xvWqKKfbW9+1CMqn+J74HPFtgp2ICIfaldJTEnc39KxhhVgYV3BWTeFijU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953786; c=relaxed/simple;
	bh=zhRWT2vQ4ShDv7JFRICZwj/3J9l5AAj3S7LYGhL+nx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oopUU5qr0pSVjOEUP5WNLY37YZKnVAGY1Q6c/ku5JnP+DTyDxOtM3rfdlxdGHzkqzbEZH1ZDnR7M/8DWc6Lyzt0/W8WeEnkqpwUnIOD3SDeBKXPrv3BkdtpYKBYnHEAbJjkXHs4oYs82mKNNMiOIRwGY0sA/zfGsjKioMsQtikg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F24tFhzt; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517Hfsul019896;
	Fri, 7 Feb 2025 18:42:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=H/rL7
	aArIDYdrhLKz8f+nFnrm1Eb43CWtQQm+8sHeUU=; b=F24tFhztIuc04PThutJyA
	c8oUCrJeMJLyoax77i28RUa8dZjvhQ88ScyHlbIEk0uifDOwzs8JO9lQsc6rWaGb
	tqvyNWCsMN088S0XO//L/eAhfq1Dhe5mgSyjNMeB7vv6xWAQcYzEgDtZByxXiVJa
	q5DLgVfSldMjWs2ozCg3mV2m6ANDI7zjnU7fTiwiWVgLvdc2psXNYQhVhnM65eMn
	S3jL5TtDO45+tFUAZXZ+Pj4hxcvJMq3sEWuOu1Efq5AuH0To87HzoIzpOoXXu+9I
	KBhWDM/iPnZpJHJrywtN1KMvKqgwXadHCpPLQqhtL8yr3swLXSkSMfi+NJkzvMBb
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44n0fsjb2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517HPB41022524;
	Fri, 7 Feb 2025 18:42:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ec8695-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:58 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517Idx9T037660;
	Fri, 7 Feb 2025 18:42:58 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8ec8665-6;
	Fri, 07 Feb 2025 18:42:58 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] vhost-scsi: log control queue write descriptors
Date: Fri,  7 Feb 2025 10:41:49 -0800
Message-ID: <20250207184212.20831-6-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250207184212.20831-1-dongli.zhang@oracle.com>
References: <20250207184212.20831-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-07_08,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502070139
X-Proofpoint-ORIG-GUID: OICwx9O4F2oe55ICQYpZB2btK8rBB9Cj
X-Proofpoint-GUID: OICwx9O4F2oe55ICQYpZB2btK8rBB9Cj

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
 drivers/vhost/scsi.c | 51 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index d678eaf4ca68..21c2d07b806a 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -225,6 +225,12 @@ struct vhost_scsi_tmf {
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
@@ -378,6 +384,11 @@ static void vhost_scsi_release_tmf_res(struct vhost_scsi_tmf *tmf)
 {
 	struct vhost_scsi_inflight *inflight = tmf->inflight;
 
+	if (tmf->tmf_log_num) {
+		kfree(tmf->tmf_log);
+		tmf->tmf_log_num = 0;
+	}
+
 	kfree(tmf);
 	vhost_scsi_put_inflight(inflight);
 }
@@ -1348,6 +1359,14 @@ static void vhost_scsi_tmf_resp_work(struct vhost_work *work)
 
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
+
+	if (unlikely(tmf->tmf_log_num)) {
+		mutex_lock(&tmf->svq->vq.mutex);
+		vhost_scsi_log_write(&tmf->svq->vq, tmf->tmf_log,
+				     tmf->tmf_log_num);
+		mutex_unlock(&tmf->svq->vq.mutex);
+	}
+
 	vhost_scsi_release_tmf_res(tmf);
 }
 
@@ -1369,7 +1388,8 @@ static void
 vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
 		      struct vhost_virtqueue *vq,
 		      struct virtio_scsi_ctrl_tmf_req *vtmf,
-		      struct vhost_scsi_ctx *vc)
+		      struct vhost_scsi_ctx *vc,
+		      struct vhost_log *log, unsigned int log_num)
 {
 	struct vhost_scsi_virtqueue *svq = container_of(vq,
 					struct vhost_scsi_virtqueue, vq);
@@ -1397,6 +1417,16 @@ vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
 	tmf->in_iovs = vc->in;
 	tmf->inflight = vhost_scsi_get_inflight(vq);
 
+	if (unlikely(log && log_num)) {
+		tmf->tmf_log = kmalloc_array(log_num, sizeof(*tmf->tmf_log),
+					     GFP_KERNEL);
+		if (tmf->tmf_log) {
+			memcpy(tmf->tmf_log, log, sizeof(*tmf->tmf_log) * log_num);
+			tmf->tmf_log_num = log_num;
+		} else
+			pr_err("vhost_scsi tmf log allocation error\n");
+	}
+
 	if (target_submit_tmr(&tmf->se_cmd, tpg->tpg_nexus->tvn_se_sess, NULL,
 			      vhost_buf_to_lun(vtmf->lun), NULL,
 			      TMR_LUN_RESET, GFP_KERNEL, 0,
@@ -1410,6 +1440,7 @@ vhost_scsi_handle_tmf(struct vhost_scsi *vs, struct vhost_scsi_tpg *tpg,
 send_reject:
 	vhost_scsi_send_tmf_resp(vs, vq, vc->in, vc->head, &vq->iov[vc->out],
 				 VIRTIO_SCSI_S_FUNCTION_REJECTED);
+	vhost_scsi_log_write(vq, log, log_num);
 }
 
 static void
@@ -1446,6 +1477,8 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	struct vhost_scsi_ctx vc;
 	size_t typ_size;
 	int ret, c = 0;
+	struct vhost_log *vq_log;
+	unsigned int log_num;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1459,8 +1492,11 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	vhost_disable_notify(&vs->dev, vq);
 
+	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
+		vq->log : NULL;
+
 	do {
-		ret = vhost_scsi_get_desc(vs, vq, &vc, NULL, NULL);
+		ret = vhost_scsi_get_desc(vs, vq, &vc, vq_log, &log_num);
 		if (ret)
 			goto err;
 
@@ -1524,9 +1560,12 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
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
@@ -1536,8 +1575,10 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 */
 		if (ret == -ENXIO)
 			break;
-		else if (ret == -EIO)
+		else if (ret == -EIO) {
 			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_log_write(vq, vq_log, log_num);
+		}
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
-- 
2.39.3


