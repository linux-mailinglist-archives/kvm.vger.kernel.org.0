Return-Path: <kvm+bounces-65818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B85FCB887B
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 10:51:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 221B6304D4BC
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 09:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4745315D27;
	Fri, 12 Dec 2025 09:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="GCrClX8B"
X-Original-To: kvm@vger.kernel.org
Received: from out28-124.mail.aliyun.com (out28-124.mail.aliyun.com [115.124.28.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FC0226CEB;
	Fri, 12 Dec 2025 09:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765532821; cv=none; b=n/khL2I6X7o/MdnT6Ux5q8mtTKkUT0Oi7b0rl5XaKJuJA2fQmhH1uqlFkwQ4gH8eNbE3KVSPR83mPbPwE3agj04SGBkvWnrIgSZ1r3NatFJXVRoTJZSWiZa5OIsx2VtmfakU1hIJijc4S1aHSHmOHM4ts+aEsnlMBTiWtGE+NkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765532821; c=relaxed/simple;
	bh=6ljWjY7QInJuwIP00LkKDNlaUhyiL5ghfGGqKB47JZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFJBLbhu3rWcZJ4pTI4ZrmF4d6FVJ9NQB6rXFVRjD1kjqKkBfz2nQ4AU4qV1DMv6GHDVtWQGWSMRbwXSQRNcVkYbh5Ia/cpNQmT2NQHH8fULVWXRAISvf1gR2eCmdOx6OCCC7EwpKyLCvszXC7vRxfd780ijDbiIKcxGCgenq18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=GCrClX8B; arc=none smtp.client-ip=115.124.28.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1765532808; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=j+NGea2KtRM7UvaPj4+WtGu8L5jh5rI5T/Jdabn7S04=;
	b=GCrClX8BpgAhWDUlDtnawknNNjX7Vjf0vYJhBien1V+52Rygoekhuww0JcfMJe+svZoi6VhwmM5QgpnaxLyNVCPLZyH3WEX7vjuKlv2bCMnDDPW3pjdNWSwn+xehpRbyoVPuAd2/b5deXtltDiixN3qwRompuXbFx5rytLUSIYs=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.filx.95_1765532807 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 12 Dec 2025 17:46:47 +0800
Date: Fri, 12 Dec 2025 17:46:47 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] KVM: x86: Consolidate KVM_GUESTDBG_SINGLESTEP check
 into the kvm_inject_emulated_db()
Message-ID: <20251212094647.GA65305@k08j02272.eu95sqa>
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
 <45cbc005e14ea2a4b9ec803a91af63e364aeb71a.1757416809.git.houwenlong.hwl@antgroup.com>
 <aTMdLPvT3gywUY6F@google.com>
 <20251211140520.GC42509@k08j02272.eu95sqa>
 <aTr9Kx9PjLuV9bi1@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTr9Kx9PjLuV9bi1@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Dec 11, 2025 at 09:19:39AM -0800, Sean Christopherson wrote:
> On Thu, Dec 11, 2025, Hou Wenlong wrote:
> > On Fri, Dec 05, 2025 at 09:58:04AM -0800, Sean Christopherson wrote:
> > > But I think the WARN will be subject to false positives.  KVM doesn't emulate data
> > > #DBs, but it does emulate code #DBs, and fault-like code #DBs can be coincident
> > > with trap-like single-step #DBs.  Ah, but kvm_vcpu_check_code_breakpoint() doesn't
> > > account for RFLAGS.TF.  That should probably be addressed in this series, especially
> > > since it's consolidating KVM_GUESTDBG_SINGLESTEP handling.
> >
> > Sorry, I didn't follow it, how fault-like code #DBs can be coincident
> > with trap-like single-step #DBs, could you provide an example?
> 
> Ya, here's a KUT testcase that applies on top of
> https://lore.kernel.org/all/20251126191736.907963-1-seanjc@google.com.
>
Thanks for your testcase; it really changed my perspective.
 
> ---
>  x86/debug.c | 43 +++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/x86/debug.c b/x86/debug.c
> index 8177575c..313d854e 100644
> --- a/x86/debug.c
> +++ b/x86/debug.c
> @@ -92,6 +92,7 @@ typedef unsigned long (*db_test_fn)(void);
>  typedef void (*db_report_fn)(unsigned long, const char *);
>  
>  static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void);
> +static unsigned long singlestep_with_code_db(void);
>  static unsigned long singlestep_with_sti_hlt(void);
>  
>  static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
> @@ -106,11 +107,12 @@ static void __run_single_step_db_test(db_test_fn test, db_report_fn report_fn)
>  	report_fn(start, "");
>  
>  	/*
> -	 * MOV DR #GPs at CPL>0, don't try to run the DR7.GD test in usermode.
> -	 * Likewise for HLT.
> +	 * MOV DR #GPs at CPL>0, don't try to run the DR7.GD or code #DB tests
> +	 * in usermode. Likewise for HLT.
>  	 */
> -	if (test == singlestep_with_movss_blocking_and_dr7_gd
> -	    || test == singlestep_with_sti_hlt)
> +	if (test == singlestep_with_movss_blocking_and_dr7_gd ||
> +	    test == singlestep_with_code_db ||
> +	    test == singlestep_with_sti_hlt)
>  		return;
>  
>  	n = 0;
> @@ -163,6 +165,38 @@ static noinline unsigned long singlestep_basic(void)
>  	return start;
>  }
>  
> +static void report_singlestep_with_code_db(unsigned long start, const char *usermode)
> +{
> +	report(n == 3 &&
> +	       dr6[0] == (DR6_ACTIVE_LOW | DR6_BS | DR6_TRAP2) && db_addr[0] == start &&
> +	       is_single_step_db(dr6[1]) && db_addr[1] == start + 1 &&
> +	       is_single_step_db(dr6[2]) && db_addr[2] == start + 1 + 1,
> +	       "%sSingle-step + code #DB test", usermode);
> +}
> +
> +static noinline unsigned long singlestep_with_code_db(void)
> +{
> +	unsigned long start;
> +
> +	asm volatile (
> +		"lea 1f(%%rip), %0\n\t"
> +		"mov %0, %%dr2\n\t"
> +		"mov $" xstr(DR7_FIXED_1 | DR7_EXECUTE_DRx(2) | DR7_GLOBAL_ENABLE_DR2) ", %0\n\t"
> +		"mov %0, %%dr7\n\t"
> +		"pushf\n\t"
> +		"pop %%rax\n\t"
> +		"or $(1<<8),%%rax\n\t"
> +		"push %%rax\n\t"
> +		"popf\n\t"
> +		"and $~(1<<8),%%rax\n\t"
In my previous understanding, I thought there would be two #DBs
generated at the instruction boundary. First, the single-step trap #DB
would be handled, and then, when resuming to start the new instruction,
it would check for the code breakpoint and generate a code fault #DB.
However, it turns out that the check for the code breakpoint happened
before the instruction boundary. I also see in the kernel hardware
breakpoint handler that it notes that code breakpoints and single-step
can be detected together. Is this due to instruction prefetch?

If we want to emulate the hardware behavior in the emulator, does that
mean we need to check for code breakpoints in kvm_vcpu_do_single_step()
and set the DR_TRAP_BITS along with the DR6_BS bit?

Thanks!

> +		"1:push %%rax\n\t"
> +		"popf\n\t"
> +		"lea 1b(%%rip), %0\n\t"
> +		: "=r" (start) : : "rax"
> +	);
> +	return start;
> +}
> +
>  static void report_singlestep_emulated_instructions(unsigned long start,
>  						    const char *usermode)
>  {
> @@ -517,6 +551,7 @@ int main(int ac, char **av)
>  	       n, db_addr[0], dr6[0]);
>  
>  	run_ss_db_test(singlestep_basic);
> +	run_ss_db_test(singlestep_with_code_db);
>  	run_ss_db_test(singlestep_emulated_instructions);
>  	run_ss_db_test(singlestep_with_sti_blocking);
>  	run_ss_db_test(singlestep_with_movss_blocking);
> 
> base-commit: 23071a886edbe303fb964c5c386750b0b458dbfb
> --

