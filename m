Return-Path: <kvm+bounces-22285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0490B93CE30
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B410D282A6D
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 06:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8037317556E;
	Fri, 26 Jul 2024 06:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QImTnMM+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D44364DC;
	Fri, 26 Jul 2024 06:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721975558; cv=none; b=AZMpG8HQdc9T7YzywPCgyGLlwKx92IE0/QIh0BxPt5Y83yNKy02LFMPV7EFpEcRkTJqiHoA7UE7tu4Q/QikeoZsu6D7B7YKJ+1J2bn66oM5NcwNNFIEHygGxk896+e1M8EpkWO1ZIY/RVWpKKEI5ufuGy/Wh48sad0ol46DXgBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721975558; c=relaxed/simple;
	bh=fX/RmpxpLqVU0ZwFcYrip898jiqaVvWfds9fPGAMYyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cK82dRRGmngXPtNE/EnY0aD9YkCvlnEJaIroXhhQB8pY/4jJeGhniqKQjAlDtoFyrZ/2Bc/I8FNBLlTvVqNgnoZNq7+KUwM3FhQfA7cij1TsmQ5ZMnTuJNQR6NetE+NYH4ODxr1ffZnELCNtT6ft35p3lgNXwmVbezJgAAB1a24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QImTnMM+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2B9C4AF0E;
	Fri, 26 Jul 2024 06:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721975558;
	bh=fX/RmpxpLqVU0ZwFcYrip898jiqaVvWfds9fPGAMYyY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QImTnMM+6dCkK2RXamL4qdnU4iiNYmwsEXSo1/PZxNqsvwIEVadXwvGm154J3mYWz
	 pGx08b7FC6O34VQ5+mjvqSt4W2475nQGEfvlITmVI5bICBZZ6dmQcr1aad+S9DG5ju
	 UU46AsQZzqTZJg78BG6/UAfnTQ40X0vpWvt/GkugvzLD6ALbNd+Lcby/cPqQRflaJU
	 0yqB34U6AoPZaACrc7DNcMVyLA+MdpFrbSJ+4TcmNL5wNutb2kfGnJLR9gI2BegRAR
	 iRkHRfO00GqnYA/YGtgGNDaVDV0fzK/KjJrdGJ3hfG0wJX0GW7u+0dMflGzTmgDrxz
	 oEd+nOKCLwpJQ==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52efa9500e0so1146711e87.3;
        Thu, 25 Jul 2024 23:32:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVLpViAM7QLiAj55BqGUZcqvz3vXDeNNzB/3C/jn6TEdohD23aG19773cIK8E2YfRQQupuPvVz++tJcfDBA9zSGiduqkAvxXfX75P+wycVk9fiySgBUV4TBelGcUSv3X8Ow
X-Gm-Message-State: AOJu0YzMLkM8oudvkuBTLhzZdJ+k13zh4+fRy35gn16MUdnttkNd7qh1
	IJZUI3Q25fDoD9SKshevlKIp5WJBkt73MWuViuyd/Wfb9l8I715CXFOh4p3FJY3FSVPJK8ZMbpR
	bn7RBGxK/pDC3Y7bX8FfG8BzwEi8=
X-Google-Smtp-Source: AGHT+IEbsWFdlyx5e6tE50U4RUretNlLHmWz33cPn1HP2NFpalZmhFOdO5lLwnhvf0kSGhuYk8rSbcPOUm+F569YkEY=
X-Received: by 2002:a05:6512:3c8b:b0:52c:e047:5c38 with SMTP id
 2adb3069b0e04-52fd602ad06mr3047042e87.15.1721975556511; Thu, 25 Jul 2024
 23:32:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6D5128458C9E19E4+20240725134820.55817-1-zhangdandan@uniontech.com>
 <c40854ac-38ef-4781-6c6b-4f74e24f265c@loongson.cn> <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
 <a9245b66-be6e-7211-49dd-a9a2d23ec2cf@loongson.cn>
In-Reply-To: <a9245b66-be6e-7211-49dd-a9a2d23ec2cf@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 26 Jul 2024 14:32:24 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Op_W0B7d4uQQVU_BEkpyQmwf9TCxQA9bYx3=JrQZ8pg@mail.gmail.com>
Message-ID: <CAAhV-H7Op_W0B7d4uQQVU_BEkpyQmwf9TCxQA9bYx3=JrQZ8pg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Loongarch: Remove undefined a6 argument comment for kvm_hypercall
To: maobibo <maobibo@loongson.cn>
Cc: Dandan Zhang <zhangdandan@uniontech.com>, zhaotianrui@loongson.cn, kernel@xen0n.name, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	wangyuli@uniontech.com, Wentao Guan <guanwentao@uniontech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2024 at 11:35=E2=80=AFAM maobibo <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/7/26 =E4=B8=8A=E5=8D=8810:55, Huacai Chen wrote:
> > On Fri, Jul 26, 2024 at 9:49=E2=80=AFAM maobibo <maobibo@loongson.cn> w=
rote:
> >>
> >>
> >>
> >> On 2024/7/25 =E4=B8=8B=E5=8D=889:48, Dandan Zhang wrote:
> >>> The kvm_hypercall set for LoongArch is limited to a1-a5.
> >>> The mention of a6 in the comment is undefined that needs to be rectif=
ied.
> >>>
> >>> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> >>> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
> >>> ---
> >>>    arch/loongarch/include/asm/kvm_para.h | 4 ++--
> >>>    1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/i=
nclude/asm/kvm_para.h
> >>> index 335fb86778e2..43ec61589e6c 100644
> >>> --- a/arch/loongarch/include/asm/kvm_para.h
> >>> +++ b/arch/loongarch/include/asm/kvm_para.h
> >>> @@ -39,9 +39,9 @@ struct kvm_steal_time {
> >>>     * Hypercall interface for KVM hypervisor
> >>>     *
> >>>     * a0: function identifier
> >>> - * a1-a6: args
> >>> + * a1-a5: args
> >>>     * Return value will be placed in a0.
> >>> - * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
> >>> + * Up to 5 arguments are passed in a1, a2, a3, a4, a5.
> >>>     */
> >>>    static __always_inline long kvm_hypercall0(u64 fid)
> >>>    {
> >>>
> >>
> >> Dandan,
> >>
> >> Nice catch. In future hypercall abi may expand such as the number of
> >> input register and output register, or async hypercall function if the=
re
> >> is really such requirement.
> >>
> >> Anyway the modification is deserved and it is enough to use now, thank=
s
> >> for doing it.
> >>
> >> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> > Maybe it is better to implement kvm_hypercall6() than remove a6 now?
> That is one option also. The main reason is that there is no such
> requirement in near future :(, I prefer to removing the annotation and
> keeping it clean.
I don't like removing something and then adding it back again, so if
kvm_hypercall6() is needed in future, it is better to add it now.

Huacai
>
> Regards
> Bibo Mao
> >
> > Huacai
> >>
>
>

