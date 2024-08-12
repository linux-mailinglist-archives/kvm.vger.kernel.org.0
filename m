Return-Path: <kvm+bounces-23830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDDD94E8BD
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 10:39:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6534EB22B76
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 08:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09C516BE24;
	Mon, 12 Aug 2024 08:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YqVOzP9o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18034D599;
	Mon, 12 Aug 2024 08:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723451976; cv=none; b=sRvS0mzjkHNf4th4EAXsVT1Ir4k6ENKimlkh2Q/BhMiOUp2zbHo8gJ74IzNXl/CdF8T5EmF6LWSKwfroh+ij2E0uucYQtYejD9+VQ8Gyxj7/+WxojjUJnB5WQH1/3pM/R4k329mo8fnuBEfIRdsBxtsL9AhvtUhpx5J+kahvLcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723451976; c=relaxed/simple;
	bh=XV9nUjhCLyBExk+VSw3rxsjG7FtPdvav3bqcyHbHGkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nA86uGZNlDzquTLX1rjl0sQNFK0pdXWtufwMD9V7TgfYpCOeQ1eITgIvTfMTGHKBea/4Gg9Mpy3WgtifYaeBG9/9B7jikeSumcnZelJ4OhYXjN26j7IOX8VA+OS4BCHD6/YsN9R9GK0NyJRIOqFGuJ9xqig4u8nSHBXOG2WBqyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YqVOzP9o; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2cb4b6ecb3dso2676011a91.3;
        Mon, 12 Aug 2024 01:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723451974; x=1724056774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBMPxTNOVtFQ5xIdEF+qAroCx/SMbY1g0f4CRcJTrug=;
        b=YqVOzP9oM42kWqvxFpPeD3Xw/CJ8H2/PBm4tMg2JtoBzujuWkTCqOXyRC9tw4esDRA
         3Y4Gc0oefxkvqx65h65WuUmJ9xn40PpiGX7PJWRPVSWKcS88TiLGc+nhuvzWXuN0YTir
         nzWt11H03LejuosnuIdlJwY3eZXISIudxPKZkC6ZFvtQlqXTkutjps8y1zDWB7q1UTM9
         A2ZGJV/G18vBn8GzHRPoXT+w03s9vpRky2NFf6XhBWJ8RbB/zFJa8RUSAnAEjiC1tKzy
         YgBB7AltQVs5lFdisKcv7E+ZERYqenBkQTon+Q7zgwo1pZIM933nTc3d+Q3P83vuPzNb
         /iEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723451974; x=1724056774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xBMPxTNOVtFQ5xIdEF+qAroCx/SMbY1g0f4CRcJTrug=;
        b=YUaQjS+B3MzK9dF/NxOrTAdSjXP6BVsShPtdZUPgcCP8K5EIeMTd66Vx/XQpff84R4
         Nli3lwOiktdWVfsk2tw+EXKNAalRVRYU0rl9ubh7E/AejA+3qCy/3XmBr7U0yKkUn3L9
         gjkR0hO7OI/9vPNMRmakHjmJRh55Xsa1xmQ8GaHapwuRKaru/b6vMpMmModrajyzoPNb
         z/XccHOKJVWUvR6PazDM4l5WAbgnH010JUVCoWNo9naNMV2KvsrCtcRcVi+U7weGSAS+
         9V8mFATpFeZY1hpvHE0+OZFIv3nQu/2I+spX/iIaQOn4jzxUvxDWmONGxAIohz6isAYi
         A/AA==
X-Forwarded-Encrypted: i=1; AJvYcCWqXhj0EEJ87VZMZTwJ5M2URWC5VL+DJL0Oi07aNF3P3TCMN5ZooUkRpf7K66ICNSoLGx0xpCxLsG8T/7XjavRRU8Wq8Ha8QosD8YAU63iRhE6K2zQyglqufPXhZT4xqmJl
X-Gm-Message-State: AOJu0YwPNaVRmoc3XJcouDWDsKfpYBArNFtX/vOXk/xsnWYrW6gm+KWF
	2xcoecPnuj7x1DWcwofPoIYC7KH/vyntGza71H8l4v/v6vCDvwdNtvle0b+cRqDFAF/7MfC0pm0
	x0RKOPhdxXkRBKaoSKzr9N6jSieporD7O
X-Google-Smtp-Source: AGHT+IH6HghSMo+9Sxukc4P5KkTBPEh7Tn0fTZUIAUJi80M4JJMpJiInTSz+J+l7UC2Qak+l8kDuTrE2/oRUmDNLcIo=
X-Received: by 2002:a17:90a:d812:b0:2c9:6ad9:b75b with SMTP id
 98e67ed59e1d1-2d1e806a0d7mr5647208a91.40.1723451973922; Mon, 12 Aug 2024
 01:39:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com> <20240809194335.1726916-20-seanjc@google.com>
In-Reply-To: <20240809194335.1726916-20-seanjc@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Mon, 12 Aug 2024 16:39:21 +0800
Message-ID: <CAJhGHyDjsmQOQQoU52vA95sddWtzg1wh139jpPYBT1miUAgj6Q@mail.gmail.com>
Subject: Re: [PATCH 19/22] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 10, 2024 at 3:49=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:

> +
> +static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
> +{
> +       unsigned long old_val, new_val;
> +
> +       old_val =3D READ_ONCE(rmap_head->val);
> +       if (!old_val)
> +               return 0;
> +
> +       do {
> +               /*
> +                * If the rmap is locked, wait for it to be unlocked befo=
re
> +                * trying acquire the lock, e.g. to bounce the cache line=
.
> +                */
> +               while (old_val & KVM_RMAP_LOCKED) {
> +                       old_val =3D READ_ONCE(rmap_head->val);
> +                       cpu_relax();

The sequence of these two lines of code can be improved.

> +               }
> +
> +               /*
> +                * Recheck for an empty rmap, it may have been purged by =
the
> +                * task that held the lock.
> +                */
> +               if (!old_val)
> +                       return 0;
> +
> +               new_val =3D old_val | KVM_RMAP_LOCKED;
> +       } while (!try_cmpxchg(&rmap_head->val, &old_val, new_val));
> +
> +       /* Return the old value, i.e. _without_ the LOCKED bit set. */
> +       return old_val;
> +}

