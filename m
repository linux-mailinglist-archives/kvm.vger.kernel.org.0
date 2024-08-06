Return-Path: <kvm+bounces-23391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5857949420
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:04:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9187E281FF5
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 15:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABCE4205E18;
	Tue,  6 Aug 2024 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="mMWwz2HZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A971D54FB
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722956661; cv=none; b=sEWdyu9wP45TqZBmnI9MLmYifvo/fB0HqSGA5i7Ofwj6VS6uX4NGh+gdL27SqNr4KaZOk6JX49hHvo6zi86ruJI2f/y92m7pWgpAwaLY9w6orzysCld5fa/6SEJ1ydqCflfMh1ot0cB804quHP/U2AeQCZ8sInvrkRnquDUeVz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722956661; c=relaxed/simple;
	bh=weU0/ygthEVhph5l+8/dKvcNrdBMCRxTJh5fbqP3ZFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NHvdJSKX3BkWdTdE7Azokwc62pBAofLfWCgcrOnQ/sK98KnKlq2TuuNjjB+hD58ROCtjoDHJblf6SA3OW3gReoRRf0wX0LID786OHc/6qeqAwiaCF/k6755BnIq7rfM+jFrmam4agrH4Eh2zt5Dq3Ke7RWx5AMaYY9ZQNfVo9Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=mMWwz2HZ; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-396e2d21812so3158475ab.2
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 08:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1722956660; x=1723561460; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLks5Q0iPBrgmJrvgcvS8LOwX/9jLhdRfGiAtwiNPmc=;
        b=mMWwz2HZoV+88ZnGUtD/Ac1qa4ACQkojhOPJpIT+8v4Xdq6SN2eF0y8UuQ8TBO4IC8
         p9ZwaKi2jeEPRRZHun3m2xIy6zxOxZUw+Uc/lPYBpD4L+w4kanAk/+30UtI6pYNlBq7O
         NgqymUSXc5zoBJCMU7q9ibmt1P4wTg4N2GFl4HR9e0+UMz8QU/4bh9yo1VExAiJfuMmZ
         wsk2UCeU+YNZfnhGcT/wf5WDM3NUxaln8U1HjdxoQEidk7VD5srJ152O9qGI3fPXR4hT
         R8EzEjT9ZH4DPiruTdtAMlwVuy0djg5obwRihK260KeLBPrfvdGaI95TLwjD0ppB4oi5
         nzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722956660; x=1723561460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sLks5Q0iPBrgmJrvgcvS8LOwX/9jLhdRfGiAtwiNPmc=;
        b=jNO1t+Jo8CVS1wy8/sTaHyTxHDsi7vNOHmyKJmAPgsZBIGNIzcAg7z8Afrm1MLYOct
         CM+/+gIneoslopUO2gzfBq6IK3t/XKHMMuMOd+t6cG1fXiHYM3c4y94UuA6I4w3XGDl2
         NWBEFCSXxpW9qmVx+KkxACh904wZeG6Hplvt5zcYYTiPRZYpr+BLFlXz1Kr5PzoKS7ZV
         ezzLxzn3GGnV79oFG1SH09UXIsGDnfARrVqXyvaET4sawZ8slWpyyjQlYyt0qzvJG81o
         yiHyXO0OnQqydAotZegyD7HIWybAOV6zaTLBqD+mXn5wRhA27r/TvoFF1F0pTE+G/mGy
         I+sw==
X-Forwarded-Encrypted: i=1; AJvYcCXbRI0wMm6wHDbDZMrghFatOCG2O1prO7BhAMeX1SsJ1RWp2r6Flg6sBZTkEzfHSi5oxiDGp3RKT1akewKDnYQWh3Ye
X-Gm-Message-State: AOJu0Yw6l7i79pX/zHVGCEXNbNJiGUoSHIW9wJ8j3/flMbceF+uM1She
	BEK8CZvFdbRR4FGlSiXlWpjyuNVRcEmI0xk/RrWB38xz4OrLvXBMJvkvUojy4ujWavYPDLMahZz
	728C/PcpyC4FFizH5tZMZP777O4NvKsuG2oVzKw==
X-Google-Smtp-Source: AGHT+IGyDNkeg1CkpECSQ0akll4U0MAQSWPOL8L25sxstJveeDCZd19K8yTTFoue56gvit0ch8aH+2CGmbmtibK8NQ8=
X-Received: by 2002:a92:c0d1:0:b0:374:9c67:1df6 with SMTP id
 e9e14a558f8ab-39b1fc23546mr155430195ab.22.1722956659564; Tue, 06 Aug 2024
 08:04:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-58-seanjc@google.com>
In-Reply-To: <20240726235234.228822-58-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 6 Aug 2024 20:34:08 +0530
Message-ID: <CAAhSdy2rvPCuN7ROU4k9pAuyCZUnyDf2DhHjfSa_pA5SG6Q5DA@mail.gmail.com>
Subject: Re: [PATCH v12 57/84] KVM: RISC-V: Mark "struct page" pfns accessed
 before dropping mmu_lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 27, 2024 at 5:24=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Mark pages accessed before dropping mmu_lock when faulting in guest memor=
y
> so that RISC-V can convert to kvm_release_faultin_page() without tripping
> its lockdep assertion on mmu_lock being held.  Marking pages accessed
> outside of mmu_lock is ok (not great, but safe), but marking pages _dirty=
_
> outside of mmu_lock can make filesystems unhappy.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup


> ---
>  arch/riscv/kvm/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 06aa5a0d056d..806f68e70642 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -683,10 +683,10 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  out_unlock:
>         if ((!ret || ret =3D=3D -EEXIST) && writable)
>                 kvm_set_pfn_dirty(hfn);
> +       else
> +               kvm_release_pfn_clean(hfn);
>
>         spin_unlock(&kvm->mmu_lock);
> -       kvm_set_pfn_accessed(hfn);
> -       kvm_release_pfn_clean(hfn);
>         return ret;
>  }
>
> --
> 2.46.0.rc1.232.g9752f9e123-goog
>

