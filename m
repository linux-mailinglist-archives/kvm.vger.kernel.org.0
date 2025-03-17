Return-Path: <kvm+bounces-41321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DEEBCA66310
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:54:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3713189FDE1
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4970B205E0D;
	Mon, 17 Mar 2025 23:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NCxoDFv9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D0820766F;
	Mon, 17 Mar 2025 23:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255519; cv=none; b=cddgVccu4BMcHpXYqw8IRBLp7wjpqe+5NMpE6L25ozAULbNoYH65kSzqXF3QTvtSlHSNYGTJ76Y4WagMw3IMvDQs/AH6zFuCavh6jwqAPAqi+pYmSC3ycC7VVHvQY1eJLIcpyJAqd+W41vNXjooN746P2sLVqXgB3Uq7W6u6Qgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255519; c=relaxed/simple;
	bh=3bAGJM+hmX4JqU8RGf3xRDTiXcP/I1qjndce7ZFN00w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hbxwvq/YJ4awzoau4CN6L5eg9813YT3nnD0/oSPhB5eX/v/k/kjfp3cQpMNZpAV+n/EPraM/d38O/ER3Qe4t2Q8u/nyHPJCOvPlQcTVv5QlLkOGh9tP1omD5A5o3VOG083NiRG3YSFGSTuCY0uVXdpsbvWTcNOlnRJClAwRS4TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NCxoDFv9; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLuJPX015661;
	Mon, 17 Mar 2025 23:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=latmc
	omXMu9YuywlJ44h0qmTh2EjHNCowUlu26BGUns=; b=NCxoDFv9dVd4Ih6x4GAtc
	hzksZcMow2uDp1gvsgaE6jzpS7yFmZnY2XAIpggFb7yJA5L38g3rco9OShUCiKyt
	DA1jPq9pGcZVX5FzLI8ZJjuosmx1CmBi27e2U3m6nySosnf3aiBsMWVAKLjlHPJU
	Bwzu4VOoCBI2qwjkpt5GA16UCfvhrc73PPf8dHzer1kIFYtcg7+gkwTMGessTBlu
	5HN2qPA0sUoWBglbfFsHIBQamYxgy/xGqaIiv6ez5WvBfWXKCZpU6bK13l09DdYy
	4iegbiw7FV+cSjFM2tzycXbTc2d9L8Q0qYOiySKsT//1VPU5xg1TvDHXRxxf1WjN
	A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1k9v3kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HMpFrQ022350;
	Mon, 17 Mar 2025 23:51:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeekf8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:47 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52HNpi2l016519;
	Mon, 17 Mar 2025 23:51:46 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeekf68-4;
	Mon, 17 Mar 2025 23:51:46 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/10] vhost-scsi: Fix vhost_scsi_send_status()
Date: Mon, 17 Mar 2025 16:55:11 -0700
Message-ID: <20250317235546.4546-4-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: YtSncYleLXmaE3aU_gsJeOMm9obcNNtt
X-Proofpoint-ORIG-GUID: YtSncYleLXmaE3aU_gsJeOMm9obcNNtt

Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
signaled by the commit 664ed90e621c ("vhost/scsi: Set
VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
vhost_scsi_send_bad_target() still assumes the response in a single
descriptor.

Similar issue in vhost_scsi_send_bad_target() has been fixed in previous
commit.

Fixes: 3ca51662f818 ("vhost-scsi: Add better resource allocation failure handling")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - New patch to fix vhost_scsi_send_status().

 drivers/vhost/scsi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 59d907b94c5e..26bcf3a7f70c 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -999,18 +999,22 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_nexus *nexus,
 
 static void
 vhost_scsi_send_status(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
-		       int head, unsigned int out, u8 status)
+		       struct vhost_scsi_ctx *vc, u8 status)
 {
-	struct virtio_scsi_cmd_resp __user *resp;
 	struct virtio_scsi_cmd_resp rsp;
+	struct iov_iter iov_iter;
 	int ret;
 
 	memset(&rsp, 0, sizeof(rsp));
 	rsp.status = status;
-	resp = vq->iov[out].iov_base;
-	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
-	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+
+	iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[vc->out], vc->in,
+		      sizeof(rsp));
+
+	ret = copy_to_iter(&rsp, sizeof(rsp), &iov_iter);
+
+	if (likely(ret == sizeof(rsp)))
+		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
@@ -1420,7 +1424,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		else if (ret == -EIO)
 			vhost_scsi_send_bad_target(vs, vq, &vc, TYPE_IO_CMD);
 		else if (ret == -ENOMEM)
-			vhost_scsi_send_status(vs, vq, vc.head, vc.out,
+			vhost_scsi_send_status(vs, vq, &vc,
 					       SAM_STAT_TASK_SET_FULL);
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
 out:
-- 
2.39.3


