Return-Path: <kvm+bounces-41326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 254BEA66325
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:56:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CCE319A0084
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E05920AF75;
	Mon, 17 Mar 2025 23:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N+5ufu4r"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D9209671;
	Mon, 17 Mar 2025 23:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255523; cv=none; b=MndUHDPhxsCse7I5gpg9TLoahE1tqaMmTxWo0jvDGWc8VFT2UNN9a9rytlsHXETzAX0Hyt8+VsfYnk7U7kczn6zilIkFkQnEGXTVMacaAlF5DC5g+QQejq8FohA9YuOA2bnjblRhwwhCi1TAETNoGUXmjc5a3bZXCTFn0r1CU5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255523; c=relaxed/simple;
	bh=aoIxfXyKbjuDzanO+iS/+dNDhJ4CSePcBAOBRQ2xq6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0D78bCXknlGrnNGTzscXxak78p8Dfs7z1P2ogdNC4AYG5GseDJJCMRwwcvlNqR0MwbCbT/UUdjLazy/d2+1unwALn1rHhYR35W8EW5Kz5qhcBYq2rKREEz+1Qw+joQc+1eWs7kCaJqf9tPCD/yY/qHWUaantnfzJQPYvO/T+AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N+5ufu4r; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLtwTu008474;
	Mon, 17 Mar 2025 23:51:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=AWbKH
	s4Wis09IHi148sMqRrR0NMHeb5or4DC4wWzaPE=; b=N+5ufu4rbbswlFBK9fPhv
	ZCj1QC0/0PLL8zR7Hqki690t3Z+lb8MEUGmkTmXBeCsh6qEFlnAESM9T0gQucIP+
	MpQT1wDXoxW4jgBdxwDC72fsyJkg5eQOf/m7yOMQkfGCBQ6PyZDpk7mJVtR9Yafm
	v2Jt7Lk6Z9PqYjhRHeo/sw3jlmNHfSZQsImYIXAR8/XYehUqKjCRG9NKAqP0SyIN
	MGA3QFEs3pgJIW7/C03+i6nZa0he6/NQ+jh7on/V+iujB8pIWxPcVdfmxlAUL9wi
	uXXEVajAsBzVBiXy+BTr69JURyXccTBrFT0gFMx95yp0JXXxP3VELauPedWt3YdM
	A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1s8m4fy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HL2F4t022346;
	Mon, 17 Mar 2025 23:51:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeekfaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:50 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52HNpi2t016519;
	Mon, 17 Mar 2025 23:51:50 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeekf68-8;
	Mon, 17 Mar 2025 23:51:50 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/10] vhost-scsi: log I/O queue write descriptors
Date: Mon, 17 Mar 2025 16:55:15 -0700
Message-ID: <20250317235546.4546-8-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: kb5AezXdYI2xdVIYiw8sPrcwxLrkYYJ_
X-Proofpoint-GUID: kb5AezXdYI2xdVIYiw8sPrcwxLrkYYJ_

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

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - Re-order if staments in vhost_scsi_log_write().
  - Log after vhost_scsi_send_status() as well.

 drivers/vhost/scsi.c | 43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 1b7211a55562..8a1b0a19fe58 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -367,6 +367,24 @@ static int vhost_scsi_check_prot_fabric_only(struct se_portal_group *se_tpg)
 	return tpg->tv_fabric_prot_type;
 }
 
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
+	vhost_log_write(vq, log, log_num, 0, false, NULL, 0);
+}
+
 static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 {
 	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
@@ -665,6 +683,9 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		} else
 			pr_err("Faulted on virtio_scsi_cmd_resp\n");
 
+		vhost_scsi_log_write(cmd->tvc_vq, cmd->tvc_log,
+				     cmd->tvc_log_num);
+
 		vhost_scsi_release_cmd_res(se_cmd);
 	}
 
@@ -1233,6 +1254,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	u8 task_attr;
 	bool t10_pi = vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI);
 	u8 *cdb;
+	struct vhost_log *vq_log;
+	unsigned int log_num;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -1248,8 +1271,11 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 	vhost_disable_notify(&vs->dev, vq);
 
+	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
+		vq->log : NULL;
+
 	do {
-		ret = vhost_scsi_get_desc(vs, vq, &vc, NULL, NULL);
+		ret = vhost_scsi_get_desc(vs, vq, &vc, vq_log, &log_num);
 		if (ret)
 			goto err;
 
@@ -1398,6 +1424,14 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 			goto err;
 		}
 
+		if (unlikely(vq_log && log_num)) {
+			/*
+			 * cmd->tvc_log depends on VHOST_F_LOG_ALL.
+			 */
+			memcpy(cmd->tvc_log, vq->log, sizeof(*cmd->tvc_log) * log_num);
+			cmd->tvc_log_num = log_num;
+		}
+
 		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
 			 cdb[0], lun);
 		pr_debug("cmd: %p exp_data_len: %d, prot_bytes: %d data_direction:"
@@ -1433,11 +1467,14 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
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
-- 
2.39.3


