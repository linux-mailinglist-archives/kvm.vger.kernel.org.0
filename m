Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780CB1B62C8
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgDWRzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 13:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgDWRzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 13:55:33 -0400
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D58DF20781
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587664532;
        bh=HzfdttVM9BgXQr/ijSQNIg+ZauLcJdE62a/irg9HQUA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cu4I9nHQfaAgy0rxfE2IlSOes6GxtHhb1TM6KzJAfSoXk3LQVsGKljDgd4Kf2e0Du
         cgTDqQF09l20AZz5QEkMAXbyseU5q3jalMsiN/Hvx3mfkYLe/u9uBIWtbfuu8QqiYD
         SEJ5CeenY+ILfm9KNSCcO8L/iPPsdWYEoz4fb+Bc=
Received: by mail-il1-f178.google.com with SMTP id u189so6445668ilc.4
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 10:55:32 -0700 (PDT)
X-Gm-Message-State: AGi0PuYAVsrsxJDdADrzxT2RCID4Snfa2nIHP4IwPEILOVZqZmDxtOur
        DK3GhVulGihCPvFqH6uBbVxMjeZtbPSZLw+XLkA=
X-Google-Smtp-Source: APiQypL/Z2RoaxQTfyMU8HG6ck8a1KcKtB0U7jGPtMPkv1hfvGb/DzU/DYKwhO+zoay4gzXDiXn1MefQvMTM2uI93Yw=
X-Received: by 2002:a92:405:: with SMTP id 5mr4426510ile.279.1587664532201;
 Thu, 23 Apr 2020 10:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com>
In-Reply-To: <20200423173844.24220-1-andre.przywara@arm.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 23 Apr 2020 19:55:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
Message-ID: <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Apr 2020 at 19:39, Andre Przywara <andre.przywara@arm.com> wrote:
>
> Hi,
>
> an update for the CFI flash emulation, addressing Alex' comments and
> adding direct mapping support.
> The actual code changes to the flash emulation are minimal, mostly this
> is about renaming and cleanups.
> This versions now adds some patches. 1/5 is a required fix, the last
> three patches add mapping support as an extension. See below.
>
> In addition to a branch with this series[1], I also put a git branch with
> all the changes compared to v3[2] as separate patches on the server, please
> have a look if you want to verify against a previous review.
>
> ===============
> The EDK II UEFI firmware implementation requires some storage for the EFI
> variables, which is typically some flash storage.
> Since this is already supported on the EDK II side, and looks like a
> generic standard, this series adds a CFI flash emulation to kvmtool.
>
> Patch 2/5 is the actual emulation code, patch 1/5 is a bug-fix for
> registering MMIO devices, which is needed for this device.
> Patches 3-5 add support for mapping the flash memory into guest, should
> it be in read-array mode. For this to work, patch 3/5 is cherry-picked
> from Alex' PCIe reassignable BAR series, to support removing a memslot
> mapping. Patch 4/5 adds support for read-only mappings, while patch 5/5
> adds or removes the mapping based on the current state.
> I am happy to squash 5/5 into 2/5, if we agree that patch 3/5 should be
> merged either separately or the PCIe series is actually merged before
> this one.
>
> This is one missing piece towards a working UEFI boot with kvmtool on
> ARM guests, the other is to provide writable PCI BARs, which is WIP.
> This series alone already enables UEFI boot, but only with virtio-mmio.
>

Excellent! Thanks for taking the time to implement the r/o memslot for
the flash, it really makes the UEFI firmware much more usable.

I will test this as soon as I get a chance, probably tomorrow.


>
> [1] http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/cfi-flash/v4
> [2] http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/cfi-flash/v3
> git://linux-arm.org/kvmtool.git (branches cfi-flash/v3 and cfi-flash/v4)
>
> Changelog v3 .. v4:
> - Rename file to cfi-flash.c (dash instead of underscore).
> - Unify macro names for states, modes and commands.
> - Enforce one or two chips only.
> - Comment on pow2_size() function.
> - Use more consistent identifier spellings.
> - Assign symbols to status register values.
> - Drop RCR register emulation.
> - Use numerical offsets instead of names for query offsets to match spec.
> - Cleanup error path and reword info message in create_flash_device_file().
> - Add fix to allow non-virtio MMIO device emulations.
> - Support tearing down and adding read-only memslots.
> - Add read-only memslot mapping when in read mode.
>
> Changelog v2 .. v3:
> - Breaking MMIO handling into three separate functions.
> - Assing the flash base address in the memory map, but stay at 32 MB for now.
>   The MMIO area has been moved up to 48 MB, to never overlap with the
>   flash.
> - Impose a limit of 16 MB for the flash size, mostly to fit into the
>   (for now) fixed memory map.
> - Trim flash size down to nearest power-of-2, to match hardware.
> - Announce forced flash size trimming.
> - Rework the CFI query table slightly, to add the addresses as array
>   indicies.
> - Fix error handling when creating the flash device.
> - Fix pow2_size implementation for 0 and 1 as input values.
> - Fix write buffer size handling.
> - Improve some comments.
>
> Changelog v1 .. v2:
> - Add locking for MMIO handling.
> - Fold flash read into handler.
> - Move pow2_size() into generic header.
> - Spell out flash base address.
