Return-Path: <kvm+bounces-47995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 347AFAC8281
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 21:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4CC44A5EDC
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 19:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF711CCEE7;
	Thu, 29 May 2025 19:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="kGrtJufm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0671136347
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748546103; cv=none; b=e7kIWv944bfIJ9PIdD/FSBovaSY7g7gcuwnQZaYBB1RjIM3oaK5dlqcBpnkeT5TbjjUJJjm6wZovtbY4EqpT88mt40Tks9DGxvZ+///Nks3J0ToqbZuXdHYMoxstB5G8ztbIcGIi6ZzwC6w0bgTVvlthxaWv81NR9/ayXcr/kVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748546103; c=relaxed/simple;
	bh=jxQBHnuX0eGLUrrbuSwhUrZgUXd7imm5V1HcYAUOa9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L68UMgRi1jvk7ZPQqxHguifsPjXbyfYWvVCPS5R2OKHTQsLsR73FWBJvYc8+/UvidHbIFewWGnWzW/8SjCEcq72ssAeZVdPcY75ICYkFQObN/h+G2P/aJnyU3hWT2RJJOZ/WJrFli8Zl582fvsgVYyUBPXxtlelDxTybIBWF8KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=kGrtJufm; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a366843fa6so680885f8f.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 12:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748546099; x=1749150899; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PETGhQTSZRzlo7qrX63Z+YHbFnHKtUVwIfZH3bLWHOY=;
        b=kGrtJufmiTKrxK3UNeViqIo/wg5K5z2bdwmWHw4USap2SCtFHDkqIKt0AkwpjH23A4
         voSqieWoU+scqCqw86ftvQubNCCdJQtdqBFCn339LxGjBLas4R6CrhQSjnc4/2ntyWgz
         Clv+/kfpm6hivtock1ZGGi0xPXZdA+VXdbRoZgkj+lH/Wa0vrOLzIViWM+KRCAfNhAeO
         7F8LXXUurICCoXfN2NgrqMEi1XBQCVVB33cKXbwbhfFgKDmLcQxqmuGg1rCHbKrtKv7a
         zD4Y8ETAd2XsoPf5tA/xfuvqK1Bmgp1MXRtRbCP/89YbwWDCCvYLapxro5wpuRevqjRT
         dsDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748546099; x=1749150899;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PETGhQTSZRzlo7qrX63Z+YHbFnHKtUVwIfZH3bLWHOY=;
        b=EF0wuxw7FOaE93eFnFpL9RLw+uVg9iawXvxKJSebdk25ZCoViF5P4pvGkOhtKF5HJH
         4XT/dEK1/QOrmA19BCmuH0YES5aKhptWNkYUafRU6szyJDPaJDeeztgV8ZSYTXIjfbCn
         JzzO9IqNeXffvzPNnO+00LLxSjjHiMl1dZpn79M9+nCofLOYQTctchMC5gxXdUXNzcxU
         tOFrDUTBG9gMUBPztjq4xbl9yUMV2CPDIZF0so7ttftiQ4z4PXj+ojq6o91rBWdhXJ1C
         FlfI2TYu2fKDEIhQHsjzJtAYcmO2/0Nqm9SYxmUmuiGhqSbvWlLbe/JMhEhcx/Ty3I1W
         ejVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5qvgEHDBZPxhLNiSkDnsrfF8On4d6HQRyRZZZHKHNOLCunGzvsS6CPXn9l4Mtb2LG39E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf8POApxxweVgJ25sivBgTgJ+QoO3gaoR4xN4zpk5CLprP9Ekz
	ZsMVPePkuwg+nt3FGfi2V1mBk5JEXsOuk+yOzHJ4883WbkA8AlE0E/jDcPIirRa8Xj0=
X-Gm-Gg: ASbGnctKwUAxNkCAgC2Pu190EoX9mNhR95RDLJmG/9D+no9F2mb6zhYi6rgJnRcqpA4
	XHlXcza8OXblkomnacgwFJduGkEDKwHkBAc76AlhmQkd8pAKXpkMc/aQuFho1oOdXaQX9muOYkj
	swODOv5yzBWIo9AjC4LUfs9gIjcMl2sCrRjj8gB0P6YRpwei8169odxA08PC2BjuN8DJQmv6R5h
	jfuU5HGePHyIwgnaM1Jzduxcp8H9Iq/YtbWYoPMvD0GSE0dN4C5fWf0NWNDvy3EdJB+KSzkgVQK
	dH2NMjnE2pKLTzEDKlycGm3KLYwUdNLTkVWWm70cjCT7/EFrIcY/JXgtHMK9NpRdgv378blWNIb
	vDdXnSIlxRyr3crc=
X-Google-Smtp-Source: AGHT+IGhExYqvgFvSbs5q9ZpMpC1uzEuDKmNj/YazFyKTWl/Thue3B6m/H9d1jT5tZwjFvDXoPguhQ==
X-Received: by 2002:a05:6000:430a:b0:3a4:f00b:69b6 with SMTP id ffacd0b85a97d-3a4f7ab15f4mr336349f8f.54.1748546098772;
        Thu, 29 May 2025 12:14:58 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4f009fb0bsm2747906f8f.87.2025.05.29.12.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 12:14:58 -0700 (PDT)
Date: Thu, 29 May 2025 21:14:57 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
Message-ID: <20250529-badd99c8168a8f607c84338a@orel>
References: <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
 <DA3KSSN3MJW5.2CM40VEWBWDHQ@ventanamicro.com>
 <61627296-6f94-45ea-9410-ed0ea2251870@linux.dev>
 <DA5YWWPPVCQW.22VHONAQHOCHE@ventanamicro.com>
 <20250526-224478e15ee50987124a47ac@orel>
 <ace8be22-3dba-41b0-81f0-bf6d661b4343@linux.dev>
 <20250528-ff9f6120de39c3e4eefc5365@orel>
 <1169138f-8445-4522-94dd-ad008524c600@linux.dev>
 <DA8KL716NTCA.2QJX4EW2OI6AL@ventanamicro.com>
 <2bac252c-883c-4f8a-9ae1-283660991520@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2bac252c-883c-4f8a-9ae1-283660991520@linux.dev>

On Thu, May 29, 2025 at 11:44:38AM -0700, Atish Patra wrote:
> 
> On 5/29/25 3:24 AM, Radim Krčmář wrote:
> > I originally gave up on the idea, but I feel kinda bad for Drew now, so
> > trying again:
> 
> I am sorry if some of my replies came across in the wrong way. That was
> never
> the intention.

Not at all. Radim only meant that I was defending his patches, even though
he wasn't :-)

> 
> 
> > 2025-05-28T12:21:59-07:00, Atish Patra <atish.patra@linux.dev>:
> > > On 5/28/25 8:09 AM, Andrew Jones wrote:
> > > > On Wed, May 28, 2025 at 07:16:11AM -0700, Atish Patra wrote:
> > > > > On 5/26/25 4:13 AM, Andrew Jones wrote:
> > > > > > On Mon, May 26, 2025 at 11:00:30AM +0200, Radim Krčmář wrote:
> > > > > > > 2025-05-23T10:16:11-07:00, Atish Patra <atish.patra@linux.dev>:
> > > > > > > > On 5/23/25 6:31 AM, Radim Krčmář wrote:
> > > > > > > > > 2025-05-22T12:03:43-07:00, Atish Patra <atishp@rivosinc.com>:
> > > > > > > > > > Upgrade the SBI version to v3.0 so that corresponding features
> > > > > > > > > > can be enabled in the guest.
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > > > > > > > > ---
> > > > > > > > > > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > > > > > > > > -#define KVM_SBI_VERSION_MAJOR 2
> > > > > > > > > > +#define KVM_SBI_VERSION_MAJOR 3
> > > > > > > > > I think it's time to add versioning to KVM SBI implementation.
> > > > > > > > > Userspace should be able to select the desired SBI version and KVM would
> > > > > > > > > tell the guest that newer features are not supported.
> > > > > > We need new code for this, but it's a good idea.
> > > > > > 
> > > > > > > > We can achieve that through onereg interface by disabling individual SBI
> > > > > > > > extensions.
> > > > > > > > We can extend the existing onereg interface to disable a specific SBI
> > > > > > > > version directly
> > > > > > > > instead of individual ones to save those IOCTL as well.
> > > > > > > Yes, I am all in favor of letting userspace provide all values in the
> > > > > > > BASE extension.
> > > > > We already support vendorid/archid/impid through one reg. I think we just
> > > > > need to add the SBI version support to that so that user space can set it.
> > > > > 
> > > > > > This is covered by your recent patch that provides userspace_sbi.
> > > > > Why do we need to invent new IOCTL for this ? Once the user space sets the
> > > > > SBI version, KVM can enforce it.
> > > > If an SBI spec version provides an extension that can be emulated by
> > > > userspace, then userspace could choose to advertise that spec version,
> > > > implement a BASE probe function that advertises the extension, and
> > > > implement the extension, even if the KVM version running is older
> > > > and unaware of it. But, in order to do that, we need KVM to exit to
> > > > userspace for all unknown SBI calls and to allow BASE to be overridden
> > > You mean only the version field in BASE - Correct ?
> > No, "BASE probe function" is the sbi_probe_extension() ecall.
> > 
> > > > by userspace. The new KVM CAP ioctl allows opting into that new behavior.
> > > But why we need a new IOCTL for that ? We can achieve that with existing
> > > one reg interface with improvements.
> > It's an existing IOCTL with a new data payload, but I can easily use
> > ONE_REG if you want to do everything through that.
> > 
> > KVM doesn't really need any other IOCTL than ONE_REGs, it's just
> > sometimes more reasonable to use a different IOCTL, like ENABLE_CAP.
> > 
> > > > The old KVM with new VMM configuration isn't totally far-fetched. While
> > > > host kernels tend to get updated regularly to include security fixes,
> > > > enterprise kernels tend to stop adding features at some point in order
> > > > to maximize stability. While enterprise VMMs would also eventually stop
> > > > adding features, enterprise consumers are always free to use their own
> > > > VMMs (at their own risk). So, there's a real chance we could have
> > > I think we are years away from that happening (if it happens). My
> > > suggestion was not to
> > > try to build a world where no body lives ;). When we get to that
> > > scenario, the default KVM
> > > shipped will have many extension implemented. So there won't be much
> > > advantage to
> > > reimplement them in the user space. We can also take an informed
> > > decision at that time
> > > if the current selective forwarding approach is better
> > Please don't repeat the design of SUSP/SRST/DBCN.
> > Seeing them is one of the reasons why I proposed the new interface.
> > 
> > "Blindly" forwarding DBCN to userspace is even a minor optimization. :)
> > 
> > >                                                         or we need to
> > > blindly forward any
> > > unknown SBI calls to the user space.
> > Yes, KVM has to do what userpace configures it to do.
> > 
> > I don't think that implementing unsupported SBI extensions in KVM is
> > important -- they should not be a hot path.
> > 
> > > > deployments with older, stable KVM where users want to enable later SBI
> > > > extensions, and, in some cases, that should be possible by just updating
> > > > the VMM -- but only if KVM is only acting as an SBI implementation
> > > > accelerator and not as a userspace SBI implementation gatekeeper.
> > > But some of the SBI extensions are so fundamental that it must be
> > > implemented in KVM
> > > for various reasons pointed by Anup on other thread.
> > No, SBI does not have to be implemented in KVM at all.
> > 
> > We do have a deep disagreement on what is virtualization and the role of
> > KVM in it.  I think that userspace wants a generic ISA accelerator.
> 
> I think the disagreement is the role of SBI in KVM virtualization rather
> than
> a generic virtualization and the role of KVM in it. I completely agree that
> KVM should act as an accelerator and defer the control to the user space in
> most of the cases
> such e.g I/O operations or system related functionalities. However, SBI
> specification solves
> much wider problems than those. Broadly we can categorize SBI
> functionalities into the following
> areas
> 
> 1. Bridging ISA GAP
> 2. Higher Privilege Assistance
> 3. Virtualization
> 4. Platform abstraction
> 5. Confidential computing
> 
> For #1, #3 and #5, I believe user space shouldn't be involved in
> implementation
> some of them are in hot path as well.

IMO, userspace should still be in control of whether or not it's involved
in #1, #3, and #5. It may make little sense for it to be involved, but the
choice should still be its.

> For #4 and #2, there are some
> opportunities which
> can be implemented in user space depending on the exact need. I am still not
> clear what is the exact
> motivation /right now/ to pursue such a path. May be I missed something.
> As per my understanding from our discussion threads, there are two use cases
> possible
> 
> 1. userspace wants to update more states in HSM. What are the states user
> space should care about scounteren (fixed already in usptream) ?
> 2. VMM vs KVM version difference - this may be true in the future depending
> on the speed of RISC-V virtualization adoption in the industry.
> But we are definitely not there yet. Please let me know if I misunderstood
> any use cases.

That's what I'm aware of as well, but I see giving userspace back full
control of what gets accelerated by KVM, and what doesn't, as a fix, which
is why I wouldn't want to delay it any longer.

> 
> > Even if userspace wants SBI for the M-mode interface, security minded
> This is probably a 3rd one ? Why we want M-mode interface in the user space
> ?
> > userspace aims for as little kernel code as possible.
> 
> We trust VMM code more than KVM code ?

We should be skeptical of both, which is why we'd rather put as much code
in userspace as possible. Insecure/faulty userspace will hopefully have
exploits/bugs contained to the single process. An insecure/faulty KVM
means the host is compromised/crashed. On x86, Google put a lot of effort
into moving instruction emulation out of KVM for security concerns[1]. In
general, if it's not a hot path and there's a way to do it in userspace,
then it should be done in userspace (or at least there should be an
option to use userspace -- each use case can choose what's best for
itself).

[1] https://www.linux-kvm.org/images/3/3d/01x02-Steve_Rutherford-Performant_Security_Hardening_of_KVM.pdf

Thanks,
drew

> 
> > Userspace might want to accelerate some SBI extension in KVM, but it
> > should not be KVM who decides what userspace wants.

