Return-Path: <kvm+bounces-23240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DADC0947F96
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 972232839EA
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 16:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF5315CD79;
	Mon,  5 Aug 2024 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cGDDg/2c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D884D8A8
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 16:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722876620; cv=none; b=hPa5Ktg+1LXcJolGUyEPJfkAl3Y5dQ/m4577wtIKmfMyEUi19GZnIQVd/u+5y5wzwqdykLaA0ojs96caPzCKHyHeIffqCmRWY/75kxSemmEepzu3z+fayUc5Dvq2TckCnwZhJTX6dVJzOPBGCB02vXjl1CcA/2U1BbiaSI+i2Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722876620; c=relaxed/simple;
	bh=sFpvW6EGiOzy6Y6ACTj0q4O8UueMOn4UVvTXWOLB/hg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ca8CggC2mhnUEGLjVTo+42Iw55PNyT6FqcRV66Um3bGBPw6RhAHc/TSTqQvCuGds8YAe/EqXB/Z+DnIzLXOwKeXc/ou6uqjumUUD3Oi43we/vLr6FT8uuikwgmorzWpHu5JqZHGhQBGMFoPVBANhIHDBGi4//P9G+iBTBR6lb1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cGDDg/2c; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-428f5c0833bso8315175e9.0
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 09:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722876617; x=1723481417; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlYHWIkzEdl16o8qSuGjYNjZJX/eTDu80bYLE0n3ANA=;
        b=cGDDg/2c0loAnbs2siM6I5bT+iq9ZzVp3v2mhyVkvfJAmmVdrLswggXHIxcQC8K5Io
         IiFt4cvlCJ5sKfYnQ3cZIPymKFXJCkfk8pDOhfRBVrW6vPfNKKmQMgHhjD++TllvG7QM
         Q33bmzNdTb98oPyISmrpFAmTY448T/Fa2MvSdOWE7BnfGsJs0PxoqSHGJG7xvXIyEbHJ
         L/7ZWv2SkAXQtsK5yWm1rtYe8mEgD3QKUdWrrmpkbuXlPhiTQtLsarWqedy+61nimOyK
         sHPHt8tHUjP8UruU2iu+J8nzH8VHml6lEDejpc7rznThMDbdXBoxRcaF0jffTNxlINPj
         ZJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722876617; x=1723481417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SlYHWIkzEdl16o8qSuGjYNjZJX/eTDu80bYLE0n3ANA=;
        b=INDZpM3UQkyRz3asUzx4xA4/ZrMXZ1dIudzObMV55Eb3VAhSW0yH+YsG6EJda0Hozz
         0nQIrrlA7d+e7plH+4YHkbJQtZx8vYpElqIp9lNWI3ecYkRK+xDb72DQZNfL4UxSUQF7
         h9/TuRTA7+0dKW1j+SwjbPJrb9TSnQw4MOHN4wgOXVh+n5LddyKQo7N1R0PFfEKuYh7f
         NS1TuGrU9Z9B+Q0CbGYgA1fmxyPpf6WrkiD+llKIkvBcWzTMtCwBlVPnf+M1vTRcrnHp
         zgngI6Bd7BADkDm7bnKo2241FJ0FqcA5mfXc18qqQ0ZaLA+PhyiGc5Rhg4GAH/XegGfV
         iMow==
X-Forwarded-Encrypted: i=1; AJvYcCXlDedaz0yk61e/1hzr+iOX6VOkmiJnzt1sArAd7+g5YfN6/PN5D8m4354vrkB013n0QI0AJXaQiqRZfTQZMCmJ5aed
X-Gm-Message-State: AOJu0YzdhaXPRw+4LLTbMJm93ksN7D2uA9nkIyzD4ZtpeDjTI7ZlApww
	6meG+nRiSJgAWqIkPHF1FZxjY9jEIi80A1DTf4Kb3iTn90t5+Ac5dq0o8M6o8TuS08D3qK3sOJu
	S+Sc4tCumkoG3E0uMbWpw48S1uQh0E5BaO/6B
X-Google-Smtp-Source: AGHT+IHB5X8RMkMuR6nTC5GH+4Sad90UxbHWWxo4J10jCiuYpyYejoudOm5/A5D8Dga81IvgZD4iL2n8LOdbFlZXPbk=
X-Received: by 2002:a05:600c:1c9c:b0:428:9c0:2ad with SMTP id
 5b1f17b1804b1-428e47a4e36mr94354085e9.18.1722876617038; Mon, 05 Aug 2024
 09:50:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801183453.57199-1-seanjc@google.com> <20240801183453.57199-5-seanjc@google.com>
In-Reply-To: <20240801183453.57199-5-seanjc@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 5 Aug 2024 09:49:51 -0700
Message-ID: <CALzav=cOnS0k5RRRs4wn4jCwFKNBHuPSj+mJjbp=n-E0uvU=Cg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/9] KVM: x86/mmu: Use Accessed bit even when
 _hardware_ A/D bits are disabled
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 1, 2024 at 11:36=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -181,7 +181,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_=
page *sp,
>
>         spte |=3D shadow_present_mask;
>         if (!prefetch)
> -               spte |=3D spte_shadow_accessed_mask(spte);
> +               spte |=3D shadow_accessed_mask;
>
>         /*
>          * For simplicity, enforce the NX huge page mitigation even if no=
t
> @@ -258,7 +258,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_=
page *sp,
>         }
>
>         if (pte_access & ACC_WRITE_MASK)
> -               spte |=3D spte_shadow_dirty_mask(spte);
> +               spte |=3D shadow_accessed_mask;

spte |=3D shadow_dirty_mask;

