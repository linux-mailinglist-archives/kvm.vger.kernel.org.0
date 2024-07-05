Return-Path: <kvm+bounces-21043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60BF7928547
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 11:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 966D81C24D66
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 09:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA1F1474C0;
	Fri,  5 Jul 2024 09:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlrgpoFG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B471482FC
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 09:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720172369; cv=none; b=WGTBlFZmTHB9Bfrhz6S37+wL0GiayTTJGOOybXV6eUHdi0kSzUwsSCgOM3uX02PXvtDKJl3OWt3ltCEGxQaAkg2Y1HZQqaVIbjVq63JY1oet+KJGqs5bJJ32AnfAzjybyItw37iEdNLYIUpqZSxLBISxY2e4GBKL9SUryalWbX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720172369; c=relaxed/simple;
	bh=pG2iZew8BLoCLMgYkV5SQ5t13qWkIIgiwTqcSRCT2JI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tXrw5rsoO/pm4EfhgaFYSfmNcVqcauZIHXRBK76AdoQOklSJz5+KTxSqBfS2L0UOZkuoGvGsG9YotOpN1uiB0tmsndzv84HiFT4E0BothmnJ/ZSEjU2OJlEMQH/NHK0lCy0xinYLgxIL0wpjJRURZzUqZ8YOpPxSqgn5ha5LSKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlrgpoFG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885C5C32781
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 09:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720172369;
	bh=pG2iZew8BLoCLMgYkV5SQ5t13qWkIIgiwTqcSRCT2JI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TlrgpoFGtEANa/tyeVVmeZh7KPuf58wSpMeu1HZTNb/hDFV+qrjmI1w8HjDYhd2x5
	 lLww6ZjfYOtf4Sesd1tN6aq6SJJ/5VYMAFrUBU9CqSU96BNXLOJjhXFSZPcU/t09vU
	 TaLTCAsBandIb8Z8fM5I/8NHNjv2PYlNppTLAzJJsn9lfACJBALL5tdr1NsBF5H5Xw
	 xm+fjN9GoWJhBy8iaV3mKZRr2swtrpcMeTh6sAh4Bc1jkSQJVOF1bfU0kKwVrzP4cO
	 4696K4vfb0UFYUEc7itIfTH7ZNv1HaAUt2qCgj5iGA7MbfuGQ6ljmVk4+6NUrVuyMd
	 UUZLUUs7Nn0wg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a6265d3ba8fso121790766b.0
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2024 02:39:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXxMyJ76JlNgiO7DWHcXAwxUeEZtQIrdOUaLlRFxvjdVPAQnlIj92Je0NG/P7O3Con2BwlfDmijWcIajDdLvH35zymL
X-Gm-Message-State: AOJu0YzLcjylfUzXwuB+dZ8vmdj2Ej1p0rxsNeNPvFcElcWp0ip93C7x
	q9268pmly2l8mYp/fw/n99tg4VNSSViLRxcgIFcEbS/ReBkX8/b8v7S+eZiAPFvqEAPnHIstCTu
	twiXcAKZd3vOMpK+XZ2j1ySIxCd8=
X-Google-Smtp-Source: AGHT+IGL5/nRdBaRnjAc6hNM4qTxVNWhnC7RJ1yHTPd4zyWU2S4tZK8PG5rZJM8LlP5+D5brsO/eDw3r4Ctg0J67X4c=
X-Received: by 2002:a17:907:7e89:b0:a72:5d75:6337 with SMTP id
 a640c23a62f3a-a77ba706ad2mr284326466b.53.1720172368186; Fri, 05 Jul 2024
 02:39:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240613003217.129303-1-jiaqingtong97@gmail.com> <7fcf7b1a-187e-5573-a9f1-336871106af1@loongson.cn>
In-Reply-To: <7fcf7b1a-187e-5573-a9f1-336871106af1@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 5 Jul 2024 17:39:16 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6mGZ-JZ3z9BhK5FAJ43sRdsh-FtLkxCc-FPw1AJTZe9g@mail.gmail.com>
Message-ID: <CAAhV-H6mGZ-JZ3z9BhK5FAJ43sRdsh-FtLkxCc-FPw1AJTZe9g@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: KVM: always make pte yong in page map's fast path
To: maobibo <maobibo@loongson.cn>
Cc: jiaqingtong97@gmail.com, zhaotianrui@loongson.cn, kernel@xen0n.name, 
	loongarch@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.

Huacai

On Thu, Jun 13, 2024 at 9:45=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/6/13 =E4=B8=8A=E5=8D=888:32, jiaqingtong97@gmail.com wrote:
> > From: Jia Qingtong <jiaqingtong97@gmail.com>
> >
> > It seems redundant to check if pte is yong before the call to
> > kvm_pte_mkyoung in kvm_map_page_fast.
> > Just remove the check.
> >
> > Signed-off-by: Jia Qingtong <jiaqingtong97@gmail.com>
> > ---
> >   arch/loongarch/kvm/mmu.c | 6 ++----
> >   1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> > index 98883aa23ab8..a46befcf85dc 100644
> > --- a/arch/loongarch/kvm/mmu.c
> > +++ b/arch/loongarch/kvm/mmu.c
> > @@ -551,10 +551,8 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu=
, unsigned long gpa, bool writ
> >       }
> >
> >       /* Track access to pages marked old */
> > -     new =3D *ptep;
> > -     if (!kvm_pte_young(new))
> > -             new =3D kvm_pte_mkyoung(new);
> > -             /* call kvm_set_pfn_accessed() after unlock */
> > +     new =3D kvm_pte_mkyoung(*ptep);
> > +     /* call kvm_set_pfn_accessed() after unlock */
> Sorry, please ignore my previous comments.
> It is to modify local variable, rather than update pte entry.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>
> >
> >       if (write && !kvm_pte_dirty(new)) {
> >               if (!kvm_pte_write(new)) {
> >
> > base-commit: eb36e520f4f1b690fd776f15cbac452f82ff7bfa
> >
>

