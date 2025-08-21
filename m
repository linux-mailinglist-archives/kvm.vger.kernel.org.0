Return-Path: <kvm+bounces-55224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83CA6B2EAA5
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 03:26:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C37B43B93EE
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 01:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E92A220F35;
	Thu, 21 Aug 2025 01:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8YE/1v+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E64821A43B;
	Thu, 21 Aug 2025 01:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755739572; cv=none; b=QOMS0yvUIZ2x8lG9K6J3FR+dOyWrWSc1/4vsysUvTBPqNlaXhVzh4uXmt/ToHltwCNFBEj5gBEFHEzWkk43HMB/ZKbk0VCvWFgWX61Z3DKPlGfCMGZWqARpHq4P7aYIxlXUcn6DtfGZmvsBiENtrkzxyYrVBJhYBjPR3EZUqrRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755739572; c=relaxed/simple;
	bh=LnGSf8eZmzHDX4YDDFfdF9dk8w7H2oiMRfMTk8c1EfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dT2OCVYZNG6zP/X0+b0i5rQfVwx52Ri/u51lPdLIbPLVtKNyekc873X/oTzPc/dRUDTg+GK4dob48O7AiXYlawLqAkPfg4LMXp9aY00FkEblDJqjD/rjcfpNCOIYVxqhQTzHb1K6kQhWMxnEk/g1QxWyV1yKq1z3OpMtwaBZZGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8YE/1v+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EBAC19421;
	Thu, 21 Aug 2025 01:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755739571;
	bh=LnGSf8eZmzHDX4YDDFfdF9dk8w7H2oiMRfMTk8c1EfA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I8YE/1v+bejfpeH18NyslQeyZvi5Gm6qOWIV82ssje3PsZan9NQbRysM78XIgyZ84
	 e5yPLdyy637cXc+Mr5qBMbWeI7ej8RLjCrgxmj+gBPzqUYXbOsxxuP6G4+1E+0kLRL
	 BhY7ONBhjfKR4ToJaJry0S1Cqv7pgxPnm4OKLVV08uqE+s7MGtqBAlslBxHtF87olo
	 pWQf/CpL1FSAIvTevEzRs5ISS/llcboVq/tUhX8gCUct1ufogWrklFDkSUVNmEbcvT
	 4WXIf0Lz2iuEeptqfA1DnFwBVk7cjCrAkrKZqlMhtUF1t+yjpP1VyfjyN040l0Ni8k
	 qglLM3+jGzn1Q==
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45a15fd04d9so10345255e9.1;
        Wed, 20 Aug 2025 18:26:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVODySg9xth1kjFOhw1JxAsMX+n0ViKpx3FkqpirbvG26IgaXXO/9JmkdwEi2tABeNsI2OlKOkxLZ09NUtY@vger.kernel.org, AJvYcCVlUHTi49vKNNBDTErKhJGejeWsAToCW3gcsw6Xam4+8zwNxvnj8z21sZ4g9NMQbd8+YXA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVFwm+L56ysP3l+qx7bAvhti4ZTePrr7wRDmgVLpGaPYK/95Sh
	tswcfMELzcylRIZbbD0X+b/ZbZOD8E2y9hJWbx5m6/efKqdLz6QVJkAUlI5D4we9FcmHBIz+hX9
	/E+8xiO2MBdlQaYp21Z+UfzqAcKKAIgs=
X-Google-Smtp-Source: AGHT+IGGICOecBkmHwgRKDE56lZRP6wcugcHJo0gEL4zRiu7fL+DOBskg/CVonknskbdGs/GTh/1B8yqRjR156fE548=
X-Received: by 2002:a05:6000:24c3:b0:3b7:590d:ac7d with SMTP id
 ffacd0b85a97d-3c4b4256002mr256638f8f.1.1755739570486; Wed, 20 Aug 2025
 18:26:10 -0700 (PDT)
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
Date: Thu, 21 Aug 2025 09:25:58 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRR0LTO-CbUMkyXisov3BeftN+UJzv99GX7KfqCxWxmUg@mail.gmail.com>
X-Gm-Features: Ac12FXxvAMsRQPy1tVyPjpoJutYOXESvM1svIIzMRusXPOnriqM8rsnzuEUEwNg
Message-ID: <CAJF2gTRR0LTO-CbUMkyXisov3BeftN+UJzv99GX7KfqCxWxmUg@mail.gmail.com>
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
> If so, it might be better to drop it and just keep the one here.
Sorry, I misunderstood here.

1. kvm_riscv_gstage_vmid_detect() & gstage_mode_detect() are indepent
function, so keep csr_write(CSR_HGATP, 0) is considerable.

2. But your idea is good, because csr_write(CSR_HGATP, 0) would cause
TLB flush in some micro-arch, which reduces the IPC. So, removing
unnecessary CSR_write (CSR_HGATP, 0) is also considerable.

I would update V4 to merge kvm_riscv_gstage_vmid_detect() &
gstage_mode_detect() into a single function, inspired by your idea.

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

