Return-Path: <kvm+bounces-23390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E10594943F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC051B2B571
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 15:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF58720127D;
	Tue,  6 Aug 2024 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="d52Gp4QX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058971EA0B7
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722956654; cv=none; b=pZCP2fQjqbqyLGVU9mKkomam9rYuJznrjLuMy1TRZDzNXRiSYxXZI6mPLMuXf3hEWHUk+suFzYCJJ6PwtiapcTdLf0mj+lxgb+a6X5o43b2qRz4YlYgY8mXtgsBak6/Wx3IUxycyxYVc5zm8KQH6WzAC8uveG+9CPxpN+ZV89ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722956654; c=relaxed/simple;
	bh=Ojp+5mgXIeLmoaOntdYobjdPsSlf5Jv2i52l1FMoU8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PE9K+o7OpknP9CGK52/Kk+kpr7H9jSZ2zuXkYhW1nq2CnnNROXgi/PpYCQ6Mqj7kq4dCYt5wyPdzsAlFqCSgXf5WRSxZIMqabMqZz6xXw6+Kp2RukptxNMGM8Qlzenr4u0fpZOthRwwpSRKd6V6NvhE3m+vs90Cgg6ba5bde3Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=d52Gp4QX; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-39b3e12754eso2789955ab.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 08:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1722956651; x=1723561451; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nqpVJEa3gF+vLMgvdD8twTbWevyBd39Y3ES27W51MM=;
        b=d52Gp4QXL5N0z7YA2EbMkiYnHuAeE5d8Q02SLVXmq4IS5IBSYyJa3nAVrhpMDbjWxo
         V/9jVDDd3xhdG8LsCLLAirk39wLC9scuXwlr1CdL9e1h1pymuXg4oDWK0ZOV+DuHQV07
         t3Yug0INszErMVCyPOACtxZo59yAidEqBQOjorFizlXE76A1+gniwNpNH/ilWHdNvMlh
         e6RYjdiQgVvMT408J/D0c8GCbJD0ObhBknuCtzcWcLsWxFPme21PGj9SiIxItFhqMbw/
         nL+dBwH+irjs9/FeyRq6l8S57zaaDqPQFjg+dvpDkPfuRXOi1XlsAf0lRG/FMvsepiF2
         5U0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722956651; x=1723561451;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nqpVJEa3gF+vLMgvdD8twTbWevyBd39Y3ES27W51MM=;
        b=U+rjtAHKYLTHkhBtDsFRK1M1L+GCPq91JdiShFDX0YiOVLtb97WEkxmZr5+YFx6HKI
         C8Q0paSBHokpVCRcu7BS5ieeWmfN6vTA6TZPE6jceylXgroCFVs7agR7NqbexJh87SMd
         vh+9uvt4i8AdAoaQVJ36xFX6dEoPebC15VdC9tyR/fWhALy8chPfIQTLciGnpCKnxR1O
         CKMuHj4PON8uDBmxqKrCdCg9k8MO2CxYCgQYi0WuIXKotYPoNlQHDKzc9a9uQuuDdg4p
         gE1MUOvMnwZnZWAW/jIgWXnzfjhtXe2FKLzBNh1zB107voi0HBK+Qdh0TnlEaLnUl40l
         hxCw==
X-Forwarded-Encrypted: i=1; AJvYcCXZykCuKFO5Izd1o5KaGIGYjVmaz3D2wjniVVdst9/cxWCxM3zL5IvsKCXLZ7QpLhh83cdkUokkRJ6+/pCO7fhO1gP1
X-Gm-Message-State: AOJu0Yw/GQBgvrc82ztX03BzQjZKk5BSbYY1WYRWnPx17suSXpD9+x0Y
	d2yMlmoypZvobqJRVxqMv0qqsGmPLMwoKIiJakMDQRiQ380QwA8edpxsarrB5YOqIYSB74zuGP3
	nZ8hvpJHb5whUOTJlAiPA2wWO2uR2YTnXvPoDow==
X-Google-Smtp-Source: AGHT+IE5dkU8O3hsRzTzR3mqE211YMexCU92LD+ZH2mO65SVdE7w+UZ8Equ/sKTPvXFYaRtJg+9DX/UprpD7ulXsS18=
X-Received: by 2002:a92:d64d:0:b0:397:d9a9:8769 with SMTP id
 e9e14a558f8ab-39b1fc37fe5mr152610645ab.24.1722956650868; Tue, 06 Aug 2024
 08:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-57-seanjc@google.com>
In-Reply-To: <20240726235234.228822-57-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 6 Aug 2024 20:33:59 +0530
Message-ID: <CAAhSdy1DvkU_C2jmtA1SBNfjp1gxu_6RhFKbf-hkhSNQeTXwwA@mail.gmail.com>
Subject: Re: [PATCH v12 56/84] KVM: RISC-V: Mark "struct page" pfns dirty iff
 a stage-2 PTE is installed
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
> Don't mark pages dirty if KVM bails from the page fault handler without
> installing a stage-2 mapping, i.e. if the page is guaranteed to not be
> written by the guest.
>
> In addition to being a (very) minor fix, this paves the way for convertin=
g
> RISC-V to use kvm_release_faultin_page().
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup


> ---
>  arch/riscv/kvm/mmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index b63650f9b966..06aa5a0d056d 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -669,7 +669,6 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 goto out_unlock;
>
>         if (writable) {
> -               kvm_set_pfn_dirty(hfn);
>                 mark_page_dirty(kvm, gfn);
>                 ret =3D gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHI=
FT,
>                                       vma_pagesize, false, true);
> @@ -682,6 +681,9 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>                 kvm_err("Failed to map in G-stage\n");
>
>  out_unlock:
> +       if ((!ret || ret =3D=3D -EEXIST) && writable)
> +               kvm_set_pfn_dirty(hfn);
> +
>         spin_unlock(&kvm->mmu_lock);
>         kvm_set_pfn_accessed(hfn);
>         kvm_release_pfn_clean(hfn);
> --
> 2.46.0.rc1.232.g9752f9e123-goog
>

