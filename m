Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796EA4C13B0
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbiBWNNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240779AbiBWNNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:13:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D5AA9A61;
        Wed, 23 Feb 2022 05:13:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C63FAB81FA1;
        Wed, 23 Feb 2022 13:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8155C340E7;
        Wed, 23 Feb 2022 13:12:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kP/TNLRo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645621979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lgLtq+lfYFesl4+M3nDQfreFYpTzpLlZU30SsFv1B9I=;
        b=kP/TNLRoQCYE16+kAQxyXUKZW27z79tNX+j9khdmnW/pHUrLp5TsQg+Sst5dY0RUvma5Mv
        bQflcE8AP3p/qcnEe0Ytn5tTaN6qKbYLfiX7li7x4NV/wK5zU/k/H2vnZMaPw50Tc8hoNc
        F6CVnKlFZJXSeHIRZPpAohvSylF0vbk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 25ac14b1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 23 Feb 2022 13:12:58 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, adrian@parity.io
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, dwmw@amazon.co.uk,
        acatan@amazon.com, graf@amazon.com, colmmacc@amazon.com,
        sblbir@amazon.com, raduweis@amazon.com, jannh@google.com,
        gregkh@linuxfoundation.org, tytso@mit.edu
Subject: [PATCH RFC v1 2/2] drivers/virt: add vmgenid driver for reinitializing RNG
Date:   Wed, 23 Feb 2022 14:12:31 +0100
Message-Id: <20220223131231.403386-3-Jason@zx2c4.com>
In-Reply-To: <20220223131231.403386-1-Jason@zx2c4.com>
References: <20220223131231.403386-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VM Generation ID is a feature from Microsoft, described at
<https://go.microsoft.com/fwlink/?LinkId=260709>, and supported by
Hyper-V and QEMU. Its usage is described in Microsoft's RNG whitepaper,
<https://aka.ms/win10rng>, as:

    If the OS is running in a VM, there is a problem that most
    hypervisors can snapshot the state of the machine and later rewind
    the VM state to the saved state. This results in the machine running
    a second time with the exact same RNG state, which leads to serious
    security problems.  To reduce the window of vulnerability, Windows
    10 on a Hyper-V VM will detect when the VM state is reset, retrieve
    a unique (not random) value from the hypervisor, and reseed the root
    RNG with that unique value.  This does not eliminate the
    vulnerability, but it greatly reduces the time during which the RNG
    system will produce the same outputs as it did during a previous
    instantiation of the same VM state.

Linux has the same issue, and given that vmgenid is supported already by
multiple hypervisors, we can implement more or less the same solution.
So this commit wires up the vmgenid ACPI notification to the RNG's newly
added add_vmfork_randomness() function.

This driver builds on prior work from Adrian Catangiu at Amazon, and it
is my hope that that team can resume maintenance of this driver.

Cc: Adrian Catangiu <adrian@parity.io>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/virt/Kconfig   |   8 +++
 drivers/virt/Makefile  |   1 +
 drivers/virt/vmgenid.c | 133 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+)
 create mode 100644 drivers/virt/vmgenid.c

diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
index 8061e8ef449f..e7f9c1bca02b 100644
--- a/drivers/virt/Kconfig
+++ b/drivers/virt/Kconfig
@@ -13,6 +13,14 @@ menuconfig VIRT_DRIVERS
 
 if VIRT_DRIVERS
 
+config VMGENID
+	bool "Virtual Machine Generation ID driver"
+	default y
+	depends on ACPI
+	help
+	  Say Y here to use the hypervisor provided Virtual Machine Generation ID
+	  to reseed the RNG when the VM is cloned.
+
 config FSL_HV_MANAGER
 	tristate "Freescale hypervisor management driver"
 	depends on FSL_SOC
diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
index 3e272ea60cd9..108d0ffcc9aa 100644
--- a/drivers/virt/Makefile
+++ b/drivers/virt/Makefile
@@ -4,6 +4,7 @@
 #
 
 obj-$(CONFIG_FSL_HV_MANAGER)	+= fsl_hypervisor.o
+obj-$(CONFIG_VMGENID)		+= vmgenid.o
 obj-y				+= vboxguest/
 
 obj-$(CONFIG_NITRO_ENCLAVES)	+= nitro_enclaves/
diff --git a/drivers/virt/vmgenid.c b/drivers/virt/vmgenid.c
new file mode 100644
index 000000000000..11ed7f668bb1
--- /dev/null
+++ b/drivers/virt/vmgenid.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Virtual Machine Generation ID driver
+ *
+ * Copyright (C) 2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ * Copyright (C) 2020 Amazon. All rights reserved.
+ * Copyright (C) 2018 Red Hat Inc. All rights reserved.
+ */
+
+#define pr_fmt(fmt) "vmgenid: " fmt
+
+#include <linux/acpi.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/uuid.h>
+
+#define DEV_NAME "vmgenid"
+ACPI_MODULE_NAME(DEV_NAME);
+
+static struct {
+	uuid_t uuid;
+	void *uuid_iomap;
+} vmgenid_data;
+
+static int vmgenid_acpi_map(acpi_handle handle)
+{
+	phys_addr_t phys_addr = 0;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	acpi_status status;
+	union acpi_object *pss;
+	union acpi_object *element;
+	int i;
+
+	status = acpi_evaluate_object(handle, "ADDR", NULL, &buffer);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating ADDR"));
+		return -ENODEV;
+	}
+	pss = buffer.pointer;
+	if (!pss || pss->type != ACPI_TYPE_PACKAGE || pss->package.count != 2)
+		return -EINVAL;
+
+	for (i = 0; i < pss->package.count; ++i) {
+		element = &pss->package.elements[i];
+		if (element->type != ACPI_TYPE_INTEGER)
+			return -EINVAL;
+		phys_addr |= element->integer.value << i * 32;
+	}
+
+	vmgenid_data.uuid_iomap = acpi_os_map_memory(phys_addr, sizeof(vmgenid_data.uuid));
+	if (!vmgenid_data.uuid_iomap) {
+		pr_err("failed to map memory at %pa, size %zu\n",
+			&phys_addr, sizeof(vmgenid_data.uuid));
+		return -ENOMEM;
+	}
+
+	memcpy_fromio(&vmgenid_data.uuid, vmgenid_data.uuid_iomap, sizeof(vmgenid_data.uuid));
+
+	return 0;
+}
+
+static int vmgenid_acpi_add(struct acpi_device *device)
+{
+	int ret;
+
+	if (!device)
+		return -EINVAL;
+	ret = vmgenid_acpi_map(device->handle);
+	if (ret < 0) {
+		pr_err("failed to map acpi device: %d\n", ret);
+		return ret;
+	}
+	device->driver_data = &vmgenid_data;
+	add_device_randomness(&vmgenid_data.uuid, sizeof(vmgenid_data.uuid));
+	return 0;
+}
+
+static int vmgenid_acpi_remove(struct acpi_device *device)
+{
+	if (!device || acpi_driver_data(device) != &vmgenid_data)
+		return -EINVAL;
+	device->driver_data = NULL;
+	if (vmgenid_data.uuid_iomap)
+		acpi_os_unmap_memory(vmgenid_data.uuid_iomap, sizeof(vmgenid_data.uuid));
+	vmgenid_data.uuid_iomap = NULL;
+	return 0;
+}
+
+static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
+{
+	uuid_t old_uuid = vmgenid_data.uuid;
+
+	if (!device || acpi_driver_data(device) != &vmgenid_data)
+		return;
+	memcpy_fromio(&vmgenid_data.uuid, vmgenid_data.uuid_iomap, sizeof(vmgenid_data.uuid));
+	if (!memcmp(&old_uuid, &vmgenid_data.uuid, sizeof(vmgenid_data.uuid)))
+		return;
+	add_vmfork_randomness(&vmgenid_data.uuid, sizeof(vmgenid_data.uuid));
+}
+
+static const struct acpi_device_id vmgenid_ids[] = {
+	{"VMGENID", 0},
+	{"QEMUVGID", 0},
+	{"", 0},
+};
+
+static struct acpi_driver acpi_vmgenid_driver = {
+	.name = "vm_generation_id",
+	.ids = vmgenid_ids,
+	.owner = THIS_MODULE,
+	.ops = {
+		.add = vmgenid_acpi_add,
+		.remove = vmgenid_acpi_remove,
+		.notify = vmgenid_acpi_notify,
+	}
+};
+
+static int __init vmgenid_init(void)
+{
+	return acpi_bus_register_driver(&acpi_vmgenid_driver);
+}
+
+static void __exit vmgenid_exit(void)
+{
+	acpi_bus_unregister_driver(&acpi_vmgenid_driver);
+}
+
+module_init(vmgenid_init);
+module_exit(vmgenid_exit);
+
+MODULE_DESCRIPTION("Virtual Machine Generation ID");
+MODULE_LICENSE("GPL");
-- 
2.35.1

