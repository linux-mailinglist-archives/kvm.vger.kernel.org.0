Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BFE58EEEC
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiHJPDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbiHJPDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:03:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBB8A760C3
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:03:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 022E41424;
        Wed, 10 Aug 2022 08:03:34 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DF893F67D;
        Wed, 10 Aug 2022 08:03:31 -0700 (PDT)
Date:   Wed, 10 Aug 2022 16:04:12 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, ricarkol@google.com, zixuanwang@google.com
Subject: Re: [kvm-unit-tests PATCH v3 00/27] EFI and ACPI support for arm64
Message-ID: <YvPI1xunDNtAV5jo@monolith.localdoman>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <YvJB/KCLSQK836ae@monolith.localdoman>
 <YvJ9dni3JCUHNsF1@google.com>
 <YvN3jk4VUD9Dhl0H@monolith.localdoman>
 <YvPHhwtc6LX62Y+E@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvPHhwtc6LX62Y+E@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Wed, Aug 10, 2022 at 02:58:15PM +0000, Sean Christopherson wrote:
> On Wed, Aug 10, 2022, Alexandru Elisei wrote:
> > Hi Sean,
> > 
> > On Tue, Aug 09, 2022 at 03:29:58PM +0000, Sean Christopherson wrote:
> > > On Tue, Aug 09, 2022, Alexandru Elisei wrote:
> > > > Note that the assumption that efi_main() makes is that setup_efi() doesn't
> > > > change the stack from the stack that the UEFI implementation allocated, in
> > > > order for setup_efi() to be able to return to efi_main().
> > > 
> > > On the x86 side, efi_main() now runs with a KUT-controlled stack since commit
> > > 
> > >   d316d12a ("x86: efi: Provide a stack within testcase memory")
> > > 
> > > > If we want to keep the UEFI allocated stack, then both mechanism must be
> > > > forbidden when running under UEFI. I dislike this idea, because those two
> > > > mechanisms allow kvm-unit-tests to run tests which otherwise wouldn't have
> > > > been possible with a normal operating system, which, except for the early
> > > > boot code, runs with the MMU enabled.
> > > 
> > > Agreed.  IMO, KUT should stop using UEFI-controlled data as early as possible.
> > > The original x86 behavior was effectively a temporary solution to get UEFI working
> > > without needing to simultaneously rework the common early boot flows.
> > 
> > Yes, this is also what I am thinking, the stack is poorly specified in the
> > specification because the specification doesn't expect an application to
> > keep using it after calling EFI_BOOT_SERVICES.Exit(). Plus, using the UEFI
> > allocated stack makes the test less reproducible, as even EDK2 today
> > diverges from the spec wrt the stack, and other UEFI implementations might
> > do things differently. And with just like all software, there might be bugs
> > in the firmware. IMO, the more control kvm-unit-tests has over its
> > resources, the more robust the tests are.
> > 
> > What I was thinking is rewriting efi_main to return setup_efi(),
> > something like this:
> > 
> > void efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> > {
> > 	/* Get image, cmdline and memory map parameters from UEFI */
> > 
> >         efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> > 
> >         /* Set up arch-specific resources, not expected to return. */
> >         setup_efi(&efi_bootinfo);
> > }
> > 
> > Which would allow all architectures to change their environment as they see
> > fit, as setup_efi() is not expected to return. Architectures would have to
> > be made aware of the efi_exit() function though.
> 
> And they'd also have to invoke the test's main().  Why can't ARM switch to a KUT
> stack before calling efi_main()?  The stack is a rather special case, I don't think
> it's unreasonable to require architectures to handle that before efi_main().

Sorry, missed the part from your earlier reply about x86 switching to a
kvm-unit-tests controlled stack. I was just going to say that, when I saw
your reply.

I agree, it's entirely feasible for arm64 to switch to its own stack before
calling efi_main(), in which case it can call efi_main() without any
changes to efi_main().

Thanks for your input.

Alex
