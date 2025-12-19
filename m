Return-Path: <kvm+bounces-66346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC88ACD090B
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BEEE930C0D9E
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 15:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74173321AC;
	Fri, 19 Dec 2025 15:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="il+4XGsq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604293191D0
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766158814; cv=none; b=XAfzKnnqyaoYNAgXmU+Ma+bvCDMOdFTDofhGsaRb9uFq9CEwhBYT7fpSMl9b42XEnhtELg5paCUGYoU+MmWBxqotMpwhFSCBEVzlxoWRH39f1gNIOFvobzrHnoiV69K/qD0VuruqFQk/PpPkM7OEESvSjcAoUjIfNYmurkBCYIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766158814; c=relaxed/simple;
	bh=V2R/B0gbkwCbHmdCAP2SACbfVHm0/ziCWsigAtAnjaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J7rnx5rhQ73bLab1wZEWuGeBF/paKPd3qy2wlwVFh/HPtnMnRLPF7toPlVvdPPR/Al+QSrF2OjPZ4piAjEeTUV0KWA7urjfL3U7vWLdhfo1emBPDSJbI0s1AtunKHCUDiDtuEFDW3EDh61475btjaDv1uzAsuX/a/11MoiitplQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=il+4XGsq; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c196fa94049so1793717a12.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 07:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766158813; x=1766763613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yxrrp2oMgVkK17s+eJEUzU1udWIn66K3HBKvgT0GfUc=;
        b=il+4XGsqsIBVWQKnxl3E0pqvy9ebNJ35jQDJqviix3y88KIrdwC4/IWC60ouSJREBh
         PWB7qXSNLjKRHqkL7MqF34y4vqoAv6mIOCdyhUhs7ZmKR1zl41Ae7hjVh5JmTBB8gtAh
         k7L3xnl/hPA5T6qitHvolwwuSdYuKUYMIIbViEU3yKMHTeaerj8nttQRh0SSpAVhILeY
         TSka5uT1Q4IB3dcbEh04t/ahII1ru01nIpHyzNNjk2qnQE5NklBq01Kxdfu7QQSr3aOH
         L5xRW6FQyqKFQn+vAZevFQY+s+qME+cTCH+Zdc4qC8FtZcZ4+fzMZ2KZPIgeG0Jy+H5n
         LU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766158813; x=1766763613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yxrrp2oMgVkK17s+eJEUzU1udWIn66K3HBKvgT0GfUc=;
        b=tCJVlkoYj6UJE9phfHFb0gWRjX3CQDGdAKd5ksar7x/E7BTuCiWBiHgVG48g7Yqgdn
         gN83oWeUDdiZ3T7T6jX8wFg8+rjEAVN7m9PdPx8iVpPWJBX96AqE2qAWTNgto7ap5J5I
         Z04Oodz7lwh6I9VFDkMAtX8ccV2aL6KYppDffTAQa6cJaqgeuiOi+YOtX+fVF78UC/DD
         rtz8j9IQUADT6ClxjBofzBDI/EmbpSDnoM0dzGkivHeH9w2C7CeLJ7LNTeh82FMohNcy
         qoqwTHUjKh6FX72DUX7/MkwwptzKtQe6uv+vwEiXZ0W0UwRSLsn1qKmrb45g0Hz/lZl3
         hQ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/VFnIW1JwymVLnCvVTSP4ch/+nwBuGfJDeLqFnGnYtiozH7tb1OCAGKDvhdo/SYTLoVw=@vger.kernel.org
X-Gm-Message-State: AOJu0YymHOJizhdQ66x/iX/YAsj1knWa4vnEgfL0bPrFeTl8E1DZ5Kjv
	tMHiN+5eaGzpClGMQWgWHrUve9X3M35ZqHGnpGH3TMi70VBQRlgX3/udlSQ8uePOT5pFQk/VU4g
	8fmoa9w==
X-Google-Smtp-Source: AGHT+IGtRE55TsKHeelPCRMsIlRwSp4fhqX1YpQo/KjGsELaRWS0xMViHMtopyhh3Du+2psPLE3aTf/OtFw=
X-Received: from pjbhl13.prod.google.com ([2002:a17:90b:134d:b0:34c:5d1d:4e95])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c106:b0:34c:2f40:c662
 with SMTP id 98e67ed59e1d1-34e71e2955bmr5999291a91.14.1766158812676; Fri, 19
 Dec 2025 07:40:12 -0800 (PST)
Date: Fri, 19 Dec 2025 07:40:11 -0800
In-Reply-To: <aUS06wE6IvFti8Le@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com> <20251206011054.494190-3-seanjc@google.com>
 <aTe4QyE3h8LHOAMb@intel.com> <aUJUbcyz2DXmphtU@yilunxu-OptiPlex-7050>
 <aUL-J-MvdCrCtDp4@google.com> <aUS06wE6IvFti8Le@yilunxu-OptiPlex-7050>
Message-ID: <aUVx20ZRjOzKgKqy@google.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 19, 2025, Xu Yilun wrote:
> On Wed, Dec 17, 2025 at 11:01:59AM -0800, Sean Christopherson wrote:
> > On Wed, Dec 17, 2025, Xu Yilun wrote:
> > > Is it better we explicitly assert the preemption for x86_virt_get_cpu()
> > > rather than embed the check in __this_cpu_inc_return()? We are not just
> > > protecting the racing for the reference counter. We should ensure the
> > > "counter increase + x86_virt_call(get_cpu)" can't be preempted.
> > 
> > I don't have a strong preference.  Using __this_cpu_inc_return() without any
> > nearby preemption_{enable,disable}() calls makes it quite clears that preemption
> > is expected to be disabled by the caller.  But I'm also ok being explicit.
> 
> Looking into __this_cpu_inc_return(), it finally calls
> check_preemption_disabled() which doesn't strictly requires preemption.
> It only ensures the context doesn't switch to another CPU. If the caller
> is in cpuhp context, preemption is possible.

Hmm, right, the cpuhp thread is is_percpu_thread(), and KVM's hooks aren't
considered atomic and so run with IRQs enabled.  In practice, it's "fine", because
TDX also exclusively does x86_virt_get_cpu() from cpuhp, i.e. the two users are
mutually exclusive, but relying on that behavior is gross.

> But in this x86_virt_get_cpu(), we need to ensure preemption disabled,
> otherwise caller A increases counter but hasn't do actual VMXON yet and
> get preempted. Caller B opts in and get the wrong info that VMX is
> already on, and fails on following vmx operations.
> 
> On a second thought, maybe we disable preemption inside
> x86_virt_get_cpu() to protect the counter-vmxon racing, this is pure
> internal thing for this kAPI.

Ya, that'd be my preference.


Kai, question for you (or anyone else that might know):

Is there any **need** for tdx_cpu_enable() and try_init_module_global() to run
with IRQs disabled?  AFAICT, the lockdep_assert_irqs_disabled() checks added by
commit 6162b310bc21 ("x86/virt/tdx: Add skeleton to enable TDX on demand") were
purely because, _when the code was written_, KVM enabled virtualization via IPI
function calls.

But by the time the KVM code landed upstream in commit fcdbdf63431c ("KVM: VMX:
Initialize TDX during KVM module load"), that was no longer true, thanks to
commit 9a798b1337af ("KVM: Register cpuhp and syscore callbacks when enabling
hardware") setting the stage for doing everything from task context.

However, rather than update the kernel side, e.g. to drop the lockdep assertions
and related comments, commit 9a798b1337af instead did this:

	local_irq_save(flags);
	r = tdx_cpu_enable();
	local_irq_restore(flags);

Somewhat frustratingly, I poked at this when the reworked code was first posted
(https://lore.kernel.org/all/ZyJOiPQnBz31qLZ7@google.com), but it just got swept
under the rug :-(

  : > > +	/* tdx_cpu_enable() must be called with IRQ disabled */
  : > 
  : > I don't find this comment helpfu.  If it explained _why_ tdx_cpu_enable() requires
  : > IRQs to be disabled, then I'd feel differently, but as is, IMO it doesn't add value.
  : 
  : I'll remove the comment.
  : 
  : > 
  : > > +	local_irq_save(flags);
  : > > +	r = tdx_cpu_enable();
  : > > +	local_irq_restore(flags);

Unless TDX _needs_ IRQs to be disabled, I would strongly prefer to drop that code
in prep patches so that it doesn't become even harder to disentagle the history
to figure out why tdx_online_cpu() disables IRQs:

  static int tdx_online_cpu(unsigned int cpu)
  {
	int ret;

	guard(irqsave)();  <=============== why is this here!?!?!

	ret = x86_virt_get_cpu(X86_FEATURE_VMX);
	if (ret)
		return ret;

	ret = tdx_cpu_enable();
	if (ret)
		x86_virt_put_cpu(X86_FEATURE_VMX);

	return ret;
  }

Side topic, KVM's change in behavior also means this comment is stale (though I
think it's worth keeping the assertion, but with a comment saying it's hardening
and paranoia, not a strick requirement).

	/*
	 * IRQs must be disabled as virtualization is enabled in hardware via
	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
	 * virtualization stays disabled.
	 */
	lockdep_assert_irqs_disabled();

