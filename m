Return-Path: <kvm+bounces-58523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88397B9566B
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 12:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F0EF1906FDE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 10:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3C0131D72D;
	Tue, 23 Sep 2025 10:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="bThBhpI0";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="bv0St62r"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2302F2ECE86;
	Tue, 23 Sep 2025 10:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758622376; cv=none; b=ZVI2JodmniURAuk4Gc6cFViKsabt6RbU2qlys0LdjYoIxBnsuNctIKglaezeFnVv4Xo8/PSzbWxP83w0QXDBdYv8FpZVpM+pnyWxAPfFCF0g4nIvYv6qQJ2SuMgYS2b/fyhI9Q3LqvPHpEMpTG2uaTB6MTYcyotC/4UJ0gU+4Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758622376; c=relaxed/simple;
	bh=vSTTYJFexJOXOPGbl9flNs1f8jdpO+hYI2JMuPrhH2M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qAPXoPv+TOGt0qoi25kRzQWocn/LuQU1teWseix6z0KZBCFrVuDwY/OAEQS0CObup7pijspnFJNMC9GtGEYOKuy0e3ZKJR49sWBm4887gAONNgNuMofPyBwwzdYOjwBNtSb/OUOWOVfFcNaxEmVsa7Pl6FMA/Vl6QA2jqL7HhW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=bThBhpI0; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=bv0St62r; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758622373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jbygUmzfw8XS2VUG0sJP6HEJcO918I6DxufbOrM/Lys=;
	b=bThBhpI0ltJ1hqx0PKVweVeLpdM3xppi1mqlVS9P988dnElWJFcno5EqlUW2/LORt+1zHz
	Wfycx0wfOOEs+0yZfXstUOoTY3leeQd5TumBF3E+fPfmgUpBgr3z2gUegc384kvbK/Fw2U
	zMu21rf4c2ypNNk6Q4WKuorRAmddD+LkdASO7a+EzkZR353yMhnagecaosBIt3xUhYRNDU
	sO0qyqawwncogrv4F2rhWO3Rg0Zvfj/jZJB14UU1T0RU54TGMg9OOPdIipGEy6os0k5wJf
	HqsjAOG4y7wjMTQ921422R3Oyvo/iBZvs68IHSoJxmN/QMofzRMMkt5Gab7g/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758622373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jbygUmzfw8XS2VUG0sJP6HEJcO918I6DxufbOrM/Lys=;
	b=bv0St62rsMuDh+7nigvQeW8MWJocEsM7XcTr5+GGEUrX8DshmHpEvAwaL6y/hDZduT7sB4
	IDchlUJGMNv0/6Dw==
To: Jason Gunthorpe <jgg@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, zong.li@sifive.com, tjeznach@rivosinc.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, alex@ghiti.fr
Subject: Re: [RFC PATCH v2 08/18] iommu/riscv: Use MSI table to enable IMSIC
 access
In-Reply-To: <20250922235651.GG1391379@nvidia.com>
References: <20250920203851.2205115-20-ajones@ventanamicro.com>
 <20250920203851.2205115-28-ajones@ventanamicro.com>
 <20250922184336.GD1391379@nvidia.com>
 <20250922-50372a07397db3155fec49c9@orel>
 <20250922235651.GG1391379@nvidia.com>
Date: Tue, 23 Sep 2025 12:12:52 +0200
Message-ID: <87ecrx4guz.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Sep 22 2025 at 20:56, Jason Gunthorpe wrote:
> On Mon, Sep 22, 2025 at 04:20:43PM -0500, Andrew Jones wrote:
>> > It has to do with each PCI BDF having a unique set of
>> > validation/mapping tables for MSIs that are granular to the interrupt
>> > number.
>> 
>> Interrupt numbers (MSI data) aren't used by the RISC-V IOMMU in any way.
>
> Interrupt number is a Linux concept, HW decodes the addr/data pair and
> delivers it to some Linux interrupt. Linux doesn't care how the HW
> treats the addr/data pair, it can ignore data if it wants.

Let me explain this a bit deeper.

As you said, the interrupt number is a pure kernel software construct,
which is mapped to a hardware interrupt source.

The interrupt domain, which is associated to a hardware interrupt
source, creates the mapping and supplies the resulting configuration to
the hardware, so that the hardware is able to raise an interrupt in the
CPU.

In case of MSI, this configuration is the MSI message (address,
data). That's composed by the domain according to the requirements of
the underlying CPU hardware resource. This underlying hardware resource
can be the CPUs interrupt controller itself or some intermediary
hardware entity.

The kernel reflects this in the interrupt domain hierarchy. The simplest
case for MSI is:

     [ CPU domain ] --- [ MSI domain ] -- device

The flow is as follows:

   device driver allocates an MSI interrupt in the MSI domain

   MSI domain allocates an interrupt in the CPU domain

   CPU domain allocates an interrupt vector and composes the
   address/data pair. If @data is written to @address, the interrupt is
   raised in the CPU

   MSI domain converts the address/data pair into device format and
   writes it into the device.

   When the device fires an interrupt it writes @data to @address, which
   raises the interrupt in the CPU at the allocated CPU vector.  That
   vector is then translated to the Linux interrupt number in the
   interrupt handling entry code by looking it up in the CPU domain.

With a remapping domain intermediary this looks like this:

     [ CPU domain ] --- [ Remap domain] --- [ MSI domain ] -- device
 
   device driver allocates an MSI interrupt in the MSI domain

   MSI domain allocates an interrupt in the Remap domain

   Remap domain allocates a resource in the remap space, e.g. an entry
   in the remap translation table and then allocates an interrupt in the
   CPU domain.

   CPU domain allocates an interrupt vector and composes the
   address/data pair. If @data is written to @address, the interrupt is
   raised in the CPU

   Remap domain converts the CPU address/data pair to remap table format
   and writes it to the alloacted entry in that table. It then composes
   a new address/data pair, which points at the remap table entry.

   MSI domain converts the remap address/data pair into device format
   and writes it into the device.

   So when the device fires an interrupt it writes @data to @address,
   which triggers the remap unit. The remap unit validates that the
   address/data pair is valid for the device and if so it writes the CPU
   address/data pair, which raises the interrupt in the CPU at the
   allocated vector. That vector is then translated to the Linux
   interrupt number in the interrupt handling entry code by looking it
   up in the CPU domain.

So from a kernel POV, the address/data pairs are just opaque
configuration values, which are written into the remap table and the
device. Whether the content of @data is relevant or not, is a hardware
implementation detail. That implementation detail is only relevant for
the interrupt domain code, which handle a specific part of the
hierarchy.

The MSI domain does not need to know anything about the content and the
meaning of @address and @data. It just cares about converting that into
the device specific storage format.

The Remap domain does not need to know anything about the content and
the meaning of the CPU domain provided @address and @data. It just cares
about converting that into the remap table specific format.

The hardware entities do not know about the Linux interrupt number at
all. That relationship is purely software managed as a mapping from the
allocated CPU vector to the Linux interrupt number.

Hope that helps.

     tglx


