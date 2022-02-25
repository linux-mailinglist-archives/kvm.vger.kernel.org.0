Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1904C4281
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 11:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbiBYKjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 05:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbiBYKjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 05:39:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25B571B2AF0
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 02:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645785520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ait68bCLPZgU08GUtkMsgL4AE3KFDcmnrVIdep4pyvw=;
        b=gtMiEhf7dBm1sBYjLvg8jPe4huFHlOe8W24/k4ZCX6rtY5bBB1AuZ3sjJcO8lWB6X2T36U
        9oOZOXZlrs+uh7+oaU8bg9bPDiVmKywi92CWpHCv3jOPul/bfrORhaTPrFiPLV7rOUEiMo
        ZGcU2yEwtl4eXUU5a8A8CHHnLMcTvtc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-7gF6m_XaN0CepHs2oHvxdg-1; Fri, 25 Feb 2022 05:38:36 -0500
X-MC-Unique: 7gF6m_XaN0CepHs2oHvxdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71716180FD73;
        Fri, 25 Feb 2022 10:38:33 +0000 (UTC)
Received: from lacos-laptop-7.usersys.redhat.com (unknown [10.39.193.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FD841053B16;
        Fri, 25 Feb 2022 10:37:52 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Cc:     adrian@parity.io, dwmw@amazon.co.uk, graf@amazon.com,
        colmmacc@amazon.com, raduweis@amazon.com, berrange@redhat.com,
        imammedo@redhat.com, ehabkost@redhat.com, ben@skyportsystems.com,
        mst@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        linux@dominikbrodowski.net, ebiggers@kernel.org, ardb@kernel.org,
        jannh@google.com, gregkh@linuxfoundation.org, tytso@mit.edu
References: <20220224133906.751587-1-Jason@zx2c4.com>
 <20220224133906.751587-3-Jason@zx2c4.com>
From:   Laszlo Ersek <lersek@redhat.com>
Message-ID: <aedd310b-4583-37b3-3dde-c00a6d73ee4d@redhat.com>
Date:   Fri, 25 Feb 2022 11:37:51 +0100
MIME-Version: 1.0
In-Reply-To: <20220224133906.751587-3-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/24/22 14:39, Jason A. Donenfeld wrote:
> VM Generation ID is a feature from Microsoft, described at
> <https://go.microsoft.com/fwlink/?LinkId=260709>, and supported by
> Hyper-V and QEMU. Its usage is described in Microsoft's RNG whitepaper,
> <https://aka.ms/win10rng>, as:
> 
>     If the OS is running in a VM, there is a problem that most
>     hypervisors can snapshot the state of the machine and later rewind
>     the VM state to the saved state. This results in the machine running
>     a second time with the exact same RNG state, which leads to serious
>     security problems.  To reduce the window of vulnerability, Windows
>     10 on a Hyper-V VM will detect when the VM state is reset, retrieve
>     a unique (not random) value from the hypervisor, and reseed the root
>     RNG with that unique value.  This does not eliminate the
>     vulnerability, but it greatly reduces the time during which the RNG
>     system will produce the same outputs as it did during a previous
>     instantiation of the same VM state.
> 
> Linux has the same issue, and given that vmgenid is supported already by
> multiple hypervisors, we can implement more or less the same solution.
> So this commit wires up the vmgenid ACPI notification to the RNG's newly
> added add_vmfork_randomness() function.
> 
> It can be used from qemu via the `-device vmgenid,guid=auto` parameter.
> After setting that, use `savevm` in the monitor to save the VM state,
> then quit QEMU, start it again, and use `loadvm`. That will trigger this
> driver's notify function, which hands the new UUID to the RNG. This is
> described in <https://git.qemu.org/?p=qemu.git;a=blob;f=docs/specs/vmgenid.txt>.
> And there are hooks for this in libvirt as well, described in
> <https://libvirt.org/formatdomain.html#general-metadata>.
> 
> Note, however, that the treatment of this as a UUID is considered to be
> an accidental QEMU nuance, per
> <https://github.com/libguestfs/virt-v2v/blob/master/docs/vm-generation-id-across-hypervisors.txt>,
> so this driver simply treats these bytes as an opaque 128-bit binary
> blob, as per the spec. This doesn't really make a difference anyway,
> considering that's how it ends up when handed to the RNG in the end.
> 
> This driver builds on prior work from Adrian Catangiu at Amazon, and it
> is my hope that that team can resume maintenance of this driver.
> 
> Cc: Adrian Catangiu <adrian@parity.io>
> Cc: Laszlo Ersek <lersek@redhat.com>
> Cc: Daniel P. Berrangé <berrange@redhat.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/virt/Kconfig   |   9 +++
>  drivers/virt/Makefile  |   1 +
>  drivers/virt/vmgenid.c | 121 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 131 insertions(+)
>  create mode 100644 drivers/virt/vmgenid.c
> 
> diff --git a/drivers/virt/Kconfig b/drivers/virt/Kconfig
> index 8061e8ef449f..d3276dc2095c 100644
> --- a/drivers/virt/Kconfig
> +++ b/drivers/virt/Kconfig
> @@ -13,6 +13,15 @@ menuconfig VIRT_DRIVERS
>  
>  if VIRT_DRIVERS
>  
> +config VMGENID
> +	tristate "Virtual Machine Generation ID driver"
> +	default y
> +	depends on ACPI
> +	help
> +	  Say Y here to use the hypervisor-provided Virtual Machine Generation ID
> +	  to reseed the RNG when the VM is cloned. This is highly recommended if
> +	  you intend to do any rollback / cloning / snapshotting of VMs.
> +
>  config FSL_HV_MANAGER
>  	tristate "Freescale hypervisor management driver"
>  	depends on FSL_SOC
> diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
> index 3e272ea60cd9..108d0ffcc9aa 100644
> --- a/drivers/virt/Makefile
> +++ b/drivers/virt/Makefile
> @@ -4,6 +4,7 @@
>  #
>  
>  obj-$(CONFIG_FSL_HV_MANAGER)	+= fsl_hypervisor.o
> +obj-$(CONFIG_VMGENID)		+= vmgenid.o
>  obj-y				+= vboxguest/
>  
>  obj-$(CONFIG_NITRO_ENCLAVES)	+= nitro_enclaves/
> diff --git a/drivers/virt/vmgenid.c b/drivers/virt/vmgenid.c
> new file mode 100644
> index 000000000000..5da4dc8f25e3
> --- /dev/null
> +++ b/drivers/virt/vmgenid.c
> @@ -0,0 +1,121 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Virtual Machine Generation ID driver
> + *
> + * Copyright (C) 2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + * Copyright (C) 2020 Amazon. All rights reserved.
> + * Copyright (C) 2018 Red Hat Inc. All rights reserved.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/acpi.h>
> +#include <linux/random.h>
> +
> +ACPI_MODULE_NAME("vmgenid");
> +
> +enum { VMGENID_SIZE = 16 };
> +
> +static struct {
> +	u8 this_id[VMGENID_SIZE];
> +	u8 *next_id;
> +} state;
> +
> +static int vmgenid_acpi_add(struct acpi_device *device)
> +{
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER };
> +	union acpi_object *pss;
> +	phys_addr_t phys_addr;
> +	acpi_status status;
> +	int ret = 0;
> +
> +	if (!device)
> +		return -EINVAL;
> +
> +	status = acpi_evaluate_object(device->handle, "ADDR", NULL, &buffer);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_EXCEPTION((AE_INFO, status, "Evaluating ADDR"));
> +		return -ENODEV;
> +	}
> +	pss = buffer.pointer;
> +	if (!pss || pss->type != ACPI_TYPE_PACKAGE || pss->package.count != 2 ||
> +	    pss->package.elements[0].type != ACPI_TYPE_INTEGER ||
> +	    pss->package.elements[1].type != ACPI_TYPE_INTEGER) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	phys_addr = (pss->package.elements[0].integer.value << 0) |
> +		    (pss->package.elements[1].integer.value << 32);
> +	state.next_id = acpi_os_map_memory(phys_addr, VMGENID_SIZE);
> +	if (!state.next_id) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	device->driver_data = &state;
> +
> +	memcpy(state.this_id, state.next_id, sizeof(state.this_id));
> +	add_device_randomness(state.this_id, sizeof(state.this_id));
> +
> +out:
> +	ACPI_FREE(buffer.pointer);
> +	return ret;
> +}
> +
> +static int vmgenid_acpi_remove(struct acpi_device *device)
> +{
> +	if (!device || acpi_driver_data(device) != &state)
> +		return -EINVAL;
> +	device->driver_data = NULL;
> +	if (state.next_id)
> +		acpi_os_unmap_memory(state.next_id, VMGENID_SIZE);
> +	state.next_id = NULL;
> +	return 0;
> +}
> +
> +static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
> +{
> +	u8 old_id[VMGENID_SIZE];
> +
> +	if (!device || acpi_driver_data(device) != &state)
> +		return;
> +	memcpy(old_id, state.this_id, sizeof(old_id));
> +	memcpy(state.this_id, state.next_id, sizeof(state.this_id));
> +	if (!memcmp(old_id, state.this_id, sizeof(old_id)))
> +		return;
> +	add_vmfork_randomness(state.this_id, sizeof(state.this_id));
> +}
> +
> +static const struct acpi_device_id vmgenid_ids[] = {
> +	{"VMGENID", 0},
> +	{"QEMUVGID", 0},
> +	{ },
> +};
> +
> +static struct acpi_driver acpi_driver = {
> +	.name = "vm_generation_id",
> +	.ids = vmgenid_ids,
> +	.owner = THIS_MODULE,
> +	.ops = {
> +		.add = vmgenid_acpi_add,
> +		.remove = vmgenid_acpi_remove,
> +		.notify = vmgenid_acpi_notify,
> +	}
> +};
> +
> +static int __init vmgenid_init(void)
> +{
> +	return acpi_bus_register_driver(&acpi_driver);
> +}
> +
> +static void __exit vmgenid_exit(void)
> +{
> +	acpi_bus_unregister_driver(&acpi_driver);
> +}
> +
> +module_init(vmgenid_init);
> +module_exit(vmgenid_exit);
> +
> +MODULE_DEVICE_TABLE(acpi, vmgenid_ids);
> +MODULE_DESCRIPTION("Virtual Machine Generation ID");
> +MODULE_LICENSE("GPL v2");
> 

I'm not an experienced reviewer for the kernel.

I've made an effort to check several -- although not all -- aspects of
this patch, and it looks OK to me.

Reviewed-by: Laszlo Ersek <lersek@redhat.com>

Thanks
Laszlo

