Return-Path: <kvm+bounces-37630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D05FBA2CBC7
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 19:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 159BE7A7B02
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B0E1DB55D;
	Fri,  7 Feb 2025 18:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R3z/2E48"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656CB1AAA10;
	Fri,  7 Feb 2025 18:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953787; cv=none; b=To5mhA0eM2z+UTk1zpnoYP+1EF0a9cVlkA0PnzIe+fqZb8D6Lm2G9uVLDAxPJ0tB1m8V2XN0ST5Nw6LUO3aHIkS/5wCgULGVim+fSlnIAReDeTHEXofdMocmN9UZtnTc5twu60JCpsTOOT3hwue+hiN1mMC3GYqnwZtosX4jQPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953787; c=relaxed/simple;
	bh=cPAdDcIzCEKs56dgAaNj1MQuvQzaDRfcPqE4lVRK/ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzU1czON4J+xJ9uCWBihrYu4CpewxP5GDLBWrqltXcU1/zWXiVIw7saL7gpaZ7eodG47jLvYA4Q8P28xJx9OeOXpvN9g4Lm6vOlzkR6a2u+iKB4yfEaHcpWYsO/GPaDjIPnookS7doqonkP4HxlYfMG1c20X3Wg2L6eJvwwIJf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R3z/2E48; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517Hg7KH000629;
	Fri, 7 Feb 2025 18:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=Dmes3
	R9tkzYX7VMGKXll9aiulkQtaayDUW51RCRhbDM=; b=R3z/2E481tEaXcSwPkuXZ
	WPGoprAwAUpCqyMGqoYI4FYdcEHNlOnTmyNOwlx2mRyx8emF5K77a9S+kvU+9Eqp
	9/ndSfNeu9TWlWJRZtogxm7pdHkTcElND7hxCcZDZpdow2oISegJDoD27zT/tvv/
	2HDw/nPd7BOMtRmZm+SN4+PQGP0BO2SNi5qStIaRYr2b214+D/c/w/KLVCpvXMGx
	7YluFE108ezECsDIolZH8F1dOUvoQITXtefUr5DStr6SBA+8MVposwMHmb8b1Gye
	nVRMuYA1jusuyIVyhpQvi6q3xPpUDV8/8XZvM6AUPTOv+zOrkfWLPyu8Ih1cl0Ep
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44mqk8bbh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:43:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517HPB42022524;
	Fri, 7 Feb 2025 18:42:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ec869r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:59 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517Idx9V037660;
	Fri, 7 Feb 2025 18:42:59 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8ec8665-7;
	Fri, 07 Feb 2025 18:42:59 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] vhost-scsi: log event queue write descriptors
Date: Fri,  7 Feb 2025 10:41:50 -0800
Message-ID: <20250207184212.20831-7-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: UvnJWz_xjjUFu1lhQBiwxCCLEbFsljie
X-Proofpoint-ORIG-GUID: UvnJWz_xjjUFu1lhQBiwxCCLEbFsljie

Log write descriptors for the event queue, leveraging vhost_get_vq_desc()
to retrieve the array of write descriptors to obtain the log buffer.

There is only one path for event queue.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/vhost/scsi.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 21c2d07b806a..40268b88f470 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -498,6 +498,8 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 	struct vhost_virtqueue *vq = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
 	struct virtio_scsi_event *event = &evt->event;
 	struct virtio_scsi_event __user *eventp;
+	struct vhost_log *vq_log;
+	unsigned int log_num;
 	unsigned out, in;
 	int head, ret;
 
@@ -508,9 +510,19 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 
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
@@ -540,6 +552,8 @@ vhost_scsi_do_evt_work(struct vhost_scsi *vs, struct vhost_scsi_evt *evt)
 		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
 	else
 		vq_err(vq, "Faulted on vhost_scsi_send_event\n");
+
+	vhost_scsi_log_write(vq, vq_log, log_num);
 }
 
 static void vhost_scsi_complete_events(struct vhost_scsi *vs, bool drop)
-- 
2.39.3


