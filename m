Return-Path: <kvm+bounces-60957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D48BDC0449D
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 05:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7D7C3B7624
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 03:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C80A27990C;
	Fri, 24 Oct 2025 03:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="b3TNWqIh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170B5273D7B
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 03:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761277951; cv=none; b=Dvr5Mljj3PYllxVQrKzePsFsuKcM0bN/KpTbpsgUsxxLloCBLn6rLB2gcF1280Xi5wiF/GYENAuKEurkoU98sVGFSCfh08EpV3mlRpR4BQ9g00qJpzvf7308qYT4OgnV9b49CpLrUVCaA6BxU1JJj21GWFxqtmNuV+j4PjBPdsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761277951; c=relaxed/simple;
	bh=PhHGkGEe4X+Wu8hlj2fK1WdZOEnN/POUrnBbn7gxhNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LWL9XhuklVi3HsVWkq1n4lszGVwxM8OeK6gZaPTNHwGG2BTL9kawwVV4k7Wo1IyVEzSkMoeogJ43nF60H70uJ3/7nkf02ITMKOzk8z6kp1ehizVCBwYdmo0D8NDVqkvY03nb+2/VM59InVnQNIL+UvkquKC5dG0WdWEdOC74nHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=b3TNWqIh; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-591ea9ccfc2so2035770e87.1
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 20:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1761277944; x=1761882744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8/9xfrwSY9dn/jrCOm3aVeNQtdTtccDMKuiFbDhKLw=;
        b=b3TNWqIhxhTggdNQRAppc98CHUX/22qT5LF9wpnnZT9NlDfgYDQ8MwjavCM+3xksJO
         6yCuIPPqF8iCMTp4pO/kr6WVnDnQ2nxFOWGQfnAyLQQB+JnefOouuzMbyJnrl236y/zR
         aZ7L+n/SXyd67txxuKB1jlzHx53RWZt4qQTFPWBZo0ypAWA2j2A5Wn7UcGYl+/pHekUi
         MT7Zhj/w2r/ajzdwcrvy1GRVLU3bU7Wn6n89GKiavR/PcF6v7a/8SemoAQB9cQ8jO3ZH
         0hpemZz85JvWLeUOBlDWAyCy/3bHh4sLCm6sWfhAG0aWd5PifYLB9fhfBPRx5dbDG5D2
         kBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761277944; x=1761882744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A8/9xfrwSY9dn/jrCOm3aVeNQtdTtccDMKuiFbDhKLw=;
        b=nLHSp+YUU17Sxou/4k7ID7olX4jgjMDX7pMqzIEqDxT8OxHKwIghqTTdaURDsKJ170
         PlgX0GxkGkgnMMmkM9t2W5/s6fp5pVfWDFXwSQrGmnIJJtBUPF1MY7zYgjnaQbpmiIKZ
         2PkIpaaT/Xy5GkGqmev63JTHKAOmSqJXSl00f1LHOSR87GWdfuIObyNmDGfC80yyI02G
         TuO1atQ8MuG6Pl8buMHj0s7iXWNRybKB+dKijzK4k356hy9a85tsbIq6z6eNuq7K2w+c
         zpbTCuf4zaxBIsV3iDJHitJfWJBl2Ce4dytOPArQdp8557lHo5DhTM865d+sumzjWWzT
         hqrg==
X-Forwarded-Encrypted: i=1; AJvYcCVIO+/Rfg6ahz5ygsT20UlEKc5ito6lIz9dcyY4w45hx5hZuZXa0qjjMYI012RYg5AQ10k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrsBojzRR/RWM6l+DMAx+j5yyJI1FyJwRk2S1JZS2/NOERSgzq
	kRqsq2RbT/zs6uiMgg7IRo3lqoZAxAWKvepVjzZqpkVxg/VjyQg2gOCIlH7w5WyElLsEaxVrER0
	LUD3YoKZqSPHE2jfbnYnQH7o1eR+2kwTbC+Xfz/JHdQ==
X-Gm-Gg: ASbGncsF5r1Dat9sk/tyyX4NjFFTWJOiJWQCcrfhIkd1Umh1CJXTJC5tP5XRniQs+Wd
	nNlkgtVXg+dI2W8gA5D/UToUs9n5QNzn1GUZCn9vnUmC8GTzdweyc/Nu/qzbSBr0QM0sLc8un8P
	wEfvL6parbRxrMwDIXko5VAphoT8oTb4XN0z427y/OchtpvPhrNYA6r2OJ1NQJysj36nuA6Zz9u
	JQCq/llqLMq59BR6yjMJlmnNfI4jSDafLLAuCcu4SaVok1+hHUfHKKf6TdGZ8SAKd1tXuYv
X-Google-Smtp-Source: AGHT+IGb8L9/8BFJcEWEY2fXEF0PpwWiveByTWgaE2reqnXO8Ueo0FIjsxeuMtM0ZpRN/r3UT6XdkbR16N4L1XohwP8=
X-Received: by 2002:a05:6512:3e06:b0:58b:75:8fc6 with SMTP id
 2adb3069b0e04-592fc12a69emr299952e87.19.1761277944103; Thu, 23 Oct 2025
 20:52:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251021083105.4029305-1-minachou@andestech.com>
In-Reply-To: <20251021083105.4029305-1-minachou@andestech.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Fri, 24 Oct 2025 09:22:12 +0530
X-Gm-Features: AS18NWBEuD60NgNp1jRJyfwYOeWuqAqMI2kePlnJ_4peqxX3K4YiUIFQFddLt-A
Message-ID: <CAK9=C2XjygELuUnQErbpVzh6-4wc4HHypf91aKUtUzMYGJwmtw@mail.gmail.com>
Subject: Re: [PATCH v2] RISC-V: KVM: flush VS-stage TLB after VCPU migration
 to prevent stale entries
To: Hui Min Mina Chou <minachou@andestech.com>
Cc: anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, tim609@andestech.com, ben717@andestech.com, 
	az70021@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025 at 2:02=E2=80=AFPM Hui Min Mina Chou
<minachou@andestech.com> wrote:
>
> From: Hui Min Mina Chou <minachou@andestech.com>
>
> If multiple VCPUs of the same Guest/VM run on the same Host CPU,
> hfence.vvma only flushes that Host CPU=E2=80=99s VS-stage TLB. Other Host=
 CPUs
> may retain stale VS-stage entries. When a VCPU later migrates to a
> different Host CPU, it can hit these stale GVA to GPA mappings, causing
> unexpected faults in the Guest.
>
> To fix this, kvm_riscv_gstage_vmid_sanitize() is extended to flush both
> G-stage and VS-stage TLBs whenever a VCPU migrates to a different Host CP=
U.
> This ensures that no stale VS-stage mappings remain after VCPU migration.
>
> Fixes: 92e450507d56 ("RISC-V: KVM: Cleanup stale TLB entries when host CP=
U changes")
> Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
> Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>

Here's what the non-normative text says about HFENCE.GVMA ...

"Conceptually, an implementation might contain two address-translation
caches: one that
maps guest virtual addresses to guest physical addresses, and another
that maps guest
physical addresses to supervisor physical addresses. HFENCE.GVMA need
not flush the
former cache, but it must flush entries from the latter cache that
match the HFENCE.GVMA=E2=80=99s
address and VMID arguments."
"More commonly, implementations contain address-translation caches
that map guest virtual
addresses directly to supervisor physical addresses, removing a level
of indirection. For such
implementations, any entry whose guest virtual address maps to a guest
physical address that
matches the HFENCE.GVMA=E2=80=99s address and VMID arguments must be flushe=
d.
Selectively
flushing entries in this fashion requires tagging them with the guest
physical address, which is
costly, and so a common technique is to flush all entries that match
the HFENCE.GVMA=E2=80=99s
VMID argument, regardless of the address argument."

This means ...

For implementations (most common) which have TLBs caching
guest virtual address to supervisor physical address, the
kvm_riscv_local_hfence_gvma_vmid_all() is sufficient upon
VCPU migrating to a different host CPU.

For implementations (relatively uncommon) which have TLBs
caching guest virtual address to guest physical address, the
HFENCE.GVMA will not touch guest virtual address to guest
physical address mapping and KVM must explicitly sanitize
VS-stage mappings using HFENCE.VVMA (like this patch)
when migrating VCPU to a different host CPU.

We should not penalize all implementations by explicitly calling
kvm_riscv_local_hfence_vvma_all()  rather this should be only
done on implementations where it is required using a static jump.
One possible way of detecting whether the underlying implementation
needs explicit HFENCE.VVMA upon VCPU is to use marchid,
mimpid, and mvendorid. Another way is to use implementation
specific CPU compatible strings.

Regards,
Anup



> ---
> Changes in v2:
> - Updated Fixes commit to 92e450507d56
> - Renamed function to kvm_riscv_local_tlb_sanitize
>
>  arch/riscv/kvm/vmid.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> index 3b426c800480..6323f5383d36 100644
> --- a/arch/riscv/kvm/vmid.c
> +++ b/arch/riscv/kvm/vmid.c
> @@ -125,7 +125,7 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vc=
pu)
>                 kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
>  }
>
> -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
> +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
>  {
>         unsigned long vmid;
>
> @@ -146,4 +146,10 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu =
*vcpu)
>
>         vmid =3D READ_ONCE(vcpu->kvm->arch.vmid.vmid);
>         kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> +
> +       /*
> +        * Flush VS-stage TLBs entry after VCPU migration to avoid using
> +        * stale entries.
> +        */
> +       kvm_riscv_local_hfence_vvma_all(vmid);
>  }
> --
> 2.34.1
>
>

