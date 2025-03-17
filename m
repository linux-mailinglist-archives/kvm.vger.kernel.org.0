Return-Path: <kvm+bounces-41317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7BCA662FA
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:52:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A00CF176D25
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CDEB2063C0;
	Mon, 17 Mar 2025 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XjmkDS/d"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CA1205505;
	Mon, 17 Mar 2025 23:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255512; cv=none; b=na7H1+VZHMJ7YHckAgAOo0pkXY2bJSKd99sgH4G1el36O1YrjaovutaKDVo90pto94JZkE6Y5bOQDs0gS5Iwyp0/buInAgrXQUA+RAW5KIj+GoYRLSjJnnzaGcJft6lGk48UmQAuOsBrkVbuuSOKK+mHwtq0RtfWSDi45ApDv7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255512; c=relaxed/simple;
	bh=XsNjQyivH1Hog8A2iZ+anJbWkZpmM+zPGmHGJX63sTY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t4n/OHjhi2jP49BaWmkLQhAmeRx/yt/+UWcMnjdXww0++Ni680cMkQhu3Ux7dV+Y0ZolKlScJo4cqa3i0qgt7ynh9aWWOwt8mxMyMO3kfzdTN9czmcHITJ1uqYeCZsqjLz4WDOo/5z8MGqu5LQFvOQHif89Ik+QfAALpq8X2HTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XjmkDS/d; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLuhUO029836;
	Mon, 17 Mar 2025 23:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=2c4Tw6svFVVlMG5F1jrrJOHoil02h
	jZZOtzQ9FEz1Hc=; b=XjmkDS/degSYOs30P9v6YK8zMDZzuoaBFVKatpuNs34Ex
	vwCVEEnUF0xK5Aw/3SHHO+AiKKrMSRs5f59rmr/Mvfa8KX812tl9QbMYMlC/lpCz
	+zmQ77dYUONLOk9ZkIADZtAw+LwrBbao+33/sJfNvuywOhKtARYhwgSxxkpR0fNh
	hxsTMCjAz+mL2S10CZhRWyz3JVeOZ9ToVCtm/HeCBcdA6leVsRC8Ngy/rVo32xCr
	0wqG28JCnuMI6G6PHQX+XV3RH6tbbmY3CFdiucUvNVMKW3Gazw561sOS/OXa9W0w
	+PIU6m6XIlcH0XiK9VDqot7zCVWxPTNgN4r/iZhlw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d23rv2yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLjXp0022498;
	Mon, 17 Mar 2025 23:51:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeekf77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:45 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52HNpi2f016519;
	Mon, 17 Mar 2025 23:51:44 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeekf68-1;
	Mon, 17 Mar 2025 23:51:44 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/10] vhost-scsi: log write descriptors for live migration (and three bugfix)
Date: Mon, 17 Mar 2025 16:55:08 -0700
Message-ID: <20250317235546.4546-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
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
X-Proofpoint-GUID: zpUf-Csj4TO_jCYy7QHMXr_QTfgwFaBB
X-Proofpoint-ORIG-GUID: zpUf-Csj4TO_jCYy7QHMXr_QTfgwFaBB

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
  - Don't allocate log buffer during initialization. Allocate during
    VHOST_SET_FEATURES or VHOST_SCSI_SET_ENDPOINT.
  - Add bugfix for vhost_scsi_send_status().

Dongli Zhang (vhost-scsi bugfix):
  vhost-scsi: protect vq->log_used with vq->mutex
  vhost-scsi: Fix vhost_scsi_send_bad_target()
  vhost-scsi: Fix vhost_scsi_send_status()

Dongli Zhang (log descriptor, suggested by Joao Martins):
  vhost: modify vhost_log_write() for broader users
  vhost-scsi: adjust vhost_scsi_get_desc() to log vring descriptors
  vhost-scsi: cache log buffer in I/O queue vhost_scsi_cmd
  vhost-scsi: log I/O queue write descriptors
  vhost-scsi: log control queue write descriptors
  vhost-scsi: log event queue write descriptors
  vhost: add WARNING if log_num is more than limit

 drivers/vhost/net.c   |   2 +-
 drivers/vhost/scsi.c  | 314 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/vhost/vhost.c |  46 +++++--
 drivers/vhost/vhost.h |   2 +-
 4 files changed, 322 insertions(+), 42 deletions(-)


base-commit: 9d8960672d63db4b3b04542f5622748b345c637a
branch: remotes/origin/linux-next
tree: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git

Thank you very much!

Dongli Zhang


