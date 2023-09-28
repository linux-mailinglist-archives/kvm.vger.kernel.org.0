Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6F7B24CC
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjI1SHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjI1SHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:07:52 -0400
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB6E19E;
        Thu, 28 Sep 2023 11:07:49 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 4C7A410029AE0;
        Thu, 28 Sep 2023 20:07:47 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id F395760D850C;
        Thu, 28 Sep 2023 20:07:46 +0200 (CEST)
X-Mailbox-Line: From bc1efd945f5d76587787f8351199e1ea45eaf2ef Mon Sep 17 00:00:00 2001
Message-Id: <bc1efd945f5d76587787f8351199e1ea45eaf2ef.1695921657.git.lukas@wunner.de>
In-Reply-To: <cover.1695921656.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 28 Sep 2023 19:32:39 +0200
Subject: [PATCH 09/12] PCI/CMA: Validate Subject Alternative Name in
 certificates
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PCIe r6.1 sec 6.31.3 stipulates requirements for X.509 Leaf Certificates
presented by devices, in particular the presence of a Subject Alternative
Name extension with a name that encodes the Vendor ID, Device ID, Device
Serial Number, etc.

This prevents a mismatch between the device identity in Config Space and
the certificate.  A device cannot misappropriate a certificate from a
different device without also spoofing Config Space.  As a corollary,
it cannot dupe an arbitrary driver into binding to it.  (Only those
which bind to the device identity in the Subject Alternative Name work.)

Parse the Subject Alternative Name using a small ASN.1 module and
validate its contents.  The theory of operation is explained in a code
comment at the top of the newly added cma-x509.c.

This functionality is introduced in a separate commit on top of basic
CMA-SPDM support to split the code into digestible, reviewable chunks.

The CMA OID added here is taken from the official OID Repository
(it's not documented in the PCIe Base Spec):
https://oid-rep.orange-labs.fr/get/2.23.147

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/pci/Makefile         |   4 +-
 drivers/pci/cma-x509.c       | 119 +++++++++++++++++++++++++++++++++++
 drivers/pci/cma.asn1         |  36 +++++++++++
 drivers/pci/cma.c            |   3 +-
 drivers/pci/pci.h            |   2 +
 include/linux/oid_registry.h |   3 +
 include/linux/spdm.h         |   6 +-
 lib/spdm_requester.c         |  14 ++++-
 8 files changed, 183 insertions(+), 4 deletions(-)
 create mode 100644 drivers/pci/cma-x509.c
 create mode 100644 drivers/pci/cma.asn1

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index e0705b82690b..a18812b8832b 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -34,7 +34,9 @@ obj-$(CONFIG_VGA_ARB)		+= vgaarb.o
 obj-$(CONFIG_PCI_DOE)		+= doe.o
 obj-$(CONFIG_PCI_DYNAMIC_OF_NODES) += of_property.o
 
-obj-$(CONFIG_PCI_CMA)		+= cma.o
+obj-$(CONFIG_PCI_CMA)		+= cma.o cma-x509.o cma.asn1.o
+$(obj)/cma-x509.o:		$(obj)/cma.asn1.h
+$(obj)/cma.asn1.o:		$(obj)/cma.asn1.c $(obj)/cma.asn1.h
 
 # Endpoint library must be initialized before its users
 obj-$(CONFIG_PCI_ENDPOINT)	+= endpoint/
diff --git a/drivers/pci/cma-x509.c b/drivers/pci/cma-x509.c
new file mode 100644
index 000000000000..614590303b38
--- /dev/null
+++ b/drivers/pci/cma-x509.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Component Measurement and Authentication (CMA-SPDM, PCIe r6.1 sec 6.31)
+ *
+ * The spdm_requester.c library calls pci_cma_validate() to check requirements
+ * for X.509 Leaf Certificates per PCIe r6.1 sec 6.31.3.
+ *
+ * It parses the Subject Alternative Name using the ASN.1 module cma.asn1,
+ * which calls pci_cma_note_oid() and pci_cma_note_san() to compare an
+ * OtherName against the expected name.
+ *
+ * The expected name is constructed beforehand by pci_cma_construct_san().
+ *
+ * Copyright (C) 2023 Intel Corporation
+ */
+
+#define dev_fmt(fmt) "CMA: " fmt
+
+#include <keys/x509-parser.h>
+#include <linux/asn1_decoder.h>
+#include <linux/oid_registry.h>
+#include <linux/pci.h>
+
+#include "cma.asn1.h"
+#include "pci.h"
+
+#define CMA_NAME_MAX sizeof("Vendor=1234:Device=1234:CC=123456:"	  \
+			    "REV=12:SSVID=1234:SSID=1234:1234567890123456")
+
+struct pci_cma_x509_context {
+	struct pci_dev *pdev;
+	enum OID last_oid;
+	char expected_name[CMA_NAME_MAX];
+	unsigned int expected_len;
+	unsigned int found:1;
+};
+
+int pci_cma_note_oid(void *context, size_t hdrlen, unsigned char tag,
+		     const void *value, size_t vlen)
+{
+	struct pci_cma_x509_context *ctx = context;
+
+	ctx->last_oid = look_up_OID(value, vlen);
+
+	return 0;
+}
+
+int pci_cma_note_san(void *context, size_t hdrlen, unsigned char tag,
+		     const void *value, size_t vlen)
+{
+	struct pci_cma_x509_context *ctx = context;
+
+	/* These aren't the drOIDs we're looking for. */
+	if (ctx->last_oid != OID_CMA)
+		return 0;
+
+	if (tag != ASN1_UTF8STR ||
+	    vlen != ctx->expected_len ||
+	    memcmp(value, ctx->expected_name, vlen) != 0) {
+		pci_err(ctx->pdev, "Invalid X.509 Subject Alternative Name\n");
+		return -EINVAL;
+	}
+
+	ctx->found = true;
+
+	return 0;
+}
+
+static unsigned int pci_cma_construct_san(struct pci_dev *pdev, char *name)
+{
+	unsigned int len;
+	u64 serial;
+
+	len = snprintf(name, CMA_NAME_MAX,
+		       "Vendor=%04hx:Device=%04hx:CC=%06x:REV=%02hhx",
+		       pdev->vendor, pdev->device, pdev->class, pdev->revision);
+
+	if (pdev->hdr_type == PCI_HEADER_TYPE_NORMAL)
+		len += snprintf(name + len, CMA_NAME_MAX - len,
+				":SSVID=%04hx:SSID=%04hx",
+				pdev->subsystem_vendor, pdev->subsystem_device);
+
+	serial = pci_get_dsn(pdev);
+	if (serial)
+		len += snprintf(name + len, CMA_NAME_MAX - len,
+				":%016llx", serial);
+
+	return len;
+}
+
+int pci_cma_validate(struct device *dev, struct x509_certificate *leaf_cert)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_cma_x509_context ctx;
+	int ret;
+
+	if (!leaf_cert->raw_san) {
+		pci_err(pdev, "Missing X.509 Subject Alternative Name\n");
+		return -EINVAL;
+	}
+
+	ctx.pdev = pdev;
+	ctx.found = false;
+	ctx.expected_len = pci_cma_construct_san(pdev, ctx.expected_name);
+
+	ret = asn1_ber_decoder(&cma_decoder, &ctx, leaf_cert->raw_san,
+			       leaf_cert->raw_san_size);
+	if (ret == -EBADMSG || ret == -EMSGSIZE)
+		pci_err(pdev, "Malformed X.509 Subject Alternative Name\n");
+	if (ret < 0)
+		return ret;
+
+	if (!ctx.found) {
+		pci_err(pdev, "Missing X.509 OtherName with CMA OID\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/drivers/pci/cma.asn1 b/drivers/pci/cma.asn1
new file mode 100644
index 000000000000..10f90e107009
--- /dev/null
+++ b/drivers/pci/cma.asn1
@@ -0,0 +1,36 @@
+-- Component Measurement and Authentication (CMA-SPDM, PCIe r6.1 sec 6.31.3)
+-- X.509 Subject Alternative Name (RFC 5280 sec 4.2.1.6)
+--
+-- https://www.rfc-editor.org/rfc/rfc5280#section-4.2.1.6
+--
+-- The ASN.1 module in RFC 5280 appendix A.1 uses EXPLICIT TAGS whereas the one
+-- in appendix A.2 uses IMPLICIT TAGS.  The kernel's simplified asn1_compiler.c
+-- always uses EXPLICIT TAGS, hence this ASN.1 module differs from RFC 5280 in
+-- that it adds IMPLICIT to definitions from appendix A.2 (such as OtherName)
+-- and omits EXPLICIT in those definitions.
+
+SubjectAltName ::= GeneralNames
+
+GeneralNames ::= SEQUENCE OF GeneralName
+
+GeneralName ::= CHOICE {
+	otherName			[0] IMPLICIT OtherName,
+	rfc822Name			[1] IMPLICIT IA5String,
+	dNSName				[2] IMPLICIT IA5String,
+	x400Address			[3] ANY,
+	directoryName			[4] ANY,
+	ediPartyName			[5] IMPLICIT EDIPartyName,
+	uniformResourceIdentifier	[6] IMPLICIT IA5String,
+	iPAddress			[7] IMPLICIT OCTET STRING,
+	registeredID			[8] IMPLICIT OBJECT IDENTIFIER
+	}
+
+OtherName ::= SEQUENCE {
+	type-id			OBJECT IDENTIFIER ({ pci_cma_note_oid }),
+	value			[0] ANY ({ pci_cma_note_san })
+	}
+
+EDIPartyName ::= SEQUENCE {
+	nameAssigner		[0] ANY OPTIONAL,
+	partyName		[1] ANY
+	}
diff --git a/drivers/pci/cma.c b/drivers/pci/cma.c
index 06e5846325e3..012190c54ab6 100644
--- a/drivers/pci/cma.c
+++ b/drivers/pci/cma.c
@@ -64,7 +64,8 @@ void pci_cma_init(struct pci_dev *pdev)
 		return;
 
 	pdev->spdm_state = spdm_create(&pdev->dev, pci_doe_transport, doe,
-				       PCI_DOE_MAX_PAYLOAD, pci_cma_keyring);
+				       PCI_DOE_MAX_PAYLOAD, pci_cma_keyring,
+				       pci_cma_validate);
 	if (!pdev->spdm_state) {
 		return;
 	}
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index bd80a0369c9c..6c4755a2c91c 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -325,6 +325,8 @@ static inline void pci_doe_disconnected(struct pci_dev *pdev) { }
 #ifdef CONFIG_PCI_CMA
 void pci_cma_init(struct pci_dev *pdev);
 void pci_cma_destroy(struct pci_dev *pdev);
+struct x509_certificate;
+int pci_cma_validate(struct device *dev, struct x509_certificate *leaf_cert);
 #else
 static inline void pci_cma_init(struct pci_dev *pdev) { }
 static inline void pci_cma_destroy(struct pci_dev *pdev) { }
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index f86a08ba0207..cafec7111473 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -141,6 +141,9 @@ enum OID {
 	OID_TPMImportableKey,		/* 2.23.133.10.1.4 */
 	OID_TPMSealedData,		/* 2.23.133.10.1.5 */
 
+	/* PCI */
+	OID_CMA,			/* 2.23.147 */
+
 	OID__NR
 };
 
diff --git a/include/linux/spdm.h b/include/linux/spdm.h
index e824063793a7..69a83bc2eb41 100644
--- a/include/linux/spdm.h
+++ b/include/linux/spdm.h
@@ -17,14 +17,18 @@
 struct key;
 struct device;
 struct spdm_state;
+struct x509_certificate;
 
 typedef int (spdm_transport)(void *priv, struct device *dev,
 			     const void *request, size_t request_sz,
 			     void *response, size_t response_sz);
 
+typedef int (spdm_validate)(struct device *dev,
+			    struct x509_certificate *leaf_cert);
+
 struct spdm_state *spdm_create(struct device *dev, spdm_transport *transport,
 			       void *transport_priv, u32 transport_sz,
-			       struct key *keyring);
+			       struct key *keyring, spdm_validate *validate);
 
 int spdm_authenticate(struct spdm_state *spdm_state);
 
diff --git a/lib/spdm_requester.c b/lib/spdm_requester.c
index 407041036599..b2af2074ba6f 100644
--- a/lib/spdm_requester.c
+++ b/lib/spdm_requester.c
@@ -489,6 +489,7 @@ static int spdm_err(struct device *dev, struct spdm_error_rsp *rsp)
  *	responder's signatures.
  * @root_keyring: Keyring against which to check the first certificate in
  *	responder's certificate chain.
+ * @validate: Function to validate additional leaf certificate requirements.
  */
 struct spdm_state {
 	struct mutex lock;
@@ -520,6 +521,7 @@ struct spdm_state {
 	/* Certificates */
 	struct public_key *leaf_key;
 	struct key *root_keyring;
+	spdm_validate *validate;
 };
 
 static int __spdm_exchange(struct spdm_state *spdm_state,
@@ -1003,6 +1005,13 @@ static int spdm_validate_cert_chain(struct spdm_state *spdm_state, u8 slot,
 	}
 
 	prev = NULL;
+
+	if (spdm_state->validate) {
+		rc = spdm_state->validate(spdm_state->dev, cert);
+		if (rc)
+			goto err_free_cert;
+	}
+
 	spdm_state->leaf_key = cert->pub;
 	cert->pub = NULL;
 
@@ -1447,12 +1456,14 @@ EXPORT_SYMBOL_GPL(spdm_authenticated);
  * @transport_priv: Transport private data
  * @transport_sz: Maximum message size the transport is capable of (in bytes)
  * @keyring: Trusted root certificates
+ * @validate: Function to validate additional leaf certificate requirements
+ *	(optional, may be %NULL)
  *
  * Returns a pointer to the allocated SPDM session state or NULL on error.
  */
 struct spdm_state *spdm_create(struct device *dev, spdm_transport *transport,
 			       void *transport_priv, u32 transport_sz,
-			       struct key *keyring)
+			       struct key *keyring, spdm_validate *validate)
 {
 	struct spdm_state *spdm_state = kzalloc(sizeof(*spdm_state), GFP_KERNEL);
 
@@ -1464,6 +1475,7 @@ struct spdm_state *spdm_create(struct device *dev, spdm_transport *transport,
 	spdm_state->transport_priv = transport_priv;
 	spdm_state->transport_sz = transport_sz;
 	spdm_state->root_keyring = keyring;
+	spdm_state->validate = validate;
 
 	mutex_init(&spdm_state->lock);
 
-- 
2.40.1

