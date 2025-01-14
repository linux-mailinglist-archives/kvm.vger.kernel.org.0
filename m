Return-Path: <kvm+bounces-35348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8ED7A0FFB1
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 04:45:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 451047A1023
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 03:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C854123354F;
	Tue, 14 Jan 2025 03:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZlD/pW6F"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81ACF23353E;
	Tue, 14 Jan 2025 03:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736826314; cv=none; b=qLK1NwdcB3piVHVq3HobHsobkUEZ19CidPmt4xT2Tc42ejs4wAKeQv+qluflruclc6FhKedECf6cXjmMDHnmPT+MpNm32bUKot+RAHIJJO7+QaljWUt7+sUyOCXitf4SWozt0fsRdJGesQQanNLzchbRovv1NPQke1DgyEMvfpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736826314; c=relaxed/simple;
	bh=2baHxOsNceSbrX10gqrwuzixoNlNazn7+PaRhMyQkxI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cp3gseJBfWQ+yq8oq5GQ6CixFef98JVg+NVaaA7LymrtjQEJ6V/a48zi2GxVPU5VEwDIpiUCsOKyHc2ty4/D4ZBzPd6FOvO4XjfaIVrlSfC14r98L9CFVilKwJU/Jmm+YtxeX39su9LZK01ywtEV0yw5UQGtC17Rl9olwzwCFj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZlD/pW6F; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=UoS5+
	02hH/0supJSB9Kntv/yoTCeLsbOH/xeO+/RD0A=; b=ZlD/pW6Fiko//PgEn53v/
	kvADpYREVeCzYtqhdaeIKyu/riT/aADa0ErCh97htNwGzLLR22692FXT5dS+ox1w
	Xk6Z2IVcvdL4QamqMFluLhUhU1tRrVvKanshM+errg5l6dKlKhZrXS5sCo2hJfpr
	hSL5fXQ1jrpuI/kybfkRiA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn7ISv3YVncmIwFw--.20087S2;
	Tue, 14 Jan 2025 11:44:48 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: kvm@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] vfio/pci: Change the variable 'physfn' definition scope
Date: Tue, 14 Jan 2025 11:43:45 +0800
Message-ID: <20250114034405.4416-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.48.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn7ISv3YVncmIwFw--.20087S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw4xuw43WrW5AF15XF1xGrg_yoWkAwbE9r
	yFvr40qF4rAFWrGr13Zr17u3sI934avFsY9F1xtF1qyFy7twn8urZrGFnrWr48Wws7AF1D
	JrWDZw15Zr1YkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRKeOJ7UUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiYBzUa2eF2aButAAAsC

Move the variable 'physfn' definition into PF finding code block, since
it is initialized and used there.

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1a4ed5a357d3..6cbbb446531b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2006,7 +2006,6 @@ static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_core_device *cur;
-	struct pci_dev *physfn;
 	int ret;
 
 	if (pdev->is_virtfn) {
@@ -2016,7 +2015,7 @@ static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
 		 * the locking in pci_disable_sriov() it cannot change until
 		 * this VF device driver is removed.
 		 */
-		physfn = pci_physfn(vdev->pdev);
+		struct pci_dev *physfn = pci_physfn(vdev->pdev);
 		mutex_lock(&vfio_pci_sriov_pfs_mutex);
 		list_for_each_entry(cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
 			if (cur->pdev == physfn) {
-- 
2.48.0


