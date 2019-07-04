Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A045F723
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 13:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfGDLOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 07:14:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbfGDLOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 07:14:17 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6AAF9C057F3B;
        Thu,  4 Jul 2019 11:14:10 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 288AB1001B16;
        Thu,  4 Jul 2019 11:14:08 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 363A110516E;
        Thu,  4 Jul 2019 08:13:46 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x64BDfL3001599;
        Thu, 4 Jul 2019 08:13:41 -0300
Date:   Thu, 4 Jul 2019 08:13:41 -0300
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
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-pm@vger.kernel.org
Subject: Re: [patch 1/5] add cpuidle-haltpoll driver
Message-ID: <20190704111341.GA1249@amt.cnet>
References: <20190703235124.783034907@amt.cnet>
 <20190703235828.340866829@amt.cnet>
 <db95f834-0307-813a-323c-c5e23c90e3f5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db95f834-0307-813a-323c-c5e23c90e3f5@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 04 Jul 2019 11:14:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 04, 2019 at 10:16:47AM +0100, Joao Martins wrote:
> On 7/4/19 12:51 AM, Marcelo Tosatti wrote:
> > +++ linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle-haltpoll.c
> > @@ -0,0 +1,69 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * cpuidle driver for haltpoll governor.
> > + *
> > + * Copyright 2019 Red Hat, Inc. and/or its affiliates.
> > + *
> > + * This work is licensed under the terms of the GNU GPL, version 2.  See
> > + * the COPYING file in the top-level directory.
> > + *
> > + * Authors: Marcelo Tosatti <mtosatti@redhat.com>
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/cpuidle.h>
> > +#include <linux/module.h>
> > +#include <linux/sched/idle.h>
> > +#include <linux/kvm_para.h>
> > +
> > +static int default_enter_idle(struct cpuidle_device *dev,
> > +			      struct cpuidle_driver *drv, int index)
> > +{
> > +	if (current_clr_polling_and_test()) {
> > +		local_irq_enable();
> > +		return index;
> > +	}
> > +	default_idle();
> > +	return index;
> > +}
> > +
> > +static struct cpuidle_driver haltpoll_driver = {
> > +	.name = "haltpoll",
> > +	.owner = THIS_MODULE,
> > +	.states = {
> > +		{ /* entry 0 is for polling */ },
> > +		{
> > +			.enter			= default_enter_idle,
> > +			.exit_latency		= 1,
> > +			.target_residency	= 1,
> > +			.power_usage		= -1,
> > +			.name			= "haltpoll idle",
> > +			.desc			= "default architecture idle",
> > +		},
> > +	},
> > +	.safe_state_index = 0,
> > +	.state_count = 2,
> > +};
> > +
> > +static int __init haltpoll_init(void)
> > +{
> > +	struct cpuidle_driver *drv = &haltpoll_driver;
> > +
> > +	cpuidle_poll_state_init(drv);
> > +
> > +	if (!kvm_para_available())
> > +		return 0;
> > +
> 
> Isn't this meant to return -ENODEV value if the module is meant to not load?

Well, the cpuidle drivers return an error only if registration fails.

> Also this check should probably be placed before initializing the poll state,
> provided poll state isn't used anyways if you're not a kvm guest.

Poll state init is only local variable initialization, it does not
have any external effect.
