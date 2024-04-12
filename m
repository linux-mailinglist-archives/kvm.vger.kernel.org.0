Return-Path: <kvm+bounces-14512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DD508A2C7D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D0211C21108
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E6C58126;
	Fri, 12 Apr 2024 10:35:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143E95490C
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918114; cv=none; b=Ifdg8Io8hnmA28DVEYjHhBCVAPRQkm8zlxKhxgjzSWoGmPBUAhNzEDl8GO3Tul6P6NvX2ZzZcO+zRVmHX/AqukkVjdQq6L29lGjets3w3OtQoQfSJIp57XafjM4AoHHGnwioFnJvvD2vpv+m9f4wQFsx5WGXUgvG8kxru0D+aTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918114; c=relaxed/simple;
	bh=tCbKgiS9JR+jEImK8XQQyk9nFFWuB9faxCmsN/kvyKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i8+hZUvO4c+yQSdHyzEq+Jf5tLiX9BDWEXGgn1jgPTVgMFjgIWqwwWyJJDJRYsR7mJoAi5/OBz6S/zw0NHP7RVnngo2bU4UG9iLDfJhOnySrZXMxEiWz6VMD2R4HYu6hVZTecmPVbRBhBqYDRcb8cp0FBESEV5VBTyDODPv7WBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7D95339;
	Fri, 12 Apr 2024 03:35:40 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CB0F3F64C;
	Fri, 12 Apr 2024 03:35:09 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Mate Toth-Pal <mate.toth-pal@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 26/33] arm: Add a library to verify tokens using the QCBOR library
Date: Fri, 12 Apr 2024 11:34:01 +0100
Message-Id: <20240412103408.2706058-27-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mate Toth-Pal <mate.toth-pal@arm.com>

Add a library wrapper around the QCBOR for parsing the Arm CCA attestation
tokens.

Signed-off-by: Mate Toth-Pal <mate.toth-pal@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/Makefile.arm64                  |   7 +-
 lib/token_verifier/attest_defines.h |  50 +++
 lib/token_verifier/token_dumper.c   | 157 ++++++++
 lib/token_verifier/token_dumper.h   |  15 +
 lib/token_verifier/token_verifier.c | 591 ++++++++++++++++++++++++++++
 lib/token_verifier/token_verifier.h |  77 ++++
 6 files changed, 896 insertions(+), 1 deletion(-)
 create mode 100644 lib/token_verifier/attest_defines.h
 create mode 100644 lib/token_verifier/token_dumper.c
 create mode 100644 lib/token_verifier/token_dumper.h
 create mode 100644 lib/token_verifier/token_verifier.c
 create mode 100644 lib/token_verifier/token_verifier.h

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index de73601d..79952914 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -11,6 +11,7 @@ arch_LDFLAGS += -z notext
 CFLAGS += -mstrict-align
 CFLAGS += -I $(SRCDIR)/lib/qcbor/inc
 CFLAGS += -DQCBOR_DISABLE_FLOAT_HW_USE -DQCBOR_DISABLE_PREFERRED_FLOAT -DUSEFULBUF_DISABLE_ALL_FLOAT
+CFLAGS += -I $(SRCDIR)/lib/token_verifier
 
 sve_flag := $(call cc-option, -march=armv8.5-a+sve, "")
 ifneq ($(strip $(sve_flag)),)
@@ -38,6 +39,9 @@ cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
 cflatobjs += lib/arm64/rsi.o
 cflatobjs += lib/qcbor/src/qcbor_decode.o lib/qcbor/src/UsefulBuf.o
+cflatobjs += lib/token_verifier/token_verifier.o
+cflatobjs += lib/token_verifier/token_dumper.o
+
 
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/acpi.o
@@ -68,4 +72,5 @@ include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
 arch_clean: arm_clean
 	$(RM) lib/arm64/.*.d		\
-	      lib/qcbor/src/.*.d
+	      lib/qcbor/src/.*.d	\
+	      lib/token_verifier/.*.d
diff --git a/lib/token_verifier/attest_defines.h b/lib/token_verifier/attest_defines.h
new file mode 100644
index 00000000..daf51c5f
--- /dev/null
+++ b/lib/token_verifier/attest_defines.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#ifndef __ATTEST_DEFINES_H__
+#define __ATTEST_DEFINES_H__
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#define TAG_COSE_SIGN1                       (18)
+#define TAG_CCA_TOKEN                       (399)
+
+#define CCA_PLAT_TOKEN                    (44234)    /* 0xACCA */
+#define CCA_REALM_DELEGATED_TOKEN         (44241)
+
+/* CCA Platform Attestation Token */
+#define CCA_PLAT_CHALLENGE                   (10)    /* EAT nonce */
+#define CCA_PLAT_INSTANCE_ID                (256)    /* EAT ueid */
+#define CCA_PLAT_PROFILE                    (265)    /* EAT profile */
+#define CCA_PLAT_SECURITY_LIFECYCLE        (2395)
+#define CCA_PLAT_IMPLEMENTATION_ID         (2396)
+#define CCA_PLAT_SW_COMPONENTS             (2399)
+#define CCA_PLAT_VERIFICATION_SERVICE      (2400)
+#define CCA_PLAT_CONFIGURATION             (2401)
+#define CCA_PLAT_HASH_ALGO_ID              (2402)
+
+/* CCA Realm Delegated Attestation Token */
+#define CCA_REALM_CHALLENGE                  (10)    /* EAT nonce */
+#define CCA_REALM_PERSONALIZATION_VALUE   (44235)
+#define CCA_REALM_HASH_ALGO_ID            (44236)
+#define CCA_REALM_PUB_KEY                 (44237)
+#define CCA_REALM_INITIAL_MEASUREMENT     (44238)
+#define CCA_REALM_EXTENSIBLE_MEASUREMENTS (44239)
+#define CCA_REALM_PUB_KEY_HASH_ALGO_ID    (44240)
+
+/* Software components */
+#define CCA_SW_COMP_MEASUREMENT_VALUE         (2)
+#define CCA_SW_COMP_VERSION                   (4)
+#define CCA_SW_COMP_SIGNER_ID                 (5)
+#define CCA_SW_COMP_HASH_ALGORITHM            (6)
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* __ATTEST_DEFINES_H__ */
diff --git a/lib/token_verifier/token_dumper.c b/lib/token_verifier/token_dumper.c
new file mode 100644
index 00000000..275d1fc5
--- /dev/null
+++ b/lib/token_verifier/token_dumper.c
@@ -0,0 +1,157 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include "attest_defines.h"
+#include "libcflat.h"
+#include "token_dumper.h"
+
+#define COLUMN_WIDTH "20"
+
+void print_raw_token(const char *token, size_t size)
+{
+	int i;
+	char byte;
+
+	printf("\r\nCopy paste token to www.cbor.me\r\n");
+	for (i = 0; i < size; ++i) {
+		byte = token[i];
+		if (byte == 0)
+			printf("0x%#02x ", byte);
+		else
+			printf("0x%02x ", byte);
+		if (((i + 1) % 8) == 0)
+			printf("\r\n");
+	}
+	printf("\r\n");
+}
+
+static void print_indent(int indent_level)
+{
+	int i;
+
+	for (i = 0; i < indent_level; ++i) {
+		printf("  ");
+	}
+}
+
+static void print_byte_string(const char *name, int index,
+			      struct q_useful_buf_c buf)
+{
+	int i;
+
+	printf("%-"COLUMN_WIDTH"s (#%d) = [", name, index);
+	for (i = 0; i < buf.len; ++i) {
+		printf("%02x", ((uint8_t *)buf.ptr)[i]);
+	}
+	printf("]\r\n");
+}
+
+static void print_text(const char *name, int index, struct q_useful_buf_c buf)
+{
+	int i;
+
+	printf("%-"COLUMN_WIDTH"s (#%d) = \"", name, index);
+	for (i = 0; i < buf.len; ++i) {
+		printf("%c", ((uint8_t *)buf.ptr)[i]);
+	}
+	printf("\"\r\n");
+}
+
+static void print_claim(struct claim_t *claim, int indent_level)
+{
+	print_indent(indent_level);
+	if (claim->present) {
+		switch (claim->type) {
+		case CLAIM_INT64:
+			printf("%-"COLUMN_WIDTH"s (#%" PRId64 ") = %" PRId64
+				"\r\n", claim->title,
+			claim->key, claim->int_data);
+			break;
+		case CLAIM_BOOL:
+			printf("%-"COLUMN_WIDTH"s (#%" PRId64 ") = %s\r\n",
+			claim->title, claim->key,
+			claim->bool_data?"true":"false");
+			break;
+		case CLAIM_BSTR:
+			print_byte_string(claim->title, claim->key,
+				claim->buffer_data);
+			break;
+		case CLAIM_TEXT:
+			print_text(claim->title, claim->key,
+				claim->buffer_data);
+			break;
+		default:
+			printf("* Internal error at  %s:%d.\r\n", __FILE__,
+				(int)__LINE__);
+			break;
+		}
+	} else {
+		printf("* Missing%s claim with key: %" PRId64 " (%s)\r\n",
+			claim->mandatory?" mandatory":"",
+			claim->key, claim->title);
+	}
+}
+
+static void print_cose_sign1_wrapper(const char *token_type,
+				     struct claim_t *cose_sign1_wrapper)
+{
+	printf("\r\n== %s Token cose header:\r\n", token_type);
+	print_claim(cose_sign1_wrapper + 0, 0);
+	/* Don't print wrapped token bytestring */
+	print_claim(cose_sign1_wrapper + 2, 0);
+	printf("== End of %s Token cose header\r\n\r\n", token_type);
+}
+
+void print_token(struct attestation_claims *claims)
+{
+	int i;
+
+	print_cose_sign1_wrapper("Realm", claims->realm_cose_sign1_wrapper);
+
+	printf("\r\n== Realm Token:\r\n");
+	/* print the claims except the last one. That is printed in detail
+	 * below.
+	 */
+	for (i = 0; i < CLAIM_COUNT_REALM_TOKEN; ++i) {
+		struct claim_t *claim = claims->realm_token_claims + i;
+
+		print_claim(claim, 0);
+	}
+
+	printf("%-"COLUMN_WIDTH"s (#%d)\r\n", "Realm measurements",
+		CCA_REALM_EXTENSIBLE_MEASUREMENTS);
+	for (i = 0; i < CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS; ++i) {
+		struct claim_t *claim = claims->realm_measurement_claims + i;
+
+		print_claim(claim, 1);
+	}
+	printf("== End of Realm Token.\r\n");
+
+	print_cose_sign1_wrapper("Platform", claims->plat_cose_sign1_wrapper);
+
+	printf("\r\n== Platform Token:\r\n");
+	for (i = 0; i < CLAIM_COUNT_PLATFORM_TOKEN; ++i) {
+		struct claim_t *claim = claims->plat_token_claims + i;
+
+		print_claim(claim, 0);
+	}
+	printf("== End of Platform Token\r\n\r\n");
+
+	printf("\r\n== Platform Token SW components:\r\n");
+
+	for (i = 0; i < MAX_SW_COMPONENT_COUNT; ++i) {
+		struct sw_component_t *component =
+			claims->sw_component_claims + i;
+
+		if (component->present) {
+			printf("  SW component #%d:\r\n", i);
+			for (int j = 0; j < CLAIM_COUNT_SW_COMPONENT; ++j) {
+				print_claim(component->claims + j, 2);
+			}
+		}
+	}
+	printf("== End of Platform Token SW components\r\n\r\n");
+}
diff --git a/lib/token_verifier/token_dumper.h b/lib/token_verifier/token_dumper.h
new file mode 100644
index 00000000..96cc0744
--- /dev/null
+++ b/lib/token_verifier/token_dumper.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#ifndef __TOKEN_DUMPER_H__
+#define __TOKEN_DUMPER_H__
+
+#include "token_verifier.h"
+
+void print_raw_token(const char *token, size_t size);
+void print_token(struct attestation_claims *claims);
+
+#endif /* __TOKEN_DUMPER_H__ */
diff --git a/lib/token_verifier/token_verifier.c b/lib/token_verifier/token_verifier.c
new file mode 100644
index 00000000..ba2a89f6
--- /dev/null
+++ b/lib/token_verifier/token_verifier.c
@@ -0,0 +1,591 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#include <libcflat.h>
+#include <inttypes.h>
+#include <qcbor/qcbor_decode.h>
+#include <qcbor/qcbor_spiffy_decode.h>
+#include "attest_defines.h"
+#include "token_verifier.h"
+#include "token_dumper.h"
+
+#define SHA256_SIZE 32
+#define SHA512_SIZE 64
+
+#define RETURN_ON_DECODE_ERROR(p_context) \
+	do { \
+		QCBORError ret; \
+		ret = QCBORDecode_GetError(p_context); \
+		if (ret != QCBOR_SUCCESS) { \
+			printf("QCBOR decode failed with error at %s:%d." \
+				" err = %d\r\n", \
+				__FILE__, (int)__LINE__, (int)ret); \
+			return TOKEN_VERIFICATION_ERR_QCBOR(ret); \
+		} \
+	} while (0)
+
+static void init_claim(struct claim_t *claim,
+		       bool mandatory, enum claim_data_type type,
+		       int64_t key, const char *title, bool present)
+{
+	claim->mandatory = mandatory;
+	claim->type = type;
+	claim->key = key;
+	claim->title = title;
+	claim->present = present;
+}
+
+static int init_cose_wrapper_claim(struct claim_t *cose_sign1_wrapper)
+{
+	struct claim_t *c;
+
+	/* The cose wrapper looks like the following:
+	 *  - Protected header (bytestring).
+	 *  - Unprotected header: might contain 0 items. This is a map. Due to
+	 *    the way this thing is implemented, it is not in the below list,
+	 *    but is handled in the verify_token_cose_sign1_wrapping
+	 *    function.
+	 *  - Payload: Platform token (bytestring). The content is passed for
+	 *    verify_platform_token.
+	 *  - Signature.
+	 */
+	c = cose_sign1_wrapper;
+	/* This structure is in an array, so the key is not used */
+	init_claim(c++, true, CLAIM_BSTR, 0, "Protected header",  false);
+	init_claim(c++, true, CLAIM_BSTR, 0, "Platform token payload", false);
+	init_claim(c++, true, CLAIM_BSTR, 0, "Signature",  false);
+	if (c > cose_sign1_wrapper + CLAIM_COUNT_COSE_SIGN1_WRAPPER) {
+		return TOKEN_VERIFICATION_ERR_INIT_ERROR;
+	}
+	return 0;
+}
+
+static int init_claims(struct attestation_claims *attest_claims)
+{
+	int i;
+	int ret;
+	struct claim_t *c;
+	/* TODO: All the buffer overwrite checks are happening too late.
+	 * Either remove, or find a better way.
+	 */
+	c = attest_claims->realm_token_claims;
+	init_claim(c++, true, CLAIM_BSTR, CCA_REALM_CHALLENGE,             "Realm challenge",                false);
+	init_claim(c++, true, CLAIM_BSTR, CCA_REALM_PERSONALIZATION_VALUE, "Realm personalization value",    false);
+	init_claim(c++, true, CLAIM_TEXT, CCA_REALM_HASH_ALGO_ID,          "Realm hash algo id",             false);
+	init_claim(c++, true, CLAIM_TEXT, CCA_REALM_PUB_KEY_HASH_ALGO_ID,  "Realm public key hash algo id",  false);
+	init_claim(c++, true, CLAIM_BSTR, CCA_REALM_PUB_KEY,               "Realm signing public key",       false);
+	init_claim(c++, true, CLAIM_BSTR, CCA_REALM_INITIAL_MEASUREMENT,   "Realm initial measurement",      false);
+	/* Realm extensible measurements are not present here as they are
+	 * encoded as a CBOR array, and it is handled specially in
+	 * verify_realm_token().
+	 */
+	if (c > attest_claims->realm_token_claims + CLAIM_COUNT_REALM_TOKEN) {
+		return TOKEN_VERIFICATION_ERR_INIT_ERROR;
+	}
+
+	ret = init_cose_wrapper_claim(attest_claims->realm_cose_sign1_wrapper);
+	if (ret != 0) {
+		return ret;
+	}
+	ret = init_cose_wrapper_claim(attest_claims->plat_cose_sign1_wrapper);
+	if (ret != 0) {
+		return ret;
+	}
+
+	c = attest_claims->plat_token_claims;
+	init_claim(c++, true,  CLAIM_BSTR,  CCA_PLAT_CHALLENGE,            "Challenge",            false);
+	init_claim(c++, false, CLAIM_TEXT,  CCA_PLAT_VERIFICATION_SERVICE, "Verification service", false);
+	init_claim(c++, true,  CLAIM_TEXT,  CCA_PLAT_PROFILE,              "Profile",              false);
+	init_claim(c++, true,  CLAIM_BSTR,  CCA_PLAT_INSTANCE_ID,          "Instance ID",          false);
+	init_claim(c++, true,  CLAIM_BSTR,  CCA_PLAT_IMPLEMENTATION_ID,    "Implementation ID",    false);
+	init_claim(c++, true,  CLAIM_INT64, CCA_PLAT_SECURITY_LIFECYCLE,   "Lifecycle",            false);
+	init_claim(c++, true,  CLAIM_BSTR,  CCA_PLAT_CONFIGURATION,        "Configuration",        false);
+	init_claim(c++, true,  CLAIM_TEXT,  CCA_PLAT_HASH_ALGO_ID,         "Platform hash algo",   false);
+	if (c > attest_claims->plat_token_claims +
+		CLAIM_COUNT_PLATFORM_TOKEN) {
+		return TOKEN_VERIFICATION_ERR_INIT_ERROR;
+	}
+
+	for (i = 0; i < CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS; ++i) {
+		c = attest_claims->realm_measurement_claims + i;
+		init_claim(c, true, CLAIM_BSTR, i,
+			"Realm extensible measurements", false);
+	}
+
+	for (i = 0; i < MAX_SW_COMPONENT_COUNT; ++i) {
+		struct sw_component_t *component =
+			attest_claims->sw_component_claims + i;
+
+		component->present = false;
+		c = component->claims;
+		init_claim(c++, false, CLAIM_TEXT, CCA_SW_COMP_HASH_ALGORITHM,    "Hash algo.",  false);
+		init_claim(c++, true,  CLAIM_BSTR, CCA_SW_COMP_MEASUREMENT_VALUE, "Meas. val.", false);
+		init_claim(c++, false, CLAIM_TEXT, CCA_SW_COMP_VERSION,           "Version",    false);
+		init_claim(c++, true,  CLAIM_BSTR, CCA_SW_COMP_SIGNER_ID,         "Signer ID",  false);
+		if (c > component->claims + CLAIM_COUNT_SW_COMPONENT) {
+			return TOKEN_VERIFICATION_ERR_INIT_ERROR;
+		}
+	}
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+static int handle_claim_decode_error(const struct claim_t *claim,
+				     QCBORError err)
+{
+	if (err == QCBOR_ERR_LABEL_NOT_FOUND) {
+		if (claim->mandatory) {
+			printf("Mandatory claim with key %" PRId64 " (%s) is "
+				"missing from token.\r\n", claim->key,
+				claim->title);
+			return TOKEN_VERIFICATION_ERR_MISSING_MANDATORY_CLAIM;
+		}
+	} else {
+		printf("Decode failed with error at %s:%d. err = %d key = %"
+			PRId64 " (%s).\r\n",  __FILE__, (int)__LINE__, err,
+			claim->key, claim->title);
+		return TOKEN_VERIFICATION_ERR_QCBOR(err);
+	}
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+/* Consume claims from a map.
+ *
+ * This function iterates on the array 'claims', and looks up items with the
+ * specified keys. If a claim flagged as mandatory is not found, an error is
+ * returned. The function doesn't checks for extra items. So if the map contains
+ * items with keys that are not in the claims array, no error is reported.
+ *
+ * The map needs to be 'entered' before calling this function, and be 'exited'
+ * after it returns.
+ */
+static int get_claims_from_map(QCBORDecodeContext *p_context,
+			       struct claim_t *claims,
+			       size_t num_of_claims)
+{
+	QCBORError err;
+	int token_verification_error;
+	int i;
+
+	for (i = 0; i < num_of_claims; ++i) {
+		struct claim_t *claim = claims + i;
+
+		switch (claim->type) {
+		case CLAIM_INT64:
+			QCBORDecode_GetInt64InMapN(p_context, claim->key,
+				&(claim->int_data));
+			break;
+		case CLAIM_BOOL:
+			QCBORDecode_GetBoolInMapN(p_context, claim->key,
+				&(claim->bool_data));
+			break;
+		case CLAIM_BSTR:
+			QCBORDecode_GetByteStringInMapN(p_context, claim->key,
+				&(claim->buffer_data));
+			break;
+		case CLAIM_TEXT:
+			QCBORDecode_GetTextStringInMapN(p_context, claim->key,
+				&(claim->buffer_data));
+			break;
+		default:
+			printf("Internal error at  %s:%d.\r\n",
+				__FILE__, (int)__LINE__);
+			return TOKEN_VERIFICATION_ERR_INTERNAL_ERROR;
+		}
+		err = QCBORDecode_GetAndResetError(p_context);
+		if (err == QCBOR_SUCCESS) {
+			claim->present = true;
+		} else {
+			token_verification_error =
+				handle_claim_decode_error(claim, err);
+			if (token_verification_error !=
+				TOKEN_VERIFICATION_ERR_SUCCESS) {
+				return token_verification_error;
+			}
+		}
+	}
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+/* Consume a single claim from an array and from the top level.
+ *
+ * The claim's 'key' and 'mandatory' attribute is not used in this function.
+ * The claim is considered mandatory.
+ */
+static int get_claim(QCBORDecodeContext *p_context, struct claim_t *claim)
+{
+	QCBORError err;
+
+	switch (claim->type) {
+	case CLAIM_INT64:
+		QCBORDecode_GetInt64(p_context, &(claim->int_data));
+		break;
+	case CLAIM_BOOL:
+		QCBORDecode_GetBool(p_context, &(claim->bool_data));
+		break;
+	case CLAIM_BSTR:
+		QCBORDecode_GetByteString(p_context, &(claim->buffer_data));
+		break;
+	case CLAIM_TEXT:
+		QCBORDecode_GetTextString(p_context, &(claim->buffer_data));
+		break;
+	default:
+		printf("Internal error at  %s:%d.\r\n",
+			__FILE__, (int)__LINE__);
+		break;
+	}
+	err = QCBORDecode_GetAndResetError(p_context);
+	if (err == QCBOR_SUCCESS) {
+		claim->present = true;
+		return TOKEN_VERIFICATION_ERR_SUCCESS;
+	}
+	printf("Decode failed with error at %s:%d. err = %d claim: \"%s\".\r\n",
+		__FILE__, (int)__LINE__, err, claim->title);
+	return TOKEN_VERIFICATION_ERR_QCBOR(err);
+}
+
+/* Consume claims from an array and from the top level.
+ *
+ * This function iterates on the array 'claims', and gets an item for each
+ * element. If the array or the cbor runs out of elements before reaching the
+ * end of the 'claims' array, then error is returned.
+ *
+ * The claim's 'key' and 'mandatory' attribute is not used in this function.
+ * All the elements considered mandatory.
+ */
+static int get_claims(QCBORDecodeContext *p_context, struct claim_t *claims,
+		      size_t num_of_claims)
+{
+	QCBORError err;
+	int i;
+
+	for (i = 0; i < num_of_claims; ++i) {
+		struct claim_t *claim = claims + i;
+
+		err = get_claim(p_context, claim);
+		if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+			return err;
+		}
+	}
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+static int verify_platform_token(struct q_useful_buf_c buf,
+				 struct attestation_claims *attest_claims)
+{
+	QCBORDecodeContext context;
+	int err;
+	int label, index;
+
+	QCBORDecode_Init(&context, buf, QCBOR_DECODE_MODE_NORMAL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_EnterMap(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	err = get_claims_from_map(&context,
+		attest_claims->plat_token_claims,
+		CLAIM_COUNT_PLATFORM_TOKEN);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	label = CCA_PLAT_SW_COMPONENTS;
+	QCBORDecode_EnterArrayFromMapN(&context, label);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	index = 0;
+	while (1) {
+		QCBORDecode_EnterMap(&context, NULL);
+		if (QCBORDecode_GetError(&context) == QCBOR_ERR_NO_MORE_ITEMS) {
+			/* This is OK. We just reached the end of the array.
+			 * Break from the loop.
+			 */
+			break;
+		}
+
+		if (index >= MAX_SW_COMPONENT_COUNT) {
+			printf("Not enough slots in sw_component_claims.\r\n");
+			printf("Increase MAX_SW_COMPONENT_COUNT in %s.\r\n",
+				__FILE__);
+			return TOKEN_VERIFICATION_ERR_INTERNAL_ERROR;
+		}
+
+		err = get_claims_from_map(&context,
+			attest_claims->sw_component_claims[index].claims,
+			CLAIM_COUNT_SW_COMPONENT);
+		if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+			return err;
+		}
+		attest_claims->sw_component_claims[index].present = true;
+
+		QCBORDecode_ExitMap(&context);
+		RETURN_ON_DECODE_ERROR(&context);
+
+		++index;
+	}
+	/* We only get here if the decode error code was a
+	 * QCBOR_ERR_NO_MORE_ITEMS which is expected when the end of an array is
+	 * reached. In this case the processing must be continued, so clear the
+	 * error.
+	 */
+	QCBORDecode_GetAndResetError(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_ExitArray(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_ExitMap(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_Finish(&context);
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+static bool verify_length_of_measurement(size_t len)
+{
+	size_t allowed_lengths[] = {SHA256_SIZE, SHA512_SIZE};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(allowed_lengths); ++i) {
+		if (len == allowed_lengths[i])
+			return true;
+	}
+
+	return false;
+}
+
+static int verify_realm_token(struct q_useful_buf_c buf,
+			     struct attestation_claims *attest_claims)
+{
+	QCBORDecodeContext context;
+	int err;
+	int i;
+
+	QCBORDecode_Init(&context, buf, QCBOR_DECODE_MODE_NORMAL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_EnterMap(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	err = get_claims_from_map(&context, attest_claims->realm_token_claims,
+		CLAIM_COUNT_REALM_TOKEN);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	/* Now get the realm extensible measurements */
+	QCBORDecode_EnterArrayFromMapN(&context,
+					CCA_REALM_EXTENSIBLE_MEASUREMENTS);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	err = get_claims(&context,
+		attest_claims->realm_measurement_claims,
+		CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	for (i = 0; i < CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS; ++i) {
+		struct claim_t *claims =
+			attest_claims->realm_measurement_claims;
+		struct q_useful_buf_c buf = claims[i].buffer_data;
+
+		if (!verify_length_of_measurement(buf.len)) {
+			return TOKEN_VERIFICATION_ERR_INVALID_CLAIM_LEN;
+		}
+	}
+
+	QCBORDecode_ExitArray(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_ExitMap(&context);
+	QCBORDecode_Finish(&context);
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+/* Returns a pointer to the wrapped token in: 'token_payload'.
+ * Returns the claims in the wrapper in cose_sign1_wrapper.
+ */
+static int verify_token_cose_sign1_wrapping(
+				  struct q_useful_buf_c token,
+				  struct q_useful_buf_c *token_payload,
+				  struct claim_t *cose_sign1_wrapper)
+{
+	QCBORDecodeContext context;
+	QCBORItem item;
+	int err;
+
+	QCBORDecode_Init(&context, token, QCBOR_DECODE_MODE_NORMAL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* Check COSE tag. */
+	QCBORDecode_PeekNext(&context, &item);
+	if (!QCBORDecode_IsTagged(&context, &item,
+		TAG_COSE_SIGN1)) {
+		return TOKEN_VERIFICATION_ERR_INVALID_COSE_TAG;
+	}
+
+	QCBORDecode_EnterArray(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* Protected header */
+	err = get_claim(&context, cose_sign1_wrapper);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	/* Unprotected header. The map is always present, but may contain 0
+	 * items.
+	 */
+	QCBORDecode_EnterMap(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+		/* Skip the content for now. */
+
+	QCBORDecode_ExitMap(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* Payload */
+	err = get_claim(&context, cose_sign1_wrapper + 1);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	/* Signature */
+	err = get_claim(&context, cose_sign1_wrapper + 2);
+	if (err != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return err;
+	}
+
+	QCBORDecode_ExitArray(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	*token_payload = cose_sign1_wrapper[1].buffer_data;
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+static int verify_cca_token(struct q_useful_buf_c  token,
+			    struct q_useful_buf_c *platform_token,
+			    struct q_useful_buf_c *realm_token)
+{
+	QCBORDecodeContext context;
+	QCBORItem item;
+	QCBORError err;
+
+	QCBORDecode_Init(&context, token, QCBOR_DECODE_MODE_NORMAL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* ================== Check CCA_TOKEN tag =========================== */
+	QCBORDecode_PeekNext(&context, &item);
+	if (!QCBORDecode_IsTagged(&context, &item, TAG_CCA_TOKEN)) {
+		return TOKEN_VERIFICATION_ERR_INVALID_COSE_TAG;
+	}
+
+	/* ================== Get the the platform token ==================== */
+	QCBORDecode_EnterMap(&context, NULL);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/*
+	 * First element is the CCA platfrom token which is a
+	 * COSE_Sign1_Tagged object. It has byte stream wrapper.
+	 */
+	QCBORDecode_GetByteStringInMapN(&context, CCA_PLAT_TOKEN,
+					platform_token);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* ================== Get the the realm token ======================= */
+	/*
+	 * Second element is the delegated realm token which is a
+	 * COSE_Sign1_Tagged object. It has byte stream wrapper.
+	 */
+	QCBORDecode_GetByteStringInMapN(&context, CCA_REALM_DELEGATED_TOKEN,
+					realm_token);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	QCBORDecode_ExitMap(&context);
+	RETURN_ON_DECODE_ERROR(&context);
+
+	/* Finishing up the decoding of the top-level wrapper */
+	err = QCBORDecode_Finish(&context);
+	if (err != QCBOR_SUCCESS) {
+		printf("QCBOR decode failed with error at %s:%d. err = %d\r\n",
+			__FILE__, (int)__LINE__, (int)err);
+		return TOKEN_VERIFICATION_ERR_QCBOR(err);
+	}
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
+/*
+ * This function expect two COSE_Sing1_Tagged object wrapped with a tagged map:
+ *
+ * cca-token = #6.44234(cca-token-map) ; 44234 = 0xACCA
+ *
+ * cca-platform-token = COSE_Sign1_Tagged
+ * cca-realm-delegated-token = COSE_Sign1_Tagged
+ *
+ * cca-token-map = {
+ *   0 => cca-platform-token
+ *   1 => cca-realm-delegated-token
+ * }
+ *
+ * COSE_Sign1_Tagged = #6.18(COSE_Sign1)
+ */
+int verify_token(const char *token, size_t size,
+		 struct attestation_claims *attest_claims)
+{
+	/* TODO: do signature check */
+	/* TODO: Add tag check on tokens */
+	struct q_useful_buf_c buf = {token, size};
+	int ret;
+	struct q_useful_buf_c realm_token;
+	struct q_useful_buf_c realm_token_payload;
+	struct q_useful_buf_c platform_token;
+	struct q_useful_buf_c platform_token_payload;
+
+	ret = init_claims(attest_claims);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+
+	/* Verify top-level token map and extract the two sub-tokens */
+	ret = verify_cca_token(buf, &platform_token, &realm_token);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+
+	/* Verify the COSE_Sign1 wrapper of the realm token */
+	ret = verify_token_cose_sign1_wrapping(realm_token,
+		&realm_token_payload,
+		attest_claims->realm_cose_sign1_wrapper);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+	/* Verify the payload of the realm token */
+	ret = verify_realm_token(realm_token_payload, attest_claims);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+
+	/* Verify the COSE_Sign1 wrapper of the platform token */
+	ret = verify_token_cose_sign1_wrapping(platform_token,
+		&platform_token_payload,
+		attest_claims->plat_cose_sign1_wrapper);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+	/* Verify the payload of the platform token */
+	ret = verify_platform_token(platform_token_payload, attest_claims);
+	if (ret != TOKEN_VERIFICATION_ERR_SUCCESS) {
+		return ret;
+	}
+
+	return TOKEN_VERIFICATION_ERR_SUCCESS;
+}
+
diff --git a/lib/token_verifier/token_verifier.h b/lib/token_verifier/token_verifier.h
new file mode 100644
index 00000000..ec3ab9c9
--- /dev/null
+++ b/lib/token_verifier/token_verifier.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+
+#ifndef __TOKEN_VERIFIER_H__
+#define __TOKEN_VERIFIER_H__
+
+#include <qcbor/qcbor_decode.h>
+
+#define TOKEN_VERIFICATION_ERR_SUCCESS                 0
+#define TOKEN_VERIFICATION_ERR_INIT_ERROR              1
+#define TOKEN_VERIFICATION_ERR_MISSING_MANDATORY_CLAIM 2
+#define TOKEN_VERIFICATION_ERR_INVALID_COSE_TAG        3
+#define TOKEN_VERIFICATION_ERR_INVALID_CLAIM_LEN       4
+#define TOKEN_VERIFICATION_ERR_INTERNAL_ERROR          5
+#define TOKEN_VERIFICATION_ERR_QCBOR(qcbor_err)        (1000 + qcbor_err)
+
+/* Number of realm extensible measurements (REM) */
+#define REM_COUNT 4
+
+#define MAX_SW_COMPONENT_COUNT 16
+
+#define CLAIM_COUNT_REALM_TOKEN 6
+#define CLAIM_COUNT_COSE_SIGN1_WRAPPER 3
+#define CLAIM_COUNT_PLATFORM_TOKEN 8
+#define CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS REM_COUNT
+#define CLAIM_COUNT_SW_COMPONENT 4
+
+/* This tells how the data should be interpreted in the claim_t struct, and not
+ * necessarily is the same as the item's major type in the token.
+ */
+enum claim_data_type {
+	CLAIM_INT64,
+	CLAIM_BOOL,
+	CLAIM_BSTR,
+	CLAIM_TEXT,
+};
+
+struct claim_t {
+	/* 'static' */
+	bool mandatory;
+	enum claim_data_type type;
+	int64_t key;
+	const char *title;
+
+	/* filled during verification */
+	bool present;
+	union {
+		int64_t int_data;
+		bool bool_data;
+		/* Used for text and bytestream as well */
+		/* TODO: Add expected length check as well? */
+		struct q_useful_buf_c buffer_data;
+	};
+};
+
+struct sw_component_t {
+	bool present;
+	struct claim_t claims[CLAIM_COUNT_SW_COMPONENT];
+};
+
+struct attestation_claims {
+	struct claim_t realm_cose_sign1_wrapper[CLAIM_COUNT_COSE_SIGN1_WRAPPER];
+	struct claim_t realm_token_claims[CLAIM_COUNT_REALM_TOKEN];
+	struct claim_t realm_measurement_claims[CLAIM_COUNT_REALM_EXTENSIBLE_MEASUREMENTS];
+	struct claim_t plat_cose_sign1_wrapper[CLAIM_COUNT_COSE_SIGN1_WRAPPER];
+	struct claim_t plat_token_claims[CLAIM_COUNT_PLATFORM_TOKEN];
+	struct sw_component_t sw_component_claims[MAX_SW_COMPONENT_COUNT];
+};
+
+/* Returns TOKEN_VERIFICATION_ERR* */
+int verify_token(const char *token, size_t size,
+	struct attestation_claims *attest_claims);
+
+#endif /* __TOKEN_VERIFIER_H__ */
-- 
2.34.1


