Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650AB4C44E4
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbiBYMtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238515AbiBYMtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:49:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F6116DAFA;
        Fri, 25 Feb 2022 04:49:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50EED61BAD;
        Fri, 25 Feb 2022 12:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12130C340E7;
        Fri, 25 Feb 2022 12:49:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jdKV1mpJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1645793352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LdPtdUugouca9RsozwqmoQ+bGf9XN+SJeuvutIA1cr4=;
        b=jdKV1mpJW4q3IBJYtCxW+ae+a5bUZRK074ZSTJvMcn72jJcdvIBmiwUnxAqMS4+bl1eg0x
        ReSUMCOqptum/00XCo/Ltsg0dMDxwJNzh5wDv4eFrGvUxLLpgjskZKWR5/s4jZ3IrN0mXX
        eAyEN2sgqceovtPZ44OOExVR8o1P0zc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id da77a47e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 25 Feb 2022 12:49:11 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     adrian@parity.io, ardb@kernel.org, ben@skyportsystems.com,
        berrange@redhat.com, colmmacc@amazon.com, decui@microsoft.com,
        dwmw@amazon.co.uk, ebiggers@kernel.org, ehabkost@redhat.com,
        graf@amazon.com, gregkh@linuxfoundation.org,
        haiyangz@microsoft.com, imammedo@redhat.com, jannh@google.com,
        kys@microsoft.com, lersek@redhat.com, linux@dominikbrodowski.net,
        mst@redhat.com, qemu-devel@nongnu.org, raduweis@amazon.com,
        sthemmin@microsoft.com, tytso@mit.edu, wei.liu@kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v4] virt: vmgenid: introduce driver for reinitializing RNG on VM fork
Date:   Fri, 25 Feb 2022 13:48:48 +0100
Message-Id: <20220225124848.909093-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
References: <CAHmME9pJ3wb=EbUErJrCRC=VYGhFZqj2ar_AkVPsUvAnqGtwwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

It can be used from qemu via the `-device vmgenid,guid=auto` parameter.
After setting that, use `savevm` in the monitor to save the VM state,
then quit QEMU, start it again, and use `loadvm`. That will trigger this
driver's notify function, which hands the new UUID to the RNG. This is
described in <https://git.qemu.org/?p=qemu.git;a=blob;f=docs/specs/vmgenid.txt>.
And there are hooks for this in libvirt as well, described in
<https://libvirt.org/formatdomain.html#general-metadata>.

Note, however, that the treatment of this as a UUID is considered to be
an accidental QEMU nuance, per
<https://github.com/libguestfs/virt-v2v/blob/master/docs/vm-generation-id-across-hypervisors.txt>,
so this driver simply treats these bytes as an opaque 128-bit binary
blob, as per the spec. This doesn't really make a difference anyway,
considering that's how it ends up when handed to the RNG in the end.

Cc: Adrian Catangiu <adrian@parity.io>
Cc: Daniel P. Berrangé <berrange@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v3->v4:
- Add this driver to MAINTAINERS, per Ard's request.
  Note: I didn't really want to do this at first, because I was hoping the
  original Amazon team looking into this last year would step up. But it seems
  like that team has moved on, and anyway I've basically rewritten the driver
  from scratch at this point -- not a single line of the original exists --
  and so I guess I'll maintain it myself. Adding Greg to the CC for his ack on
  this.
- Don't use a static global state in case there are multiple instances.
- Use devm_memremap instead of the acpi internal functions.
- Default to being modular instead of a built-in, as apparently this is
  udev-able.

 MAINTAINERS            |   1 +
 drivers/virt/Kconfig   |   9 ++++
 drivers/virt/Makefile  |   1 +
 drivers/virt/vmgenid.c | 112 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 123 insertions(+)
 create mode 100644 drivers/virt/vmgenid.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 777cd6fa2b3d..a10997e15146 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16211,6 +16211,7 @@ M:	Jason A. Donenfeld <Jason@zx2c4.com>
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/crng/random.git
 S:	Maintained
 F:	drivers/char/random.c
+F:	drivers/virt/vmgenid.c
 
 RAPIDIO SUBSYSTEM
 M:	Matt Porter <mporter@kernel.crashing.org>
diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
index 8061e8ef449f..5596c7313f59 100644
--- a/drivers/virt/Kconfig
+++ b/drivers/virt/Kconfig
@@ -13,6 +13,15 @@ menuconfig VIRT_DRIVERS
 
 if VIRT_DRIVERS
 
+config VMGENID
+	tristate "Virtual Machine Generation ID driver"
+	default m
+	depends on ACPI
+	help
+	  Say Y here to use the hypervisor-provided Virtual Machine Generation ID
+	  to reseed the RNG when the VM is cloned. This is highly recommended if
+	  you intend to do any rollback / cloning / snapshotting of VMs.
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
index 000000000000..e3dd4afb33c6
--- /dev/null
+++ b/drivers/virt/vmgenid.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ *
+ * The "Virtual Machine Generation ID" is exposed via ACPI and changes when a
+ * virtual machine forks or is cloned. This driver exists for shepherding that
+ * information to random.c.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/acpi.h>
+#include <linux/random.h>
+
+ACPI_MODULE_NAME("vmgenid");
+
+enum { VMGENID_SIZE = 16 };
+
+struct vmgenid_state {
+	u8 *next_id;
+	u8 this_id[VMGENID_SIZE];
+};
+
+static int vmgenid_acpi_add(struct acpi_device *device)
+{
+	struct acpi_buffer parsed = { ACPI_ALLOCATE_BUFFER };
+	struct vmgenid_state *state;
+	union acpi_object *obj;
+	phys_addr_t phys_addr;
+	acpi_status status;
+	int ret = 0;
+
+	state = devm_kmalloc(&device->dev, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	status = acpi_evaluate_object(device->handle, "ADDR", NULL, &parsed);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Evaluating ADDR"));
+		return -ENODEV;
+	}
+	obj = parsed.pointer;
+	if (!obj || obj->type != ACPI_TYPE_PACKAGE || obj->package.count != 2 ||
+	    obj->package.elements[0].type != ACPI_TYPE_INTEGER ||
+	    obj->package.elements[1].type != ACPI_TYPE_INTEGER) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	phys_addr = (obj->package.elements[0].integer.value << 0) |
+		    (obj->package.elements[1].integer.value << 32);
+	state->next_id = devm_memremap(&device->dev, phys_addr, VMGENID_SIZE, MEMREMAP_WB);
+	if (!state->next_id) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(state->this_id, state->next_id, sizeof(state->this_id));
+	add_device_randomness(state->this_id, sizeof(state->this_id));
+
+	device->driver_data = state;
+
+out:
+	ACPI_FREE(parsed.pointer);
+	return ret;
+}
+
+static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
+{
+	struct vmgenid_state *state = acpi_driver_data(device);
+	u8 old_id[VMGENID_SIZE];
+
+	memcpy(old_id, state->this_id, sizeof(old_id));
+	memcpy(state->this_id, state->next_id, sizeof(state->this_id));
+	if (!memcmp(old_id, state->this_id, sizeof(old_id)))
+		return;
+	add_vmfork_randomness(state->this_id, sizeof(state->this_id));
+}
+
+static const struct acpi_device_id vmgenid_ids[] = {
+	{ "VMGENID", 0 },
+	{ "QEMUVGID", 0 },
+	{ },
+};
+
+static struct acpi_driver acpi_driver = {
+	.name = "vmgenid",
+	.ids = vmgenid_ids,
+	.owner = THIS_MODULE,
+	.ops = {
+		.add = vmgenid_acpi_add,
+		.notify = vmgenid_acpi_notify,
+	}
+};
+
+static int __init vmgenid_init(void)
+{
+	return acpi_bus_register_driver(&acpi_driver);
+}
+
+static void __exit vmgenid_exit(void)
+{
+	acpi_bus_unregister_driver(&acpi_driver);
+}
+
+module_init(vmgenid_init);
+module_exit(vmgenid_exit);
+
+MODULE_DEVICE_TABLE(acpi, vmgenid_ids);
+MODULE_DESCRIPTION("Virtual Machine Generation ID");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
-- 
2.35.1

