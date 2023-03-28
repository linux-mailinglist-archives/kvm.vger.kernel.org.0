Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566D06CBA00
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 11:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjC1JDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 05:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjC1JD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 05:03:28 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30A1459DF
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 02:03:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 313F0C14;
        Tue, 28 Mar 2023 02:04:10 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D20053F73F;
        Tue, 28 Mar 2023 02:03:24 -0700 (PDT)
Date:   Tue, 28 Mar 2023 10:03:14 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, ricarkol@google.com
Subject: Re: [PATCH v4 30/30] arm64: Add an efi/run script
Message-ID: <ZCKtUvJbSTLcerCc@monolith.localdoman>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-31-nikos.nikoleris@arm.com>
 <20230321184158.phwwbsk5mv7qwhpa@orel>
 <07119162-55c9-cf86-ce55-651496dabb00@arm.com>
 <20230322112455.got7oypemataep2c@orel>
 <31ac48f6-c8d9-edb1-d013-551489a34740@arm.com>
 <20230322123213.xqddob4isz7ipwor@orel>
 <44df7485-7758-3f8f-1949-845ac4a89b38@arm.com>
 <20230323175256.bjd4p7apnuyzynpg@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323175256.bjd4p7apnuyzynpg@orel>
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Just a thought, but if the page allocator is giving you trouble, you could
try using the physical allocator instead, like I tried to do in my cache
maintenance series [1] (requires this patch [2] to change how the idmap is
allocated, to use pgd_alloc() instead of page_alloc()).

That patch also moves the point where the MMU is enabled to earlier in the
boot process, which might be too invasive for this series. In theory, it
shouldn't cause any problems, but that's just in theory.

[1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/commit/3385347b8157d72ea1f2b83afe0026305d89a9ea
[2] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/commit/6faa52530b6a1c150dca4bb7e7caae6c70b162ee

Thanks,
Alex

On Thu, Mar 23, 2023 at 06:52:56PM +0100, Andrew Jones wrote:
> On Wed, Mar 22, 2023 at 07:09:23PM +0000, Nikos Nikoleris wrote:
> > On 22/03/2023 12:32, Andrew Jones wrote:
> > > On Wed, Mar 22, 2023 at 11:57:17AM +0000, Nikos Nikoleris wrote:
> > > > On 22/03/2023 11:24, Andrew Jones wrote:
> > > > > On Wed, Mar 22, 2023 at 10:02:35AM +0000, Nikos Nikoleris wrote:
> > > > > > Hi Drew,
> > > > > > 
> > > > > > On 21/03/2023 18:41, Andrew Jones wrote:
> > > > > > > On Mon, Feb 13, 2023 at 10:17:59AM +0000, Nikos Nikoleris wrote:
> > > > > > > > This change adds a efi/run script inspired by the one in x86. This
> > > > > > > > script will setup a folder with the test compiled as an EFI app and a
> > > > > > > > startup.nsh script. The script launches QEMU providing an image with
> > > > > > > > EDKII and the path to the folder with the test which is executed
> > > > > > > > automatically.
> > > > > > > > 
> > > > > > > > For example:
> > > > > > > > 
> > > > > > > > $> ./arm/efi/run ./arm/selftest.efi setup smp=2 mem=256
> > > > > > > 
> > > > > > > This should be
> > > > > > > 
> > > > > > > ./arm/efi/run ./arm/selftest.efi -append "setup smp=2 mem=256" -smp 2 -m 256
> > > > > > > 
> > > > > > 
> > > > > > Indeed, I will update the commit message.
> > > > > > 
> > > > > > > but I can't get any tests to run through ./arm/efi/run. All of them
> > > > > > > immediately die with a DABT_EL1. I can get the tests to run (and pass) by
> > > > > > > manually booting into UEFI with the FAT partition pointing at the parent
> > > > > > > directory
> > > > > > > 
> > > > > > 
> > > > > > I suppose the DABT_EL1 is happening after the test has started and not while
> > > > > > the UEFI interactive shell starts?
> > > > > 
> > > > > The countdown completes and the startup script runs (I can add an echo to
> > > > > check it). So it must be the test that fails.
> > > > > 
> > > > > > 
> > > > > > >     $QEMU -nodefaults -machine virt -accel tcg -cpu cortex-a57 \
> > > > > > >           -device pci-testdev -display none -serial stdio \
> > > > > > >           -bios /usr/share/edk2/aarch64/QEMU_EFI.silent.fd \
> > > > > > >           -drive file.dir=efi-tests/,file.driver=vvfat,file.rw=on,format=raw,if=virtio
> > > > > > > 
> > > > > > 
> > > > > > Do you hit the DABT_EL1 if you let it automatically start using the
> > > > > > startup.nsh prepared by the ./arm/efi/run script? Meaning change the above
> > > > > > command if you provided -drive file.dir=efi-tests/timer instead:
> > > > > > 
> > > > > >    $QEMU -nodefaults -machine virt -accel tcg -cpu cortex-a57 \
> > > > > >          -device pci-testdev -display none -serial stdio \
> > > > > >          -bios /usr/share/edk2/aarch64/QEMU_EFI.silent.fd \
> > > > > >          -drive file.dir=efi
> > > > > > tests/timer,file.driver=vvfat,file.rw=on,format=raw,if=virtio
> > > > > 
> > > > > Yes, this is what ./arm/efi/run does, and it doesn't help to use the
> > > > > command line directly.
> > > > > 
> > > > > > 
> > > > > > Thanks for reviewing this!
> > > > > > 
> > > > > > Nikos
> > > > > > 
> > > > > > > and then, for example for the timer test, doing
> > > > > > > 
> > > > > > >     fs0:
> > > > > > >     cd timer
> > > > > > >     timer.efi
> > > > > 
> > > > > This actually doesn't work. I was actually doing
> > > > > 
> > > > >    fs0:
> > > > >    cd timer
> > > > >    ls
> > > > >    timer.efi
> > > > > 
> > > > > and, believe it or not, without the 'ls' I get the dabt, with the 'ls' the
> > > > > test runs and passes. Adding an 'ls' to the startup script doesn't help
> > > > > the automatic execution though.
> > > > > 
> > > > > Which versions of QEMU and edk2 are you using? And what file system do you
> > > > > have the efi-tests directory on?
> > > > > 
> > > > 
> > > > I am using the QEMU_EFI.fd image that comes with Ubuntu 20.04.6
> > > > (0~20191122.bd85bf54-2ubuntu3.4)
> > > > https://packages.ubuntu.com/focal-updates/qemu-efi-aarch64
> > > > 
> > > > and I've tried two different versions of QEMU
> > > > 
> > > > $> qemu-system-aarch64 --version
> > > > 
> > > > QEMU emulator version 4.2.1 (Debian 1:4.2-3ubuntu6.24)
> > > > Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
> > > > 
> > > > $> ../qemu/build/qemu-system-aarch64 --version
> > > > QEMU emulator version 7.0.0 (v7.0.0-dirty)
> > > > Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
> > > > 
> > > > efi-tests is on ext4
> > > > 
> > > > I am happy to have a closer look if you help me reproduce your environment.
> > > 
> > > I'm on Fedora 36 and the file system used for this is XFS. My QEMU version
> > > was something pretty recent, but I didn't remember what, so I just updated
> > > to latest master (which happens to be the same as v8.0.0-rc1 right now).
> > > My edk2 is the one packaged with F36,
> > > edk2-aarch64-20221117gitfff6d81270b5-14.fc36.noarch
> > > 
> > > The QEMU update to v8.0.0-rc1 didn't change anything for me (still same
> > > failure and still same "fix" of running the test manually after doing
> > > a manual 'ls').
> > > 
> > 
> > Thanks Drew!
> > 
> > I managed to hit the DABT_EL1 when I switched to the F36 edk2. The problem
> > seems to be with the initialization of the page allocation mechanism.
> > mmu_idmap is allocated at 0x80000000 and phys_alloc_show() prints
> > 
> > phys_alloc minimum alignment: 0x40
> > 0000000048000000-000000007c590fff [USED]
> > 000000007c591000-000000007c590fff [FREE]
> > 
> > Am I wrong to expect that the address that page_alloc() returns for
> > mmu_idmap should be within the [USED] range?
> 
> You're not wrong. That's what I would expect as well from the sequence
> of allocator initializations and allocations, and that's indeed how it
> works for the non-uefi case.
> 
> > 
> > I'll have a closer look into this but I just wanted to check as I am not
> > sure I fully understand the code/logic of lib/alloc_page.{c,h}
> 
> I'll also try to find time to take a look. TBH, I never completely grokked
> the new allocator either. If it gets in our way, then we could add a
> simpler allocator implementation (just a linked list like it was before)
> as an alternative and then use that instead.
> 
> Thanks,
> drew
> 
