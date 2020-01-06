Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2A0131182
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 12:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgAFLlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 06:41:53 -0500
Received: from foss.arm.com ([217.140.110.172]:43200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgAFLlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 06:41:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5634328;
        Mon,  6 Jan 2020 03:41:52 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B65C53F534;
        Mon,  6 Jan 2020 03:41:51 -0800 (PST)
Date:   Mon, 6 Jan 2020 11:41:49 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/18] arm/arm64: psci: Don't run C
 code without stack or vectors
Message-ID: <20200106114149.GB9630@lakrids.cambridge.arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-7-git-send-email-alexandru.elisei@arm.com>
 <20200102181121.6895344d@donnerap.cambridge.arm.com>
 <61ea7391-7e65-4548-17b6-7dbd977fa394@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61ea7391-7e65-4548-17b6-7dbd977fa394@arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 06, 2020 at 10:41:55AM +0000, Alexandru Elisei wrote:
> On 1/2/20 6:11 PM, Andre Przywara wrote:
> > On Tue, 31 Dec 2019 16:09:37 +0000
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >> +.global asm_cpu_psci_cpu_die
> >> +asm_cpu_psci_cpu_die:
> >> +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
> >> +	hvc	#0
> >> +	b	.
> > I am wondering if this implementation is actually too simple. Both
> > the current implementation and the kernel clear at least the first
> > three arguments to 0.
> > I failed to find a requirement for doing this (nothing in the SMCCC
> > or the PSCI spec), but I guess it would make sense when looking at
> > forward compatibility.
> 
> The SMC calling convention only specifies the values for the arguments that are
> used by a function, not the values for all possible arguments. kvm-unit-tests sets
> the other arguments to 0 because the function prototype that does the actual SMC
> call takes 4 arguments. The value 0 is a random value that was chosen for those
> unused parameters. For example, it could have been a random number on each call.

That's correct.

A caller can leave arbitrary values in non-argument registers, in the
same manner as a caller of an AAPCS function. The callee should not
consume those values as they are not arguments.

> Let me put it another way. Suggesting that unused arguments should be set to 0 is
> the same as suggesting that normal C function that adheres to procedure call
> standard for arm64 should always have 8 arguments, and for a particular function
> that doesn't use all of them, they should be set to 0 by the caller.

Heh, same rationale. :)

> @Mark Rutland has worked on the SMC implementation for the Linux kernel, if he
> wants to chime in on this.
> 
> Thanks,
> Alex
> > At the very least it's a change in behaviour (ignoring the missing printf).
> > So shall we just clear r1, r2 and r3 here? (Same for arm64 below)

There's no need to zero non-argument registers, and it could potentially
mask bugs in callees, so I don't think it's a good idea to do so.

If you really want to test that the callee is robust and correct, it
would be better to randomize the content of non-argument regsiters to
fuzz the callee.

Thanks,
Mark.
