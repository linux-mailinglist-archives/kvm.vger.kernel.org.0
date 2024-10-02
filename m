Return-Path: <kvm+bounces-27799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE7AF98D6C3
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 15:44:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C7511C22271
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 13:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1E71D0DC7;
	Wed,  2 Oct 2024 13:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="L8LNRCGJ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="YtR5p8hm"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01F41D0493;
	Wed,  2 Oct 2024 13:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876534; cv=none; b=paj3laBJ+wcfVQRKSL/WRXDxxRercYNHdjgcq5GuMUm9qfetYjbLa0GBYCEqnXu1UhyqSoyjxpohRHd9xGKdFc2TsUVcDXymtYqAxoklHXFX4+DZKLRkQTgVCsQt1tYJCzPWe/s3R5z+/Bv6C6RxCwsoQafPISuVMIWT87tkdkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876534; c=relaxed/simple;
	bh=NBa7U0h1fk0FBmpRarLKeNgZmOvFdjYEeC79+qldwE0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LVqlQwQsVx6XS4zi5zDrjAbD4x6z79U72/hGSxriwM0JZtcQq02YymK7uzHyCFMIQjtuLWmFfxhikMh3O+qCwhzJ744/wfu26zRch2NaiU6HeoA8tzJejFWLwY0DfiCXTDfbzfI9F0uLw7CV6eUfnESCrDo3qy5R1IoVaA3H++U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=L8LNRCGJ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=YtR5p8hm; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1727876531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBa7U0h1fk0FBmpRarLKeNgZmOvFdjYEeC79+qldwE0=;
	b=L8LNRCGJNgjD26YiGUCoMqw+J0Zs+hXaKPH+d5kqTestsYtXLAV9z7i5Lg+1N6WOLSCn60
	kywNfPUaL3mTyAiWQqw/e69CAXK4RQ9FP/DN+7CPod/TxMmx/ZlKCyE0VcxkFVgc8aEG21
	XtfV6TBTBcAuceTl92JbGVUD+g+NncqurF5C7Sq+P9v7MIN/Z2JF/Pu8f8M00ep79n/9Kk
	uyqX15NVLNKJgvndibFESiM3uuLitL02hfCkIEGee/ePfiCWwO3wR3jzbjYKoWn3B9DPr5
	vjOqb7IreLxcBp5GhY/MAe7Iyvn165TMAx9SFYY07Qq4995q/bcuV3m/niG0/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1727876531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBa7U0h1fk0FBmpRarLKeNgZmOvFdjYEeC79+qldwE0=;
	b=YtR5p8hmnGrJhDxTOLfZFyFJVEvvijyqebbrf/uTdYCXKwPgwV/3ISc2Ee+Eqvau2M1V0D
	vSyH0Yhq+3dHAgCw==
To: Huacai Chen <chenhuacai@kernel.org>, Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 x86@kernel.org, Song Gao <gaosong@loongson.cn>
Subject: Re: [PATCH v8 3/3] irqchip/loongson-eiointc: Add extioi virt
 extension support
In-Reply-To: <CAAhV-H4W4LwL3U2HT+-r+6nH5ZSBBbPYL2wdZJqQF7WNkhOgMw@mail.gmail.com>
References: <20240830093229.4088354-1-maobibo@loongson.cn>
 <20240830093229.4088354-4-maobibo@loongson.cn>
 <CAAhV-H4W4LwL3U2HT+-r+6nH5ZSBBbPYL2wdZJqQF7WNkhOgMw@mail.gmail.com>
Date: Wed, 02 Oct 2024 15:42:10 +0200
Message-ID: <878qv6y631.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11 2024 at 17:11, Huacai Chen wrote:
> Hi, Thomas,
>
> On Fri, Aug 30, 2024 at 5:32=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wr=
ote:
>>
>> Interrupts can be routed to maximal four virtual CPUs with one HW
>> EIOINTC interrupt controller model, since interrupt routing is encoded w=
ith
>> CPU bitmap and EIOINTC node combined method. Here add the EIOINTC virt
>> extension support so that interrupts can be routed to 256 vCPUs on
>> hypervisor mode. CPU bitmap is replaced with normal encoding and EIOINTC
>> node type is removed, so there are 8 bits for cpu selection, at most 256
>> vCPUs are supported for interrupt routing.
> This patch is OK for me now, but seems it depends on the first two,
> and the first two will get upstream via loongarch-kvm tree. So is that
> possible to also apply this one to loongarch-kvm with your Acked-by?

Go ahead.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

