Return-Path: <kvm+bounces-54872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99304B29B1E
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 09:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CC7C18A5B38
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 07:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F6D928640D;
	Mon, 18 Aug 2025 07:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ffsh8y/O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4B53FE7;
	Mon, 18 Aug 2025 07:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755503149; cv=none; b=iwpMyw61pp33LiKfNUzeF+RBb8xq/KNnUQZPhUG3/y4F6K1z1XUGK33zGFpGrtaTEqvw3pwdud1pZI/AMXT//5YaXA9WNeI76XQmQA6/FZBfyYlb/2Z4xaljcGNBHBPobMuNZtihH1Y2P7gIyuEaAnm4T0I4Qnr4Iom0N9KWRZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755503149; c=relaxed/simple;
	bh=f5gFJWZNQokzZOq71ViHREuQpbfVbZrgOrUABXKAViM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FO7bZDd1pAAL2kV+UEPfigz5UYmh6Wn9n+551uUVZrR06Ww3zqAspbQMcs2o0mMfRaWL2VOhJPK+NMVmEYz39jqXRqVkwJSwPCtck9+06UKBw27K3Rb/de/F+E/rrddpJpGw2hEcPSblD2vHS3UjX3PzCkbg3dnYaEPqzZNSh+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ffsh8y/O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA29BC116D0;
	Mon, 18 Aug 2025 07:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755503148;
	bh=f5gFJWZNQokzZOq71ViHREuQpbfVbZrgOrUABXKAViM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ffsh8y/O2JaZVNiMDIHY6BS5ex3bNjgqkeVeRgHjjgOrXt/CKunYwGK+7E+KZr+Wj
	 A/7JOszRNc/HY8nA69woYUxdbkEtCzGDoZpAxbNELAgAKWEK7+8o05C0dTIgSdZDR2
	 hSWufsu7FkJwAgMl4nobHGwul506MVUmFvN83RsimrHJDPG2O27L2zq4R6H5OTr0QB
	 0NIDBNW9ZGZFNRwAQRpHGhnLrENgoVosGVy6uiZxMOx/zQKaAJFcv9mGzQVkfdkNQw
	 BZyDxO1LMmyDWyq9e241PkiTNzMu/WbkvL60XM4i/GsftrbiI/fNaYYmeem9e4k7PU
	 AVPqZ1djdeiEw==
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b9dc5c8ee7so2434097f8f.1;
        Mon, 18 Aug 2025 00:45:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW0tnKPk9PLLxh0NNXqOfRQnZDA8g6+OpCpPcF0WTI3RFxOqKXqRcV+Ef4PLqkgmD5tnGQ=@vger.kernel.org, AJvYcCXOduHL0/uFMhtV+nrl7oBtKvjicKO1UJU9FVNMThFq242NFgb8/2iJ+MsGTonZkpj/0nKHlIwnJzODlGSF@vger.kernel.org
X-Gm-Message-State: AOJu0YwvpMI5KA6VpotIy610aQMz+tu+mKS8E0CxZAM+TMRQnID7AEkc
	AazYFRlK8RN9oSXsOk1ESMZLyu+tNB1BbI3VwdvIf0fUCT+rIb9qvFEADBhekZjqGn0YvoRRHDE
	F8PAEIMW98UVwx5z9Ecz7ofbw6IIKVFs=
X-Google-Smtp-Source: AGHT+IGB7LkhStNqvvKRj/omAM1mb4ypfuPD4iQ0j12D2cQIIBZbw8yOGFfbBk4SzXwHAZG+XPtcy3nV7EaiWd9UgmY=
X-Received: by 2002:a5d:5887:0:b0:3b9:15eb:6464 with SMTP id
 ffacd0b85a97d-3bb66f11537mr8108831f8f.15.1755503147364; Mon, 18 Aug 2025
 00:45:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250818054207.21532-1-fangyu.yu@linux.alibaba.com> <CAJF2gTTqPMVTNdHL7PUwobXQr3dwzKPi13ZDpmkVz+3VXHLZVw@mail.gmail.com>
In-Reply-To: <CAJF2gTTqPMVTNdHL7PUwobXQr3dwzKPi13ZDpmkVz+3VXHLZVw@mail.gmail.com>
From: Guo Ren <guoren@kernel.org>
Date: Mon, 18 Aug 2025 15:45:34 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQFWJzHhRoQ-oASO9nn1kC0dv+NuK-DD=JgfeHE90RWqw@mail.gmail.com>
X-Gm-Features: Ac12FXzzM0il7f9K7PUzED9HklQztO75B3sc-fXWfkPu4ViWfodFZHTR1W6vw-E
Message-ID: <CAJF2gTQFWJzHhRoQ-oASO9nn1kC0dv+NuK-DD=JgfeHE90RWqw@mail.gmail.com>
Subject: Re: [PATCH V2] RISC-V: KVM: Write hgatp register with valid mode bits
To: fangyu.yu@linux.alibaba.com
Cc: anup@brainfault.org, atish.patra@linux.dev, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	guoren@linux.alibaba.com, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 2:17=E2=80=AFPM Guo Ren <guoren@kernel.org> wrote:
>
> On Mon, Aug 18, 2025 at 1:42=E2=80=AFPM <fangyu.yu@linux.alibaba.com> wro=
te:
> >
> > From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >
> > According to the RISC-V Privileged Architecture Spec, when MODE=3DBare
> > is selected,software must write zero to the remaining fields of hgatp.
> >
> > We have detected the valid mode supported by the HW before, So using a
> > valid mode to detect how many vmid bits are supported.
> Good catch! It's a bug. The code seems copied from asids_init(), whose
> old value is not bare mode. For real hardware, it would cause
> problems, but the qemu buggy code hides the problem.
>
> It needs a tag: Fixes: fd7bb4a251df ("RISC-V: KVM: Implement VMID allocat=
or")
>
> Others, Reviewed-by: Guo Ren <guoren@kerenl.org>

Sorry for the typo:
Reviewed-by: Guo Ren <guoren@kernel.org>
                                                             ^^
>
> >
> > Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >
> > ---
> > Changes in v2:
> > - Fixed build error since kvm_riscv_gstage_mode() has been modified.
> > ---
> >  arch/riscv/kvm/vmid.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> > index 3b426c800480..5f33625f4070 100644
> > --- a/arch/riscv/kvm/vmid.c
> > +++ b/arch/riscv/kvm/vmid.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/smp.h>
> >  #include <linux/kvm_host.h>
> >  #include <asm/csr.h>
> > +#include <asm/kvm_mmu.h>
> >  #include <asm/kvm_tlb.h>
> >  #include <asm/kvm_vmid.h>
> >
> > @@ -28,7 +29,7 @@ void __init kvm_riscv_gstage_vmid_detect(void)
> >
> >         /* Figure-out number of VMID bits in HW */
> >         old =3D csr_read(CSR_HGATP);
> > -       csr_write(CSR_HGATP, old | HGATP_VMID);
> > +       csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT=
) | HGATP_VMID);
> >         vmid_bits =3D csr_read(CSR_HGATP);
> >         vmid_bits =3D (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
> >         vmid_bits =3D fls_long(vmid_bits);
> > --
> > 2.49.0
> >
>
>
> --
> Best Regards
>  Guo Ren



--=20
Best Regards
 Guo Ren

