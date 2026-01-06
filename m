Return-Path: <kvm+bounces-67098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7A8CF6C56
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 06:26:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7300D302D52E
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 05:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6836301717;
	Tue,  6 Jan 2026 05:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hm9fZ7aO"
X-Original-To: kvm@vger.kernel.org
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221702BD5A8;
	Tue,  6 Jan 2026 05:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767677145; cv=none; b=g1vHzdkGULwDbV2uE86UYViTf8MUPxON9uBDMVgXq5ohNxmtU4eSunUNvkuBuL9rWTTp0nLa1bpavubV6TUbZ6jlegfNU0oH6v88RvfFD2kj1ivFGcZrHDrmtT71ZiKnlJ37dv64Mw6AInI607Saaax/+wsFECY3NX7kfWPetAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767677145; c=relaxed/simple;
	bh=ePAsxEhBS2WPW4tMMfOev1sOuNfD1Zy2tmgOi1F2lPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXZ3Hqwwb0E4VvFr7EV+3bdLmYb3prQ5q6oIhhGrXLUTX+Hy96243UYcRdI/91I29GxqLtqL+1fcHNP0QxfcfdPxPqt7MVcin46Qp5AbwSLH3IkERSLGqZLK9FzfPF1SxHiF4UNzdsJ4dtc661brBNEQj3XT/CX2fQqqkbDobZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hm9fZ7aO; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767677138; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=sqKHxsvRqvCMzBbXkJlIz5eLBsYjaU/14IDuOzVUkFo=;
	b=hm9fZ7aOzDRyVlMa+7bxJCjZiCUHQJR+ZDAFvtyZzI9ehSUbrm08z8tZKRvSw2lOM4V02ugv4YhBQTe2K//4FrzTjGrZ2BfnKzeGoPzJrMYKNmIaFDUyfqy5FRU93QhPfaobWG13uzxuFNZ3woONzFLIROt1dlvouUxW0izAgOg=
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0WwUehPs_1767677137 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 06 Jan 2026 13:25:37 +0800
Date: Tue, 6 Jan 2026 13:25:37 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yao Yuan <yaoyuan0329os@gmail.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever
 XFD[i]=1
Message-ID: <jehglwyqu243ouotvrfy2cdml73fha23pglabopcskb3qjtsw4@b5spz5uw4suq>
References: <20260101090516.316883-1-pbonzini@redhat.com>
 <20260101090516.316883-2-pbonzini@redhat.com>
 <aig6cfdj7vxmm5yt6lvfsyqwlnavrcl2n4z3gzomqydce5suxm@ydomfhhmwd7y>
 <aVv1WTR9Zsx2FpZ0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVv1WTR9Zsx2FpZ0@google.com>

On Mon, Jan 05, 2026 at 09:31:05AM +0800, Sean Christopherson wrote:
> On Sat, Jan 03, 2026, Yao Yuan wrote:
> > On Thu, Jan 01, 2026 at 10:05:13AM +0100, Paolo Bonzini wrote:
> > > diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> > > index da233f20ae6f..166c380b0161 100644
> > > --- a/arch/x86/kernel/fpu/core.c
> > > +++ b/arch/x86/kernel/fpu/core.c
> > > @@ -319,10 +319,29 @@ EXPORT_SYMBOL_FOR_KVM(fpu_enable_guest_xfd_features);
> > >  #ifdef CONFIG_X86_64
> > >  void fpu_update_guest_xfd(struct fpu_guest *guest_fpu, u64 xfd)
> > >  {
> > > +	struct fpstate *fpstate = guest_fpu->fpstate;
> > > +
> > >  	fpregs_lock();
> > > -	guest_fpu->fpstate->xfd = xfd;
> > > -	if (guest_fpu->fpstate->in_use)
> > > -		xfd_update_state(guest_fpu->fpstate);
> > > +
> > > +	/*
> > > +	 * KVM's guest ABI is that setting XFD[i]=1 *can* immediately revert
> > > +	 * the save state to initialized.  Likewise, KVM_GET_XSAVE does the
> > > +	 * same as XSAVE and returns XSTATE_BV[i]=0 whenever XFD[i]=1.
> > > +	 *
> > > +	 * If the guest's FPU state is in hardware, just update XFD: the XSAVE
> > > +	 * in fpu_swap_kvm_fpstate will clear XSTATE_BV[i] whenever XFD[i]=1.
> > > +	 *
> > > +	 * If however the guest's FPU state is NOT resident in hardware, clear
> > > +	 * disabled components in XSTATE_BV now, or a subsequent XRSTOR will
> > > +	 * attempt to load disabled components and generate #NM _in the host_.
> > > +	 */
> >
> > Hi Sean and Paolo,
> >
> > > +	if (xfd && test_thread_flag(TIF_NEED_FPU_LOAD))
> > > +		fpstate->regs.xsave.header.xfeatures &= ~xfd;
> > > +
> > > +	fpstate->xfd = xfd;
> > > +	if (fpstate->in_use)
> > > +		xfd_update_state(fpstate);
> >
> > I see a *small* window that the Host IRQ can happen just after above
> > TIF_NEED_FPU_LOAD checking, which could set TIF_NEED_FPU_LOAD
>
> Only if the code using FPU from IRQ context is buggy.  More below.
>
> > but w/o clear the xfd from fpstate->regs.xsave.header.xfeatures.
> >
> > But there's WARN in in kernel_fpu_begin_mask():
> >
> > 	WARN_ON_FPU(!irq_fpu_usable());
> >
> > irq_fpu_usable()
> > {
> > 	...
> > 	/*
> > 	 * In hard interrupt context it's safe when soft interrupts
> > 	 * are enabled, which means the interrupt did not hit in
> > 	 * a fpregs_lock()'ed critical region.
> > 	 */
> > 	return !softirq_count();
> > }
> >
> > Looks we are relying on this to catch the above *small* window
> > yet, we're in fpregs_lock() region yet.
>
> Kernel use of FPU from (soft) IRQ context is required to check irq_fpu_usable()
> (e.g. via may_use_simd()), i.e. calling fpregs_lock() protects against the kernel
> using the FPU and thus setting TIF_NEED_FPU_LOAD.
>
> The WARN in kernel_fpu_begin_mask() is purely a sanity check to help detect and
> debug buggy users.

OK, I have same understanding w/ you, thanks.

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

