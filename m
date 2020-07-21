Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B9D228484
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgGUQCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:02:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:30545 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbgGUQCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:02:44 -0400
IronPort-SDR: YydCq5NOClKvzf8lJdKr0JulIEHL2oQ+gFO2v+2vO4zgxngM7MOINyn3D6gaWUUuNkiJOo++Qd
 32Tx/ZurOVUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="150143040"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="150143040"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 09:02:43 -0700
IronPort-SDR: +j90kn5v9Tgl0Cb2KqBMPe25kTMzUBivffLJ8Vm8x7FzmO/N993eiKojud0fo0UNMorDHUVrez
 ZYQ2dl7ticKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="326413312"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jul 2020 09:02:41 -0700
Subject: [PATCH RFC v2 04/18] irq/dev-msi: Introduce APIs to allocate/free
 dev-msi interrupts
From:   Dave Jiang <dave.jiang@intel.com>
To:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, jgg@mellanox.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, jgg@mellanox.com,
        rafael@kernel.org, dave.hansen@intel.com, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Date:   Tue, 21 Jul 2020 09:02:41 -0700
Message-ID: <159534736176.28840.5547007059232964457.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Megha Dey <megha.dey@intel.com>

The dev-msi interrupts are to be allocated/freed only for custom devices,
not standard PCI-MSIX devices.

These interrupts are device-defined and they are distinct from the already
existing msi interrupts:
pci-msi: Standard PCI MSI/MSI-X setup format
platform-msi: Platform custom, but device-driver opaque MSI setup/control
arch-msi: fallback for devices not assigned to the generic PCI domain
dev-msi: device defined IRQ domain for ancillary devices. For e.g. DSA
portal devices use device specific IMS(Interrupt message store) interrupts.

dev-msi interrupts are represented by their own device-type. That means
dev->msi_list is never contended for different interrupt types. It
will either be all PCI-MSI or all device-defined.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Megha Dey <megha.dey@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/base/dev-msi.c |   23 +++++++++++++++++++++++
 include/linux/msi.h    |    4 ++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/base/dev-msi.c b/drivers/base/dev-msi.c
index 43d6ed3ba10f..4cc75bfd62da 100644
--- a/drivers/base/dev-msi.c
+++ b/drivers/base/dev-msi.c
@@ -145,3 +145,26 @@ struct irq_domain *create_remap_dev_msi_irq_domain(struct irq_domain *parent,
 	return domain;
 }
 #endif
+
+int dev_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
+			      const struct platform_msi_ops *platform_ops)
+{
+	if (!dev->msi_domain) {
+		dev->msi_domain = dev_msi_default_domain;
+	} else if (dev->msi_domain != dev_msi_default_domain) {
+		dev_WARN_ONCE(dev, 1, "already registered to another irq domain?\n");
+		return -ENXIO;
+	}
+
+	return platform_msi_domain_alloc_irqs(dev, nvec, platform_ops);
+}
+EXPORT_SYMBOL_GPL(dev_msi_domain_alloc_irqs);
+
+void dev_msi_domain_free_irqs(struct device *dev)
+{
+	if (dev->msi_domain != dev_msi_default_domain)
+		dev_WARN_ONCE(dev, 1, "registered to incorrect irq domain?\n");
+
+	platform_msi_domain_free_irqs(dev);
+}
+EXPORT_SYMBOL_GPL(dev_msi_domain_free_irqs);
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 7098ba566bcd..9dde8a43a0f7 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -381,6 +381,10 @@ void platform_msi_mask_irq(struct irq_data *data);
 
 int dev_msi_prepare(struct irq_domain *domain, struct device *dev,
                            int nvec, msi_alloc_info_t *arg);
+
+int dev_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
+			      const struct platform_msi_ops *platform_ops);
+void dev_msi_domain_free_irqs(struct device *dev);
 #endif /* CONFIG_GENERIC_MSI_IRQ_DOMAIN */
 
 #ifdef CONFIG_PCI_MSI_IRQ_DOMAIN

