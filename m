Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6B23BA34E
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhGBQlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 12:41:16 -0400
Received: from foss.arm.com ([217.140.110.172]:50774 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhGBQlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 12:41:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45060147A;
        Fri,  2 Jul 2021 09:38:43 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.15.239])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94E3C3F5A1;
        Fri,  2 Jul 2021 09:38:38 -0700 (PDT)
Date:   Fri, 2 Jul 2021 17:38:36 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Joe Perches <joe@perches.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Zhu Lingshan <lingshan.zhu@intel.com>, wanpengli@tencent.com,
        Like Xu <like.xu@linux.intel.com>, eranian@google.com,
        weijiang.yang@intel.com, Guo Ren <guoren@kernel.org>,
        linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com,
        ak@linux.intel.com, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, joro@8bytes.org, x86@kernel.org,
        linux-csky@vger.kernel.org, wei.w.wang@intel.com,
        xen-devel@lists.xenproject.org, liuxiangdong5@huawei.com,
        bp@alien8.de, Paul Walmsley <paul.walmsley@sifive.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org, jmattson@google.com,
        like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>,
        seanjc@google.com, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <20210702163836.GB94260@C02TD0UTHF1T.local>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-2-lingshan.zhu@intel.com>
 <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
 <7379289718c6826dd1affec5824b749be2aee0a4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7379289718c6826dd1affec5824b749be2aee0a4.camel@perches.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 09:00:22AM -0700, Joe Perches wrote:
> On Fri, 2021-07-02 at 13:22 +0200, Peter Zijlstra wrote:
> > On Tue, Jun 22, 2021 at 05:42:49PM +0800, Zhu Lingshan wrote:
> > > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> []
> > > @@ -90,6 +90,27 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
> > >   */
> > >  DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs);
> > >  
> > > 
> > > +DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
> > > +DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
> > > +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
> > > +
> > > +void arch_perf_update_guest_cbs(void)
> > > +{
> > > +	static_call_update(x86_guest_state, (void *)&__static_call_return0);
> > > +	static_call_update(x86_guest_get_ip, (void *)&__static_call_return0);
> > > +	static_call_update(x86_guest_handle_intel_pt_intr, (void *)&__static_call_return0);
> > > +
> > > +	if (perf_guest_cbs && perf_guest_cbs->state)
> > > +		static_call_update(x86_guest_state, perf_guest_cbs->state);
> > > +
> > > +	if (perf_guest_cbs && perf_guest_cbs->get_ip)
> > > +		static_call_update(x86_guest_get_ip, perf_guest_cbs->get_ip);
> > > +
> > > +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
> > > +		static_call_update(x86_guest_handle_intel_pt_intr,
> > > +				   perf_guest_cbs->handle_intel_pt_intr);
> > > +}
> > 
> > Coding style wants { } on that last if().
> 
> That's just your personal preference.
> 
> The coding-style document doesn't require that.
> 
> It just says single statement.  It's not the number of
> vertical lines or characters required for the statement.
> 
> ----------------------------------
> 
> Do not unnecessarily use braces where a single statement will do.
> 
> .. code-block:: c
> 
> 	if (condition)
> 		action();
> 
> and
> 
> .. code-block:: none
> 
> 	if (condition)
> 		do_this();
> 	else
> 		do_that();
> 
> This does not apply if only one branch of a conditional statement is a single
> statement; in the latter case use braces in both branches:

Immediately after this, we say:

| Also, use braces when a loop contains more than a single simple statement:
|
| .. code-block:: c
| 
|         while (condition) {
|                 if (test)
|                         do_something();
|         }
| 

... and while that says "a loop", the principle is obviously supposed to
apply to conditionals too; structurally they're no different. We should
just fix the documentation to say "a loop or conditional", or something
to that effect.

Mark.
