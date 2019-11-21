Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60131047CA
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 01:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfKUA6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 19:58:47 -0500
Received: from ozlabs.org ([203.11.71.1]:60897 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfKUA6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 19:58:46 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 47JLm40WNcz9sPL; Thu, 21 Nov 2019 11:58:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1574297924;
        bh=tCEjjjB7GWqDoKkmTHHtPfHvbR0elnZvywA0y/9MLo0=;
        h=From:To:Cc:Subject:Date:From;
        b=EyVBCYXMbgL/PZAgLOTtz0gX0pXijPuX9pUZJRgcHWhLB/w4oLX2BSi4I/VPlBnOC
         q0FYGB73r6i3IDHdz26veT6iTYIPVJLENM+xVShNbLHYT6ymE19SLFyXyQA/XjtblG
         dqtn6WBoa1baAQuibNkZrG2Ez5v4xLF3w4mfR4fA=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>, clg@kaod.org
Cc:     groug@kaod.org, philmd@redhat.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Riku Voipio <riku.voipio@iki.fi>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 0/5] vfio/spapr: Handle changes of master irq chip for VFIO devices
Date:   Thu, 21 Nov 2019 11:56:02 +1100
Message-Id: <20191121005607.274347-1-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Due to the way feature negotiation works in PAPR (which is a
paravirtualized platform), we can end up changing the global irq chip
at runtime, including it's KVM accelerate model.  That causes
complications for VFIO devices with INTx, which wire themselves up
directly to the KVM irqchip for performance.

This series introduces a new notifier to let VFIO devices (and
anything else that needs to in the future) know about changes to the
master irqchip.  It modifies VFIO to respond to the notifier,
reconnecting itself to the new KVM irqchip as necessary.

In particular this removes a misleading (though not wholly inaccurate)
warning that occurs when using VFIO devices on a pseries machine type
guest.

Open question: should this go into qemu-4.2 or wait until 5.0?  It's
has medium complexity / intrusiveness, but it *is* a bugfix that I
can't see a simpler way to fix.  It's effectively a regression from
qemu-4.0 to qemu-4.1 (because that introduced XIVE support by
default), although not from 4.1 to 4.2.

Changes since RFC:
 * Fixed some incorrect error paths pointed by aw in 3/5
 * 5/5 had some problems previously, but they have been obsoleted by
   other changes merged in the meantime

David Gibson (5):
  kvm: Introduce KVM irqchip change notifier
  vfio/pci: Split vfio_intx_update()
  vfio/pci: Respond to KVM irqchip change notifier
  spapr: Handle irq backend changes with VFIO PCI devices
  spapr: Work around spurious warnings from vfio INTx initialization

 accel/kvm/kvm-all.c    | 18 ++++++++++++
 accel/stubs/kvm-stub.c | 12 ++++++++
 hw/ppc/spapr_irq.c     | 17 +++++++++++-
 hw/vfio/pci.c          | 62 +++++++++++++++++++++++++++---------------
 hw/vfio/pci.h          |  1 +
 include/sysemu/kvm.h   |  5 ++++
 6 files changed, 92 insertions(+), 23 deletions(-)

-- 
2.23.0

