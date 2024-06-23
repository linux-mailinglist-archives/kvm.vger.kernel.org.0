Return-Path: <kvm+bounces-20330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A3019138D6
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 09:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEE80281F23
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 07:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E70A5EE97;
	Sun, 23 Jun 2024 07:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bc4qwU92"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FC61EB25;
	Sun, 23 Jun 2024 07:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719129354; cv=none; b=A1QCbxPtuXFpe3h4Eb3IrSGcSeiB/tAwlIamNSWlqvD0uDy77G/PJqoosNdtlVUcIgQXQyYwVo+11JEu7FM7RrhBZxhQmtwcNsMr4XEamZi6eIeWK5T6dsz1JiszGgOGpBb9SuAaiUbXMzNbxeePAFBJsP2A+t+XEMqgz3qPSPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719129354; c=relaxed/simple;
	bh=rgqojQtganfsNyFa5sKdGm6qZZFIx5JMG901agYQJ3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HHKz0YavlfqXqrmSFkryPU2UATmHBmS6bdoUGGBXmo6EUYrGtM0Yj4EincN0ZeQInVLLaZXQmtb4JAv6ChNxLULtTv9Cpe5PV0ShD5eAz7m79JtH/FcMj7KM+I2HV7ueXTdEJtd44uWh33lZsqGxeQPhKnJwct0yJKndRHRMxMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bc4qwU92; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502FBC32786;
	Sun, 23 Jun 2024 07:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719129354;
	bh=rgqojQtganfsNyFa5sKdGm6qZZFIx5JMG901agYQJ3Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Bc4qwU92Zb/N2WusRI/aj8UNKx2EGgS1JYl8M7ePpx4Hfl79eqAjK+NyeVW3pB5oN
	 jdC/ivW4vJeKaWF8sk0u2WSer+tkovp7OIZrTa+3GeekSMDS2XFW4oVXMZZhWYISs6
	 qUVGh6+ZV2j+S3zTJsFDd48mxfFWWmb2fgaWSF86B9LgiiebAxQMaqCyVXHjUxeLpc
	 X3MRvuPbdgO4u0jU35S9LKyQcsLR/lOso62/6Xm5Rt/6X51zNARNtanceCHDP/5Vcy
	 qoHfsElgjjkGwYb5GSLTJ2/UvLJLY2rlEJ92cZuLD9lXXukun5hf0pryNp37VIiY9q
	 iHST5xIDk1F5Q==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57d05e0017aso3961484a12.1;
        Sun, 23 Jun 2024 00:55:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWzX1E7Aa1qvAGTEspCzmR4oTqEK9ThUrYtJpCChHIKh2zdTu4g/dQWISXXhuT3eKzFcLioeThLnJLEv0iXV5IyBTYFf5UcbFTXNrmgtPIT4kpLP1g499JwBZn6pEa7XDvz
X-Gm-Message-State: AOJu0Yw8EDsLtugUMW1yNliCQXU/mGy3bgPTKNv93GaDs+9N4gbq5Q1p
	B2oEZdjQc5Uu+/5AQE7Gda0pxyeqpOfOvSTOmcxh1It3cKQOH6/xywiRCKposBzH1Ht4+KAy7rI
	0IzuGqv6R4zG8808gKg4XQRxeZY8=
X-Google-Smtp-Source: AGHT+IH+q68pgvGWid8lDdf6e6JaOfr/7TiTueM58nZbAb66L6ay5EsP+L8r6fjfH5a4bJV8RQ9epsJMUv2TD/h/QaQ=
X-Received: by 2002:a50:9f8d:0:b0:57d:1627:93ed with SMTP id
 4fb4d7f45d1cf-57d457a1540mr1638421a12.22.1719129352908; Sun, 23 Jun 2024
 00:55:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619080940.2690756-1-maobibo@loongson.cn> <20240619080940.2690756-3-maobibo@loongson.cn>
In-Reply-To: <20240619080940.2690756-3-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 23 Jun 2024 15:55:42 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7YXHwfdy-DFAd6_qPXdqbBVUSHq0U8Hu1eEgdtN_b+OA@mail.gmail.com>
Message-ID: <CAAhV-H7YXHwfdy-DFAd6_qPXdqbBVUSHq0U8Hu1eEgdtN_b+OA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] LoongArch: KVM: Select huge page only if secondary
 mmu supports it
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Bibo,

On Wed, Jun 19, 2024 at 4:09=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Currently page level selection about secondary mmu depends on memory
> slot and page level about host mmu. There will be problem if page level
> of secondary mmu is zero already. So page level selection should depend
> on the following three conditions.
>  1. Memslot is aligned for huge page and vm is not migrating.
>  2. Page level of host mmu is huge page also.
>  3. Page level of secondary mmu is suituable for huge page, it cannot
> be normal page since it is not supported to merge normal pages into
> huge page now.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  arch/loongarch/include/asm/kvm_mmu.h |  2 +-
>  arch/loongarch/kvm/mmu.c             | 16 +++++++++++++---
>  2 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/arch/loongarch/include/asm/kvm_mmu.h b/arch/loongarch/includ=
e/asm/kvm_mmu.h
> index 099bafc6f797..d06ae0e0dde5 100644
> --- a/arch/loongarch/include/asm/kvm_mmu.h
> +++ b/arch/loongarch/include/asm/kvm_mmu.h
> @@ -55,7 +55,7 @@ static inline void kvm_set_pte(kvm_pte_t *ptep, kvm_pte=
_t val)
>  static inline int kvm_pte_write(kvm_pte_t pte) { return pte & _PAGE_WRIT=
E; }
>  static inline int kvm_pte_dirty(kvm_pte_t pte) { return pte & _PAGE_DIRT=
Y; }
>  static inline int kvm_pte_young(kvm_pte_t pte) { return pte & _PAGE_ACCE=
SSED; }
> -static inline int kvm_pte_huge(kvm_pte_t pte) { return pte & _PAGE_HUGE;=
 }
> +static inline int kvm_pte_huge(kvm_pte_t pte)  { return !!(pte & _PAGE_H=
UGE); }
Why do we need this change?

Huacai

>
>  static inline kvm_pte_t kvm_pte_mkyoung(kvm_pte_t pte)
>  {
> diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
> index 9e39d28fec35..c6351d13ca1b 100644
> --- a/arch/loongarch/kvm/mmu.c
> +++ b/arch/loongarch/kvm/mmu.c
> @@ -858,10 +858,20 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsi=
gned long gpa, bool write)
>
>         /* Disable dirty logging on HugePages */
>         level =3D 0;
> -       if (!fault_supports_huge_mapping(memslot, hva, write)) {
> -               level =3D 0;
> -       } else {
> +       if (fault_supports_huge_mapping(memslot, hva, write)) {
> +               /* Check page level about host mmu*/
>                 level =3D host_pfn_mapping_level(kvm, gfn, memslot);
> +               if (level =3D=3D 1) {
> +                       /*
> +                        * Check page level about secondary mmu
> +                        * Disable hugepage if it is normal page on
> +                        * secondary mmu already
> +                        */
> +                       ptep =3D kvm_populate_gpa(kvm, NULL, gpa, 0);
> +                       if (ptep && !kvm_pte_huge(*ptep))
> +                               level =3D 0;
> +               }
> +
>                 if (level =3D=3D 1) {
>                         gfn =3D gfn & ~(PTRS_PER_PTE - 1);
>                         pfn =3D pfn & ~(PTRS_PER_PTE - 1);
> --
> 2.39.3
>

