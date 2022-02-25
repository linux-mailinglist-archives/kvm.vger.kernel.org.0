Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C17A4C4356
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 12:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbiBYLYy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 06:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240050AbiBYLYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 06:24:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC4222322E;
        Fri, 25 Feb 2022 03:24:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 874336190C;
        Fri, 25 Feb 2022 11:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2617C340F9;
        Fri, 25 Feb 2022 11:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645788257;
        bh=VaOu742RP2LwocmJ1+01sMqse3h6LbgsBGSrCtIR6go=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZZNZ2aZL70TaNtyfu0Ky4f6LUrvdiGgRXrTa443ElHp/neB5aZgF9NU2XaiLY4nGt
         idW2b8I39c1RaLIUipBtHOvkik4yH1sJDjAsopuBrbj5i/C8farejpFP+BraBVM+Iw
         N8iy5P0mXSgQv3puBwVPQf9uZn98qardEZO+HuZGCjew/07/9OIhwSeWRf7MpMRK4T
         5KVX9PbSb2EvGkwcbWZSJfZKtwWmNWwTnsL+F8vgLHj4OpPwtGbu2JK9hDjXBP+Njb
         Add7ER5WXynk2tNJTmjePGA4AEmTIV9wZrf4Bbk+8GHYPUKsBgw2ePqFO1oOe/71B/
         8IaitSZp3A1aw==
Received: by mail-yb1-f169.google.com with SMTP id e140so5181075ybh.9;
        Fri, 25 Feb 2022 03:24:17 -0800 (PST)
X-Gm-Message-State: AOAM530g1xKC6igasW4rP1w3RIeQ0CMkCE9qbQZV+e6a3OXrle4mLyTN
        2Vd/e+aTt01W4eQvy9cKd6PVBVd2V6Splhr/qlA=
X-Google-Smtp-Source: ABdhPJzyFAUvIiZAqOt8HiVgBGCdAtJM1r7J/8UreBhPGyHq4pDRXSw8PE6pk1tdeCiGUzabUotuUODSW972fXPAcz0=
X-Received: by 2002:a25:4214:0:b0:624:6215:4823 with SMTP id
 p20-20020a254214000000b0062462154823mr6653602yba.432.1645788256940; Fri, 25
 Feb 2022 03:24:16 -0800 (PST)
MIME-Version: 1.0
References: <20220224133906.751587-1-Jason@zx2c4.com> <20220224133906.751587-3-Jason@zx2c4.com>
In-Reply-To: <20220224133906.751587-3-Jason@zx2c4.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 25 Feb 2022 12:24:05 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE-2sknZD7o72G-ZARpfm4Q0m+im1pTLuPhPu6TkqKOPQ@mail.gmail.com>
Message-ID: <CAMj1kXE-2sknZD7o72G-ZARpfm4Q0m+im1pTLuPhPu6TkqKOPQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] virt: vmgenid: introduce driver for reinitializing
 RNG on VM fork
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        adrian@parity.io, dwmw@amazon.co.uk,
        Alexander Graf <graf@amazon.com>, colmmacc@amazon.com,
        raduweis@amazon.com, berrange@redhat.com,
        Laszlo Ersek <lersek@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, ben@skyportsystems.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Feb 2022 at 14:39, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> VM Generation ID is a feature from Microsoft, described at
> <https://go.microsoft.com/fwlink/?LinkId=3D260709>, and supported by
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
> It can be used from qemu via the `-device vmgenid,guid=3Dauto` parameter.
> After setting that, use `savevm` in the monitor to save the VM state,
> then quit QEMU, start it again, and use `loadvm`. That will trigger this
> driver's notify function, which hands the new UUID to the RNG. This is
> described in <https://git.qemu.org/?p=3Dqemu.git;a=3Dblob;f=3Ddocs/specs/=
vmgenid.txt>.
> And there are hooks for this in libvirt as well, described in
> <https://libvirt.org/formatdomain.html#general-metadata>.
>
> Note, however, that the treatment of this as a UUID is considered to be
> an accidental QEMU nuance, per
> <https://github.com/libguestfs/virt-v2v/blob/master/docs/vm-generation-id=
-across-hypervisors.txt>,
> so this driver simply treats these bytes as an opaque 128-bit binary
> blob, as per the spec. This doesn't really make a difference anyway,
> considering that's how it ends up when handed to the RNG in the end.
>
> This driver builds on prior work from Adrian Catangiu at Amazon, and it
> is my hope that that team can resume maintenance of this driver.
>
> Cc: Adrian Catangiu <adrian@parity.io>
> Cc: Laszlo Ersek <lersek@redhat.com>
> Cc: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
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

drivers/virt does not have a maintainer and this code needs one.

> @@ -13,6 +13,15 @@ menuconfig VIRT_DRIVERS
>
>  if VIRT_DRIVERS
>
> +config VMGENID
> +       tristate "Virtual Machine Generation ID driver"
> +       default y

Please make this default m - this code can run as a module and the
feature it relies on is discoverable by udev

> +       depends on ACPI
> +       help
> +         Say Y here to use the hypervisor-provided Virtual Machine Gener=
ation ID
> +         to reseed the RNG when the VM is cloned. This is highly recomme=
nded if
> +         you intend to do any rollback / cloning / snapshotting of VMs.
> +
>  config FSL_HV_MANAGER
>         tristate "Freescale hypervisor management driver"
>         depends on FSL_SOC
> diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
> index 3e272ea60cd9..108d0ffcc9aa 100644
> --- a/drivers/virt/Makefile
> +++ b/drivers/virt/Makefile
> @@ -4,6 +4,7 @@
>  #
>
>  obj-$(CONFIG_FSL_HV_MANAGER)   +=3D fsl_hypervisor.o
> +obj-$(CONFIG_VMGENID)          +=3D vmgenid.o
>  obj-y                          +=3D vboxguest/
>
>  obj-$(CONFIG_NITRO_ENCLAVES)   +=3D nitro_enclaves/
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
> + * Copyright (C) 2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights R=
eserved.
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
> +enum { VMGENID_SIZE =3D 16 };
> +
> +static struct {
> +       u8 this_id[VMGENID_SIZE];
> +       u8 *next_id;
> +} state;
> +

This state is singular


> +static int vmgenid_acpi_add(struct acpi_device *device)
> +{

... whereas this may be called for multiple instances of the device.
This likely makes no sense, so it is better to reject it here.

Otherwise, the state should be allocated dynamically.

> +       struct acpi_buffer buffer =3D { ACPI_ALLOCATE_BUFFER };
> +       union acpi_object *pss;
> +       phys_addr_t phys_addr;
> +       acpi_status status;
> +       int ret =3D 0;
> +
> +       if (!device)
> +               return -EINVAL;
> +
> +       status =3D acpi_evaluate_object(device->handle, "ADDR", NULL, &bu=
ffer);
> +       if (ACPI_FAILURE(status)) {
> +               ACPI_EXCEPTION((AE_INFO, status, "Evaluating ADDR"));
> +               return -ENODEV;
> +       }
> +       pss =3D buffer.pointer;
> +       if (!pss || pss->type !=3D ACPI_TYPE_PACKAGE || pss->package.coun=
t !=3D 2 ||
> +           pss->package.elements[0].type !=3D ACPI_TYPE_INTEGER ||
> +           pss->package.elements[1].type !=3D ACPI_TYPE_INTEGER) {
> +               ret =3D -EINVAL;
> +               goto out;
> +       }
> +
> +       phys_addr =3D (pss->package.elements[0].integer.value << 0) |
> +                   (pss->package.elements[1].integer.value << 32);
> +       state.next_id =3D acpi_os_map_memory(phys_addr, VMGENID_SIZE);

No need to use acpi_os_map_memory() here, plain memremap() should be fine.

> +       if (!state.next_id) {
> +               ret =3D -ENOMEM;
> +               goto out;
> +       }
> +       device->driver_data =3D &state;
> +
> +       memcpy(state.this_id, state.next_id, sizeof(state.this_id));
> +       add_device_randomness(state.this_id, sizeof(state.this_id));
> +
> +out:
> +       ACPI_FREE(buffer.pointer);
> +       return ret;
> +}
> +
> +static int vmgenid_acpi_remove(struct acpi_device *device)
> +{
> +       if (!device || acpi_driver_data(device) !=3D &state)
> +               return -EINVAL;
> +       device->driver_data =3D NULL;
> +       if (state.next_id)
> +               acpi_os_unmap_memory(state.next_id, VMGENID_SIZE);

memunmap() here

> +       state.next_id =3D NULL;
> +       return 0;
> +}
> +
> +static void vmgenid_acpi_notify(struct acpi_device *device, u32 event)
> +{
> +       u8 old_id[VMGENID_SIZE];
> +
> +       if (!device || acpi_driver_data(device) !=3D &state)
> +               return;
> +       memcpy(old_id, state.this_id, sizeof(old_id));
> +       memcpy(state.this_id, state.next_id, sizeof(state.this_id));
> +       if (!memcmp(old_id, state.this_id, sizeof(old_id)))
> +               return;

Is this little dance really necessary? I.e., can we just do

add_vmfork_randomness(state.next_id, VMGENID_SIZE)

and be done with it?

And if we cannot, is it ok to just return without some kind of
diagnostic message?

> +       add_vmfork_randomness(state.this_id, sizeof(state.this_id));
> +}
> +
> +static const struct acpi_device_id vmgenid_ids[] =3D {
> +       {"VMGENID", 0},
> +       {"QEMUVGID", 0},
> +       { },
> +};
> +
> +static struct acpi_driver acpi_driver =3D {
> +       .name =3D "vm_generation_id",
> +       .ids =3D vmgenid_ids,
> +       .owner =3D THIS_MODULE,
> +       .ops =3D {
> +               .add =3D vmgenid_acpi_add,
> +               .remove =3D vmgenid_acpi_remove,
> +               .notify =3D vmgenid_acpi_notify,
> +       }
> +};
> +
> +static int __init vmgenid_init(void)
> +{
> +       return acpi_bus_register_driver(&acpi_driver);
> +}
> +
> +static void __exit vmgenid_exit(void)
> +{
> +       acpi_bus_unregister_driver(&acpi_driver);
> +}
> +
> +module_init(vmgenid_init);
> +module_exit(vmgenid_exit);
> +
> +MODULE_DEVICE_TABLE(acpi, vmgenid_ids);
> +MODULE_DESCRIPTION("Virtual Machine Generation ID");
> +MODULE_LICENSE("GPL v2");
> --
> 2.35.1
>
