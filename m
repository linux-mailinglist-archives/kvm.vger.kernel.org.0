Return-Path: <kvm+bounces-67461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D43CD05FB6
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 21:06:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7B42303F0F4
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 20:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49FB32E6BA;
	Thu,  8 Jan 2026 20:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0arqA01X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653FE328B43
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767902656; cv=none; b=SZ8+VkbCbLxZU1bDxHH0Ev4u61uFwlnfy+1E6MXpTqPID0KFtfvGXOFBL7FE9hevZs1z5+3dHNo2nxgBTmMBcdHCqU1sQAPX27xrIMXiwGu6qETtJS4fLYbQQ9Rd61+I17EB4WQG32LZjO34ZO3Rw3e0LXEGHilbq9bFmmYZdWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767902656; c=relaxed/simple;
	bh=Sc+ak6kXD2O2otUHZGDuYAqOJ/KnbA1ceZEKyhd2zdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OgwMrQffKHe1yFB9U4LNwd26gq5hOV0DaTx2FjVSDjUaCJECI4dhjhzWXRLRS37NGQZT/EgiRGeYxJhYlSmQg737qR4xX4gmRseB7KL/v4jDylxCSfFqMAnq2qDurniO7W5eDD330ni25QuhEKXINo0f2pW0mnjuGhI1+48mdgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0arqA01X; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c337cde7e40so2269455a12.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 12:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767902653; x=1768507453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RHDeNFz490Nrky17RXCNoP5KLrJVy9PVF3wfzv9VqJU=;
        b=0arqA01XpbM3TMubUP5H+mLn2n88A6rvPSWzfrsAKarq2TR9qylufJ57fgzE3QI/63
         i+01Np2Su+UuNW+rNzVa0qSMgG1osn/Et9e4aUK93pxF8el9yVmLbgVqjnu9eLrA9FP9
         ieR3Km8iaPS+m0gZ4LNas7Ayui7ADg/zd1chuZdTKmxWXufxDilfUA7pNWIbTalRaY8K
         KSkBR8bfGhaU5CaQsOmSPzxy18Elbcdtc7V/6Fn4UzslkS0T0GEk8ENkAAedKrU43JSq
         MFYHxw7pxbHzVa8wkZJFKHC9zriuv76mmnnZvmXF9d2wmdRjHcq7FLV6Bu/pRKp2RDle
         90iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767902653; x=1768507453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RHDeNFz490Nrky17RXCNoP5KLrJVy9PVF3wfzv9VqJU=;
        b=eaSD0gFviyl96BoE29b8jp+eoqfM/Ali3kTnOx1LCszpiMJcR8r00Mzl7pyOQaG4k2
         34UbwrOjEvWon2RiSP+Kx9BsyyzOx2X5xaDuVeI9atz5+xYsOILJHHJpPPXEi0ItGwC7
         89QsRKdK9CaFN4pwlwNN493tdFrWsH5E2WCDpIS+Y9oSEoBreZjQHXIfHwbXj+JYyUvh
         T8lzd8WNW7OEZ9nScPszp0bmGTIsouHfKwM9qk+YozgN7Vy7bZkNDkslJ/1xXFNTlO46
         OgLX2F5m0gMGUPW1CaIjPV+sr+scetljdehhf4p5PqEYTrg0HcybZugCLjUSgXTV8qZ1
         QOJg==
X-Forwarded-Encrypted: i=1; AJvYcCVlV8nOF7XMlNFdUY1BG3AmpspcmpoRTzZB04utDSTcJAslKged06bVfcpGKZaf8u06Rhw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3fFM6whLqGyBxw3ytZT8ApgEUgVyy3DkQqz8yV1KuG8rpvYtH
	h7q4ie9Q5ztFqjFt2BGCReR5vm48uxQldKMGi4jPH2L+WUZ64fEQ/HhiaDefd+bve0g0ogc583l
	o0rOEng==
X-Google-Smtp-Source: AGHT+IFhKs48GN0WkSDiAO4qPNHLVPhcEoNB+pDwryoeKjyNGQcxURXgfxIrWzkPwVlbxpHNfeozbbrhcz8=
X-Received: from plhi7.prod.google.com ([2002:a17:903:2ec7:b0:29f:68b:3548])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3947:b0:344:97a7:8c6a
 with SMTP id adf61e73a8af0-3898f9cc49cmr7749765637.51.1767902652739; Thu, 08
 Jan 2026 12:04:12 -0800 (PST)
Date: Thu, 8 Jan 2026 12:04:11 -0800
In-Reply-To: <04c70698-e523-43ae-9092-f360c848d797@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com> <20251206001720.468579-40-seanjc@google.com>
 <04c70698-e523-43ae-9092-f360c848d797@linux.intel.com>
Message-ID: <aWANuxukqWmo36N0@google.com>
Subject: Re: [PATCH v6 39/44] KVM: VMX: Bug the VM if either MSR auto-load
 list is full
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 08, 2025, Dapeng Mi wrote:
> On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 38491962b2c1..2c50ebf4ff1b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1098,6 +1098,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> >  {
> >  	int i, j = 0;
> >  	struct msr_autoload *m = &vmx->msr_autoload;
> > +	struct kvm *kvm = vmx->vcpu.kvm;
> >  
> >  	switch (msr) {
> >  	case MSR_EFER:
> > @@ -1134,12 +1135,10 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> >  	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> >  	j = vmx_find_loadstore_msr_slot(&m->host, msr);
> >  
> > -	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
> > -	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
> > -		printk_once(KERN_WARNING "Not enough msr switch entries. "
> > -				"Can't add msr %x\n", msr);
> > +	if (KVM_BUG_ON(i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm) ||
> > +	    KVM_BUG_ON(j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> 
> nit: Remove one extra space before "m->host.nr".

Oh, that's intentional, so that the rest of the line is aligned with the "guest"
line above.

