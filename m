Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10190596CB7
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 12:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiHQKRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 06:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiHQKRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 06:17:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B7B958DCE
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 03:17:43 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BB7D113E;
        Wed, 17 Aug 2022 03:17:43 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A79263F67D;
        Wed, 17 Aug 2022 03:17:41 -0700 (PDT)
Date:   Wed, 17 Aug 2022 11:18:25 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     will@kernel.org, kvm@vger.kernel.org, jean-philippe@linaro.org,
        maz@kernel.org
Subject: Re: [kvmtool PATCH] net: Use vfork() instead of fork() for script
 execution
Message-ID: <YvzAcQCJrbw43m5c@monolith.localdoman>
References: <20220809124816.2880990-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809124816.2880990-1-suzuki.poulose@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Suzuki,

On Tue, Aug 09, 2022 at 01:48:16PM +0100, Suzuki K Poulose wrote:
> When a script is specified for a guest nic setup, we fork() and execl()s
> the script when it is time to execute the script. However this is not
> optimal, given we are running a VM. The fork() will trigger marking the
> entire page-table of the current process as CoW, which will trigger
> unmapping the entire stage2 page tables from the guest. Anyway, the

This looks correct to me, virtio_notify_status() is called when the guest
writes to the status register, which in turn can end up calling
virtio_net_exec_script(). This happens when the guest is up and running,
when stage 2 has been created and populated.

> child process will exec the script as soon as we fork(), making all
> these mm operations moot. Also, this operation could be problematic
> for confidential compute VMs, where it may be expensive (and sometimes
> destructive) to make changes to the stage2 page tables.
> 
> So, instead we could use vfork() and avoid the CoW and unmap of the stage2.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virtio/net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virtio/net.c b/virtio/net.c
> index c4e302bd..a5e0cea5 100644
> --- a/virtio/net.c
> +++ b/virtio/net.c
> @@ -295,7 +295,7 @@ static int virtio_net_exec_script(const char* script, const char *tap_name)
>  	pid_t pid;
>  	int status;
>  
> -	pid = fork();
> +	pid = vfork();
>  	if (pid == 0) {
>  		execl(script, script, tap_name, NULL);

This matches the man 2 page for vfork, which basically says that vfork can
be used only if the child immediately issues one of the exec family of
functions. Which is what is happening here.

The man page for vfork also says this:

"vfork() differs from fork(2) in that the calling thread is suspended until
the child terminates (either normally, by calling _exit(2), or abnormally,
after delivery  of a  fatal  signal), or it makes a call to execve(2)".

waitpid (which is invoked in the parent in the else branch) waits until the
child has changed state, which is defined in man 2 waitpid as:

"A state change is considered to be: the child terminated; the child was
stopped by a signal; or the child was resumed by a signal."

It doesn't mention anything about waitpid returning after the child make a
call to execve, so I guess it's correct to keep the call to waitpid in the
parent:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

>  		_exit(1);
> -- 
> 2.37.1
> 
