Return-Path: <kvm+bounces-17799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FD08CA457
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 00:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7B9CB226AD
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 22:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B8C139D07;
	Mon, 20 May 2024 22:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FC4J8Efy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303E51CD3B
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 22:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716242748; cv=none; b=h2Oq5k42qHh24W0yxdXDYVVAMmSUb72+qtsleV7n+AnxWQL+a40LPID71RCj3DdyXVGq7Hh4KTYakv0cHcoIZnCkh7M3O47MMaXLhF/iN/Dbysa9b1LkQn42ZgzDP35cF81qvIvkn4Pfbb0s16xuFz/EFvAhSZxXfedQij2W7ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716242748; c=relaxed/simple;
	bh=4JZdz/1D+d0zQQyDQvVHptZ5R9UfQntpoUvU5SuzHqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pC2ZyPIYUXyOw5uIvpA/sBhRztPKTWd4G/veVuLHiOIlHLZo0KZ3Gngfkz6UpRv1dIcwgM1jnVyESNP+KTahYzPquSVZ6P1AblgEbTyBpivU2rKDdIqTp71DwUNSmOYTG44m2aZxjJn9Z+qyZwIrkOcOKVjo3hM36pZyyTl8NGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FC4J8Efy; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-51f12ccff5eso5938065e87.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 15:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1716242744; x=1716847544; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5k5eJmbzJa61ZoWDHg+7VWIVwbJtoHtJlHDNGFuDR+E=;
        b=FC4J8EfyNxDSU/f907zrY40tqmOXhCF8tOzhad1kJc/ZxRqn7DOfgcdPG4FreRzHV2
         Jwoapdt9mJRwPE4zwetIH2zUE5fE8Mz0Ty9/PXzx13IkxGuuG918ObE8WJDTpSLLBezI
         ModFMvc2cF6zW4eta25/LyFMlZbw2cMTVZzP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716242744; x=1716847544;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5k5eJmbzJa61ZoWDHg+7VWIVwbJtoHtJlHDNGFuDR+E=;
        b=OOfud8aH9/gmvRj80RBcs/EZkP8HYnXslaLXnGRObTtcqrqMeEHCYNlos3rQ6PS3zA
         q9fFd5udbiEmqnpduhvYcXD5EInlcZFJjuIzoFxuPqyQCj20L0NzSl1JNSoGdKLtkWE4
         FSz5aUcNbjtQWGz8STuchnotCCwmS7YG+KvBFd9ZQrlH6wHAoe9YpA8dNXesIATMRPf3
         yVZ+sGnrLkgcmOtJlTG0KGK/hDAPM0gxQAcosSTWYKWF/qd1GL83a8RguQwxzyUNNR7t
         JdYpK7Yrk1lCFj7z2ZWH7yTkxIbLQVdFTrW/8qMbm0JnEroQNxwE9DQ8UPGUyIsg0Y+E
         TgWQ==
X-Gm-Message-State: AOJu0YwG0k3uO3Rs1MB1UzUXoIs6Q9J/PliKTWNsRuV3edut5DoU18n1
	Nqnp+8g5F0zIsnPxd2WzNrVQuMxQC+sQ68TNx6cun1Q2cysDXGQDNN2uPwRGnFAuprH0ijWKjWP
	mYcCBGg==
X-Google-Smtp-Source: AGHT+IEN31HiC4jEUax1tqNfVxi8+4Nph9wZ8PDnzdqfDY0alido5MNAGU+QO9xKX+eKTZWA7ePTig==
X-Received: by 2002:ac2:4c85:0:b0:51d:1c86:a274 with SMTP id 2adb3069b0e04-5221017775amr17489404e87.34.1716242743925;
        Mon, 20 May 2024 15:05:43 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a179c7fdasm1509070666b.128.2024.05.20.15.05.43
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 May 2024 15:05:43 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5766cd9ca1bso2442992a12.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 15:05:43 -0700 (PDT)
X-Received: by 2002:a17:907:9705:b0:a5a:7cd3:b2e7 with SMTP id
 a640c23a62f3a-a5a7cd3b463mr1819041866b.11.1716242743134; Mon, 20 May 2024
 15:05:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240520121223.5be06e39.alex.williamson@redhat.com>
In-Reply-To: <20240520121223.5be06e39.alex.williamson@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 May 2024 15:05:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiecagwwqGQerx35p+1e2jwjjEbXCphKjPO6Q97DrtYPQ@mail.gmail.com>
Message-ID: <CAHk-=wiecagwwqGQerx35p+1e2jwjjEbXCphKjPO6Q97DrtYPQ@mail.gmail.com>
Subject: Re: [GIT PULL] VFIO updates for v6.10-rc1
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 May 2024 at 11:12, Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> I've provided the simplified diffstat from a temporary merge branch to
> avoid the noise of merging QAT dependencies from a branch provided by
> Herbert.

The diffstat looks good, but the merge itself sucks.

This is the totality of the "explanation" in the merge commit: "".

Yup. That's it. Nothing. Nada.

If you cannot explain *why* you merged a branch from some other tree,
youi damn well shouldn't have done the merge in the first place.

Merge commits need explanations just like regular commits do. In fact,
because there isn't some obvious diff attached to them, explanations
are arguably even more needed.

I've pulled this, but dammit, why does this keep happening?

                Linus

