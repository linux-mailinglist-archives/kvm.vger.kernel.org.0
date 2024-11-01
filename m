Return-Path: <kvm+bounces-30294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81D4E9B8D5E
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 09:55:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDB40B23172
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 08:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0024157E6B;
	Fri,  1 Nov 2024 08:55:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF475156676
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 08:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730451341; cv=none; b=GJ/VeXYfIOwkMFmMLjPXVLDfYF7qF7Xex3tUmT3sX3p4s2r6KjCAWiuTp7H1vDx0M9Xj+0jnf2GCZz81CFxbswhWQvuSLsom5JmyLQeyN9bhZ4vScUPUD0HqMyLzsbzHa75HOOx4l7U81b4Xv7LAugOJd7iD0hdw9GR2MMqE8qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730451341; c=relaxed/simple;
	bh=BqqWz22+WrSyUAQqAM+VFaYDafctq+D1faIlE+2csoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B620wdzjWfJbLezZd5azcdhjT4eCSFhlUpSgueSgOyy1WO/NwUCvvygteTt1drwRzEvHRjJ4xTKjAIuz5lhTwbohALyjOF4uoiSXRdPu4tMMh5l4tmVkqu038+GeACqtRoo7vDH71M2fBH1MYM/JxL+IrX9/54OPMZP4ixCYB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=mias.mediconcil.de; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mias.mediconcil.de
Received: from bernie by mediconcil.de with local (Exim 4.96)
	(envelope-from <bernie@mias.mediconcil.de>)
	id 1t6nRK-00ET49-0p;
	Fri, 01 Nov 2024 09:55:30 +0100
Date: Fri, 1 Nov 2024 09:55:30 +0100
From: Bernhard Kauer <bk@alpico.io>
To: Sean Christopherson <seanjc@google.com>
Cc: Bernhard Kauer <bk@alpico.io>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
Message-ID: <ZySXgqcYKoHJ3jcf@mias.mediconcil.de>
References: <20241018100919.33814-1-bk@alpico.io>
 <Zxfhy9uifey4wShq@google.com>
 <Zxf4FeRtA3xzdZG3@mias.mediconcil.de>
 <ZyOvPYHrpgPbxUtX@google.com>
 <ZyPjwW55n0JHg0pu@mias.mediconcil.de>
 <ZyQS8AhrBFS6nZuq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyQS8AhrBFS6nZuq@google.com>

On Thu, Oct 31, 2024 at 04:29:52PM -0700, Sean Christopherson wrote:
> > > Unless your VM doesn't need a timer and doesn't need interrupts of
> > > any kind, emulating the local APIC in userspace is going to be much
> > > less performant.
> > 
> > Do you have any performance numbers?
> 
> Heh, nope.  I actually tried to grab some, mostly out of curiosity again, but
> recent (last few years) versions of QEMU don't even support a userspace APIC.
> 
> A single EOI is a great example though.  On a remotely modern CPU, an in-kernel
> APIC allows KVM to enable hardware acceleration so that the EOI is virtualized by
> hardware, i.e. doesn't take a VM-Exit and so the latency is basically the same as
> a native EOI (tens of cycles, maybe less).
> 
> With a userspace APIC, the roundtrip to userspace to emulate the EOI is measured
> in tens of thousands of cycles.  IIRC, last I played around with userspace exits
> the average turnaround time was ~50k cycles.


That sound a lot so I did some quick benchmarking.  An exit is around 1400
TSC cycles on my AMD laptop, instruction emulation takes 1200 and going
to user-level needs at least 6200.  Not terribly slow but still room for
optimizations.


	INSTR
        	CPUID   1394
	        RDMSR   1550
	MMIO
	        APIC    2609
	        IOAPIC  2800
	        HPET    9426
	PIO
        	PIC     1804
	        UART    8011


