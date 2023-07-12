Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1308A750E7F
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjGLQ0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbjGLQ0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:26:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88BFD1BF1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:26:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A961012FC;
        Wed, 12 Jul 2023 09:27:09 -0700 (PDT)
Received: from [10.57.36.71] (unknown [10.57.36.71])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E52893F73F;
        Wed, 12 Jul 2023 09:26:25 -0700 (PDT)
Message-ID: <8097c572-6f40-fc11-361f-8e6e0c16ddff@arm.com>
Date:   Wed, 12 Jul 2023 17:26:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH kvmtool v2 2/4] Replace printf/fprintf with pr_* macros
To:     Alexandru Elisei <alexandru.elisei@arm.com>, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        maz@kernel.org, oliver.upton@linux.dev,
        jean-philippe.brucker@arm.com, apatel@ventanamicro.com,
        kvm@vger.kernel.org
References: <20230707151119.81208-1-alexandru.elisei@arm.com>
 <20230707151119.81208-3-alexandru.elisei@arm.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230707151119.81208-3-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru

On 07/07/2023 16:11, Alexandru Elisei wrote:
> To prepare for allowing finer control over the messages that kvmtool
> displays, replace printf() and fprintf() with the pr_* macros.
> 
> Minor changes were made to fix coding style issues that were pet peeves for
> the author. And use pr_err() in kvm_cpu__init() instead of pr_warning() for
> fatal errors.
> 
> Also, fix the message when printing the exit code for KVM_EXIT_UNKNOWN by
> removing the '0x' part, because it's printing a decimal number, not a
> hexadecimal one (the format specifier is %llu, not %llx).
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
> Changelog:
> 
> - Use pr_err() to directly replace fprintf() in kernel_usage_with_options()
>    instead of concatening the kernel locations.
> - Removed the '0x' from the "KVM exit code: 0x%llu" message in kvm_cpu_thread()
>    because the number is decimal (it's %llu, not %llx).
> - Reverted the changes to kvm__emulate_mmio() and debug_io () because those
>    messages are displayed with --debug-mmio, respectively --debug-ioport, and
>    --loglevel hiding them would have been counter-intuitive.
> - Replaced the "warning" string in kvm__emulate_mmio() with "MMIO warning", to
>    match the message from kvm__emulate_io(). And to make it clear that it isn't
>    toggled with --loglevel.
> - Removed extra spaces in virtio_compat_add_message().
> 
>   arm/gic.c       |  5 ++---
>   builtin-run.c   | 37 +++++++++++++++++++------------------
>   builtin-setup.c | 16 ++++++++--------
>   guest_compat.c  |  2 +-
>   kvm-cpu.c       | 12 ++++++------
>   mmio.c          |  2 +-
>   6 files changed, 37 insertions(+), 37 deletions(-)
> 

> diff --git a/guest_compat.c b/guest_compat.c
> index fd4704b20b16..93f9aabcd6db 100644
> --- a/guest_compat.c
> +++ b/guest_compat.c
> @@ -86,7 +86,7 @@ int compat__print_all_messages(void)
>   
>   		msg = list_first_entry(&messages, struct compat_message, list);
>   
> -		printf("\n  # KVM compatibility warning.\n\t%s\n\t%s\n",
> +		pr_warning("KVM compatibility warning.\n\t%s\n\t%s",
>   			msg->title, msg->desc);

Does this really need to be a Warning ? A user could be running a non-
Linux guest and reporting the compatibility with WARNING level makes it
a bit tricky to suppress. i.e., User may want to suppress the "virtio"
compatibility messages, without actually loosing any other important
"Warnings". With the --loglevel=warning, we don't have that capability.

There are two options here as far as I can see:

1) Convert compatibility messages to "Info"
2) Control the compatibility messages via new option, (something like we
    did here, with --nocompat [0])

[0] 
https://lore.kernel.org/all/20230127113932.166089-5-suzuki.poulose@arm.com/


Suzuki

