Return-Path: <kvm+bounces-15305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8CC68AB0F6
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:46:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC78E1C22198
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BB512F38B;
	Fri, 19 Apr 2024 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N9cARp8g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF1112EBEA;
	Fri, 19 Apr 2024 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713537970; cv=none; b=CBNndfhFBhXmbvpQo+G8x9qKrjT0w2dstLd91+jOzpFF1Lunj0Knpbhqpi+5/BkYbRpfJiEB9h0DMlTHW8WJFX/oI//fIld/7yju5Pwg1n6x1Anq7FuR1BAlm1dj0gpdLLDLVeXB/TqbHIL+4RGuAyeb5x+8uV1aGLDNtp0X4Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713537970; c=relaxed/simple;
	bh=D9gFcA0ASCTLN6THsn+aJ2GmP14GMakR81RQg71n03A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rc0UY+9T7f16JQyXkT4ht58y4xEm+3RtWnk3aCt93VHg42Qp/C+iOEpozUQAmzD00i8LMVoXeCcHZcouRQX3zjUNB7FxqiMFMxEOS/C4sOrZYhqsoga9loq2zXzW6CHsg4UmJFB43phLMRr9he5n2gAgY2U4jgzpPTdMOpGdqwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N9cARp8g; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713537969; x=1745073969;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=D9gFcA0ASCTLN6THsn+aJ2GmP14GMakR81RQg71n03A=;
  b=N9cARp8gMq5g1PW6nZQ87NfSQCg/AUdKiralBucZo6hI7Sj/ewaFh/0M
   hJ0wq/xltsYSyJwxZc1yHSM/SLw/GLbnn6ocxot3Hqt4O3qTGadJVI+oq
   ZMqesM+X/lifqR9+fDaY6ZgxScAlPYnOagXI4eD4SDmYZEGabABgcuJnZ
   5FTi1YC1d8Wi2IsvRofuRGoOPsnwBF1nZ7zpkkuesgKCVmIP6bSfi9yRG
   3cBOTYSAR0McKHJwB1vNLuacMeYMpl/TIafXf1SN/eS/aEJBMgOJhgB5Q
   3bxWL/RMJ8ojDoCi6gxBrhdjGrWzNyPOSwmWt/mQ71hgQZ1QozGkaRoAW
   g==;
X-CSE-ConnectionGUID: b7vId9j0SgSNExvOlIcp3g==
X-CSE-MsgGUID: eQ+CswvUTbOh7CPoNU/TKA==
X-IronPort-AV: E=McAfee;i="6600,9927,11049"; a="12977654"
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="12977654"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 07:46:08 -0700
X-CSE-ConnectionGUID: vfb81nxvQCKJLk3G0i/4PQ==
X-CSE-MsgGUID: 65jMgnRrTbe4nwnXUT27LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,214,1708416000"; 
   d="scan'208";a="27978818"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa004.fm.intel.com with ESMTP; 19 Apr 2024 07:46:04 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id DE871FD; Fri, 19 Apr 2024 17:46:02 +0300 (EEST)
Date: Fri, 19 Apr 2024 17:46:02 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Tina Zhang <tina.zhang@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	Hang Yuan <hang.yuan@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Kai Huang <kai.huang@intel.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Message-ID: <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
 <ZfR4UHsW_Y1xWFF-@google.com>
 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
 <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
 <ZiFlw_lInUZgv3J_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiFlw_lInUZgv3J_@google.com>

On Thu, Apr 18, 2024 at 11:26:11AM -0700, Sean Christopherson wrote:
> On Thu, Apr 18, 2024, kirill.shutemov@linux.intel.com wrote:
> > On Tue, Apr 16, 2024 at 07:45:18PM +0000, Edgecombe, Rick P wrote:
> > > On Wed, 2024-04-10 at 15:49 +0300, Kirill A. Shutemov wrote:
> > > > On Fri, Mar 15, 2024 at 09:33:20AM -0700, Sean Christopherson wrote:
> > > > > So my feedback is to not worry about the exports, and instead focus on
> > > > > figuring
> > > > > out a way to make the generated code less bloated and easier to read/debug.
> > > > 
> > > > I think it was mistake trying to centralize TDCALL/SEAMCALL calls into
> > > > few megawrappers. I think we can get better results by shifting leaf
> > > > function wrappers into assembly.
> > > > 
> > > > We are going to have more assembly, but it should produce better result.
> > > > Adding macros can help to write such wrapper and minimizer boilerplate.
> > > > 
> > > > Below is an example of how it can look like. It's not complete. I only
> > > > converted TDCALLs, but TDVMCALLs or SEAMCALLs. TDVMCALLs are going to be
> > > > more complex.
> > > > 
> > > > Any opinions? Is it something worth investing more time?
> > > 
> > > We discussed offline how implementing these for each TDVM/SEAMCALL increases the
> > > chances of a bug in just one TDVM/SEAMCALL. Which could making debugging
> > > problems more challenging. Kirill raised the possibility of some code generating
> > > solution like cpufeatures.h, that could take a spec and generate correct calls.
> > > 
> > > So far no big wins have presented themselves. Kirill, do we think the path to
> > > move the messy part out-of-line will not work?
> > 
> > I converted all TDCALL and TDVMCALL leafs to direct assembly wrappers.
> > Here's WIP branch: https://github.com/intel/tdx/commits/guest-tdx-asm/
> > 
> > I still need to clean it up and write commit messages and comments for all
> > wrappers.
> > 
> > Now I think it worth the shot.
> > 
> > Any feedback?
> 
> I find it hard to review for correctness, and extremely susceptible to developer
> error.  E.g. lots of copy+paste, and manual encoding of RCX to expose registers.

Yes, I agree. The approach requires careful manual work and is error-prone.
I was planning to get around and stare at every wrapper to make sure it is correct.
This approach is not scalable, though.

> It also bleeds TDX ABI into C code, e.g.
> 
> 	/*
> 	 * As per TDX GHCI CPUID ABI, r12-r15 registers contain contents of
> 	 * EAX, EBX, ECX, EDX registers after the CPUID instruction execution.
> 	 * So copy the register contents back to pt_regs.
> 	 */
> 	regs->ax = args.r12;
> 	regs->bx = args.r13;
> 	regs->cx = args.r14;
> 	regs->dx = args.r15;
> 
> Oh, and it requires input/output paramters, which is quite gross for C code *and*
> for assembly code, e.g.
> 
> 	u64 tdvmcall_map_gpa(u64 *gpa, u64 size);
> 
> and then the accompanying assembly code:
> 
> 		FRAME_BEGIN
> 
> 		save_regs r12,r13
> 
> 		movq	(%rdi), %r12
> 		movq	%rsi, %r13
> 
> 		movq	$(TDX_R10 | TDX_R11 | TDX_R12 | TDX_R13), %rcx
> 
> 		tdvmcall	$TDVMCALL_MAP_GPA
> 
> 		movq	%r11, (%rdi)
> 
> 		restore_regs r13,r12
> 
> 		FRAME_END
> 		RET
> 
> I think having one trampoline makes sense, e.g. to minimize the probability of
> leaking register state to the VMM.  The part that I don't like, and which generates
> awful code, is shoving register state into a memory structure.

I don't think we can get away with single trampoline. We have outliers.

See TDG.VP.VMCALL<ReportFatalError> that uses pretty much all registers as
input. And I hope we wouldn't need TDG.VP.VMCALL<Instruction.PCONFIG> any
time soon. It uses all possible output registers.

But I guess we can make a *few* wrappers that covers all needed cases.

> The annoying part with the TDX ABI is that it heavily uses r8-r15, and asm()
> constraints don't play nice with r8-15.  But that doesn't mean we can't use asm()
> with macros, it just means we have to play games with registers.
> 
> Because REG-REG moves are super cheap, and ignoring the fatal error goofiness,
> there are at most four inputs.  That means having a single trampoline take *all*
> possible inputs is a non-issue.  And we can avoiding polluting the inline code if
> we bury the register shuffling in the trampoline.
> 
> And if we use asm() wrappers to call the trampoline, then the trampoline doesn't
> need to precisely follow the C calling convention.  I.e. the trampoline can return
> with the outputs still in r12-r15, and let the asm() wrappers extract the outputs
> they want.
> 
> As it stands, TDVMCALLs either have 0, 1, or 4 outputs.  I.e. we only need three
> asm() wrappers.  We could get away with one wrapper, but then users of the wrappers
> would need dummy variables for inputs *and* outputs, and the outputs get gross.
> 
> Completely untested, but this is what I'm thinking.  Side topic, I think making
> "tdcall" a macro that takes a leaf is a mistake.  If/when an assembler learns what
> tdcall is, we're going to have to rewrite all of that code.  And what a coincidence,
> my suggestion needs a bare TDCALL!  :-)

I guess rename the macro (if it still needed) to something like
tdcall_leaf or something.

> Side topic #2, I don't think the trampoline needs a stack frame, its a leaf function.

Hm. I guess.

> Side topic #3, the ud2 to induce panic should be out-of-line.

Yeah. I switched to the inline one while debugging one section mismatch
issue and forgot to switch back.

> Weird?  Yeah.  But at least we one need to document one weird calling convention,
> and the ugliness is contained to three macros and a small assembly function.

Okay, the approach is worth exploring. I can work on it.

You focuses here on TDVMCALL. What is your take on the rest of TDCALL?

> .pushsection .noinstr.text, "ax"
> SYM_FUNC_START(tdvmcall_trampoline)
> 	movq	$TDX_HYPERCALL_STANDARD, %r10
> 	movq	%rax, %r11
> 	movq	%rdi, %r12
> 	movq	%rsi, %r13
> 	movq	%rdx, %r14
> 	movq	%rcx, %r15
> 
> 	movq	$(TDX_R10 | TDX_R11 | TDX_R12 | TDX_R13 | TDX_R14 | TDX_R15), %rcx
> 
> 	tdcall
> 
> 	testq	%rax, %rax
> 	jnz	.Lpanic
> 
> 	ret
> 
> .Lpanic:
> 	ud2
> SYM_FUNC_END(tdvmcall_trampoline)
> .popsection
> 
> 
> #define TDVMCALL(reason, in1, in2, in3, in4)				\
> ({									\
> 	long __ret;							\
> 									\
> 	asm(								\
> 		"call tdvmcall_trampoline\n\t"				\
> 		"mov %%r10, %0\n\t"					\
> 		: "=r" (__ret)						\
> 		: "D" (in1), "S"(in2), "d"(in3), "c" (in4)		\
> 		: "r12", "r13", "r14", "r15"				\
> 	);								\
> 	__ret;								\
> })
> 
> #define TDVMCALL_1(reason, in1, in2, in3, in4, out1)			\
> ({									\
> 	long __ret;							\
> 									\
> 	asm(								\
> 		"call tdvmcall_trampoline\n\t"				\
> 		"mov %%r10, %0\n\t"					\
> 		"mov %%r12, %1\n\t"					\

It is r11, not r12.

> 		: "=r"(__ret) "=r" (out1)				\
> 		: "a"(reason), "D" (in1), "S"(in2), "d"(in3), "c" (in4)	\
> 		: "r12", "r13", "r14", "r15"				\
> 	);								\
> 	__ret;								\
> })
> 
> #define TDVMCALL_4(reason, in1, in2, in3, in4, out1, out2, out3, out4)	\
> ({									\
> 	long __ret;							\
> 									\
> 	asm(								\
> 		"call tdvmcall_trampoline\n\t"				\
> 		"mov %%r10, %0\n\t"					\
> 		"mov %%r12, %1\n\t"					\
> 		"mov %%r13, %2\n\t"					\
> 		"mov %%r14, %3\n\t"					\
> 		"mov %%r15, %4\n\t"					\
> 		: "=r" (__ret),						\
> 		  "=r" (out1), "=r" (out2), "=r" (out3), "=r" (out4)	\
> 		: "a"(reason), "D" (in1), "S"(in2), "d"(in3), "c" (in4)	\
> 		  [reason] "i" (reason) 				\
> 		: "r12", "r13", "r14", "r15"				\
> 	);								\
> 	__ret;								\
> })
> 
> static int handle_halt(struct ve_info *ve)
> {
> 	if (TDVMCALL(EXIT_REASON_HALT, irqs_disabled(), 0, 0, 0))
> 		return -EIO;
> 
> 	return ve_instr_len(ve);
> }
> 
> void __cpuidle tdx_safe_halt(void)
> {
> 	WARN_ONCE(TDVMCALL(EXIT_REASON_HALT, false, 0, 0, 0),
> 		  "HLT instruction emulation failed");
> }
> 
> static int read_msr(struct pt_regs *regs, struct ve_info *ve)
> {
> 	u64 val;
> 
> 	if (TDVMCALL_1(EXIT_REASON_MSR_READ, regs->cx, 0, 0, 0, val))
> 		return -EIO;
> 
> 	regs->ax = lower_32_bits(val);
> 	regs->dx = upper_32_bits(val);
> 
> 	return ve_instr_len(ve);
> }
> 
> static int write_msr(struct pt_regs *regs, struct ve_info *ve)
> {
> 	u64 val = (u64)regs->dx << 32 | regs->ax;
> 
> 	if (TDVMCALL(EXIT_REASON_MSR_WRITE, regs->cx, val, 0, 0))
> 		return -EIO;
> 
> 	return ve_instr_len(ve);
> }
> static int handle_cpuid(struct pt_regs *regs, struct ve_info *ve)
> {
> 	/*
> 	 * Only allow VMM to control range reserved for hypervisor
> 	 * communication.
> 	 *
> 	 * Return all-zeros for any CPUID outside the range. It matches CPU
> 	 * behaviour for non-supported leaf.
> 	 */
> 	if (regs->ax < 0x40000000 || regs->ax > 0x4FFFFFFF) {
> 		regs->ax = regs->bx = regs->cx = regs->dx = 0;
> 		return ve_instr_len(ve);
> 	}
> 
> 	if (TDVMCALL_4(EXIT_REASON_CPUID, regs->ax, regs->cx, 0, 0,
> 		       regs->ax, regs->bx, regs->cx, regs->dx))
> 		return -EIO;
> 
> 	return ve_instr_len(ve);
> }
> 
> static bool mmio_read(int size, u64 gpa, u64 *val)
> {
> 	*val = 0;
> 	return !TDVMCALL_1(EXIT_REASON_EPT_VIOLATION, size, EPT_READ, gpa, 0, val);
> }
> 
> static bool mmio_write(int size, u64 gpa, u64 val)
> {
> 	return !TDVMCALL(EXIT_REASON_EPT_VIOLATION, size, EPT_WRITE, gpa, val);
> }

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

