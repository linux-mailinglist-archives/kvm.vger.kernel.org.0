Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000004B7353
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 17:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241407AbiBOQPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 11:15:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241389AbiBOQPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 11:15:02 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB06BE02C2
        for <kvm@vger.kernel.org>; Tue, 15 Feb 2022 08:14:51 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 944931396;
        Tue, 15 Feb 2022 08:14:51 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BFF343F66F;
        Tue, 15 Feb 2022 08:14:49 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:15:11 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
        thuth@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] lib/devicetree: Support 64 bit addresses
 for the initrd
Message-ID: <YgvQupgYA2gIby95@monolith.localdoman>
References: <20220214135226.joxzj2tgg244wl6n@gator>
 <YgphzKLQLb5pMYoP@monolith.localdoman>
 <20220214142444.saeogrpgpx6kaamm@gator>
 <YgqBPSV+CMyzfNlv@monolith.localdoman>
 <87k0dx4c23.wl-maz@kernel.org>
 <20220215073212.fp5lh4gfxk7clwwc@gator>
 <Ygt7PbS6zW9H1By4@monolith.localdoman>
 <20220215125300.6b5ff3luxikc4jhd@gator>
 <Ygu1q6r4oalKzn0H@monolith.localdoman>
 <20220215155037.7q5aivsuxu657ztp@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215155037.7q5aivsuxu657ztp@gator>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On Tue, Feb 15, 2022 at 04:50:37PM +0100, Andrew Jones wrote:
> On Tue, Feb 15, 2022 at 02:16:32PM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Tue, Feb 15, 2022 at 01:53:00PM +0100, Andrew Jones wrote:
> > > On Tue, Feb 15, 2022 at 10:07:16AM +0000, Alexandru Elisei wrote:
> > > > 
> > > > I've started working on the next iteration of the kvmtool test
> > > > runner support series, I'll do my best to make sure kvmtool wll be able to run
> > > > the tests when kvm-unit-tests has been configured with --arch=arm.
> > > >
> > > 
> > > Excellent!
> > > 
> > > BTW, I went ahead an pushed a patch to misc/queue to improve the initrd
> > > address stuff
> > > 
> > > https://gitlab.com/rhdrjones/kvm-unit-tests/-/commit/6f8f74ed2d9953830a3c74669f25439d9ad68dec
> > > 
> > > It may be necessary for you if kvmtool shares its fdt creation between
> > > aarch64 and aarch32 guests, emitting 8 byte initrd addresses for both,
> > > even though the aarch32 guest puts the fdt below 4G.
> > 
> > While trying your patch (it works, but with the caveat below), I remembered that
> > kvmtool is not able to run kvm-unit-tests for arm. That's because the code is
> > not relocatable (like it is for arm64) and the text address is hardcoded in the
> > makefile.
> > 
> > In past, to run the arm tests with kvmtool, I was doing this change:
> > 
> > diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> > index 3a4cc6b26234..6c580b067413 100644
> > --- a/arm/Makefile.arm
> > +++ b/arm/Makefile.arm
> > @@ -14,7 +14,7 @@ CFLAGS += $(machine)
> >  CFLAGS += -mcpu=$(PROCESSOR)
> >  CFLAGS += -mno-unaligned-access
> >  
> > -arch_LDFLAGS = -Ttext=40010000
> > +arch_LDFLAGS = -Ttext=80008000
> >  
> >  define arch_elf_check =
> >  endef
> > 
> > Any suggestions how to fix that? One way would be to change the LDFLAGS based on
> > $TARGET. Another way would be to make the arm tests relocatable, I tried to do
> > that in the past but I couldn't make any progress.
> 
> Ideally we'd eventually make it relocatable, but it's not worth moving
> mountains, so I'm OK with the LDFLAGS approach.
> 
> > 
> > Separate from that, I also tried to run the 32 bit arm tests with run_tests.sh.
> > The runner uses qemu-system-arm (because $ARCH_NAME is arm in
> > scripts/arch-run.bash::search_qemu_binary()), but uses kvm as the accelerator
> > (because /dev/kvm exists in scrips/arch-run.bash::kvm_available()). This fails
> > with the error:
> > 
> > qemu-system-arm: -accel kvm: invalid accelerator kvm
> > 
> > I don't think that's supposed to happen, as kvm_available() specifically returns
> > true if $HOST = aarch64 and $ARCH = arm. Any suggestions?
> > 
> 
> Ah, that's a kvm-unit-tests bug. Typically qemu-system-$ARCH_NAME is
> correct and, with TCG, qemu-system-arm runs the arm built unit tests fine.
> But, when KVM is enabled, the QEMU used should be qemu-system-$HOST.
> 
> I don't think we want to change search_qemu_binary(), though, as that
> would require ACCEL being set first and may not apply to all
> architectures. Probably the best thing to do is fix this up in arm/run

Definitely, this should go in arm/run.

> 
> diff --git a/arm/run b/arm/run
> index 2153bd320751..ff18def43403 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -13,6 +13,10 @@ processor="$PROCESSOR"
>  ACCEL=$(get_qemu_accelerator) ||
>         exit $?
>  
> +if [ "$ACCEL" = "kvm" ] && [ -z "$QEMU" ]; then
> +       QEMU=qemu-system-$HOST
> +fi

Looking at get_qemu_accelerator, I think it returns true when /dev/kvm exists,
which means that get_qemu_accelerator can return "kvm" when trying to run the
arm64 tests on an arm machine with KVM. But in this case, it's impossible to run
the tests using KVM.

And I also think there should be some checking that aarch64=off works, as there
are arm64 CPUs which don't support AArch32 (like Cortex-A510).

Thanks,
Alex

> +
>  qemu=$(search_qemu_binary) ||
>         exit $?
>  
> 
> Thanks,
> drew
> 
