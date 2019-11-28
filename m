Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1EAB10CE01
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 18:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfK1RlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 12:41:22 -0500
Received: from foss.arm.com ([217.140.110.172]:39034 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfK1RlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 12:41:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EDC01FB;
        Thu, 28 Nov 2019 09:41:21 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 898F33F6C4;
        Thu, 28 Nov 2019 09:41:20 -0800 (PST)
Date:   Thu, 28 Nov 2019 17:41:15 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        sami.mujawar@arm.com
Subject: Re: [PATCH kvmtool 00/16] Add writable BARs and PCIE 1.1 support
Message-ID: <20191128174115.GA14099@e121166-lin.cambridge.arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 25, 2019 at 10:30:17AM +0000, Alexandru Elisei wrote:
> kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to prevent
> it from trying to reprogram the BARs. Let's make the BARs writable so we
> can get rid of this band-aid.

For the sake of precision, PCI BARs are *always* writable and are indeed
written in eg Linux kernel enumeration code regardless of what DT
firmware property is present - in order to size them.

This series - which is very welcome - allows something different, namely
it allows changing the BARs value from a default address space
configuration aka reassigning BARs in Linux kernel speak.

Thanks,
Lorenzo

> Let's also extend the legacy PCI emulation, which came out in 1992, so we
> can properly emulate the PCI Express version 1.1 protocol, which is
> relatively newer, being published in 2005.
> 
> With these two changes, we are very close to running EDK2 as the firmware
> for the virtual machine; the only thing that is missing is flash emulation
> for storing firmware variables.
> 
> Summary of the patches:
> * Patches 1-12 are fixes or enhancements needed to support reprogramable
>   BARs.
> * Patches 13-15 add support for reprogramable BARs and remove the dt
>   property.
> * Patch 16 adds support for PCIE 1.1.
> 
> Based on the series at [1].
> 
> [1] https://lists.cs.columbia.edu/pipermail/kvmarm/2019-March/034964.html
> 
> Alexandru Elisei (8):
>   Makefile: Use correct objcopy binary when cross-compiling for x86_64
>   Remove pci-shmem device
>   Check that a PCI device's memory size is power of two
>   arm: pci.c: Advertise only PCI bus 0 in the DT
>   virtio/pci: Ignore MMIO and I/O accesses when they are disabled
>   Use independent read/write locks for ioport and mmio
>   virtio/pci: Add support for BAR configuration
>   Add PCI Express 1.1 support
> 
> Julien Thierry (7):
>   ioport: pci: Move port allocations to PCI devices
>   pci: Fix ioport allocation size
>   arm/pci: Fix PCI IO region
>   arm/pci: Do not use first PCI IO space bytes for devices
>   virtio/pci: Make memory and IO BARs independent
>   vfio: Add support for BAR configuration
>   arm/fdt: Remove 'linux,pci-probe-only' property
> 
> Sami Mujawar (1):
>   pci: Fix BAR resource sizing arbitration
> 
>  Makefile                          |   4 +-
>  arm/fdt.c                         |   1 -
>  arm/include/arm-common/kvm-arch.h |   2 +-
>  arm/include/arm-common/pci.h      |   1 +
>  arm/kvm.c                         |   3 +
>  arm/pci.c                         |  28 ++-
>  builtin-run.c                     |   5 -
>  hw/pci-shmem.c                    | 400 ------------------------------
>  hw/vesa.c                         |  21 +-
>  include/kvm/ioport.h              |   4 -
>  include/kvm/pci-shmem.h           |  32 ---
>  include/kvm/pci.h                 |  61 ++++-
>  include/kvm/util.h                |   2 +
>  include/kvm/vesa.h                |   6 +-
>  include/kvm/virtio-pci.h          |   1 +
>  ioport.c                          |  36 +--
>  mmio.c                            |  26 +-
>  pci.c                             |  64 ++++-
>  powerpc/include/kvm/kvm-arch.h    |   2 +-
>  vfio/core.c                       |   6 +-
>  vfio/pci.c                        |  97 +++++++-
>  virtio/pci.c                      | 355 ++++++++++++++++++++------
>  x86/include/kvm/kvm-arch.h        |   2 +-
>  23 files changed, 562 insertions(+), 597 deletions(-)
>  delete mode 100644 hw/pci-shmem.c
>  delete mode 100644 include/kvm/pci-shmem.h
> 
> -- 
> 2.20.1
> 
