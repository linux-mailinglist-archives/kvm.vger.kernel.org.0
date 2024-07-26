Return-Path: <kvm+bounces-22279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F1193CCCD
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 04:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C314B21669
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 02:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E7D210EC;
	Fri, 26 Jul 2024 02:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDTyFOTm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED8E1B947;
	Fri, 26 Jul 2024 02:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721962546; cv=none; b=Ng8IY63Yj41RBJYekR0dnmpYPuxzGIWm4F9Je962ahaNM83ZYWYk4phkltFL0qhhI4aBrZdgSOmi6wmqXCgdjcsqC7JwdwY50sty9+rqfVliIrcFKApf05StRl57ufWeKnGBmFOQRPZZdfBmiEJXmNH8NVz7yHdwrqIIcX5Ld60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721962546; c=relaxed/simple;
	bh=rG5tjABluGl5jSIlvCNi682GBmX8Z4Ux3yVbb7xs/1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GSfyYv2v21A1zHo+5jWaSNvAZh4sD0MHHr8bmicCyYbnO3NVRysiIMoadLsJ30TZ9ZL/lQhoRS4vvur/iyQtNA50s1r2uXGnWTwPmVoMZ8nwsmviqhEbgtvIbYKiQEAKHPT8WCY5tM1BcbUKXD7jlXnpXgRro0tuxmg0qw+v9Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDTyFOTm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C47C116B1;
	Fri, 26 Jul 2024 02:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721962546;
	bh=rG5tjABluGl5jSIlvCNi682GBmX8Z4Ux3yVbb7xs/1Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IDTyFOTmsYAtt/A2DLVLAbZiXfCsmc6MS4ef6q2B5BO6495/+LgUAjj1o3uYs9bGK
	 FFoVUimbtIDrO5eZ6IcbnQAqvd3yapiNt7DPbOE0l+QSor5crhRU3rPi7ElMCj5StJ
	 +KHSPvAnpv1Q9Lw2Nxq97azt1xCNFwmidNjuO/CvbE6GETC3Mrs13XNqS1e7653Kpg
	 W7uikWONpLSEteSQAAK7OMh6074cCkxElm06fMyuf2PQf+mZ/HVETFdpxvSp/21vEZ
	 vtqMGX4LqoWHAAtHhuUR/Ct/j7Y9trBfHZ9W3F+i1hDZsLwO7HjVRmAvH5LLCf364X
	 YkZtjSi0Zdu+g==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7ac469e4c4so211305166b.0;
        Thu, 25 Jul 2024 19:55:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUpc3PvukAmLjyaBRk0xU0vUBsFCBXLx82EPvpe0S1fncRki7r19yUKjv20NJuwhfPqOUQxmXbs9LIXCEYsF6IFtM3MyRSRLvEdb2bYofc9g7yuxMRclmiwisIBi2eW2xhY
X-Gm-Message-State: AOJu0YxpJCgbShr9BLBjb43SEV9U2E9OPPylN7l6bO9ADhkUcZ4szCaD
	CtqhCPl7B25gj2/HsskoetbT/kY0fqI7qLapHWLz6lOocmfp2oG//jiqVXeYtC1336cpG4F3V/m
	g7cB0VcA7blUs3VXeoTgg7yWayC8=
X-Google-Smtp-Source: AGHT+IE4toV1Z8IEIkI9dLEtzNT/nSio8g4ih23Ay9wLdv4UiDf78cC3Ce/5CiLn8M6oYP1rZEPnyxLFAdWIfYBzpXY=
X-Received: by 2002:a17:907:970d:b0:a77:ab9e:9202 with SMTP id
 a640c23a62f3a-a7ab2bb46f7mr777476566b.4.1721962544864; Thu, 25 Jul 2024
 19:55:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6D5128458C9E19E4+20240725134820.55817-1-zhangdandan@uniontech.com>
 <c40854ac-38ef-4781-6c6b-4f74e24f265c@loongson.cn>
In-Reply-To: <c40854ac-38ef-4781-6c6b-4f74e24f265c@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 26 Jul 2024 10:55:32 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
Message-ID: <CAAhV-H5R_kamf=YJ62hb+iFr7Y+cvCaBBrY1rdk_wEEq4+6D_w@mail.gmail.com>
Subject: Re: [PATCH] KVM: Loongarch: Remove undefined a6 argument comment for kvm_hypercall
To: maobibo <maobibo@loongson.cn>
Cc: Dandan Zhang <zhangdandan@uniontech.com>, zhaotianrui@loongson.cn, kernel@xen0n.name, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	wangyuli@uniontech.com, Wentao Guan <guanwentao@uniontech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2024 at 9:49=E2=80=AFAM maobibo <maobibo@loongson.cn> wrote=
:
>
>
>
> On 2024/7/25 =E4=B8=8B=E5=8D=889:48, Dandan Zhang wrote:
> > The kvm_hypercall set for LoongArch is limited to a1-a5.
> > The mention of a6 in the comment is undefined that needs to be rectifie=
d.
> >
> > Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
> > Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
> > ---
> >   arch/loongarch/include/asm/kvm_para.h | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/inc=
lude/asm/kvm_para.h
> > index 335fb86778e2..43ec61589e6c 100644
> > --- a/arch/loongarch/include/asm/kvm_para.h
> > +++ b/arch/loongarch/include/asm/kvm_para.h
> > @@ -39,9 +39,9 @@ struct kvm_steal_time {
> >    * Hypercall interface for KVM hypervisor
> >    *
> >    * a0: function identifier
> > - * a1-a6: args
> > + * a1-a5: args
> >    * Return value will be placed in a0.
> > - * Up to 6 arguments are passed in a1, a2, a3, a4, a5, a6.
> > + * Up to 5 arguments are passed in a1, a2, a3, a4, a5.
> >    */
> >   static __always_inline long kvm_hypercall0(u64 fid)
> >   {
> >
>
> Dandan,
>
> Nice catch. In future hypercall abi may expand such as the number of
> input register and output register, or async hypercall function if there
> is really such requirement.
>
> Anyway the modification is deserved and it is enough to use now, thanks
> for doing it.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Maybe it is better to implement kvm_hypercall6() than remove a6 now?

Huacai
>

