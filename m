Return-Path: <kvm+bounces-52617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 735AAB0743E
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29FA17AFB89
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6D02F3C19;
	Wed, 16 Jul 2025 11:05:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D6F2F0028;
	Wed, 16 Jul 2025 11:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752663956; cv=none; b=dTkXoMwH4Fw0h8CDeBxkJiRf2QttAG1rN72muXsvnsKUAgj+6Irx7wkZb4Ra9ktyMoWB/gpe3AaMueB2QZjY4rtWOnAQBQFt4M6Q7FYks7riV8yXUydqBkTqUTpHEDEcduAWgo9amG0KaOe0RDfP77DEyiLdcRmyStbTJWfdnDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752663956; c=relaxed/simple;
	bh=dyQYr4lv0y7IcIYqRyjYGKZ/D0kemm9xuT47filb00c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ek02jNWo8TMzDTt56DaFQQ8J1bzQGHljEuCB2N2ccNaq5XaNU4iBkniN4zdr/9Vll/0FH4Pzzy7ec65FU3NnQB472/pCO7hqEuZvt5KeF52LqUp+QGv7krKl5hqPrcV1sB5bKT2SrP/Qb81XTq6JSlT0f0Qxk0kCeGZ2A6eyldQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6766112FC;
	Wed, 16 Jul 2025 04:05:45 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 363A93F66E;
	Wed, 16 Jul 2025 04:05:51 -0700 (PDT)
Date: Wed, 16 Jul 2025 12:05:46 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] KVM: s390: Fix latent guest entry/exit bugs
Message-ID: <aHeHilsi8-Tr9_1D@J2N7QTR9R3>
References: <20250708092742.104309-1-ajd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708092742.104309-1-ajd@linux.ibm.com>

On Tue, Jul 08, 2025 at 07:27:40PM +1000, Andrew Donnellan wrote:
> In [0], the guest_{enter,exit}_irqoff() helpers were deprecated, in favour
> of guest_timing_{enter,exit}_irqoff() and
> guest_context_{enter,exit}_irqoff(). This was to fix a number of latent
> guest entry/exit bugs, relating to the enabling of interrupts during an
> RCU extended quiescent state, instrumentation code, and correct handling
> of lockdep and tracing.
> 
> However, while arm64, mips, riscv and x86 have been migrated to the new
> helpers, s390 hasn't been. There was an initial attempt at [1] to do this,
> but that didn't work for reasons discussed at [2].
> 
> Since then, Claudio Imbrenda has reworked much of the interrupt handling.
> Moving interrupt handling into vcpu_post_run() avoids the issues in [2],
> so we can now move to the new helpers.

Nice!

> I've rebased Mark's patches from [1]. kvm-unit-tests, the kvm selftests,
> and IBM's internal test suites pass under debug_defconfig.

I took a quick look at this and Claudio's preparatory work, and this all
looks like what I was hoping for back in one of the replies to [2]:

  https://lore.kernel.org/all/YerRbhqvJ5nEcQYT@FVFF77S0Q05N/

I am not aware of any additional problems, and this all looks good to
me. Thanks for picking this up!

Mark.

> These patches do introduce some overhead - in my testing, a few of the
> tests in the kvm-unit-tests exittime test suite appear 6-11% slower, but
> some noticeable overhead may be unavoidable (we introduce a new function
> call and the irq entry/exit paths change a bit).
> 
> [0] https://lore.kernel.org/lkml/20220201132926.3301912-1-mark.rutland@arm.com/
> [1] https://lore.kernel.org/all/20220119105854.3160683-7-mark.rutland@arm.com/
> [2] https://lore.kernel.org/all/a4a26805-3a56-d264-0a7e-60bed1ada9f3@linux.ibm.com/
> [3] https://lore.kernel.org/all/20241022120601.167009-1-imbrenda@linux.ibm.com/
> 
> Mark Rutland (2):
>   entry: Add arch_in_rcu_eqs()
>   KVM: s390: Rework guest entry logic
> 
>  arch/s390/include/asm/entry-common.h | 10 ++++++
>  arch/s390/include/asm/kvm_host.h     |  3 ++
>  arch/s390/kvm/kvm-s390.c             | 51 +++++++++++++++++++++-------
>  arch/s390/kvm/vsie.c                 | 17 ++++------
>  include/linux/entry-common.h         | 16 +++++++++
>  kernel/entry/common.c                |  3 +-
>  6 files changed, 77 insertions(+), 23 deletions(-)
> 
> -- 
> 2.50.0

