Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25572397E8
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbfFGVjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 17:39:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46223 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731343AbfFGVjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 17:39:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D2F0AA3B76;
        Fri,  7 Jun 2019 21:39:08 +0000 (UTC)
Received: from amt.cnet (ovpn-112-16.gru2.redhat.com [10.97.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C503A60BE2;
        Fri,  7 Jun 2019 21:39:05 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id D278610515C;
        Fri,  7 Jun 2019 17:25:18 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x57KPEPX021903;
        Fri, 7 Jun 2019 17:25:14 -0300
Date:   Fri, 7 Jun 2019 17:25:14 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [patch v2 3/3] cpuidle-haltpoll: disable host side polling when
 kvm virtualized
Message-ID: <20190607202513.GB5542@amt.cnet>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.360289262@amt.cnet>
 <20190604122404.GA18979@amt.cnet>
 <cb11ef01-b579-1526-d585-0c815f2e1f6f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb11ef01-b579-1526-d585-0c815f2e1f6f@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 07 Jun 2019 21:39:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joao,

On Thu, Jun 06, 2019 at 07:25:28PM +0100, Joao Martins wrote:
> On 6/4/19 1:24 PM, Marcelo Tosatti wrote:
> > 
> > When performing guest side polling, it is not necessary to 
> > also perform host side polling. 
> > 
> > So disable host side polling, via the new MSR interface, 
> > when loading cpuidle-haltpoll driver.
> > 
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > 
> > ---
> > 
> > v2: remove extra "}"
> > 
> >  arch/x86/Kconfig                        |    7 +++++
> >  arch/x86/include/asm/cpuidle_haltpoll.h |    8 ++++++
> >  arch/x86/kernel/kvm.c                   |   40 ++++++++++++++++++++++++++++++++
> >  drivers/cpuidle/cpuidle-haltpoll.c      |    9 ++++++-
> >  include/linux/cpuidle_haltpoll.h        |   16 ++++++++++++
> >  5 files changed, 79 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.git/arch/x86/include/asm/cpuidle_haltpoll.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6.git/arch/x86/include/asm/cpuidle_haltpoll.h	2019-06-03 19:38:42.328718617 -0300
> > @@ -0,0 +1,8 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ARCH_HALTPOLL_H
> > +#define _ARCH_HALTPOLL_H
> > +
> > +void arch_haltpoll_enable(void);
> > +void arch_haltpoll_disable(void);
> > +
> > +#endif
> > Index: linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c
> > ===================================================================
> > --- linux-2.6.git.orig/drivers/cpuidle/cpuidle-haltpoll.c	2019-06-03 19:38:12.376619124 -0300
> > +++ linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c	2019-06-03 19:38:42.328718617 -0300
> > @@ -15,6 +15,7 @@
> >  #include <linux/module.h>
> >  #include <linux/timekeeping.h>
> >  #include <linux/sched/idle.h>
> > +#include <linux/cpuidle_haltpoll.h>
> >  #define CREATE_TRACE_POINTS
> >  #include "cpuidle-haltpoll-trace.h"
> >  
> > @@ -157,11 +158,17 @@
> >  
> >  static int __init haltpoll_init(void)
> >  {
> > -	return cpuidle_register(&haltpoll_driver, NULL);
> > +	int ret = cpuidle_register(&haltpoll_driver, NULL);
> > +
> > +	if (ret == 0)
> > +		arch_haltpoll_enable();
> > +
> > +	return ret;
> >  }
> >  
> >  static void __exit haltpoll_exit(void)
> >  {
> > +	arch_haltpoll_disable();
> >  	cpuidle_unregister(&haltpoll_driver);
> >  }
> >  
> > Index: linux-2.6.git/include/linux/cpuidle_haltpoll.h
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6.git/include/linux/cpuidle_haltpoll.h	2019-06-03 19:41:57.293366260 -0300
> > @@ -0,0 +1,16 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _CPUIDLE_HALTPOLL_H
> > +#define _CPUIDLE_HALTPOLL_H
> > +
> > +#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
> > +#include <asm/cpuidle_haltpoll.h>
> > +#else
> > +static inline void arch_haltpoll_enable(void)
> > +{
> > +}
> > +
> > +static inline void arch_haltpoll_disable(void)
> > +{
> > +}
> > +#endif
> > +#endif
> > Index: linux-2.6.git/arch/x86/Kconfig
> > ===================================================================
> > --- linux-2.6.git.orig/arch/x86/Kconfig	2019-06-03 19:38:12.376619124 -0300
> > +++ linux-2.6.git/arch/x86/Kconfig	2019-06-03 19:42:34.478489868 -0300
> > @@ -787,6 +787,7 @@
> >  	bool "KVM Guest support (including kvmclock)"
> >  	depends on PARAVIRT
> >  	select PARAVIRT_CLOCK
> > +	select ARCH_CPUIDLE_HALTPOLL
> >  	default y
> >  	---help---
> >  	  This option enables various optimizations for running under the KVM
> > @@ -795,6 +796,12 @@
> >  	  underlying device model, the host provides the guest with
> >  	  timing infrastructure such as time of day, and system time
> >  
> > +config ARCH_CPUIDLE_HALTPOLL
> > +        def_bool n
> > +        proUmpt "Disable host haltpoll when loading haltpoll driver"
> > +        help
> > +	  If virtualized under KVM, disable host haltpoll.
> > +
> >  config PVH
> >  	bool "Support for running PVH guests"
> >  	---help---
> > Index: linux-2.6.git/arch/x86/kernel/kvm.c
> > ===================================================================
> > --- linux-2.6.git.orig/arch/x86/kernel/kvm.c	2019-06-03 19:38:12.376619124 -0300
> > +++ linux-2.6.git/arch/x86/kernel/kvm.c	2019-06-03 19:40:14.359024312 -0300
> > @@ -853,3 +853,43 @@
> >  }
> >  
> >  #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
> > +
> > +#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
> > +
> > +void kvm_disable_host_haltpoll(void *i)
> > +{
> > +	wrmsrl(MSR_KVM_POLL_CONTROL, 0);
> > +}
> > +
> > +void kvm_enable_host_haltpoll(void *i)
> > +{
> > +	wrmsrl(MSR_KVM_POLL_CONTROL, 1);
> > +}
> > +
> > +void arch_haltpoll_enable(void)
> > +{
> > +	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
> > +		return;
> > +
> 
> Perhaps warn the user when failing to disable host poll e.g.:
> 
> if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
> 	pr_warn_once("haltpoll: Failed to disable host halt polling\n");
> 	return;
> }
> 
> But I wonder whether we should fail to load cpuidle-haltpoll when host halt
> polling can't be disabled[*]? That is to avoid polling in both host and guest
> and *possibly* avoid chances for performance regressions when running on older
> hypervisors?
> 
> [*] with guest still able load with lack of host polling control via modparam

I don't think so. First, the driver reduces the halt poll interval when
the system is idle, so overhead is reduced to zero in such cases.

Moreover, when both host and guest side polling are performed, 
power might be wasted, but i haven't seen a significant 
performance regression caused by it.

Thanks.

> 
> > +	preempt_disable();
> > +	/* Enabling guest halt poll disables host halt poll */
> > +	kvm_disable_host_haltpoll(NULL);
> > +	smp_call_function(kvm_disable_host_haltpoll, NULL, 1);
> > +	preempt_enable();
> > +}
> > +EXPORT_SYMBOL_GPL(arch_haltpoll_enable);
> > +
> > +void arch_haltpoll_disable(void)
> > +{
> > +	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
> > +		return;
> > +
> > +	preempt_disable();
> > +	/* Enabling guest halt poll disables host halt poll */
> > +	kvm_enable_host_haltpoll(NULL);
> > +	smp_call_function(kvm_enable_host_haltpoll, NULL, 1);
> > +	preempt_enable();
> > +}
> > +
> > +EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
> > +#endif
> > 
