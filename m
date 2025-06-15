Return-Path: <kvm+bounces-49565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78CEEADA2D1
	for <lists+kvm@lfdr.de>; Sun, 15 Jun 2025 19:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BF7116E378
	for <lists+kvm@lfdr.de>; Sun, 15 Jun 2025 17:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D869E27C84E;
	Sun, 15 Jun 2025 17:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kXqGAMrZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6233E1DA21;
	Sun, 15 Jun 2025 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750009185; cv=none; b=pm+JwNYBEIHO6ZGgC/aS8CY6WdrsAHhq//0UUBvH9QUrd0YkxuY4VF7fsETsvwoxSP2hjiR5e6xWc9qVgby1a7jejQjSsrljE9/21kQkTbPHDFVLlVMW91X2tKyQzuzg/q/Qrk0Iv1QB7APcI/79TpOAVA8UEmCzv+ccCS7lTt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750009185; c=relaxed/simple;
	bh=UBe7ZI2S/I2GLHGBNylfL8K9GtWYxlCEE1bt1BngSGY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aAzpjLhdj85VYebRTZM1vRVznOF9UA8DAWm8L/hJjQHuEo//YX76gHoOTdY9bV3kt9hen5+ktqwudRJdKpZUyZXQeqt4cUvZszSUTDA0FREKGbx03XMhWBAxIrdKXFjQe4WSWEvZBM0jOkCOIKGC4axaPN8/aUp6uSmzEMkO098=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kXqGAMrZ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55FFF1Tr010054;
	Sun, 15 Jun 2025 17:39:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=NCs7c1l7MM/8D4zXiWpe0mT4C5cvI
	JZJSbDPhF+plTs=; b=kXqGAMrZ6uFDmlCdCrnm8vRzXVT3oRQYvtbKH8N2+h1km
	U3ckhJ2PVzqbmAokxLt7tEfTtgc2184I/SvwlEJl7iwQv5Bm0oVGVpk8khEBqKvt
	K+529QwQ7CdEwzQd/fPHxLFxltxa5Y4ZKpW66KrMHEUNqpalU8FU9gWzHgzLY15a
	mrdwb7CZejHUb2dXzQ4k1GsvSXNbhPBsJHTojlCsolY3Ofc1sUFLDaKz/bUduC1h
	MP0o5kUkUyj9msIwxauuB+I1/5AarqyfExpuOWW9rjOBxuqGMuNCupWRQSud4MbQ
	GiosvyOAcRhN/Nr3EiuyI+tnV6mFYFIOU9a+e85Tw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900es9bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Jun 2025 17:39:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55FBhFpM036275;
	Sun, 15 Jun 2025 17:39:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhdn9uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 15 Jun 2025 17:39:36 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55FHdZpL026728;
	Sun, 15 Jun 2025 17:39:36 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 478yhdn9un-1;
	Sun, 15 Jun 2025 17:39:35 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux.dev
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] vhost: Fix typos in comments and clarity on alignof usage
Date: Sun, 15 Jun 2025 10:39:11 -0700
Message-ID: <20250615173933.1610324-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-15_08,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506150131
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE1MDEzMSBTYWx0ZWRfXyrsi7S/cKvRM IDSDCgDoI3blZmJq84JL229WHFtuhtXw9eq+39qRkUF0/KShdU3yBrPVx3ycVSTKsN0gf1ejVyS Xc7Dt4q+txWjoBz3ZAK++vjGOickbGKLS7DHZEUCRW46OsK2GWecUvvwSfoSdULCI5SN60Uwh6A
 Eo+tRsmZXXGKQWHdtXANP6ZBXbsR1lDPWtmrjNbOVsCZMY62A7R6qtEBmgUuly8LLPPqtJCKccH GLVdMpwLwDJBlokr/64iTrg4F7yqvHid4DMz08zEuwscfhmkykTh+NR7alFOoUFPuO2xe4Jfnhn yJ2jTkYL/61njwlUuVvAa0weQscdTi2CREiOMmmFKwYudT/sSiYjMPAcfrCegZvV/rt7Frbvzr4
 SI3gLDEMaxg3vzUXrrSV4gvT3vp1cndyGAycQeVG9rtxlrrFqvjq0g2kcneMsfAnOVDRxTYS
X-Proofpoint-ORIG-GUID: 2C7unwbj5qbUvxCBi2komyuRMmOih1Jf
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=684f055a b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=yfRN1CPU6vwYn5W2bpUA:9 cc=ntf awl=host:14714
X-Proofpoint-GUID: 2C7unwbj5qbUvxCBi2komyuRMmOih1Jf

This patch fixes multiple typos and improves comment clarity across
vhost.c.
- Correct spelling errors: "thead" -> "thread", "RUNNUNG" -> "RUNNING"
  and "available".
- Improve comment by replacing informal comment ("Supersize me!")
  with a clear description.
- Use __alignof__ correctly on dereferenced pointer types for better
  readability and alignment with kernel documentation.

These changes enhance code readability and maintainability.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/vhost/vhost.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3a5ebb973dba..0227c123c0e0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -594,10 +594,10 @@ static void vhost_attach_mm(struct vhost_dev *dev)
 	if (dev->use_worker) {
 		dev->mm = get_task_mm(current);
 	} else {
-		/* vDPA device does not use worker thead, so there's
-		 * no need to hold the address space for mm. This help
+		/* vDPA device does not use worker thread, so there's
+		 * no need to hold the address space for mm. This helps
 		 * to avoid deadlock in the case of mmap() which may
-		 * held the refcnt of the file and depends on release
+		 * hold the refcnt of the file and depends on release
 		 * method to remove vma.
 		 */
 		dev->mm = current->mm;
@@ -731,7 +731,7 @@ static void __vhost_vq_attach_worker(struct vhost_virtqueue *vq,
 	 * We don't want to call synchronize_rcu for every vq during setup
 	 * because it will slow down VM startup. If we haven't done
 	 * VHOST_SET_VRING_KICK and not done the driver specific
-	 * SET_ENDPOINT/RUNNUNG then we can skip the sync since there will
+	 * SET_ENDPOINT/RUNNING then we can skip the sync since there will
 	 * not be any works queued for scsi and net.
 	 */
 	mutex_lock(&vq->mutex);
@@ -1898,8 +1898,8 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 		return -EFAULT;
 
 	/* Make sure it's safe to cast pointers to vring types. */
-	BUILD_BUG_ON(__alignof__ *vq->avail > VRING_AVAIL_ALIGN_SIZE);
-	BUILD_BUG_ON(__alignof__ *vq->used > VRING_USED_ALIGN_SIZE);
+	BUILD_BUG_ON(__alignof__(*vq->avail) > VRING_AVAIL_ALIGN_SIZE);
+	BUILD_BUG_ON(__alignof__(*vq->used) > VRING_USED_ALIGN_SIZE);
 	if ((a.avail_user_addr & (VRING_AVAIL_ALIGN_SIZE - 1)) ||
 	    (a.used_user_addr & (VRING_USED_ALIGN_SIZE - 1)) ||
 	    (a.log_guest_addr & (VRING_USED_ALIGN_SIZE - 1)))
@@ -2840,7 +2840,7 @@ void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(vhost_signal);
 
-/* And here's the combo meal deal.  Supersize me! */
+/* Add to used ring and signal guest. */
 void vhost_add_used_and_signal(struct vhost_dev *dev,
 			       struct vhost_virtqueue *vq,
 			       unsigned int head, int len)
@@ -2860,7 +2860,7 @@ void vhost_add_used_and_signal_n(struct vhost_dev *dev,
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
 
-/* return true if we're sure that avaiable ring is empty */
+/* return true if we're sure that available ring is empty */
 bool vhost_vq_avail_empty(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
 	int r;
-- 
2.47.1


