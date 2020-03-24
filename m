Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6021914AE
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgCXPh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:32884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbgCXPh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 11:37:58 -0400
Received: from localhost (lfbn-ncy-1-985-231.w90-101.abo.wanadoo.fr [90.101.63.231])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 264E220714;
        Tue, 24 Mar 2020 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585064277;
        bh=0orXiZqfiTQ0nzIx4WpHUD4WiuEZt0G9H0JZyzsPBKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ruMaTUcF2yzwekmY93CJzG2BGG4W8nKTZXqNyJRXTUwe42rb0yX/c1nOjMxLUb+Aa
         vVKctHlID/TWSjuD6M/03AeHT9OPiwqTYR6yMoAetUoU1ADuDdxUjN34zTT2FgZ620
         b44giTe0V8GYIUm82txE/NT3ztoS/bnjTP0y7rCw=
Date:   Tue, 24 Mar 2020 16:37:55 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [patch V3 01/23] rcu: Dont acquire lock in NMI handler in
 rcu_nmi_enter_common()
Message-ID: <20200324153754.GA20223@lenoir>
References: <20200320175956.033706968@linutronix.de>
 <20200320180032.523372590@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320180032.523372590@linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 06:59:57PM +0100, Thomas Gleixner wrote:
> From: "Paul E. McKenney" <paulmck@kernel.org>
> 
> The rcu_nmi_enter_common() function can be invoked both in interrupt
> and NMI handlers.  If it is invoked from process context (as opposed
> to userspace or idle context) on a nohz_full CPU, it might acquire the
> CPU's leaf rcu_node structure's ->lock.  Because this lock is held only
> with interrupts disabled, this is safe from an interrupt handler, but
> doing so from an NMI handler can result in self-deadlock.
> 
> This commit therefore adds "irq" to the "if" condition so as to only
> acquire the ->lock from irq handlers or process context, never from
> an NMI handler.
> 
> Fixes: 5b14557b073c ("rcu: Avoid tick_dep_set_cpu() misordering")
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Link: https://lkml.kernel.org/r/20200313024046.27622-1-paulmck@kernel.org

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
