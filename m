Return-Path: <kvm+bounces-32963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC529E2F5C
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 23:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D69CB163BDB
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 22:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B26BF20A5F5;
	Tue,  3 Dec 2024 22:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="uUpHwAst";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="c+FJ40Es"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155901E2009;
	Tue,  3 Dec 2024 22:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733266761; cv=none; b=ZRx0C/o7oQ8GMlCKeUtX8sECejFZ/YiA719jPu9SKNZ+Q5JHFqt9GuK5qGcGZFyGrSwkEoka4RmARMyJNPcgKYS+z7lRAjY8MxHOhN5B9s2yjZvW6CHpI/Li2Tu/Ai9iV4fiiMABbitMVf0eodMHEvq57afxRmLFOWcYuvQIs+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733266761; c=relaxed/simple;
	bh=Ts5twGI5WLXGCgWxTjs5dJLKgs4RCUcQq24XWrHPHPg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oJrvl76CmSe4J9z06UtVmJKCRMIJuyGqRJC8+yx0KU9dEaFF71GbBzLju9DHhw4Zq4pDUPifvKZBBjaYobOvClplEO7t3GRFTblWlTxUMr2l6PNkJkxb0ph+m1Sjy3XXDW6NdwObfqPOT5xnGMhyhE3NDihUTf+iqLas3q4Ps5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=uUpHwAst; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=c+FJ40Es; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1733266758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/xkyLKWpUVdm6mfEZQQyS1yp6VoP0OWawZ5KoEQBw98=;
	b=uUpHwAstAvPIPqurwVOkG4Z+xsuHUFtZ1THMwPD1xXJxmU3itDeHHaJi+jhl8lLBJ7eZ/4
	rikeyL9y6/r0ZR071XOgksOdUYZ/PQCe+hGK2BvzyddYsmst8WpxFVe+UJVJzQGrdhxgcV
	HLNq7f9LeqLepzH7RGzXJqq5B5jJnr9J9t79clawHMUjQb2mmGKapYpb+SK2DhA2lakxq8
	iBadArbE9YJ0ZSq/71hfYpbAAi3BpT0+6GSmKjPazSH/yyLgWTtVB1F0ADpZ6/xF9oAxLK
	SGrYIEc+XE/odY9cufIHKNqH/CkVZlI3It65iNeu/FplcxvHLpJdwfka9aOq7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1733266758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/xkyLKWpUVdm6mfEZQQyS1yp6VoP0OWawZ5KoEQBw98=;
	b=c+FJ40EsursGL5c6ZmSdluV0Hszl6xqc8ugVFc+JqAg5TyAq0eyEU7V2yrjQR13ZoVbsYq
	CKD1ARZ8ojo9HDCA==
To: Anup Patel <anup@brainfault.org>
Cc: Andrew Jones <ajones@ventanamicro.com>, iommu@lists.linux.dev,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 tjeznach@rivosinc.com, zong.li@sifive.com, joro@8bytes.org,
 will@kernel.org, robin.murphy@arm.com, atishp@atishpatra.org,
 alex.williamson@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 01/15] irqchip/riscv-imsic: Use hierarchy to reach
 irq_set_affinity
In-Reply-To: <874j3ktrjv.ffs@tglx>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-18-ajones@ventanamicro.com> <87mshcub2u.ffs@tglx>
 <CAAhSdy08gi998HsTkGpaV+bTWczVSL6D8c7EmuTQqovo63oXDw@mail.gmail.com>
 <874j3ktrjv.ffs@tglx>
Date: Tue, 03 Dec 2024 23:59:17 +0100
Message-ID: <87ser4s796.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03 2024 at 21:55, Thomas Gleixner wrote:
> On Tue, Dec 03 2024 at 22:07, Anup Patel wrote:
>> On Tue, Dec 3, 2024 at 7:23=E2=80=AFPM Thomas Gleixner <tglx@linutronix.=
de> wrote:
>>> Sorry, I missed that when reviewing the original IMSIC MSI support.
>>>
>>> The whole IMSIC MSI support can be moved over to MSI LIB which makes all
>>> of this indirection go away and your intermediate domain will just fit
>>> in.
>>>
>>> Uncompiled patch below. If that works, it needs to be split up properly.
>>>
>>> Note, this removes the setup of the irq_retrigger callback, but that's
>>> fine because on hierarchical domains irq_chip_retrigger_hierarchy() is
>>> invoked anyway. See try_retrigger().
>>
>> The IMSIC driver was merged one kernel release before common
>> MSI LIB was merged.
>
> Ah indeed.
>
>> We should definitely update the IMSIC driver to use MSI LIB, I will
>> try your suggested changes (below) and post a separate series.
>
> Pick up the delta patch I gave Andrew...

As I was looking at something else MSI related I had a look at
imsic_irq_set_affinity() again.

It's actually required to have the message write in that function and
not afterwards as you invoke imsic_vector_move() from that function.

That's obviously not true for the remap case as that will not change the
message address/data pair because the remap table entry is immutable -
at least I assume so for my mental sanity sake :)

But that brings me to a related question. How is this supposed to work
with non-atomic message updates? PCI/MSI does not necessarily provide
masking, and the write of the address/data pair is done in bits and
pieces. So you can end up with an intermediate state seen by the device
which ends up somewhere in interrupt nirvana space.

See the dance in msi_set_affinity() and commit 6f1a4891a592
("x86/apic/msi: Plug non-maskable MSI affinity race") for further
explanation.

The way how the IMSIC driver works seems to be pretty much the same as
the x86 APIC mess:

        @address is the physical address of the per CPU MSI target
        address and @data is the vector ID on that CPU.

So the non-atomic update in case of non-maskable MSI suffers from the
same problem. It works most of the time, but if it doesn't you might
stare at the occasionally lost interrupt and the stale device in
disbelief for quite a while :)

I might be missing something which magically prevent that though :)

Thanks,

        tglx

