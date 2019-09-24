Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA993BD487
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 23:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437838AbfIXVrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 17:47:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395520AbfIXVrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 17:47:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1BCC185550;
        Tue, 24 Sep 2019 21:47:01 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2CC65B69A;
        Tue, 24 Sep 2019 21:46:58 +0000 (UTC)
Date:   Tue, 24 Sep 2019 17:46:57 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190924214657.GE4658@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923190514.GB19996@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 24 Sep 2019 21:47:01 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 03:05:14PM -0400, Andrea Arcangeli wrote:
> On Mon, Sep 23, 2019 at 11:57:57AM +0200, Paolo Bonzini wrote:
> > On 23/09/19 11:31, Vitaly Kuznetsov wrote:
> > > +#ifdef CONFIG_RETPOLINE
> > > +		if (exit_reason == EXIT_REASON_MSR_WRITE)
> > > +			return handle_wrmsr(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> > > +			return handle_preemption_timer(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
> > > +			return handle_interrupt_window(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> > > +			return handle_external_interrupt(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_HLT)
> > > +			return handle_halt(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
> > > +			return handle_pause(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_MSR_READ)
> > > +			return handle_rdmsr(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_CPUID)
> > > +			return handle_cpuid(vcpu);
> > > +		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> > > +			return handle_ept_misconfig(vcpu);
> > > +#endif
> > >  		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> > 
> > Most of these, while frequent, are already part of slow paths.
> > 
> > I would keep only EXIT_REASON_MSR_WRITE, EXIT_REASON_PREEMPTION_TIMER,
> > EXIT_REASON_EPT_MISCONFIG and add EXIT_REASON_IO_INSTRUCTION.
> 
> Intuition doesn't work great when it comes to CPU speculative
> execution runtime. I can however run additional benchmarks to verify
> your theory that keeping around frequent retpolines will still perform
> ok.

On one most recent CPU model there's no measurable difference with
your list or my list with a hrtimer workload (no cpuid). It's
challenging to measure any difference below 0.5%.

An artificial cpuid loop takes 1.5% longer to compute if I don't add
CPUID to the list, but that's just the measurement of the cost of
hitting a frequent retpoline in the exit reason handling code.

Thanks,
Andrea
