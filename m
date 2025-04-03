Return-Path: <kvm+bounces-42539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81776A79BFE
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 08:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26FAD1893863
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 06:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD211A2C06;
	Thu,  3 Apr 2025 06:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z45EOcJu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328219F416;
	Thu,  3 Apr 2025 06:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743661958; cv=none; b=bSDaeHAhhvqExBurs9teAkgaHVP85OSSp8Mqs9sKnDtLuHGMFtlv5FTz4PUpT0X9w6TatY6oRSMOLhjUWtdm64rJOoQVUEaNmgrUMYtU6gF3LYO1rH+MpZIvbA7pXyHV2JnxPfoilVbk0hw+pLoO/QtXt9ldFjooibLF4HP6Zgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743661958; c=relaxed/simple;
	bh=j7Ru8mv8vnhUetnXdIui0NsBTj10RY4l3etu2Ql1sBw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tuYCb335O45tS5UQrSi3rlRUVer+yieXSHo/rp99kNkxPHRcmlsSpqEa9PPIfOYuoY0wP7Fi7nGUTtiK0+6bPhL8KtAoxxJvoRRTzyj2gpyQ5x3hwi3zIkCHv4qJxFBg9AuG56AuWT7xE5Qrza1uo+2RsvE2mR2oGjVH03wtho0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z45EOcJu; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 532NMpAn032002;
	Thu, 3 Apr 2025 06:32:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=TdjQnHvAXtYqsVzceeZ1eHE+nHufv
	Tv/MEQX+acT2uQ=; b=Z45EOcJuDyVW5dcnnjqa0vSdflpHFBJkf4/iWEwd6O015
	65r71ZjwnGWvql4qP1B6CjxiFhowVMHIzrINIeqW36GGcF14IbuFdfA2M5Lk1k3t
	edWxamrk9IeaPQ8URk2vtlMACGrOpFH5FDoe8IwA031yM52ug2+CXb4FAJo29xmT
	PWqy/CXmTxrWItZhrBCoXgoehFKYoVmurl7YcL2CAO7ViOb9WYEGdZ9XTzGU9PwZ
	5MEeCZ6YUFDx749E6zC025mlAuR4UChICsirHp+UoONSFJiKSy1tweI68H7pkQUr
	N5YXjROF1p5E8yK/pC86E94ec81SDz8LvpAtJ0TCw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p8fscgj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5334ocZ4002579;
	Thu, 3 Apr 2025 06:32:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45pr8stj51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 03 Apr 2025 06:32:30 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5336WTx3032092;
	Thu, 3 Apr 2025 06:32:30 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45pr8stj4h-1;
	Thu, 03 Apr 2025 06:32:29 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/9] vhost-scsi: log write descriptors for live migration (and three bugfix) 
Date: Wed,  2 Apr 2025 23:29:45 -0700
Message-ID: <20250403063028.16045-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
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
X-Proofpoint-ORIG-GUID: t6yg06fUEEFEuMNQhy6DMoBp1QzRoUiE
X-Proofpoint-GUID: t6yg06fUEEFEuMNQhy6DMoBp1QzRoUiE

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

In addition, the patchset also fixes three bugs in vhost-scsi.

Changed since v1:
  - Rebase on top of most recent vhost changes.
  - Don't allocate log buffer during initialization. Allocate only once for
    each command. Don't free until not used any longer.
  - Add bugfix for vhost_scsi_send_status().
Changed since v2:
  - Document parameters of vhost_log_write().
  - Use (len == U64_MAX) to indicate whether log all pages, instead of
    introducing a new parameter.
  - Merge PATCH 6 and PATCH 7 from v2 as one patch, to Allocate for only
    once in submission path in runtime. Reclaim int
    VHOST_SET_FEATURES/VHOST_SCSI_SET_ENDPOINT.
  - Encapsulate the one-time on-demand per-cmd log buffer alloc/copy in a
    helper, as suggested by Mike.

Dongli Zhang (vhost-scsi bugfix):
  vhost-scsi: protect vq->log_used with vq->mutex
  vhost-scsi: Fix vhost_scsi_send_bad_target()
  vhost-scsi: Fix vhost_scsi_send_status()

Dongli Zhang (log descriptor, suggested by Joao Martins):
  vhost: modify vhost_log_write() for broader users
  vhost-scsi: adjust vhost_scsi_get_desc() to log vring descriptors
  vhost-scsi: log I/O queue write descriptors
  vhost-scsi: log control queue write descriptors
  vhost-scsi: log event queue write descriptors
  vhost: add WARNING if log_num is more than limit

 drivers/vhost/scsi.c  | 264 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/vhost/vhost.c |  46 ++++++--
 2 files changed, 273 insertions(+), 37 deletions(-)


base-commit: ac34bd6a617c03cad0fbb61f189f7c4dafbbddfb
branch: remotes/origin/linux-next
tree: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git

Thank you very much!

Dongli Zhang


