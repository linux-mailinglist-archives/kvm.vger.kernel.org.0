Return-Path: <kvm+bounces-41320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CF10BA6630C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D47B57AA262
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:52:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133E9207DF0;
	Mon, 17 Mar 2025 23:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R12Nb3us"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884BD20766B;
	Mon, 17 Mar 2025 23:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255519; cv=none; b=Wdbf+Zfc01J/wePUxXf14iK5lGP83layT3Rt+xnq5Il9p6pPcLGIY91B+iBStZhb3h3Kmv618PaxEMFceiCHP+Gzw49yA1DkE6wRqQ3JfV2636OKulKQzTpZnXSjoQRiBex8I0xqajHjqer4w14Xq/EsnSEkhghgbjlfXw9Sb6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255519; c=relaxed/simple;
	bh=I712f/ybYciN9xr4XP7PBKt2U1U4pSyUKrVaQc6a4R8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGJT45+urUVh6Kb6JXMDithAJm5FOrwS2JHLLFFcLArPjfg7ll+/rXwBf6u+MExwTlBT2dKUNxrz6QnFDx2UhvNd2RhHW0z2yabBqtvWSKosAwVTZtg8CwymhnpiynizSRUBlSEkaoS8ao35vpv4yScDou7r4oovMbYtIbFRb9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R12Nb3us; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLucGc029809;
	Mon, 17 Mar 2025 23:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=weOnP
	/Gb9PD/eYhEwL9QyTYVOol4UfY29GaLwn7/mlc=; b=R12Nb3usycjOrflLOHuZ5
	zHYd8EbDu6BJKIKL2z4apSRgOzQLS1NtOx0RgdWlBb4kGmfsBVKSi1yPxM6aFODT
	Y9AC+lXYt/pXIo0R2OvC4h/GnzyMeBBziLL1MV/PVimJA20ukxPY9H5IlFcmrZt1
	kXF+RdBPBnVD0ESEh6bEg2oOd53CrR0El/R1zrJX51tGvSB7NZCIMo8wAsXkOwHu
	7CuCxHKvHxTNMNmfDdqKybfpquyRU/wYQozb0BQgz7y7+JiDQ162VnucMrSV4bDi
	+9NQW4RoVCQF+8UYdrIVmBHK9Rf7eaob0SNT7RLkF5U9CG2z+eACKb6ku8TFMRuE
	Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d23rv308-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLo3wR022502;
	Mon, 17 Mar 2025 23:51:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeekfbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:52 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52HNpi2x016519;
	Mon, 17 Mar 2025 23:51:51 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeekf68-10;
	Mon, 17 Mar 2025 23:51:51 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/10] vhost-scsi: log event queue write descriptors
Date: Mon, 17 Mar 2025 16:55:17 -0700
Message-ID: <20250317235546.4546-10-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: LJEtfEhdaEw5POSoTogTEgwDDpZdGXa5
X-Proofpoint-ORIG-GUID: LJEtfEhdaEw5POSoTogTEgwDDpZdGXa5

Log write descriptors for the event queue, leveraging vhost_get_vq_desc()
to retrieve the array of write descriptors to obtain the log buffer.

There is only one path for event queue.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/vhost/scsi.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 3cdc5c2fa60e..525610bbabc9 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -550,6 +550,8 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct virtio_scsi_event *event = &evt->event;
 	struct virtio_scsi_event __user *eventp;
+	struct vhost_log *vq_log;
+	unsigned int log_num;
 	unsigned out, in;
 	int head, ret;
 
@@ -560,9 +562,19 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 
 again:
 	vhost_disable_notify(&vs->dev, vq);
+
+	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
+		vq->log : NULL;
+
+	/*
+	 * Reset 'log_num' since vhost_get_vq_desc() may reset it only
+	 * after certain condition checks.
+	 */
+	log_num = 0;
+
 	head = vhost_get_vq_desc(vq, vq->iov,
 			ARRAY_SIZE(vq->iov), &out, &in,
-			NULL, NULL);
+			vq_log, &log_num);
 	if (head < 0) {
 		vs->vs_events_missed = true;
 		return;
@@ -592,6 +604,8 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
 	else
 		vq_err(vq, "Faulted on vhost_scsi_send_event\n");
+
+	vhost_scsi_log_write(vq, vq_log, log_num);
 }
 
 static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
-- 
2.39.3


