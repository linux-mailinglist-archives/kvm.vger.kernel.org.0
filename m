Return-Path: <kvm+bounces-25289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F15962FB8
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 20:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 119E71F211F1
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F491A76BC;
	Wed, 28 Aug 2024 18:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PwQHV71d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6EB14D71E
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 18:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724869233; cv=none; b=hQ/zViIN4WkrvInGl9q9SyufD4iAX+rkIxadZjcL4SZmzxox5WR6pV6sk1Di02U8e5mB3MjXaN6Ktz0RyXj/7KRVBVdLgylslGrLEpDsA5gEaYxYnnM2a+Y0QMiDENVKSrv0853tmNXY6OrAydbDsbdkb4cekDSGG+4i/byXZiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724869233; c=relaxed/simple;
	bh=GfsT+vvYha7T/tdivOawOneMSln9lfsX+bYPVQCgdao=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=EYn86vhjRLqn5KPIzagkwsvSBn6gbJot7WrV6IMNy0ebN+6UMXWMqou9PhuF2mhGwUXXLzA7VScYNemVhMmwRTKFtRP8aKX9XDFMhM1nFk4qVpGw4sRcJ6oDQAdLOq6zfWAjSSkQEhsTy+HWE5g4jHmplS/TEOvrb2ohbrLa+xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PwQHV71d; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-202563ba251so79372335ad.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 11:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724869232; x=1725474032; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E9QORzkbaaIm1Shd59RkljU3nACF4RVEs75Qe6yztVA=;
        b=PwQHV71dJo8Hu29+3dQ9VAHC9j7de9FC5teCZRnA3qqAXfYz/tCBCfI5d9Hwax47YP
         u77n/1tcTkc0uNOh00/SnlNmKGpw+mvVCU45+w8kWn2OHOQGy9gDxr7f1FAHK4dqnozT
         Q+tb6dytGFtMYq9fYU0jNO3lllgvlOhKomWBZM/IuqSMczS9ALMNib4wJqXtxAI8py5u
         hsghv72+bre50Yfs78spO9kuRlmXC+Xz0HRLgoEkw/3DGwaA+/mmgdRAm/eZZ1dG3FdQ
         8W3cRIhIiT5xTo4o0javEiDrzi4curUS95SvOhkyPFc6JFKIHCwPwcUNYeJZXy5yKBal
         bsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724869232; x=1725474032;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9QORzkbaaIm1Shd59RkljU3nACF4RVEs75Qe6yztVA=;
        b=CEYSoZNcSnufFGIGV0vvRqzuYqiLVDu3ZwZ924WUCvx1fkQZYfXn0WwcD5yblLryj8
         Q5zDwULUrS5+sg8TXXEFen60kzXd5qX1dI4u33nTJ7jEh1jcE48+RySXIHbRfgzKX4SZ
         sFeiXvJxtAhgbweOMer0BbxtTubcoQE3pXHn3jn5Df8c2nLY92P22onRiO/3ZlKbFuPn
         UWFElEkJ4XuNgLGDaGAzDblQchfVgys7cTEn/JFrOFRnOoDxnvv5GcycXHqWzsSoaRZp
         bndIs8jpfWgq+gK2s2m00zpHXfy+5B7A04rq4UFOAG/UYfopaDePzFKRWO0HcQTFnpWv
         YwdA==
X-Forwarded-Encrypted: i=1; AJvYcCXqKdFYX+PR8+FFIEBzC5aHNlAXqnAiciEbgoca1dQ7QUqLisIBR+aKTnQiTfV20AnEKAg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yytum+/B3c/jSazQjiCUmVlVx6HFy+c4/Dpr8RMyyEJqs+/lN4S
	HGAo58K3yXHcsnOv0BbfGyu9Hz1FBU/2ujHRNd8/uIh+2CNdXWIEBPDLT6su8Q/WfVdhuU9inAl
	PdA==
X-Google-Smtp-Source: AGHT+IGmEH4zsz+BBfnZFRtoj4ShHcKA/Dy+MAP5E3wD0XLVVVClTEOGYDvwZFejqOumhasfY16ODgvgScg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:db11:b0:202:2fc8:da23 with SMTP id
 d9443c01a7336-2050c3437e9mr230455ad.5.1724869231597; Wed, 28 Aug 2024
 11:20:31 -0700 (PDT)
Date: Wed, 28 Aug 2024 11:20:30 -0700
In-Reply-To: <20240809194335.1726916-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-11-seanjc@google.com>
Message-ID: <Zs9qbsC_mjWkoQr3@google.com>
Subject: Re: [PATCH 10/22] KVM: x86/mmu: Move walk_slot_rmaps() up near for_each_slot_rmap_range()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 09, 2024, Sean Christopherson wrote:
> Move walk_slot_rmaps() and friends up near for_each_slot_rmap_range() so
> that the walkers can be used to handle mmu_notifier invalidations, and so
> that similar function has some amount of locality in code.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 107 +++++++++++++++++++++--------------------
>  1 file changed, 54 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 901be9e420a4..676cb7dfcbf9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1534,6 +1534,60 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
>  	     slot_rmap_walk_okay(_iter_);				\
>  	     slot_rmap_walk_next(_iter_))
>  
> +

Doh, extra newline here.

> +/* The return value indicates if tlb flush on all vcpus is needed. */
> +typedef bool (*slot_rmaps_handler) (struct kvm *kvm,
> +				    struct kvm_rmap_head *rmap_head,
> +				    const struct kvm_memory_slot *slot);
> +

