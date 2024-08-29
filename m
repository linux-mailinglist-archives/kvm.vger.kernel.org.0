Return-Path: <kvm+bounces-25358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA51C964792
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 811631F252BB
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C441B29BE;
	Thu, 29 Aug 2024 14:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="pWksMAGx";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="a2ymgWm1"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196211AE87B;
	Thu, 29 Aug 2024 14:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724940274; cv=none; b=LTUGSuJ0hKUjaKfu8OoE/0jIOtpcSWHCkF5MF1PQiZlNc0OJf559arCokcG9p9SOrkaDiQmbys8s4ghkg0Uitxld5994E5o+iarA8TktGe6utmpnlTimFbi/2+jdfOTOD6XCQEIJ+IaoX0pGB87N8CV6z3d8+C6hlOio2zfd6Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724940274; c=relaxed/simple;
	bh=Iy3rr4lTi7gvxiZbkZ8fGrFuuRZAf0GwZeBS02I6fhI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=s/3DteTq53Xjc9tNe+sBmasqfnkKvq/k+ygHi7y65oKoUCklwBET8Wrz2YAVaibmxtN2UIe45tEEJ1plUBO6aBOWAT5xXjZDHF/yBQ6H4bWr5XXpMXNq1PDafHJLTU4CF6x4MG01qPCnVZK4U3DfH3OR6kdy/YxscPIhrchyE1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=pWksMAGx; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=a2ymgWm1; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1724940271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iy3rr4lTi7gvxiZbkZ8fGrFuuRZAf0GwZeBS02I6fhI=;
	b=pWksMAGxGdVbcQ+BGtxY7ybXr6LbJ5KARkSear+fdAiDnvtCwVcAwHpIuI8i3Pn8BpE3pV
	q8nu9SjBr3aDcoqaBoLNDos/SlHFS2R5ykfK9TX3BlBGRu1jEbxa5TMGIrIW9hkKYtME/3
	D3h+Tf0x2s1jWhxR/xCijCuLv8xQpI6qGHEHXWah6oG7hC2Qz+RjEYplrLcrzXkYHogw2F
	jGGxHzAHiAoiSokJ4hNBrXNBNOAeW7MR4YBLUqzSOgosOHUvfi469ACq8KmQQcjL0ZQejn
	mafZXr6ZTEXDWMIX9kRhfpekclTn2dEErCQfemKabDxzSQeiHWNzpehqaKaRVw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1724940271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iy3rr4lTi7gvxiZbkZ8fGrFuuRZAf0GwZeBS02I6fhI=;
	b=a2ymgWm1IofddEW390AKixeeMdlX5IA5hk7CDAhBJ33JH0RiPeMVmpo7b5t8dMgZO6DiW7
	uaqpv0jMxsjhYZDw==
To: Huacai Chen <chenhuacai@kernel.org>, maobibo <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 x86@kernel.org, Song Gao <gaosong@loongson.cn>
Subject: Re: [PATCH v7 3/3] irqchip/loongson-eiointc: Add extioi virt
 extension support
In-Reply-To: <CAAhV-H6zBgaTpirE30_q8pxrZ_zkeNWe_696PNZqCWugC+FKrw@mail.gmail.com>
References: <20240823063943.2618675-1-maobibo@loongson.cn>
 <20240823063943.2618675-4-maobibo@loongson.cn>
 <CAAhV-H7t0Bn=iK7UygG6ym=hsCJqZAFVJHqDupm7mL9rVAm0GA@mail.gmail.com>
 <b2722073-a74d-0540-18bb-ae6f450ef123@loongson.cn>
 <CAAhV-H6zBgaTpirE30_q8pxrZ_zkeNWe_696PNZqCWugC+FKrw@mail.gmail.com>
Date: Thu, 29 Aug 2024 16:04:31 +0200
Message-ID: <87ikvja0i8.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29 2024 at 20:29, Huacai Chen wrote:
> On Thu, Aug 29, 2024 at 9:46=E2=80=AFAM maobibo <maobibo@loongson.cn> wro=
te:
>> > I think qemu hasn't release with v-eiointc? So we still have a chance
>> > to modify qemu and this driver to simplify registers:
>> It is already merged in qemu mainline, code is frozen and qemu 9.1 will
>> release soon. Once it is merged in mainline and even if code is not
>> frozen, I will modify it only if it is bug.
> If Thomas think the register definition is OK, then I have no objections.

No objections

