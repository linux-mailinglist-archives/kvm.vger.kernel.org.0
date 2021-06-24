Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0412F3B2E8E
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 14:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhFXMIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 08:08:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44424 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFXMI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 08:08:29 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624536369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7UpP1CcjI5eMSbTnXKpzEkX6EJ+vShXJKxQp9lhmMeQ=;
        b=awuejK0ObYDEC0wLXFlvbSRa4YRf1NvN/VzSsUj3Om68jgq6wcme5a1Lz06oOt4WmhzyTj
        MukHv52C41DpnCRr6h5UM/iShPWG1+syWSdy1U6EhKC4GrX7lTWj9gPD1c5Ac23EdaSHh8
        veeve45x8UQUOYLdWSZiWbE1ynmvKDbOTNVtvucEAIchjnCy2F7eSxoMbSF7ZaXgZGubDQ
        fbUIeiuYAZCfMuWOyE40Tvo3SyhFeD1yEMmygq09eXqvu76xIt3kl8PAN9d7hN37Rwe9Nj
        3CDs5vo4yYCOB4nF4qoJ/FGCiwRkMmwUzIlxQejWQ3Me91EE0/v076AJipGi8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624536369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7UpP1CcjI5eMSbTnXKpzEkX6EJ+vShXJKxQp9lhmMeQ=;
        b=oUXs2E5BYK59QdXkYHYYQlN8/0l3eT+VtEij9b3sSSkUtoDBCiT87+icEjBuqx9VNAMDoc
        1BuO0nJM2LS9vMAw==
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian\, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH] vfio/pci: Document the MSI[X] resize side effects properly
In-Reply-To: <20210623204828.2bc7e6dc.alex.williamson@redhat.com>
References: <20210622131217.76b28f6f.alex.williamson@redhat.com> <87o8bxcuxv.ffs@nanos.tec.linutronix.de> <20210623091935.3ab3e378.alex.williamson@redhat.com> <MWHPR11MB18864420ACE88E060203F7818C079@MWHPR11MB1886.namprd11.prod.outlook.com> <87mtrgatqo.ffs@nanos.tec.linutronix.de> <20210623204828.2bc7e6dc.alex.williamson@redhat.com>
Date:   Thu, 24 Jun 2021 14:06:09 +0200
Message-ID: <87im23bh72.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The documentation of VFIO_IRQ_INFO_NORESIZE is inaccurate as it suggests
that it is safe to dynamically add new MSI-X vectors even when
previously allocated vectors are already in use and enabled.

Enabling additional vectors is possible according the MSI-X specification,
but the kernel does not have any mechanisms today to do that safely.

The only available mechanism is to teardown the already active vectors
and to setup the full vector set afterwards.

This requires to temporarily disable MSI-X which redirects any interrupt
raised by the device during this time to the legacy PCI/INTX which is
not handled and the interrupt is therefore lost.

Update the documentation of VFIO_IRQ_INFO_NORESIZE accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/uapi/linux/vfio.h |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -699,10 +699,19 @@ struct vfio_region_info_cap_nvlink2_lnks
  * disabling the entire index.  This is used for interrupts like PCI MSI
  * and MSI-X where the driver may only use a subset of the available
  * indexes, but VFIO needs to enable a specific number of vectors
- * upfront.  In the case of MSI-X, where the user can enable MSI-X and
- * then add and unmask vectors, it's up to userspace to make the decision
- * whether to allocate the maximum supported number of vectors or tear
- * down setup and incrementally increase the vectors as each is enabled.
+ * upfront.
+ *
+ * MSI cannot be resized safely when interrupts are in use already because
+ * resizing requires temporary disablement of MSI for updating the relevant
+ * PCI config space entries. Disabling MSI redirects an interrupt raised by
+ * the device during this time to the unhandled legacy PCI/INTX, which
+ * means the interrupt is lost.
+ *
+ * Enabling additional vectors for MSI-X is possible at least from the
+ * perspective of the MSI-X specification, but not supported by the
+ * exisiting PCI/MSI-X mechanisms in the kernel. The kernel provides
+ * currently only a full teardown/setup cycle which requires to disable
+ * MSI-X temporarily with the same side effects as for MSI.
  */
 struct vfio_irq_info {
 	__u32	argsz;
