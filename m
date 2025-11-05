Return-Path: <kvm+bounces-62122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BE44CC37D68
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 22:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ADA804E5562
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 21:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 822D634DB74;
	Wed,  5 Nov 2025 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IzoZQBQa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75B634DB64
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762376662; cv=none; b=OKXFLJreAuQcaiwfY13m345bYl/Ij+0d8NLKKJ2CE9eLj1+ZC+DPx3RPybRDbCVm7yrIwyV2FMxxjv7Hp/yv/ca54ZkQW3DsTDNZCdoXBhTpaOgY+LNipsI4ULjTXWpzcOSf4i/60J531qsVnQIzzeaLxeI9N/KTY5xMbfzuSo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762376662; c=relaxed/simple;
	bh=P8eDkmmPxYci1oATfDP4Fv06Mi8/tbu3FYJpC5vK090=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SDowHvVjxehKq6eHGYJdV0funxRkkRNmZQW0LidUIP7KTVGVEEp8b6qV2Fnszt3V3korst7EZCuOqshT2QVtbf1FnJ810TO8qTUIZ+KbSfy/JhkMaRB6E54JIbS5/MErRgrixBu8BdqDzcGhtBJXn4xWHwD12KhZM7NcuYIictg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IzoZQBQa; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-378d6fa5aebso2177071fa.2
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 13:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762376659; x=1762981459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUKzkaerNDYHfhaKw3P3V/fTljtW1E4BLZGuN8NzxHI=;
        b=IzoZQBQaCDS/vZUwIim/eHePnG/8Gc2Ltkxh5dhR60NSvxJWxa/NQ4iuTstAT2cE2/
         OjMMgYB8EMzqBkR0SHL8UNpU5blXcIQr4hZJ+CnNqbXrEbnylrDeozfETKSANaTK8Yly
         L5H/WyK2J9Bh7yeqXZmrfdDMtG+5G2Gv4RkFfdhlSrf8a/nHmpw5TcZWzmbo1eKAEqpd
         8SRGebhMCo9aazBKgw6oSiiIOpmdEmQ2xCMja4+S85nYy178ZPpM3ktbeT2zrMlr6LOv
         w0LfJXNKDcEMHJeGkOoUvM8mOox5z61uKXY7yuGbJr9N8GmqymVV3oWgZ46mFLc2yVkW
         RuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762376659; x=1762981459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cUKzkaerNDYHfhaKw3P3V/fTljtW1E4BLZGuN8NzxHI=;
        b=rjbo3Nt7xqNfGhet4rbGsuEPlcqNb7KexXjKLK0ohLQGvFWJeKzQrwK3FnTh3OWQY+
         VPbTfVr8fSOA1DBwfj9YjcO+cv8fIqiMSY3SlZp0O37udXtddz7QMKbl4lgCqT9c8Ff0
         Wv0zYy0jDjJdoQ33lqJrodN/Zcd+8kDxA45bCH/J+sRdBH0KTTxuVdx9F7t9mb+p20fU
         3g7a/WexUxD4Ok5YxSsvhHaio7ZXYwq9ykutRGt+Ntt8oDEJZwiuFbdnwpTSK86+f+B8
         97W4YRKqQ9+hGeqnZdBoj8q/pLid0mENr8MpVA+x592GkCc8Hi2oAn8QwM1NwlfFhWix
         IOlA==
X-Forwarded-Encrypted: i=1; AJvYcCW2PAxL5Pyx6HU43iFsoQ7xKDeDFWvim6rv86mBuqFLWPKIoTIewBh9jcBBfcGhU3CxPRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXHocLakKYN1DRva6rhPPVSmx7B0yGFlVsZZ9p5GOk5LtMkf9O
	P/eWUThE+LYF7Xm3INi8rTbgADJmXBeW859nqAaQlW/uCi3ZqRveTX+JPTmSb65Jt5p4AsE6Q53
	DZOjkdUtSYHWiUapiCg+0ZGIUIjGtN604eO+Yr08c
X-Gm-Gg: ASbGncu1gyt4Li/OZV5x7bP8QActcQl8O12EzpbEKVXIylejXJHbIt4EEMFhdrO0LWz
	U8ZPIIaNYb5Z2VX0Kygc8485GpIecPfRjmSuDkJgEKp1WwgpEmQgA2o3cG1iX5Tw2oi3jY73LRS
	SlF8TsDojwSUmPljGGlhVUn8aBsJ4Kk8hNSTVEG0Dvj5Vu0x7bXVc1h8jhTvqftc9oFEMvafLPu
	yuEyvThDHhFNNpYgKhzxdTHdpcm7PupjEJTB5EPVWsDwz1u1FMj/zEt7bgaTFICUEeMC8o=
X-Google-Smtp-Source: AGHT+IH/P3F2GwJ8frEJnTZxEXVJwxJdN6lDmimCTilmQ8c8TUMtSzpzwDQoJQEMWRvIh4RI0XmTrQB3lS7PrBEoYqA=
X-Received: by 2002:a05:6512:3988:b0:593:83c:b5f4 with SMTP id
 2adb3069b0e04-5943d7d0c91mr1150061e87.41.1762376658478; Wed, 05 Nov 2025
 13:04:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251008232531.1152035-1-dmatlack@google.com> <20251105120634.3aca5a6b.alex@shazbot.org>
In-Reply-To: <20251105120634.3aca5a6b.alex@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Wed, 5 Nov 2025 13:03:51 -0800
X-Gm-Features: AWmQ_bnEevN_rog3SGT_ycK5B-l0DtLiQ2LQYEh3MSTZPNsFgog3nZiWUQlUhAk
Message-ID: <CALzav=cMyD=SOUnpy3XnFn5cmn7xb8_YnTJHFyfCgqNpECCQsA@mail.gmail.com>
Subject: Re: [PATCH 00/12] vfio: selftests: Support for multi-device tests
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 5, 2025 at 11:06=E2=80=AFAM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Wed,  8 Oct 2025 23:25:19 +0000
> David Matlack <dmatlack@google.com> wrote:
>
> > This series adds support for tests that use multiple devices, and adds
> > one new test, vfio_pci_device_init_perf_test, which measures parallel
> > device initialization time to demonstrate the improvement from commit
> > e908f58b6beb ("vfio/pci: Separate SR-IOV VF dev_set").
> >
> > This series also breaks apart the monolithic vfio_util.h and
> > vfio_pci_device.c into separate files, to account for all the new code.
> > This required some code motion so the diffstat looks large. The final
> > layout is more granular and provides a better separation of the IOMMU
> > code from the device code.
>
> Hi David,
>
> This series doesn't apply to mainline currently and I see you have some
> self-comments that suggests this is still a WIP, so I'll drop it and
> look for a v2.

Yes, I am going to send a v2 to address my self-comments. I'm also
looking at getting reviews of this series from some fellow Googlers on
the mailing list. Feel free to hold off for now.

>  I believe
> https://lore.kernel.org/kvm/20250912222525.2515416-2-dmatlack@google.com/
> is still in play though and does apply.  Thanks,

This series will need another revision as well to address Sean's
feedback, and I think can be merged via KVM maintainers.

That being said,
https://lore.kernel.org/kvm/20250922224857.2528737-1-dmatlack@google.com/
should apply and be ready to merge. It is a small prep patch for the
KVM selftests integration.

