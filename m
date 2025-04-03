Return-Path: <kvm+bounces-42541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B13E8A79C11
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:35:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32B553B35E0
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 06:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AA61C8611;
	Thu,  3 Apr 2025 06:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S4vGYozV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D07F1A0BCF;
	Thu,  3 Apr 2025 06:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743661960; cv=none; b=ZV32eiOBxVXsf8yYHaE64J5YQiRnPR27hx2FmXdRtlid2VieQvNe0Nec68ey2qgU44Xxk+6uv6o2ErDiabJpXANlEgYyzj906T4xP86GDt/b+QpwIKkvyhM/cvIUTGe+xDgdXqAm8VEyxTLIuvRKiiOd2vs0/qAZx78ZpuGaPhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743661960; c=relaxed/simple;
	bh=15YOlJahHhXVF9NwO+TG4QDcKbaTL8DE6XKKf4M7bjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghaixQuyqyUDwf0Z7i15E/sAkZUKrBIa4YkYrGrjUrXiS5gqFwFQD2U1z9fRYH+2Ol6VzD9V2AJD39T0jg0NoYzfX+a/+AGPuliyoW7BY1cNmUock+Xmgd/hNHRrr0PCn5rSPKzgJzMrrI/g16BO4a3xiQpHRK4nie+ZnUS+FBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S4vGYozV; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 532NMrgU007998;
	Thu, 3 Apr 2025 06:32:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=BO9Ji
	GYREtmMdjz9Rf8aG7RESCrajR08Nazr5KGiiVY=; b=S4vGYozVVuYkqaT5Gj4gl
	eAOcT+PCoGzgB9u8nlXshxo7Ab5TU3TI4ETCRF5u1RCdxmpDniKmDOtgIlVnxHAH
	HAFp+RSxM6p19Ddam4uF5byarbZ0FOlHrf58/k0/mMZSEn5e+6Ft8fvosekowo6z
	UlfqA7d/qinUEtpdbCrXAACNVT4PU+N0yn//0f9NjgKdxirCSdBu5uoolfo+N+nA
	2/ydlaxSi6Q1x1qzi+T49DtF3z9Tv9IZTBcvSlP4mQoBjDtAQ26EIJbcnms4PMzX
	42odthhi8gXgIk0IuX2UoDPe1QO7nGWyDGpNIJKpDxngQYLBQ8VI8XKaSC5DxOEO
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7n2cfs7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53360Znc002620;
	Thu, 3 Apr 2025 06:32:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45pr8stj63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:32 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5336WTx7032092;
	Thu, 3 Apr 2025 06:32:31 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45pr8stj4h-3;
	Thu, 03 Apr 2025 06:32:31 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/9] vhost-scsi: Fix vhost_scsi_send_bad_target()
Date: Wed,  2 Apr 2025 23:29:47 -0700
Message-ID: <20250403063028.16045-3-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: AJAHQD3y25ibWnWQCapOlfJ18H7CyFDW
X-Proofpoint-GUID: AJAHQD3y25ibWnWQCapOlfJ18H7CyFDW

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
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
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


