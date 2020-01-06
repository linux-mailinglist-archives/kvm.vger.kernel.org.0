Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 123031312B1
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 14:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgAFNR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 08:17:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726340AbgAFNRY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jan 2020 08:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578316643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Kp1/toVR1oRinTXnjr4t9/BWu9zh7Vzh2O7pDzwFrZ8=;
        b=DSPl/D3vhHzbPLYe4cWvVc+zpeAN+nOA7Pf8O5/3szYoDxzu1EORXvDcyIDC4ipiz3e3Oh
        wYsnWr3R0GsrGtERdHPQLND7DxXRxE2vH//s/kIcgFFiYc+rdDNR8nMkbXuJUM3D6CCr50
        8JbKy3wd2O87IkPUsFvEzr1uz2MlW0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-ZZawUmruMwGRyM0oEXKL_w-1; Mon, 06 Jan 2020 08:17:21 -0500
X-MC-Unique: ZZawUmruMwGRyM0oEXKL_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81CE7800D4E;
        Mon,  6 Jan 2020 13:17:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E093960E1C;
        Mon,  6 Jan 2020 13:17:18 +0000 (UTC)
Date:   Mon, 6 Jan 2020 14:17:16 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/18] arm/arm64: psci: Don't run C
 code without stack or vectors
Message-ID: <20200106131716.qq2aitogv6u62n2n@kamzik.brq.redhat.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-7-git-send-email-alexandru.elisei@arm.com>
 <20200102181121.6895344d@donnerap.cambridge.arm.com>
 <61ea7391-7e65-4548-17b6-7dbd977fa394@arm.com>
 <20200106114149.GB9630@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106114149.GB9630@lakrids.cambridge.arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 06, 2020 at 11:41:49AM +0000, Mark Rutland wrote:
> On Mon, Jan 06, 2020 at 10:41:55AM +0000, Alexandru Elisei wrote:
> > On 1/2/20 6:11 PM, Andre Przywara wrote:
> > > On Tue, 31 Dec 2019 16:09:37 +0000
> > > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > >> +.global asm_cpu_psci_cpu_die
> > >> +asm_cpu_psci_cpu_die:
> > >> +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
> > >> +	hvc	#0
> > >> +	b	.
> > > I am wondering if this implementation is actually too simple. Both
> > > the current implementation and the kernel clear at least the first
> > > three arguments to 0.
> > > I failed to find a requirement for doing this (nothing in the SMCCC
> > > or the PSCI spec), but I guess it would make sense when looking at
> > > forward compatibility.
> > 
> > The SMC calling convention only specifies the values for the arguments that are
> > used by a function, not the values for all possible arguments. kvm-unit-tests sets
> > the other arguments to 0 because the function prototype that does the actual SMC
> > call takes 4 arguments. The value 0 is a random value that was chosen for those
> > unused parameters. For example, it could have been a random number on each call.
> 
> That's correct.
> 
> A caller can leave arbitrary values in non-argument registers, in the
> same manner as a caller of an AAPCS function. The callee should not
> consume those values as they are not arguments.
> 
> > Let me put it another way. Suggesting that unused arguments should be set to 0 is
> > the same as suggesting that normal C function that adheres to procedure call
> > standard for arm64 should always have 8 arguments, and for a particular function
> > that doesn't use all of them, they should be set to 0 by the caller.
> 
> Heh, same rationale. :)

This is a good rationale for the function to not zero parameters.

> 
> > @Mark Rutland has worked on the SMC implementation for the Linux kernel, if he
> > wants to chime in on this.
> > 
> > Thanks,
> > Alex
> > > At the very least it's a change in behaviour (ignoring the missing printf).
> > > So shall we just clear r1, r2 and r3 here? (Same for arm64 below)
> 
> There's no need to zero non-argument registers, and it could potentially
> mask bugs in callees, so I don't think it's a good idea to do so.
> 
> If you really want to test that the callee is robust and correct, it
> would be better to randomize the content of non-argument regsiters to
> fuzz the callee.
>

But this indicates there is risk that we'll be less robust if we don't
zero the parameters. Since this function is a common utility function and
kvm-unit-tests targets KVM, QEMU/tcg, and anything else that somebody
wants to try and target, then if there's any chance that zeroing unused
parameters is more robust, I believe we should do that here. If we want to
test/fuzz the PSCI/SMC emulation with kvm-unit-tests, then we can write
explicit test cases to do that.

I can't speak to the risk of not zeroing, but due to the way we've been
calling PSCI functions with C, I can say up until now we always have.

Thanks,
drew

