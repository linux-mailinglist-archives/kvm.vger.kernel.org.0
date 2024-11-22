Return-Path: <kvm+bounces-32366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C68D19D6122
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 16:12:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B1601F22168
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 15:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EBF21DDA32;
	Fri, 22 Nov 2024 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Nk9cOUGK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3136148FE1
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732288301; cv=none; b=EQwKzYDkilWpmv2uNb7Zo0wFRvfb+4yQjL7KQ0qFbUK2eE/tsHpnISjXoocf1hU2e71u+mCFrjmBYvkU8MoGapUypimTfZyFpa4bL4dwdA/Fn7UJXIkRVAppbZatWBL8Rl1khnLptjcGdDjGDH22V6oIjdZO+6tBNn19sfnacdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732288301; c=relaxed/simple;
	bh=Bz2c02l8ERcOrBWQwOujhwzOKgirMz3lVpfTP39zZ/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qCSGGQS7koLn7hSH68OoiXAcvkFbI8znbQBfWALibLBT1rGwpHgsi0FK8ruY/Kt4wwQUmCvprKlKaUAeHqiNEzpW3DXjhY/9nw03LKmBnkC62z/jBLNZoz8n1NNKGTi7HIFUgY943HI+PZkpa3Q7iLavT/9aXmWJOSkYo8ZbjcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Nk9cOUGK; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-38241435528so1501605f8f.2
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 07:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732288298; x=1732893098; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2+yAcNB3wPLv50EszBtHoaBKj8Z5/OU1c68F3vdA3XI=;
        b=Nk9cOUGKjfTFh0PRNuyASy7wSJh9j20Vbo/dXs7bjDJDFPZRqidSVV+8KTCiyquIhG
         rHuJaJXGGACBZ6yeqFwut15YSYBSO7n5jVBw1DxyuAgiKFHiiw4biXInfhce2u3coC6b
         4m7+fg/FAGYcvc6Vv7VdV85QEUoe1JrW6hgF9Emui6N0Vjz8mwuOeZwXMm25yaFDlIfG
         8IPVEDjn0mgv1bBPhS8KiJtXv18f8LxQ4hn42CyPN6HS7SWkE3QaiocQQxof7T9VlknC
         lX7W/dwD5FR0sSxpskt+Prs4lbJrYYK7CCesrLwWI+fAjNydwvNrLEEJUodbx3qAlZig
         awsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732288298; x=1732893098;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+yAcNB3wPLv50EszBtHoaBKj8Z5/OU1c68F3vdA3XI=;
        b=C0Fa7PqLX5yE+QdDHc1QZn/Zzmy97ezUDqD9pSBxAFz+nqloIrbamNdkq3roqwNTpK
         zu6/ABBQ2kNv9+VfFNOdYunbAzmol2Q/HfDUlGLln0KLggOUHjUDyCj0BXcXjEqknsPo
         Eu1EIY2OntsW2AHIHwM6KbqK4yNG+v543elXYK55NGvZSsjsoIO29Ea1ciEieOZX6Fv5
         1PW2q7WTgmIsbl08EuFXSKtHzxe5NXxyiETdYNLqdQ1w//TcwqArwfEA4IWXXkGRX1jG
         iuw3w+sQaG6PiCTjuddegv5BCL0nfJcdRmrorG7i1iaYPWlJ8iFF/1u8WZoy+bU5zRk4
         zGcg==
X-Forwarded-Encrypted: i=1; AJvYcCV9Tl1NTkQMY9Ty6eqNgTZ1w0BZCy5hz6tA9RfBGUihSemM+7NpukQMQrbjOb2wne/CUpA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaZ9RYZWWTy/IZ3/D6TBl4Q3I8GSqVu8vRmn4URhxbMgak+WH9
	nbSWI+SiW3xhCpn1MmGisNZZxRzNafGg3Zw8GE8NwZrE9sqZjqjsydp/rau6eps=
X-Gm-Gg: ASbGncsVmtb+xvSJjaJekpNnC6v+FwcQLyx23VM5rFMQGsXCHO5BFR/n3VV8AsaSzac
	yN3m80xgca2J46snT26n8cseFT+gz9sMFR6vpZj9apGG+xA//YmiVKvDo/R1dCT8ZgqNsPcfN+9
	K1T3rsaJtBL6PoK7ccn+/u3jxndnbjrZD65++/YpcEUnyxC2sidFuCYJvwhHamHISmMn/pQWUVR
	1Ut4j0fNcIh6iZxSs65qTGlVe00Lj7uAN44EG8vsEKjx1tOmVredbo2oauWdTIY4wUA7NLpqBNf
	/AlBC9deSb3I9WiUOC3c16s7Q8GB/rPl+Ls=
X-Google-Smtp-Source: AGHT+IHb9Bmd0b73+vONmIkjjrmjPdTvZeeinULGXC1DO8MOvrqHzr0CJRYp4UVboJ7X3gZYYU2K6w==
X-Received: by 2002:a05:6000:144c:b0:382:4f4e:1cd4 with SMTP id ffacd0b85a97d-38260bcf97dmr2659883f8f.42.1732288297448;
        Fri, 22 Nov 2024 07:11:37 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fad60b8sm2624448f8f.17.2024.11.22.07.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 07:11:36 -0800 (PST)
Date: Fri, 22 Nov 2024 16:11:36 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, anup@brainfault.org, atishp@atishpatra.org, tglx@linutronix.de, 
	alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 08/15] iommu/riscv: Add IRQ domain for interrupt
 remapping
Message-ID: <20241121-4e637c492d554280dec3b077@orel>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-25-ajones@ventanamicro.com>
 <20241118184336.GB559636@ziepe.ca>
 <20241119-62ff49fc1eedba051838dba2@orel>
 <20241119140047.GC559636@ziepe.ca>
 <DE13E1DF-7C68-461D-ADCD-8141B1ACEA5E@ventanamicro.com>
 <20241119153622.GD559636@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119153622.GD559636@ziepe.ca>

On Tue, Nov 19, 2024 at 11:36:22AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 19, 2024 at 04:03:05PM +0100, Andrew Jones wrote:
> 
> > >This is the wrong thinking entirely. There is no such thing as a "VFIO
> > >domain".
> > >
> > >Default VFIO created domains should act excatly the same as a DMA API
> > >domain.
> > >
> > >If you want your system to have irq remapping, then it should be on by
> > >default and DMA API gets remapping too. There would need to be a very
> > >strong reason not to do that in order to make something special for
> > >riscv. If so you'd need to add some kind of flag to select it.
> > >
> > >Until you reach nested translation there is no "need" for VFIO to use
> > >any particular stage. The design is that default VFIO uses the same
> > >stage as the DMA API because it is doing the same basic default
> > >translation function.
> > 
> > The RISC-V IOMMU needs to use g-stage for device assignment, if we
> > also want to enable irqbypass, because the IOMMU is specified to
> > only look at the MSI table when g-stage is in use. This is actually
> > another reason the irq domain only makes sense for device
> > assignment.
> 
> Most HW has enablable interrupt remapping and typically Linux just
> turns it always on.
> 
> Is there a reason the DMA API shouldn't use this translation mode too?
> That seems to be the main issue here, you are trying to avoid
> interrupt remapping for DMA API and use it only for VFIO, and haven't
> explained why we need such complexity. Just use it always?

The reason is that the RISC-V IOMMU only checks the MSI table, i.e.
enables its support for MSI remapping, when the g-stage (second-stage)
page table is in use. However, the expected virtual memory scheme for an
OS to use for DMA would be to have s-stage (first-stage) in use and the
g-stage set to 'Bare' (not in use). OIOW, it doesn't appear the spec
authors expected MSI remapping to be enabled for the host DMA use case.
That does make some sense, since it's actually not necessary. For the
host DMA use case, providing mappings for each s-mode interrupt file
which the device is allowed to write to in the s-stage page table
sufficiently enables MSIs to be delivered.

> 
> > >Nested translation has a control to select the stage, and you can
> > >then force the g-stage for VFIO users at that point.
> > 
> > We could force riscv device assignment to always be nested, and when
> > not providing an iommu to the guest, it will still be single-stage,
> > but g-stage, but I don't think that's currently possible with VFIO,
> > is it?
> 
> That isn't what I mean, I mean you should not be forcing the kind of
> domain being created until you get to special cases like nested.
> 
> Default VFIO should work the same as the DMA API.

If "default VFIO" means VFIO without irqbypass, then it would work the
same as the DMA API, assuming all mappings for all necessary s-mode
interrupt files are created (something the DMA API needs as well).
However, VFIO would also need 'vfio_iommu_type1.allow_unsafe_interrupts=1'
to be set for this no-irqbypass configuration.

> 
> > >> The IRQ domain will only be useful for device assignment, as that's when
> > >> an MSI translation will be needed. I can't think of any problems that
> > >> could arise from only creating the IRQ domain when probing assigned
> > >> devices, but I could certainly be missing something. Do you have some
> > >> potential problems in mind?
> > >
> > >I'm not an expert in the interrupt subsystem, but my understanding was
> > >we expect the interrupt domains/etc to be static once a device driver
> > >is probed. Changing things during iommu domain attach is after drivers
> > >are probed. I don't really expect it to work correctly in all corner
> > >cases.
> > 
> > With VFIO the iommu domain attach comes after an unbind/bind, so the
> > new driver is probed.
> 
> That's the opposite of what I mean. The irq domain should be setup
> *before* VFIO binds to the driver.
> 
> Changing the active irq_domain while VFIO is already probed to the
> device is highly unlikely to work right in all cases.
> 
> > I think that's a safe time. However, if there
> > could be cases where the attach does not follow an unbind/bind, then
> > I agree that wouldn't be safe.
> 
> These cases exist.
> 
> > I'll consider always creating an IRQ
> > domain, even if it won't provide any additional functionality unless
> > the device is assigned.
> 
> That isn't ideal, the translation under the IRQs shouldn't really be
> changing as the translation under the IOMMU changes.

Unless the device is assigned to a guest, then the IRQ domain wouldn't
do anything at all (it'd just sit between the device and the device's
old MSI parent domain), but it also wouldn't come and go, risking issues
with anything sensitive to changes in the IRQ domain hierarchy.

> 
> Further, VFIO assumes iommu_group_has_isolated_msi(), ie
> IRQ_DOMAIN_FLAG_ISOLATED_MSI, is fixed while it is is bound. Will that
> be true if the iommu is flapping all about? What will you do when VFIO
> has it attached to a blocked domain?
> 
> It just doesn't make sense to change something so fundamental as the
> interrupt path on an iommu domain attachement. :\

Yes, it does appear I should be doing this at iommu device probe time
instead. It won't provide any additional functionality to use cases which
aren't assigning devices to guests, but it also won't hurt, and it should
avoid the risks you point out.

> 
> > >VFIO is allowed to change the translation as it operates and we expect
> > >that interrupts are not disturbed.
> > 
> > The IRQ domain stays the same during operation, the only changes are
> > the mappings from what the guest believes are its s-mode interrupt
> > files to the hypervisor selected guest interrupt files, and these
> > changes are made possible by the IRQ domain's vcpu-affinity support.
> 
> That is only the case when talking about kvm, this all still has to
> work fully for non-kvm VFIO uses cases too.
> 

I'll rework the irq domain creation to be at iommu device probe time for
the next version.

Thanks,
drew

