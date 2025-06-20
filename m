Return-Path: <kvm+bounces-50159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4409BAE22A8
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 21:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6EDB1C25458
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06262ECD0C;
	Fri, 20 Jun 2025 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tRJFVj6N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB6926E708
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 19:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750446263; cv=none; b=R9KuEQcQGxb4lWXOrY3CUcdhpxtALrvDycT3d1Ndi/norRzwTO5rVcSFNgKco4RNyhx7hpUV8GR3u+yhaZGnTCgyovpqlY+9zfdm4T47ZJY7wFW2AeO6Zl+Y6CeFj27Rac07ME9Cnwq/XYSG9JtroXHpViln+NHQnzsaG70hQoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750446263; c=relaxed/simple;
	bh=OLvgJGuXcx3y3Cr8WfBTX53IpLfHL0hGq+vYXbhOGw8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I5pMXGeTFdn7wQ3rT4lJGoMhUP9wFm3znrXOF2vO0Gq7EgxPC0ZJsi2+ObtEmWbBozyc9qTtZNrASgagQz5tVKhofii7B6/Xw5E8wYv9zCbrx+fsWNzsdLRx3znhBVgfAKkfi1vaYcxeTfzAoJ7s4eJ8fsMj5yGv7un10LXLh7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tRJFVj6N; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31df10dfadso1455780a12.0
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 12:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750446261; x=1751051061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5V4eEdTfLNGKvwTMu6gpmcWM1DlkOACRK3Iq7ll+QeI=;
        b=tRJFVj6NhCCp0XNKPtEDw7LGkBcJVasLzNXauCn3kdi+HR049bie+hNKTPZk287dja
         jputA6e+ZAknPK33XDlISt7SvTEozwuqJKf4uOTTpRa7GfWS4H/FAgm/6h04HxWHnFLN
         DZhuO2wRlBfmuBzVc3/Y4QWtD+5Dk42O8WGAQVTGcrUd1dFD7tfSi9EhY06ArR9En0cq
         Q3aKc6tT33ITbzIUz2i2dXi76PUyc03WGpY5frPsMfSM+zZBnRiHurgdb7mGjM9COfc5
         MDkt6ETI2H5NBKv33yzsAnn2TMVmF2Anl4SKAul6Yb1olulZlrkJUAp5kh/fAWYbZypg
         ZZYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750446261; x=1751051061;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5V4eEdTfLNGKvwTMu6gpmcWM1DlkOACRK3Iq7ll+QeI=;
        b=Gnltlky5IwMPdczd+sAlfm+iBVGXZhG6GAd6b1bDTZPLJmkqO0n90Vk+5zXb5VFGPB
         ANQh7o8gbN4tkACG0mDLMwAE5SmT9wW1c0YIKGN9M+6L1yPFii/C/d50yI7133sh1mFf
         YtDBcjK2rjEUEQLT/vraIF+iyH+xdSb8QZC7/U4k4pYfwxVeT6KKhz+pbcRj5kxeYnLa
         TFyBGml4BxIr1hoYGoIHkE9ENd33/fONLuEVZXyt7cKSX5LpebkJAMeFQfE996jK+14V
         56o+9XOKk8dE+bxHKX3wDCSMelFgG59/FvXKdRVMo7k6dz6v10zFAcVJ1of9YNRXRkBI
         HRuA==
X-Forwarded-Encrypted: i=1; AJvYcCWbx5XYaZV7M1+BL/E8mF6vd+s9Mll3NI3eDVhLN7+QThAYdV0MkelNKkou0JOlgmWmt3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJnwY7FJ9fbMPOtJ8O/KE5VA7mg40DOMo/2PeawF0S+o3YVT42
	H+ihK2GCOv/DF+g01T1mefCxPfORRwqKlttYP1f2EERHj6h34e7N3mXyGm43mRjGQBiewACxlqd
	GQsdMig==
X-Google-Smtp-Source: AGHT+IF1HEaBNlmc+Q9tLzc6oMTF1bn1vxvg37edQgx2B9G2cFY6EZBuAhcrhbwMKilEdjhrXVyorY3eseo=
X-Received: from pjbsr13.prod.google.com ([2002:a17:90b:4e8d:b0:311:8076:14f1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5143:b0:311:fde5:c4c2
 with SMTP id 98e67ed59e1d1-3159d6361damr6100280a91.1.1750446260678; Fri, 20
 Jun 2025 12:04:20 -0700 (PDT)
Date: Fri, 20 Jun 2025 12:04:19 -0700
In-Reply-To: <aFWtB6Vmn9MnfkEi@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-4-seanjc@google.com>
 <86tt4lcgs3.wl-maz@kernel.org> <aErlezuoFJ8u0ue-@google.com>
 <aEyOcJJsys9mm_Xs@linux.dev> <aFWY2LTVIxz5rfhh@google.com> <aFWtB6Vmn9MnfkEi@linux.dev>
Message-ID: <aFWws7h3L-iN52sF@google.com>
Subject: Re: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 20, 2025, Oliver Upton wrote:
> On Fri, Jun 20, 2025 at 10:22:32AM -0700, Sean Christopherson wrote:
> > On Fri, Jun 13, 2025, Oliver Upton wrote:
> > > On Thu, Jun 12, 2025 at 07:34:35AM -0700, Sean Christopherson wrote:
> > > > On Thu, Jun 12, 2025, Marc Zyngier wrote:
> > > > > But not having an VLPI mapping for an interrupt at the point where we're
> > > > > tearing down the forwarding is pretty benign. IRQs *still* go where they
> > > > > should, and we don't lose anything.
> > > 
> > > The VM may not actually be getting torn down, though. The series of
> > > fixes [*] we took for 6.16 addressed games that VMMs might be playing on
> > > irqbypass for a live VM.
> > > 
> > > [*] https://lore.kernel.org/kvmarm/20250523194722.4066715-1-oliver.upton@linux.dev/
> > > 
> > > > All of those failure scenario seem like warnable offences when KVM thinks it has
> > > > configured the IRQ to be forwarded to a vCPU.
> > > 
> > > I tend to agree here, especially considering how horribly fragile GICv4
> > > has been in some systems. I know of a couple implementations where ITS
> > > command failures and/or unmapped MSIs are fatal for the entire machine.
> > > Debugging them has been a genuine pain in the ass.
> > > 
> > > WARN'ing when state tracking for vLPIs is out of whack would've made it
> > > a little easier.
> > 
> > Marc, does this look and read better?
> > 
> > I'd really, really like to get this sorted out asap, as it's the only thing
> > blocking the series, and I want to get the series into linux-next early next
> > week, before I go OOO for ~10 days.
> 
> Can you just send it out as a standalone patch? It's only tangientally
> related to the truckload of x86 stuff

The issue is that "KVM: Don't WARN if updating IRQ bypass route fails" directly
depends on both this patch and decent chunk of the x86 crud.  I could probably
trim some of the x86 crud by reshuffling patches around, but I can't get rid of
it entirely.

> that I'd rather not pull in the event of conflict resolution.

LOL, why not?  :-)

If I post it as a standalone patch, could you/Marc put it into a stable topic
branch based on kvm/master? (kvm/master now has patch 1, yay!)  Then I can create
a topic branch for this mountain of stuff based on the arm64 topic branch.

