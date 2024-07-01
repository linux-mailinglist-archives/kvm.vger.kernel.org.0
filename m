Return-Path: <kvm+bounces-20785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 063B191DBE3
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 11:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28AEF1C22B54
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E54156F21;
	Mon,  1 Jul 2024 09:56:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7CD713E881;
	Mon,  1 Jul 2024 09:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719827774; cv=none; b=FjEZEEljUTqLETcM9vaBGyy4OkqC3dLGeN405odOdy8Pw/swulerOkaMKVrlf6pOEcyPhp5f38E0wfuVt3u1x2CT7q8zCgfpMb6qV2yhfU/wPzu8YZKIQhmrkmXZHAO1DljAkKi10f/IEAKerFMZ/ZUZ6nb6U4CNins1Ug7JTc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719827774; c=relaxed/simple;
	bh=v6JZGNvu7kMnuCr2dGpEvrSScXvHkXPK36he9SfxXTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iVmbMvcgDPdJV5NoJZN1xPBimQVko0R9rj73KeqWPfSxooPJe9CGQ2HDnGEVekWYVz6u80u+JDFMbM+Txwf/CkMUevONHgJS1kCsURMxZGF5AKmcpSlTXsjC55hmEW5oKmqFFbCSZqbtEr66CBHfT1ExOqGxYaI4K4IyVNN0YmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AE81339;
	Mon,  1 Jul 2024 02:56:37 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.44.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 935543F762;
	Mon,  1 Jul 2024 02:56:09 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v4 15/15] virt: arm-cca-guest: TSM_REPORT support for realms
Date: Mon,  1 Jul 2024 10:55:05 +0100
Message-Id: <20240701095505.165383-16-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240701095505.165383-1-steven.price@arm.com>
References: <20240701095505.165383-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sami Mujawar <sami.mujawar@arm.com>

Introduce an arm-cca-guest driver that registers with
the configfs-tsm module to provide user interfaces for
retrieving an attestation token.

When a new report is requested the arm-cca-guest driver
invokes the appropriate RSI interfaces to query an
attestation token.

The steps to retrieve an attestation token are as follows:
  1. Mount the configfs filesystem if not already mounted
     mount -t configfs none /sys/kernel/config
  2. Generate an attestation token
     report=/sys/kernel/config/tsm/report/report0
     mkdir $report
     dd if=/dev/urandom bs=64 count=1 > $report/inblob
     hexdump -C $report/outblob
     rmdir $report

Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
v3: Minor improvements to comments and adapt to the renaming of
GRANULE_SIZE to RSI_GRANULE_SIZE.
---
 drivers/virt/coco/Kconfig                     |   2 +
 drivers/virt/coco/Makefile                    |   1 +
 drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
 drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
 .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
 5 files changed, 227 insertions(+)
 create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
 create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
 create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c

diff --git a/drivers/virt/coco/Kconfig b/drivers/virt/coco/Kconfig
index 87d142c1f932..4fb69804b622 100644
--- a/drivers/virt/coco/Kconfig
+++ b/drivers/virt/coco/Kconfig
@@ -12,3 +12,5 @@ source "drivers/virt/coco/efi_secret/Kconfig"
 source "drivers/virt/coco/sev-guest/Kconfig"
 
 source "drivers/virt/coco/tdx-guest/Kconfig"
+
+source "drivers/virt/coco/arm-cca-guest/Kconfig"
diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
index 18c1aba5edb7..a6228a1bf992 100644
--- a/drivers/virt/coco/Makefile
+++ b/drivers/virt/coco/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_TSM_REPORTS)	+= tsm.o
 obj-$(CONFIG_EFI_SECRET)	+= efi_secret/
 obj-$(CONFIG_SEV_GUEST)		+= sev-guest/
 obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx-guest/
+obj-$(CONFIG_ARM_CCA_GUEST)	+= arm-cca-guest/
diff --git a/drivers/virt/coco/arm-cca-guest/Kconfig b/drivers/virt/coco/arm-cca-guest/Kconfig
new file mode 100644
index 000000000000..9dd27c3ee215
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-guest/Kconfig
@@ -0,0 +1,11 @@
+config ARM_CCA_GUEST
+	tristate "Arm CCA Guest driver"
+	depends on ARM64
+	default m
+	select TSM_REPORTS
+	help
+	  The driver provides userspace interface to request and
+	  attestation report from the Realm Management Monitor(RMM).
+
+	  If you choose 'M' here, this module will be called
+	  arm-cca-guest.
diff --git a/drivers/virt/coco/arm-cca-guest/Makefile b/drivers/virt/coco/arm-cca-guest/Makefile
new file mode 100644
index 000000000000..69eeba08e98a
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-guest/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_ARM_CCA_GUEST) += arm-cca-guest.o
diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c b/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
new file mode 100644
index 000000000000..61172730cb90
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/cc_platform.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/smp.h>
+#include <linux/tsm.h>
+#include <linux/types.h>
+
+#include <asm/rsi.h>
+
+/**
+ * struct arm_cca_token_info - a descriptor for the token buffer.
+ * @granule:	PA of the page to which the token will be written
+ * @offset:	Offset within granule to start of buffer in bytes
+ * @len:	Number of bytes of token data that was retrieved
+ * @result:	result of rsi_attestation_token_continue operation
+ */
+struct arm_cca_token_info {
+	phys_addr_t     granule;
+	unsigned long   offset;
+	int             result;
+};
+
+/**
+ * arm_cca_attestation_continue - Retrieve the attestation token data.
+ *
+ * @param: pointer to the arm_cca_token_info
+ *
+ * Attestation token generation is a long running operation and therefore
+ * the token data may not be retrieved in a single call. Moreover, the
+ * token retrieval operation must be requested on the same CPU on which the
+ * attestation token generation was initialised.
+ * This helper function is therefore scheduled on the same CPU multiple
+ * times until the entire token data is retrieved.
+ */
+static void arm_cca_attestation_continue(void *param)
+{
+	unsigned long len;
+	unsigned long size;
+	struct arm_cca_token_info *info;
+
+	if (!param)
+		return;
+
+	info = (struct arm_cca_token_info *)param;
+
+	size = RSI_GRANULE_SIZE - info->offset;
+	info->result = rsi_attestation_token_continue(info->granule,
+						      info->offset, size, &len);
+	info->offset += len;
+}
+
+/**
+ * arm_cca_report_new - Generate a new attestation token.
+ *
+ * @report: pointer to the TSM report context information.
+ * @data:  pointer to the context specific data for this module.
+ *
+ * Initialise the attestation token generation using the challenge data
+ * passed in the TSM decriptor. Allocate memory for the attestation token
+ * and schedule calls to retrieve the attestation token on the same CPU
+ * on which the attestation token generation was initialised.
+ *
+ * The challenge data must be at least 32 bytes and no more than 64 bytes. If
+ * less than 64 bytes are provided it will be zero padded to 64 bytes.
+ *
+ * Return:
+ * * %0        - Attestation token generated successfully.
+ * * %-EINVAL  - A parameter was not valid.
+ * * %-ENOMEM  - Out of memory.
+ * * %-EFAULT  - Failed to get IPA for memory page(s).
+ * * A negative status code as returned by smp_call_function_single().
+ */
+static int arm_cca_report_new(struct tsm_report *report, void *data)
+{
+	int ret;
+	int cpu;
+	long max_size;
+	unsigned long token_size;
+	struct arm_cca_token_info info;
+	void *buf;
+	u8 *token __free(kvfree) = NULL;
+	struct tsm_desc *desc = &report->desc;
+
+	if (!report)
+		return -EINVAL;
+
+	if (desc->inblob_len < 32 || desc->inblob_len > 64)
+		return -EINVAL;
+
+	/*
+	 * Get a CPU on which the attestation token generation will be
+	 * scheduled and initialise the attestation token generation.
+	 */
+	cpu = get_cpu();
+	max_size = rsi_attestation_token_init(desc->inblob, desc->inblob_len);
+	put_cpu();
+
+	if (max_size <= 0)
+		return -EINVAL;
+
+	/* Allocate outblob */
+	token = kvzalloc(max_size, GFP_KERNEL);
+	if (!token)
+		return -ENOMEM;
+
+	/*
+	 * Since the outblob may not be physically contiguous, use a page
+	 * to bounce the buffer from RMM.
+	 */
+	buf = alloc_pages_exact(RSI_GRANULE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* Get the PA of the memory page(s) that were allocated. */
+	info.granule = (unsigned long)virt_to_phys(buf);
+
+	token_size = 0;
+	/* Loop until the token is ready or there is an error. */
+	do {
+		/* Retrieve one RSI_GRANULE_SIZE data per loop iteration. */
+		info.offset = 0;
+		do {
+			/*
+			 * Schedule a call to retrieve a sub-granule chunk
+			 * of data per loop iteration.
+			 */
+			ret = smp_call_function_single(cpu,
+						       arm_cca_attestation_continue,
+						       (void *)&info, true);
+			if (ret != 0) {
+				token_size = 0;
+				goto exit_free_granule_page;
+			}
+
+			ret = info.result;
+		} while ((ret == RSI_INCOMPLETE) &&
+			 (info.offset < RSI_GRANULE_SIZE));
+
+		/*
+		 * Copy the retrieved token data from the granule
+		 * to the token buffer, ensuring that the RMM doesn't
+		 * overflow the buffer.
+		 */
+		if (WARN_ON(token_size + info.offset > max_size))
+			break;
+		memcpy(&token[token_size], buf, info.offset);
+		token_size += info.offset;
+	} while (ret == RSI_INCOMPLETE);
+
+	if (ret != RSI_SUCCESS) {
+		ret = -ENXIO;
+		token_size = 0;
+		goto exit_free_granule_page;
+	}
+
+	report->outblob = no_free_ptr(token);
+exit_free_granule_page:
+	report->outblob_len = token_size;
+	free_pages_exact(buf, RSI_GRANULE_SIZE);
+	return ret;
+}
+
+static const struct tsm_ops arm_cca_tsm_ops = {
+	.name = KBUILD_MODNAME,
+	.report_new = arm_cca_report_new,
+};
+
+/**
+ * arm_cca_guest_init - Register with the Trusted Security Module (TSM)
+ * interface.
+ *
+ * Return:
+ * * %0        - Registered successfully with the TSM interface.
+ * * %-ENODEV  - The execution context is not an Arm Realm.
+ * * %-EINVAL  - A parameter was not valid.
+ * * %-EBUSY   - Already registered.
+ */
+static int __init arm_cca_guest_init(void)
+{
+	int ret;
+
+	if (!is_realm_world())
+		return -ENODEV;
+
+	ret = tsm_register(&arm_cca_tsm_ops, NULL, &tsm_report_default_type);
+	if (ret < 0)
+		pr_err("Failed to register with TSM.\n");
+
+	return ret;
+}
+module_init(arm_cca_guest_init);
+
+/**
+ * arm_cca_guest_exit - unregister with the Trusted Security Module (TSM)
+ * interface.
+ */
+static void __exit arm_cca_guest_exit(void)
+{
+	tsm_unregister(&arm_cca_tsm_ops);
+}
+module_exit(arm_cca_guest_exit);
+
+MODULE_AUTHOR("Sami Mujawar <sami.mujawar@arm.com>");
+MODULE_DESCRIPTION("Arm CCA Guest TSM Driver.");
+MODULE_LICENSE("GPL");
-- 
2.34.1


