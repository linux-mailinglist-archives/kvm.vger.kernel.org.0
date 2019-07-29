Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF87B78A5B
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 13:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387632AbfG2LXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 07:23:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387450AbfG2LXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 07:23:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11EAD4E8AC;
        Mon, 29 Jul 2019 11:23:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D41FA60C5F;
        Mon, 29 Jul 2019 11:23:11 +0000 (UTC)
Date:   Mon, 29 Jul 2019 13:23:09 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
Subject: Re: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when
 waiting for interrupt
Message-ID: <20190729112309.wooytkz7g6qtvvc2@kamzik.brq.redhat.com>
References: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 29 Jul 2019 11:23:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 29, 2019 at 10:28:52AM +0100, Alexandru Elisei wrote:
> Commit 204e85aa9352 ("arm64: timer: a few test improvements") added a call
> to report_info after enabling the timer and before the wfi instruction. The
> uart that printf uses is emulated by userspace and is slow, which makes it
> more likely that the timer interrupt will fire before executing the wfi
> instruction, which leads to a deadlock.
> 
> An interrupt can wake up a CPU out of wfi, regardless of the
> PSTATE.{A, I, F} bits. Fix the deadlock by masking interrupts on the CPU
> before enabling the timer and unmasking them after the wfi returns so the
> CPU can execute the timer interrupt handler.
> 
> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/timer.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 6f2ad1d76ab2..f2f60192ba62 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -242,9 +242,11 @@ static void test_timer(struct timer_info *info)
>  	/* Test TVAL and IRQ trigger */
>  	info->irq_received = false;
>  	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
> +	local_irq_disable();
>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
>  	report_info("waiting for interrupt...");
>  	wfi();
> +	local_irq_enable();
>  	left = info->read_tval();
>  	report("interrupt received after TVAL/WFI", info->irq_received);
>  	report("timer has expired (%d)", left < 0, left);
> -- 
> 2.7.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks Alexandru. It now makes more sense to me that wfi wakes up on
an interrupt, even when interrupts are masked, as it's clearly to
avoid these types of races. I see we have the same type of race in
arm/gic.c. I'll try to get around to fixing that at some point, unless
somebody beats me to it :)

drew
