Return-Path: <kvm+bounces-32940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E00CC9E2821
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 17:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DA1A169363
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 16:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 435501FC115;
	Tue,  3 Dec 2024 16:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="T9WrCOrx";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="7UtLMG0F"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4441FA176;
	Tue,  3 Dec 2024 16:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733244617; cv=none; b=b0nFUW8lTPr8RfdszRl2MfsggKrjsZZCSgT/fSwESVQnCHFqOvQmYybocglL35DMwRs8CS3v99567ZHdg1SDUgvM7s1nfDL00vpPoKZiXCXkIOYfB/Hy+cAoWeumbZR00cOIBt+1HYtQpUhliNXolDfQtkyBcR7vcojVYAybz+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733244617; c=relaxed/simple;
	bh=dCLZ/6d9Emqzk6rjNaKFq70Ab/o+bBlDNmnOufWyYvo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tZ3kYYBWM8vFjVcFfDcgsYufJHZhsdzpzaTqCZC930WEaDVnwQDaUz0f2MePbW7E30EGInl1bd3V2oXvj3UOoiiFD0++mQpqcFZfhcuwfE27JLDI7rSr2J0IW/ky50eT5T5N2g49eV7AQaphoqiSurMmMwEzKBg1xg+eUxHGJWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=T9WrCOrx; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=7UtLMG0F; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1733244613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ddUgFgPxg+SS7wo0+tjynAsBYR5Mxah4PrQSaFnCmnk=;
	b=T9WrCOrxKvgOzRX18+gpG03ZanbaXNOW4Q8EJ+AjPslvATRO09l/e/uoFg5o0u3V7mUxIc
	FKCFbTtx7TWQa10iy/a+u0zHSpl3oM+K6vPIY9QN3aZr19zGDrMJOmgz4vPYA6x3G1/c3M
	WxUqbqLRsTrv/siOEk3R5LiTzgSo1JgEv+NOVe8nSL0VGMxhIKdtW2JlhhQbsGo42ibEke
	2lZUHWjzXEzzayRZlFzV90vwPiuaNQ2p8MbtOrPSWndbBJzlUJHotzmppPVkuKRyl+XUKe
	4OyeIQ55HqBlfvUvBUNtTExzn47SF13chN/bZbI7ZfD22izCmNHBbNZyXaOqwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1733244613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ddUgFgPxg+SS7wo0+tjynAsBYR5Mxah4PrQSaFnCmnk=;
	b=7UtLMG0FCrXqstktFxvDODEZS+Zvp0Wod9CVP17RsZNtcP0UOJ6fcJsb5uKaTcWojLI+EE
	5MXVE3lGdmrbDeBQ==
To: Andrew Jones <ajones@ventanamicro.com>
Cc: iommu@lists.linux.dev, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, tjeznach@rivosinc.com, zong.li@sifive.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 anup@brainfault.org, atishp@atishpatra.org, alex.williamson@redhat.com,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 01/15] irqchip/riscv-imsic: Use hierarchy to reach
 irq_set_affinity
In-Reply-To: <20241203-1cadc72be6883bc2d77a8050@orel>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-18-ajones@ventanamicro.com> <87mshcub2u.ffs@tglx>
 <20241203-1cadc72be6883bc2d77a8050@orel>
Date: Tue, 03 Dec 2024 17:50:13 +0100
Message-ID: <87a5dcu2wq.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Dec 03 2024 at 17:27, Andrew Jones wrote:
> On Tue, Dec 03, 2024 at 02:53:45PM +0100, Thomas Gleixner wrote:
>> On Thu, Nov 14 2024 at 17:18, Andrew Jones wrote:
>> The whole IMSIC MSI support can be moved over to MSI LIB which makes all
>> of this indirection go away and your intermediate domain will just fit
>> in.
>> 
>> Uncompiled patch below. If that works, it needs to be split up properly.
>
> Thanks Thomas. I gave your patch below a go, but we now fail to have an
> msi domain set up when probing devices which go through aplic_msi_setup(),
> resulting in an immediate NULL deference in
> msi_create_device_irq_domain(). I'll look closer tomorrow.

Duh! I forgot to update the .select callback. I don't know how you fixed that
compile fail up. Delta patch below.

Thanks,

        tglx
---
--- a/drivers/irqchip/irq-riscv-imsic-platform.c
+++ b/drivers/irqchip/irq-riscv-imsic-platform.c
@@ -180,7 +180,7 @@ static void imsic_irq_debug_show(struct
 static const struct irq_domain_ops imsic_base_domain_ops = {
 	.alloc		= imsic_irq_domain_alloc,
 	.free		= imsic_irq_domain_free,
-	.select		= imsic_irq_domain_select,
+	.select		= msi_lib_irq_domain_select,
 #ifdef CONFIG_GENERIC_IRQ_DEBUGFS
 	.debug_show	= imsic_irq_debug_show,
 #endif

