Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C191314B7
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 16:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgAFPUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 10:20:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30309 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726303AbgAFPUX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jan 2020 10:20:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578324022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g7E0AC1bvSC88k/8RhOdp34bUp0Xjvf3gVfON2Jbsuc=;
        b=GwQo0f4Ka5Y0LNlXMQmxc+A+ZF7YirGaqxMFLgDOVSnEOb8FPKU1fpA8FjCeU2Ozm6OYV3
        jRasEoqP6HqHx3e/nfV6qenG1/5nf7Vle8qS4ERJ+wuJduLYqtgKWz9QgnombpqKAq7i/D
        1geahKScyd/Hy98OCIHrH3ysPfmOC9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-0OiSu7dcPdmjo8Rhi-quxQ-1; Mon, 06 Jan 2020 10:20:20 -0500
X-MC-Unique: 0OiSu7dcPdmjo8Rhi-quxQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B47398C81E1;
        Mon,  6 Jan 2020 15:20:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 309557DB55;
        Mon,  6 Jan 2020 15:20:16 +0000 (UTC)
Date:   Mon, 6 Jan 2020 16:20:14 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/18] arm/arm64: psci: Don't run C
 code without stack or vectors
Message-ID: <20200106152014.m26yjqhvozl3mw6t@kamzik.brq.redhat.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-7-git-send-email-alexandru.elisei@arm.com>
 <20200102181121.6895344d@donnerap.cambridge.arm.com>
 <61ea7391-7e65-4548-17b6-7dbd977fa394@arm.com>
 <20200106114149.GB9630@lakrids.cambridge.arm.com>
 <20200106131716.qq2aitogv6u62n2n@kamzik.brq.redhat.com>
 <e5620b4a-c65b-34e6-a08c-b9c2f43be705@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5620b4a-c65b-34e6-a08c-b9c2f43be705@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 06, 2020 at 02:12:46PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On 1/6/20 1:17 PM, Andrew Jones wrote:
> > On Mon, Jan 06, 2020 at 11:41:49AM +0000, Mark Rutland wrote:
> >> On Mon, Jan 06, 2020 at 10:41:55AM +0000, Alexandru Elisei wrote:
> >>> On 1/2/20 6:11 PM, Andre Przywara wrote:
> >>>> On Tue, 31 Dec 2019 16:09:37 +0000
> >>>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >>>>> +.global asm_cpu_psci_cpu_die
> >>>>> +asm_cpu_psci_cpu_die:
> >>>>> +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
> >>>>> +	hvc	#0
> >>>>> +	b	.
> >>>> I am wondering if this implementation is actually too simple. Both
> >>>> the current implementation and the kernel clear at least the first
> >>>> three arguments to 0.
> >>>> I failed to find a requirement for doing this (nothing in the SMCCC
> >>>> or the PSCI spec), but I guess it would make sense when looking at
> >>>> forward compatibility.
> >>> The SMC calling convention only specifies the values for the arguments that are
> >>> used by a function, not the values for all possible arguments. kvm-unit-tests sets
> >>> the other arguments to 0 because the function prototype that does the actual SMC
> >>> call takes 4 arguments. The value 0 is a random value that was chosen for those
> >>> unused parameters. For example, it could have been a random number on each call.
> >> That's correct.
> >>
> >> A caller can leave arbitrary values in non-argument registers, in the
> >> same manner as a caller of an AAPCS function. The callee should not
> >> consume those values as they are not arguments.
> >>
> >>> Let me put it another way. Suggesting that unused arguments should be set to 0 is
> >>> the same as suggesting that normal C function that adheres to procedure call
> >>> standard for arm64 should always have 8 arguments, and for a particular function
> >>> that doesn't use all of them, they should be set to 0 by the caller.
> >> Heh, same rationale. :)
> > This is a good rationale for the function to not zero parameters.
> >
> >>> @Mark Rutland has worked on the SMC implementation for the Linux kernel, if he
> >>> wants to chime in on this.
> >>>
> >>> Thanks,
> >>> Alex
> >>>> At the very least it's a change in behaviour (ignoring the missing printf).
> >>>> So shall we just clear r1, r2 and r3 here? (Same for arm64 below)
> >> There's no need to zero non-argument registers, and it could potentially
> >> mask bugs in callees, so I don't think it's a good idea to do so.
> >>
> >> If you really want to test that the callee is robust and correct, it
> >> would be better to randomize the content of non-argument regsiters to
> >> fuzz the callee.
> >>
> > But this indicates there is risk that we'll be less robust if we don't
> > zero the parameters. Since this function is a common utility function and
> > kvm-unit-tests targets KVM, QEMU/tcg, and anything else that somebody
> > wants to try and target, then if there's any chance that zeroing unused
> > parameters is more robust, I believe we should do that here. If we want to
> 
> We agree that zero'ing unused parameters is not required by the specification,
> right?

Definitely

> After that, I think it depends how you see kvm-unit-tests. I am of the
> opinion that as a testing tool, if not zero'ing parameters (I'm not talking here
> about fuzzing) causes an error in whatever piece of software you are running, then
> that piece of software is not specification compliant and kvm-unit-tests has done
> its job.

We generally do our best to make sure the supporting code in the framework
is robust and fails cleanly (usually with asserts). If there's reason to
believe that the SUT may not implement a specification correctly, but we
have test results proving it at least works under certain constrains, then
we should probably keep the support code within those constraints. We can
also write independent test cases to check that the SUT implements the
specification completely. The reason for this approach is because not
every user of kvm-unit-tests is willing to debug a random, potentially
difficult to isolate failure when they're attempting to use the framework
to test something unrelated.

> 
> Either way, I'm not advocating changing our PSCI code. I'm fine with dropping this
> patch for now (I mentioned this in another thread), so we can resume this
> conversation when I rework it.

Sounds good. And, like I said, I can't speak to the risk of not zeroing.
Perhaps there's not enough concern here to bother with it. Maybe we could
write those PSCI fuzzing tests sooner than later, confirm that on a
reasonable sample of targets that there's no risk in not zeroing, and then
implement all supporting functions as we wish.

Thanks,
drew

> 
> Thanks,
> Alex
> > test/fuzz the PSCI/SMC emulation with kvm-unit-tests, then we can write
> > explicit test cases to do that.
> >
> > I can't speak to the risk of not zeroing, but due to the way we've been
> > calling PSCI functions with C, I can say up until now we always have.
> >
> > Thanks,
> > drew
> >
> 

