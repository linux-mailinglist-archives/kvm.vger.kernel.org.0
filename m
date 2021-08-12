Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8178F3EA993
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 19:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbhHLRiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 13:38:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236442AbhHLRh7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 13:37:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628789854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0fN0hJhiU42MG6Y9ixqg9uAkz6xOxVcicryD5YB7e2I=;
        b=C8Hk8B3zy5SZ3SFz2KfCkLIx3Mq8rKqToZYFWCjGMlYISuEAeFwVQkn/0EtwEdZInHXjOV
        RI0hxelj1LQTj5hR7z6KlJMcm7dcABs34+XJOc8pg/7UPDcIuTc+UZbsGGmEn4/M0kRafQ
        qYrXOSmlWqSbIHJ1gfcchR1L7jH6WZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-Xvn8QKT8NhqC3By6_hTAZA-1; Thu, 12 Aug 2021 13:37:32 -0400
X-MC-Unique: Xvn8QKT8NhqC3By6_hTAZA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6103C107ACF5;
        Thu, 12 Aug 2021 17:37:31 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-113-77.phx2.redhat.com [10.3.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D1161F6;
        Thu, 12 Aug 2021 17:37:27 +0000 (UTC)
Subject: [PATCH] vfio_pci: Wake device to D0 before resets
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 12 Aug 2021 11:37:27 -0600
Message-ID: <162878980049.119165.8034541463589403195.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pci_pm_reset() actually depends on the device starting in the D0 power
state, therefore any time we're using a flavor of pci_reset_function()
we should make sure the device is fully powered-up in case the PM reset
method is used.

It's not uncommon that shutdown of a VM will put the device into a D3
state such that vfio_pci_disable() is managing a device in this low
power state.  The reset state of a device is the D0 power state, so
it's also reasonable to put the device into this state prior to reset.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index a4f44ea52fa3..e3faa1eb1a8c 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -454,6 +454,15 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 	vdev->needs_reset = true;
 
+	/*
+	 * Userspace may have left the device in a low power state which
+	 * affects our ability to trigger a PM reset, restore to D0 and
+	 * toss any saved state from the previous session.
+	 */
+	pci_set_power_state(pdev, PCI_D0);
+	kfree(vdev->pm_save);
+	vdev->pm_save = NULL;
+
 	/*
 	 * If we have saved state, restore it.  If we can reset the device,
 	 * even better.  Resetting with current state seems better than
@@ -1013,6 +1022,9 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 		if (!vdev->reset_works)
 			return -EINVAL;
 
+		/* PM reset depends on the device not already being in D3 */
+		vfio_pci_set_power_state(vdev, PCI_D0);
+
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
 		ret = pci_try_reset_function(vdev->pdev);
 		up_write(&vdev->memory_lock);


