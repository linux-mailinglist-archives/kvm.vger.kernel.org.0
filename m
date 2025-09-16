Return-Path: <kvm+bounces-57730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98965B59A53
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:36:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 601591C06709
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 14:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4813D34AB0D;
	Tue, 16 Sep 2025 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2HBtTeB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4BA32ED38
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 14:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032841; cv=none; b=u6E9uD7RltPztVw2lSqIBbvrqQY0F8f9/mx61jL/CyC1C6aJNM377Vx4IAney9/93T7pULX+gl2bJnud6iFBbzGHhRJBZ3nWvEmquFZQl6ifYeXw+7tc3kegmMGjVLf9SA9n5BJYlRtJooo7siQS12G+/dSXZolBWs1oM+OQHwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032841; c=relaxed/simple;
	bh=q4rUfcvmiJb32MQczGG3S+6Y8g30PLS6+e2uvzs7O0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fvkkeMeoeXgzLlTuJgpr6N4Bce2GAYHta0wTZc0uWZjgzXDrbiTcbYpaetWzTcFs4DXVqYpqSZ6sxvls3h8GyNvfTgJYLj65ehK0dAufQ7mXTcz4IFbXd0hn3VENOoJG8OlpJrWjMUJ6hdZwFCYPcBiNDFJCh1eHcG0eIsHyVuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2HBtTeB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196B1C4CEFD
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758032841;
	bh=q4rUfcvmiJb32MQczGG3S+6Y8g30PLS6+e2uvzs7O0M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=l2HBtTeBHdKqoiSy/dakxKQFFR+ZTEnNdB7CiUwhGGPxzleXSvXfSEOUF/2vwKUd0
	 XFh32KsO7sSvnfeUQQzjB6Z07+N/JYGE2XNJFsudIpGQVSGEVOVsphFyygErU/hYgq
	 bbuWI3rjpW8lKc300skBAduIV+ZJvIUGWem1rBRkCyK54FV/Y9pb/YcUkD9R9fIshH
	 JliGhH0cFRnxHTdW2ffvlzeiIGQPUQ7jZQZF/LZ5KJ6iU/eUM34xcpYNn8ogP1xpyA
	 QM9lHiN9A7ULv3M3YNa9+XDSDCj06GC+FOwCeweCpp1h3XUKWlQZFxeucNnCJiReNI
	 eh8bJccsQWreQ==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b046f6fb230so1075810366b.1
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 07:27:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWXJVbcSQItnBFv62GJZ4xN5Q5fJmMrPdywO9U4vLwRZzYDDYhwaQ4B3oW7egE/chBTWMs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywuu7/AFJAj34aQ7uLxkFWCwp/aXozusH6sOqNkr6KoC1G8a+js
	ldvDzHq0RN/aYWLh6NvtiGfa6V2dcfpNDXUrZfdLkP1UGWvo2eOW//tVIpRZJUozCOUJLhq1tXU
	eZeCxBFk8AxtNiIA4T7HmDnFj0oI/Wtg=
X-Google-Smtp-Source: AGHT+IFqP0fpUqt1ZWajzstj84vE34u4JkQD1agA/3Q1+0riSlytXGPjdEylj+SXW1TR5p7NMwNV5e+mGbeyV8m0vps=
X-Received: by 2002:a17:907:3d02:b0:b04:7eba:1b55 with SMTP id
 a640c23a62f3a-b1680591430mr301532466b.19.1758032839546; Tue, 16 Sep 2025
 07:27:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250913002907.69703-1-yury.norov@gmail.com> <0e330fc0-1200-6a02-7b21-78064fc63a2e@loongson.cn>
In-Reply-To: <0e330fc0-1200-6a02-7b21-78064fc63a2e@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 16 Sep 2025 22:27:07 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6yyM+tDhVix=3RH6VtDMs3E-B7jW1K6Xbn7mryBDW74A@mail.gmail.com>
X-Gm-Features: AS18NWCwWelxSFwVvkzr8lZM6L2aWGgaUs1snDVHDrpyA8a8UYAEXIM94XsZF0M
Message-ID: <CAAhV-H6yyM+tDhVix=3RH6VtDMs3E-B7jW1K6Xbn7mryBDW74A@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: rework pch_pic_update_batch_irqs()
To: Bibo Mao <maobibo@loongson.cn>
Cc: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 9:30=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2025/9/13 =E4=B8=8A=E5=8D=888:29, Yury Norov (NVIDIA) wrote:
> > Use proper bitmap API and drop all the housekeeping code.
> >
> > Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
> > ---
> >   arch/loongarch/kvm/intc/pch_pic.c | 11 +++--------
> >   1 file changed, 3 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/int=
c/pch_pic.c
> > index 119290bcea79..57e13ae51d24 100644
> > --- a/arch/loongarch/kvm/intc/pch_pic.c
> > +++ b/arch/loongarch/kvm/intc/pch_pic.c
> > @@ -35,16 +35,11 @@ static void pch_pic_update_irq(struct loongarch_pch=
_pic *s, int irq, int level)
> >   /* update batch irqs, the irq_mask is a bitmap of irqs */
> >   static void pch_pic_update_batch_irqs(struct loongarch_pch_pic *s, u6=
4 irq_mask, int level)
> >   {
> > -     int irq, bits;
> > +     DECLARE_BITMAP(irqs, 64) =3D { BITMAP_FROM_U64(irq_mask) };
> > +     unsigned int irq;
> >
> > -     /* find each irq by irqs bitmap and update each irq */
> > -     bits =3D sizeof(irq_mask) * 8;
> > -     irq =3D find_first_bit((void *)&irq_mask, bits);
> > -     while (irq < bits) {
> > +     for_each_set_bit(irq, irqs, 64)
> >               pch_pic_update_irq(s, irq, level);
> > -             bitmap_clear((void *)&irq_mask, irq, 1);
> > -             irq =3D find_first_bit((void *)&irq_mask, bits);
> > -     }
> >   }
> >
> >   /* called when a irq is triggered in pch pic */
> >
> Thanks for doing this.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Queued, thanks.

Huacai

>
>

