Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B4F58E966
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 11:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiHJJQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 05:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiHJJQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 05:16:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74694642D9
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 02:16:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D7891FB;
        Wed, 10 Aug 2022 02:16:38 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38A283F70D;
        Wed, 10 Aug 2022 02:16:36 -0700 (PDT)
Date:   Wed, 10 Aug 2022 10:17:17 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, ricarkol@google.com, zixuanwang@google.com
Subject: Re: [kvm-unit-tests PATCH v3 00/27] EFI and ACPI support for arm64
Message-ID: <YvN3jk4VUD9Dhl0H@monolith.localdoman>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <YvJB/KCLSQK836ae@monolith.localdoman>
 <YvJ9dni3JCUHNsF1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvJ9dni3JCUHNsF1@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Tue, Aug 09, 2022 at 03:29:58PM +0000, Sean Christopherson wrote:
> On Tue, Aug 09, 2022, Alexandru Elisei wrote:
> > Hi,
> > 
> > Adding Sean and Zixuan, as they were involved in the initial x86 UEFI
> > support.
> > 
> > This version of the UEFI support for arm64 jumps to lib/efi.c::efi_main
> > after performing the relocation. I'll post an abbreviated/simplified
> > version of efi_main() for reference:
> > 
> > efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> > {
> > 	/* Get image, cmdline and memory map parameters from UEFI */
> > 
> >         efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> > 
> >         /* Set up arch-specific resources */
> >         setup_efi(&efi_bootinfo);
> > 
> >         /* Run the test case */
> >         ret = main(__argc, __argv, __environ);
> > 
> >         /* Shutdown the guest VM */
> >         efi_exit(ret);
> > 
> >         /* Unreachable */
> >         return EFI_UNSUPPORTED;
> > }
> > 
> > Note that the assumption that efi_main() makes is that setup_efi() doesn't
> > change the stack from the stack that the UEFI implementation allocated, in
> > order for setup_efi() to be able to return to efi_main().
> 
> On the x86 side, efi_main() now runs with a KUT-controlled stack since commit
> 
>   d316d12a ("x86: efi: Provide a stack within testcase memory")
> 
> > If we want to keep the UEFI allocated stack, then both mechanism must be
> > forbidden when running under UEFI. I dislike this idea, because those two
> > mechanisms allow kvm-unit-tests to run tests which otherwise wouldn't have
> > been possible with a normal operating system, which, except for the early
> > boot code, runs with the MMU enabled.
> 
> Agreed.  IMO, KUT should stop using UEFI-controlled data as early as possible.
> The original x86 behavior was effectively a temporary solution to get UEFI working
> without needing to simultaneously rework the common early boot flows.

Yes, this is also what I am thinking, the stack is poorly specified in the
specification because the specification doesn't expect an application to
keep using it after calling EFI_BOOT_SERVICES.Exit(). Plus, using the UEFI
allocated stack makes the test less reproducible, as even EDK2 today
diverges from the spec wrt the stack, and other UEFI implementations might
do things differently. And with just like all software, there might be bugs
in the firmware. IMO, the more control kvm-unit-tests has over its
resources, the more robust the tests are.

What I was thinking is rewriting efi_main to return setup_efi(),
something like this:

void efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
{
	/* Get image, cmdline and memory map parameters from UEFI */

        efi_exit_boot_services(handle, &efi_bootinfo.mem_map);

        /* Set up arch-specific resources, not expected to return. */
        setup_efi(&efi_bootinfo);
}

Which would allow all architectures to change their environment as they see
fit, as setup_efi() is not expected to return. Architectures would have to
be made aware of the efi_exit() function though.

If you like that approach, I can give it a go, though I'm very rusty when
it comes to x86.

Thanks,
Alex

> 
> Side topic, I think the x86 code now has a benign bug.  The old code contained an
> adjustment to RSP to undo some stack shenanigans (can't figure out why those
> shenanigans exist), but now the adjustment happens on the KUT stack, which doesn't
> need to be fixed up.
> 
> It's a moot point since efi_main() should never return, but it looks odd.  And it
> seems like KUT should intentionally explode if efi_main() returns, e.g. do this
> over two patches:
> 
> diff --git a/x86/efi/crt0-efi-x86_64.S b/x86/efi/crt0-efi-x86_64.S
> index 1708ed55..e62891bc 100644
> --- a/x86/efi/crt0-efi-x86_64.S
> +++ b/x86/efi/crt0-efi-x86_64.S
> @@ -62,10 +62,7 @@ _start:
>         lea stacktop(%rip), %rsp
>  
>         call efi_main
> -       addq $8, %rsp
> -
> -.exit: 
> -       ret
> +       ud2
>  
>         // hand-craft a dummy .reloc section so EFI knows it's a relocatable executable:
