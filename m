Return-Path: <kvm+bounces-15203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D1A8AA78F
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 06:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CB381C2512F
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 04:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90737947A;
	Fri, 19 Apr 2024 04:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="WXDPgm6I";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PMiG0Y5z"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C8BC127;
	Fri, 19 Apr 2024 04:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713499236; cv=none; b=Iyq5Lh7ejgpfd7YnLVqTJylclfaxJmvbCKJgPCvuqO8ClqWNP5E+7l3lld68WEHTPE2K5cxusErae6qndyi8LMvcb4u4oGbWq4dnizYleAW7G01rWK8xSvHYZxD0gAwQ5B2f3kJqhWTis/EyzkTi58vMrbebIrXmjRg4sVOHL70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713499236; c=relaxed/simple;
	bh=VoP8eWs6X6UpwdEU6DxqE0BQtx+LA81NOt7BFExm19w=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:MIME-Version:
	 Content-Type; b=O0DHtU+eoMUsH1m74AsdWIXBljYCwHWYEvGjDeZRP6nzFMCmBpXiv9FY4KECD2hsK5fItXc/KEn4sVT0JL+emfSbWWptHJ8Kcbk1FKSoM1p3rstYdmSXxuAGSbhRGLtznM5PS6mGhTanVPJsBSgy7Gs86ThN7mODwgC2ZVAvSvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=WXDPgm6I; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PMiG0Y5z; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1713499233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=tgzlDnJme9o2gtucDdd8zdE7h5GgA/sTAqIFz7UDrEM=;
	b=WXDPgm6IvctRQxcXrX6tSm9pkFn4Uz27SX71mqwQgPqsFN4NXYVNJe2xAEeEG036BEZLc+
	WECVmKyTgocKSb3PyYs1ihSxDs1OdbYJtJw1v3Fu0RFhYM6IdCV2EfoZY+ung4mvQYcoOy
	R8GYNByD5/EoaxHWktTs7Mt7b0jH2zMVcIGbc7jAImxKyXO7ic4mI0uZaEue0WMVXw3vGu
	Cfah7ZtTQ/gmagvyItzfZ5I3kObUEzN8NMZzVQPYumUejE8ySO21vJax1c8vsY84vQGJ7Z
	wneXC+XucG71+B5RA+1DsCkGluarqqT8wr2m6/ERkcdfz7pVeWMCDOX4lptGTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1713499233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=tgzlDnJme9o2gtucDdd8zdE7h5GgA/sTAqIFz7UDrEM=;
	b=PMiG0Y5znY4WFNYm0eVJzdOnTurK42sJ9GX83OPgjqBau96ZerAFLLNHFzO3xxvpZY7OOi
	46aPv77kfi2e7ZAg==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev, Lu Baolu
 <baolu.lu@linux.intel.com>, kvm@vger.kernel.org, Dave Hansen
 <dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
 <mingo@redhat.com>, Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jim.harris@samsung.com, a.manzanares@samsung.com, Bjorn Helgaas
 <helgaas@kernel.org>, guang.zeng@intel.com, robert.hoo.linux@gmail.com,
 jacob.jun.pan@linux.intel.com, acme@kernel.org, kan.liang@intel.com,
 "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [PATCH v2 05/13] x86/irq: Reserve a per CPU IDT vector for
 posted MSIs
In-Reply-To: <20240415134354.67c9d1d1@jacob-builder>
Date: Fri, 19 Apr 2024 06:00:24 +0200
Message-ID: <87jzkuxaqv.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Apr 15 2024 at 13:43, Jacob Pan wrote:
> On Mon, 15 Apr 2024 11:53:58 -0700, Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:
>> On Thu, 11 Apr 2024 18:51:14 +0200, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > If we really care then we do it proper for _all_ of them. Something like
>> > the uncompiled below. There is certainly a smarter way to do the build
>> > thing, but my kbuild foo is rusty.  
>> I too had the concern of the wasting system vectors, but did not know how
>> to fix it. But now your code below works well. Tested without KVM in
>> .config to show the gaps:
>> 
>> In VECTOR IRQ domain.
>> 
>> BEFORE:
>> System: 46: 0-31,50,235-236,244,246-255
>> 
>> AFTER:
>> System: 46: 0-31,50,241-242,245-255
>> 
>> The only gap is MANAGED_IRQ_SHUTDOWN_VECTOR(243), which is expected on a
>> running system.
>> 
>> Verified in irqvectors.s: .ascii "->MANAGED_IRQ_SHUTDOWN_VECTOR $243
>> 
>> POSTED MSI/first system vector moved up from 235 to 241 for this case.
>> 
>> Will try to let tools/arch/x86/include/asm/irq_vectors.h also use it
>> instead of manually copy over each time. Any suggestions greatly
>> appreciated.
>>
> On a second thought, if we make system IRQ vector determined at compile
> time based on different CONFIG options, will it break userspace tools such
> as perf? More importantly the rule of not breaking userspace.

tools/arch/x86/include/asm/irq_vectors.h is only used to generate the
list of system vectors for pretty output. And your change already broke
that.

The obvious solution to that is to expose that list in sysfs for
consumption by perf.

But we don't have to do any of that right away. It's an orthogonal
issue. Just waste the extra system vector to start with and then we can
add the compile time dependend change on top if we really care about
gaining back the vectors.

Thanks,

        tglx


