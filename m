Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303047A5BB
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 12:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbfG3KMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 06:12:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfG3KMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 06:12:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A29ADF26;
        Tue, 30 Jul 2019 10:12:19 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E1F2860922;
        Tue, 30 Jul 2019 10:12:17 +0000 (UTC)
Date:   Tue, 30 Jul 2019 12:12:15 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com
Subject: Re: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when
 waiting for interrupt
Message-ID: <20190730101215.i3geqxzwjqwyp3bz@kamzik.brq.redhat.com>
References: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
 <20190729112309.wooytkz7g6qtvvc2@kamzik.brq.redhat.com>
 <ab4d8b69-9fc2-94a0-f5a3-01fb87c3ac44@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ab4d8b69-9fc2-94a0-f5a3-01fb87c3ac44@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 30 Jul 2019 10:12:19 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 30, 2019 at 10:30:50AM +0100, Alexandru Elisei wrote:
> On 7/29/19 12:23 PM, Andrew Jones wrote:
> > On Mon, Jul 29, 2019 at 10:28:52AM +0100, Alexandru Elisei wrote:
> >> Commit 204e85aa9352 ("arm64: timer: a few test improvements") added a call
> >> to report_info after enabling the timer and before the wfi instruction. The
> >> uart that printf uses is emulated by userspace and is slow, which makes it
> >> more likely that the timer interrupt will fire before executing the wfi
> >> instruction, which leads to a deadlock.
> >>
> >> An interrupt can wake up a CPU out of wfi, regardless of the
> >> PSTATE.{A, I, F} bits. Fix the deadlock by masking interrupts on the CPU
> >> before enabling the timer and unmasking them after the wfi returns so the
> >> CPU can execute the timer interrupt handler.
> >>
> >> Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  arm/timer.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/arm/timer.c b/arm/timer.c
> >> index 6f2ad1d76ab2..f2f60192ba62 100644
> >> --- a/arm/timer.c
> >> +++ b/arm/timer.c
> >> @@ -242,9 +242,11 @@ static void test_timer(struct timer_info *info)
> >>  	/* Test TVAL and IRQ trigger */
> >>  	info->irq_received = false;
> >>  	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
> >> +	local_irq_disable();
> >>  	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
> >>  	report_info("waiting for interrupt...");
> >>  	wfi();
> >> +	local_irq_enable();
> >>  	left = info->read_tval();
> >>  	report("interrupt received after TVAL/WFI", info->irq_received);
> >>  	report("timer has expired (%d)", left < 0, left);
> >> -- 
> >> 2.7.4
> >>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> >
> > Thanks Alexandru. It now makes more sense to me that wfi wakes up on
> > an interrupt, even when interrupts are masked, as it's clearly to
> > avoid these types of races. I see we have the same type of race in
> > arm/gic.c. I'll try to get around to fixing that at some point, unless
> > somebody beats me to it :)
> 
> Something like this? Tested with gicv3-ipi.
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index ed5642e74f70..f0bd5739842a 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -220,12 +220,12 @@ static void ipi_enable(void)
>  #else
>         install_irq_handler(EL1H_IRQ, ipi_handler);
>  #endif
> -       local_irq_enable();
>  }
>  
>  static void ipi_send(void)
>  {
>         ipi_enable();
> +       local_irq_enable();
>         wait_on_ready();
>         ipi_test_self();
>         ipi_test_smp();
> @@ -236,9 +236,13 @@ static void ipi_send(void)
>  static void ipi_recv(void)
>  {
>         ipi_enable();
> +       local_irq_disable();
>         cpumask_set_cpu(smp_processor_id(), &ready);
> -       while (1)
> +       while (1) {
> +               local_irq_disable();
>                 wfi();
> +               local_irq_enable();
> +       }
>  }
>  
>  static void ipi_test(void *data __unused)

I'm not sure we need to worry about enabling/disabling interrupts around
the wfi, since we're just doing a tight loop on it. I think something like
this (untested), which is quite similar to your approach, should work

diff --git a/arm/gic.c b/arm/gic.c
index ed5642e74f70..cdbb4134b0af 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -214,18 +214,19 @@ static void ipi_test_smp(void)
 
 static void ipi_enable(void)
 {
+       local_irq_disable();
        gic_enable_defaults();
 #ifdef __arm__
        install_exception_handler(EXCPTN_IRQ, ipi_handler);
 #else
        install_irq_handler(EL1H_IRQ, ipi_handler);
 #endif
-       local_irq_enable();
 }
 
 static void ipi_send(void)
 {
        ipi_enable();
+       local_irq_enable();
        wait_on_ready();
        ipi_test_self();
        ipi_test_smp();
@@ -237,6 +238,7 @@ static void ipi_recv(void)
 {
        ipi_enable();
        cpumask_set_cpu(smp_processor_id(), &ready);
+       local_irq_enable();
        while (1)
                wfi();
 }

What do you think?

Thanks,
drew
