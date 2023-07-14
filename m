Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794DB753BF6
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 15:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbjGNNoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 09:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbjGNNoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 09:44:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EAFA30FF
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 06:44:21 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C1831570;
        Fri, 14 Jul 2023 06:45:03 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DB9C3F67D;
        Fri, 14 Jul 2023 06:44:19 -0700 (PDT)
Date:   Fri, 14 Jul 2023 14:44:12 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, maz@kernel.org, oliver.upton@linux.dev,
        jean-philippe.brucker@arm.com, apatel@ventanamicro.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool v2 2/4] Replace printf/fprintf with pr_* macros
Message-ID: <ZLFQZ5v3XX_NNTJd@monolith.localdoman>
References: <20230707151119.81208-1-alexandru.elisei@arm.com>
 <20230707151119.81208-3-alexandru.elisei@arm.com>
 <8097c572-6f40-fc11-361f-8e6e0c16ddff@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8097c572-6f40-fc11-361f-8e6e0c16ddff@arm.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Suzuki,

On Wed, Jul 12, 2023 at 05:26:24PM +0100, Suzuki K Poulose wrote:
> Hi Alexandru
> 
> On 07/07/2023 16:11, Alexandru Elisei wrote:
> > To prepare for allowing finer control over the messages that kvmtool
> > displays, replace printf() and fprintf() with the pr_* macros.
> > 
> > Minor changes were made to fix coding style issues that were pet peeves for
> > the author. And use pr_err() in kvm_cpu__init() instead of pr_warning() for
> > fatal errors.
> > 
> > Also, fix the message when printing the exit code for KVM_EXIT_UNKNOWN by
> > removing the '0x' part, because it's printing a decimal number, not a
> > hexadecimal one (the format specifier is %llu, not %llx).
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> > Changelog:
> > 
> > - Use pr_err() to directly replace fprintf() in kernel_usage_with_options()
> >    instead of concatening the kernel locations.
> > - Removed the '0x' from the "KVM exit code: 0x%llu" message in kvm_cpu_thread()
> >    because the number is decimal (it's %llu, not %llx).
> > - Reverted the changes to kvm__emulate_mmio() and debug_io () because those
> >    messages are displayed with --debug-mmio, respectively --debug-ioport, and
> >    --loglevel hiding them would have been counter-intuitive.
> > - Replaced the "warning" string in kvm__emulate_mmio() with "MMIO warning", to
> >    match the message from kvm__emulate_io(). And to make it clear that it isn't
> >    toggled with --loglevel.
> > - Removed extra spaces in virtio_compat_add_message().
> > 
> >   arm/gic.c       |  5 ++---
> >   builtin-run.c   | 37 +++++++++++++++++++------------------
> >   builtin-setup.c | 16 ++++++++--------
> >   guest_compat.c  |  2 +-
> >   kvm-cpu.c       | 12 ++++++------
> >   mmio.c          |  2 +-
> >   6 files changed, 37 insertions(+), 37 deletions(-)
> > 
> 
> > diff --git a/guest_compat.c b/guest_compat.c
> > index fd4704b20b16..93f9aabcd6db 100644
> > --- a/guest_compat.c
> > +++ b/guest_compat.c
> > @@ -86,7 +86,7 @@ int compat__print_all_messages(void)
> >   		msg = list_first_entry(&messages, struct compat_message, list);
> > -		printf("\n  # KVM compatibility warning.\n\t%s\n\t%s\n",
> > +		pr_warning("KVM compatibility warning.\n\t%s\n\t%s",
> >   			msg->title, msg->desc);
> 
> Does this really need to be a Warning ? A user could be running a non-
> Linux guest and reporting the compatibility with WARNING level makes it
> a bit tricky to suppress. i.e., User may want to suppress the "virtio"
> compatibility messages, without actually loosing any other important
> "Warnings". With the --loglevel=warning, we don't have that capability.

That sounds reasonable.

> 
> There are two options here as far as I can see:
> 
> 1) Convert compatibility messages to "Info"
> 2) Control the compatibility messages via new option, (something like we
>    did here, with --nocompat [0])

Out of the two, I would rather go the "info" route, so there aren't two
separate methods to disable kvmtool messages, via --loglevel and via
--nocompat.

I'll prepare a patch.

Thanks,
Alex

> 
> [0]
> https://lore.kernel.org/all/20230127113932.166089-5-suzuki.poulose@arm.com/
> 
> 
> Suzuki
> 
