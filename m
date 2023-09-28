Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032077B24F2
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjI1SKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjI1SKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:10:53 -0400
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ee9:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21B819E;
        Thu, 28 Sep 2023 11:10:50 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 06A2210189DFC;
        Thu, 28 Sep 2023 20:10:49 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id D3CBF60DFEBD;
        Thu, 28 Sep 2023 20:10:48 +0200 (CEST)
X-Mailbox-Line: From e71af6b0bf695694d4a6de2c44356fe4fda97fea Mon Sep 17 00:00:00 2001
Message-Id: <e71af6b0bf695694d4a6de2c44356fe4fda97fea.1695921657.git.lukas@wunner.de>
In-Reply-To: <cover.1695921656.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 28 Sep 2023 19:32:40 +0200
Subject: [PATCH 10/12] PCI/CMA: Reauthenticate devices on reset and resume
To:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CMA-SPDM state is lost when a device undergoes a Conventional Reset.
(But not a Function Level Reset, PCIe r6.1 sec 6.6.2.)  A D3cold to D0
transition implies a Conventional Reset (PCIe r6.1 sec 5.8).

Thus, reauthenticate devices on resume from D3cold and on recovery from
a Secondary Bus Reset or DPC-induced Hot Reset.

The requirement to reauthenticate devices on resume from system sleep
(and in the future reestablish IDE encryption) is the reason why SPDM
needs to be in-kernel:  During ->resume_noirq, which is the first phase
after system sleep, the PCI core walks down the hierarchy, puts each
device in D0, restores its config space and invokes the driver's
->resume_noirq callback.  The driver is afforded the right to access the
device already during this phase.

To retain this usage model in the face of authentication and encryption,
CMA-SPDM reauthentication and IDE reestablishment must happen during the
->resume_noirq phase, before the driver's first access to the device.
The driver is thus afforded seamless authenticated and encrypted access
until the last moment before suspend and from the first moment after
resume.

During the ->resume_noirq phase, device interrupts are not yet enabled.
It is thus impossible to defer CMA-SPDM reauthentication to a user space
component on an attached disk or on the network, making an in-kernel
SPDM implementation mandatory.

The same catch-22 exists on recovery from a Conventional Reset:  A user
space SPDM implementation might live on a device which underwent reset,
rendering its execution impossible.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/pci/cma.c        | 10 ++++++++++
 drivers/pci/pci-driver.c |  1 +
 drivers/pci/pci.c        | 12 ++++++++++--
 drivers/pci/pci.h        |  5 +++++
 drivers/pci/pcie/err.c   |  3 +++
 include/linux/pci.h      |  1 +
 6 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/cma.c b/drivers/pci/cma.c
index 012190c54ab6..89d23fdc37ec 100644
--- a/drivers/pci/cma.c
+++ b/drivers/pci/cma.c
@@ -71,6 +71,16 @@ void pci_cma_init(struct pci_dev *pdev)
 	}
 
 	rc = spdm_authenticate(pdev->spdm_state);
+	if (rc != -EPROTONOSUPPORT)
+		pdev->cma_capable = true;
+}
+
+int pci_cma_reauthenticate(struct pci_dev *pdev)
+{
+	if (!pdev->cma_capable)
+		return -ENOTTY;
+
+	return spdm_authenticate(pdev->spdm_state);
 }
 
 void pci_cma_destroy(struct pci_dev *pdev)
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index a79c110c7e51..b5d47eefe8df 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -568,6 +568,7 @@ static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
 	pci_pm_power_up_and_verify_state(pci_dev);
 	pci_restore_state(pci_dev);
 	pci_pme_restore(pci_dev);
+	pci_cma_reauthenticate(pci_dev);
 }
 
 static void pci_pm_bridge_power_up_actions(struct pci_dev *pci_dev)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 59c01d68c6d5..0f36e6082579 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5248,8 +5248,16 @@ static int pci_reset_bus_function(struct pci_dev *dev, bool probe)
 
 	rc = pci_dev_reset_slot_function(dev, probe);
 	if (rc != -ENOTTY)
-		return rc;
-	return pci_parent_bus_reset(dev, probe);
+		goto done;
+
+	rc = pci_parent_bus_reset(dev, probe);
+
+done:
+	/* CMA-SPDM state is lost upon a Conventional Reset */
+	if (!probe)
+		pci_cma_reauthenticate(dev);
+
+	return rc;
 }
 
 void pci_dev_lock(struct pci_dev *dev)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 6c4755a2c91c..71092ccf4fbd 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -325,11 +325,16 @@ static inline void pci_doe_disconnected(struct pci_dev *pdev) { }
 #ifdef CONFIG_PCI_CMA
 void pci_cma_init(struct pci_dev *pdev);
 void pci_cma_destroy(struct pci_dev *pdev);
+int pci_cma_reauthenticate(struct pci_dev *pdev);
 struct x509_certificate;
 int pci_cma_validate(struct device *dev, struct x509_certificate *leaf_cert);
 #else
 static inline void pci_cma_init(struct pci_dev *pdev) { }
 static inline void pci_cma_destroy(struct pci_dev *pdev) { }
+static inline int pci_cma_reauthenticate(struct pci_dev *pdev)
+{
+	return -ENOTTY;
+}
 #endif
 
 /**
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 59c90d04a609..4783bd907b54 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -122,6 +122,9 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
 	pci_ers_result_t vote, *result = data;
 	const struct pci_error_handlers *err_handler;
 
+	/* CMA-SPDM state is lost upon a Conventional Reset */
+	pci_cma_reauthenticate(dev);
+
 	device_lock(&dev->dev);
 	pdrv = dev->driver;
 	if (!pdrv ||
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0c0123317df6..2bc11d8b567e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -519,6 +519,7 @@ struct pci_dev {
 #endif
 #ifdef CONFIG_PCI_CMA
 	struct spdm_state *spdm_state;	/* Security Protocol and Data Model */
+	unsigned int	cma_capable:1;	/* Authentication supported */
 #endif
 	u16		acs_cap;	/* ACS Capability offset */
 	phys_addr_t	rom;		/* Physical address if not from BAR */
-- 
2.40.1

