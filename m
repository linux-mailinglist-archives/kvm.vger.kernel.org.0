Return-Path: <kvm+bounces-65105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A613FC9B7A0
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 13:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8CCC73490BE
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 12:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F265431329C;
	Tue,  2 Dec 2025 12:21:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0135B3101B6
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 12:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764678084; cv=none; b=ujS6xVJw7vaf9jm1spwmaHT6+ADGYtor5zBJmMWs6MsqA+cxhu4EJnB9HadL+AgXimh4dnww/f160mSMbWd9VFgs58x58lVvGC4MsBgw5AJXaXyExEid820Y7OzB+yLFKdD7ZA5RLOla5NeyYAqOGTeXdWt6HFPDx8h8eAV2gx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764678084; c=relaxed/simple;
	bh=UseOUG3kLjCVjpdnzT2Eet3VXzUGg1JGq1FiykszZDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtJnl2pKPdlnKm3A52jExSPlYL0aDjEWV/qZRNy82J8f+KulGgHBWfLHrwHx4PRUPghUAhuYu+O9TkBCeUuTUq+zYE09aDsElFgqiEvjUzJf5ve9bgGSMOzZNylVBHpxsG+23PCuhXCf6PKP98J/3bsbB1fkMFHaCp31wfwkcqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E86F7153B;
	Tue,  2 Dec 2025 04:21:14 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 065963F73B;
	Tue,  2 Dec 2025 04:21:20 -0800 (PST)
Date: Tue, 2 Dec 2025 12:21:15 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 07/10] arm64: selftest: update test for
 running at EL2
Message-ID: <20251202122115.GA3921791@e124191.cambridge.arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-8-joey.gouly@arm.com>
 <5160dadb-1ff3-487e-bd0b-9f643c3d9ec3@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5160dadb-1ff3-487e-bd0b-9f643c3d9ec3@redhat.com>

On Tue, Dec 02, 2025 at 10:16:42AM +0100, Eric Auger wrote:
> 
> 
> On 9/25/25 4:19 PM, Joey Gouly wrote:
> > From: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > Remove some hard-coded assumptions that this test is running at EL1.
> >
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > ---
> >  arm/selftest.c | 18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/arm/selftest.c b/arm/selftest.c
> > index 1553ed8e..01691389 100644
> > --- a/arm/selftest.c
> > +++ b/arm/selftest.c
> > @@ -232,6 +232,7 @@ static void user_psci_system_off(struct pt_regs *regs)
> >  	__user_psci_system_off();
> >  }
> >  #elif defined(__aarch64__)
> > +static unsigned long expected_level;
> >  
> >  /*
> >   * Capture the current register state and execute an instruction
> > @@ -276,8 +277,7 @@ static bool check_regs(struct pt_regs *regs)
> >  {
> >  	unsigned i;
> >  
> > -	/* exception handlers should always run in EL1 */
> > -	if (current_level() != CurrentEL_EL1)
> > +	if (current_level() != expected_level)
> >  		return false;
> >  
> >  	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
> > @@ -301,7 +301,11 @@ static enum vector check_vector_prep(void)
> >  		return EL0_SYNC_64;
> >  
> >  	asm volatile("mrs %0, daif" : "=r" (daif) ::);
> > -	expected_regs.pstate = daif | PSR_MODE_EL1h;
> > +	expected_regs.pstate = daif;
> > +	if (current_level() == CurrentEL_EL1)
> > +		expected_regs.pstate |= PSR_MODE_EL1h;
> > +	else
> > +		expected_regs.pstate |= PSR_MODE_EL2h;
> >  	return EL1H_SYNC;
> >  }
> >  
> > @@ -317,8 +321,8 @@ static bool check_und(void)
> >  
> >  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
> >  
> > -	/* try to read an el2 sysreg from el0/1 */
> > -	test_exception("", "mrs x0, sctlr_el2", "", "x0");
> > +	/* try to read an el3 sysreg from el0/1/2 */
> > +	test_exception("", "mrs x0, sctlr_el3", "", "x0");
> >  
> >  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
> >  
> > @@ -429,6 +433,10 @@ int main(int argc, char **argv)
> >  	if (argc < 2)
> >  		report_abort("no test specified");
> >  
> > +#if defined(__aarch64__)
> > +	expected_level = current_level();
> nit I would directly use current_level() in the calling function,
> check_regs() to avoid that #ifdef

I can't move it into check_regs() because that's what's checking the exception
level of the handler is what the expected_level is.

Something like this (untested) would work:

diff --git a/arm/selftest.c b/arm/selftest.c
index 01691389..f173bc99 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -215,6 +215,7 @@ static void pabt_handler(struct pt_regs *regs)
 
 static bool check_pabt(void)
 {
+       expected_level = current_level();
        install_exception_handler(EXCPTN_PABT, pabt_handler);
 
        test_exception("ldr     r9, =check_pabt_invalid_paddr\n"
@@ -318,6 +319,7 @@ static void unknown_handler(struct pt_regs *regs, unsigned int esr __unused)
 static bool check_und(void)
 {
        enum vector v = check_vector_prep();
+       expected_level = current_level();
 
        install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
 
@@ -340,6 +342,7 @@ static void svc_handler(struct pt_regs *regs, unsigned int esr)
 static bool check_svc(void)
 {
        enum vector v = check_vector_prep();
+       expected_level = current_level();
 
        install_exception_handler(v, ESR_EL1_EC_SVC64, svc_handler);
 
@@ -433,10 +436,6 @@ int main(int argc, char **argv)
        if (argc < 2)
                report_abort("no test specified");
 
-#if defined(__aarch64__)
-       expected_level = current_level();
-#endif
-
        report_prefix_push(argv[1]);
 
        if (strcmp(argv[1], "setup") == 0) {

Is that preferable than an #ifdef?

Thanks,
Joey
> 
> Eric
> > +#endif
> > +
> >  	report_prefix_push(argv[1]);
> >  
> >  	if (strcmp(argv[1], "setup") == 0) {
> 

