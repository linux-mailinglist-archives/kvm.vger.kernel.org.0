Return-Path: <kvm+bounces-37626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6F7A2CBBD
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 19:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA5EE18803A2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B571BEF74;
	Fri,  7 Feb 2025 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YSUgRQqp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F7E1A38F9;
	Fri,  7 Feb 2025 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953786; cv=none; b=pzlU+MDC38YbU0K91KJUt6UrkeJHrMsUFo21iyLjDSPUu5Edtxxlsisi4ylhRwD5vHUdGoAfXbIVrVebrCpTC6qIy/4CENAdiBuRHIrzwnWRxspcYzkESC2wMBUvO7MsRIliwDmfuCVCvxfBPdbiyalGxKBn19/h8yhryj9YTYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953786; c=relaxed/simple;
	bh=ikD3WcT3bZbN966PZ81A9i/+I6kiRYH61Uq2okRMyFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHa67PaQgbOdC1QEQbmReveSmBOeFiW3m8744WKkuhkqW9B9Un/MfbAEvCw2+9g/q6eI70+DT97pwd2RHYYI//vjiBKfejB3FnrDIKGDEGmB6fuDAAT7AhkRFhG98tIpGOeNGhjN3AOXHoADKtYlUnT/DkmY8t35igKkkKtQH/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YSUgRQqp; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517HgPQM023796;
	Fri, 7 Feb 2025 18:42:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=MqIgg
	zXMS+FRLkCHvwW4YvogltdqmKg2UK+X1oTySD0=; b=YSUgRQqpUpOpGZ1VoCBG8
	uxwJu6uvL17PTt3sE1tCW9+BS8FvrzHp/5DpL19rDWwNM0jn1Lx+IYIXPpr2uOp9
	3WOwQSAOi6FI1aN9pgUPCit/gBk+cliRm5HYQrSEJ0QlLsaPJ30Lr8jXidDlDY3/
	r3Chcvor1l6OKX7Dx4uEbpwkg1rtPNTjr2vfIGknU2lYBxr8YyFCLX+sVGOj2aHZ
	J6E/8n6mMID2aZRL4mkaaZsxtij9FIeWGiz4As1bJP54EPBG/tvQdKfFiSoGxhZT
	NK8ajkijwap58N72SBml61GLEyfSR9/1f94HZ1hWNOJvgfa25YC5luOeHHwlPT2Y
	A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44m58cnc7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517HPB40022524;
	Fri, 7 Feb 2025 18:42:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ec868p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:58 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517Idx9R037660;
	Fri, 7 Feb 2025 18:42:57 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8ec8665-5;
	Fri, 07 Feb 2025 18:42:57 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] vhost-scsi: log I/O queue write descriptors
Date: Fri,  7 Feb 2025 10:41:48 -0800
Message-ID: <20250207184212.20831-5-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: Ea15RNTTBc6ZMQ2GGGpAKu6Ia5Z8lgYz
X-Proofpoint-GUID: Ea15RNTTBc6ZMQ2GGGpAKu6Ia5Z8lgYz

Log write descriptors for the I/O queue, leveraging vhost_scsi_get_desc()
and vhost_get_vq_desc() to retrieve the array of write descriptors to
obtain the log buffer.

In addition, introduce a vhost-scsi specific function to log vring
descriptors. In this function, the 'partial' argument is set to false, and
the 'len' argument is set to 0, because vhost-scsi always logs all pages
shared by a vring descriptor. Add WARN_ON_ONCE() since vhost-scsi doesn't
support VIRTIO_F_ACCESS_PLATFORM.

Store the log buffer during the submission path and log it in the
completion path. Logging is also required in the error handling path of the
submission process.

While the submission path is already protected by vq->mutex, the completion
path also requires this lock for synchronization.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/vhost/scsi.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5e6221cbbe9e..d678eaf4ca68 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -329,6 +329,24 @@ static int vhost_scsi_check_prot_fabric_only(struct se_portal_group *se_tpg)
 	return tpg->tv_fabric_prot_type;
 }
 
+static void vhost_scsi_log_write(struct vhost_virtqueue *vq,
+				 struct vhost_log *log,
+				 unsigned int log_num)
+{
+	if (likely(!log || !log_num))
+		return;
+
+	if (likely(!vhost_has_feature(vq, VHOST_F_LOG_ALL)))
+		return;
+
+	/*
+	 * vhost-scsi doesn't support VIRTIO_F_ACCESS_PLATFORM.
+	 * No requirement for vq->iotlb case.
+	 */
+	WARN_ON_ONCE(unlikely(vq->iotlb));
+	vhost_log_write(vq, log, log_num, 0, false, NULL, 0);
+}
+
 static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
@@ -606,6 +624,13 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		} else
 			pr_err("Faulted on virtio_scsi_cmd_resp\n");
 
+		if (unlikely(cmd->tvc_log_num)) {
+			mutex_lock(&cmd->tvc_vq->mutex);
+			vhost_scsi_log_write(cmd->tvc_vq, cmd->tvc_log,
+					     cmd->tvc_log_num);
+			mutex_unlock(&cmd->tvc_vq->mutex);
+		}
+
 		vhost_scsi_release_cmd_res(se_cmd);
 	}
 
@@ -1082,6 +1107,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
 	void *cdb;
+	struct vhost_log *vq_log;
+	unsigned int log_num;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1097,8 +1124,11 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	vhost_disable_notify(&vs->dev, vq);
 
+	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
+		vq->log : NULL;
+
 	do {
-		ret = vhost_scsi_get_desc(vs, vq, &vc, NULL, NULL);
+		ret = vhost_scsi_get_desc(vs, vq, &vc, vq_log, &log_num);
 		if (ret)
 			goto err;
 
@@ -1238,6 +1268,11 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			cmd->tvc_resp_iov[i] = vq->iov[vc.out + i];
 		cmd->tvc_in_iovs = vc.in;
 
+		if (unlikely(vq_log && log_num)) {
+			memcpy(cmd->tvc_log, vq->log, sizeof(*cmd->tvc_log) * log_num);
+			cmd->tvc_log_num = log_num;
+		}
+
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
 			 cmd->tvc_cdb[0], cmd->tvc_lun);
 		pr_debug("cmd: %p exp_data_len: %d, prot_bytes: %d data_direction:"
@@ -1269,8 +1304,10 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
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


