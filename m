Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D30B6C490B
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 12:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCVLZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 07:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCVLZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 07:25:02 -0400
Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [IPv6:2001:41d0:203:375::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0945561523
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 04:24:59 -0700 (PDT)
Date:   Wed, 22 Mar 2023 12:24:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679484297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aITG1t60yJcLOWRraYur4nSTqT9NFr2rwaG9aiUNdl0=;
        b=FVNveFkEQhM7cS2x/d3kOLwVC/Yub5VlcR+2J0duNOWeK9e+e8TIRk2d06B8y025T2mNUW
        ta0qJlbbudAhv8+5TglW51qIKWYypI2XRBxUCrWthalnHmsTDJPNIGcGWRGzFPHJJhi7yl
        my6mrSJjTglMLSFN+kJ2bAK83veWpS8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [PATCH v4 30/30] arm64: Add an efi/run script
Message-ID: <20230322112455.got7oypemataep2c@orel>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-31-nikos.nikoleris@arm.com>
 <20230321184158.phwwbsk5mv7qwhpa@orel>
 <07119162-55c9-cf86-ce55-651496dabb00@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07119162-55c9-cf86-ce55-651496dabb00@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 10:02:35AM +0000, Nikos Nikoleris wrote:
> Hi Drew,
> 
> On 21/03/2023 18:41, Andrew Jones wrote:
> > On Mon, Feb 13, 2023 at 10:17:59AM +0000, Nikos Nikoleris wrote:
> > > This change adds a efi/run script inspired by the one in x86. This
> > > script will setup a folder with the test compiled as an EFI app and a
> > > startup.nsh script. The script launches QEMU providing an image with
> > > EDKII and the path to the folder with the test which is executed
> > > automatically.
> > > 
> > > For example:
> > > 
> > > $> ./arm/efi/run ./arm/selftest.efi setup smp=2 mem=256
> > 
> > This should be
> > 
> > ./arm/efi/run ./arm/selftest.efi -append "setup smp=2 mem=256" -smp 2 -m 256
> > 
> 
> Indeed, I will update the commit message.
> 
> > but I can't get any tests to run through ./arm/efi/run. All of them
> > immediately die with a DABT_EL1. I can get the tests to run (and pass) by
> > manually booting into UEFI with the FAT partition pointing at the parent
> > directory
> > 
> 
> I suppose the DABT_EL1 is happening after the test has started and not while
> the UEFI interactive shell starts?

The countdown completes and the startup script runs (I can add an echo to
check it). So it must be the test that fails.

> 
> >   $QEMU -nodefaults -machine virt -accel tcg -cpu cortex-a57 \
> >         -device pci-testdev -display none -serial stdio \
> >         -bios /usr/share/edk2/aarch64/QEMU_EFI.silent.fd \
> >         -drive file.dir=efi-tests/,file.driver=vvfat,file.rw=on,format=raw,if=virtio
> > 
> 
> Do you hit the DABT_EL1 if you let it automatically start using the
> startup.nsh prepared by the ./arm/efi/run script? Meaning change the above
> command if you provided -drive file.dir=efi-tests/timer instead:
> 
>  $QEMU -nodefaults -machine virt -accel tcg -cpu cortex-a57 \
>        -device pci-testdev -display none -serial stdio \
>        -bios /usr/share/edk2/aarch64/QEMU_EFI.silent.fd \
>        -drive file.dir=efi
> tests/timer,file.driver=vvfat,file.rw=on,format=raw,if=virtio

Yes, this is what ./arm/efi/run does, and it doesn't help to use the
command line directly.

> 
> Thanks for reviewing this!
> 
> Nikos
> 
> > and then, for example for the timer test, doing
> > 
> >   fs0:
> >   cd timer
> >   timer.efi

This actually doesn't work. I was actually doing

 fs0:
 cd timer
 ls
 timer.efi

and, believe it or not, without the 'ls' I get the dabt, with the 'ls' the
test runs and passes. Adding an 'ls' to the startup script doesn't help
the automatic execution though.

Which versions of QEMU and edk2 are you using? And what file system do you
have the efi-tests directory on?

Thanks,
drew

> > 
> > but the script never works.
> > 
> > Thanks,
> > drew
