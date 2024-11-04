Return-Path: <kvm+bounces-30448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4843E9BAD5E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:44:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B6B9280F42
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB9D19AA5D;
	Mon,  4 Nov 2024 07:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="IuFEQVEg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B841917C4
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 07:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730706276; cv=none; b=TZUv14xQoXPXQXe2CrJrUupRHtawVlzcqeTyIGpVmPTtnYtOswfrROglX7rN6ijVL+pLy8GPH/38cP9Tm683TiK+765dvJbcACCNhLj6ThuQbUCKlVsS8FRWssYRoXOQ1+7ielI+eyJSVdjAjZs6puojDbL2N4VsxIY0e7ME2+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730706276; c=relaxed/simple;
	bh=3KHj8uEqJirMKpCWT5YbQY/pJhcJbQL7gGQaWllcVwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OkM/v+rJ0KIP9X+YWCWgu6novQsMR3dSOKBWRl9vroJeBUdPc+ZB09esn3MCQUDx15kHoIiv86lo/RtQGPBrAHY3iZLy9MRTGrW63fcYqCa+biVLxH5tBO09VC8jiLNcRzaKLiWIpuJ3l7sMIOPcfcPDjr+MQs2C/4kFLcL9DWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=IuFEQVEg; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c96b2a10e1so5624017a12.2
        for <kvm@vger.kernel.org>; Sun, 03 Nov 2024 23:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1730706273; x=1731311073; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C1UzoUW+225YzvqE1f3m2N8UQrWxc0odLIz4t11IfNg=;
        b=IuFEQVEgTUtMCdc/caf7utELN3o6xuugv9D9LoqelYYb7SdbItupOH4Z2+9XThBimF
         ejTD6DIELWIzmRJK9+Eg46TaMzYiTZCg5XeteyTTzWZK6pRI/3pTlELFkOmdnzicorOZ
         ROIxpXSRVDL3SxKF72mtNWhW3ukMFvASJ4gfugZEMVNdOya+kKf/H+rWforoH7NgJXWI
         c1zErMGoiXPyhYFu38AGjWT6NicIZpTQcADnoUUCgmL6xHhRbUOnqKx4aH6LLOn+AnW8
         LMyFZGkLidj5M10yFCXf29qzyLkqHbwPrMsqCOG+8lfnFmRVxpNUbbAIsFm/S5gBW4Mn
         TF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730706273; x=1731311073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C1UzoUW+225YzvqE1f3m2N8UQrWxc0odLIz4t11IfNg=;
        b=wI8LTgPGMEOHxEecjZisN6hhQds+VM03s6w7WZIiYmUiXLZ5cf6bJSSAQZpM3nPUc1
         tt+VAbv8iU2dhYUSZ5/NexMj8ahn4/0EHbm2yO5zGHJ6b6rw1eszNvzE07tvfSMMyOEs
         CeCBb5clTn1N8skkZp2lyMXCqh7oWNtfHPTSg3jaZ1RbiI4V8jdZoGJ3LSmWUt4rgXj+
         KGz82EBmRszKWHplWXRCDpPH8Uupv3B1oqrCIj8vJIHygFarJ5Yh8nHM7s1WKWCSVuMu
         61tQosB7NQVsF2thkowRnuwYp0KYjx/qdCihK/z+eQup+r2mhYeisRdn7+dt4zI2uFmq
         xKzw==
X-Forwarded-Encrypted: i=1; AJvYcCVqi7JgugWY3S+rHKsTDTlv1Af9iQsZtNmrff9xp2O49rCC1WjF+a3+s28OMir9WXVNpHc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUUVgzsfKyqZS8b6ViByDJEynudEdGgf1RHISe/AeaZIYZ3SZo
	hYU4PtNof1dlp+yvM8DyM5cE+o1WkgNLsO6b+i+bb9z0WQPwfM93+9D5U4U2AdKjR7x2QwAhylp
	LOig3IDJfsiCY3Lz4ZtQ+fL/J6GHkpPdud4D0oQ==
X-Google-Smtp-Source: AGHT+IEksnR3vuhAnQrwH3mab69+1/DkM6JOYCLAfgomVfAxSyJ+/4yRefXDNLq7hexWVnxdTSNFTCh1cLhgy0PD5yI=
X-Received: by 2002:a17:907:7245:b0:a99:f8e2:edec with SMTP id
 a640c23a62f3a-a9de5d6f21cmr3120143866b.21.1730706273092; Sun, 03 Nov 2024
 23:44:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240927-dev-maxh-svukte-rebase-2-v2-0-9afe57c33aee@sifive.com>
 <20240927-dev-maxh-svukte-rebase-2-v2-3-9afe57c33aee@sifive.com> <CAAhSdy0ncLTAjEE1s-GWL95sscxwQFsKn1rXyA1_VVfk1bQBiw@mail.gmail.com>
In-Reply-To: <CAAhSdy0ncLTAjEE1s-GWL95sscxwQFsKn1rXyA1_VVfk1bQBiw@mail.gmail.com>
From: Max Hsu <max.hsu@sifive.com>
Date: Mon, 4 Nov 2024 15:44:21 +0800
Message-ID: <CAHibDywpKUE7r4UfcudDSBZCM=JAC5s40uf+PwQE+oMvZy4aVA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/3] riscv: KVM: Add Svukte extension support for Guest/VM
To: Anup Patel <anup@brainfault.org>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Atish Patra <atishp@atishpatra.org>, Palmer Dabbelt <palmer@sifive.com>, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, Samuel Holland <samuel.holland@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anup,

Thank you for the suggestion.

I=E2=80=99m not entirely sure if I fully understand it, but I believe the
hypervisor should be able to disable the Svukte extension.

Inside the switch-case of kvm_riscv_vcpu_isa_disable_allowed(),
the default case breaks and returns true.

So that means when the KVM_RISCV_ISA_EXT_SVUKTE passed into
kvm_riscv_vcpu_isa_disable_allowed() it will return true.

If I've misunderstood, please let me know.

Best regards,
Max Hsu

On Fri, Oct 25, 2024 at 3:17=E2=80=AFAM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Fri, Sep 27, 2024 at 7:12=E2=80=AFPM Max Hsu <max.hsu@sifive.com> wrot=
e:
> >
> > Add KVM ISA extension ONE_REG interface to allow VMM tools to
> > detect and enable Svukte extension for Guest/VM.
> >
> > Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
> > Signed-off-by: Max Hsu <max.hsu@sifive.com>
> > ---
> >  arch/riscv/include/uapi/asm/kvm.h | 1 +
> >  arch/riscv/kvm/vcpu_onereg.c      | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index e97db3296456e19f79ca02e4c4f70ae1b4abb48b..41b466b7ffaec421e8389d3=
f5b178580091a2c98 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -175,6 +175,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> >         KVM_RISCV_ISA_EXT_ZCF,
> >         KVM_RISCV_ISA_EXT_ZCMOP,
> >         KVM_RISCV_ISA_EXT_ZAWRS,
> > +       KVM_RISCV_ISA_EXT_SVUKTE,
> >         KVM_RISCV_ISA_EXT_MAX,
> >  };
> >
> > diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.=
c
> > index b319c4c13c54ce22d2a7552f4c9f256a0c50780e..67237d6e53882a9fcd2cf26=
5aa1704f25cc4a701 100644
> > --- a/arch/riscv/kvm/vcpu_onereg.c
> > +++ b/arch/riscv/kvm/vcpu_onereg.c
> > @@ -41,6 +41,7 @@ static const unsigned long kvm_isa_ext_arr[] =3D {
> >         KVM_ISA_EXT_ARR(SVINVAL),
> >         KVM_ISA_EXT_ARR(SVNAPOT),
> >         KVM_ISA_EXT_ARR(SVPBMT),
> > +       KVM_ISA_EXT_ARR(SVUKTE),
> >         KVM_ISA_EXT_ARR(ZACAS),
> >         KVM_ISA_EXT_ARR(ZAWRS),
> >         KVM_ISA_EXT_ARR(ZBA),
>
> The KVM_RISCV_ISA_EXT_SVUKTE should be added to the
> switch-case in kvm_riscv_vcpu_isa_disable_allowed() because
> hypervisor seems to have no way to disable Svukte for the Guest
> when it's available on the Host.
>
> Regards,
> Anup

