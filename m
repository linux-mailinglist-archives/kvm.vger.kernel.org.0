Return-Path: <kvm+bounces-37628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7631A2CBC1
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 19:45:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75241162BEC
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D701D619F;
	Fri,  7 Feb 2025 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NyI3jb6c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5871A5BA9;
	Fri,  7 Feb 2025 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738953786; cv=none; b=J89cZrzVWgh2h1qk3dg5VRhCUCDMsBvHu0XNg5rjgEz1BLeXy+P9aqNH0/QYWv1ja9X7mbARiSZew5F9bIjLG9P+8l/ELbiKjyz9WhuT94QsSaKwdBu+E0vYyXCCTGkM3pavXfHK6cnPqbHD6pcl8X1yLU/5Dh6ShQ0oFfynxYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738953786; c=relaxed/simple;
	bh=xYRoMaqK+fegCTjStXrdl72EPrXOJeqEDX3VwEbscKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H5TCqIjAZaLe/JTh7p+lJ/KBSoeaIzHsB7/ZbY+NFRHe3UzaCKDpcWv9yvORpi72+PTHynu8JFKQf8EeL1+jfN0pNUOqi4kMtwLzn9raXoO0F2kfdrCJ4wnY1RoYy6mBTyaUycov5uiZIxNbFF7eS9UD8vP0HIgZ/3+u0J6bd08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NyI3jb6c; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517HfrV3009266;
	Fri, 7 Feb 2025 18:42:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=Yo6tS6gz0B0pEFDUsuyiuKIMv39Hk
	Djy5iWRR+R2NpQ=; b=NyI3jb6cKnV/keBEl377RD9Y8lqdCcSTj5sDlJQV8OP5C
	1VqXNRm/7JXQAtWWXzGmDH2nWiWQfcN+Z6uJKf26EMpG9wRHF5FSX1hd6ftkrqK9
	wCOQTzsY6VKYmS5ATLIwfZS8if9DeeJHGysUcvQmFO75F7v50hojQYQ7oAfbG+Xo
	zE3x8dy10mzzBIZNEMPLjr010f769UAl7uK4+ILIdT/0+66hyjtAtPJ9at/bu4XK
	s6Y7Bs6qTUmIuItcpBxW0S9aflIjuDm9VH6bOd8F/Y0CSndxj5WJ8lg2M019lQqL
	TGXjg3LpKuk1AG5zQjUoyBVS5OF/c6kloPvl2dkdA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44mwwpjqs0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517H04iR023083;
	Fri, 7 Feb 2025 18:42:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8ec866t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:42:54 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 517Idx9J037660;
	Fri, 7 Feb 2025 18:42:54 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8ec8665-1;
	Fri, 07 Feb 2025 18:42:54 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        michael.christie@oracle.com, pbonzini@redhat.com, stefanha@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] vhost-scsi: log write descriptors for live migration (and two bugfix)
Date: Fri,  7 Feb 2025 10:41:44 -0800
Message-ID: <20250207184212.20831-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
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
X-Proofpoint-ORIG-GUID: gUmi0H9VoKB3Ekahu6yr9dbo3H8GXgXM
X-Proofpoint-GUID: gUmi0H9VoKB3Ekahu6yr9dbo3H8GXgXM

The live migration with vhost-scsi has been enabled by QEMU commit
b3e89c941a85 ("vhost-scsi: Allow user to enable migration"), which
thoroughly explains the workflow that QEMU collaborates with vhost-scsi on
the live migration.

Although it logs dirty data for the used ring, it doesn't log any write
descriptor (VRING_DESC_F_WRITE).

In comparison, vhost-net logs write descriptors via vhost_log_write(). The
SPDK (vhost-user-scsi backend) also logs write descriptors via
vhost_log_req_desc().

As a result, there is likely data mismatch between memory and vhost-scsi
disk during the live migration.

1. Suppose there is high workload and high memory usage. Suppose some
systemd userspace pages are swapped out to the swap disk.

2. Upon request from systemd, the kernel reads some pages from the swap
disk to the memory via vhost-scsi.

3. Although those userspace pages' data are updated, they are not marked as
dirty by vhost-scsi (this is the bug). They are not going to migrate to the
target host during memory transfer iterations.

4. Suppose systemd doesn't write to those pages any longer. Those pages
never get the chance to be dirty or migrated any longer.

5. Once the guest VM is resumed on the target host, because of the lack of
those dirty pages' data, the systemd may run into abnormal status, i.e.,
there may be systemd segfault.

Log all write descriptors to fix the issue.

In addition, the patchset also fixes two bugs in vhost-scsi.

Dongli Zhang (log descriptor, suggested by Joao Martins):
  vhost: modify vhost_log_write() for broader users
  vhost-scsi: adjust vhost_scsi_get_desc() to log vring descriptors
  vhost-scsi: cache log buffer in I/O queue vhost_scsi_cmd
  vhost-scsi: log I/O queue write descriptors
  vhost-scsi: log control queue write descriptors
  vhost-scsi: log event queue write descriptors
  vhost: add WARNING if log_num is more than limit

Dongli Zhang (vhost-scsi bugfix):
  vhost-scsi: protect vq->log_used with vq->mutex
  vhost-scsi: Fix vhost_scsi_send_bad_target()

 drivers/vhost/net.c   |   2 +-
 drivers/vhost/scsi.c  | 191 +++++++++++++++++++++++++++++++++++++++------
 drivers/vhost/vhost.c |  46 ++++++++---
 drivers/vhost/vhost.h |   2 +-
 4 files changed, 206 insertions(+), 35 deletions(-)


base-commit: 5c8c229261f14159b54b9a32f12e5fa89d88b905

Thank you very much!

Dongli Zhang


