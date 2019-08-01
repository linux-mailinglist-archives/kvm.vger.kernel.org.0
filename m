Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40DE47DE41
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732291AbfHAOvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:51:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47980 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731148AbfHAOvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TLXphQCYQA4IH6EeQfPIRer8TKaUSBx10Q5NGx+zH2A=; b=tfVE0gpM/bbhJ21q88MryQl3W
        VpX8K2qjMXf2ZLhMSkeoQbqrPsU9ZrsrQNacazFNkqJZrfdGGRJwVGcQ94yYxloZP6LKLYCt1OIbf
        WRxKna+/IOOgsWkKvhc0+05JYEILE71YYB88OGPSWnGt++lKvCqOmBfL75cMoU8YdqaMy9Qe5yma9
        cborZwPpvfMaWKk2ePpV7LlvV7Pq5iKQQKH0zcT6OgICS1/pMWpMVMH+JwG1Diy7674fLSHYEfd7v
        i0D6QkPd7sTNG12iftcHxo0XauzkcWoEGK4Xi835kdhlGES7tnNESUNUfVTpZV9kqeVXGjIDLM17p
        cylcGOXww==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1htCQH-0005Qw-M0; Thu, 01 Aug 2019 14:51:17 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 17F132029F4C9; Thu,  1 Aug 2019 16:51:16 +0200 (CEST)
Date:   Thu, 1 Aug 2019 16:51:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 4/5] posix-cpu-timers: Defer timer handling to task_work
Message-ID: <20190801145116.GD31398@hirez.programming.kicks-ass.net>
References: <20190801143250.370326052@linutronix.de>
 <20190801143658.074833024@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801143658.074833024@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 04:32:54PM +0200, Thomas Gleixner wrote:
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -52,6 +52,11 @@ config GENERIC_CLOCKEVENTS_MIN_ADJUST
>  config GENERIC_CMOS_UPDATE
>  	bool
>  
> +# Select to handle posix CPU timers from task_work
> +# and not from the timer interrupt context
> +config POSIX_CPU_TIMERS_TASK_WORK
> +	bool
> +
>  if GENERIC_CLOCKEVENTS
>  menu "Timers subsystem"
>  


diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index deff97217496..76e37ad5bc31 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -58,6 +58,7 @@ config PREEMPT
 config PREEMPT_RT
 	bool "Fully Preemptible Kernel (Real-Time)"
 	depends on EXPERT && ARCH_SUPPORTS_RT
+	depends on POSIX_CPU_TIMERS_TASK_WORK
 	select PREEMPTION
 	help
 	  This option turns the kernel into a real-time kernel by replacing
