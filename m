Return-Path: <kvm+bounces-47887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D795EAC6C9F
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 17:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EC3E3AE2E0
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 15:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4C9028BA8E;
	Wed, 28 May 2025 15:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XSHUHdzh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493EA28BAA8
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748445036; cv=none; b=jmfLKam+orx1U2PvKQR20y3h96obfa4xkLM9SPTC+Rna9+EmkcEp5V2ailRd5aqeAytlTh6d0v2aOb/hZhkcLd6/U+RGK27grmHU2TAZdznuOs+cDLQHVwYDg1NdKIpvhgiUPCkAyYcHR0jVl+D/rnReIqd//cMM0YUd9s+GZCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748445036; c=relaxed/simple;
	bh=oRij2I0TpTX32X/NhxasXgfEJxa8A5RThaAlheT8LBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YM2wP07+7QRFd9Sf3m+cQPkZxI60W+LoFacyuy+Ovlds5BQ2hiSQpJZA1PB4A/iRaTYASjB+891xYJp5nVOGXZlx0rj0nP7YdKnnWDzniZSb6PkeOYRdrrTuQA0vOMmHOtiN7MTZ6dAm3vIhc1rvlK6krKJC09s2ozrNZa+5eGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XSHUHdzh; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e7dcd60c092so1440560276.3
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 08:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748445034; x=1749049834; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mkOH/F0mBjSGdYPCUEiDsSIcD6SIWcpvbL1Z7KSMawk=;
        b=XSHUHdzh4M3Tz1CxqHeZu5QTLHzRV3Z8TIcZdNftoj7tZJUy1qxF7vAtEIvnAlUmTE
         JdJ/7C3uWpNaHD7A0OgWrMpPOQSSOCNiRkVqlgam5TmRHWM4uNeLXI4FgN4H6pg9dvOc
         /YNI8k4NDPiydQqZD4S9zOl+A5gQDsBNgNtowZwexAva5z9XQKZLChtezIFfZ061EFpY
         aTQxb3ee98rHEGg85oBwRrIFAsYtUYTDRDOXQOgCJGmEmWCg3qr8Ez/LcFK8QZoqDMEJ
         rvqjRx5+n+1UF3ppt/Do5fixTZf9bDsTo9IdGYvIVYoXkmMrod0ABMGWssVFg2SXP5JO
         1yKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748445034; x=1749049834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mkOH/F0mBjSGdYPCUEiDsSIcD6SIWcpvbL1Z7KSMawk=;
        b=nV6qsUO2u5kDZ9+VluAjrB7Y7NcP/2hv8Forfy/ySnw/e2M+gQ0rErgsCMDheqm57m
         BnaUAa3MLuoTDhLyCBzh1Na8SWUUbM+fUuX1Z8PiAw+kxsE68e+eM4+ACt26Tt9v/xTq
         sDLZzHQV7Gn1wuNFWyG8h60XPWQpBgm+Z9T/+OkQmyDaki9vTxZog3uVBMYinAXyKNDq
         nmc4IPOktZbNIRWg7xr0a3dABfx16jDDtPG6iko6apr28U0aIipFRNRbgRTdgaAhgWj5
         sQueuzR8nsu3ieNWwUor0LgEVB7qLScDZLCZD0KeLfcLlmO3Ue2/KKZDHRXw+TXKJqlP
         KDdw==
X-Forwarded-Encrypted: i=1; AJvYcCUSLXf9XPNiq1u9myWlVxPMF4WlSTCQE5s8YcvuYaxDxETmOxBRY0YwhDb+fkYmT/jlrS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYUqgRKx55OWWtl4haW0FblACP6OVc03WYRwsRlzcKB+wNrITL
	Tt3L0NckjMyoIM0ybN5Zc08lEqC7gdmN6XymQwFk0HDoMr3jakActqF1K4ZjRDuTnq4a1DLK0AO
	BTipJtrmtr4W2o2STIpeq2sqhAzmxrvMgAF3TN4Qd
X-Gm-Gg: ASbGncvVfAoQbVYpY1tmGbXdAuk96e2ADjqznpuFJA39ssvq/908+1gXl3SqhC1KULU
	js0xGOxa3UUYENgS16Nszm/HBgN2sn63qafpea9oLnWAxSvalJZhmhnH7Ld47I2Dm3+KQLQIXuQ
	sxwRsjqzo4Qug0lkkh1RyvLdc55CWuT0OviGT4rdJW/MvnSQ4KAx2p73P3Ds7pZ+I9Cqta4W0/6
	O+LYcD6CN/OR2fQ
X-Google-Smtp-Source: AGHT+IGR99lWrX4uBQGr2kH0bGfT4JkEfaCzPmaHW/nbBCSd4QahIO99ZAocGBZAuHyfUiwPf1Ucb1uKFWWP5NDU59M=
X-Received: by 2002:a05:6902:2841:b0:e7d:6fe3:fc81 with SMTP id
 3f1490d57ef6-e7d91b459aamr21754237276.30.1748445033884; Wed, 28 May 2025
 08:10:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
 <20250109204929.1106563-7-jthoughton@google.com> <aBqkINKO9PUAzZeS@google.com>
In-Reply-To: <aBqkINKO9PUAzZeS@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 28 May 2025 11:09:58 -0400
X-Gm-Features: AX0GCFt9PLVfklSGC-mOnCNW0mGP_16cIQYPD6tP1ev5K3PmI8fYxDutOCJrYcQ
Message-ID: <CADrL8HXDDRC6Ey5HYWvtzQzjcM2RNX7c7ngGyjUsD3WiBF3VYA@mail.gmail.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 8:06=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jan 09, 2025, James Houghton wrote:
> > @@ -2073,6 +2080,23 @@ void kvm_arch_commit_memory_region(struct kvm *k=
vm,
> >                                  enum kvm_mr_change change)
> >  {
> >       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PA=
GES;
> > +     u32 new_flags =3D new ? new->flags : 0;
> > +     u32 changed_flags =3D (new_flags) ^ (old ? old->flags : 0);
>
> This is a bit hard to read, and there's only one use of log_dirty_pages. =
 With
> zapping handled in common KVM, just do:

Thanks, Sean. Yeah what you have below looks a lot better, thanks for
applying it for me. I'll post a new version soon. One note below.

>
> @@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct kvm *kv=
m,
>                                    const struct kvm_memory_slot *new,
>                                    enum kvm_mr_change change)
>  {
> -       bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PA=
GES;
> +       u32 old_flags =3D old ? old->flags : 0;
> +       u32 new_flags =3D new ? new->flags : 0;
> +
> +       /* Nothing to do if not toggling dirty logging. */
> +       if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
> +               return;

This is my bug, not yours, but I think this condition must also check
that `change =3D=3D KVM_MR_FLAGS_ONLY` for it to be correct. This, for
example, will break the case where we are deleting a memslot that
still has KVM_MEM_LOG_DIRTY_PAGES enabled. Will fix in the next
version.

>
>         /*
>          * At this point memslot has been committed and there is an
>          * allocated dirty_bitmap[], dirty pages will be tracked while th=
e
>          * memory slot is write protected.
>          */
> -       if (log_dirty_pages) {
> +       if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
>
>                 if (change =3D=3D KVM_MR_DELETE)
>                         return;

