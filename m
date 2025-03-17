Return-Path: <kvm+bounces-41323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC0FA66312
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CDB67AAF98
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC73C2080FB;
	Mon, 17 Mar 2025 23:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QFs0+F1T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B9C20767B;
	Mon, 17 Mar 2025 23:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255520; cv=none; b=q/tissRWidswDxWJytTfWsjAWeBEy4qz4AtTG7HdPe6p9ibO4qa8kNDuopIFF7JC7MxvJXoa2lAqZ4S4ZjMrKgo/8Uf3ZGJxzzZDkp632ghuZbY3kxOrpEpQcARJp/WqstesXPiF0dGXwfqwrDA7NDTvK8qJAuggvbV1YrIuvLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255520; c=relaxed/simple;
	bh=AtcW4JqNCDC+RfhFBZKuuVK+fkEzCpeAWc2WDCame4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoYT5YynBhPgBXSMoBdYpNy2d7ilXYY7R9VlVdjSB0L0STYt6Euf0ccgJVzQ1PuOOsV8MhLPJ0LmoZlkt3nAb3S25rcwaeYQlAHvEElAyOM3lZoYwg7xpibogXV46sEKgN5AzJm4Mfs4FvJGo9eea8QJ+1Ekb6TxUyZBZ0fvpm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QFs0+F1T; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLunnb015846;
	Mon, 17 Mar 2025 23:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=NRSXZ
	CVl49uEUV5pb8cvfLLElVUofUO0chgK1Bz8Lk4=; b=QFs0+F1T1xSQqCnCgJj1S
	pvJZSZzzh2vD36L30vgQCvmDw4TLYtgjewEKjPjYa1Uo0yt9GmwAVWJD0DZ55B5H
	iBRvw0ua3qMlId8Ud44ItNr1zXCC5wNjPqT1xjfc/NCjQAOvlcT+jZW3V/hT2zm5
	n1CBsWTdQsU+GLRpwOnnvKexUAGFZ185dLgn8q4HTNsV3ECmoyhemFjaLGo4bxRF
	wA+Yg8U6GMSS02zn9FRd4+Ja8xpcv5G0Wzxx/rBr/wBjj/dauXqYDVKqjImnEFM7
	qHWzMAqPS2UK861Jb3A1jvpuR4wSbpf0TVP4NOyDqjdN76c5TzbTcmxp8cc56r1P
	w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1k9v3ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HL5Sci022365;
	Mon, 17 Mar 2025 23:51:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeekfa5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:49 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52HNpi2r016519;
	Mon, 17 Mar 2025 23:51:49 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeekf68-7;
	Mon, 17 Mar 2025 23:51:49 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/10] vhost-scsi: cache log buffer in I/O queue vhost_scsi_cmd
Date: Mon, 17 Mar 2025 16:55:14 -0700
Message-ID: <20250317235546.4546-7-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: 705QLe9nubQwusti7CTVJ1BUdbKmvOXG
X-Proofpoint-ORIG-GUID: 705QLe9nubQwusti7CTVJ1BUdbKmvOXG

The vhost-scsi I/O queue uses vhost_scsi_cmd. Allocate the log buffer
during vhost_scsi_cmd allocation or when VHOST_F_LOG_ALL is set. Free the
log buffer when vhost_scsi_cmd is reclaimed or when VHOST_F_LOG_ALL is
removed.

Fail vhost_scsi_set_endpoint or vhost_scsi_set_features() on allocation
failure.

The cached log buffer will be uses in upcoming patches to log write
descriptors for the I/O queue. The core idea is to cache the log in the
per-command log buffer in the submission path, and use them to log write
descriptors in the completion path.

As a reminder, currently QEMU's vhost-scsi VHOST_SET_FEATURES handler
doesn't process the failure gracefully. Instead, it crashes immediately on
failure from VHOST_SET_FEATURES.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - Don't allocate log buffer during initialization. Allocate during
    VHOST_SET_FEATURES or VHOST_SCSI_SET_ENDPOINT.

 drivers/vhost/scsi.c | 126 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 3875967dee36..1b7211a55562 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -133,6 +133,11 @@ struct vhost_scsi_cmd {
 	struct se_cmd tvc_se_cmd;
 	/* Sense buffer that will be mapped into outgoing status */
 	unsigned char tvc_sense_buf[TRANSPORT_SENSE_BUFFER];
+	/*
+	 * Dirty write descriptors of this command.
+	 */
+	struct vhost_log *tvc_log;
+	unsigned int tvc_log_num;
 	/* Completed commands list, serviced from vhost worker thread */
 	struct llist_node tvc_completion_list;
 	/* Used to track inflight cmd */
@@ -676,6 +681,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
 					struct vhost_scsi_virtqueue, vq);
 	struct vhost_scsi_cmd *cmd;
 	struct scatterlist *sgl, *prot_sgl;
+	struct vhost_log *log;
 	int tag;
 
 	tag = sbitmap_get(&svq->scsi_tags);
@@ -687,9 +693,11 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
 	cmd = &svq->scsi_cmds[tag];
 	sgl = cmd->sgl;
 	prot_sgl = cmd->prot_sgl;
+	log = cmd->tvc_log;
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->sgl = sgl;
 	cmd->prot_sgl = prot_sgl;
+	cmd->tvc_log = log;
 	cmd->tvc_se_cmd.map_tag = tag;
 	cmd->inflight = vhost_scsi_get_inflight(vq);
 
@@ -1760,6 +1768,55 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 		wait_for_completion(&vs->old_inflight[i]->comp);
 }
 
+static void vhost_scsi_destroy_vq_log(struct vhost_virtqueue *vq)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_cmd *tv_cmd;
+	unsigned int i;
+
+	if (!svq->scsi_cmds)
+		return;
+
+	for (i = 0; i < svq->max_cmds; i++) {
+		tv_cmd = &svq->scsi_cmds[i];
+		kfree(tv_cmd->tvc_log);
+		tv_cmd->tvc_log = NULL;
+		tv_cmd->tvc_log_num = 0;
+	}
+}
+
+static int vhost_scsi_setup_vq_log(struct vhost_virtqueue *vq)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+					struct vhost_scsi_virtqueue, vq);
+	struct vhost_scsi_cmd *tv_cmd;
+	unsigned int i;
+
+	if (!svq->scsi_cmds)
+		return 0;
+
+	for (i = 0; i < svq->max_cmds; i++) {
+		tv_cmd = &svq->scsi_cmds[i];
+		WARN_ON_ONCE(unlikely(tv_cmd->tvc_log ||
+				      tv_cmd->tvc_log_num));
+		tv_cmd->tvc_log_num = 0;
+		tv_cmd->tvc_log = kcalloc(vq->dev->iov_limit,
+					  sizeof(struct vhost_log),
+					  GFP_KERNEL);
+		if (!tv_cmd->tvc_log) {
+			pr_err("Unable to allocate tv_cmd->tvc_log\n");
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	vhost_scsi_destroy_vq_log(vq);
+	return -ENOMEM;
+}
+
 static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 {
 	struct vhost_scsi_virtqueue *svq = container_of(vq,
@@ -1779,6 +1836,7 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 
 	sbitmap_free(&svq->scsi_tags);
 	kfree(svq->upages);
+	vhost_scsi_destroy_vq_log(vq);
 	kfree(svq->scsi_cmds);
 	svq->scsi_cmds = NULL;
 }
@@ -1834,6 +1892,11 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 			}
 		}
 	}
+
+	if (vhost_has_feature(vq, VHOST_F_LOG_ALL) &&
+	    vhost_scsi_setup_vq_log(vq))
+		goto out;
+
 	return 0;
 out:
 	vhost_scsi_destroy_vq_cmds(vq);
@@ -2088,6 +2151,8 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 {
 	struct vhost_virtqueue *vq;
+	bool is_log, was_log;
+	int ret;
 	int i;
 
 	if (features & ~VHOST_SCSI_FEATURES)
@@ -2100,14 +2165,75 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 		return -EFAULT;
 	}
 
+	if (!vs->dev.nvqs)
+		goto out;
+
+	is_log = features & (1 << VHOST_F_LOG_ALL);
+	/*
+	 * All VQs should have same feature.
+	 */
+	was_log = vhost_has_feature(&vs->vqs[0].vq, VHOST_F_LOG_ALL);
+
+	/*
+	 * If VHOST_F_LOG_ALL is going to be added, allocate tvc_log before
+	 * vq->acked_features is committed.
+	 * Return -ENOMEM on allocation failure.
+	 */
+	if (is_log && !was_log) {
+		for (i = VHOST_SCSI_VQ_IO; i < vs->dev.nvqs; i++) {
+			if (!vs->vqs[i].scsi_cmds)
+				continue;
+
+			vq = &vs->vqs[i].vq;
+
+			mutex_lock(&vq->mutex);
+			ret = vhost_scsi_setup_vq_log(vq);
+			mutex_unlock(&vq->mutex);
+
+			if (ret)
+				goto destroy_cmd_log;
+		}
+	}
+
 	for (i = 0; i < vs->dev.nvqs; i++) {
 		vq = &vs->vqs[i].vq;
 		mutex_lock(&vq->mutex);
 		vq->acked_features = features;
 		mutex_unlock(&vq->mutex);
 	}
+
+	/*
+	 * If VHOST_F_LOG_ALL is removed, free tvc_log after
+	 * vq->acked_features is committed.
+	 */
+	if (!is_log && was_log) {
+		for (i = VHOST_SCSI_VQ_IO; i < vs->dev.nvqs; i++) {
+			if (!vs->vqs[i].scsi_cmds)
+				continue;
+
+			vq = &vs->vqs[i].vq;
+			mutex_lock(&vq->mutex);
+			vhost_scsi_destroy_vq_log(vq);
+			mutex_unlock(&vq->mutex);
+		}
+	}
+
+out:
 	mutex_unlock(&vs->dev.mutex);
 	return 0;
+
+destroy_cmd_log:
+	for (i--; i >= VHOST_SCSI_VQ_IO; i--) {
+		if (!vs->vqs[i].scsi_cmds)
+			continue;
+
+		vq = &vs->vqs[i].vq;
+		mutex_lock(&vq->mutex);
+		vhost_scsi_destroy_vq_log(vq);
+		mutex_unlock(&vq->mutex);
+	}
+	mutex_unlock(&vs->dev.mutex);
+	return -ENOMEM;
 }
 
 static int vhost_scsi_open(struct inode *inode, struct file *f)
-- 
2.39.3


