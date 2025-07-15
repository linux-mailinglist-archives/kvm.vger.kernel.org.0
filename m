Return-Path: <kvm+bounces-52403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F5BB04CC3
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 02:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56DBF3AA5C9
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DF01547D2;
	Tue, 15 Jul 2025 00:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AFV8rqaA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBE63207;
	Tue, 15 Jul 2025 00:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752538908; cv=none; b=ggZ2nsbWSvSo3BaJhQiO+jGoTSab1iJdMBw8S/3A4gp3SHJVMlTgIYTW7cavPbcq92a+09f+aYTl0SZZ3ie04reJIfIZB0wv0q1t8TljxxnHBiwav2DfJ2uB/mXbNqfo8uyyNUTzC6opl8fo5gW2ChTUUxePVT4EFc6axWvB8uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752538908; c=relaxed/simple;
	bh=ZS6y3+YZOrPGOdLZpTQcp7s63vIuVeQB/7QkEQLYFOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsMs+i/yV9wJIIGdki15oOcXGALgrzBTeu07SSRJB10pEvpzU3sH4PJdsGgd54SsXIxH5TIJi45KOqRrmUTYDH1+WLWS7c+An+VPDiS1aOcSWpKIoqdCdyX4XB9D7CfSwYCWXw6NTn2q3g1RH21QaOeIDYRGKEsfdXmgGRFYsHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AFV8rqaA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CDDC4CEED;
	Tue, 15 Jul 2025 00:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752538908;
	bh=ZS6y3+YZOrPGOdLZpTQcp7s63vIuVeQB/7QkEQLYFOk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=AFV8rqaAoLjVxEuVlCUFYMLsiU1h9Va8CTIxgUvsHGrpgjCxjznNo9asxXAPIyxNp
	 EJ9lSSpP1a2yzn/SoGXXgsK4lzWhgMAaZ2lQz0OOrYenU59HkO0Ke61jHyJIdNATFh
	 EE3YpdPSBaf71QV2aGF75WGL6Rny8A+hwXpbNVaYABc4djiMYwF8vpQVCQcHVrU452
	 mxaq42IdqV008WfsmPYwpkhJX4YCwjz+Ef/76maqb0MobzUj+q6IuDklEHvR9WRHEz
	 VA1jPsoh5fFWFPS0M8YoHP7MXu+AoGkEPTw/HrKLSkhcgWAW04fXYzR98SSt7w20eR
	 wttPzui8HE3Uw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id E7180CE0BAF; Mon, 14 Jul 2025 17:21:47 -0700 (PDT)
Date: Mon, 14 Jul 2025 17:21:47 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, x86@kernel.org, kvm@vger.kernel.org,
	seanjc@google.com, pbonzini@redhat.com, eddie.dong@intel.com,
	kirill.shutemov@intel.com, dave.hansen@intel.com,
	dan.j.williams@intel.com, kai.huang@intel.com,
	isaku.yamahata@intel.com, elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 00/20] TD-Preserving updates
Message-ID: <a7affba9-0cea-4493-b868-392158b59d83@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250523095322.88774-1-chao.gao@intel.com>
 <aHDFoIvB5+33blGp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHDFoIvB5+33blGp@intel.com>

On Fri, Jul 11, 2025 at 04:04:48PM +0800, Chao Gao wrote:
> On Fri, May 23, 2025 at 02:52:23AM -0700, Chao Gao wrote:
> >Hi Reviewers,
> >
> >This series adds support for runtime TDX module updates that preserve
> >running TDX guests (a.k.a, TD-Preserving updates). The goal is to gather
> >feedback on the feature design. Please pay attention to the following items:
> >
> >1. TD-Preserving updates are done in stop_machine() context. it copy-pastes
> >   part of multi_cpu_stop() to guarantee step-locked progress on all CPUs.
> >   But, there are a few differences between them. I am wondering whether
> >   these differences have reached a point where abstracting a common
> >   function might do more harm than good. See more details in patch 10.

Please note that multi_cpu_stop() is used by a number of functions,
so it is a good example of common code.  But you are within your rights
to create your own function to pass to stop_machine(), and quite a
few call sites do just that.  Most of them expect this function to be
executed on only one CPU, but these run on multiple CPUs:

o	__apply_alternatives_multi_stop(), which has CPU 0 do the
	work and the rest wati on it.

o	cpu_enable_non_boot_scope_capabilities(), which works on
	a per-CPU basis.

o	do_join(), which is similar to your do_seamldr_install_module().
	Somewhat similar, anyway.

o	__ftrace_modify_code(), of which there are several, some of
	which have some vague resemblance to your code.

o	cache_rendezvous_handler(), which works on a per-CPU basis.

o	panic_stop_irqoff_fn(), which is a simple barrier-wait, with
	the last CPU to arrive doing the work.

I strongly recommend looking at these functions.  They might
suggest an improved way to do what you are trying to accomplish with
do_seamldr_install_module().

> >2. P-SEAMLDR seamcalls (specificially SEAMRET from P-SEAMLDR) clear current
> >   VMCS pointers, which may disrupt KVM. To prevent VMX instructions in IRQ
> >   context from encountering NULL current-VMCS pointers, P-SEAMLDR
> >   seamcalls are called with IRQ disabled. I'm uncertain if NMIs could
> >   cause a problem, but I believe they won't. See more information in patch 3.
> >
> >3. Two helpers, cpu_vmcs_load() and cpu_vmcs_store(), are added in patch 3
> >   to save and restore the current VMCS. KVM has a variant of cpu_vmcs_load(),
> >   i.e., vmcs_load(). Extracting KVM's version would cause a lot of code
> >   churn, and I don't think that can be justified for reducing ~16 LoC
> >   duplication. Please let me know if you disagree.
> 
> Gentle ping!

I do not believe that I was CCed on the original.  Just in case you
were wondering why I did not respond.  ;-)

> There are three open issues: one regarding stop_machine() and two related to
> interactions with KVM.
> 
> Sean and Paul, do you have any preferences or insights on these matters?

Again, you are within your rights to create a new function and pass
it to stop_machine().  But it seems quite likely that there is a much
simpler way to get your job done.

Either way, please add a header comment stating what your function
is trying to do, which appears to be to wait for all CPUs to enter
do_seamldr_install_module() and then just leave?  Sort of like
multi_cpu_stop(), except leaving interrupts enabled and not executing a
"msdata->fn(msdata->data);", correct?

If so, something like panic_stop_irqoff_fn() might be a simpler model,
perhaps with the touch_nmi_watchdog() and rcu_momentary_eqs() added.

Oh, and one bug:  You must have interrupts disabled when you call
rcu_momentary_eqs().  Please fix this.

							Thanx, Paul

