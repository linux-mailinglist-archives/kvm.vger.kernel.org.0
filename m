Return-Path: <kvm+bounces-59990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A26BD71FE
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 04:50:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C26D218A22AF
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 02:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C15307489;
	Tue, 14 Oct 2025 02:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzfWp0Q6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F709213E6A
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 02:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760410223; cv=none; b=bEMwT0G2ienXgYqutTpRsZdZb4TZINTRoG1trkKG6Cy4EFnKY1yu10YKbwDdKXdnR342+7uuQ7h5gVrDE8aqApH1iBwwr4+HR44O2bHjD2kpAZWRKAoD4tBXhCZPYXUtyLbI2tH/Fm+twAlqwCTz9Yy+T7J75PGuDQCRWPYbWpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760410223; c=relaxed/simple;
	bh=RrBAZIy0TteWe1rNbnE+vumd8Hb0TdY/5ho6tkbZS8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zksx6+56xsRl1dVduFim1WdtJm5HAfzFariql8rZAhzVJoPCTFJ3v5wHTaf0HMFwU7DHgzYg1/PZTsyyupoA2blAG2avTZdAEHHwUDphWOAkS0+/T6MWzJiNrap+YQ+vnWRoBaTgBN6ugyFZC9FZxySw0la5sBbIULToyBMUALY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NzfWp0Q6; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42557c5cedcso2578151f8f.0
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 19:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760410220; x=1761015020; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dsk3/CfBAO5ltJKDJvUsPAsJ58KzLDJtMB6cqf8BZM8=;
        b=NzfWp0Q6QxUZ5DHBA6xbTZturPACKrm8NGPXJ+4MGfLmQYgNG/WmQpnvNVjxejKQxF
         b80ozgGh01zu2aHDsJiWYUS6f2nLxUHmRwjcCoT3ch4CvV8MXStPlrkAsvDEOcCEzIIH
         1Zam2EqBEKMX9LEcKKlRksJcDGg2dxCQxYrRQdoC9Uu9FPNOAG9+uKcCMWIq3ISs4xnu
         E0rXuzZmBxBdIY2C0oTs/FB4PjUtlq5B0rmL2/bZoUS1Zj0coBwFkqxpFmgVwqVL/o/2
         jkukL+1rMk9emaOJ4DO0mYP1N/oXQItBfBphsCe/DfGb1jRFl0uhyQbRIMF1L7AHwGRv
         L1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760410220; x=1761015020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dsk3/CfBAO5ltJKDJvUsPAsJ58KzLDJtMB6cqf8BZM8=;
        b=TJ2iBGlgZ0oivLWau+jvdY9WyJ2Ojg5NmorVBLVm1N/G3WTNEBJcPbKEM3Uf3g4IFb
         VKTm1bzK9RZAaQ3v1AiL5di7x9ZwsGkJtp1iTxIY1Fb6rB3u3ooUSaxZDuDAUtN552fO
         TLlceA0llEYTD4heoIZPlKlTbu2tCw90iTVC5pDR0tolzRZLDyaNHbK4q6FqzzsLlGKJ
         aAc0UMxFyEugTQ2FCc8B1YcpaeTunPTU5v7zkxPlVqU+9S2wyUC7lm/EeMt2tbUoSCoN
         5/q2CUilFuqI7/DzlWQXCkSeMQqTIUeKiRlKD6EBq6a/WDvT9GpAwmn5BdQ+PbL6NF11
         c4hw==
X-Forwarded-Encrypted: i=1; AJvYcCV8ukcX0O+q75iAQzv6iWAwBQFWXNubpDWaEg8QN3ZjlHEQZYgwg9TRpfOTkgckKvFsXMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKS9DVZ+qwWD+PlqpkjwguBDrw5QO+VVXP2w3zDJ/RiLcFmcWm
	Md0qq1597vaWFwrCIAyxJBOz422AHmmBzAjgtAKMjIRewWMmmq2eIoea9DZyA90nCfagUVJWO55
	K5YZiDN38u711xrChUzigt2WE5Y8OS+g=
X-Gm-Gg: ASbGnctgTO2a55YBDuR9Nu5KoVIPwouwDu/KnDKtPMFxIAwDucD/EdfyngDv7wUdEMp
	8hBBs+dTUgA1s1zTpai1z4CP32c86xkbioFpIulVYzO7P+xBhgsjLzmhZx/U9j6ljN5lEPbitti
	vNWHX0XZnlFN68VFCEWR3bdSz9xR3HwsRRIhkv3lx1Z+UygXW8XeESkSyqJHeBSneOlyHe9CMtE
	vc8dA+ExWP/R4z9h+mz3ZXowlyxTGivXa29icNGmUo/fV8g3YtCmJDJYBxAkI7HjWJ1Uw==
X-Google-Smtp-Source: AGHT+IG9mJh8ykO/cRsI1p26T3hRTaGKLUk4Twtr59/y1RD7cuCR/M359pO3FDOyWU1KemQ7oMxv+1oAoHB6goCn2Uo=
X-Received: by 2002:a05:6000:2087:b0:3ee:1563:a78b with SMTP id
 ffacd0b85a97d-42667177dc7mr15344285f8f.20.1760410219591; Mon, 13 Oct 2025
 19:50:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014023450.1023-1-chuguangqing@inspur.com>
In-Reply-To: <20251014023450.1023-1-chuguangqing@inspur.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 13 Oct 2025 19:50:08 -0700
X-Gm-Features: AS18NWDYezDAswt7t7gVgX0LbcpsbXLar9N7zvRnvMlP9Bm7rix-FersDRs5Vy8
Message-ID: <CAADnVQKMgbDV2poeHYmJg0=GD-F2zDTcjSxcUDZSO3Y5EwD17Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] Some spelling error fixes in samples directory
To: Chu Guangqing <chuguangqing@inspur.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	kwankhede@nvidia.com, bpf <bpf@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 7:35=E2=80=AFPM Chu Guangqing <chuguangqing@inspur.=
com> wrote:
>
> Fixes for some spelling errors in samples directory
>
> Chu Guangqing (5):
>   samples/bpf: Fix a spelling typo in do_hbm_test.sh
>   samples: bpf: Fix a spelling typo in hbm.c
>   samples/bpf: Fix a spelling typo in tracex1.bpf.c
>   samples/bpf: Fix a spelling typo in tcp_cong_kern.c
>   vfio-mdev: Fix a spelling typo in mtty.c
>
>  samples/bpf/do_hbm_test.sh  | 2 +-
>  samples/bpf/hbm.c           | 4 ++--
>  samples/bpf/tcp_cong_kern.c | 2 +-
>  samples/bpf/tracex1.bpf.c   | 2 +-
>  samples/vfio-mdev/mtty.c    | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)

Trying to improve your patches-in-the-kernel score?
Not going to happen. One patch for all typos pls.

pw-bot: cr

