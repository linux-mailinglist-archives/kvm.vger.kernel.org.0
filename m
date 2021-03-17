Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C0C33F751
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCQRoZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 13:44:25 -0400
Received: from foss.arm.com ([217.140.110.172]:40604 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhCQRoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 13:44:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26BEFD6E;
        Wed, 17 Mar 2021 10:44:21 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 137C83F718;
        Wed, 17 Mar 2021 10:44:19 -0700 (PDT)
Subject: Re: [PATCH kvmtool v3 00/22] Unify I/O port and MMIO trap handling
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <72c227a7-5854-2cba-fb98-9606dfe79b7d@arm.com>
Date:   Wed, 17 Mar 2021 17:44:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315153350.19988-1-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will, Julien,

On 3/15/21 3:33 PM, Andre Przywara wrote:
> Hi,
>
> this version is addressing Alexandru's comments, fixing mostly minor
> issues in the naming scheme. The biggest change is to keep the
> ioport__read/ioport_write wrappers for the serial device.
> For more details see the changelog below.
> ==============
>
> At the moment we use two separate code paths to handle exits for
> KVM_EXIT_IO (ioport.c) and KVM_EXIT_MMIO (mmio.c), even though they
> are semantically very similar. Because the trap handler callback routine
> is different, devices need to decide on one conduit or need to provide
> different handler functions for both of them.
>
> This is not only unnecessary code duplication, but makes switching
> devices from I/O port to MMIO a tedious task, even though there is no
> real difference between the two, especially on ARM and PowerPC.
>
> For ARM we aim at providing a flexible memory layout, and also have
> trouble with the UART and RTC device overlapping with the PCI I/O area,
> so it seems indicated to tackle this once and for all.
>
> The first three patches do some cleanup, to simplify things later.
>
> Patch 04/22 lays the groundwork, by extending mmio.c to be able to also
> register I/O port trap handlers, using the same callback prototype as
> we use for MMIO.
>
> The next 14 patches then convert devices that use the I/O port
> interface over to the new joint interface. This requires to rework
> the trap handler routine to adhere to the same prototype as the existing
> MMIO handlers. For most devices this is done in two steps: a first to
> introduce the reworked handler routine, and a second to switch to the new
> joint registration routine. For some devices the first step is trivial,
> so it's done in one patch.
>
> Patch 19/22 then retires the old I/O port interface, by removing ioport.c
> and friends.
> Patch 20/22 uses the opportunity to clean up the memory map description,
> also declares a new region (from 16MB on), where the final two patches
> switch the UART and the RTC device to. They are now registered
> on the MMIO "bus", when running on ARM or arm64. This moves them away
> from the first 64KB, so they are not in the PCI I/O area anymore.

I have reviewed the series and everything looks fine to me and ready to be merged.
I have also ran the following tests:

- On my x86_64 desktop, I ran a guest with --sdl, to exercise the vesa device.

- On a rockpro64, I ran kvm-unit-tests for arm64 and arm (kvmtool was compiled for
arm64); I also ran Linux guests using 4k and 64k pages with and without --force-pci.

- On a Seattle machine, I did PCI passthrough for an Intel 82574L network card and
ran Linux guests using 4k and 64k pages with and without --force-pci.

- On an odroid-c4 (4 x Cortex-A55), I ran Linux guests using 4k, 16k and 64k pages
with and without --force-pci.

With this series merged, everything will be in place to bring back the patch that
adds PCI Express 1.1 support for arm/arm64 [1]. The patch was previously dropped
because the RTC and UART were overlapping with the PCI I/O space and EDK2 doesn't
not understand PCI I/O bus addresses above 64k, but this series fixes that by
moving the addresses of the two devices.

[1] https://www.spinics.net/lists/kvm/msg211304.html

Thanks,
Alex
