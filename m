Return-Path: <kvm+bounces-55223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 933A8B2EA3F
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 03:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 699C316D96B
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 01:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADA31FE455;
	Thu, 21 Aug 2025 01:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AV2O85AW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EA71A9FB1;
	Thu, 21 Aug 2025 01:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755738842; cv=none; b=I8yXdiRfOwm3kVthymz9VQYaEsAFmoCfDIC9huuoXGptjQ/pY+3kU0VkSHT2KwWKCRIw+tW5Ak8+AWnHYlXg3dC9S8mLwtyKkH+Mcaouy4aQIVtB8U+FSe1Ty+r7Vyg0VHrCtZxlwJ+kk0B76+bAx81BizZZgZzE/EqxXyDW4JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755738842; c=relaxed/simple;
	bh=45NXROLhzFWPchWEfmo+8RdCuCIUFvLMSvkuiR//zk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gm2B9up9NX3hhA03oVkexb5kdY7w5G0HjhZ4AwK04KEyG1nXTC5XkmrXqRdtwfGVHDxocdvlYqq2hJejBATCXo0x4+5meRNNEJ3LXkLLcFSzbqoNc5OP7D//Y+rAdcZ79Emg88lPRH8TmK6BN97BH48Kx0GNMUrwHBmUrKjUnoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AV2O85AW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41E9C116C6;
	Thu, 21 Aug 2025 01:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755738841;
	bh=45NXROLhzFWPchWEfmo+8RdCuCIUFvLMSvkuiR//zk8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AV2O85AWad5xKprLZOTLbAOBXZOAckbHAQUSDaQYLVQvbVAes6PrpXuUcvbs3QtB8
	 BgGv2EZTC2/1U020NEKuQXtZc4ZI+PsM6bAxLSTvcpzfOMLUk8Ctz0U/dht5MYivJh
	 DH5dngak565O0ISJSOuj9vdNYTbK9sr613Z7kZCPaYmljzLfEFwEfM7XK3BLHaD72y
	 Ut+oH9mh7w542Mjz0ku+Lmlul9ycBp703J0IRJXsiYM9zTOipts2cut1LtpKmDFYfU
	 IjEB8dEwh/eNwL+yelFy/KBhiuOg53vex3BMPo4zEY0MrghY9fZds2LFVDruWSi7mZ
	 Cuvk3FnYA5Vgg==
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3b9e4193083so436070f8f.3;
        Wed, 20 Aug 2025 18:14:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW036WrLhK0KWmx5PWxiW+KBgPSkC4a5tR1Gd9UWmY6rBHuK/0J2y2JFPQt+zAlScecNx0=@vger.kernel.org, AJvYcCWdprkJWcMT6CyIJlX+8m75lF/ZEsVDr1YC+mQuz5xu6/EpqeOmYe8zVtu0TAiSulJzLdbQ/jpG31pUcfqf@vger.kernel.org
X-Gm-Message-State: AOJu0YyBkGQycySZwbvcnl0GcE4ZyA82yPThNn7CI2LBvfVzqOxucIeD
	VZvGKB5Pt4Wu5oxVeK/Yb+mGRXUiGn5V1GV/G1htJf0S439RcY/aTWHQBnf/fv4q4+3xReHq5M+
	sIxGhL5s0QhlZf1M7f9o08CPLGZCkU3g=
X-Google-Smtp-Source: AGHT+IHZN+pvmQenAfdScnxdgIeND2pxNhMesffXW4PF/YmXxHES0fVAha8XrYgyDwwnSOqPLvKrtGhubH5RGQQu4jQ=
X-Received: by 2002:a5d:5f42:0:b0:3b7:9dc1:74a5 with SMTP id
 ffacd0b85a97d-3c4962226d5mr440951f8f.52.1755738840191; Wed, 20 Aug 2025
 18:14:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250820125952.71689-1-fangyu.yu@linux.alibaba.com>
 <20250820125952.71689-3-fangyu.yu@linux.alibaba.com> <aKXeXd4pZvoQmYB9@troy-wujie14pro-arch>
In-Reply-To: <aKXeXd4pZvoQmYB9@troy-wujie14pro-arch>
From: Guo Ren <guoren@kernel.org>
Date: Thu, 21 Aug 2025 09:13:47 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRBpCj+ToxMMTD9w9fkPHvF=SXNm8mJOUAP_J7RUywxuQ@mail.gmail.com>
X-Gm-Features: Ac12FXyrfWTEOIumNm2zK1RJwo1sCg6Y71V-rBfVkEDGBWsArsLczQzhQ0Kly3w
Message-ID: <CAJF2gTRBpCj+ToxMMTD9w9fkPHvF=SXNm8mJOUAP_J7RUywxuQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] RISC-V KVM: Remove unnecessary HGATP csr_read
To: Troy Mitchell <troy.mitchell@linux.dev>
Cc: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 10:40=E2=80=AFPM Troy Mitchell <troy.mitchell@linux=
.dev> wrote:
>
> On Wed, Aug 20, 2025 at 08:59:52PM +0800, fangyu.yu@linux.alibaba.com wro=
te:
> > From: "Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>
> >
> > The HGATP has been set to zero in gstage_mode_detect(), so there
> > is no need to save the old context. Unify the code convention
> > with gstage_mode_detect().
> >
> > Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
> > Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> > ---
> >  arch/riscv/kvm/vmid.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> > index 5f33625f4070..abb1c2bf2542 100644
> > --- a/arch/riscv/kvm/vmid.c
> > +++ b/arch/riscv/kvm/vmid.c
> > @@ -25,15 +25,12 @@ static DEFINE_SPINLOCK(vmid_lock);
> >
> >  void __init kvm_riscv_gstage_vmid_detect(void)
> >  {
> > -     unsigned long old;
> > -
> >       /* Figure-out number of VMID bits in HW */
> > -     old =3D csr_read(CSR_HGATP);
> >       csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) =
| HGATP_VMID);
> >       vmid_bits =3D csr_read(CSR_HGATP);
> >       vmid_bits =3D (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
> >       vmid_bits =3D fls_long(vmid_bits);
> > -     csr_write(CSR_HGATP, old);
> > +     csr_write(CSR_HGATP, 0);
> Is setting HGATP to 0 in gstage_mode_detect meaningless now?
It's not meaningless, it means keep hgatp off. CSR_HGATP is set to 0
by gstage_mode_detect(), but that's another independent function whose
coincidence is set to 0. And in that function, we use
"csr_write(CSR_HGATP, 0)", but here we change to confusing save_old &
restore_old coding convention?

So, keep kvm_riscv_gstage_vmid_detect() coding convention clear. We
should follow the same approach as gstage_mode_detect(), that is,
"csr_write(CSR_HGATP, 0)".

 - The first patch is focused on fixing meaning, so keep the minimum
modifications, no coding convention cleanup.
 - The second one is about coding convention, which is no need to Cc:
stable@kernel.org

Hope the above explanation makes sense.

> If so, it might be better to drop it and just keep the one here.
>
>                 - Troy
>
> >
> >       /* We polluted local TLB so flush all guest TLB */
> >       kvm_riscv_local_hfence_gvma_all();
> > --
> > 2.49.0
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv



--=20
Best Regards
 Guo Ren

