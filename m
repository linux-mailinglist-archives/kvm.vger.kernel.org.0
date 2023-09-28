Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D715D7B2508
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjI1SNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbjI1SNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:13:51 -0400
Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ee9:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8E398;
        Thu, 28 Sep 2023 11:13:47 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id A8EA11018978B;
        Thu, 28 Sep 2023 20:13:45 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 7BE1F60DFEBD;
        Thu, 28 Sep 2023 20:13:45 +0200 (CEST)
X-Mailbox-Line: From 821682573e57e0384162f365652171e5ee1e6611 Mon Sep 17 00:00:00 2001
Message-Id: <821682573e57e0384162f365652171e5ee1e6611.1695921657.git.lukas@wunner.de>
In-Reply-To: <cover.1695921656.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 28 Sep 2023 19:32:41 +0200
Subject: [PATCH 11/12] PCI/CMA: Expose in sysfs whether devices are
 authenticated
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

The PCI core has just been amended to authenticate CMA-capable devices
on enumeration and store the result in an "authenticated" bit in struct
pci_dev->spdm_state.

Expose the bit to user space through an eponymous sysfs attribute.

Allow user space to trigger reauthentication (e.g. after it has updated
the CMA keyring) by writing to the sysfs attribute.

Subject to further discussion, a future commit might add a user-defined
policy to forbid driver binding to devices which failed authentication,
similar to the "authorized" attribute for USB.

Alternatively, authentication success might be signaled to user space
through a uevent, whereupon it may bind a (blacklisted) driver.
A uevent signaling authentication failure might similarly cause user
space to unbind or outright remove the potentially malicious device.

Traffic from devices which failed authentication could also be filtered
through ACS I/O Request Blocking Enable (PCIe r6.1 sec 7.7.11.3) or
through Link Disable (PCIe r6.1 sec 7.5.3.7).  Unlike an IOMMU, that
will not only protect the host, but also prevent malicious peer-to-peer
traffic to other devices.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 Documentation/ABI/testing/sysfs-bus-pci | 27 +++++++++
 drivers/pci/Kconfig                     |  3 +
 drivers/pci/Makefile                    |  1 +
 drivers/pci/cma-sysfs.c                 | 73 +++++++++++++++++++++++++
 drivers/pci/cma.c                       |  2 +
 drivers/pci/doe.c                       |  2 +
 drivers/pci/pci-sysfs.c                 |  3 +
 drivers/pci/pci.h                       |  1 +
 include/linux/pci.h                     |  2 +
 9 files changed, 114 insertions(+)
 create mode 100644 drivers/pci/cma-sysfs.c

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ecf47559f495..2ea9b8deffcc 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -500,3 +500,30 @@ Description:
 		console drivers from the device.  Raw users of pci-sysfs
 		resourceN attributes must be terminated prior to resizing.
 		Success of the resizing operation is not guaranteed.
+
+What:		/sys/bus/pci/devices/.../authenticated
+Date:		September 2023
+Contact:	Lukas Wunner <lukas@wunner.de>
+Description:
+		This file contains 1 if the device authenticated successfully
+		with CMA-SPDM (PCIe r6.1 sec 6.31).  It contains 0 if the
+		device failed authentication (and may thus be malicious).
+
+		Writing anything to this file causes reauthentication.
+		That may be opportune after updating the .cma keyring.
+
+		The file is not visible if authentication is unsupported
+		by the device.
+
+		If the kernel could not determine whether authentication is
+		supported because memory was low or DOE communication with
+		the device was not working, the file is visible but accessing
+		it fails with error code ENOTTY.
+
+		This prevents downgrade attacks where an attacker consumes
+		memory or disturbs DOE communication in order to create the
+		appearance that a device does not support authentication.
+
+		The reason why authentication support could not be determined
+		is apparent from "dmesg".  To probe for authentication support
+		again, exercise the "remove" and "rescan" attributes.
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index c9aa5253ac1f..51df3be3438e 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -129,6 +129,9 @@ config PCI_CMA
 	  A PCI DOE mailbox is used as transport for DMTF SPDM based
 	  attestation, measurement and secure channel establishment.
 
+config PCI_CMA_SYSFS
+	def_bool PCI_CMA && SYSFS
+
 config PCI_DOE
 	bool
 
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index a18812b8832b..612ae724cd2d 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_PCI_DOE)		+= doe.o
 obj-$(CONFIG_PCI_DYNAMIC_OF_NODES) += of_property.o
 
 obj-$(CONFIG_PCI_CMA)		+= cma.o cma-x509.o cma.asn1.o
+obj-$(CONFIG_PCI_CMA_SYSFS)	+= cma-sysfs.o
 $(obj)/cma-x509.o:		$(obj)/cma.asn1.h
 $(obj)/cma.asn1.o:		$(obj)/cma.asn1.c $(obj)/cma.asn1.h
 
diff --git a/drivers/pci/cma-sysfs.c b/drivers/pci/cma-sysfs.c
new file mode 100644
index 000000000000..b2d45f96601a
--- /dev/null
+++ b/drivers/pci/cma-sysfs.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Component Measurement and Authentication (CMA-SPDM, PCIe r6.1 sec 6.31)
+ *
+ * Copyright (C) 2023 Intel Corporation
+ */
+
+#include <linux/pci.h>
+#include <linux/spdm.h>
+#include <linux/sysfs.h>
+
+#include "pci.h"
+
+static ssize_t authenticated_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	ssize_t rc;
+
+	if (!pdev->cma_capable &&
+	    (pdev->cma_init_failed || pdev->doe_init_failed))
+		return -ENOTTY;
+
+	rc = pci_cma_reauthenticate(pdev);
+	if (rc)
+		return rc;
+
+	return count;
+}
+
+static ssize_t authenticated_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (!pdev->cma_capable &&
+	    (pdev->cma_init_failed || pdev->doe_init_failed))
+		return -ENOTTY;
+
+	return sysfs_emit(buf, "%u\n", spdm_authenticated(pdev->spdm_state));
+}
+static DEVICE_ATTR_RW(authenticated);
+
+static struct attribute *pci_cma_attrs[] = {
+	&dev_attr_authenticated.attr,
+	NULL
+};
+
+static umode_t pci_cma_attrs_are_visible(struct kobject *kobj,
+					 struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	/*
+	 * If CMA or DOE initialization failed, CMA attributes must be visible
+	 * and return an error on access.  This prevents downgrade attacks
+	 * where an attacker disturbs memory allocation or DOE communication
+	 * in order to create the appearance that CMA is unsupported.
+	 * The attacker may achieve that by simply hogging memory.
+	 */
+	if (!pdev->cma_capable &&
+	    !pdev->cma_init_failed && !pdev->doe_init_failed)
+		return 0;
+
+	return a->mode;
+}
+
+const struct attribute_group pci_cma_attr_group = {
+	.attrs  = pci_cma_attrs,
+	.is_visible = pci_cma_attrs_are_visible,
+};
diff --git a/drivers/pci/cma.c b/drivers/pci/cma.c
index 89d23fdc37ec..c539ad85a28f 100644
--- a/drivers/pci/cma.c
+++ b/drivers/pci/cma.c
@@ -52,6 +52,7 @@ void pci_cma_init(struct pci_dev *pdev)
 	int rc;
 
 	if (!pci_cma_keyring) {
+		pdev->cma_init_failed = true;
 		return;
 	}
 
@@ -67,6 +68,7 @@ void pci_cma_init(struct pci_dev *pdev)
 				       PCI_DOE_MAX_PAYLOAD, pci_cma_keyring,
 				       pci_cma_validate);
 	if (!pdev->spdm_state) {
+		pdev->cma_init_failed = true;
 		return;
 	}
 
diff --git a/drivers/pci/doe.c b/drivers/pci/doe.c
index 79f0336eb0c3..fabbda68edac 100644
--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -686,6 +686,7 @@ void pci_doe_init(struct pci_dev *pdev)
 						      PCI_EXT_CAP_ID_DOE))) {
 		doe_mb = pci_doe_create_mb(pdev, offset);
 		if (IS_ERR(doe_mb)) {
+			pdev->doe_init_failed = true;
 			pci_err(pdev, "[%x] failed to create mailbox: %ld\n",
 				offset, PTR_ERR(doe_mb));
 			continue;
@@ -693,6 +694,7 @@ void pci_doe_init(struct pci_dev *pdev)
 
 		rc = xa_insert(&pdev->doe_mbs, offset, doe_mb, GFP_KERNEL);
 		if (rc) {
+			pdev->doe_init_failed = true;
 			pci_err(pdev, "[%x] failed to insert mailbox: %d\n",
 				offset, rc);
 			pci_doe_destroy_mb(doe_mb);
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d9eede2dbc0e..7024e08e1b9a 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1655,6 +1655,9 @@ static const struct attribute_group *pci_dev_attr_groups[] = {
 #endif
 #ifdef CONFIG_PCIEASPM
 	&aspm_ctrl_attr_group,
+#endif
+#ifdef CONFIG_PCI_CMA_SYSFS
+	&pci_cma_attr_group,
 #endif
 	NULL,
 };
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 71092ccf4fbd..d80cc06be0cc 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -328,6 +328,7 @@ void pci_cma_destroy(struct pci_dev *pdev);
 int pci_cma_reauthenticate(struct pci_dev *pdev);
 struct x509_certificate;
 int pci_cma_validate(struct device *dev, struct x509_certificate *leaf_cert);
+extern const struct attribute_group pci_cma_attr_group;
 #else
 static inline void pci_cma_init(struct pci_dev *pdev) { }
 static inline void pci_cma_destroy(struct pci_dev *pdev) { }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2bc11d8b567e..2c5fde81bb85 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -516,10 +516,12 @@ struct pci_dev {
 #endif
 #ifdef CONFIG_PCI_DOE
 	struct xarray	doe_mbs;	/* Data Object Exchange mailboxes */
+	unsigned int	doe_init_failed:1;
 #endif
 #ifdef CONFIG_PCI_CMA
 	struct spdm_state *spdm_state;	/* Security Protocol and Data Model */
 	unsigned int	cma_capable:1;	/* Authentication supported */
+	unsigned int	cma_init_failed:1;
 #endif
 	u16		acs_cap;	/* ACS Capability offset */
 	phys_addr_t	rom;		/* Physical address if not from BAR */
-- 
2.40.1

