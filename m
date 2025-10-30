Return-Path: <kvm+bounces-61513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E51C21BF2
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:22:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4ED5A188D960
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD24536CA6A;
	Thu, 30 Oct 2025 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I4VcTSpq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B66304BA4
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 18:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761848516; cv=none; b=VOsIGXv/tQPNum91oDb1uakEOaPm3XUSvvL45Fy44zLDbrKwHK03/WLF/dtVkpI56Uq30gD5NxwQ2Td09PlA+5UIczpOswuOVP4tQRATj4rHr8AgqJrqUzwmGEuHV5VGk7W8TtCygOgL/eWoqNplMEGmBsRUOim8WiTH7omlzvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761848516; c=relaxed/simple;
	bh=G1Jqn8HIFCQ5/7U8zfCQsFPnyExuKJcxWfgsrhsTV0I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F65BD1bND92dIAe8SMM2IzFEPLcyvlfxPaknG1vMp4rYcD5WQT8t+EOZtwwt+Y6Fzcgwka/4BQHnTewFth03hFocBzQogrP5to5cidygUT8mdZUk4drtATJ9QsHm8Y4Kiom4hFha/EcvY5Tl4OS9mWaS4bwZuor261K0BFKW86o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I4VcTSpq; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-286a252bfbfso32105715ad.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 11:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761848514; x=1762453314; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EuJruU9oaN2P5lJoCoNzBsYuCo9kwc/l55LcfG94yho=;
        b=I4VcTSpqbO2dqyESNEMIP7mYukoX7xjvjFSgz1V6fmR1sLINj5OxLGTh5lMF6y3q9e
         D5XWbuLpLtrd3wvqhhH6PL4Z80hF5GmffLbpuBsuFNSoNKITIQQS5NIM5XbXXAXF3soK
         xyEPcrODEWHXLTlgHNLROKr2GZAfB7oB76djVc3XbvLNbGnJbGcQCBQaWfsrJnaMhysB
         ICiaqbQzHHjEybbb4ihx48e3cymifke94I2csILWTxG208ZfxIyOsj5zi8mzZbgL4AVs
         beqp58aeAqku0qaCMkue3IBpXTAQG/+HLHtw0sl02rCB6zFXpvlzPhIP9kU2v3rCGrvv
         x0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761848514; x=1762453314;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EuJruU9oaN2P5lJoCoNzBsYuCo9kwc/l55LcfG94yho=;
        b=P9NqKXgMKJcCWT72wEGm7MDt2QACdeq5mBfgmwDmNU8trnVbCUKtOiJjYP+Cn6J5Ge
         SmK2RRAPwguhnyw2UjcMfJpwBas3t7vzaMqN+aGaJxHK7EiXbBbLejOXqqMioice26rW
         y4dHIYmkNSXNnKYjVJSZkuhB5Xpc8FeQPQvlMy9FyhyjQ/WSs0acDbSQP9aw+RNU8ErM
         Xlx0zmJj+X7w7kwMjjPv6mT8a70ushUA+Ll/diTXdCF+p9D+OljioB2iiKKgpNZUkIxJ
         llUxFi7Cf0KcSkXWcIGEmOIrLIiJ4YPHokOlEHIkXk+H5iscBHnCKyVwa5eaj8DyaqXR
         SmXw==
X-Forwarded-Encrypted: i=1; AJvYcCXhik0PLpuNa1bQL5JHE0aMe5vd+OZrxT/lwSQ6VEPzSjO662Qu/uf5gP7oXZf9s5UfHcg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/klO7rQ9ijK0JC5BPojfGaIeiOWr68cHJ6SU8DTesPoEJOzAu
	yiPyh0vdU57WRrEcs2tCQqAosCR4jyfF9q8o+3ERorsV8P8Bqsor+pgUFHM21vABRaaxx0JuqDN
	fbqKGXQ==
X-Google-Smtp-Source: AGHT+IFhuCcrL5ADfsl+BP4psk3N6HcI37Id2x/bm3fdH2feH6TxaP2oTiRvqUgUBJC0iJkIAGK4A1y8eQM=
X-Received: from plbbj10.prod.google.com ([2002:a17:902:850a:b0:294:5f94:dc3a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3848:b0:294:df00:1886
 with SMTP id d9443c01a7336-2951a45a13dmr9585705ad.39.1761848513763; Thu, 30
 Oct 2025 11:21:53 -0700 (PDT)
Date: Thu, 30 Oct 2025 11:21:52 -0700
In-Reply-To: <20251030172836.5ys2wag3dax5fmwk@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com> <DDVO5U7JZF4F.1WXXE8IYML140@google.com>
 <20251030172836.5ys2wag3dax5fmwk@desk>
Message-ID: <aQOswAMVciBXu1ud@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Brendan Jackman <jackmanb@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 30, 2025, Pawan Gupta wrote:
> On Thu, Oct 30, 2025 at 12:52:12PM +0000, Brendan Jackman wrote:
> > On Wed Oct 29, 2025 at 9:26 PM UTC, Pawan Gupta wrote:
> > > +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> > > +	jz .Lskip_clear_cpu_buffers
> > 
> > Hm, it's a bit weird that we have the "alternative" inside
> > VM_CLEAR_CPU_BUFFERS, but then we still keep the test+jz
> > unconditionally. 
> 
> Exactly, but it is tricky to handle the below 2 cases in asm:
> 
> 1. MDS -> Always do VM_CLEAR_CPU_BUFFERS
> 
> 2. MMIO -> Do VM_CLEAR_CPU_BUFFERS only if guest can access host MMIO

Overloading VM_CLEAR_CPU_BUFFERS for MMIO is all kinds of confusing, e.g. my
pseudo-patch messed things.  It's impossible to understand

> In th MMIO case, one guest may have access to host MMIO while another may
> not. Alternatives alone can't handle this case as they patch code at boot
> which is then set in stone. One way is to move the conditional inside
> VM_CLEAR_CPU_BUFFERS that gets a flag as an arguement.
> 
> > If we really want to super-optimise the no-mitigations-needed case,
> > shouldn't we want to avoid the conditional in the asm if it never
> > actually leads to a flush?
> 
> Ya, so effectively, have VM_CLEAR_CPU_BUFFERS alternative spit out
> conditional VERW when affected by MMIO_only, otherwise an unconditional
> VERW.
> 
> > On the other hand, if we don't mind a couple of extra instructions,
> > shouldn't we be fine with just having the whole asm code based solely
> > on VMX_RUN_CLEAR_CPU_BUFFERS and leaving the
> > X86_FEATURE_CLEAR_CPU_BUF_VM to the C code?
> 
> That's also an option.
> 
> > I guess the issue is that in the latter case we'd be back to having
> > unnecessary inconsistency with AMD code while in the former case... well
> > that would just be really annoying asm code - am I on the right
> > wavelength there? So I'm not necessarily asking for changes here, just
> > probing in case it prompts any interesting insights on your side.
> > 
> > (Also, maybe this test+jz has a similar cost to the nops that the
> > "alternative" would inject anyway...?)
> 
> Likely yes. test+jz is a necessary evil that is needed for MMIO Stale Data
> for different per-guest handling.

I don't like any of those options :-)

I again vote to add X86_FEATURE_CLEAR_CPU_BUF_MMIO, and then have it be mutually
exlusive with X86_FEATURE_CLEAR_CPU_BUF_VM, i.e. be an alterantive, not a subset.
Because as proposed, the MMIO case _isn't_ a strict subset, it's a subset iff
the MMIO mitigation is enabled, otherwise it's something else entirely.

After half an hour of debugging godawful assembler errors because I used stringify()
instead of __stringify(), I was able to get to this, which IMO is readable and
intuitive.

	/* Clobbers EFLAGS.ZF */
	ALTERNATIVE_2 "",							\
		      __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM,	\
		      __stringify(jz .Lskip_clear_cpu_buffers;			\
				  CLEAR_CPU_BUFFERS_SEQ;			\
				  .Lskip_clear_cpu_buffers:),			\
		      X86_FEATURE_CLEAR_CPU_BUF_MMIO

Without overloading X86_FEATURE_CLEAR_CPU_BUF_VM, e.g. the conversion from a
static branch to X86_FEATURE_CLEAR_CPU_BUF_MMIO is a pure conversion and yields:

	if (verw_clear_cpu_buf_mitigation_selected) {
		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
	} else {
		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_MMIO);
	}

Give me a few hours to test, and I'll post a v2.  The patches are:

Pawan Gupta (1):
  x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well

Sean Christopherson (4):
  x86/bugs: Decouple ALTERNATIVE usage from VERW macro definition
  x86/bugs: Use an X86_FEATURE_xxx flag for the MMIO Stale Data mitigation
  KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly via ALTERNATIVES_2
  x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as SVM_CLEAR_CPU_BUFFERS

 arch/x86/include/asm/cpufeatures.h   |  1 +
 arch/x86/include/asm/nospec-branch.h | 24 +++++++++---------------
 arch/x86/kernel/cpu/bugs.c           | 18 +++++++-----------
 arch/x86/kvm/mmu/spte.c              |  2 +-
 arch/x86/kvm/svm/vmenter.S           |  6 ++++--
 arch/x86/kvm/vmx/vmenter.S           | 13 ++++++++++++-
 arch/x86/kvm/vmx/vmx.c               | 15 +--------------
 7 files changed, 35 insertions(+), 44 deletions(-)

