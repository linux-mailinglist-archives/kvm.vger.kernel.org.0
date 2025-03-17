Return-Path: <kvm+bounces-41325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C34A66326
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:56:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1958421747
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4CC20A5F0;
	Mon, 17 Mar 2025 23:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iN/fHtSp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D71820898C;
	Mon, 17 Mar 2025 23:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255523; cv=none; b=ocMmMPoCzXlqbA/rRdf3fBaa/iCrfq1yd3kfkHCby0Glj6xT2De+zJKXw3MlOBnzgpFVzVRcv0nn0MMGyp1h8LiSJI9zlYYsMBiztZOZuQ7vFyg/vVlgi130cEHMfu+10PQVbZ9Q0Tq1a8Fro285WtiEOH0b/HtkWEkiPXzQLkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255523; c=relaxed/simple;
	bh=OPW9tAUCAJ5GoaLzf5nNJHql4/CQHMyisi5VqpfhYiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zu3rL5eMj6iHRKE3BRhCKZnBWk/abaGMyuijTC91BDVIyobH4yaE8sMl+I+z2bhAqTUQYMvKM22LAAL7+pvxMF0gTGW+tloJvvkBeNb9CbI8YxmJ9DjW3VaQWQVva60/KzMg6aRMbEGk5SMfdb4KTY5aDSr3cDw6JKNPKRswt2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iN/fHtSp; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLtwTt008474;
	Mon, 17 Mar 2025 23:51:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=FdvbV
	ynkvc3ERZ7T4/BLFYbO7mvFhyKZKhIsCb4xGlU=; b=iN/fHtSpl7aML/1G6Z+0J
	FUttGGjkwzbaS7eWMSJPg+LBbZJtSRU9YhaFJJbISdWzXE5yCdLbzM46ICYvs8ov
	JarqiDE7x6MNG+Q7fp2iIW1BKvrVIFIMIR7Pk+uxzH+MsSTCqBQfPx8y2/rVsy9K
	2CGvEzkFTnRhxlhTHNhc6/JP5r8576cpQiF2XnnvzMQzU0PZ3pFWLDGZdI4wI9n1
	6pi+NZscldX5Et70AL2YIIdhpshp/dILCwi1KYsDk5xz4eJa/IA3jXNlZ3ZglgsW
	WDm/yF8wCyKmmkhvFePUXLV95Uogg0V9ksVMrrj1E6QNsBkhJBuXpwDmHbmjrmL9
	g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1s8m4fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HMd0Qu022414;
	Mon, 17 Mar 2025 23:51:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeekf8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:46 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52HNpi2j016519;
	Mon, 17 Mar 2025 23:51:46 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeekf68-3;
	Mon, 17 Mar 2025 23:51:46 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/10] vhost-scsi: Fix vhost_scsi_send_bad_target()
Date: Mon, 17 Mar 2025 16:55:10 -0700
Message-ID: <20250317235546.4546-3-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: 4rJz50CwP3Y1193Toa0qLJsmZ6cJwRdV
X-Proofpoint-GUID: 4rJz50CwP3Y1193Toa0qLJsmZ6cJwRdV

Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
signaled by the commit 664ed90e621c ("vhost/scsi: Set
VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
vhost_scsi_send_bad_target() still assumes the response in a single
descriptor.

In addition, although vhost_scsi_send_bad_target() is used by both I/O
queue and control queue, the response header is always
virtio_scsi_cmd_resp. It is required to use virtio_scsi_ctrl_tmf_resp or
virtio_scsi_ctrl_an_resp for control queue.

Fixes: 664ed90e621c ("vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - Move this bugfix patch to before dirty log tracking patches.

 drivers/vhost/scsi.c | 48 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index f846f2aa7c87..59d907b94c5e 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1015,23 +1015,46 @@ vhost_scsi_send_status(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
 
+#define TYPE_IO_CMD    0
+#define TYPE_CTRL_TMF  1
+#define TYPE_CTRL_AN   2
+
 static void
 vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 			   struct vhost_virtqueue *vq,
-			   int head, unsigned out)
+			   struct vhost_scsi_ctx *vc, int type)
 {
-	struct virtio_scsi_cmd_resp __user *resp;
-	struct virtio_scsi_cmd_resp rsp;
+	union {
+		struct virtio_scsi_cmd_resp cmd;
+		struct virtio_scsi_ctrl_tmf_resp tmf;
+		struct virtio_scsi_ctrl_an_resp an;
+	} rsp;
+	struct iov_iter iov_iter;
+	size_t rsp_size;
 	int ret;
 
 	memset(&rsp, 0, sizeof(rsp));
-	rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
-	resp = vq->iov[out].iov_base;
-	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
-	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+
+	if (type == TYPE_IO_CMD) {
+		rsp_size = sizeof(struct virtio_scsi_cmd_resp);
+		rsp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
+	} else if (type == TYPE_CTRL_TMF) {
+		rsp_size = sizeof(struct virtio_scsi_ctrl_tmf_resp);
+		rsp.tmf.response = VIRTIO_SCSI_S_BAD_TARGET;
+	} else {
+		rsp_size = sizeof(struct virtio_scsi_ctrl_an_resp);
+		rsp.an.response = VIRTIO_SCSI_S_BAD_TARGET;
+	}
+
+	iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[vc->out], vc->in,
+		      rsp_size);
+
+	ret = copy_to_iter(&rsp, rsp_size, &iov_iter);
+
+	if (likely(ret == rsp_size))
+		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
 	else
-		pr_err("Faulted on virtio_scsi_cmd_resp\n");
+		pr_err("Faulted on virtio scsi type=%d\n", type);
 }
 
 static int
@@ -1395,7 +1418,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc, TYPE_IO_CMD);
 		else if (ret == -ENOMEM)
 			vhost_scsi_send_status(vs, vq, vc.head, vc.out,
 					       SAM_STAT_TASK_SET_FULL);
@@ -1631,7 +1654,10 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO)
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc,
+						   v_req.type == VIRTIO_SCSI_T_TMF ?
+						   TYPE_CTRL_TMF :
+						   TYPE_CTRL_AN);
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
 	mutex_unlock(&vq->mutex);
-- 
2.39.3


