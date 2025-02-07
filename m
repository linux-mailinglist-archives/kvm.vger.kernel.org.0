Return-Path: <kvm+bounces-37633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A298FA2CBD0
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 19:47:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3266916646D
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFAA1DFD9E;
	Fri,  7 Feb 2025 18:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GjTBR9p0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D72D1DE3BF;
	Fri,  7 Feb 2025 18:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953791; cv=none; b=MUjZ2Aq3Ht48yaEbXsjTNZ7Gq0pqkXBwKaFD/2siS8rZgYSke85UDHgWrFj4RBmuf7DClg32WFP7K7QknAq51L/q6sYziL7BUN06UxC1sGCoLRbJNHnhby4itvG144J1vhLLw12iZ5dmPpJKqfsy5KNv/WZVPIaaY4FdfFKtMpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953791; c=relaxed/simple;
	bh=nQnZYW52vb86coFPjs/TEXCK0Op+JRWUcCW/VbtdSps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpuyYd5SXxOtxgLRfJuRJbgmKhu4ouuvIAwsBH6JuHjSZygSyxgN1ZNKXHOcs9HDZBscqm0dENUikLdOZfVK4zUbxg2TSW2JeuAfFyFl20UcwFJ2zRRk5TujYBSStHe9RVJSxLhlF6DydTBV8dEUHB1xujN2ASqQqn2hI8T76bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GjTBR9p0; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517HfsNZ011643;
	Fri, 7 Feb 2025 18:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=Ketic
	Cnpyb6jzdEUojEwLtoo1PFBDN83aIYMiT5obl4=; b=GjTBR9p0xeWArPk1s37Au
	5sIrtaE+u3yb8U1viPRg7anBbUsjTbNwb1so7Y5/vezhlwCdQ0RmhxzujoIPO8s2
	vLJBZlCAt5zL3TmXC8Yd1hHqHySd1G4WGdRebDGTp3FSPHIRv4Ns9VrCIrcjV61l
	kPgXTBge6TISpaCiKZgQfRMiFEHiXOBZy4mnVJRVCCHeCVX/2RKy+4PEJRznsy0W
	CJDhdyaHTeOcjjSURvVlLgcW3hiAgQSkot7HSScvEwrhH8sCJ82cvMIvUjXXqZmG
	iv3srz5BoDEmnGYx33Jtek38HqAgh5zlrkUcuyU1+aZERiokOdtHgoDPWwfKegku
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44m50udacn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:43:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517HKTTq022731;
	Fri, 7 Feb 2025 18:43:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ec86b7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:43:02 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517Idx9b037660;
	Fri, 7 Feb 2025 18:43:01 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8ec8665-10;
	Fri, 07 Feb 2025 18:43:01 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] vhost-scsi: Fix vhost_scsi_send_bad_target()
Date: Fri,  7 Feb 2025 10:41:53 -0800
Message-ID: <20250207184212.20831-10-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: cg1KL6VSm7q0IoyM47cXu2dE5uwnNUjn
X-Proofpoint-ORIG-GUID: cg1KL6VSm7q0IoyM47cXu2dE5uwnNUjn

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
 drivers/vhost/scsi.c | 50 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 3b87d698adaf..6aa3f3ad2695 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -989,23 +989,46 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 	target_submit(se_cmd);
 }
 
+#define TYPE_IO_CMD	0
+#define TYPE_CTRL_TMF	1
+#define TYPE_CTRL_AN	2
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
+	} resp;
+	struct iov_iter iov_iter;
+	size_t resp_size;
 	int ret;
 
-	memset(&rsp, 0, sizeof(rsp));
-	rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
-	resp = vq->iov[out].iov_base;
-	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
-	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+	memset(&resp, 0, sizeof(resp));
+
+	if (type == TYPE_IO_CMD) {
+		resp_size = sizeof(struct virtio_scsi_cmd_resp);
+		resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
+	} else if (type == TYPE_CTRL_TMF) {
+		resp_size = sizeof(struct virtio_scsi_ctrl_tmf_resp);
+		resp.tmf.response = VIRTIO_SCSI_S_BAD_TARGET;
+	} else {
+		resp_size = sizeof(struct virtio_scsi_ctrl_an_resp);
+		resp.an.response = VIRTIO_SCSI_S_BAD_TARGET;
+	}
+
+	iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[vc->out], vc->in,
+		      resp_size);
+
+	ret = copy_to_iter(&resp, resp_size, &iov_iter);
+
+	if (likely(ret == resp_size))
+		vhost_add_used_and_signal(&vs->dev, vq, vc->head, 0);
 	else
-		pr_err("Faulted on virtio_scsi_cmd_resp\n");
+		pr_err("Faulted on virtio scsi type=%d\n", type);
 }
 
 static int
@@ -1332,7 +1355,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO) {
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc, TYPE_IO_CMD);
 			vhost_scsi_log_write(vq, vq_log, log_num);
 		}
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
@@ -1594,7 +1617,10 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		if (ret == -ENXIO)
 			break;
 		else if (ret == -EIO) {
-			vhost_scsi_send_bad_target(vs, vq, vc.head, vc.out);
+			vhost_scsi_send_bad_target(vs, vq, &vc,
+						   v_req.type == VIRTIO_SCSI_T_TMF ?
+						   TYPE_CTRL_TMF :
+						   TYPE_CTRL_AN);
 			vhost_scsi_log_write(vq, vq_log, log_num);
 		}
 	} while (likely(!vhost_exceeds_weight(vq, ++c, 0)));
-- 
2.39.3


