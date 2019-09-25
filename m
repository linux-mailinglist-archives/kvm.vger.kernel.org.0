Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87674BE6AA
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 22:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390283AbfIYUvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 16:51:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387977AbfIYUvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 16:51:31 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 20C5D8AC6F5;
        Wed, 25 Sep 2019 20:51:31 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C303B10018F8;
        Wed, 25 Sep 2019 20:51:28 +0000 (UTC)
Date:   Wed, 25 Sep 2019 16:51:28 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190925205128.GB13637@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <E8FE7592-69C3-455E-8D80-A2D73BB2E14C@dinechin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E8FE7592-69C3-455E-8D80-A2D73BB2E14C@dinechin.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Wed, 25 Sep 2019 20:51:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 01:03:32PM +0200, Christophe de Dinechin wrote:
> 
> 
> > On 23 Sep 2019, at 11:31, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > 
> > Andrea Arcangeli <aarcange@redhat.com <mailto:aarcange@redhat.com>> writes:
> > 
> >> It's enough to check the exit value and issue a direct call to avoid
> >> the retpoline for all the common vmexit reasons.
> >> 
> >> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> >> ---
> >> arch/x86/kvm/vmx/vmx.c | 24 ++++++++++++++++++++++--
> >> 1 file changed, 22 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >> index a6e597025011..9aa73e216df2 100644
> >> --- a/arch/x86/kvm/vmx/vmx.c
> >> +++ b/arch/x86/kvm/vmx/vmx.c
> >> @@ -5866,9 +5866,29 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> >> 	}
> >> 
> >> 	if (exit_reason < kvm_vmx_max_exit_handlers
> >> -	    && kvm_vmx_exit_handlers[exit_reason])
> >> +	    && kvm_vmx_exit_handlers[exit_reason]) {
> >> +#ifdef CONFIG_RETPOLINE
> >> +		if (exit_reason == EXIT_REASON_MSR_WRITE)
> >> +			return handle_wrmsr(vcpu);
> >> +		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> >> +			return handle_preemption_timer(vcpu);
> >> +		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
> >> +			return handle_interrupt_window(vcpu);
> >> +		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> >> +			return handle_external_interrupt(vcpu);
> >> +		else if (exit_reason == EXIT_REASON_HLT)
> >> +			return handle_halt(vcpu);
> >> +		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
> >> +			return handle_pause(vcpu);
> >> +		else if (exit_reason == EXIT_REASON_MSR_READ)
> >> +			return handle_rdmsr(vcpu);
> >> +		else if (exit_reason == EXIT_REASON_CPUID)
> >> +			return handle_cpuid(vcpu);
> >> +		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> >> +			return handle_ept_misconfig(vcpu);
> >> +#endif
> >> 		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> > 
> > I agree with the identified set of most common vmexits, however, this
> > still looks a bit random. Would it be too much if we get rid of
> > kvm_vmx_exit_handlers completely replacing this code with one switch()?
> 
> Not sure, but if you do that, won’t the compiler generate a table and
> bring you back to square one? Or is there a reason why the mitigation
> is not needed for tables and indirect branches generated from switch
> statements?

When the kernel is built with retpolines the compiler is forbidden to
use a table for any switch. I pointed out the relevant commit earlier
in this thread. Instead the compiler will still try to bisect the
exit_reason trying to make the cost more equal for all exit_reason and
to reduce the number of checks, but we know the most likely exits so
it should be better to prioritize the most frequent exit reasons.

Thanks,
Andrea
