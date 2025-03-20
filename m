Return-Path: <kvm+bounces-41597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA76A6AEA6
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 20:42:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B51231882F22
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 19:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E5F227EBE;
	Thu, 20 Mar 2025 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bp2t8Yrl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DD82AEFE
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 19:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742499719; cv=none; b=FZsKG21PTIpWjR+uJcsWODpokuptda46y3Wfac3pKC06HixMwh10ra79WeQFJc6w3fXGKwP4PB8YwfX8AG55Y/Ms1ijz9zl6GemG0yPI9QKnlIfz7/3Epke+hkSgeRHApBLjaYWH//gIftz0wqpChl9kgo6EFQh9KRxSrs1pzf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742499719; c=relaxed/simple;
	bh=8Xkkx7cSUBPFhheIny+Y5Avt1EwGq0KlBksucgZfnE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vh+yEE1J5OGpvZHai/foC3MZSFwbObYqT2YOgkwVmPTAEbjuayR/cWr5B1+LZJvYecHnhFkWoiiMwAIGVm25OkGQM5eRVz7gF2G7dqQge6tWrBj/7akSahh8yoTBRLO6KK7vcFs09Tq+Onl1gsTbq9/1djw0Bg/CX0cKpcZVbDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bp2t8Yrl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742499717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dOpkcvXWmwXW7oImhKpb3CoC8jp/UH4cPDEcdQv5dyg=;
	b=bp2t8Yrlxb7FSs/6lOJEHfOySQf1nc4Tcpou24sEDbRFSl1hk+WMHJVzRCT+CU2gvnO5JJ
	JPXF+rgmw2aojIIcnzqq9rbNxyhIkr6ZQ+w+KXCDPYPWVbPAYlKQX3EvMvdskyiMM4ZgMz
	XnzIft+VT/5wtRjQH0DsRH8xFoNNC2E=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-171-PkVHJK0aPzClx-GspYN6hQ-1; Thu,
 20 Mar 2025 15:41:55 -0400
X-MC-Unique: PkVHJK0aPzClx-GspYN6hQ-1
X-Mimecast-MFC-AGG-ID: PkVHJK0aPzClx-GspYN6hQ_1742499714
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE1F7196B344;
	Thu, 20 Mar 2025 19:41:54 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.89.109])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BCF631800944;
	Thu, 20 Mar 2025 19:41:52 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	sbhat@linux.ibm.com,
	kevin.tian@intel.com
Subject: [PATCH] vfio/pci: Virtualize zero INTx PIN if no pdev->irq
Date: Thu, 20 Mar 2025 13:41:42 -0600
Message-ID: <20250320194145.2816379-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Typically pdev->irq is consistent with whether the device itself
supports INTx, where device support is reported via the PIN register.
Therefore the PIN register is often already zero if pdev->irq is zero.

Recently virtualization of the PIN register was expanded to include
the case where the device supports INTx but the platform does not
route the interrupt.  This is reported by a value of IRQ_NOTCONNECTED
on some architectures.  Other architectures just report zero for
pdev->irq.

We already disallow INTx setup if pdev->irq is zero, therefore add
this to the PIN register virtualization criteria so that a consistent
view is provided to userspace through virtualized config space and
ioctls.

Reported-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Link: https://lore.kernel.org/all/174231895238.2295.12586708771396482526.stgit@linux.ibm.com/
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

Applies over https://lore.kernel.org/all/20250311230623.1264283-1-alex.williamson@redhat.com/

 drivers/vfio/pci/vfio_pci_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 14437396d721..8f02f236b5b4 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1815,7 +1815,7 @@ int vfio_config_init(struct vfio_pci_core_device *vdev)
 	}
 
 	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx ||
-	    vdev->pdev->irq == IRQ_NOTCONNECTED)
+	    !vdev->pdev->irq || vdev->pdev->irq == IRQ_NOTCONNECTED)
 		vconfig[PCI_INTERRUPT_PIN] = 0;
 
 	ret = vfio_cap_init(vdev);
-- 
2.48.1


