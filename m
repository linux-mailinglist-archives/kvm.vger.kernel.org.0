Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1F97B24B8
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjI1SE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjI1SE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:04:26 -0400
X-Greylist: delayed 946 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Sep 2023 11:04:23 PDT
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ee9:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C801819D;
        Thu, 28 Sep 2023 11:04:23 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id EF16E10189DF6;
        Thu, 28 Sep 2023 20:04:21 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id C685960D850C;
        Thu, 28 Sep 2023 20:04:21 +0200 (CEST)
X-Mailbox-Line: From 7721bfa3b4f8a99a111f7808ad8890c3c13df56d Mon Sep 17 00:00:00 2001
Message-Id: <7721bfa3b4f8a99a111f7808ad8890c3c13df56d.1695921657.git.lukas@wunner.de>
In-Reply-To: <cover.1695921656.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 28 Sep 2023 19:32:38 +0200
Subject: [PATCH 08/12] PCI/CMA: Authenticate devices on enumeration
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Component Measurement and Authentication (CMA, PCIe r6.1 sec 6.31)
allows for measurement and authentication of PCIe devices.  It is
based on the Security Protocol and Data Model specification (SPDM,
https://www.dmtf.org/dsp/DSP0274).

CMA-SPDM in turn forms the basis for Integrity and Data Encryption
(IDE, PCIe r6.1 sec 6.33) because the key material used by IDE is
exchanged over a CMA-SPDM session.

As a first step, authenticate CMA-capable devices on enumeration.
A subsequent commit will expose the result in sysfs.

When allocating SPDM session state with spdm_create(), the maximum SPDM
message length needs to be passed.  Make the PCI_DOE_MAX_LENGTH macro
public and calculate the maximum payload length from it.

Credits:  Jonathan wrote a proof-of-concept of this CMA implementation.
Lukas reworked it for upstream.  Wilfred contributed fixes for issues
discovered during testing.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 MAINTAINERS             |  1 +
 drivers/pci/Kconfig     | 13 ++++++
 drivers/pci/Makefile    |  2 +
 drivers/pci/cma.c       | 97 +++++++++++++++++++++++++++++++++++++++++
 drivers/pci/doe.c       |  3 --
 drivers/pci/pci.h       |  8 ++++
 drivers/pci/probe.c     |  1 +
 drivers/pci/remove.c    |  1 +
 include/linux/pci-doe.h |  4 ++
 include/linux/pci.h     |  4 ++
 10 files changed, 131 insertions(+), 3 deletions(-)
 create mode 100644 drivers/pci/cma.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2591d2217d65..70a2beb4a278 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19305,6 +19305,7 @@ M:	Lukas Wunner <lukas@wunner.de>
 L:	linux-cxl@vger.kernel.org
 L:	linux-pci@vger.kernel.org
 S:	Maintained
+F:	drivers/pci/cma*
 F:	include/linux/spdm.h
 F:	lib/spdm*
 
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index e9ae66cc4189..c9aa5253ac1f 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -116,6 +116,19 @@ config XEN_PCIDEV_FRONTEND
 config PCI_ATS
 	bool
 
+config PCI_CMA
+	bool "Component Measurement and Authentication (CMA-SPDM)"
+	select CRYPTO_ECDSA
+	select CRYPTO_RSA
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	select PCI_DOE
+	select SPDM_REQUESTER
+	help
+	  Authenticate devices on enumeration per PCIe r6.1 sec 6.31.
+	  A PCI DOE mailbox is used as transport for DMTF SPDM based
+	  attestation, measurement and secure channel establishment.
+
 config PCI_DOE
 	bool
 
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index cc8b4e01e29d..e0705b82690b 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -34,6 +34,8 @@ obj-$(CONFIG_VGA_ARB)		+= vgaarb.o
 obj-$(CONFIG_PCI_DOE)		+= doe.o
 obj-$(CONFIG_PCI_DYNAMIC_OF_NODES) += of_property.o
 
+obj-$(CONFIG_PCI_CMA)		+= cma.o
+
 # Endpoint library must be initialized before its users
 obj-$(CONFIG_PCI_ENDPOINT)	+= endpoint/
 
diff --git a/drivers/pci/cma.c b/drivers/pci/cma.c
new file mode 100644
index 000000000000..06e5846325e3
--- /dev/null
+++ b/drivers/pci/cma.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Component Measurement and Authentication (CMA-SPDM, PCIe r6.1 sec 6.31)
+ *
+ * Copyright (C) 2021 Huawei
+ *     Jonathan Cameron <Jonathan.Cameron@huawei.com>
+ *
+ * Copyright (C) 2022-23 Intel Corporation
+ */
+
+#define dev_fmt(fmt) "CMA: " fmt
+
+#include <linux/pci.h>
+#include <linux/pci-doe.h>
+#include <linux/pm_runtime.h>
+#include <linux/spdm.h>
+
+#include "pci.h"
+
+#define PCI_DOE_PROTOCOL_CMA 1
+
+/* Keyring that userspace can poke certs into */
+static struct key *pci_cma_keyring;
+
+static int pci_doe_transport(void *priv, struct device *dev,
+			     const void *request, size_t request_sz,
+			     void *response, size_t response_sz)
+{
+	struct pci_doe_mb *doe = priv;
+	int rc;
+
+	/*
+	 * CMA-SPDM operation in non-D0 states is optional (PCIe r6.1
+	 * sec 6.31.3).  The spec does not define a way to determine
+	 * if it's supported, so resume to D0 unconditionally.
+	 */
+	rc = pm_runtime_resume_and_get(dev);
+	if (rc)
+		return rc;
+
+	rc = pci_doe(doe, PCI_VENDOR_ID_PCI_SIG, PCI_DOE_PROTOCOL_CMA,
+		     request, request_sz, response, response_sz);
+
+	pm_runtime_put(dev);
+
+	return rc;
+}
+
+void pci_cma_init(struct pci_dev *pdev)
+{
+	struct pci_doe_mb *doe;
+	int rc;
+
+	if (!pci_cma_keyring) {
+		return;
+	}
+
+	if (!pci_is_pcie(pdev))
+		return;
+
+	doe = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
+				   PCI_DOE_PROTOCOL_CMA);
+	if (!doe)
+		return;
+
+	pdev->spdm_state = spdm_create(&pdev->dev, pci_doe_transport, doe,
+				       PCI_DOE_MAX_PAYLOAD, pci_cma_keyring);
+	if (!pdev->spdm_state) {
+		return;
+	}
+
+	rc = spdm_authenticate(pdev->spdm_state);
+}
+
+void pci_cma_destroy(struct pci_dev *pdev)
+{
+	if (pdev->spdm_state)
+		spdm_destroy(pdev->spdm_state);
+}
+
+__init static int pci_cma_keyring_init(void)
+{
+	pci_cma_keyring = keyring_alloc(".cma", KUIDT_INIT(0), KGIDT_INIT(0),
+					current_cred(),
+					(KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					KEY_USR_VIEW | KEY_USR_READ |
+					KEY_USR_WRITE | KEY_USR_SEARCH,
+					KEY_ALLOC_NOT_IN_QUOTA |
+					KEY_ALLOC_SET_KEEP, NULL, NULL);
+	if (IS_ERR(pci_cma_keyring)) {
+		pr_err("Could not allocate keyring\n");
+		return PTR_ERR(pci_cma_keyring);
+	}
+
+	return 0;
+}
+arch_initcall(pci_cma_keyring_init);
diff --git a/drivers/pci/doe.c b/drivers/pci/doe.c
index e3aab5edaf70..79f0336eb0c3 100644
--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -31,9 +31,6 @@
 #define PCI_DOE_FLAG_CANCEL	0
 #define PCI_DOE_FLAG_DEAD	1
 
-/* Max data object length is 2^18 dwords */
-#define PCI_DOE_MAX_LENGTH	(1 << 18)
-
 /**
  * struct pci_doe_mb - State for a single DOE mailbox
  *
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 39a8932dc340..bd80a0369c9c 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -322,6 +322,14 @@ static inline void pci_doe_destroy(struct pci_dev *pdev) { }
 static inline void pci_doe_disconnected(struct pci_dev *pdev) { }
 #endif
 
+#ifdef CONFIG_PCI_CMA
+void pci_cma_init(struct pci_dev *pdev);
+void pci_cma_destroy(struct pci_dev *pdev);
+#else
+static inline void pci_cma_init(struct pci_dev *pdev) { }
+static inline void pci_cma_destroy(struct pci_dev *pdev) { }
+#endif
+
 /**
  * pci_dev_set_io_state - Set the new error state if possible.
  *
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 795534589b98..1420a8d82386 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2487,6 +2487,7 @@ static void pci_init_capabilities(struct pci_dev *dev)
 	pci_dpc_init(dev);		/* Downstream Port Containment */
 	pci_rcec_init(dev);		/* Root Complex Event Collector */
 	pci_doe_init(dev);		/* Data Object Exchange */
+	pci_cma_init(dev);		/* Component Measurement & Auth */
 
 	pcie_report_downtraining(dev);
 	pci_init_reset_methods(dev);
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index d749ea8250d6..f009ac578997 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -39,6 +39,7 @@ static void pci_destroy_dev(struct pci_dev *dev)
 	list_del(&dev->bus_list);
 	up_write(&pci_bus_sem);
 
+	pci_cma_destroy(dev);
 	pci_doe_destroy(dev);
 	pcie_aspm_exit_link_state(dev);
 	pci_bridge_d3_update(dev);
diff --git a/include/linux/pci-doe.h b/include/linux/pci-doe.h
index 1f14aed4354b..0d3d7656c456 100644
--- a/include/linux/pci-doe.h
+++ b/include/linux/pci-doe.h
@@ -15,6 +15,10 @@
 
 struct pci_doe_mb;
 
+/* Max data object length is 2^18 dwords (including 2 dwords for header) */
+#define PCI_DOE_MAX_LENGTH	(1 << 18)
+#define PCI_DOE_MAX_PAYLOAD	((PCI_DOE_MAX_LENGTH - 2) * sizeof(u32))
+
 struct pci_doe_mb *pci_find_doe_mailbox(struct pci_dev *pdev, u16 vendor,
 					u8 type);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8c7c2c3c6c65..0c0123317df6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -39,6 +39,7 @@
 #include <linux/io.h>
 #include <linux/resource_ext.h>
 #include <linux/msi_api.h>
+#include <linux/spdm.h>
 #include <uapi/linux/pci.h>
 
 #include <linux/pci_ids.h>
@@ -515,6 +516,9 @@ struct pci_dev {
 #endif
 #ifdef CONFIG_PCI_DOE
 	struct xarray	doe_mbs;	/* Data Object Exchange mailboxes */
+#endif
+#ifdef CONFIG_PCI_CMA
+	struct spdm_state *spdm_state;	/* Security Protocol and Data Model */
 #endif
 	u16		acs_cap;	/* ACS Capability offset */
 	phys_addr_t	rom;		/* Physical address if not from BAR */
-- 
2.40.1

