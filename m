Return-Path: <kvm+bounces-58553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 541F3B9682C
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E231E18A0F7F
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6225B264A8D;
	Tue, 23 Sep 2025 15:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="lAywEXkQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3CF2417D9
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 15:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758640367; cv=none; b=u6FOiL29F0JNE+DFd1A9xIGLOf5mN/J8Lu+3l0PCFEv1u8BIYGw0+EgzKPihayw1NI3VHtIacNF1CbG+z2zVdRBMqk1gjQ+mLMybujNxOyf1HJweiydN/GkpE9IT2+wgpnqtm1agx5qSM5d5YRJy0R7vmp2/x7x8/lbsLc6oFDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758640367; c=relaxed/simple;
	bh=vasz5nshzs53EJtKEqVkeCvyDuQCp5OET50jfbjxrsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gj0ZRoNNObxNRJjcaQyExt2ZncM9m2IR5cxZWdHrOnNXSYePrEu3foqJ0O7F7iKYyu5YlW2CHgApaKXzygMPPyHQot2BS0ENrJAr3NpGq9BMtS8eKWaFWQ85qQrAPaSqBPbv434NbyVdVtmIICTsFSGlMAI7wpMRoNPUzgkUeB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=lAywEXkQ; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-ea5bcc26849so4339107276.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 08:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1758640365; x=1759245165; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IcoDQc5Q5w0LSP8tWH7zt/4vlU+pjxCSOZ2lxuUdQv4=;
        b=lAywEXkQCDZVXIILg215XD6ZW9ghgSWZjMVb+JpBj/c+FAjDjg0TRmuoX52RC49Fy5
         coNNbgpA8TS5LOyv0sl6OOBLb8vjip2crFXWiz3O/JZ7z30yHYY1UJoGAn5FmKZOlYZo
         V+U+mcIF0l1+RGJgUq8h5pBNvEajYui3AHdKJC72O0BfMtOIXSuPOfyNC/XbcjAvatrd
         aGOrvokM659heSH5dbaK0J0qSlNE+p1OmdtcyvR8hnW7+Q64qSMILZslLq7rdKO0RKku
         nUW9ZW33zFx6V1PE0QxPw9caQoayddhVyiyLtCuC1+En8CJx6qIuFv3LV0WmlPZcUKyf
         EKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758640365; x=1759245165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcoDQc5Q5w0LSP8tWH7zt/4vlU+pjxCSOZ2lxuUdQv4=;
        b=MaOsY+kdy8eu0OCvH1wP4WAlZ6Q0/4xbiMNao333tZxr+PXOdeaAP3BvnlWNSm/8K5
         LRe5tsCEV8v8QqoTN6mPzUCcjhQAjxbeezDovmweQqaChsMsaj8Fqf9jDkVMaCICv7ce
         7Kt0ni091ADr1EotuRY40Uy7XK1iOMP1XMVnA10b12VUIOxCdp7obB1Dzz8PRVsH7c9r
         2hdyPrNKtyIuXpTv1b8jlXgBb0fTApuYrly+woR5H1GHCSFRnHW/22jP+4hQmMInMlYo
         Z4jFPhPpsv5hbvpDpsd9QqymZRW/8xpY1uONoV0M8zoAN/uo8bVjHjt2gT/ly6aJ2C7t
         KwTw==
X-Forwarded-Encrypted: i=1; AJvYcCV2p/PuyKNoyUJQpa++unr6NIonN1KlwgCoHcZBL+nHaYzT8tQ1tamgsz3c0rSoT9NZtrM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXSY0uGb3mMODf0i1XC2DIHG/0fuA+buhWvdcovNSIRp+lYqK3
	tJMpyHGk+XuDwrhA1b/o06nsgjv0avwY1M1lUoQFAqw6hLx0/PMCS+e40WURSUfGR3Y=
X-Gm-Gg: ASbGnct0f09ZwrM29XMfqBYrZq/IkCtwJi2kCpB6WQlEN7PuhTUVE6itxSCC9QfLt7S
	+5bemNqtsItQUFIVrXH9WN8VdB5GpugsQ+b2afgKbtG/TMJRXlOm5LY6QQM3oeDEvwX8v09rjRU
	jW862HqpxswfcKAUVQjQS/qk8WHfgeSOIa/utt0USBZkWPYglcZceV2fUxjmCFpQfF+7ycT6MM5
	fCFXXBYhZ2VsBMfoMUxo6CR4U4lbstKM+lamKsBtKhE7qWuizV7ID3u8b+Oca1dmqoEZunedzv1
	oy7Cshi0eK3Ga0KNVF1MgkkA7EMZNY9FayJwq9lUuSSF8Y6miV7xZLNRRMlWMhwhZmvNIPJtqSu
	gxcmT0tFkOxUkW2Mdt5pMlIU+JhbHDqzDVwU=
X-Google-Smtp-Source: AGHT+IEMS7urR+MAiaqL/uLW9oLtRDN0Kx2AZwEqvz53/Dorjr00baJwfX+lZDlIYthJJ5jr4bmaAw==
X-Received: by 2002:a05:6902:c0f:b0:ea4:302:9a8a with SMTP id 3f1490d57ef6-eb32e058783mr1870670276.6.1758640364669;
        Tue, 23 Sep 2025 08:12:44 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea5ce974ac3sm5081124276.24.2025.09.23.08.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 08:12:44 -0700 (PDT)
Date: Tue, 23 Sep 2025 10:12:42 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, iommu@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, zong.li@sifive.com, tjeznach@rivosinc.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com, anup@brainfault.org, atish.patra@linux.dev, 
	alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
Message-ID: <20250923-b85e3309c54eaff1cdfddcf9@orel>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
 <20250922-50372a07397db3155fec49c9@orel>
 <20250922235651.GG1391379@nvidia.com>
 <87ecrx4guz.ffs@tglx>
 <20250923140646.GM1391379@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923140646.GM1391379@nvidia.com>

On Tue, Sep 23, 2025 at 11:06:46AM -0300, Jason Gunthorpe wrote:
> On Tue, Sep 23, 2025 at 12:12:52PM +0200, Thomas Gleixner wrote:
> > With a remapping domain intermediary this looks like this:
> > 
> >      [ CPU domain ] --- [ Remap domain] --- [ MSI domain ] -- device
> >  
> >    device driver allocates an MSI interrupt in the MSI domain
> > 
> >    MSI domain allocates an interrupt in the Remap domain
> > 
> >    Remap domain allocates a resource in the remap space, e.g. an entry
> >    in the remap translation table and then allocates an interrupt in the
> >    CPU domain.
> 
> Thanks!
> 
> And to be very crystal clear here, the meaning of
> IRQ_DOMAIN_FLAG_ISOLATED_MSI is that the remap domain has a security
> feature such that the device can only trigger CPU domain interrupts
> that have been explicitly allocated in the remap domain for that
> device. The device can never go through the remap domain and trigger
> some other device's interrupt.
> 
> This is usally done by having the remap domain's HW take in the
> Addr/Data pair, do a per-BDF table lookup and then completely replace
> the Addr/Data pair with the "remapped" version. By fully replacing the
> remap domain prevents the device from generating a disallowed
> addr/data pair toward the CPU domain.
> 
> It fundamentally must be done by having the HW do a per-RID/BDF table
> lookup based on the incoming MSI addr/data and fully sanitize the
> resulting output.
> 
> There is some legacy history here. When MSI was first invented the
> goal was to make interrupts scalable by removing any state from the
> CPU side. The device would be told what Addr/Data to send to the CPU
> and the CPU would just take some encoded information in that pair as a
> delivery instruction. No state on the CPU side per interrupt.
> 
> In the world of virtualization it was realized this is not secure, so
> the archs undid the core principal of MSI and the CPU HW has some kind
> of state/table entry for every single device interrupt source.
> 
> x86/AMD did this by having per-device remapping tables in their IOMMU
> device context that are selected by incomming RID and effectively
> completely rewrite the addr/data pair before it reaches the APIC. The
> remap table alone now basically specifies where the interrupt is
> delivered.
> 
> ARM doesn't do remapping, instead the interrupt controller itself has
> a table that converts (BDF,Data) into a delivery instruction. It is
> inherently secure.

Thanks, Jason. All the above information is very much appreciated,
particularly the history.

> 
> That flag has nothing to do with affinity.
>

So the reason I keep bringing affinity into the context of isolation is
that, for MSI-capable RISC-V, each CPU has its own MSI controller (IMSIC).
As riscv is missing data validation its closer to the legacy, insecure
description above, but the "The device would be told what Addr/Data to
send to the CPU and the CPU would just take some encoded information in
that pair as a delivery instruction" part becomes "Addr is used to select
a CPU and then the CPU would take some encoded information in Data as the
delivery instruction". Since setting irq affinity is a way to set Addr
to one of a particular set of CPUs, then a device cannot raise interrupts
on CPUs outside that set. And, only interrupts that the allowed set of
CPUs are aware of may be raised. As a device's irqs move around from
irqbalance or a user's selection we can ensure only the CPU an irq should
be able to reach be reachable by managing the IOMMU MSI table. This gives
us some level of isolation, but there is still the possibility a device
may raise an interrupt it should not be able to when its irqs are affined
to the same CPU as another device's and the malicious/broken device uses
the wrong MSI data. For the non-virt case it's fair to say that's no where
near isolated enough. However, for the virt case, Addr is set to guest
interrupt files (something like virtual IMSICs) which means there will be
no other host device or other guest device irqs sharing those Addrs.
Interrupts for devices assigned to guests are truly isolated (not within
the guest, but we need nested support to fully isolate within the guest
anyway).

In v1, I tried to only turn IRQ_DOMAIN_FLAG_ISOLATED_MSI on for the virt
case, but, as you pointed out, that wasn't a good idea. For v2, I was
hoping the comment above the flag was enough, but thinking about it some
more, I agree it's not. I'm not sure what we can do for this other than
an IOMMU spec change at this point.

Thanks,
drew

