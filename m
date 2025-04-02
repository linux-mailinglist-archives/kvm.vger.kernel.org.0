Return-Path: <kvm+bounces-42516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF7F6A797AA
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 23:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A606916F478
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 21:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7ED1F428F;
	Wed,  2 Apr 2025 21:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lBixc8EO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128C1288DA
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 21:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743629183; cv=none; b=nPWYrG5+iFrTlFhnpH6wo/a+EfvQIcnRX+A/g/P+oJvIGgBxZsRs2Q62f7w94T1XBQBRg7MR2ZMhzLWc4aOCzElLIQb1Mi2c/EgKKFi6TY/cg1ItantVo3s8LZTGc088W1Gwdq3zeGlk7+a/zZUzFLXAQ5Ilr0gLAq3SSLlALzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743629183; c=relaxed/simple;
	bh=WrSAroPteEkIfTPk5VG63Y9jqJZdMnOd06w/KS/3d54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sIVlqBbA5PuevivnIgtPxtIwGwSldJDrUT4lvyzFKbR9NRKOPgedLI+m0MU/OSmbHuIODQmTwzEq16WUhjDbLYpzcyRyWWzdqpOnnT2nAgbXKzb2QRfNhgOtUnlXId7PqP4C8wPC1TJrQmF/578tzeESYVKAvfjGxbPjaRgoBsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lBixc8EO; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6f74b78df93so4029747b3.0
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 14:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743629181; x=1744233981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jkq7RDB6qUQkjmvNPDbUzRwwtYEXsO/0AHJxtOGmBfQ=;
        b=lBixc8EOGwUTg4GDYqiHmVzQuXDlNaL2SywjcPQ8PVeIRUjyhhVcsIJJTlCTprQ0x0
         6P/Vt780rkXLxz97gNQnIdxuYHtPQTHV7op4zV8snJM2x1J4D2K3lutYQFsXly9xDVTY
         OIwvr6+i1EPES1C+xokEVx3o4oEfR/DsXZNEDp27vz7Z/Bsxl9PCWLiJFsRILsAdxRCP
         Uz7zOhjLq0E4Nf5Hm1XVdkxYFtMn57HVQY6mXDD/1R5w3Q/jLQLLRjRDYWEJFZdgsSXM
         ot+Dd5OC8f+uwlArRxr3t5BexD1F4RJosqKlZgrV5cZ+unuCcQYgvjBWz5RlpgnB9Su3
         yx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743629181; x=1744233981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jkq7RDB6qUQkjmvNPDbUzRwwtYEXsO/0AHJxtOGmBfQ=;
        b=EfZ6RCMFH5PQCN9deUGCes1SjkGB4JZvlermz/yT966QQyXwzIpBPzBE6dGfcPTj+M
         ul7jU6ZKq9vLlxSAxDN/QDTO23QYd3cEAVABVJSG0hnzLU0URAQ8Yt5pW8QSUUaIXdEF
         FY6d1zelQJ2O6BIsjsjERJtby3sq+1qJG7OSk7k/dG40tjrPdDvTTd3/AqtTWnkIRlk9
         Mx9gFxi1OS490Ycmvp38ycpCXn+/i1wx8zd2ctU2TDercu/hZZBcjuY9Kt/hP1rRmCeS
         0/TCu7wYifjVAIvDv3uAFWIeaYEUobGwNy5lV0yHkqbd9Gd27ETIvkd68Bnfj/MkzVf+
         WKdw==
X-Forwarded-Encrypted: i=1; AJvYcCVqfnSxp4FeEmqd5wwvYVHiC5wrxs7n8cqHt1whO+Gss31GQBJcbfVWlSrUpWDoHyh6sps=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6zilmwkQ20A16UEu1mG3D0RnsRPIToh2KfPp1XXTe6q4DxPqF
	tmdcQGsFH/8NZqRzw71hfe5bQwAy59xcA1A/X8dgXrQbo08Lii8RqQhGFNnoAk4nNYBg6pvTr1Y
	QuAw1eFHEIfzrE16KT5b83j5N2620zJi9M8sU
X-Gm-Gg: ASbGnctEeszyd4UwTt2SxuHAvCw1kBsGRQ3cwYQjEgsfziG9bEmUewOwk9rI4BdullJ
	zKMSG2N/mEBTyOlacuYIVMDxzernSv24NvZlz7TOy2gSfQKfYMOTO/gXUQRJNmklgbQ/Pe4Qz82
	mj4lIOAZivv7geHpCxPdlhfRffAYVp0+S9MJ8w/b9811L9we6VqFqH4WM=
X-Google-Smtp-Source: AGHT+IHC9iQyimPIf9LK2ZxOiOmyeaERAe030mPiaTlyv077TSi4Ij2X2Zh68MYzFPFo7mJNC8RXC973zmIYLF4HpwM=
X-Received: by 2002:a05:690c:f0a:b0:702:d54:5794 with SMTP id
 00721157ae682-702573625aemr252565667b3.31.1743629180815; Wed, 02 Apr 2025
 14:26:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402160721.97596-1-kalyazin@amazon.com> <20250402160721.97596-4-kalyazin@amazon.com>
In-Reply-To: <20250402160721.97596-4-kalyazin@amazon.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 2 Apr 2025 14:25:45 -0700
X-Gm-Features: AQ5f1JpgHKJ4oBuxUfdSQZzG2qvYTZmYOUmQV1t1d9CLWvy8fODsNbzGuiQPDsA
Message-ID: <CADrL8HVADXDKUu4mn-dHb9ih=ZnuMWtKfqL2xFxKf2yff7RJvQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm: userfaultfd: allow to register continue for guest_memfd
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: akpm@linux-foundation.org, pbonzini@redhat.com, shuah@kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, ryan.roberts@arm.com, quic_eberman@quicinc.com, 
	peterx@redhat.com, graf@amazon.de, jgowans@amazon.com, roypat@amazon.co.uk, 
	derekmn@amazon.com, nsaenz@amazon.es, xmarcalx@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 9:08=E2=80=AFAM Nikita Kalyazin <kalyazin@amazon.com=
> wrote:
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  include/linux/userfaultfd_k.h | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.=
h
> index 75342022d144..bc184edfbb85 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -212,6 +212,10 @@ static inline bool userfaultfd_armed(struct vm_area_=
struct *vma)
>         return vma->vm_flags & __VM_UFFD_FLAGS;
>  }
>
> +#ifdef CONFIG_KVM_PRIVATE_MEM
> +bool kvm_gmem_vma_is_gmem(struct vm_area_struct *vma);
> +#endif
> +
>  static inline bool vma_can_userfault(struct vm_area_struct *vma,
>                                      unsigned long vm_flags,
>                                      bool wp_async)
> @@ -222,7 +226,11 @@ static inline bool vma_can_userfault(struct vm_area_=
struct *vma,
>                 return false;
>
>         if ((vm_flags & VM_UFFD_MINOR) &&
> -           (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
> +           (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma))
> +#ifdef CONFIG_KVM_PRIVATE_MEM
> +            && !kvm_gmem_vma_is_gmem(vma)
> +#endif

Maybe a better way to do this is to add a vm_ops->can_userfault() or
something, so we could write something like this:

if (vma->vm_ops && !vma->vm_ops->can_userfault)
  return false;
if (vma->vm_ops && !vma->vm_ops->can_userfault(vm_flags))
  return false;

And shmem/hugetlbfs can advertise support for everything they already
support that way.

> +           )
>                 return false;
>
>         /*
> @@ -244,6 +252,9 @@ static inline bool vma_can_userfault(struct vm_area_s=
truct *vma,
>
>         /* By default, allow any of anon|shmem|hugetlb */
>         return vma_is_anonymous(vma) || is_vm_hugetlb_page(vma) ||
> +#ifdef CONFIG_KVM_PRIVATE_MEM
> +           kvm_gmem_vma_is_gmem(vma) ||
> +#endif
>             vma_is_shmem(vma);
>  }
>
> --
> 2.47.1
>

