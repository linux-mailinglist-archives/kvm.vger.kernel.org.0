Return-Path: <kvm+bounces-36091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB636A178B0
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 08:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8737F3A547F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 07:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E341B85D3;
	Tue, 21 Jan 2025 07:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b="siMMCyGG"
X-Original-To: kvm@vger.kernel.org
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705901B4138;
	Tue, 21 Jan 2025 07:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.211.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737445334; cv=none; b=MHYtm5nsK7XOXspaR4sVsw5HvdTkZcrJWqWN11+7pZmXlVdJtQMsFb0zzUZpBZ24/Px+7beJe66qiTri60pcCTSlX1HAaIRQVh9tlhdpzEDtJzyw4J6HgJjziGs9ASdA5bfoCEyKUh2Z+5voBiSL/dt5OLaawPwyb7hZnDhzO90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737445334; c=relaxed/simple;
	bh=YoR2qmbgNtmvjgCuNEPzabJVy/e0TB54nbKvYF0fuOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lfh48J3bMjaXmkUKVaMQKbzUb415yJa1Q2wtBvctboBYCgkBOVasvLMKgyTcdb+fw7D9KovkgrMYQCR/OQG9VAYXJng/yVvHsPMAo3ZMjcaX0vH+LWmAtZ7Vl3zpDmkjb6m837CFs7gveGSrGba818UioH+cTypHRtzG4dikMas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; spf=pass smtp.mailfrom=swemel.ru; dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b=siMMCyGG; arc=none smtp.client-ip=95.143.211.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=swemel.ru
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1737445325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lWSW0NEGTXwhqneciz6Bo6cmaj9O0uFqZ22QTxPc1DM=;
	b=siMMCyGGHIRAb4pTfU/Z4Hf4++YaLkFHeAxVG1Hl1Zor/EoNDbu0+hx0ouhPa2n+IY/c7L
	yENFvH/QyG+cGbIe5O64v4RjgHNXsvzOFUmnHGtUy1X9qCRQZ0URGzlU29IqRLfGpX3ald
	OzTDaAEXwZ2fFbQzIlv6NfCLCvyFej8=
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Ye Bin <yebin10@huawei.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10] vfio/pci: fix potential memory leak in vfio_intx_enable()
Date: Tue, 21 Jan 2025 10:42:03 +0300
Message-ID: <20250121074205.4836-1-arefev@swemel.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ye Bin <yebin10@huawei.com>

commit 82b951e6fbd31d85ae7f4feb5f00ddd4c5d256e2 upstream. 

If vfio_irq_ctx_alloc() failed will lead to 'name' memory leak.

Fixes: 18c198c96a81 ("vfio/pci: Create persistent INTx handler")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Link: https://lore.kernel.org/r/20240415015029.3699844-1-yebin10@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
[Denis: minor fix to resolve merge conflict.]                                           
Signed-off-by: Denis Arefev <arefev@swemel.ru>                                    
---
Backport fix for CVE-2024-38632          
Link: https://nvd.nist.gov/vuln/detail/CVE-2024-38632
---
 drivers/vfio/pci/vfio_pci_intrs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 5b0b7fab3ba1..83498ec1ec0b 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -181,8 +181,10 @@ static int vfio_intx_enable(struct vfio_pci_device *vdev,
 		return -ENOMEM;
 
 	vdev->ctx = kzalloc(sizeof(struct vfio_pci_irq_ctx), GFP_KERNEL);
-	if (!vdev->ctx)
+	if (!vdev->ctx) {
+		kfree(name);
 		return -ENOMEM;
+	}
 
 	vdev->num_ctx = 1;
 
-- 
2.43.0


