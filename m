Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89E2131175
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 12:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgAFLgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 06:36:31 -0500
Received: from foss.arm.com ([217.140.110.172]:43156 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgAFLga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 06:36:30 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D415328;
        Mon,  6 Jan 2020 03:36:30 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E7783F534;
        Mon,  6 Jan 2020 03:36:29 -0800 (PST)
Date:   Mon, 6 Jan 2020 11:36:22 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/18] arm/arm64: psci: Don't run C
 code without stack or vectors
Message-ID: <20200106113622.GA9630@lakrids.cambridge.arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-7-git-send-email-alexandru.elisei@arm.com>
 <20200102181121.6895344d@donnerap.cambridge.arm.com>
 <61ea7391-7e65-4548-17b6-7dbd977fa394@arm.com>
 <20200106111716.692c949f@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106111716.692c949f@donnerap.cambridge.arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 06, 2020 at 11:17:16AM +0000, Andre Przywara wrote:
> On Mon, 6 Jan 2020 10:41:55 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> > Hi Andre,
> > 
> > Thank you for reviewing the patches!
> > 
> > On 1/2/20 6:11 PM, Andre Przywara wrote:
> > >> +.global asm_cpu_psci_cpu_die
> > >> +asm_cpu_psci_cpu_die:
> > >> +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
> > >> +	hvc	#0
> > >> +	b	.  
> > > I am wondering if this implementation is actually too simple. Both
> > > the current implementation and the kernel clear at least the first
> > > three arguments to 0.  I failed to find a requirement for doing
> > > this (nothing in the SMCCC or the PSCI spec), but I guess it would
> > > make sense when looking at forward compatibility.  

This is a Linux implementation detail, and is not intended to be an
SMCCC contract detail. To be generic to all SMCCC calls, the invocation
functions have to take the largest set of potential arguments, and
callers have to pass /something/ for the unused values.

It would be perfectly valid for callers to pass the result of
get_random_long() instead. The SMCCC implementation should not derive
any meaning from registers which are not arguments to the call in
question.

> > The SMC calling convention only specifies the values for the arguments that are
> > used by a function, not the values for all possible arguments. kvm-unit-tests sets
> > the other arguments to 0 because the function prototype that does the actual SMC
> > call takes 4 arguments. The value 0 is a random value that was chosen for those
> > unused parameters. For example, it could have been a random number on each call.
> > 
> > Let me put it another way. Suggesting that unused arguments should be set to 0 is
> > the same as suggesting that normal C function that adheres to procedure call
> > standard for arm64 should always have 8 arguments, and for a particular function
> > that doesn't use all of them, they should be set to 0 by the caller.
> 
> I understand that, but was wondering if the SMCCC would mandate
> stricter requirements. After all every PSCI call from Linux goes
> through a function which clears all unused input parameters.

Callers are not deliberately clearingh the unused parameters, but rather
passing arbitrary values because they are forced to.

Thanks,
Mark.
