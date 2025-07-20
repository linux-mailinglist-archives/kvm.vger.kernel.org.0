Return-Path: <kvm+bounces-52952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F9C4B0B454
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 10:51:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 496883BF8E7
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 08:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936971E51FA;
	Sun, 20 Jul 2025 08:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RIRDrwj9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7774125D6;
	Sun, 20 Jul 2025 08:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753001466; cv=none; b=swhRD+McGWamFnGPyeEHfx9k5oeD3hhXi+GDBY+bwHbC5iDki0CrYsGG//1njU2TAG3xFTDrOAGk0WKqegbH+jNibr7Z14897jGotTQhXHwqkAYSaSQnQu7MbAI1w4hKhFnupJVE+vQXiHT82EA5oh+4UyTj4Nrxl6XqJj4LCsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753001466; c=relaxed/simple;
	bh=J/rvTA/jVuJbWTmukEQlcZNGdobpB8JKqXpVtDqlIs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AjDNq+gCOYv8IC0cKUiJMmS9Y9zTw6w/QnPKjkmVwvYW3A/RhrltKKzyuvRGmprDYbL2MHRFeJnyUf4Mpd0EGh3EMco9zY5UxuKQ34RUZIVf4ZB4o8AGMg/Z+HGtkpqNEwshavz4IHsoa59VoR/QPDPyLObBOttWtIvWd/g+kBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RIRDrwj9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A112C4CEE7;
	Sun, 20 Jul 2025 08:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753001466;
	bh=J/rvTA/jVuJbWTmukEQlcZNGdobpB8JKqXpVtDqlIs4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RIRDrwj9pdMyhOlDbz+oMbMYScGSjwW6AWvNA49OnBKK1NGliFK/uZAALHCBZpShd
	 bN1YmhWO5vRqBOg5fyaeTtxwm9kIoiwobFhKwT/HQXpiDe3e9GgCxjWtV2Hu2o8Z+6
	 nd2aZxG4quV8ngHBa+o+q3it8TiKy5anF7vYZIhMmZVjAOSgYXYzuebE05/7ets7HC
	 EnP9s0zkDbRhTPQZ5PkyvRxNrL5W1DH/vn07/B7I+cI/eLr4vbpOYaK8cvDVtrgzqH
	 y9awgRieWZQEqe9hkzAEX4IsZv+pzRqkTbDBoUZo09ktXJucZrWHR2pasMXQFFvY0A
	 nS0cdcWd3QcYg==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6097d144923so7339253a12.1;
        Sun, 20 Jul 2025 01:51:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUaSvwA7rWNw8fw21/VnFlI9vA3H4yXJzHudw57kcVkAd6T8mQ6+0tG7tapOoP1iUyTIEbewevVE7zBYb7h@vger.kernel.org, AJvYcCWlxiEyHIA/pNp9xAKzRSe1zAXsYA7z6dlwSGKb7qHwuUWgi4131GE465ErWZX0rtqm64s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy68A0R26/lwJWzotlhSlrgdYQOqlo0Iz05PI6MS/WNWVRGFaXH
	jchcrgEYvpT31U/9ch3TAwr8EDio2dQ6i35utoSUNKLBdFOtFzuDuF3m8y/XQSPNBjYy+Tf7Ng8
	2hW+RY/Idz/0Hmq2cFOzxHv+8Q771CuA=
X-Google-Smtp-Source: AGHT+IEekYjhbbbLsayWGO6yVvrLqKRoOKVGGoHcBf1eDQ74XzFA7hmcyVBlCaoveLApmim4pjfmJrwCvzU0OHFsXic=
X-Received: by 2002:a05:6402:3484:b0:612:b6aa:783e with SMTP id
 4fb4d7f45d1cf-612b6aa81ddmr9149250a12.11.1753001464967; Sun, 20 Jul 2025
 01:51:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250716165929.22386-1-yury.norov@gmail.com>
In-Reply-To: <20250716165929.22386-1-yury.norov@gmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 20 Jul 2025 16:50:52 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4yxH0qHA5V4dwSrU3nTFYBzRVQa2z-a0fScj7pkSesWQ@mail.gmail.com>
X-Gm-Features: Ac12FXyW1wh1OZXBKreWa8iIshHa85Cc2VH4ySoj1iJikvxE9vBhn9liOhOoTnk
Message-ID: <CAAhV-H4yxH0qHA5V4dwSrU3nTFYBzRVQa2z-a0fScj7pkSesWQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] LoongArch: KVM: simplify KVM routines
To: Yury Norov <yury.norov@gmail.com>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.

Huacai

On Thu, Jul 17, 2025 at 12:59=E2=80=AFAM Yury Norov <yury.norov@gmail.com> =
wrote:
>
> From: Yury Norov (NVIDIA) <yury.norov@gmail.com>
>
> Switch KVM functions to use a proper bitmaps API.
>
> Yury Norov (NVIDIA) (2):
>   LoongArch: KVM: rework kvm_send_pv_ipi()
>   LoongArch: KVM:: simplify kvm_deliver_intr()
>
>  arch/loongarch/kvm/exit.c      | 31 ++++++++++++-------------------
>  arch/loongarch/kvm/interrupt.c | 23 +++--------------------
>  2 files changed, 15 insertions(+), 39 deletions(-)
>
> --
> 2.43.0
>

