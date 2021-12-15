Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4064475775
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 12:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241993AbhLOLKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 06:10:51 -0500
Received: from foss.arm.com ([217.140.110.172]:48848 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241975AbhLOLKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 06:10:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57E1EED1;
        Wed, 15 Dec 2021 03:10:46 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.67.176])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D395B3F774;
        Wed, 15 Dec 2021 03:10:43 -0800 (PST)
Date:   Wed, 15 Dec 2021 11:10:38 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: Re: [PATCH v2 3/7] cpu/hotplug: Add dynamic parallel bringup states
 before CPUHP_BRINGUP_CPU
Message-ID: <YbnNLkXTOtFiDMpc@FVFF77S0Q05N>
References: <20211214123250.88230-1-dwmw2@infradead.org>
 <20211214123250.88230-4-dwmw2@infradead.org>
 <YbipFmlKSf1UuisZ@FVFF77S0Q05N>
 <d48f836d202d3b76b2a6cbaaf3d57f0c8077d986.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d48f836d202d3b76b2a6cbaaf3d57f0c8077d986.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021 at 08:32:29PM +0000, David Woodhouse wrote:
> On Tue, 2021-12-14 at 14:24 +0000, Mark Rutland wrote:
> > On Tue, Dec 14, 2021 at 12:32:46PM +0000, David Woodhouse wrote:
> > > From: David Woodhouse <
> > > dwmw@amazon.co.uk
> > > >
> > > 
> > > If the platform registers these states, bring all CPUs to each registered
> > > state in turn, before the final bringup to CPUHP_BRINGUP_CPU. This allows
> > > the architecture to parallelise the slow asynchronous tasks like sending
> > > INIT/SIPI and waiting for the AP to come to life.
> > > 
> > > There is a subtlety here: even with an empty CPUHP_BP_PARALLEL_DYN step,
> > > this means that *all* CPUs are brought through the prepare states and to
> > > CPUHP_BP_PREPARE_DYN before any of them are taken to CPUHP_BRINGUP_CPU
> > > and then are allowed to run for themselves to CPUHP_ONLINE.
> > > 
> > > So any combination of prepare/start calls which depend on A-B ordering
> > > for each CPU in turn, such as the X2APIC code which used to allocate a
> > > cluster mask 'just in case' and store it in a global variable in the
> > > prep stage, then potentially consume that preallocated structure from
> > > the AP and set the global pointer to NULL to be reallocated in
> > > CPUHP_X2APIC_PREPARE for the next CPU... would explode horribly.
> > > 
> > > We believe that X2APIC was the only such case, for x86. But this is why
> > > it remains an architecture opt-in. For now.
> > 
> > It might be worth elaborating with a non-x86 example, e.g.
> > 
> > >  We believe that X2APIC was the only such case, for x86. Other architectures
> > >  have similar requirements with global variables used during bringup (e.g.
> > >  `secondary_data` on arm/arm64), so architectures must opt-in for now.
> > 
> > ... so that we have a specific example of how unconditionally enabling this for
> > all architectures would definitely break things today.
> 
> I do not have such an example, and I do not know that it would
> definitely break things to turn it on for all architectures today.
> 
> The x2apic one is an example of why it *might* break random
> architectures and thus why it needs to be an architecture opt-in.

Ah; I had thought we did the `secondary_data` setup in a PREPARE step, and
hence it was a comparable example, but I was mistaken. Sorry for the noise!

> > FWIW, that's something I would like to cleanup for arm64 for general
> > robustness, and if that would make it possible for us to have parallel bringup
> > in future that would be a nice bonus.
> 
> Yes. But although I lay the groundwork here, the arch can't *actually*
> do parallel bringup without some arch-specific work, so auditing the
> pre-bringup states is the easy part. :)

Sure; that was trying to be a combination of:

* This looks nice, I'd like to use this (eventually) on arm64.

* I'm aware of some arm64-specific groundwork we need to do before arm64 can
  use this.

So I think we're agreed. :)

Thanks,
Mark.
