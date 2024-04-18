Return-Path: <kvm+bounces-15122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49C228AA1FE
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 20:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DE7C1C21558
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A3017AD85;
	Thu, 18 Apr 2024 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hTskooSC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43C7171092
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 18:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713464775; cv=none; b=PR0PhugD1ME/FOHvhMGh/5iZclArlfjM7JJZ13gT1YDcR/xXt+PKKAuNrbD+6LE5oGPbWbQ4B18+ALAfA7RSPhHSxBgUi3n+XO42XMi0tyLXykY6fA/SUxb+gC1QdyNw+DBCgkUzlpFZH6NAI91jBIu6eqkY4Dru5jw8RbMbjfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713464775; c=relaxed/simple;
	bh=FhDtn/1Oncebi5qTzuSBS0nrpK3TbxVu093eT7IPIoA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hVCFbKPMzmDN3H12MRB9AdSRAIN7SYrtR395RgQFcBnZxhWHZPMs33l68Uu7YQM6Dx5isg+p6YnQ/HFGkvBJfLsT87oYEU6A45OpTEyCstyKW5jkeSJ+sRFf4bqgrBMuol21ubnF5N8/JEN3BfiDMunpLJEQSPfxOfiZhsYInOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hTskooSC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1e2a553aad6so13252475ad.1
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 11:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713464773; x=1714069573; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RmUziw85ELNs5DunGMczbwZRDhKt3LNvBNFMebu6TKQ=;
        b=hTskooSCAkgxaDEFuU3btjif1PSvVS2WsIJ0A3+Ahx4yIBxpUevhls1HOla39JZslH
         u7bpeZrFVoFVPeiO23p7L5F3DNN131xbSIekK2QzjeGPcvZYDVjIaGZxDCuu9IeRdqAZ
         A3NakElPETPYe0pP/w78yYkxylgZU4PFquRgxBV9iOOjMGf+Di6bLvGe9GpGDM/OFFj5
         3qLskCTb5cBTO+3QpmwKUNV4Aw9tXPAZk5lau/FbvB+Bj7jMNphteEKDoOkDKXRajM1q
         bgnVA3Ubwp3x4v+/QEoQr0PmAPEhmsZx01NCzlJT8GPaQvfK6cjIrrd8p0W6tqie6SF7
         e07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713464773; x=1714069573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RmUziw85ELNs5DunGMczbwZRDhKt3LNvBNFMebu6TKQ=;
        b=nbr3jGrlerDJqBHeNQuofPS7PHRuhdG/CoQYKpDfDjXh/f6MyKJt68x46gb7uD/yNe
         mhvJcEjtlIkOudhaHL5P61lGPD7TsVkmso/a4pZbsqSETFUxjJ8JndJTwTbswTB1sLsM
         1DNaMzdRQbrMk+9UYtwR6h8tPcW12T2HFT6pT250WoDV5bNYjv0zeOcfK77MFGz0yZc0
         MHjyB35dkjYWSUNUr6UwXHlT84TW4dVQRPZZOf4lj32C+JcZrz2sE20JwzI4XSblbdll
         3XQ9RflwEM4MqqCQm+jPbdHSa8GArkI2phSFuVgACujFjUbT4O1LTbdgonhLaJUejaBf
         5/lw==
X-Forwarded-Encrypted: i=1; AJvYcCUqFj5F4LMtDAPvG6tXQltst/DiGOJNjC0P2GsUGM5hpgm+wY/FXcmmgtPuWPqO3PWd2nJTQ7BkqOmpg0+3bbFBD/ez
X-Gm-Message-State: AOJu0YywLLhLktkuq3GcH7BnQFYYLtwRhf5xcnkDrIUPxQOiL3enh9TY
	NTQXjnFKW01XUAuBD3HelRrduV/fpkjCJ4Qm/Jz8cOYS3AxCTEseQLfH0rft81nxMSu6V3BGgvU
	7yQ==
X-Google-Smtp-Source: AGHT+IHi4MYznpirLYLsYvqS5mZfsgjkGMGyYW3vGG4C7v/qV79tzP+wzMFnQyGkJtLGYkIfMLxse2hFPSI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c2:b0:1e0:afa0:cc94 with SMTP id
 u2-20020a170902e5c200b001e0afa0cc94mr8974plf.7.1713464773080; Thu, 18 Apr
 2024 11:26:13 -0700 (PDT)
Date: Thu, 18 Apr 2024 11:26:11 -0700
In-Reply-To: <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com> <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com> <ZfR4UHsW_Y1xWFF-@google.com>
 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com> <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
Message-ID: <ZiFlw_lInUZgv3J_@google.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
From: Sean Christopherson <seanjc@google.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, Tina Zhang <tina.zhang@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, Kai Huang <kai.huang@intel.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 18, 2024, kirill.shutemov@linux.intel.com wrote:
> On Tue, Apr 16, 2024 at 07:45:18PM +0000, Edgecombe, Rick P wrote:
> > On Wed, 2024-04-10 at 15:49 +0300, Kirill A. Shutemov wrote:
> > > On Fri, Mar 15, 2024 at 09:33:20AM -0700, Sean Christopherson wrote:
> > > > So my feedback is to not worry about the exports, and instead focus on
> > > > figuring
> > > > out a way to make the generated code less bloated and easier to read/debug.
> > > 
> > > I think it was mistake trying to centralize TDCALL/SEAMCALL calls into
> > > few megawrappers. I think we can get better results by shifting leaf
> > > function wrappers into assembly.
> > > 
> > > We are going to have more assembly, but it should produce better result.
> > > Adding macros can help to write such wrapper and minimizer boilerplate.
> > > 
> > > Below is an example of how it can look like. It's not complete. I only
> > > converted TDCALLs, but TDVMCALLs or SEAMCALLs. TDVMCALLs are going to be
> > > more complex.
> > > 
> > > Any opinions? Is it something worth investing more time?
> > 
> > We discussed offline how implementing these for each TDVM/SEAMCALL increases the
> > chances of a bug in just one TDVM/SEAMCALL. Which could making debugging
> > problems more challenging. Kirill raised the possibility of some code generating
> > solution like cpufeatures.h, that could take a spec and generate correct calls.
> > 
> > So far no big wins have presented themselves. Kirill, do we think the path to
> > move the messy part out-of-line will not work?
> 
> I converted all TDCALL and TDVMCALL leafs to direct assembly wrappers.
> Here's WIP branch: https://github.com/intel/tdx/commits/guest-tdx-asm/
> 
> I still need to clean it up and write commit messages and comments for all
> wrappers.
> 
> Now I think it worth the shot.
> 
> Any feedback?

I find it hard to review for correctness, and extremely susceptible to developer
error.  E.g. lots of copy+paste, and manual encoding of RCX to expose registers.
It also bleeds TDX ABI into C code, e.g.

	/*
	 * As per TDX GHCI CPUID ABI, r12-r15 registers contain contents of
	 * EAX, EBX, ECX, EDX registers after the CPUID instruction execution.
	 * So copy the register contents back to pt_regs.
	 */
	regs->ax = args.r12;
	regs->bx = args.r13;
	regs->cx = args.r14;
	regs->dx = args.r15;

Oh, and it requires input/output paramters, which is quite gross for C code *and*
for assembly code, e.g.

	u64 tdvmcall_map_gpa(u64 *gpa, u64 size);

and then the accompanying assembly code:

		FRAME_BEGIN

		save_regs r12,r13

		movq	(%rdi), %r12
		movq	%rsi, %r13

		movq	$(TDX_R10 | TDX_R11 | TDX_R12 | TDX_R13), %rcx

		tdvmcall	$TDVMCALL_MAP_GPA

		movq	%r11, (%rdi)

		restore_regs r13,r12

		FRAME_END
		RET

I think having one trampoline makes sense, e.g. to minimize the probability of
leaking register state to the VMM.  The part that I don't like, and which generates
awful code, is shoving register state into a memory structure.

The annoying part with the TDX ABI is that it heavily uses r8-r15, and asm()
constraints don't play nice with r8-15.  But that doesn't mean we can't use asm()
with macros, it just means we have to play games with registers.

Because REG-REG moves are super cheap, and ignoring the fatal error goofiness,
there are at most four inputs.  That means having a single trampoline take *all*
possible inputs is a non-issue.  And we can avoiding polluting the inline code if
we bury the register shuffling in the trampoline.

And if we use asm() wrappers to call the trampoline, then the trampoline doesn't
need to precisely follow the C calling convention.  I.e. the trampoline can return
with the outputs still in r12-r15, and let the asm() wrappers extract the outputs
they want.

As it stands, TDVMCALLs either have 0, 1, or 4 outputs.  I.e. we only need three
asm() wrappers.  We could get away with one wrapper, but then users of the wrappers
would need dummy variables for inputs *and* outputs, and the outputs get gross.

Completely untested, but this is what I'm thinking.  Side topic, I think making
"tdcall" a macro that takes a leaf is a mistake.  If/when an assembler learns what
tdcall is, we're going to have to rewrite all of that code.  And what a coincidence,
my suggestion needs a bare TDCALL!  :-)

Side topic #2, I don't think the trampoline needs a stack frame, its a leaf function.

Side topic #3, the ud2 to induce panic should be out-of-line.

Weird?  Yeah.  But at least we one need to document one weird calling convention,
and the ugliness is contained to three macros and a small assembly function.

.pushsection .noinstr.text, "ax"
SYM_FUNC_START(tdvmcall_trampoline)
	movq	$TDX_HYPERCALL_STANDARD, %r10
	movq	%rax, %r11
	movq	%rdi, %r12
	movq	%rsi, %r13
	movq	%rdx, %r14
	movq	%rcx, %r15

	movq	$(TDX_R10 | TDX_R11 | TDX_R12 | TDX_R13 | TDX_R14 | TDX_R15), %rcx

	tdcall

	testq	%rax, %rax
	jnz	.Lpanic

	ret

.Lpanic:
	ud2
SYM_FUNC_END(tdvmcall_trampoline)
.popsection


#define TDVMCALL(reason, in1, in2, in3, in4)				\
({									\
	long __ret;							\
									\
	asm(								\
		"call tdvmcall_trampoline\n\t"				\
		"mov %%r10, %0\n\t"					\
		: "=r" (__ret)						\
		: "D" (in1), "S"(in2), "d"(in3), "c" (in4)		\
		: "r12", "r13", "r14", "r15"				\
	);								\
	__ret;								\
})

#define TDVMCALL_1(reason, in1, in2, in3, in4, out1)			\
({									\
	long __ret;							\
									\
	asm(								\
		"call tdvmcall_trampoline\n\t"				\
		"mov %%r10, %0\n\t"					\
		"mov %%r12, %1\n\t"					\
		: "=r"(__ret) "=r" (out1)				\
		: "a"(reason), "D" (in1), "S"(in2), "d"(in3), "c" (in4)	\
		: "r12", "r13", "r14", "r15"				\
	);								\
	__ret;								\
})

#define TDVMCALL_4(reason, in1, in2, in3, in4, out1, out2, out3, out4)	\
({									\
	long __ret;							\
									\
	asm(								\
		"call tdvmcall_trampoline\n\t"				\
		"mov %%r10, %0\n\t"					\
		"mov %%r12, %1\n\t"					\
		"mov %%r13, %2\n\t"					\
		"mov %%r14, %3\n\t"					\
		"mov %%r15, %4\n\t"					\
		: "=r" (__ret),						\
		  "=r" (out1), "=r" (out2), "=r" (out3), "=r" (out4)	\
		: "a"(reason), "D" (in1), "S"(in2), "d"(in3), "c" (in4)	\
		  [reason] "i" (reason) 				\
		: "r12", "r13", "r14", "r15"				\
	);								\
	__ret;								\
})

static int handle_halt(struct ve_info *ve)
{
	if (TDVMCALL(EXIT_REASON_HALT, irqs_disabled(), 0, 0, 0))
		return -EIO;

	return ve_instr_len(ve);
}

void __cpuidle tdx_safe_halt(void)
{
	WARN_ONCE(TDVMCALL(EXIT_REASON_HALT, false, 0, 0, 0),
		  "HLT instruction emulation failed");
}

static int read_msr(struct pt_regs *regs, struct ve_info *ve)
{
	u64 val;

	if (TDVMCALL_1(EXIT_REASON_MSR_READ, regs->cx, 0, 0, 0, val))
		return -EIO;

	regs->ax = lower_32_bits(val);
	regs->dx = upper_32_bits(val);

	return ve_instr_len(ve);
}

static int write_msr(struct pt_regs *regs, struct ve_info *ve)
{
	u64 val = (u64)regs->dx << 32 | regs->ax;

	if (TDVMCALL(EXIT_REASON_MSR_WRITE, regs->cx, val, 0, 0))
		return -EIO;

	return ve_instr_len(ve);
}
static int handle_cpuid(struct pt_regs *regs, struct ve_info *ve)
{
	/*
	 * Only allow VMM to control range reserved for hypervisor
	 * communication.
	 *
	 * Return all-zeros for any CPUID outside the range. It matches CPU
	 * behaviour for non-supported leaf.
	 */
	if (regs->ax < 0x40000000 || regs->ax > 0x4FFFFFFF) {
		regs->ax = regs->bx = regs->cx = regs->dx = 0;
		return ve_instr_len(ve);
	}

	if (TDVMCALL_4(EXIT_REASON_CPUID, regs->ax, regs->cx, 0, 0,
		       regs->ax, regs->bx, regs->cx, regs->dx))
		return -EIO;

	return ve_instr_len(ve);
}

static bool mmio_read(int size, u64 gpa, u64 *val)
{
	*val = 0;
	return !TDVMCALL_1(EXIT_REASON_EPT_VIOLATION, size, EPT_READ, gpa, 0, val);
}

static bool mmio_write(int size, u64 gpa, u64 val)
{
	return !TDVMCALL(EXIT_REASON_EPT_VIOLATION, size, EPT_WRITE, gpa, val);
}

