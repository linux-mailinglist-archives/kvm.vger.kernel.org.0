Return-Path: <kvm+bounces-42544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 255D3A79C1A
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E433D18946D4
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 06:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4167E1EF0AE;
	Thu,  3 Apr 2025 06:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nsHpKWXg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA1F1D6DB4;
	Thu,  3 Apr 2025 06:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743661963; cv=none; b=OSR+pSh32kRF7dA6CzGa8dxPJ+KP/TnUOk0dfNdZG2YYmiwb93nsidlwf7tgw+Aw3M3IMH/dsyGU6avSehGpIvTsYiHzeFg/PPZOeAzzDNhj1ycp8Y2FH0u6TFSJVARVrQ0hC8c4xBmr6mLG8lmbWj/IKoQl9h8ZLiuobQ199sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743661963; c=relaxed/simple;
	bh=+xvPVEsaBQ5T7GDWVwypOnOcaIAq4+qwQeNpSEDGblI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7a3vnnGBI3EGboicjVvMWBi8S8cckbcWg3LrJ3dvHuFsGBVYW7L7Bhrja+YaknXIox9Yq/IVdnum+JesopPQeszWKuqndEvzZcgw2pQBJySqOFHRTHPP5zOnNoARPMMnYaPQEwkG4lqY05di5+l1AlyFuSo0kMLchb+tyjbW3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nsHpKWXg; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 532NNgK0010214;
	Thu, 3 Apr 2025 06:32:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=jYYwz
	F8VEPiQHusdFdJd0BjxD99bF6wdu0hE6sqazQU=; b=nsHpKWXgj82YMBVa3OMYv
	IqwuBjAbo4CP0e0NuyA23GUncdmpT+QgWLqyeQzCPR3jGHiQo/KfXKDqu9yrUiMl
	gU8e+b7Yh3sYyOMW3e72asS7AfoNTjinsYKh9sd7vCRu1OFDXRRLS4RBCPjh9/66
	gEluunt87/4m90BoPXDCJgSmitYNZTN6Ty22mmjZzbRJrntBC2Hrh/OGeJKehpAN
	5LV0z9TpPnXYPRY97HzrzaLw8iNneuzqYbuavZe9pwL8qvoT4tAewwiblHdSk6D8
	79r2NTwQr5psE/jZCmA+xqWBMITcKom6fjsPR0dZYS2c4Z/F0l5U/sG6vT3tY0Kw
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7n2cfsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 533574gk002715;
	Thu, 3 Apr 2025 06:32:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45pr8stj7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:35 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5336WTxF032092;
	Thu, 3 Apr 2025 06:32:34 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45pr8stj4h-7;
	Thu, 03 Apr 2025 06:32:34 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/9] vhost-scsi: log I/O queue write descriptors
Date: Wed,  2 Apr 2025 23:29:51 -0700
Message-ID: <20250403063028.16045-7-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: pdKhtIYLI6JVPGOpgyyI6LukfPrkjpP2
X-Proofpoint-GUID: pdKhtIYLI6JVPGOpgyyI6LukfPrkjpP2

Log write descriptors for the I/O queue, leveraging vhost_scsi_get_desc()
and vhost_get_vq_desc() to retrieve the array of write descriptors to
obtain the log buffer.

In addition, introduce a vhost-scsi specific function to log vring
descriptors. In this function, the 'partial' argument is set to false, and
the 'len' argument is set to 0, because vhost-scsi always logs all pages
shared by a vring descriptor. Add WARN_ON_ONCE() since vhost-scsi doesn't
support VIRTIO_F_ACCESS_PLATFORM.

The per-cmd log buffer is allocated on demand in the submission path after
VHOST_F_LOG_ALL is set. Return -ENOMEM on allocation failure, in order to
send SAM_STAT_TASK_SET_FULL to the guest.

It isn't reclaimed in the completion path. Instead, it is reclaimed when
VHOST_F_LOG_ALL is removed, or during VHOST_SCSI_SET_ENDPOINT when all
commands are destroyed.

Store the log buffer during the submission path and log it in the
completion path. Logging is also required in the error handling path of the
submission process.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - Don't allocate log buffer during initialization. Allocate during
  - VHOST_SET_FEATURES or VHOST_SCSI_SET_ENDPOINT.
  - Re-order if staments in vhost_scsi_log_write().
  - Log after vhost_scsi_send_status() as well.
Changed since v2:
  - Merge PATCH 6 and PATCH 7 from v2 as one patch.
  - Don't pre-allocate log buffer in
    VHOST_SET_FEATURES/VHOST_SCSI_SET_ENDPOINT. Allocate for only once in
    submission path in runtime. Reclaim int
    VHOST_SET_FEATURES/VHOST_SCSI_SET_ENDPOINT.
  - Encapsulate the one-time on-demand per-cmd log buffer alloc/copy in a
    helper, as suggested by Mike.

 drivers/vhost/scsi.c | 119 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 116 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 3875967dee36..af7b0ee42b6d 100644
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
@@ -362,6 +367,45 @@ static int vhost_scsi_check_prot_fabric_only(struct se_portal_group *se_tpg)
 	return tpg->tv_fabric_prot_type;
 }
 
+static int vhost_scsi_copy_cmd_log(struct vhost_virtqueue *vq,
+				   struct vhost_scsi_cmd *cmd,
+				   struct vhost_log *log,
+				   unsigned int log_num)
+{
+	if (!cmd->tvc_log)
+		cmd->tvc_log = kmalloc_array(vq->dev->iov_limit,
+					     sizeof(*cmd->tvc_log),
+					     GFP_KERNEL);
+
+	if (unlikely(!cmd->tvc_log)) {
+		vq_err(vq, "Failed to alloc tvc_log\n");
+		return -ENOMEM;
+	}
+
+	memcpy(cmd->tvc_log, log, sizeof(*cmd->tvc_log) * log_num);
+	cmd->tvc_log_num = log_num;
+
+	return 0;
+}
+
+static void vhost_scsi_log_write(struct vhost_virtqueue *vq,
+				 struct vhost_log *log,
+				 unsigned int log_num)
+{
+	if (likely(!vhost_has_feature(vq, VHOST_F_LOG_ALL)))
+		return;
+
+	if (likely(!log_num || !log))
+		return;
+
+	/*
+	 * vhost-scsi doesn't support VIRTIO_F_ACCESS_PLATFORM.
+	 * No requirement for vq->iotlb case.
+	 */
+	WARN_ON_ONCE(unlikely(vq->iotlb));
+	vhost_log_write(vq, log, log_num, U64_MAX, NULL, 0);
+}
+
 static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
@@ -660,6 +704,9 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		} else
 			pr_err("Faulted on virtio_scsi_cmd_resp\n");
 
+		vhost_scsi_log_write(cmd->tvc_vq, cmd->tvc_log,
+				     cmd->tvc_log_num);
+
 		vhost_scsi_release_cmd_res(se_cmd);
 	}
 
@@ -676,6 +723,7 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
 					struct vhost_scsi_virtqueue, vq);
 	struct vhost_scsi_cmd *cmd;
 	struct scatterlist *sgl, *prot_sgl;
+	struct vhost_log *log;
 	int tag;
 
 	tag = sbitmap_get(&svq->scsi_tags);
@@ -687,9 +735,11 @@ vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
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
 
@@ -1225,6 +1275,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
 	u8 *cdb;
+	struct vhost_log *vq_log;
+	unsigned int log_num;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1240,8 +1292,11 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	vhost_disable_notify(&vs->dev, vq);
 
+	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
+		vq->log : NULL;
+
 	do {
-		ret = vhost_scsi_get_desc(vs, vq, &vc, NULL, NULL);
+		ret = vhost_scsi_get_desc(vs, vq, &vc, vq_log, &log_num);
 		if (ret)
 			goto err;
 
@@ -1390,6 +1445,14 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			goto err;
 		}
 
+		if (unlikely(vq_log && log_num)) {
+			ret = vhost_scsi_copy_cmd_log(vq, cmd, vq_log, log_num);
+			if (unlikely(ret)) {
+				vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
+				goto err;
+			}
+		}
+
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
 			 cdb[0], lun);
 		pr_debug("cmd: %p exp_data_len: %d, prot_bytes: %d data_direction:"
@@ -1425,11 +1488,14 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 */
 		if (ret == -ENXIO)
 			break;
-		else if (ret == -EIO)
+		else if (ret == -EIO) {
 			vhost_scsi_send_bad_target(vs, vq, &vc, TYPE_IO_CMD);
-		else if (ret == -ENOMEM)
+			vhost_scsi_log_write(vq, vq_log, log_num);
+		} else if (ret == -ENOMEM) {
 			vhost_scsi_send_status(vs, vq, &vc,
 					       SAM_STAT_TASK_SET_FULL);
+			vhost_scsi_log_write(vq, vq_log, log_num);
+		}
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
@@ -1760,6 +1826,24 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
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
 static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 {
 	struct vhost_scsi_virtqueue *svq = container_of(vq,
@@ -1779,6 +1863,7 @@ static void vhost_scsi_destroy_vq_cmds(struct vhost_virtqueue *vq)
 
 	sbitmap_free(&svq->scsi_tags);
 	kfree(svq->upages);
+	vhost_scsi_destroy_vq_log(vq);
 	kfree(svq->scsi_cmds);
 	svq->scsi_cmds = NULL;
 }
@@ -2088,6 +2173,7 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 {
 	struct vhost_virtqueue *vq;
+	bool is_log, was_log;
 	int i;
 
 	if (features & ~VHOST_SCSI_FEATURES)
@@ -2100,12 +2186,39 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
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
 }
-- 
2.39.3


