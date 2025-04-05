Return-Path: <kvm+bounces-42775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 042BDA7C718
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 02:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8ED2178204
	for <lists+kvm@lfdr.de>; Sat,  5 Apr 2025 00:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DB58479;
	Sat,  5 Apr 2025 00:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b+znGhJP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951154A1C
	for <kvm@vger.kernel.org>; Sat,  5 Apr 2025 00:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743813149; cv=none; b=VYVgjod4zb8mFNUsILxIDmF4TERnIKBm609XJRtPR95SDv6us1vQRB5AQ8++CMsJKNblKYkQGQRlDCqVrfpwv4KDYzrn+loW+u2JyfYXMnjmnuKwl1aihsJYtydu1p6IEbApZew3FRIkJ36yLFKoPxGuIs9dtE4xEyyCA2NLSE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743813149; c=relaxed/simple;
	bh=Sp6+0cwU9/FKMgxRKFjmZLvuoauBZNCxKbw0Q3jR9Vo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fg6OjiOZEH1wFKfKYWRoj0dm9Da+82oVVqkEtWeAiDrhSZiGSlSqNxL8niLcAcwPF0H/52IMnN2f8yLoaU7XuE18JoT1x0zvrOo6joUmh5gkQ6TkKCA0mKDobEjmQwJBEaiOZzdYF4a0GPqJNFEfdwj8ZhWj9mgobo7AbGe3V2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b+znGhJP; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6e8fc176825so22220016d6.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 17:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743813146; x=1744417946; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pG5OgA5u3r7SWYVRvl04U+VJKzgkH/slr5SK5HxcIr8=;
        b=b+znGhJPKQWZQU3bK3r8zjz6I8H+nkZ02nMRgsehsyLEL8phWtYtUrPslpkmHwbmuL
         unBfINr0aeG+wrkDUs5ptoI7knNxT/IzW1p+g+w9b7jW1sxaXhkOdyZhmhk/lz3Kej9h
         srRp0Wvzmt4Kj+uKWD+yYZlcm3X0TDtF/HVT75IOMYpNkdJ5UXTpmt7vPJkDBxv+EST3
         q35aHD9CEstkH/1vtzGycDqMcOurW9TOQLrK6Z3/xCkaO8GyvsWTr6lON00kfbKi84Tr
         HEmkoIlU6oQprpJ3W5Ifz2faxJMOLDwpCg5Rq96llvqv3Wiphj8nKjtUOzn3CVGrHE/c
         YwXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743813146; x=1744417946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pG5OgA5u3r7SWYVRvl04U+VJKzgkH/slr5SK5HxcIr8=;
        b=LOfcsD0S55YeUJvBuyR1OwSrWixJwoi6TZ+iLP6tqnuRSCB8iQR+yVzWVBhlqLrrE8
         sLGrFVaE5d1fRs9bOU3xnfA6vNJloP8ucb2q2Yy71Zs9s10Gf0tflYJcRukDpWo9EU7a
         p8r6p8iDH/lxH5lcBLzDnPRwJ/Xuscrc7xliOx4eULNlhy2Aey1N41BUH1GzzSwAQJGi
         sHJT/Te6nhxr+KmP0p0USMMuTyDnjjwdYobK/7gLI4grQLTAzP5YMSzWpdwKVjiz9Vlo
         pBFBFIELrM5ZaFdxDQfz+1EMqLpNEktoHowru+7+PVx8RVp40lLaxQsq2Il/Jd1IJSqb
         FFZA==
X-Forwarded-Encrypted: i=1; AJvYcCUv6oyqLKzsNDC6YGSQ/diqC9kINdSdDm5Nl6+scX1t6nm1N4HxRm9qDOVArARWJfFfgLI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyow9vPlhOVVo8hM2Oi1gVLhLruNU21SMQvygyzB8hWgGN52zAG
	Roa42ZjoU3qFllpbTrZr/SZDr31JhNglxF/0Qw6T+sT5Q2hEjqKa+GblImHqtbefvAzBzhs6SQo
	PCkDUuB2aZ2dpa84J+jirkmiAHj7oxr2VCZKH
X-Gm-Gg: ASbGncu8Yzh7vPVD6S2bMjd27ewYulSxKVxIJTLt/q+DNncIen3UukdF1bvjMQ6uE0F
	g4V8A8k0qImHt2qyAtEXpx+c7nlgzqVtD2nOcMZ+BcCA3IDnfdsKmLggWL3VoivpnowfMJOgMc1
	xjGxwhhPOYnLRs1oIY6Kc4PM4RLeAi
X-Google-Smtp-Source: AGHT+IFdsVd/lCa/5EHlC59IfCvD5ejt4ymZP3PtjMovWWTZHQUVaynKa8ekIZOHGPXU7kyqQ3Dv7qIk0/P6Afy4pSo=
X-Received: by 2002:a05:6214:212e:b0:6e8:f4e2:26e1 with SMTP id
 6a1803df08f44-6f00deededemr91976776d6.20.1743813146236; Fri, 04 Apr 2025
 17:32:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250405001042.1470552-1-rananta@google.com> <20250405001042.1470552-3-rananta@google.com>
In-Reply-To: <20250405001042.1470552-3-rananta@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Fri, 4 Apr 2025 17:31:49 -0700
X-Gm-Features: ATxdqUEh8xXy0f-Tg56BnLvVp3zRksb0Z3WI3QPNIi_wEpzrRIgGyHaX6LOUeOs
Message-ID: <CAL715WKaAHSgUhtMMT3Ztw90mMoHpVLdKUgVM15xx6yoUws9+Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: selftests: arm64: Explicitly set the page
 attrs to Inner-Shareable
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

.

On Fri, Apr 4, 2025 at 5:10=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Atomic instructions such as 'ldset' over (global) variables in the guest
> is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
> DEFINED fault (Unsupported Exclusive or Atomic access)). The observation
> was particularly apparent on Neoverse-N3.
>
> According to ARM ARM DDI0487L.a B2.2.6 (Possible implementation
> restrictions on using atomic instructions), atomic instructions are
> architecturally guaranteed for Inner Shareable and Outer Shareable
> attributes. For Non-Shareable attribute, the atomic instructions are
> not atomic and issuing such an instruction can lead to the FSC
> mentioned in this case (among other things).
>
> Moreover, according to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte
> load/store), it is implementation defined that a data abort with the
> mentioned FSC is reported for the first stage of translation that
> provides an inappropriate memory type. It's likely that Neoverse-N3
> chose to implement these two and why we see an FSC of 0x35 in EL1 upon
> executing atomic instructions.

nit: It's likely that Neoverse-N3 chose to implement this option (the
first option) instead of reporting at the final enabled stage of
translation

I have minor question here: The DDI0487L C3.2.6 (Single-copy atomic
64-byte load/store) mentioned

"""
When the instructions access a memory type that is not one of the
following, a data abort for unsupported Exclusive or atomic access is
generated:

=E2=80=A2 Normal Inner Non-cacheable, Outer Non-cacheable.
"""

So, the above is the "Normal Inner Non-cacheable", but in our case we
have "Normal and non-shareable" in stage-1 mapping, right? I know it
is very close, but it seems the situation is still only "one bit" away
in my understanding...

>
> ARM64 KVM selftests sets no shareable attributes, which makes them
> Non-Shareable by default. Hence, explicitly set them as Inner-Shareable
> to fix this issue.
>
> Suggested-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/include/arm64/processor.h | 1 +
>  tools/testing/selftests/kvm/lib/arm64/processor.c     | 3 +++
>  2 files changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tool=
s/testing/selftests/kvm/include/arm64/processor.h
> index 7d88ff22013a..b0fc0f945766 100644
> --- a/tools/testing/selftests/kvm/include/arm64/processor.h
> +++ b/tools/testing/selftests/kvm/include/arm64/processor.h
> @@ -113,6 +113,7 @@
>  #define PMD_TYPE_TABLE         BIT(1)
>  #define PTE_TYPE_PAGE          BIT(1)
>
> +#define PTE_SHARED             (UL(3) << 8) /* SH[1:0], inner shareable =
*/
>  #define PTE_AF                 BIT(10)
>
>  #define PTE_ADDR_MASK(page_shift)      GENMASK(47, (page_shift))
> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/te=
sting/selftests/kvm/lib/arm64/processor.c
> index da5802c8a59c..9d69904cb608 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
> @@ -172,6 +172,9 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t =
vaddr, uint64_t paddr,
>         }
>
>         pg_attr =3D PTE_AF | PTE_ATTRINDX(attr_idx) | PTE_TYPE_PAGE | PTE=
_VALID;
> +       if (!use_lpa2_pte_format(vm))
> +               pg_attr |=3D PTE_SHARED;
> +
>         *ptep =3D addr_pte(vm, paddr, pg_attr);
>  }
>
> --
> 2.49.0.504.g3bcea36a83-goog
>

