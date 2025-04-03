Return-Path: <kvm+bounces-42542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 811BCA79C14
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57B353B262E
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 06:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939D91DACA1;
	Thu,  3 Apr 2025 06:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NjAC/Ek6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1A01A2872;
	Thu,  3 Apr 2025 06:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743661960; cv=none; b=tgJR2N4mI15eY+txbjhcgmT+y/XEJ87IbYGv0vAdEqa781Cm4ixwXJYeS6T0aIrWOdCFAGeQtssznUOPKh/w6OJeAjdBzntM74XcD95PWOJ60rg8lXzeG5FqZsx0BdTRXP57k17PT75Vwd0LwERglAWxuoR0Q+ds/PPb98SP49o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743661960; c=relaxed/simple;
	bh=+MoSZdkXB8P8wlNJnarUXq4B9nciJZZWT6fkgPK6mOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqOshesQZX4FFXpAEjFGbvkE0Arkh2N6VbIXRzrxry07Z+hq7Dqw/upn4cWvsZxnSC7kTHCA7bwdT20pDiOzHD+UgbtGfgEO+mTOxZy5PSf5qLPWkDlHTH4y3SLrDpGMjoUAI7U2ozCdlTrJ3JMYQWY/Chz+bOuWx1cYVwlHZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NjAC/Ek6; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 532NMrcQ026560;
	Thu, 3 Apr 2025 06:32:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=BlFGb
	dl3kMGnJTb1iEd/Fu/J459efqX8nafqrQ+D4mU=; b=NjAC/Ek6X1kkj3HSJOVg/
	8u6o+zhKI7nFdXjz6jWCEdM+TUCp/Mt88bNkENFqgyyHmlyakEeW18wLA+PFHdRi
	+c89GkMiSBZ8HG+GvYDOZVNPilvLXjNBi1sWgmGeb5CZI3jYanmAriGJaCVWkTF+
	QFLH2fGkJfav1oeBRwbEz5L9AcJ6o9YTp7qHgtlWY0+jokPBP8W/MYTr11pDYcfZ
	PtNzxvOF+olk+cuH6fSinU+gHlnM53Smy1hZDc55SutleV/k7+Tni1kW/TZH+iGW
	bC8E+xxd1HrhdlefDt1Hs3/F5A6VURETOdORG4i3DCcJr7WUVOUsc+gFAZxMKLDG
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p79ccb17-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53360Znd002620;
	Thu, 3 Apr 2025 06:32:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45pr8stj6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:32 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5336WTx9032092;
	Thu, 3 Apr 2025 06:32:32 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45pr8stj4h-4;
	Thu, 03 Apr 2025 06:32:32 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/9] vhost-scsi: Fix vhost_scsi_send_status()
Date: Wed,  2 Apr 2025 23:29:48 -0700
Message-ID: <20250403063028.16045-4-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: RDl9xRJhxkYpbyXSWsCBm3muA03n_s6O
X-Proofpoint-ORIG-GUID: RDl9xRJhxkYpbyXSWsCBm3muA03n_s6O

Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
signaled by the commit 664ed90e621c ("vhost/scsi: Set
VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
vhost_scsi_send_bad_target() still assumes the response in a single
descriptor.

Similar issue in vhost_scsi_send_bad_target() has been fixed in previous
commit. In addition, similar issue for vhost_scsi_complete_cmd_work() has
been fixed by the commit 6dd88fd59da8 ("vhost-scsi: unbreak any layout for
response").

Fixes: 3ca51662f818 ("vhost-scsi: Add better resource allocation failure handling")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
---
Changed since v1:
  - New patch to fix vhost_scsi_send_status().
Changed since v2:
  - Mention the commit 6dd88fd59da8 in the commit message.

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


