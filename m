Return-Path: <kvm+bounces-19867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F04E390D650
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 16:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 230261C24BDE
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 14:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C973148313;
	Tue, 18 Jun 2024 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxs0alx0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C9D2139C1;
	Tue, 18 Jun 2024 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718722507; cv=none; b=eSS8SR6AR2iRZuzEhMYvr+XiKHhuIroA5hjNv8A9AySw1mk8U/Rq2PSWGEiLW1Vqw5GKYypb1uU1s4kZxbMz9azRo+SnRszHMX5+cv5xepeFhROSq7dxCgOkYumKT9pYLKvhGrQnNQ+RYWG/fO+ABQndP4igbY9tVjMTlGbmJZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718722507; c=relaxed/simple;
	bh=4N2mkqWw4oVDZXaqiKIREnReDpxgfXGU4iX5l5GVKA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gYPcN/h/wpiVR22senpd2rPQgGFiOdnnWtrkv1CpvKiepC7guQsiHf3vVMLlZIByhREhAutCDJ+/7BVAkkJKy3CZnhwNeh42jK4GXYyDMdu5FFOc4IIH+XpUzCO3uBrr3UcBebRevwXrEi22RMGCEvnEE6ynVEMaRYFu97uh+rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxs0alx0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB07C3277B;
	Tue, 18 Jun 2024 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718722506;
	bh=4N2mkqWw4oVDZXaqiKIREnReDpxgfXGU4iX5l5GVKA8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lxs0alx0YtToRHCm6zAsalV7YBw/LX1s6CBqu8/+6OPIq/1oH5hkEKrK4KrN88ej7
	 vZNA2DbVrBIiYXJ/4W7TbAs07nglBd6sFQSIbi/JVUwZ+0dtdiIEqeYTBgrgPu7PKn
	 H5gVdtoB7M23x6a8LVLM62zM60fhvB7X1y/2iD7IN5W+b2Mj3adjCPOpEdgFfbRkOp
	 aXcmduqfHSlbzdWqZi8Gy/OSjc9Q6GzfHrvJ1HFW1nRLm4jbDPXqemb1j0yPKE+VBz
	 CGmeZiSQWWFiOtg6qylODPcpEJvvG2FsWOKL5JyIeWzB8hDIH+CH/mP/yPsdbtR67V
	 aseB6qvfMj9EA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a6f04afcce1so715096766b.2;
        Tue, 18 Jun 2024 07:55:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVa83VZSYTWT6r8UmjSpeaOTwIAg9n7rdLcBcP0/jWjAst2+5Vg2pE+/xCeB+EDeQuxswQUJ6yWnxSRx/t7kWHqZ9qlFSQp08Sp6+NKpdry1KfdYmu2PjZYYtx2T1RuDPf/
X-Gm-Message-State: AOJu0YxiUubDD0Pp6L3jbQ/Iym7EF+7N88bK0LbIlDOTOz6fHktKvuTD
	Y2xA0tb/gxyQEwvh9Ekfz9wKB+kVStu8Wia85z+1prsvXhGwncMMSawDbdiMYjEmSrMGQR0feWa
	jNGvbsj5ZXVYHXqnIm7KgtlxCTkk=
X-Google-Smtp-Source: AGHT+IGxiXPbEMxpPDDWWILuim67EpiBCnDI9u/o2oiytHGesfTPI2v7VbQSw8eWzbi1QtTSUhamNG2ED8uuyyDDYq0=
X-Received: by 2002:a17:906:fc01:b0:a6f:2e80:6e04 with SMTP id
 a640c23a62f3a-a6f60d3775emr972581966b.19.1718722505332; Tue, 18 Jun 2024
 07:55:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618010013.66332-1-yang.lee@linux.alibaba.com> <2812c8ae-62c2-1ac5-087d-202891a513b6@loongson.cn>
In-Reply-To: <2812c8ae-62c2-1ac5-087d-202891a513b6@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 18 Jun 2024 22:54:55 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6ALi1cvt6MB8cXP2QNg77P84vWP4kthaZLyQJURMBv8w@mail.gmail.com>
Message-ID: <CAAhV-H6ALi1cvt6MB8cXP2QNg77P84vWP4kthaZLyQJURMBv8w@mail.gmail.com>
Subject: Re: [PATCH -next] LoongArch: KVM: Remove unneeded semicolon
To: maobibo <maobibo@loongson.cn>
Cc: Yang Li <yang.lee@linux.alibaba.com>, zhaotianrui@loongson.cn, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Queued, thanks.

Huacai

On Tue, Jun 18, 2024 at 10:06=E2=80=AFAM maobibo <maobibo@loongson.cn> wrot=
e:
>
>
>
> On 2024/6/18 =E4=B8=8A=E5=8D=889:00, Yang Li wrote:
> > ./arch/loongarch/kvm/exit.c:764:2-3: Unneeded semicolon
> >
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=3D9343
> > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> > ---
> >   arch/loongarch/kvm/exit.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> > index c86e099af5ca..a68573e091c0 100644
> > --- a/arch/loongarch/kvm/exit.c
> > +++ b/arch/loongarch/kvm/exit.c
> > @@ -761,7 +761,7 @@ static void kvm_handle_service(struct kvm_vcpu *vcp=
u)
> >       default:
> >               ret =3D KVM_HCALL_INVALID_CODE;
> >               break;
> > -     };
> > +     }
> >
> >       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, ret);
> >   }
> >
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>
>

