Return-Path: <kvm+bounces-42543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E2BA79C17
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108433B483A
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 06:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C54F1E3761;
	Thu,  3 Apr 2025 06:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cqq5Ngks"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3B21A83F8;
	Thu,  3 Apr 2025 06:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743661961; cv=none; b=pMdgy58UveLnX6dXjvYB2WtTGTRLt8DG98/5ZEIPp96Utb/nkwWLuUrg2dNuKf3Y8uQUdt+aOpb+QvSiaSvtdPqjYs+aXr8O91iS5a1g8vB3awFfqzr7i3+UL5MntQle2N5nL/xKUxbB7Jo2MJZs868uv2fZvNXh9EC2RI4rf+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743661961; c=relaxed/simple;
	bh=3K/UlJs1dsf97yiuY6Bb9E5kNsDbytX9WTP2odegu0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+CiR0eBeaVxf9uA13LGVIcz4yRp35mxfKgOdJ0Zm0TdJhSpILcSfnZHNYW7dwX8yVCRFJg9LxhySnL6cP9qW8seySXjuyYz4fJMrjIgcekChliR/2eWE4hyXc7/ZFH5vAS+TQHxNWBn96mF/Fz/Ij/lZP84+q5el7RFpdgOQVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cqq5Ngks; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 532NMpAo032002;
	Thu, 3 Apr 2025 06:32:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=t+nxk
	K3nseyGMWW6rfotAeAMK3+o2XHXb4dX0pbXGTs=; b=Cqq5NgkslT2YCNfzFfAkP
	9z+tppr4QSuZzZq8se46FEyVBhhm6LvyIp4D114mg9hPXi2FUjPDhpz5A1GfVHZ0
	2AJojCLRHjbnyAe/rU7i86PZySa60YEryzfN3Gf5pFRQesjE3F58Gc+iLmLu/Y/x
	lIKCrzqrRPKEDcyuwof4fRX2dhdAt14wqnAuLE8sopYscynjw32nslNSHbO4K8b5
	GI9zPUHqqZc9B+Id3iM82pYxotnhSPGTbdD/xGOtKKRA1vXoltgufu1IpDNkVxzY
	ps9EneRM+tSCPPnhcE5HnbpdYspkA8fFo5lMYIUNtIXDsk7WHPjux6b7U+gLmDqZ
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p8fscgj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5335TvbF002700;
	Thu, 3 Apr 2025 06:32:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45pr8stj6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:33 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5336WTxB032092;
	Thu, 3 Apr 2025 06:32:33 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45pr8stj4h-5;
	Thu, 03 Apr 2025 06:32:32 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/9] vhost: modify vhost_log_write() for broader users
Date: Wed,  2 Apr 2025 23:29:49 -0700
Message-ID: <20250403063028.16045-5-dongli.zhang@oracle.com>
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
X-Proofpoint-ORIG-GUID: bs2I2fp2F0QdzTm1k6L_zahEYWqeGS6A
X-Proofpoint-GUID: bs2I2fp2F0QdzTm1k6L_zahEYWqeGS6A

Currently, the only user of vhost_log_write() is vhost-net. The 'len'
argument prevents logging of pages that are not tainted by the RX path.

Adjustments are needed since more drivers (i.e. vhost-scsi) begin using
vhost_log_write(). So far vhost-net RX path may only partially use pages
shared via the last vring descriptor. Unlike vhost-net, vhost-scsi always
logs all pages shared via vring descriptors. To accommodate this,
use (len == U64_MAX) to indicate whether the driver would log all pages of
vring descriptors, or only pages that are tainted by the driver.

In addition, removes BUG().

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v2:
  - Document parameters of vhost_log_write().
  - Use (len == U64_MAX) to indicate whether log all pages, instead of
    introducing a new parameter.

 drivers/vhost/vhost.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9ac25d08f473..494b3da5423a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2304,6 +2304,19 @@ static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
 	return 0;
 }
 
+/*
+ * vhost_log_write() - Log in dirty page bitmap
+ * @vq:      vhost virtqueue.
+ * @log:     Array of dirty memory in GPA.
+ * @log_num: Size of vhost_log arrary.
+ * @len:     The total length of memory buffer to log in the dirty bitmap.
+ *	     Some drivers may only partially use pages shared via the last
+ *	     vring descriptor (i.e. vhost-net RX buffer).
+ *	     Use (len == U64_MAX) to indicate the driver would log all
+ *           pages of vring descriptors.
+ * @iov:     Array of dirty memory in HVA.
+ * @count:   Size of iovec array.
+ */
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 		    unsigned int log_num, u64 len, struct iovec *iov, int count)
 {
@@ -2327,15 +2340,14 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
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
+		if (len != U64_MAX)
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
-- 
2.39.3


