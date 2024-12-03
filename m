Return-Path: <kvm+bounces-32956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A7E9E2DB2
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 21:55:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA7DC166A52
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 20:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62CA2207A20;
	Tue,  3 Dec 2024 20:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="j3xZ7ZWF";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="uAjTjd9B"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EF71FF7CF;
	Tue,  3 Dec 2024 20:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733259337; cv=none; b=Ipk69puueS6NY2t3Q0/O9YebH3XwOHA8zow2+v7pF+jhkBIjMzP2tQtz87o2hXlDbv12PkxoTKQpBqbXi3OsAc/JWeGTfP1hTA9tHQ5t1eUSZeTCpsYQQrnxj6U0OYFHnfzbAPy8PZoDWsodhiQBcOhT1lhir/IUs6/mM195L+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733259337; c=relaxed/simple;
	bh=1Vw7nq1aQDtWvQcv5ozrIWgauqOHp4Xst17oCDS5tdk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=beRRvKuOuzx1Qrymu7zbaXASFe6KQlIShNXPRyjFMXtcwFfkE4T4xv0X7ihKsXLpnRAiHrAQ0m7Tp3q3FwZUaKbt2r3gnxRbKJ/0qMxwv/Sowy0TqlGb16bNcfXaSUWKfRnbgw6cCMuEO2jUcZCp6eRxv2URSXNXTtExvysrnJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=j3xZ7ZWF; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=uAjTjd9B; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1733259333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Vw7nq1aQDtWvQcv5ozrIWgauqOHp4Xst17oCDS5tdk=;
	b=j3xZ7ZWFy2hL7pxYlVg9MJz3602gMHQLlOCSB5IFE2hYgwHiCmqq6cOGP61nFHziKbygNE
	7i/hkkxMjJQOQoOleLMCdadQNQwZBqWFs5xKvdodhd/CIeHlKTZIeeZlIs86hDBKoSKmDC
	u2HfN+VZPWy8mWBSBGZf9bBfGroISFgy4ikLuqlwQ9BIQ5asnEoDD8TxIjhK2jEUXdBSLn
	06fypEp/Dcj14ZildKSQ3yIGDGBX8FXAJdPnrtKBiUJZ4PtzWoeKq+g0YNMdBJ6LwMYn9/
	A2YrNMvXJpddF5IkFNxflgI62NoBk+vmQh1Yooegqi4Ibubo1nM5Yv9LN5pPjg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1733259333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Vw7nq1aQDtWvQcv5ozrIWgauqOHp4Xst17oCDS5tdk=;
	b=uAjTjd9Bdv3Hyb9oR+zF04wYQT7dpe7EddPHw1ftQ1vQ22n9XQU/tWMXhzuhbQ9TYsAtQ/
	3NcMtY0zXJK2JSCg==
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
In-Reply-To: <CAAhSdy08gi998HsTkGpaV+bTWczVSL6D8c7EmuTQqovo63oXDw@mail.gmail.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
 <20241114161845.502027-18-ajones@ventanamicro.com> <87mshcub2u.ffs@tglx>
 <CAAhSdy08gi998HsTkGpaV+bTWczVSL6D8c7EmuTQqovo63oXDw@mail.gmail.com>
Date: Tue, 03 Dec 2024 21:55:32 +0100
Message-ID: <874j3ktrjv.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03 2024 at 22:07, Anup Patel wrote:
> On Tue, Dec 3, 2024 at 7:23=E2=80=AFPM Thomas Gleixner <tglx@linutronix.d=
e> wrote:
>> Sorry, I missed that when reviewing the original IMSIC MSI support.
>>
>> The whole IMSIC MSI support can be moved over to MSI LIB which makes all
>> of this indirection go away and your intermediate domain will just fit
>> in.
>>
>> Uncompiled patch below. If that works, it needs to be split up properly.
>>
>> Note, this removes the setup of the irq_retrigger callback, but that's
>> fine because on hierarchical domains irq_chip_retrigger_hierarchy() is
>> invoked anyway. See try_retrigger().
>
> The IMSIC driver was merged one kernel release before common
> MSI LIB was merged.

Ah indeed.

> We should definitely update the IMSIC driver to use MSI LIB, I will
> try your suggested changes (below) and post a separate series.

Pick up the delta patch I gave Andrew...

