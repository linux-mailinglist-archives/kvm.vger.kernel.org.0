Return-Path: <kvm+bounces-23026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC97945D0F
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 13:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C23182814E9
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 11:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE1B1DF692;
	Fri,  2 Aug 2024 11:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fwoudIRm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2991DAC6C
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 11:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722597376; cv=none; b=OSU5gp5QAXPk572gOpPZ4+KMFATapYl8neWZX04IK12N/c86uTeDH7Q9BBR3oQvFERSx/ex4x2fH1fHy5P7ykXgkh2zGPh+jHwxeYHXILabkJq6je1JtT0e/1BIlNqwJphwkzZGOaXRCNHRUE/8xybeEL6auWKNxbk2L6YraB74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722597376; c=relaxed/simple;
	bh=5/L0Yc2Z+AOSOKZw3/Dotf6pZ+cloK9IZVwKZGtH7AE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LH4gza743+B7wbmwWjXpAMEvah1ifrpjdAa6YoQ/8z2z51cX3zBe3iuxZC+orkdoyWSVKFPDvoV60/tRbyW6wlSdHOYy6f3opjhngjuyVPhOjOHAbopiqx9/z5YNGx/+U25Mq2Rov2g1t+fDrmuWrNImJb5rs5W3mVspj31Yy5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fwoudIRm; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5a79df5af51so5540978a12.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 04:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722597373; x=1723202173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h+a+YbUYnYp2O9o3vDX++ZHVr+zNy81A/L7Ak8HFY0M=;
        b=fwoudIRmwyCZlvfZAYP55lQcN+bde7o08iQUsXGJ/fUVJ1Tf4MSd9mmhuHU3dSCrX0
         W3Tau751iP6vRYFZW9yxiV609CXOQ6fzoqnmowcurzv2TWw5tHNLy2Z8r7bsYH/CJG93
         gi4+fx4KAfHEf4ahly+/x1/RHo+wyHG7H64Pv8TUj17ZApMqNMra+oGnF0xbwewFXfT2
         tPi1FLl4/+XJhnn81LdxSTjN/SsAK0UbQP5WpGHja82rTztj2E8wE7jAzP5h3xvb57vQ
         WDCK6fWMywgyF6T5pFcJycbxuICu9UO7uz+hhfBKlzsZTpJHt1WEfpJWzdUSmZdlD0Lv
         6szw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722597373; x=1723202173;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h+a+YbUYnYp2O9o3vDX++ZHVr+zNy81A/L7Ak8HFY0M=;
        b=mPmHWki4eIwm76tU6vfZc3bj5Pqjn+dRFSn4gGnP+/o0bc+m8ANkGGK2TP5o+YyhX+
         oDtvZpGWvJ011jzqBEF3k0CcoYFx8zzW/Mp3mKtzW2UelD+QNCyHCBNWODqqnx8MMYeS
         6jMiGzY6N3NX2hJVsGEalGNoYJyOrZOcedWRV0p4Xi2ur2p7Vyp2zgeiHzvF/KtNJtVN
         rT+wUmVOQ4QNgPY985DUu2i2J1zRA4HqiH9/B6DHD8dmXX9cnz3KSkSQlfv8hAhhvY3s
         xaIENl+YwAm0StrHIJ0CfCWNCgvP4X8F2mT0i6Lw21PhEUnenx/ZPAYZcVkXE+h8XUV3
         u9QQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKCH+b06rxHKmI3Jpzv5lTwTJkt3UmX0sM7YxJuemKvLAWESFSlzHwzeqcY8sjyq8aMqW9kUpKF1OtiF3lfVe9BOGP
X-Gm-Message-State: AOJu0YyeVLNQjhGj1noTZdBK+DC+DOWMnaU22ALoHj8f8VUDuVbvqYLD
	0aTqtep/Fq1EOL+LkcjYcQrf5oAnkE5NyNh1qHo/tC8e0vrdyd2JBLHletD2PEM=
X-Google-Smtp-Source: AGHT+IHUr2+eigMQMyKiFV2SC/+LcUpbtIeuSXGg+vhEQqD67tJuIK6amWVCFT4RRO+CzEGYIGxtXA==
X-Received: by 2002:a17:907:25c5:b0:a7a:acae:340b with SMTP id a640c23a62f3a-a7dc628bf8fmr256404766b.31.1722597372903;
        Fri, 02 Aug 2024 04:16:12 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9bcb19csm87224666b.42.2024.08.02.04.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 04:16:08 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 91DEE5F8A9;
	Fri,  2 Aug 2024 12:16:04 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>,
  Oliver Upton <oliver.upton@linux.dev>,  Tianrui Zhao
 <zhaotianrui@loongson.cn>,  Bibo Mao <maobibo@loongson.cn>,  Huacai Chen
 <chenhuacai@kernel.org>,  Michael Ellerman <mpe@ellerman.id.au>,  Anup
 Patel <anup@brainfault.org>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Janosch Frank
 <frankja@linux.ibm.com>,  Claudio Imbrenda <imbrenda@linux.ibm.com>,
  kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  loongarch@lists.linux.dev,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  David Matlack <dmatlack@google.com>,
  David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 11/84] KVM: Rename gfn_to_page_many_atomic() to
 kvm_prefetch_pages()
In-Reply-To: <20240726235234.228822-12-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:51:20 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-12-seanjc@google.com>
Date: Fri, 02 Aug 2024 12:16:04 +0100
Message-ID: <87frrncgzv.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Rename gfn_to_page_many_atomic() to kvm_prefetch_pages() to try and
> communicate its true purpose, as the "atomic" aspect is essentially a
> side effect of the fact that x86 uses the API while holding mmu_lock.

It's never too late to start adding some kdoc annotations to a function
and renaming a kvm_host API call seems like a good time to do it.

> E.g. even if mmu_lock weren't held, KVM wouldn't want to fault-in pages,
> as the goal is to opportunistically grab surrounding pages that have
> already been accessed and/or dirtied by the host, and to do so quickly.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
<snip>

/**
 * kvm_prefetch_pages() - opportunistically grab previously accessed pages
 * @slot: which @kvm_memory_slot the pages are in
 * @gfn: guest frame
 * @pages: array to receives page pointers
 * @nr_pages: number of pages
 *
 * Returns the number of pages actually mapped.
 */

?

>=20=20
> -int gfn_to_page_many_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
> -			    struct page **pages, int nr_pages)
> +int kvm_prefetch_pages(struct kvm_memory_slot *slot, gfn_t gfn,
> +		       struct page **pages, int nr_pages)
>  {
>  	unsigned long addr;
>  	gfn_t entry =3D 0;
> @@ -3075,7 +3075,7 @@ int gfn_to_page_many_atomic(struct kvm_memory_slot =
*slot, gfn_t gfn,
>=20=20
>  	return get_user_pages_fast_only(addr, nr_pages, FOLL_WRITE, pages);
>  }
> -EXPORT_SYMBOL_GPL(gfn_to_page_many_atomic);
> +EXPORT_SYMBOL_GPL(kvm_prefetch_pages);
>=20=20
>  /*
>   * Do not use this helper unless you are absolutely certain the gfn _mus=
t_ be

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

