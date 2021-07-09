Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332183C22FD
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 13:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhGILlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 07:41:14 -0400
Received: from foss.arm.com ([217.140.110.172]:50862 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230024AbhGILlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 07:41:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECE34ED1;
        Fri,  9 Jul 2021 04:38:29 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 577B53F5A1;
        Fri,  9 Jul 2021 04:38:28 -0700 (PDT)
Date:   Fri, 9 Jul 2021 12:37:49 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Wei Chen <Wei.Chen@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "will@kernel.org" <will@kernel.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Julien Grall <julien@xen.org>, Marc Zyngier <maz@kernel.org>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>
Subject: Re: [Kvmtool] Some thoughts on using kvmtool Virtio for Xen
Message-ID: <20210709123749.1aaa5bfe@slackpad.fritz.box>
In-Reply-To: <DB9PR08MB6857B375207376D8320AFBA89E309@DB9PR08MB6857.eurprd08.prod.outlook.com>
References: <DB9PR08MB6857B375207376D8320AFBA89E309@DB9PR08MB6857.eurprd08.prod.outlook.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Jun 2021 07:12:08 +0100
Wei Chen <Wei.Chen@arm.com> wrote:

Hi Wei,

> I have some thoughts of using kvmtool Virtio implementation
> for Xen. I copied my markdown file to this email. If you have
> time, could you please help me review it?
> 
> Any feedback is welcome!
> 
> # Some thoughts on using kvmtool Virtio for Xen
> ## Background
> 
> Xen community is working on adding VIRTIO capability to Xen. And we're working
> on VIRTIO backend of Xen. But except QEMU can support virtio-net for x86-xen,
> there is not any VIRTIO backend can support Xen. Because of the community's
> strong voice of Out-of-QEMU, we want to find a light weight VIRTIO backend to
> support Xen.
> 
> We have an idea of utilizing the virtio implementaton of kvmtool for Xen. And
> We know there was some agreement that kvmtool won't try to be a full QEMU
> alternative. So we have written two proposals in following content for
> communities to discuss in public:
> 
> ## Proposals
> ### 1. Introduce a new "dm-only" command
> 1. Introduce a new "dm-only" command to provide a pure device model mode. In
>    this mode, kvmtool only handles IO request. VM creation and initialization
>    will be bypassed.
> 
>     * We will rework the interface between the virtio code and the rest of
>     kvmtool, to use just the minimal set of information. At the end, there
>     would be MMIO accesses and shared memory that control the device model,
>     so that could be abstracted to do away with any KVM specifics at all. If
>     this is workable, we will send the first set of patches to introduce this
>     interface, and adapt the existing kvmtool to it. Then later we will can
>     add Xen support on top of it.
> 
>     About Xen support, we will detect the presence of Xen libraries, also
>     allow people to ignore them, as kvmtoll do with optional features like
>     libz or libaio.
> 
>     Idealy, we want to move all code replying on Xen libraries to a set of
>     new files. In this case, thes files can only be compiled when Xen
>     libraries are detected. But if we can't decouple this code completely,
>     we may introduce a bit of #ifdefs to protect this code.
> 
>     If kvm or other VMM do not need "dm-only" mode. Or "dm-only" can not
>     work without Xen libraries. We will make "dm-only" command depends on
>     the presence of Xen libraries.
> 
>     So a normal compile (without the Xen libraries installed) would create
>     a binary as close as possible to the current code, and only the people
>     who having Xen libraries installed would ever generate a "dm-only"
>     capable kvmtool.

This is not for me to decide, but just to let you know that this
approach might not be very popular with kvmtool people, as kvmtool's
design goal is be "lean and mean". So slapping a lot of code on the
side, not helping with the actual KVM functionality, does not sound too
tempting.

> 
> ### 2. Abstract kvmtool virtio implementation as a library
> 1. Add a kvmtool Makefile target to generate a virtio library. In this
>    scenario, not just Xen, but any project else want to provide a
>    userspace virtio backend service can link to this virtio libraris.
>    These users would benefit from the VIRTIO implementation of kvmtool
>    and will participate in improvements, upgrades, and maintenance of
>    the VIRTIO libraries.
> 
>     * In this case, Xen part code will not upstream to kvmtool repo,
>       it would then be natural parts of the xen repo, in xen/tools or
>       maintained in other repo.
> 
>       We will have a completely separate VIRTIO backend for Xen, just
>       linking to kvmtool's VIRTIO library.
> 
>     * The main changes of kvmtool would be:
>         1. Still need to rework the interface between the virtio code
>            and the rest of kvmtool, to abstract the whole virtio
>            implementation into a library
>         2. Modify current build system to add a new virtio library target.

As this has at least the prospect of being cleaner, this approach
sounds better to me.

> 
> ## Reworking the interface is the common work for above proposals
> **In kvmtool, one virtual device can be separated into three layers:**
> 
> - A device type layer to provide an abstract
>     - Provide interface to collect and store device configuration.
>         Using block device as an example, kvmtool is using disk_image to
>         -  collect and store disk parameters like:
>             -  backend image format: raw, qcow or block device
>             -  backend block device or file image path
>             -  Readonly, direct and etc
>     - Provide operations to interact with real backend devices or services:
>         - provide backend device operations:
>             - block device operations
>             - raw image operations
>             - qcow image operations

So I was wondering if the device backend would come as part of the
library package? At the end of the day this mostly POSIX code to access
some files.
Or did you plan to terminate the library interface at the block access
level (read/write device x sector y), and have the actual storage
backends (raw, qcow, block device, you-name-it) in the Xen parts? What
would Xen need here, on top of what kvmtool already offers?

And that brings up the question of portability: At the moment kvmtool is
Linux only (naturally), but IIUC Xen Dom0s also run in *BSD,
potentially even other OSes? That might not be a showstopper, but the
kvmtool code might contain some Linux-isms (libaio?), which would need
to be abstracted first.


I haven't looked at the details down the line, but I guess we should
agree on the general feasibility first.

Cheers,
Andre

> - Hypervisor interfaces
>     - Guest memory mapping and unmapping interfaces
>     - Virtual device register interface
>         - MMIO/PIO space register
>         - IRQ register
>     - Virtual IRQ inject interface
>     - Hypervisor eventfd interface
> - An implementation layer to handle guest IO request.
>     - Kvmtool provides virtual devices for guest. Some virtual devices two
>       kinds of implementations:
>         - VIRTIO implementation
>         - Real hardware emulation
> 
> For example, kvmtool console has virtio console and 8250 serial two kinds
> of implementations. These implementation depends on device type parameters
> to create devices, and depends on device type ops to forward data from/to
> real device. And the implementation will invoke hypervisor interfaces to
> map/unmap resources and notify guest.
> 
> In the current kvmtool code, the boundaries between these three layers are
> relatively clear, but there are a few pieces of code that are somewhat
> interleaved, for example:
> - In virtio_blk__init(...) function, the code will use disk_image directly.
>   This data is kvmtool specified. If we want to make VIRTIO implementation
>   become hypervisor agnostic. Such kind of code should be moved to other
>   place. Or we just keep code from virtio_blk__init_one(...) in virtio block
>   implementation, but keep virtio_blk__init(...) in kvmtool specified part
>   code.
> 
> However, in the current VIRTIO device creation and data handling process,
> the device type and hypervisor API used are both exclusive to kvmtool and
> KVM. If we want to use current VIRTIO implementation for other device
> models and hypervisors, it is unlikely to work properly.
> 
> So, the major work of reworking interface is decoupling VIRTIO implementation
> from kvmtool and KVM.
> 
> **Introduce some intermediate data structures to do decouple:**
> 1. Introduce intermedidate type data structures like `virtio_disk_type`,
>    `virtio_net_type`, `virtio_console_type` and etc. These data structures
>    will be the standard device type interfaces between virtio device
>    implementation and hypervisor.  Using virtio_disk_type as an example:
>     ~~~~
>     struct virtio_disk_type {
>         /*
>          * Essential configuration for virtio block device can be got from
>          * kvmtool disk_image. Other hypervisor device model also can use
>          * this data structure to pass necessary parameters for creating
>          * a virtio block device.
>          */
>         struct virtio_blk_cfg vblk_cfg;
>         /*
>          * Virtio block device MMIO address and IRQ line. These two members
>          * are optional. If hypervisor provides allocate_mmio_space and
>          * allocate_irq_line capability and device model doesn't set these
>          * two fields, virtio block implementation will use hypervisor APIs
>          * to allocate MMIO address and IRQ line. If these two fields are
>          * configured, virtio block implementation will use them.
>          */
>         paddr_t addr;
>         uint32_t irq;
>         /*
>          * In kvmtool, this ops will connect to disk_image APIs. Other
>          * hypervisor device model should provide similar APIs for this
>          * ops to interact with real backend device.
>          */
>         struct disk_type_ops {
>             .read
>             .write
>             .flush
>             .wait
>             ...
>         } ops;
>     };
>     ~~~~
> 
> 2. Introduce a intermediate hypervisor data structure. This data structure
>    provides a set of standard hypervisor API interfaces. In virtio
>    implementation, the KVM specified APIs, like kvm_register_mmio, will not
>    be invoked directly. The virtio implementation will use these interfaces
>    to access hypervisor specified APIs. for example `struct vmm_impl`:
>     ~~~~
>     struct vmm_impl {
>         /*
>          * Pointer that link to real hypervisor handle like `struct kvm *kvm`.
>          * This pointer will be passed to the vmm ops;
>          */
>         void *vmm;
>         allocate_irq_line_fn_t(void* vmm, ...);
>         allocate_mmio_space_fn_t(void* vmm, ...);
>         register_mmio_fn_t(void* vmm, ...);
>         map_guest_page_fn_t(void* vmm, ...);
>         unmap_guest_page_fn_t(void* vmm, ...);
>         virtual_irq_inject_fn_t(void* vmm, ...);
>     };
>     ~~~~
> 
> 3. After decoupled with kvmtool, any hypervisor can use standard `vmm_impl`
>    and `virtio_xxxx_type` interfaces to invoke standard virtio implementation
>    interfaces to create virtio devices.
>     ~~~~
>     /* Prepare VMM interface */
>     struct vmm_impl *vmm = ...;
>     vmm->register_mmio_fn_t = kvm__register_mmio;
>     /* kvm__map_guset_page is a wrapper guest_flat_to_host */
>     vmm->map_guest_page_fn_t = kvm__map_guset_page;
>     ...
> 
>     /* Prepare virtio_disk_type */
>     struct virtio_disk_type *vdisk_type = ...;
>     vdisk_type->vblk_cfg.capacity = disk_image->size / SECTOR_SIZE;
>     ...
>     vdisk_type->ops->read = disk_image__read;
>     vdisk_type->ops->write = disk_image__write;
>     ...
> 
>     /* Invoke VIRTIO implementation API to create a virtio block device */
>     virtio_blk__init_one(vmm, vdisk_type);
>     ~~~~
> 
> VIRTIO block device simple flow before reworking interface:
> https://drive.google.com/file/d/1k0Grd4RSuCmhKUPktHj9FRamEYrPCFkX/view?usp=sharing
> ![image](https://drive.google.com/uc?export=view&id=1k0Grd4RSuCmhKUPktHj9FRamEYrPCFkX)
> 
> VIRTIO block device simple flow after reworking interface:
> https://drive.google.com/file/d/1rMXRvulwlRO39juWf08Wgk3G1NZtG2nL/view?usp=sharing
> ![image](https://drive.google.com/uc?export=view&id=1rMXRvulwlRO39juWf08Wgk3G1NZtG2nL)
> 
> 
> Thanks,
> Wei Chen

