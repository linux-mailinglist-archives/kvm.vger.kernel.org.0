Return-Path: <kvm+bounces-37625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 890D6A2CBB0
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 19:44:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA5C17A6F67
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE0B1A5BBC;
	Fri,  7 Feb 2025 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V8ppnauY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E6A1A3145;
	Fri,  7 Feb 2025 18:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953783; cv=none; b=bmf79ewxmhgERcyILOxeLzwVYr/C2OQokaqRT19DYFrRrWGJJlNsXYuf41yRxEZifZPSR8IQ39ZKW3HawabDO2IeUqmoR2fFEQsskNQRIMa7jRIYc/QTJAu4BiBLHa/N9TnfJPMPI1PMMS2yPtwoy/obIifW2xfgjPnNQE3j5zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953783; c=relaxed/simple;
	bh=KZpYGCgP90T/gN1JAyUvL6ue46fXpr3ZBw6UD+zQaSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iA3TWUe9bvFD5QytV+aeWTzvF00agpiRGUH7WLGS/lU2xM6qXX3f6NDRaRPg4A4EB32HPdvsdwLext1pISuHmDGUgzLo/F9JoJAtBlrr/HJrqzGfDnBLKttSuyiXL3cjIXDd8SRftOhv9ARn1NmXHZsqwN/MfukBz5JBW8FHd+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V8ppnauY; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517Hg6xv000482;
	Fri, 7 Feb 2025 18:42:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=Ud1cq
	X2B/Bk8a2z8lXNW+8CRC+VrCZiQVXNoaj7J2aQ=; b=V8ppnauYKhDf/ef/8Meqx
	Ca3X4jihY09ndkSjy652lQ49VBDseL9SfSPz8GjlG8STpn8lKuBP4JjjuZPjZkye
	JBjoE5cF2ancexNRK3Xd4FNb81/vBUq4SJYYtdchgHOsQi9fIOZdPeBOgsy1eNMW
	tNpBsEXmRU3UHGkw61SMBP7GVOiUKtDdL1SrPfF3DE6k5BOq4lAUoRcTWaoz//UR
	5ND2+smqKaHCMr5bKHOmd0trJumsifZRX7f5NJV5+oaIk++X/lg381wKaUp+cTjk
	PY8VMHAA+8Rm7d64c4JeGOSBr43ab3JO/aHtmCajdBCyuPo1zflzt1lJbkqSkke0
	A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44mqk8bbh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517HiGLA022576;
	Fri, 7 Feb 2025 18:42:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ec867n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:56 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517Idx9N037660;
	Fri, 7 Feb 2025 18:42:56 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8ec8665-3;
	Fri, 07 Feb 2025 18:42:56 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] vhost-scsi: adjust vhost_scsi_get_desc() to log vring descriptors
Date: Fri,  7 Feb 2025 10:41:46 -0800
Message-ID: <20250207184212.20831-3-dongli.zhang@oracle.com>
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
X-Proofpoint-GUID: LqyZ_sjfs2KJG3yuPs4Dcj8sh6sNCnPD
X-Proofpoint-ORIG-GUID: LqyZ_sjfs2KJG3yuPs4Dcj8sh6sNCnPD

Adjust vhost_scsi_get_desc() to facilitate logging of vring descriptors.

Add new arguments to allow passing the log buffer and length to
vhost_get_vq_desc().

In addition, reset 'log_num' since vhost_get_vq_desc() may reset it only
after certain condition checks.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/vhost/scsi.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 718fa4e0b31e..ee2310555740 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -950,13 +950,17 @@ vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 
 static int
 vhost_scsi_get_desc(struct vhost_scsi *vs, struct vhost_virtqueue *vq,
-		    struct vhost_scsi_ctx *vc)
+		    struct vhost_scsi_ctx *vc,
+		    struct vhost_log *log, unsigned int *log_num)
 {
 	int ret = -ENXIO;
 
+	if (likely(log_num))
+		*log_num = 0;
+
 	vc->head = vhost_get_vq_desc(vq, vq->iov,
 				     ARRAY_SIZE(vq->iov), &vc->out, &vc->in,
-				     NULL, NULL);
+				     log, log_num);
 
 	pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
 		 vc->head, vc->out, vc->in);
@@ -1086,7 +1090,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	vhost_disable_notify(&vs->dev, vq);
 
 	do {
-		ret = vhost_scsi_get_desc(vs, vq, &vc);
+		ret = vhost_scsi_get_desc(vs, vq, &vc, NULL, NULL);
 		if (ret)
 			goto err;
 
@@ -1411,7 +1415,7 @@ vhost_scsi_ctl_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	vhost_disable_notify(&vs->dev, vq);
 
 	do {
-		ret = vhost_scsi_get_desc(vs, vq, &vc);
+		ret = vhost_scsi_get_desc(vs, vq, &vc, NULL, NULL);
 		if (ret)
 			goto err;
 
-- 
2.39.3


