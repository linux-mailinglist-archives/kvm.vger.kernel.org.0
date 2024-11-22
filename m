Return-Path: <kvm+bounces-32367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA70C9D6164
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 16:33:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 482F81603C9
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 15:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894B816BE2A;
	Fri, 22 Nov 2024 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="DPDBwdtB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A7C3BBD8
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 15:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732289624; cv=none; b=TIJ2C7U0eSQF/XFjdZY6di4q4nB8hdZxx3OEQQathe2vAysG2WsLC9TKpPxT6xSS+7eXwxKGLkZaEewC9rgJetmqxv3P64tkakQkw1+hWkqShms/tVoE99NJZ0Cc+CsDZUd73XJRALrd34FhF4YrLmRNGabpFBIEZu5de3f/cTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732289624; c=relaxed/simple;
	bh=5/4mOCruP9LCg0HwglvqohMWx01ZFcFeJHiltZsn6Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oeffR8evvO7qLVn1DuN8h/lF7E+s5UrBAnT2pIVxzcTVIO+hz9bJiNeMngpQJFk+bv+CevnfAGp55YUJXNKtkLH+818lm63wzICn1cCHqD/n/9D4Sx5PbKsuxrt66zZiRAB0F0qfgRjENeFIz0SJdIE2F+uW9xD4iCKG2c1SV2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=DPDBwdtB; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4609d8874b1so14444321cf.3
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 07:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1732289622; x=1732894422; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EOCWTCKBT/RmxXc7uytrHzl3RpOs2C/hy6YIYREc/Lg=;
        b=DPDBwdtBRUA3evxTQe3BT7jm8vK1mahsr4wxYESKT0YL338iFFzvFUN6pBKr3xQytM
         fvEeWLlVmERb67jMfHvxyoGz9vwL+mwoWLkmGIuvj5oqcbImX1jZVuOEYPwjGZl1LfJf
         18neTU66RfhIxuzMD3Z4Lk9l3cZjRb0RE+odyanE+g4AGEkkJw0mKxjxdqJcD/EckRMp
         z0MSXLhYtiJ+xH3nbnvV7PzYvXnnYMbOO7jYDL7uBEZV1pdFjsbtRFumEQ+WrnI8MWrS
         mNtw/82RhY+w/piaO8hxJsf+2tk71tF7yXVXiBOxbu8PWV9eowJddZ+sswNNLTbnooGy
         c4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732289622; x=1732894422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EOCWTCKBT/RmxXc7uytrHzl3RpOs2C/hy6YIYREc/Lg=;
        b=g4DZpjk+yhyzydTYUk7RClUKYpdMghXfgQtJ8fP6KQRTLavhwG4Ef+IOyJ2pXUaPUr
         17J5Pa3NBdP/MZbIirUDxsscrFtTI6gqJRhGDV3XPmxBbeBH6kOO4Zqu7oYtu7fYpJdO
         OPDh71WXn/ejkvXWjjwquS7SqlQHH3r5XxQsclsPzIuU9Bv+yfy4foUM6kHRPvQf9pBA
         dqa99kHpRGjN2m/RAJUe5L9kiGsC0B8zu+snPOdlF3/6NDUwmVuSJR1PcXY4eqb/MSgK
         IJ4YHODd7VIINz5Mv2pmHngz+q+Bfhig7wLbszDUOH22Mk3+fFWJkkPQZOs1lp2Myg/9
         pY7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWIaBtbEnc01MNFyw6KXmhmI4kzRpauY/C8/gyHW3Va0OH0i5ik0+ToMmQW+GaLyvTJFss=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgZ3BJn4h8i5nHmCBf7KmBv+Z0+wLrUoY9uk/jW/IRPsOIygT0
	3aYpfxawSG1IPs8pV/2Z5Y8TdmMcWSg+pK5YeGOcdeWZRrKrkOk3Bt6vHoYgJEk=
X-Gm-Gg: ASbGnct8YynivXI068PzY9VdWN84wVJZnn6n9q2dBdRHsubIN9eVI4IrMNYrR2FcrKy
	q0xgTq8aOyccQ78WmPP6Y5JoVWwnd2NY0N0uqYuBvf+msggRZnKzbfAy4qRa7ZMKYkeWgU40Ju6
	VDHNUoCtmgQqPQmVusbVnW/3nEQI6O6bwp/IxLT0zLINiwZL4vdoNYxMXnwhr7XvF4goqUxXcI6
	0F96Wx6xBO47SXzuwOE/0IlfIgmuWLa35sbO39pBzIIJ9QwgqGvBIN844VD5OrgMPCzSStob9ld
	o27k2w2FHg/5EZqxQQu6luU=
X-Google-Smtp-Source: AGHT+IE/84E5Hy9Mt/fOujPHeev+IBUL62FBMMJZ/uhWKf39i8Fv9iytqMnfgjTl0nmjaLXsEb0oaw==
X-Received: by 2002:a05:622a:388:b0:461:186b:6b9d with SMTP id d75a77b69052e-4653d568a95mr41065441cf.17.1732289621751;
        Fri, 22 Nov 2024 07:33:41 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b514152bbasm95886085a.100.2024.11.22.07.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 07:33:40 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tEVfA-00000004Tw6-1J4a;
	Fri, 22 Nov 2024 11:33:40 -0400
Date: Fri, 22 Nov 2024 11:33:40 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, tjeznach@rivosinc.com,
	zong.li@sifive.com, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, anup@brainfault.org, atishp@atishpatra.org,
	tglx@linutronix.de, alex.williamson@redhat.com,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 08/15] iommu/riscv: Add IRQ domain for interrupt
 remapping
Message-ID: <20241122153340.GC773835@ziepe.ca>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-25-ajones@ventanamicro.com>
 <20241118184336.GB559636@ziepe.ca>
 <20241119-62ff49fc1eedba051838dba2@orel>
 <20241119140047.GC559636@ziepe.ca>
 <DE13E1DF-7C68-461D-ADCD-8141B1ACEA5E@ventanamicro.com>
 <20241119153622.GD559636@ziepe.ca>
 <20241121-4e637c492d554280dec3b077@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121-4e637c492d554280dec3b077@orel>

On Fri, Nov 22, 2024 at 04:11:36PM +0100, Andrew Jones wrote:

> The reason is that the RISC-V IOMMU only checks the MSI table, i.e.
> enables its support for MSI remapping, when the g-stage (second-stage)
> page table is in use. However, the expected virtual memory scheme for an
> OS to use for DMA would be to have s-stage (first-stage) in use and the
> g-stage set to 'Bare' (not in use). 

That isn't really a technical reason.

> OIOW, it doesn't appear the spec authors expected MSI remapping to
> be enabled for the host DMA use case.  That does make some sense,
> since it's actually not necessary. For the host DMA use case,
> providing mappings for each s-mode interrupt file which the device
> is allowed to write to in the s-stage page table sufficiently
> enables MSIs to be delivered.

Well, that seems to be the main problem here. You are grappling with a
spec design that doesn't match the SW expecations. Since it has
deviated from what everyone else has done you now have extra
challenges to resolve in some way.

Just always using interrupt remapping if the HW is capable of
interrupt remapping and ignoring the spec "expectation" is a nice a
simple way to make things work with existing Linux.

> If "default VFIO" means VFIO without irqbypass, then it would work the
> same as the DMA API, assuming all mappings for all necessary s-mode
> interrupt files are created (something the DMA API needs as well).
> However, VFIO would also need 'vfio_iommu_type1.allow_unsafe_interrupts=1'
> to be set for this no-irqbypass configuration.

Which isn't what anyone wants, you need to make the DMA API domain be
fully functional so that VFIO works.

> > That isn't ideal, the translation under the IRQs shouldn't really be
> > changing as the translation under the IOMMU changes.
> 
> Unless the device is assigned to a guest, then the IRQ domain wouldn't
> do anything at all (it'd just sit between the device and the device's
> old MSI parent domain), but it also wouldn't come and go, risking issues
> with anything sensitive to changes in the IRQ domain hierarchy.

VFIO isn't restricted to such a simple use model. You have to support
all the generality, which includes fully supporting changing the iommu
translation on the fly.

> > Further, VFIO assumes iommu_group_has_isolated_msi(), ie
> > IRQ_DOMAIN_FLAG_ISOLATED_MSI, is fixed while it is is bound. Will that
> > be true if the iommu is flapping all about? What will you do when VFIO
> > has it attached to a blocked domain?
> > 
> > It just doesn't make sense to change something so fundamental as the
> > interrupt path on an iommu domain attachement. :\
> 
> Yes, it does appear I should be doing this at iommu device probe time
> instead. It won't provide any additional functionality to use cases which
> aren't assigning devices to guests, but it also won't hurt, and it should
> avoid the risks you point out.

Even if you statically create the domain you can't change the value of
IRQ_DOMAIN_FLAG_ISOLATED_MSI depending on what is currently attached
to the IOMMU.

What you are trying to do is not supported by the software stack right
now. You need to make much bigger, more intrusive changes, if you
really want to make interrupt remapping dynamic.

Jason

