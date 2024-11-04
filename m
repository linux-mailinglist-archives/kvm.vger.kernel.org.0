Return-Path: <kvm+bounces-30522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0DB9BB5C2
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DCF11C2155C
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60BBD13BC2F;
	Mon,  4 Nov 2024 13:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RHM0y5Ap"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D172C2AE93
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726370; cv=none; b=AmaUt5rMQvUCaL5OHwg/Hpj1YvpAUWuKQClT9gEcoT8YvE6YxhIaY8ZQOyGnrfThbFvyUPe26ZMrzs7tgPJir/Jw8M4w4fXI6LA2YyjyqQlg+Eys9k2AymHCySXtC/83JR297TD+SJZwTeb6tzQsfUnsXA5dBtY5Tba3p7DHw0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726370; c=relaxed/simple;
	bh=scUb7SAwqAl5EEyO2kXhSL71Qki0G03FL4CcVLoFIho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YkW3FZEgtAWkzSrd6K3qxrvAdNZQjYB8cA64WHu5ZBFsapa7eVe7+vxua79DtgPmSuF9XMqOMvIffOwyruGLZplVlYzbY9ynAbaEhwum29YrztilPdj1zgcT5wUbYvOSK6i7kFU/4KMZF/pgCFLNuVTNtg6v6aqT6MIDin7ylVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RHM0y5Ap; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fc96f9c41fso44963841fa.0
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 05:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1730726366; x=1731331166; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lARrYvZxE2uyY6URVf+ZDkFNyhIinmek/ei9ImL8GSc=;
        b=RHM0y5ApaBLTa21bykgZ6lN+4MQOatomuHvR+RMSHUhjOqiYpJCjsdWRsXsufSj7yK
         iJlYte9fdREFH6ZVkEDsQPl5ldwWnZHJ/FQLGU4BUpbIHjbyc+Qzm/etMXvN+j5RdsAy
         2rpdvhnVemZQa/1NOafqAJ6R/k0qbCtzRVgT9ohc6S2C6MeLhmA+0kBt/cYiMnA40sUI
         yKTTABYAborJ2FJt49TKuD2DaDJP5UCZItvIoVPnY7euIxJiJLTynx1CtX0aeWdaSDfI
         3Hjv3Q6/4X+uPu/rAw9rAA0awE9lhVWma5/QlTkXgNtR4Ln9FbXUIe+/xBgBB62CSkXD
         l9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730726366; x=1731331166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lARrYvZxE2uyY6URVf+ZDkFNyhIinmek/ei9ImL8GSc=;
        b=pS680m35Fq67XxagASJUKJz6QBX7vw+Nt5HQSMDxUWb/KBiFG/3QbNq0APgrUlPJk4
         uLnBHTJNgujB1RfNsouPEg4JVeeZFCEYUmwe6mosAfmioA6WfiGdxqxScE8c19k0PKRV
         L97mbAQycLuBJZtriqedF03sd2+8oFKmm1bhZumem3WhnyL0GyjXSOM/xMj47hLCdJ6j
         ZbXGLHcj4KOep1IVmqE8hdF2o1/El87F43nVrG0LzywYSFI83rDKKuWY4HQJ+GMpWxaJ
         gkDN6eqLMnJ7cjyYVHG2ku30GycQWZX24OlY9LUbQqr5xmlIoF5Hlsq7rQKF8iXu/ieS
         ckfA==
X-Forwarded-Encrypted: i=1; AJvYcCU5TLQkbq/fpvwOLQO1WWDFB48Yv00i3pl7pyzxZqm4m+a8JnunHYJb9soSaB810voP22s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwilpZCOv6ciEQMlXEuuWdly+cASlP0WchlQRndE5PN3gi32fkE
	inPbdjX71KmAggDMDp7MP0c0ZpK1RnjoigII9c0+5mbaQEkJGFE2aENVCyPeC+geBm2XiJU8ieG
	JOpaHejAECoZuuXJYQF5nN+l2S594oOYYf0loCA==
X-Google-Smtp-Source: AGHT+IGhPab8jh+uf869h58p1p0BRB4pFjO0xN4TR4JkldBqulhRLCRm6iMFCtQY3hH8h2hEmFSyTlBKp0y/jc43UKM=
X-Received: by 2002:a2e:a908:0:b0:2fa:d464:32d3 with SMTP id
 38308e7fff4ca-2fedb488ad0mr44010011fa.20.1730726365811; Mon, 04 Nov 2024
 05:19:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240927-dev-maxh-svukte-rebase-2-v2-0-9afe57c33aee@sifive.com>
 <20240927-dev-maxh-svukte-rebase-2-v2-3-9afe57c33aee@sifive.com>
 <CAAhSdy0ncLTAjEE1s-GWL95sscxwQFsKn1rXyA1_VVfk1bQBiw@mail.gmail.com> <CAHibDywpKUE7r4UfcudDSBZCM=JAC5s40uf+PwQE+oMvZy4aVA@mail.gmail.com>
In-Reply-To: <CAHibDywpKUE7r4UfcudDSBZCM=JAC5s40uf+PwQE+oMvZy4aVA@mail.gmail.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Mon, 4 Nov 2024 18:49:15 +0530
Message-ID: <CAK9=C2WEU53TD+tnWRLC1iLRf+j607s=bZXevkogTnr-cmhPGw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/3] riscv: KVM: Add Svukte extension support for Guest/VM
To: Max Hsu <max.hsu@sifive.com>
Cc: Anup Patel <anup@brainfault.org>, Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@sifive.com>, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Samuel Holland <samuel.holland@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 4, 2024 at 1:14=E2=80=AFPM Max Hsu <max.hsu@sifive.com> wrote:
>
> Hi Anup,
>
> Thank you for the suggestion.
>
> I=E2=80=99m not entirely sure if I fully understand it, but I believe the
> hypervisor should be able to disable the Svukte extension.
>
> Inside the switch-case of kvm_riscv_vcpu_isa_disable_allowed(),
> the default case breaks and returns true.
>
> So that means when the KVM_RISCV_ISA_EXT_SVUKTE passed into
> kvm_riscv_vcpu_isa_disable_allowed() it will return true.
>
> If I've misunderstood, please let me know.

I don't see any code in this patch which disables/enables Svukte for
Guest based on KVM ONE_REG interface.

Regards,
Anup

>
> Best regards,
> Max Hsu
>
> On Fri, Oct 25, 2024 at 3:17=E2=80=AFAM Anup Patel <anup@brainfault.org> =
wrote:
> >
> > On Fri, Sep 27, 2024 at 7:12=E2=80=AFPM Max Hsu <max.hsu@sifive.com> wr=
ote:
> > >
> > > Add KVM ISA extension ONE_REG interface to allow VMM tools to
> > > detect and enable Svukte extension for Guest/VM.
> > >
> > > Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> > > Signed-off-by: Max Hsu <max.hsu@sifive.com>
> > > ---
> > >  arch/riscv/include/uapi/asm/kvm.h | 1 +
> > >  arch/riscv/kvm/vcpu_onereg.c      | 1 +
> > >  2 files changed, 2 insertions(+)
> > >
> > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/u=
api/asm/kvm.h
> > > index e97db3296456e19f79ca02e4c4f70ae1b4abb48b..41b466b7ffaec421e8389=
d3f5b178580091a2c98 100644
> > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > @@ -175,6 +175,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> > >         KVM_RISCV_ISA_EXT_ZCF,
> > >         KVM_RISCV_ISA_EXT_ZCMOP,
> > >         KVM_RISCV_ISA_EXT_ZAWRS,
> > > +       KVM_RISCV_ISA_EXT_SVUKTE,
> > >         KVM_RISCV_ISA_EXT_MAX,
> > >  };
> > >
> > > diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onere=
g.c
> > > index b319c4c13c54ce22d2a7552f4c9f256a0c50780e..67237d6e53882a9fcd2cf=
265aa1704f25cc4a701 100644
> > > --- a/arch/riscv/kvm/vcpu_onereg.c
> > > +++ b/arch/riscv/kvm/vcpu_onereg.c
> > > @@ -41,6 +41,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
> > >         KVM_ISA_EXT_ARR(SVINVAL),
> > >         KVM_ISA_EXT_ARR(SVNAPOT),
> > >         KVM_ISA_EXT_ARR(SVPBMT),
> > > +       KVM_ISA_EXT_ARR(SVUKTE),
> > >         KVM_ISA_EXT_ARR(ZACAS),
> > >         KVM_ISA_EXT_ARR(ZAWRS),
> > >         KVM_ISA_EXT_ARR(ZBA),
> >
> > The KVM_RISCV_ISA_EXT_SVUKTE should be added to the
> > switch-case in kvm_riscv_vcpu_isa_disable_allowed() because
> > hypervisor seems to have no way to disable Svukte for the Guest
> > when it's available on the Host.
> >
> > Regards,
> > Anup
>

