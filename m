Return-Path: <kvm+bounces-50919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF46AEAA24
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C9BD1885C31
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43F862236F8;
	Thu, 26 Jun 2025 22:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iu0Ov7WS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F13C8EB
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 22:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750978612; cv=none; b=Zxho28xhpoFrumayLP7e70o1n8ylI0Nfb/T7knSQfAr3YeAbdg9+bZzhkuTo/8V+kv5KYkjqOPD7dDf4tkbrnv8AsHp/QuNVULbetzXRk+ZC+ciUQwCF9mddIxoTdSb74JRqgO/ifdMqH3rEqg3iKzD0+r+d0jz7yp3j8x6tkKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750978612; c=relaxed/simple;
	bh=ysf4zQ41GnVnvndPLOiQrVwKU2gDIWWpmDH4O7TNIOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O+ykjIcB/JbLL20du54202zguPjaU/hvv3NdoC0sJTHOmcjcIHE7MgQOib/fJDkvWT+s1dnX9NdWl/BlFC0eZjuTGd2syVcka/MLQh6AkP0uzaE+FFcWoZIBBU7ocnCwU4Af20/6ua42hSzKvLj4KRWObxRDalheZA8dmZr3CMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Iu0Ov7WS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750978609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MqMr2wjxNnHvbD2oPRJuftKLIiWTSEkuNNb46CNYz/w=;
	b=Iu0Ov7WSGrhxBRenOmmEfgyKel9GfNs7qbw7/odV111XLBLiymyIL9qDfDbJHuy2JCfbZG
	u/x317/d19KnQgwcrjvafObb7AyefhnSofCo7J/XpSH/v+4gVD82Ur4UbeHGS2c7FFqElh
	SX/9mCbxxLkgI60XfgjfXogqCC8Lnyg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-n2Yde0x-MiqW-Xp0bwcZkQ-1; Thu,
 26 Jun 2025 18:56:47 -0400
X-MC-Unique: n2Yde0x-MiqW-Xp0bwcZkQ-1
X-Mimecast-MFC-AGG-ID: n2Yde0x-MiqW-Xp0bwcZkQ_1750978604
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A2FF1801210;
	Thu, 26 Jun 2025 22:56:33 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.88.94])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F1D281800EC8;
	Thu, 26 Jun 2025 22:56:30 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com,
	kvm@vger.kernel.org
Cc: aaronlewis@google.com,
	jgg@nvidia.com,
	bhelgaas@google.com,
	dmatlack@google.com,
	vipinsh@google.com,
	seanjc@google.com,
	jrhilke@google.com,
	kevin.tian@intel.com
Subject: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Date: Thu, 26 Jun 2025 16:56:18 -0600
Message-ID: <20250626225623.1180952-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

In the below noted Fixes commit we introduced a reflck mutex to allow
better scaling between devices for open and close.  The reflck was
based on the hot reset granularity, device level for root bus devices
which cannot support hot reset or bus/slot reset otherwise.  Overlooked
in this were SR-IOV VFs, where there's also no bus reset option, but
the default for a non-root-bus, non-slot-based device is bus level
reflck granularity.

The reflck mutex has since become the dev_set mutex and is our defacto
serialization for various operations and ioctls.  It still seems to be
the case though that sets of vfio-pci devices really only need
serialization relative to hot resets affecting the entire set, which
is not relevant to SR-IOV VFs.  As described in the Closes link below,
this serialization contributes to startup latency when multiple VFs
sharing the same "bus" are opened concurrently.

Mark the device itself as the basis of the dev_set for SR-IOV VFs.

Reported-by: Aaron Lewis <aaronlewis@google.com>
Closes: https://lore.kernel.org/all/20250626180424.632628-1-aaronlewis@google.com
Tested-by: Aaron Lewis <aaronlewis@google.com>
Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6328c3a05bcd..261a6dc5a5fc 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2149,7 +2149,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		return -EBUSY;
 	}
 
-	if (pci_is_root_bus(pdev->bus)) {
+	if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) {
 		ret = vfio_assign_device_set(&vdev->vdev, vdev);
 	} else if (!pci_probe_reset_slot(pdev->slot)) {
 		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);
-- 
2.49.0


