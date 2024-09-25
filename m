Return-Path: <kvm+bounces-27408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 449E2985527
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 10:10:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0380B281446
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 08:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAADD158D81;
	Wed, 25 Sep 2024 08:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DG+rbbRL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC4A155741
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 08:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727251794; cv=none; b=D+te2+CgY/DnpxPmhwkZt7ItlSyZFKrme61OcBWHk1A/koS+yaWcW2fHhse8G6r74WZXIohqbo45ohLCxuWT7Hnhj2593bgG0svcTgW18UCqaHvSKo68sWm+uitUCYJwB+9D92/Ttz+OIV5cfSqwe+nPNISg2BRr9GUEqWrpqWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727251794; c=relaxed/simple;
	bh=gF4N/WbpCBs9EJZcuqGshEGAssyBpYUYMxaE44usRrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBg+ptSc6ltCCElfoH8qBbkMhafpKQrxunJ+Z3PiuOHdfpFtyYh7mNDBVD1Tf297fcudwNe1UhbZeY38ciaMTtNi7vFoLEIgHHguaFzJivRnBjN2Eg2sjYNuS98TaBiUeVAUhyeYP4L+u0KAvmCuBN1a5MJ14EGxUpsLbE2Kk7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DG+rbbRL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8D4C4CEC3;
	Wed, 25 Sep 2024 08:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727251793;
	bh=gF4N/WbpCBs9EJZcuqGshEGAssyBpYUYMxaE44usRrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DG+rbbRLiyvNBK+w0Cmul/A/wbudn6AqIqJQ6+gUdVnW4BRICyhz9J8Uij+8Zkjl1
	 vzYSDqn+pbNP5tMS1BpWEnc8qUbMHMYnnHRZiNCnciWhnhlfk5aZGKAgYQDdRIw8fT
	 +R86Q47zcwm35yWb94i6/VTxPEkXobdfRKbHGsqdvCSVqD8mIiva310lRNWdgO2l1E
	 h+96lANKA/rsFLIRBMzioOHaHfz++XTL+eWz7oZ2Drq9+/qPLtyonFeMafq0Zo6j9X
	 43R/WM/NvSt4In4K5aiPSuR0yPwXS0/CqaoaEKMxG6q8r98TERGVBak4Z1QBwUUk/4
	 ncO5qllgEp2bA==
Date: Wed, 25 Sep 2024 10:09:48 +0200
From: Keith Busch <kbusch@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, x86@kernel.org,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Xu Liu <liuxu@meta.com>
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
Message-ID: <ZvPFTMBXAwHhrU1i@kbusch-mbp>
References: <20240820230431.3850991-1-kbusch@meta.com>
 <ZvAUIaZiFD3lsDI_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvAUIaZiFD3lsDI_@google.com>

On Sun, Sep 22, 2024 at 05:57:05AM -0700, Sean Christopherson wrote:
> On Tue, Aug 20, 2024, Keith Busch wrote:
> > To test, I executed the following program against a qemu emulated pci
> > device resource. Prior to this kernel patch, it would fail with
> > 
> >   traps: vmovdq[378] trap invalid opcode ip:4006b2 sp:7ffe2f5bb680 error:0 in vmovdq[6b2,400000+1000]
>  
> ...
> 
> > +static const struct gprefix pfx_avx_0f_6f_0f_7f = {
> > +	N, I(Avx | Aligned, em_mov), N, I(Avx | Unaligned, em_mov),
> > +};
> > +
> > +static const struct opcode avx_0f_table[256] = {
> > +	/* 0x00 - 0x5f */
> > +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> > +	/* 0x60 - 0x6F */
> > +	X8(N), X4(N), X2(N), N,
> > +	GP(SrcMem | DstReg | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
> > +	/* 0x70 - 0x7F */
> > +	X8(N), X4(N), X2(N), N,
> > +	GP(SrcReg | DstMem | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
> > +	/* 0x80 - 0xFF */
> > +	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
> > +};
> 
> Mostly as an FYI, we're likely going to run into more than just VMOVDQU sooner
> rather than later.  E.g. gcc-13 with -march=x86-64-v3 (which per Vitaly is now
> the default gcc behavior for some distros[*]) compiles this chunk from KVM
> selftests' kvm_fixup_exception():
> 
> 	regs->rip = regs->r11;
> 	regs->r9 = regs->vector;
> 	regs->r10 = regs->error_code;
> 
> intto this monstronsity (which is clever, but oof).
> 
>   405313:       c4 e1 f9 6e c8          vmovq  %rax,%xmm1
>   405318:       48 89 68 08             mov    %rbp,0x8(%rax)
>   40531c:       48 89 e8                mov    %rbp,%rax
>   40531f:       c4 c3 f1 22 c4 01       vpinsrq $0x1,%r12,%xmm1,%xmm0
>   405325:       49 89 6d 38             mov    %rbp,0x38(%r13)
>   405329:       c5 fa 7f 45 00          vmovdqu %xmm0,0x0(%rbp)
> 
> I wouldn't be surprised if the same packing shenanigans get employed when generating
> code for a struct overlay of emulated MMIO.

Thanks for the notice. I'm hoping we can proceed with just the mov
instructions for now, unless someone already has a real use for these on
emulated MMIO. Otherwise, we can cross that bridge when we get there.

As it is, if just the vmovdq[u,a] are okay, I have a follow on for
vmovdqu64, though I'm currently having trouble adding AVX-512 registers.
Simply increasing the size of the struct x86_emulate_ctxt appears to
break something even without trying to emulate those instructions. But I
want to wait to see if this first part is okay before spending too much
time on it.

