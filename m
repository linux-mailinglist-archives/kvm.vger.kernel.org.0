Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE0520A36F
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403965AbgFYQ5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 12:57:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27810 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390448AbgFYQ5Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 12:57:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593104235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GF5LkOlnhTVNoedCdKoIYF7NkNTIxZXf2Tb7J0LGaQ4=;
        b=L/cdiRfUxVsivUDkBMKDfaB6n1++DKCrt1rXsnVN5nVzWDI9xwRXeg8QO60wo9NE+EVAKy
        e9wuEeS59H6oM+t4+ImN2qDrMeU8d8/j0ub+JnrD9oRIKxMbBIWJtJgNE+N9dvenGiYYvO
        YnnLrCiadGaoyWIv/JNIcCXJLd9cAK0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-wkv-tCLbMWuF2rp9omMg7w-1; Thu, 25 Jun 2020 12:57:12 -0400
X-MC-Unique: wkv-tCLbMWuF2rp9omMg7w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D636464;
        Thu, 25 Jun 2020 16:57:12 +0000 (UTC)
Received: from gimli.home (ovpn-112-156.phx2.redhat.com [10.3.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08E855D9D3;
        Thu, 25 Jun 2020 16:57:03 +0000 (UTC)
Subject: [PATCH] vfio/pci: Fix SR-IOV VF handling with MMIO blocking
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com
Date:   Thu, 25 Jun 2020 10:57:03 -0600
Message-ID: <159310421505.27590.16617666489295503039.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SR-IOV VFs do not implement the memory enable bit of the command
register, therefore this bit is not set in config space after
pci_enable_device().  This leads to an unintended difference
between PF and VF in hand-off state to the user.  We can correct
this by setting the initial value of the memory enable bit in our
virtualized config space.  There's really no need however to
ever fault a user on a VF though as this would only indicate an
error in the user's management of the enable bit, versus a PF
where the same access could trigger hardware faults.

Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 8746c943247a..d98843feddce 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -398,9 +398,15 @@ static inline void p_setd(struct perm_bits *p, int off, u32 virt, u32 write)
 /* Caller should hold memory_lock semaphore */
 bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
 {
+	struct pci_dev *pdev = vdev->pdev;
 	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 
-	return cmd & PCI_COMMAND_MEMORY;
+	/*
+	 * SR-IOV VF memory enable is handled by the MSE bit in the
+	 * PF SR-IOV capability, there's therefore no need to trigger
+	 * faults based on the virtual value.
+	 */
+	return pdev->is_virtfn || (cmd & PCI_COMMAND_MEMORY);
 }
 
 /*
@@ -1728,6 +1734,15 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 				 vconfig[PCI_INTERRUPT_PIN]);
 
 		vconfig[PCI_INTERRUPT_PIN] = 0; /* Gratuitous for good VFs */
+
+		/*
+		 * VFs do no implement the memory enable bit of the COMMAND
+		 * register therefore we'll not have it set in our initial
+		 * copy of config space after pci_enable_device().  For
+		 * consistency with PFs, set the virtual enable bit here.
+		 */
+		*(__le16 *)&vconfig[PCI_COMMAND] |=
+					cpu_to_le16(PCI_COMMAND_MEMORY);
 	}
 
 	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)

