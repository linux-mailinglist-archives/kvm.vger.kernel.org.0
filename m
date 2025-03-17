Return-Path: <kvm+bounces-41319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE36DA66307
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:53:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 216F6189C96D
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86A6207649;
	Mon, 17 Mar 2025 23:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XJWVTSw1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500032063EE;
	Mon, 17 Mar 2025 23:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255516; cv=none; b=oD5c050y5zQ0i9tKmt4RiGTyJAiRE0r8anJaulBbFMiNoPxwkrJEG9VQD174DxJvRotI8kyk3vdIR3DpFcTpdcQ2Zk8nr4OnMihWEM3Pe7VstprdJzRuDnkcdsLEYbX9sxhMNETkTTMNePXAIlsD5XRJh3utz7xMRVAxVMQtzjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255516; c=relaxed/simple;
	bh=GjBNQ6+NVFKyJGJPRf5FY78SvbrtMuBCufejpM0iu5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTQUnRvq3u+dsNso09wwJMzFpvHqbTTa7wTWgIM/nOfMxtSFQVDtW+z+FOeClnMnQ9OQAASgiVaEsvFg5I7qxmfVrGVCzRAyI5XkgWIwfznMnJ+dyP4TR0OI9fMOsqfYoh3dGjxcEnIvTIhTJJBk155FzBfVjZEHIBpLOIF/JrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XJWVTSw1; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLtvY7028310;
	Mon, 17 Mar 2025 23:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=Q11OU
	aRwLsU4W0d17uY17NUHcyRRAjGZ3xTHFdH0R20=; b=XJWVTSw1GmwcfQ1i/lWjd
	4FzVehRynLdKPvshyTmIHhon09XZpOeYXWvQlQJw+c5BPJRSQ6l+8+0sZSvMEpez
	i+BokAPytapVWJ010opwhjqaZjrlSkgN9uRVAPX0kBXeXZViZYVisAIzorDZwZ/w
	+72E9BtKmg845whBRd3m2DdbkxSHxamCoOOzvulXpxxr4Puh8D4OVux/d9pieWx8
	PDgTJromM2SvVwjz4sRYdGqKHm7zsRsErU0Ic2Tmve29wp6N/jXxvyd9/CC5CzuB
	GWevRn/GJz11uMgy2uOTxHQpsaa9GG1zh2jLN/NReAOb0pXLsI6DDdzFY1akKzRb
	Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d23rv303-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLXjeV023051;
	Mon, 17 Mar 2025 23:51:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeekf9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:48 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52HNpi2n016519;
	Mon, 17 Mar 2025 23:51:47 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeekf68-5;
	Mon, 17 Mar 2025 23:51:47 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/10] vhost: modify vhost_log_write() for broader users
Date: Mon, 17 Mar 2025 16:55:12 -0700
Message-ID: <20250317235546.4546-5-dongli.zhang@oracle.com>
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
 adultscore=0 mlxlogscore=981 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503170173
X-Proofpoint-GUID: JuWQprw7Op6UhA4vIqhU_DL2z1_HuuCx
X-Proofpoint-ORIG-GUID: JuWQprw7Op6UhA4vIqhU_DL2z1_HuuCx

Currently, the only user of vhost_log_write() is vhost-net. The 'len'
argument prevents logging of pages that are not tainted by the RX path.

Adjustments are needed since more drivers (i.e. vhost-scsi) begin using
vhost_log_write(). So far vhost-net RX path may only partially use pages
shared by the last vring descriptor. Unlike vhost-net, vhost-scsi always
logs all pages shared via vring descriptors. To accommodate this, a new
argument 'partial' is introduced. This argument works alongside 'len' to
indicate whether the driver should log all pages of a vring descriptor, or
only pages that are tainted by the driver.

In addition, removes BUG().

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/vhost/net.c   |  2 +-
 drivers/vhost/vhost.c | 28 +++++++++++++++++-----------
 drivers/vhost/vhost.h |  2 +-
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b9b9e9d40951..0e5d82bfde76 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1219,7 +1219,7 @@ static void handle_rx(struct vhost_net *net)
 		if (nvq->done_idx > VHOST_NET_BATCH)
 			vhost_net_signal_used(nvq);
 		if (unlikely(vq_log))
-			vhost_log_write(vq, vq_log, log, vhost_len,
+			vhost_log_write(vq, vq_log, log, vhost_len, true,
 					vq->iov, in);
 		total_len += vhost_len;
 	} while (likely(!vhost_exceeds_weight(vq, ++recv_pkts, total_len)));
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9ac25d08f473..db3b30aba940 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2304,8 +2304,14 @@ static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
 	return 0;
 }
 
-int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
-		    unsigned int log_num, u64 len, struct iovec *iov, int count)
+/*
+ * 'len' is used only when 'partial' is true, to indicate whether the
+ * entire length of each descriptor is logged.
+ */
+int vhost_log_write(struct vhost_virtqueue *vq,
+		    struct vhost_log *log, unsigned int log_num,
+		    u64 len, bool partial,
+		    struct iovec *iov, int count)
 {
 	int i, r;
 
@@ -2323,19 +2329,19 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 	}
 
 	for (i = 0; i < log_num; ++i) {
-		u64 l = min(log[i].len, len);
+		u64 l = partial ? min(log[i].len, len) : log[i].len;
+
 		r = log_write(vq->log_base, log[i].addr, l);
 		if (r < 0)
 			return r;
-		len -= l;
-		if (!len) {
-			if (vq->log_ctx)
-				eventfd_signal(vq->log_ctx);
-			return 0;
-		}
+
+		if (partial)
+			len -= l;
 	}
-	/* Length written exceeds what we have stored. This is a bug. */
-	BUG();
+
+	if (vq->log_ctx)
+		eventfd_signal(vq->log_ctx);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vhost_log_write);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index bb75a292d50c..5de5941988fe 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -224,7 +224,7 @@ bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);
 bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
-		    unsigned int log_num, u64 len,
+		    unsigned int log_num, u64 len, bool partial,
 		    struct iovec *iov, int count);
 int vq_meta_prefetch(struct vhost_virtqueue *vq);
 
-- 
2.39.3


