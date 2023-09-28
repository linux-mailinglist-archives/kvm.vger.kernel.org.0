Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868567B24B3
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjI1SC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbjI1SCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:02:22 -0400
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [176.9.242.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B78CCD6;
        Thu, 28 Sep 2023 11:02:05 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id D452B10029AE0;
        Thu, 28 Sep 2023 20:02:02 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 4B32060D850C;
        Thu, 28 Sep 2023 20:02:02 +0200 (CEST)
X-Mailbox-Line: From 89a83f42ae3c411f46efd968007e9b2afd839e74 Mon Sep 17 00:00:00 2001
Message-Id: <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
In-Reply-To: <cover.1695921656.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 28 Sep 2023 19:32:37 +0200
Subject: [PATCH 07/12] spdm: Introduce library to authenticate devices
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
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

The Security Protocol and Data Model (SPDM) allows for authentication,
measurement, key exchange and encrypted sessions with devices.

A commonly used term for authentication and measurement is attestation.

SPDM was conceived by the Distributed Management Task Force (DMTF).
Its specification defines a request/response protocol spoken between
host and attached devices over a variety of transports:

  https://www.dmtf.org/dsp/DSP0274

This implementation supports SPDM 1.0 through 1.3 (the latest version).
It is designed to be transport-agnostic as the kernel already supports
two different SPDM-capable transports:

* PCIe Data Object Exchange (PCIe r6.1 sec 6.30, drivers/pci/doe.c)
* Management Component Transport Protocol (MCTP,
  Documentation/networking/mctp.rst)

Use cases for SPDM include, but are not limited to:

* PCIe Component Measurement and Authentication (PCIe r6.1 sec 6.31)
* Compute Express Link (CXL r3.0 sec 14.11.6)
* Open Compute Project (Attestation of System Components r1.0)
  https://www.opencompute.org/documents/attestation-v1-0-20201104-pdf

The initial focus of this implementation is enabling PCIe CMA device
authentication.  As such, only a subset of the SPDM specification is
contained herein, namely the request/response sequence GET_VERSION,
GET_CAPABILITIES, NEGOTIATE_ALGORITHMS, GET_DIGESTS, GET_CERTIFICATE
and CHALLENGE.

A simple API is provided for subsystems wishing to authenticate devices:
spdm_create(), spdm_authenticate() (can be called repeatedly for
reauthentication) and spdm_destroy().  Certificates presented by devices
are validated against an in-kernel keyring of trusted root certificates.
A pointer to the keyring is passed to spdm_create().

The set of supported cryptographic algorithms is limited to those
declared mandatory in PCIe r6.1 sec 6.31.3.  Adding more algorithms
is straightforward as long as the crypto subsystem supports them.

Future commits will extend this implementation with support for
measurement, key exchange and encrypted sessions.

So far, only the SPDM requester role is implemented.  Care was taken to
allow for effortless addition of the responder role at a later stage.
This could be needed for a PCIe host bridge operating in endpoint mode.
The responder role will be able to reuse struct definitions and helpers
such as spdm_create_combined_prefix().  Those can be moved to
spdm_common.{h,c} files upon introduction of the responder role.
For now, all is kept in a single source file to avoid polluting the
global namespace with unnecessary symbols.

Credits:  Jonathan wrote a proof-of-concept of this SPDM implementation.
Lukas reworked it for upstream.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 MAINTAINERS          |    9 +
 include/linux/spdm.h |   35 +
 lib/Kconfig          |   15 +
 lib/Makefile         |    2 +
 lib/spdm_requester.c | 1487 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1548 insertions(+)
 create mode 100644 include/linux/spdm.h
 create mode 100644 lib/spdm_requester.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 90f13281d297..2591d2217d65 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19299,6 +19299,15 @@ M:	Security Officers <security@kernel.org>
 S:	Supported
 F:	Documentation/process/security-bugs.rst
 
+SECURITY PROTOCOL AND DATA MODEL (SPDM)
+M:	Jonathan Cameron <jic23@kernel.org>
+M:	Lukas Wunner <lukas@wunner.de>
+L:	linux-cxl@vger.kernel.org
+L:	linux-pci@vger.kernel.org
+S:	Maintained
+F:	include/linux/spdm.h
+F:	lib/spdm*
+
 SECURITY SUBSYSTEM
 M:	Paul Moore <paul@paul-moore.com>
 M:	James Morris <jmorris@namei.org>
diff --git a/include/linux/spdm.h b/include/linux/spdm.h
new file mode 100644
index 000000000000..e824063793a7
--- /dev/null
+++ b/include/linux/spdm.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * DMTF Security Protocol and Data Model (SPDM)
+ * https://www.dmtf.org/dsp/DSP0274
+ *
+ * Copyright (C) 2021-22 Huawei
+ *     Jonathan Cameron <Jonathan.Cameron@huawei.com>
+ *
+ * Copyright (C) 2022-23 Intel Corporation
+ */
+
+#ifndef _SPDM_H_
+#define _SPDM_H_
+
+#include <linux/types.h>
+
+struct key;
+struct device;
+struct spdm_state;
+
+typedef int (spdm_transport)(void *priv, struct device *dev,
+			     const void *request, size_t request_sz,
+			     void *response, size_t response_sz);
+
+struct spdm_state *spdm_create(struct device *dev, spdm_transport *transport,
+			       void *transport_priv, u32 transport_sz,
+			       struct key *keyring);
+
+int spdm_authenticate(struct spdm_state *spdm_state);
+
+bool spdm_authenticated(struct spdm_state *spdm_state);
+
+void spdm_destroy(struct spdm_state *spdm_state);
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index c686f4adc124..3516cf1dad16 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -764,3 +764,18 @@ config ASN1_ENCODER
 
 config POLYNOMIAL
        tristate
+
+config SPDM_REQUESTER
+	tristate
+	select KEYS
+	select ASYMMETRIC_KEY_TYPE
+	select ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+	select X509_CERTIFICATE_PARSER
+	help
+	 The Security Protocol and Data Model (SPDM) allows for authentication,
+	 measurement, key exchange and encrypted sessions with devices.  This
+	 option enables support for the SPDM requester role.
+
+	 Crypto algorithms offered to SPDM responders are limited to those
+	 enabled in .config.  Drivers selecting SPDM_REQUESTER need to also
+	 select any algorithms they deem mandatory.
diff --git a/lib/Makefile b/lib/Makefile
index 740109b6e2c8..d9ae58a9ca83 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -315,6 +315,8 @@ obj-$(CONFIG_PERCPU_TEST) += percpu_test.o
 obj-$(CONFIG_ASN1) += asn1_decoder.o
 obj-$(CONFIG_ASN1_ENCODER) += asn1_encoder.o
 
+obj-$(CONFIG_SPDM_REQUESTER) += spdm_requester.o
+
 obj-$(CONFIG_FONT_SUPPORT) += fonts/
 
 hostprogs	:= gen_crc32table
diff --git a/lib/spdm_requester.c b/lib/spdm_requester.c
new file mode 100644
index 000000000000..407041036599
--- /dev/null
+++ b/lib/spdm_requester.c
@@ -0,0 +1,1487 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DMTF Security Protocol and Data Model (SPDM)
+ * https://www.dmtf.org/dsp/DSP0274
+ *
+ * Copyright (C) 2021-22 Huawei
+ *     Jonathan Cameron <Jonathan.Cameron@huawei.com>
+ *
+ * Copyright (C) 2022-23 Intel Corporation
+ */
+
+#define dev_fmt(fmt) "SPDM: " fmt
+
+#include <linux/dev_printk.h>
+#include <linux/key.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/spdm.h>
+
+#include <asm/unaligned.h>
+#include <crypto/hash.h>
+#include <crypto/public_key.h>
+#include <keys/asymmetric-type.h>
+#include <keys/x509-parser.h>
+
+/* SPDM versions supported by this implementation */
+#define SPDM_MIN_VER 0x10
+#define SPDM_MAX_VER 0x13
+
+#define SPDM_CACHE_CAP			BIT(0)		    /* response only */
+#define SPDM_CERT_CAP			BIT(1)
+#define SPDM_CHAL_CAP			BIT(2)
+#define SPDM_MEAS_CAP_MASK		GENMASK(4, 3)	    /* response only */
+#define   SPDM_MEAS_CAP_NO		0		    /* response only */
+#define   SPDM_MEAS_CAP_MEAS		1		    /* response only */
+#define   SPDM_MEAS_CAP_MEAS_SIG	2		    /* response only */
+#define SPDM_MEAS_FRESH_CAP		BIT(5)		    /* response only */
+#define SPDM_ENCRYPT_CAP		BIT(6)
+#define SPDM_MAC_CAP			BIT(7)
+#define SPDM_MUT_AUTH_CAP		BIT(8)
+#define SPDM_KEY_EX_CAP			BIT(9)
+#define SPDM_PSK_CAP_MASK		GENMASK(11, 10)
+#define   SPDM_PSK_CAP_NO		0
+#define   SPDM_PSK_CAP_PSK		1
+#define   SPDM_PSK_CAP_PSK_CTX		2		    /* response only */
+#define SPDM_ENCAP_CAP			BIT(12)
+#define SPDM_HBEAT_CAP			BIT(13)
+#define SPDM_KEY_UPD_CAP		BIT(14)
+#define SPDM_HANDSHAKE_ITC_CAP		BIT(15)
+#define SPDM_PUB_KEY_ID_CAP		BIT(16)
+#define SPDM_CHUNK_CAP			BIT(17)		/* 1.2 */
+#define SPDM_ALIAS_CERT_CAP		BIT(18)		/* 1.2 response only */
+#define SPDM_SET_CERT_CAP		BIT(19)		/* 1.2 response only */
+#define SPDM_CSR_CAP			BIT(20)		/* 1.2 response only */
+#define SPDM_CERT_INST_RESET_CAP	BIT(21)		/* 1.2 response only */
+#define SPDM_EP_INFO_CAP_MASK		GENMASK(23, 22) /* 1.3 */
+#define   SPDM_EP_INFO_CAP_NO		0		/* 1.3 */
+#define   SPDM_EP_INFO_CAP_RSP		1		/* 1.3 */
+#define   SPDM_EP_INFO_CAP_RSP_SIG	2		/* 1.3 */
+#define SPDM_MEL_CAP			BIT(24)		/* 1.3 response only */
+#define SPDM_EVENT_CAP			BIT(25)		/* 1.3 */
+#define SPDM_MULTI_KEY_CAP_MASK		GENMASK(27, 26)	/* 1.3 */
+#define   SPDM_MULTI_KEY_CAP_NO		0		/* 1.3 */
+#define   SPDM_MULTI_KEY_CAP_ONLY	1		/* 1.3 */
+#define   SPDM_MULTI_KEY_CAP_SEL	2		/* 1.3 */
+#define SPDM_GET_KEY_PAIR_INFO_CAP	BIT(28)		/* 1.3 response only */
+#define SPDM_SET_KEY_PAIR_INFO_CAP	BIT(29)		/* 1.3 response only */
+
+/* SPDM capabilities supported by this implementation */
+#define SPDM_CAPS			(SPDM_CERT_CAP | SPDM_CHAL_CAP)
+
+/* SPDM capabilities required from responders */
+#define SPDM_MIN_CAPS			(SPDM_CERT_CAP | SPDM_CHAL_CAP)
+
+/*
+ * SPDM cryptographic timeout of this implementation:
+ * Assume calculations may take up to 1 sec on a busy machine, which equals
+ * roughly 1 << 20.  That's within the limits mandated for responders by CMA
+ * (1 << 23 usec, PCIe r6.1 sec 6.31.3) and DOE (1 sec, PCIe r6.1 sec 6.30.2).
+ * Used in GET_CAPABILITIES exchange.
+ */
+#define SPDM_CTEXPONENT			20
+
+#define SPDM_ASYM_RSASSA_2048		BIT(0)
+#define SPDM_ASYM_RSAPSS_2048		BIT(1)
+#define SPDM_ASYM_RSASSA_3072		BIT(2)
+#define SPDM_ASYM_RSAPSS_3072		BIT(3)
+#define SPDM_ASYM_ECDSA_ECC_NIST_P256	BIT(4)
+#define SPDM_ASYM_RSASSA_4096		BIT(5)
+#define SPDM_ASYM_RSAPSS_4096		BIT(6)
+#define SPDM_ASYM_ECDSA_ECC_NIST_P384	BIT(7)
+#define SPDM_ASYM_ECDSA_ECC_NIST_P521	BIT(8)
+#define SPDM_ASYM_SM2_ECC_SM2_P256	BIT(9)
+#define SPDM_ASYM_EDDSA_ED25519		BIT(10)
+#define SPDM_ASYM_EDDSA_ED448		BIT(11)
+
+#define SPDM_HASH_SHA_256		BIT(0)
+#define SPDM_HASH_SHA_384		BIT(1)
+#define SPDM_HASH_SHA_512		BIT(2)
+#define SPDM_HASH_SHA3_256		BIT(3)
+#define SPDM_HASH_SHA3_384		BIT(4)
+#define SPDM_HASH_SHA3_512		BIT(5)
+#define SPDM_HASH_SM3_256		BIT(6)
+
+#if IS_ENABLED(CONFIG_CRYPTO_RSA)
+#define SPDM_ASYM_RSA			SPDM_ASYM_RSASSA_2048 |		\
+					SPDM_ASYM_RSASSA_3072 |		\
+					SPDM_ASYM_RSASSA_4096 |
+#endif
+
+#if IS_ENABLED(CONFIG_CRYPTO_ECDSA)
+#define SPDM_ASYM_ECDSA			SPDM_ASYM_ECDSA_ECC_NIST_P256 |	\
+					SPDM_ASYM_ECDSA_ECC_NIST_P384 |
+#endif
+
+#if IS_ENABLED(CONFIG_CRYPTO_SHA256)
+#define SPDM_HASH_SHA2_256		SPDM_HASH_SHA_256 |
+#endif
+
+#if IS_ENABLED(CONFIG_CRYPTO_SHA512)
+#define SPDM_HASH_SHA2_384_512		SPDM_HASH_SHA_384 |		\
+					SPDM_HASH_SHA_512 |
+#endif
+
+/* SPDM algorithms supported by this implementation */
+#define SPDM_ASYM_ALGOS		       (SPDM_ASYM_RSA			\
+					SPDM_ASYM_ECDSA	0)
+
+#define SPDM_HASH_ALGOS		       (SPDM_HASH_SHA2_256		\
+					SPDM_HASH_SHA2_384_512 0)
+
+/*
+ * Common header shared by all messages.
+ * Note that the meaning of param1 and param2 is message dependent.
+ */
+struct spdm_header {
+	u8 version;
+	u8 code;  /* RequestResponseCode */
+	u8 param1;
+	u8 param2;
+} __packed;
+
+#define SPDM_REQ 0x80
+#define SPDM_GET_VERSION 0x84
+
+struct spdm_get_version_req {
+	u8 version;
+	u8 code;
+	u8 param1;
+	u8 param2;
+} __packed;
+
+struct spdm_get_version_rsp {
+	u8 version;
+	u8 code;
+	u8 param1;
+	u8 param2;
+
+	u8 reserved;
+	u8 version_number_entry_count;
+	__le16 version_number_entries[];
+} __packed;
+
+#define SPDM_GET_CAPABILITIES 0xE1
+#define SPDM_MIN_DATA_TRANSFER_SIZE 42 /* SPDM 1.2.0 margin no 226 */
+
+/* For this exchange the request and response messages have the same form */
+struct spdm_get_capabilities_reqrsp {
+	u8 version;
+	u8 code;
+	u8 param1;
+	u8 param2;
+	/* End of SPDM 1.0 structure */
+
+	u8 reserved1;
+	u8 ctexponent;
+	u16 reserved2;
+
+	__le32 flags;
+	/* End of SPDM 1.1 structure */
+
+	__le32 data_transfer_size;			/* 1.2+ */
+	__le32 max_spdm_msg_size;			/* 1.2+ */
+} __packed;
+
+#define SPDM_NEGOTIATE_ALGS 0xE3
+
+struct spdm_negotiate_algs_req {
+	u8 version;
+	u8 code;
+	u8 param1; /* Number of ReqAlgStruct entries at end */
+	u8 param2;
+
+	__le16 length;
+	u8 measurement_specification;
+	u8 other_params_support;			/* 1.2+ */
+
+	__le32 base_asym_algo;
+	__le32 base_hash_algo;
+
+	u8 reserved1[12];
+	u8 ext_asym_count;
+	u8 ext_hash_count;
+	u8 reserved2;
+	u8 mel_specification;				/* 1.3+ */
+
+	/*
+	 * Additional optional fields at end of this structure:
+	 * - ExtAsym: 4 bytes * ext_asym_count
+	 * - ExtHash: 4 bytes * ext_hash_count
+	 * - ReqAlgStruct: variable size * param1	 * 1.1+ *
+	 */
+} __packed;
+
+struct spdm_negotiate_algs_rsp {
+	u8 version;
+	u8 code;
+	u8 param1; /* Number of RespAlgStruct entries at end */
+	u8 param2;
+
+	__le16 length;
+	u8 measurement_specification_sel;
+	u8 other_params_sel;				/* 1.2+ */
+
+	__le32 measurement_hash_algo;
+	__le32 base_asym_sel;
+	__le32 base_hash_sel;
+
+	u8 reserved1[11];
+	u8 mel_specification_sel;			/* 1.3+ */
+	u8 ext_asym_sel_count; /* Either 0 or 1 */
+	u8 ext_hash_sel_count; /* Either 0 or 1 */
+	u8 reserved2[2];
+
+	/*
+	 * Additional optional fields at end of this structure:
+	 * - ExtAsym: 4 bytes * ext_asym_count
+	 * - ExtHash: 4 bytes * ext_hash_count
+	 * - RespAlgStruct: variable size * param1	 * 1.1+ *
+	 */
+} __packed;
+
+struct spdm_req_alg_struct {
+	u8 alg_type;
+	u8 alg_count; /* 0x2K where K is number of alg_external entries */
+	__le16 alg_supported; /* Size is in alg_count[7:4], always 2 */
+	__le32 alg_external[];
+} __packed;
+
+#define SPDM_GET_DIGESTS 0x81
+
+struct spdm_get_digests_req {
+	u8 version;
+	u8 code;
+	u8 param1; /* Reserved */
+	u8 param2; /* Reserved */
+} __packed;
+
+struct spdm_get_digests_rsp {
+	u8 version;
+	u8 code;
+	u8 param1; /* SupportedSlotMask */		/* 1.3+ */
+	u8 param2; /* ProvisionedSlotMask */
+	u8 digests[]; /* Hash of struct spdm_cert_chain for each slot */
+	/* End of SPDM 1.2 structure */
+
+	/*
+	 * Additional optional fields at end of this structure:
+	 * (omitted as long as we do not advertise MULTI_KEY_CAP)
+	 * - KeyPairID: 1 byte for each slot		 * 1.3+ *
+	 * - CertificateInfo: 1 byte for each slot	 * 1.3+ *
+	 * - KeyUsageMask: 2 bytes for each slot	 * 1.3+ *
+	 */
+} __packed;
+
+#define SPDM_GET_CERTIFICATE 0x82
+#define SPDM_SLOTS 8 /* SPDM 1.0.0 section 4.9.2.1 */
+
+struct spdm_get_certificate_req {
+	u8 version;
+	u8 code;
+	u8 param1; /* Slot number 0..7 */
+	u8 param2; /* SlotSizeRequested */		/* 1.3+ */
+	__le16 offset;
+	__le16 length;
+} __packed;
+
+struct spdm_get_certificate_rsp {
+	u8 version;
+	u8 code;
+	u8 param1; /* Slot number 0..7 */
+	u8 param2; /* CertModel */			/* 1.3+ */
+	__le16 portion_length;
+	__le16 remainder_length;
+	u8 cert_chain[]; /* PortionLength long */
+} __packed;
+
+struct spdm_cert_chain {
+	__le16 length;
+	u8 reserved[2];
+	/*
+	 * Additional fields at end of this structure:
+	 * - RootHash: Digest of Root Certificate
+	 * - Certificates: Chain of ASN.1 DER-encoded X.509 v3 certificates
+	 */
+} __packed;
+
+#define SPDM_CHALLENGE 0x83
+#define SPDM_MAX_OPAQUE_DATA 1024 /* SPDM 1.0.0 table 21 */
+
+struct spdm_challenge_req {
+	u8 version;
+	u8 code;
+	u8 param1; /* Slot number 0..7 */
+	u8 param2; /* MeasurementSummaryHash type */
+	u8 nonce[32];
+	/* End of SPDM 1.2 structure */
+
+	u8 context[8];					/* 1.3+ */
+} __packed;
+
+struct spdm_challenge_rsp {
+	u8 version;
+	u8 code;
+	u8 param1; /* Slot number 0..7 */
+	u8 param2; /* Slot mask */
+	/*
+	 * Additional fields at end of this structure:
+	 * - CertChainHash: Hash of struct spdm_cert_chain for selected slot
+	 * - Nonce: 32 bytes long
+	 * - MeasurementSummaryHash: Optional hash of selected measurements
+	 * - OpaqueDataLength: 2 bytes long
+	 * - OpaqueData: Up to 1024 bytes long
+	 * - RequesterContext: 8 bytes long		 * 1.3+ *
+	 * - Signature
+	 */
+} __packed;
+
+#define SPDM_ERROR 0x7f
+
+enum spdm_error_code {
+	spdm_invalid_request = 0x01,
+	spdm_invalid_session = 0x02,			/* 1.1 only */
+	spdm_busy = 0x03,
+	spdm_unexpected_request = 0x04,
+	spdm_unspecified = 0x05,
+	spdm_decrypt_error = 0x06,
+	spdm_unsupported_request = 0x07,
+	spdm_request_in_flight = 0x08,
+	spdm_invalid_response_code = 0x09,
+	spdm_session_limit_exceeded = 0x0a,
+	spdm_session_required = 0x0b,
+	spdm_reset_required = 0x0c,
+	spdm_response_too_large = 0x0d,
+	spdm_request_too_large = 0x0e,
+	spdm_large_response = 0x0f,
+	spdm_message_lost = 0x10,
+	spdm_invalid_policy = 0x11,			/* 1.3+ */
+	spdm_version_mismatch = 0x41,
+	spdm_response_not_ready = 0x42,
+	spdm_request_resynch = 0x43,
+	spdm_operation_failed = 0x44,			/* 1.3+ */
+	spdm_no_pending_requests = 0x45,		/* 1.3+ */
+	spdm_vendor_defined_error = 0xff,
+};
+
+struct spdm_error_rsp {
+	u8 version;
+	u8 code;
+	enum spdm_error_code error_code:8;
+	u8 error_data;
+
+	u8 extended_error_data[];
+} __packed;
+
+static int spdm_err(struct device *dev, struct spdm_error_rsp *rsp)
+{
+	switch (rsp->error_code) {
+	case spdm_invalid_request:
+		dev_err(dev, "Invalid request\n");
+		return -EINVAL;
+	case spdm_invalid_session:
+		if (rsp->version == 0x11) {
+			dev_err(dev, "Invalid session %#x\n", rsp->error_data);
+			return -EINVAL;
+		}
+		break;
+	case spdm_busy:
+		dev_err(dev, "Busy\n");
+		return -EBUSY;
+	case spdm_unexpected_request:
+		dev_err(dev, "Unexpected request\n");
+		return -EINVAL;
+	case spdm_unspecified:
+		dev_err(dev, "Unspecified error\n");
+		return -EINVAL;
+	case spdm_decrypt_error:
+		dev_err(dev, "Decrypt error\n");
+		return -EIO;
+	case spdm_unsupported_request:
+		dev_err(dev, "Unsupported request %#x\n", rsp->error_data);
+		return -EINVAL;
+	case spdm_request_in_flight:
+		dev_err(dev, "Request in flight\n");
+		return -EINVAL;
+	case spdm_invalid_response_code:
+		dev_err(dev, "Invalid response code\n");
+		return -EINVAL;
+	case spdm_session_limit_exceeded:
+		dev_err(dev, "Session limit exceeded\n");
+		return -EBUSY;
+	case spdm_session_required:
+		dev_err(dev, "Session required\n");
+		return -EINVAL;
+	case spdm_reset_required:
+		dev_err(dev, "Reset required\n");
+		return -ERESTART;
+	case spdm_response_too_large:
+		dev_err(dev, "Response too large\n");
+		return -EINVAL;
+	case spdm_request_too_large:
+		dev_err(dev, "Request too large\n");
+		return -EINVAL;
+	case spdm_large_response:
+		dev_err(dev, "Large response\n");
+		return -EMSGSIZE;
+	case spdm_message_lost:
+		dev_err(dev, "Message lost\n");
+		return -EIO;
+	case spdm_invalid_policy:
+		dev_err(dev, "Invalid policy\n");
+		return -EINVAL;
+	case spdm_version_mismatch:
+		dev_err(dev, "Version mismatch\n");
+		return -EINVAL;
+	case spdm_response_not_ready:
+		dev_err(dev, "Response not ready\n");
+		return -EINPROGRESS;
+	case spdm_request_resynch:
+		dev_err(dev, "Request resynchronization\n");
+		return -ERESTART;
+	case spdm_operation_failed:
+		dev_err(dev, "Operation failed\n");
+		return -EINVAL;
+	case spdm_no_pending_requests:
+		return -ENOENT;
+	case spdm_vendor_defined_error:
+		dev_err(dev, "Vendor defined error\n");
+		return -EINVAL;
+	}
+
+	dev_err(dev, "Undefined error %#x\n", rsp->error_code);
+	return -EINVAL;
+}
+
+/**
+ * struct spdm_state - SPDM session state
+ *
+ * @lock: Serializes multiple concurrent spdm_authenticate() calls.
+ * @authenticated: Whether device was authenticated successfully.
+ * @dev: Transport device.  Used for error reporting and passed to @transport.
+ * @transport: Transport function to perform one message exchange.
+ * @transport_priv: Transport private data.
+ * @transport_sz: Maximum message size the transport is capable of (in bytes).
+ *	Used as DataTransferSize in GET_CAPABILITIES exchange.
+ * @version: Maximum common supported version of requester and responder.
+ *	Negotiated during GET_VERSION exchange.
+ * @responder_caps: Cached capabilities of responder.
+ *	Received during GET_CAPABILITIES exchange.
+ * @base_asym_alg: Asymmetric key algorithm for signature verification of
+ *	CHALLENGE_AUTH messages.
+ *	Selected by responder during NEGOTIATE_ALGORITHMS exchange.
+ * @base_hash_alg: Hash algorithm for signature verification of
+ *	CHALLENGE_AUTH messages.
+ *	Selected by responder during NEGOTIATE_ALGORITHMS exchange.
+ * @slot_mask: Bitmask of populated certificate slots in the responder.
+ *	Received during GET_DIGESTS exchange.
+ * @base_asym_enc: Human-readable name of @base_asym_alg's signature encoding.
+ *	Passed to crypto subsystem when calling verify_signature().
+ * @s: Signature length of @base_asym_alg (in bytes).  S or SigLen in SPDM
+ *	specification.
+ * @base_hash_alg_name: Human-readable name of @base_hash_alg.
+ *	Passed to crypto subsystem when calling crypto_alloc_shash() and
+ *	verify_signature().
+ * @shash: Synchronous hash handle for @base_hash_alg computation.
+ * @desc: Synchronous hash context for @base_hash_alg computation.
+ * @h: Hash length of @base_hash_alg (in bytes).  H in SPDM specification.
+ * @leaf_key: Public key portion of leaf certificate against which to check
+ *	responder's signatures.
+ * @root_keyring: Keyring against which to check the first certificate in
+ *	responder's certificate chain.
+ */
+struct spdm_state {
+	struct mutex lock;
+	unsigned int authenticated:1;
+
+	/* Transport */
+	struct device *dev;
+	spdm_transport *transport;
+	void *transport_priv;
+	u32 transport_sz;
+
+	/* Negotiated state */
+	u8 version;
+	u32 responder_caps;
+	u32 base_asym_alg;
+	u32 base_hash_alg;
+	unsigned long slot_mask;
+
+	/* Signature algorithm */
+	const char *base_asym_enc;
+	size_t s;
+
+	/* Hash algorithm */
+	const char *base_hash_alg_name;
+	struct crypto_shash *shash;
+	struct shash_desc *desc;
+	size_t h;
+
+	/* Certificates */
+	struct public_key *leaf_key;
+	struct key *root_keyring;
+};
+
+static int __spdm_exchange(struct spdm_state *spdm_state,
+			   const void *req, size_t req_sz,
+			   void *rsp, size_t rsp_sz)
+{
+	const struct spdm_header *request = req;
+	struct spdm_header *response = rsp;
+	int length;
+	int rc;
+
+	rc = spdm_state->transport(spdm_state->transport_priv, spdm_state->dev,
+				   req, req_sz, rsp, rsp_sz);
+	if (rc < 0)
+		return rc;
+
+	length = rc;
+	if (length < sizeof(struct spdm_header))
+		return -EPROTO;
+
+	if (response->code == SPDM_ERROR)
+		return spdm_err(spdm_state->dev, (struct spdm_error_rsp *)rsp);
+
+	if (response->code != (request->code & ~SPDM_REQ)) {
+		dev_err(spdm_state->dev,
+			"Response code %#x does not match request code %#x\n",
+			response->code, request->code);
+		return -EPROTO;
+	}
+
+	return length;
+}
+
+static int spdm_exchange(struct spdm_state *spdm_state,
+			 void *req, size_t req_sz, void *rsp, size_t rsp_sz)
+{
+	struct spdm_header *req_header = req;
+
+	if (req_sz < sizeof(struct spdm_header) ||
+	    rsp_sz < sizeof(struct spdm_header))
+		return -EINVAL;
+
+	req_header->version = spdm_state->version;
+
+	return __spdm_exchange(spdm_state, req, req_sz, rsp, rsp_sz);
+}
+
+static const struct spdm_get_version_req spdm_get_version_req = {
+	.version = 0x10,
+	.code = SPDM_GET_VERSION,
+};
+
+static int spdm_get_version(struct spdm_state *spdm_state,
+			    struct spdm_get_version_rsp *rsp, size_t *rsp_sz)
+{
+	u8 version = SPDM_MIN_VER;
+	bool foundver = false;
+	int rc, length, i;
+
+	/*
+	 * Bypass spdm_exchange() to be able to set version = 0x10.
+	 * rsp buffer is large enough for the maximum possible 255 entries.
+	 */
+	rc = __spdm_exchange(spdm_state, &spdm_get_version_req,
+			     sizeof(spdm_get_version_req), rsp,
+			     struct_size(rsp, version_number_entries, 255));
+	if (rc < 0)
+		return rc;
+
+	length = rc;
+	if (length < sizeof(*rsp) ||
+	    length < struct_size(rsp, version_number_entries,
+				 rsp->version_number_entry_count)) {
+		dev_err(spdm_state->dev, "Truncated version response\n");
+		return -EIO;
+	}
+
+	for (i = 0; i < rsp->version_number_entry_count; i++) {
+		u8 ver = get_unaligned_le16(&rsp->version_number_entries[i]) >> 8;
+
+		if (ver >= version && ver <= SPDM_MAX_VER) {
+			foundver = true;
+			version = ver;
+		}
+	}
+	if (!foundver) {
+		dev_err(spdm_state->dev, "No common supported version\n");
+		return -EPROTO;
+	}
+	spdm_state->version = version;
+
+	*rsp_sz = struct_size(rsp, version_number_entries,
+			      rsp->version_number_entry_count);
+
+	return 0;
+}
+
+static int spdm_get_capabilities(struct spdm_state *spdm_state,
+				 struct spdm_get_capabilities_reqrsp *req,
+				 size_t *reqrsp_sz)
+{
+	struct spdm_get_capabilities_reqrsp *rsp;
+	size_t req_sz;
+	size_t rsp_sz;
+	int rc, length;
+
+	req->code = SPDM_GET_CAPABILITIES;
+	req->ctexponent = SPDM_CTEXPONENT;
+	req->flags = cpu_to_le32(SPDM_CAPS);
+
+	if (spdm_state->version == 0x10) {
+		req_sz = offsetof(typeof(*req), reserved1);
+		rsp_sz = offsetof(typeof(*rsp), data_transfer_size);
+	} else if (spdm_state->version == 0x11) {
+		req_sz = offsetof(typeof(*req), data_transfer_size);
+		rsp_sz = offsetof(typeof(*rsp), data_transfer_size);
+	} else {
+		req_sz = sizeof(*req);
+		rsp_sz = sizeof(*rsp);
+		req->data_transfer_size = cpu_to_le32(spdm_state->transport_sz);
+		req->max_spdm_msg_size = cpu_to_le32(spdm_state->transport_sz);
+	}
+
+	rsp = (void *)req + req_sz;
+
+	rc = spdm_exchange(spdm_state, req, req_sz, rsp, rsp_sz);
+	if (rc < 0)
+		return rc;
+
+	length = rc;
+	if (length < rsp_sz) {
+		dev_err(spdm_state->dev, "Truncated capabilities response\n");
+		return -EIO;
+	}
+
+	spdm_state->responder_caps = le32_to_cpu(rsp->flags);
+	if ((spdm_state->responder_caps & SPDM_MIN_CAPS) != SPDM_MIN_CAPS)
+		return -EPROTONOSUPPORT;
+
+	if (spdm_state->version >= 0x12) {
+		u32 data_transfer_size = le32_to_cpu(rsp->data_transfer_size);
+		if (data_transfer_size < SPDM_MIN_DATA_TRANSFER_SIZE) {
+			dev_err(spdm_state->dev,
+				"Malformed capabilities response\n");
+			return -EPROTO;
+		}
+		spdm_state->transport_sz = min(spdm_state->transport_sz,
+					       data_transfer_size);
+	}
+
+	*reqrsp_sz += req_sz + rsp_sz;
+
+	return 0;
+}
+
+/**
+ * spdm_start_hash() - Build first part of CHALLENGE_AUTH hash
+ *
+ * @spdm_state: SPDM session state
+ * @transcript: GET_VERSION request and GET_CAPABILITIES request and response
+ * @transcript_sz: length of @transcript
+ * @req: NEGOTIATE_ALGORITHMS request
+ * @req_sz: length of @req
+ * @rsp: ALGORITHMS response
+ * @rsp_sz: length of @rsp
+ *
+ * We've just learned the hash algorithm to use for CHALLENGE_AUTH signature
+ * verification.  Hash the GET_VERSION and GET_CAPABILITIES exchanges which
+ * have been stashed in @transcript, as well as the NEGOTIATE_ALGORITHMS
+ * exchange which has just been performed.  Subsequent requests and responses
+ * will be added to the hash as they become available.
+ *
+ * Return 0 on success or a negative errno.
+ */
+static int spdm_start_hash(struct spdm_state *spdm_state,
+			   void *transcript, size_t transcript_sz,
+			   void *req, size_t req_sz, void *rsp, size_t rsp_sz)
+{
+	int rc;
+
+	spdm_state->shash = crypto_alloc_shash(spdm_state->base_hash_alg_name,
+					       0, 0);
+	if (!spdm_state->shash)
+		return -ENOMEM;
+
+	spdm_state->desc = kzalloc(sizeof(*spdm_state->desc) +
+				   crypto_shash_descsize(spdm_state->shash),
+				   GFP_KERNEL);
+	if (!spdm_state->desc)
+		return -ENOMEM;
+
+	spdm_state->desc->tfm = spdm_state->shash;
+
+	/* Used frequently to compute offsets, so cache H */
+	spdm_state->h = crypto_shash_digestsize(spdm_state->shash);
+
+	rc = crypto_shash_init(spdm_state->desc);
+	if (rc)
+		return rc;
+
+	rc = crypto_shash_update(spdm_state->desc,
+				 (u8 *)&spdm_get_version_req,
+				 sizeof(spdm_get_version_req));
+	if (rc)
+		return rc;
+
+	rc = crypto_shash_update(spdm_state->desc,
+				 (u8 *)transcript, transcript_sz);
+	if (rc)
+		return rc;
+
+	rc = crypto_shash_update(spdm_state->desc, (u8 *)req, req_sz);
+	if (rc)
+		return rc;
+
+	rc = crypto_shash_update(spdm_state->desc, (u8 *)rsp, rsp_sz);
+
+	return rc;
+}
+
+static int spdm_parse_algs(struct spdm_state *spdm_state)
+{
+	switch (spdm_state->base_asym_alg) {
+	case SPDM_ASYM_RSASSA_2048:
+		spdm_state->s = 256;
+		spdm_state->base_asym_enc = "pkcs1";
+		break;
+	case SPDM_ASYM_RSASSA_3072:
+		spdm_state->s = 384;
+		spdm_state->base_asym_enc = "pkcs1";
+		break;
+	case SPDM_ASYM_RSASSA_4096:
+		spdm_state->s = 512;
+		spdm_state->base_asym_enc = "pkcs1";
+		break;
+	case SPDM_ASYM_ECDSA_ECC_NIST_P256:
+		spdm_state->s = 64;
+		spdm_state->base_asym_enc = "p1363";
+		break;
+	case SPDM_ASYM_ECDSA_ECC_NIST_P384:
+		spdm_state->s = 96;
+		spdm_state->base_asym_enc = "p1363";
+		break;
+	default:
+		dev_err(spdm_state->dev, "Unknown asym algorithm\n");
+		return -EINVAL;
+	}
+
+	switch (spdm_state->base_hash_alg) {
+	case SPDM_HASH_SHA_256:
+		spdm_state->base_hash_alg_name = "sha256";
+		break;
+	case SPDM_HASH_SHA_384:
+		spdm_state->base_hash_alg_name = "sha384";
+		break;
+	case SPDM_HASH_SHA_512:
+		spdm_state->base_hash_alg_name = "sha512";
+		break;
+	default:
+		dev_err(spdm_state->dev, "Unknown hash algorithm\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int spdm_negotiate_algs(struct spdm_state *spdm_state,
+			       void *transcript, size_t transcript_sz)
+{
+	struct spdm_req_alg_struct *req_alg_struct;
+	struct spdm_negotiate_algs_req *req;
+	struct spdm_negotiate_algs_rsp *rsp;
+	size_t req_sz = sizeof(*req);
+	size_t rsp_sz = sizeof(*rsp);
+	int rc, length;
+
+	/* Request length shall be <= 128 bytes (SPDM 1.1.0 margin no 185) */
+	BUILD_BUG_ON(req_sz > 128);
+
+	req = kzalloc(req_sz, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->code = SPDM_NEGOTIATE_ALGS;
+	req->length = cpu_to_le16(req_sz);
+	req->base_asym_algo = cpu_to_le32(SPDM_ASYM_ALGOS);
+	req->base_hash_algo = cpu_to_le32(SPDM_HASH_ALGOS);
+
+	rsp = kzalloc(rsp_sz, GFP_KERNEL);
+	if (!rsp) {
+		rc = -ENOMEM;
+		goto err_free_req;
+	}
+
+	rc = spdm_exchange(spdm_state, req, req_sz, rsp, rsp_sz);
+	if (rc < 0)
+		goto err_free_rsp;
+
+	length = rc;
+	if (length < sizeof(*rsp) ||
+	    length < sizeof(*rsp) + rsp->param1 * sizeof(*req_alg_struct)) {
+		dev_err(spdm_state->dev, "Truncated algorithms response\n");
+		rc = -EIO;
+		goto err_free_rsp;
+	}
+
+	spdm_state->base_asym_alg =
+		le32_to_cpu(rsp->base_asym_sel) & SPDM_ASYM_ALGOS;
+	spdm_state->base_hash_alg =
+		le32_to_cpu(rsp->base_hash_sel) & SPDM_HASH_ALGOS;
+
+	/* Responder shall select exactly 1 alg (SPDM 1.0.0 table 14) */
+	if (hweight32(spdm_state->base_asym_alg) != 1 ||
+	    hweight32(spdm_state->base_hash_alg) != 1 ||
+	    rsp->ext_asym_sel_count != 0 ||
+	    rsp->ext_hash_sel_count != 0 ||
+	    rsp->param1 > req->param1) {
+		dev_err(spdm_state->dev, "Malformed algorithms response\n");
+		rc = -EPROTO;
+		goto err_free_rsp;
+	}
+
+	rc = spdm_parse_algs(spdm_state);
+	if (rc)
+		goto err_free_rsp;
+
+	/*
+	 * If request contained a ReqAlgStruct not supported by responder,
+	 * the corresponding RespAlgStruct may be omitted in response.
+	 * Calculate the actual (possibly shorter) response length:
+	 */
+	rsp_sz = sizeof(*rsp) + rsp->param1 * sizeof(*req_alg_struct);
+
+	rc = spdm_start_hash(spdm_state, transcript, transcript_sz,
+			     req, req_sz, rsp, rsp_sz);
+
+err_free_rsp:
+	kfree(rsp);
+err_free_req:
+	kfree(req);
+
+	return rc;
+}
+
+static int spdm_get_digests(struct spdm_state *spdm_state)
+{
+	struct spdm_get_digests_req req = { .code = SPDM_GET_DIGESTS };
+	struct spdm_get_digests_rsp *rsp;
+	size_t rsp_sz;
+	int rc, length;
+
+	/*
+	 * Assume all 8 slots are populated.  We know the hash length (and thus
+	 * the response size) because the responder only returns digests for
+	 * the hash algorithm selected during the NEGOTIATE_ALGORITHMS exchange
+	 * (SPDM 1.1.2 margin no 206).
+	 */
+	rsp_sz = sizeof(*rsp) + SPDM_SLOTS * spdm_state->h;
+	rsp = kzalloc(rsp_sz, GFP_KERNEL);
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = spdm_exchange(spdm_state, &req, sizeof(req), rsp, rsp_sz);
+	if (rc < 0)
+		goto err_free_rsp;
+
+	length = rc;
+	if (length < sizeof(*rsp) ||
+	    length < sizeof(*rsp) + hweight8(rsp->param2) * spdm_state->h) {
+		dev_err(spdm_state->dev, "Truncated digests response\n");
+		rc = -EIO;
+		goto err_free_rsp;
+	}
+
+	rsp_sz = sizeof(*rsp) + hweight8(rsp->param2) * spdm_state->h;
+
+	/*
+	 * Authentication-capable endpoints must carry at least 1 cert chain
+	 * (SPDM 1.0.0 section 4.9.2.1).
+	 */
+	spdm_state->slot_mask = rsp->param2;
+	if (!spdm_state->slot_mask) {
+		dev_err(spdm_state->dev, "No certificates provisioned\n");
+		rc = -EPROTO;
+		goto err_free_rsp;
+	}
+
+	rc = crypto_shash_update(spdm_state->desc, (u8 *)&req, sizeof(req));
+	if (rc)
+		goto err_free_rsp;
+
+	rc = crypto_shash_update(spdm_state->desc, (u8 *)rsp, rsp_sz);
+
+err_free_rsp:
+	kfree(rsp);
+
+	return rc;
+}
+
+static int spdm_validate_cert_chain(struct spdm_state *spdm_state, u8 slot,
+				    u8 *certs, size_t total_length)
+{
+	struct x509_certificate *cert, *prev = NULL;
+	bool is_leaf_cert;
+	size_t offset = 0;
+	struct key *key;
+	int rc, length;
+
+	while (offset < total_length) {
+		rc = x509_get_certificate_length(certs + offset,
+						 total_length - offset);
+		if (rc < 0) {
+			dev_err(spdm_state->dev, "Invalid certificate length "
+				"at slot %u offset %zu\n", slot, offset);
+			goto err_free_prev;
+		}
+
+		length = rc;
+		is_leaf_cert = offset + length == total_length;
+
+		cert = x509_cert_parse(certs + offset, length);
+		if (IS_ERR(cert)) {
+			rc = PTR_ERR(cert);
+			dev_err(spdm_state->dev, "Certificate parse error %d "
+				"at slot %u offset %zu\n", rc, slot, offset);
+			goto err_free_prev;
+		}
+		if ((is_leaf_cert ==
+		     test_bit(KEY_EFLAG_CA, &cert->pub->key_eflags)) ||
+		    (is_leaf_cert &&
+		     !test_bit(KEY_EFLAG_DIGITALSIG, &cert->pub->key_eflags))) {
+			rc = -EKEYREJECTED;
+			dev_err(spdm_state->dev, "Malformed certificate "
+				"at slot %u offset %zu\n", slot, offset);
+			goto err_free_cert;
+		}
+		if (cert->unsupported_sig) {
+			rc = -EKEYREJECTED;
+			dev_err(spdm_state->dev, "Unsupported signature "
+				"at slot %u offset %zu\n", slot, offset);
+			goto err_free_cert;
+		}
+		if (cert->blacklisted) {
+			rc = -EKEYREJECTED;
+			goto err_free_cert;
+		}
+
+		if (!prev) {
+			/* First cert in chain, check against root_keyring */
+			key = find_asymmetric_key(spdm_state->root_keyring,
+						  cert->sig->auth_ids[0],
+						  cert->sig->auth_ids[1],
+						  cert->sig->auth_ids[2],
+						  false);
+			if (IS_ERR(key)) {
+				dev_info(spdm_state->dev, "Root certificate "
+					 "for slot %u not found in %s "
+					 "keyring: %s\n", slot,
+					 spdm_state->root_keyring->description,
+					 cert->issuer);
+				rc = PTR_ERR(key);
+				goto err_free_cert;
+			}
+
+			rc = verify_signature(key, cert->sig);
+			key_put(key);
+		} else {
+			/* Subsequent cert in chain, check against previous */
+			rc = public_key_verify_signature(prev->pub, cert->sig);
+		}
+
+		if (rc) {
+			dev_err(spdm_state->dev, "Signature validation error "
+				"%d at slot %u offset %zu\n", rc, slot, offset);
+			goto err_free_cert;
+		}
+
+		x509_free_certificate(prev);
+		offset += length;
+		prev = cert;
+	}
+
+	prev = NULL;
+	spdm_state->leaf_key = cert->pub;
+	cert->pub = NULL;
+
+err_free_cert:
+	x509_free_certificate(cert);
+err_free_prev:
+	x509_free_certificate(prev);
+	return rc;
+}
+
+static int spdm_get_certificate(struct spdm_state *spdm_state, u8 slot)
+{
+	struct spdm_get_certificate_req req = {
+		.code = SPDM_GET_CERTIFICATE,
+		.param1 = slot,
+	};
+	struct spdm_get_certificate_rsp *rsp;
+	struct spdm_cert_chain *certs = NULL;
+	size_t rsp_sz, total_length, header_length;
+	u16 remainder_length = 0xffff;
+	u16 portion_length;
+	u16 offset = 0;
+	int rc, length;
+
+	/*
+	 * It is legal for the responder to send more bytes than requested.
+	 * (Note the "should" in SPDM 1.0.0 table 19.)  If we allocate a
+	 * too small buffer, we can't calculate the hash over the (truncated)
+	 * response.  Only choice is thus to allocate the maximum possible 64k.
+	 */
+	rsp_sz = min_t(u32, sizeof(*rsp) + 0xffff, spdm_state->transport_sz);
+	rsp = kvmalloc(rsp_sz, GFP_KERNEL);
+	if (!rsp)
+		return -ENOMEM;
+
+	do {
+		/*
+		 * If transport_sz is sufficiently large, first request will be
+		 * for offset 0 and length 0xffff, which means entire cert
+		 * chain (SPDM 1.0.0 table 18).
+		 */
+		req.offset = cpu_to_le16(offset);
+		req.length = cpu_to_le16(min_t(size_t, remainder_length,
+					       rsp_sz - sizeof(*rsp)));
+
+		rc = spdm_exchange(spdm_state, &req, sizeof(req), rsp, rsp_sz);
+		if (rc < 0)
+			goto err_free_certs;
+
+		length = rc;
+		if (length < sizeof(*rsp) ||
+		    length < sizeof(*rsp) + le16_to_cpu(rsp->portion_length)) {
+			dev_err(spdm_state->dev,
+				"Truncated certificate response\n");
+			rc = -EIO;
+			goto err_free_certs;
+		}
+
+		portion_length = le16_to_cpu(rsp->portion_length);
+		remainder_length = le16_to_cpu(rsp->remainder_length);
+
+		/*
+		 * On first response we learn total length of cert chain.
+		 * Should portion_length + remainder_length exceed 0xffff,
+		 * the min() ensures that the malformed check triggers below.
+		 */
+		if (!certs) {
+			total_length = min(portion_length + remainder_length,
+					   0xffff);
+			certs = kvmalloc(total_length, GFP_KERNEL);
+			if (!certs) {
+				rc = -ENOMEM;
+				goto err_free_certs;
+			}
+		}
+
+		if (!portion_length ||
+		    (rsp->param1 & 0xf) != slot ||
+		    offset + portion_length + remainder_length != total_length)
+		{
+			dev_err(spdm_state->dev,
+				"Malformed certificate response\n");
+			rc = -EPROTO;
+			goto err_free_certs;
+		}
+
+		memcpy((u8 *)certs + offset, rsp->cert_chain, portion_length);
+		offset += portion_length;
+
+		rc = crypto_shash_update(spdm_state->desc, (u8 *)&req,
+					 sizeof(req));
+		if (rc)
+			goto err_free_certs;
+
+		rc = crypto_shash_update(spdm_state->desc, (u8 *)rsp,
+					 sizeof(*rsp) + portion_length);
+		if (rc)
+			goto err_free_certs;
+
+	} while (remainder_length > 0);
+
+	header_length = sizeof(struct spdm_cert_chain) + spdm_state->h;
+
+	if (total_length < header_length ||
+	    total_length != le16_to_cpu(certs->length)) {
+		dev_err(spdm_state->dev,
+			"Malformed certificate chain in slot %u\n", slot);
+		rc = -EPROTO;
+		goto err_free_certs;
+	}
+
+	rc = spdm_validate_cert_chain(spdm_state, slot,
+				      (u8 *)certs + header_length,
+				      total_length - header_length);
+
+err_free_certs:
+	kvfree(certs);
+	kvfree(rsp);
+	return rc;
+}
+
+#define SPDM_PREFIX_SZ 64 /* SPDM 1.2.0 margin no 803 */
+#define SPDM_COMBINED_PREFIX_SZ 100 /* SPDM 1.2.0 margin no 806 */
+
+/**
+ * spdm_create_combined_prefix() - Create combined_spdm_prefix for a hash
+ *
+ * @spdm_state: SPDM session state
+ * @spdm_context: SPDM context
+ * @buf: Buffer to receive combined_spdm_prefix (100 bytes)
+ *
+ * From SPDM 1.2, a hash is prefixed with the SPDM version and context before
+ * a signature is generated (or verified) over the resulting concatenation
+ * (SPDM 1.2.0 section 15).  Create that prefix.
+ */
+static void spdm_create_combined_prefix(struct spdm_state *spdm_state,
+					const char *spdm_context, void *buf)
+{
+	u8 minor = spdm_state->version & 0xf;
+	u8 major = spdm_state->version >> 4;
+	size_t len = strlen(spdm_context);
+	int rc, zero_pad;
+
+	rc = snprintf(buf, SPDM_PREFIX_SZ + 1,
+		      "dmtf-spdm-v%hhx.%hhx.*dmtf-spdm-v%hhx.%hhx.*"
+		      "dmtf-spdm-v%hhx.%hhx.*dmtf-spdm-v%hhx.%hhx.*",
+		      major, minor, major, minor, major, minor, major, minor);
+	WARN_ON(rc != SPDM_PREFIX_SZ);
+
+	zero_pad = SPDM_COMBINED_PREFIX_SZ - SPDM_PREFIX_SZ - 1 - len;
+	WARN_ON(zero_pad < 0);
+
+	memset(buf + SPDM_PREFIX_SZ + 1, 0, zero_pad);
+	memcpy(buf + SPDM_PREFIX_SZ + 1 + zero_pad, spdm_context, len);
+}
+
+/**
+ * spdm_verify_signature() - Verify signature against leaf key
+ *
+ * @spdm_state: SPDM session state
+ * @s: Signature
+ * @spdm_context: SPDM context (used to create combined_spdm_prefix)
+ *
+ * Implementation of the abstract SPDMSignatureVerify() function described in
+ * SPDM 1.2.0 section 16:  Compute the hash in @spdm_state->desc and verify
+ * that its signature @s was generated with @spdm_state->leaf_key.
+ * Return 0 on success or a negative errno.
+ */
+static int spdm_verify_signature(struct spdm_state *spdm_state, u8 *s,
+				 const char *spdm_context)
+{
+	struct public_key_signature sig = {
+		.s = s,
+		.s_size = spdm_state->s,
+		.encoding = spdm_state->base_asym_enc,
+		.hash_algo = spdm_state->base_hash_alg_name,
+	};
+	u8 *m, *mhash = NULL;
+	int rc;
+
+	m = kmalloc(SPDM_COMBINED_PREFIX_SZ + spdm_state->h, GFP_KERNEL);
+	if (!m)
+		return -ENOMEM;
+
+	rc = crypto_shash_final(spdm_state->desc, m + SPDM_COMBINED_PREFIX_SZ);
+	if (rc)
+		goto err_free_m;
+
+	if (spdm_state->version <= 0x11) {
+		/*
+		 * Until SPDM 1.1, the signature is computed only over the hash
+		 * (SPDM 1.0.0 section 4.9.2.7).
+		 */
+		sig.digest = m + SPDM_COMBINED_PREFIX_SZ;
+		sig.digest_size = spdm_state->h;
+	} else {
+		/*
+		 * From SPDM 1.2, the hash is prefixed with spdm_context before
+		 * computing the signature over the resulting message M
+		 * (SPDM 1.2.0 margin no 841).
+		 */
+		spdm_create_combined_prefix(spdm_state, spdm_context, m);
+
+		/*
+		 * RSA and ECDSA algorithms require that M is hashed once more.
+		 * EdDSA and SM2 algorithms omit that step.
+		 * The switch statement prepares for their introduction.
+		 */
+		switch (spdm_state->base_asym_alg) {
+		default:
+			mhash = kmalloc(spdm_state->h, GFP_KERNEL);
+			if (!mhash) {
+				rc = -ENOMEM;
+				goto err_free_m;
+			}
+
+			rc = crypto_shash_digest(spdm_state->desc, m,
+				SPDM_COMBINED_PREFIX_SZ + spdm_state->h,
+				mhash);
+			if (rc)
+				goto err_free_mhash;
+
+			sig.digest = mhash;
+			sig.digest_size = spdm_state->h;
+			break;
+		}
+	}
+
+	rc = public_key_verify_signature(spdm_state->leaf_key, &sig);
+
+err_free_mhash:
+	kfree(mhash);
+err_free_m:
+	kfree(m);
+	return rc;
+}
+
+/**
+ * spdm_challenge_rsp_sz() - Calculate CHALLENGE_AUTH response size
+ *
+ * @spdm_state: SPDM session state
+ * @rsp: CHALLENGE_AUTH response (optional)
+ *
+ * A CHALLENGE_AUTH response contains multiple variable-length fields
+ * as well as optional fields.  This helper eases calculating its size.
+ *
+ * If @rsp is %NULL, assume the maximum OpaqueDataLength of 1024 bytes
+ * (SPDM 1.0.0 table 21).  Otherwise read OpaqueDataLength from @rsp.
+ * OpaqueDataLength can only be > 0 for SPDM 1.0 and 1.1, as they lack
+ * the OtherParamsSupport field in the NEGOTIATE_ALGORITHMS request.
+ * For SPDM 1.2+, we do not offer any Opaque Data Formats in that field,
+ * which forces OpaqueDataLength to 0 (SPDM 1.2.0 margin no 261).
+ */
+static size_t spdm_challenge_rsp_sz(struct spdm_state *spdm_state,
+				    struct spdm_challenge_rsp *rsp)
+{
+	size_t  size  = sizeof(*rsp)		/* Header */
+		      + spdm_state->h		/* CertChainHash */
+		      + 32;			/* Nonce */
+
+	if (rsp)
+		/* May be unaligned if hash algorithm has unusual length. */
+		size += get_unaligned_le16((u8 *)rsp + size);
+	else
+		size += SPDM_MAX_OPAQUE_DATA;	/* OpaqueData */
+
+	size += 2;				/* OpaqueDataLength */
+
+	if (spdm_state->version >= 0x13)
+		size += 8;			/* RequesterContext */
+
+	return  size  + spdm_state->s;		/* Signature */
+}
+
+static int spdm_challenge(struct spdm_state *spdm_state, u8 slot)
+{
+	size_t req_sz, rsp_sz, rsp_sz_max, sig_offset;
+	struct spdm_challenge_req req = {
+		.code = SPDM_CHALLENGE,
+		.param1 = slot,
+		.param2 = 0, /* no measurement summary hash */
+	};
+	struct spdm_challenge_rsp *rsp;
+	int rc, length;
+
+	get_random_bytes(&req.nonce, sizeof(req.nonce));
+
+	if (spdm_state->version <= 0x12)
+		req_sz = offsetof(typeof(req), context);
+	else
+		req_sz = sizeof(req);
+
+	rsp_sz_max = spdm_challenge_rsp_sz(spdm_state, NULL);
+	rsp = kzalloc(rsp_sz_max, GFP_KERNEL);
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = spdm_exchange(spdm_state, &req, req_sz, rsp, rsp_sz_max);
+	if (rc < 0)
+		goto err_free_rsp;
+
+	length = rc;
+	rsp_sz = spdm_challenge_rsp_sz(spdm_state, rsp);
+	if (length < rsp_sz) {
+		dev_err(spdm_state->dev, "Truncated challenge_auth response\n");
+		rc = -EIO;
+		goto err_free_rsp;
+	}
+
+	/* Last step of building the hash */
+	rc = crypto_shash_update(spdm_state->desc, (u8 *)&req, req_sz);
+	if (rc)
+		goto err_free_rsp;
+
+	sig_offset = rsp_sz - spdm_state->s;
+	rc = crypto_shash_update(spdm_state->desc, (u8 *)rsp, sig_offset);
+	if (rc)
+		goto err_free_rsp;
+
+	/* Hash is complete and signature received; verify against leaf key */
+	rc = spdm_verify_signature(spdm_state, (u8 *)rsp + sig_offset,
+				   "responder-challenge_auth signing");
+	if (rc)
+		dev_err(spdm_state->dev,
+			"Failed to verify challenge_auth signature: %d\n", rc);
+
+err_free_rsp:
+	kfree(rsp);
+	return rc;
+}
+
+static void spdm_reset(struct spdm_state *spdm_state)
+{
+	public_key_free(spdm_state->leaf_key);
+	spdm_state->leaf_key = NULL;
+
+	kfree(spdm_state->desc);
+	spdm_state->desc = NULL;
+
+	crypto_free_shash(spdm_state->shash);
+	spdm_state->shash = NULL;
+}
+
+/**
+ * spdm_authenticate() - Authenticate device
+ *
+ * @spdm_state: SPDM session state
+ *
+ * Authenticate a device through a sequence of GET_VERSION, GET_CAPABILITIES,
+ * NEGOTIATE_ALGORITHMS, GET_DIGESTS, GET_CERTIFICATE and CHALLENGE exchanges.
+ *
+ * Perform internal locking to serialize multiple concurrent invocations.
+ * Can be called repeatedly for reauthentication.
+ *
+ * Return 0 on success or a negative errno.  In particular, -EPROTONOSUPPORT
+ * indicates that authentication is not supported by the device.
+ */
+int spdm_authenticate(struct spdm_state *spdm_state)
+{
+	size_t transcript_sz;
+	void *transcript;
+	int rc = -ENOMEM;
+	u8 slot;
+
+	mutex_lock(&spdm_state->lock);
+	spdm_reset(spdm_state);
+
+	/*
+	 * For CHALLENGE_AUTH signature verification, a hash is computed over
+	 * all exchanged messages to detect modification by a man-in-the-middle
+	 * or media error.  However the hash algorithm is not known until the
+	 * NEGOTIATE_ALGORITHMS response has been received.  The preceding
+	 * GET_VERSION and GET_CAPABILITIES exchanges are therefore stashed
+	 * in a transcript buffer and consumed once the algorithm is known.
+	 * The buffer size is sufficient for the largest possible messages with
+	 * 255 version entries and the capability fields added by SPDM 1.2.
+	 */
+	transcript = kzalloc(struct_size_t(struct spdm_get_version_rsp,
+					   version_number_entries, 255) +
+			     sizeof(struct spdm_get_capabilities_reqrsp) * 2,
+			     GFP_KERNEL);
+	if (!transcript)
+		goto unlock;
+
+	rc = spdm_get_version(spdm_state, transcript, &transcript_sz);
+	if (rc)
+		goto unlock;
+
+	rc = spdm_get_capabilities(spdm_state, transcript + transcript_sz,
+				   &transcript_sz);
+	if (rc)
+		goto unlock;
+
+	rc = spdm_negotiate_algs(spdm_state, transcript, transcript_sz);
+	if (rc)
+		goto unlock;
+
+	rc = spdm_get_digests(spdm_state);
+	if (rc)
+		goto unlock;
+
+	for_each_set_bit(slot, &spdm_state->slot_mask, SPDM_SLOTS) {
+		rc = spdm_get_certificate(spdm_state, slot);
+		if (rc == 0)
+			break; /* success */
+		if (rc != -ENOKEY && rc != -EKEYREJECTED)
+			break; /* try next slot only on signature error */
+	}
+	if (rc)
+		goto unlock;
+
+	rc = spdm_challenge(spdm_state, slot);
+
+unlock:
+	if (rc)
+		spdm_reset(spdm_state);
+	spdm_state->authenticated = !rc;
+	mutex_unlock(&spdm_state->lock);
+	kfree(transcript);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(spdm_authenticate);
+
+/**
+ * spdm_authenticated() - Whether device was authenticated successfully
+ *
+ * @spdm_state: SPDM session state
+ *
+ * Return true if the most recent spdm_authenticate() call was successful.
+ */
+bool spdm_authenticated(struct spdm_state *spdm_state)
+{
+	return spdm_state->authenticated;
+}
+EXPORT_SYMBOL_GPL(spdm_authenticated);
+
+/**
+ * spdm_create() - Allocate SPDM session
+ *
+ * @dev: Transport device
+ * @transport: Transport function to perform one message exchange
+ * @transport_priv: Transport private data
+ * @transport_sz: Maximum message size the transport is capable of (in bytes)
+ * @keyring: Trusted root certificates
+ *
+ * Returns a pointer to the allocated SPDM session state or NULL on error.
+ */
+struct spdm_state *spdm_create(struct device *dev, spdm_transport *transport,
+			       void *transport_priv, u32 transport_sz,
+			       struct key *keyring)
+{
+	struct spdm_state *spdm_state = kzalloc(sizeof(*spdm_state), GFP_KERNEL);
+
+	if (!spdm_state)
+		return NULL;
+
+	spdm_state->dev = dev;
+	spdm_state->transport = transport;
+	spdm_state->transport_priv = transport_priv;
+	spdm_state->transport_sz = transport_sz;
+	spdm_state->root_keyring = keyring;
+
+	mutex_init(&spdm_state->lock);
+
+	return spdm_state;
+}
+EXPORT_SYMBOL_GPL(spdm_create);
+
+/**
+ * spdm_destroy() - Destroy SPDM session
+ *
+ * @spdm_state: SPDM session state
+ */
+void spdm_destroy(struct spdm_state *spdm_state)
+{
+	spdm_reset(spdm_state);
+	mutex_destroy(&spdm_state->lock);
+	kfree(spdm_state);
+}
+EXPORT_SYMBOL_GPL(spdm_destroy);
+
+MODULE_LICENSE("GPL");
-- 
2.40.1

