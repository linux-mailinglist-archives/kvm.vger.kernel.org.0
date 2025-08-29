Return-Path: <kvm+bounces-56271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3EEB3B840
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 12:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4252C5679AD
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2512B3081BD;
	Fri, 29 Aug 2025 10:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Db6AkdrF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B4A2877DA;
	Fri, 29 Aug 2025 10:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756462228; cv=none; b=d7Y9CHF6aBzk4v7aDQzHmAfqNAknWxDDlzk03GVt/C/SCxVN7kUNnGb2M9I3C6fyu9JKU5bG6ClW+0Gw6qY3xGYOA4RppJwKSz5BtzQz68DgrQLwj10WUwdJyM7B75HA7TfUyZ0Dk7SEipt/Qr6KlXocZ7N5thEo3PDs8qe+WVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756462228; c=relaxed/simple;
	bh=3WANg64V0AhtHHBMJuT9dXLg2Zyqf27J8zwlg0GxBss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uZeesYVqRNFk4QVJlf99AWjsrvC5jgyX49Ir/x+TODJ9F0SPvBfkDdpDHtWrGmcBCOW8qRlrq4ScjQNb/y+xXcNejWuyey2JJVJQj4ccAqDxciS2LsXY/c6Kh0llUG8gMOfZWZbbUJJ1CebqM7n17os71wWEsoSIfIwoFmlxJAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Db6AkdrF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C03C4CEF5;
	Fri, 29 Aug 2025 10:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756462227;
	bh=3WANg64V0AhtHHBMJuT9dXLg2Zyqf27J8zwlg0GxBss=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Db6AkdrFbm30w1oQGUhWMO2WMzz5DzdSeYpfCV4DbNHuGdIejJ0L3pUV3tSV6SS1u
	 Jp4w3Q2cYCj2Xo31Rxpt8iQCKxAturNna8A0dzIsscJPDbKFcij8j7fxtEI4CVp3Ce
	 iSs8cxcTv3uNDyXnhmcjd4HFn/1uGqZINi4xtiJF8AfQbuvqb7CMDitXnYL77FPA8u
	 lt90W1/P4DE2o6S+D3z9/LoKnhqBkYkKDEOuwyWqkNxCqtY7lHVsFaUpZSrSJ3Vv9o
	 9wkQ7Bxhb0rEvuqTvtp0ZKfgH/5dUH1SrdaPlqQYutOuJznlQ8CEIoRcFDSJ+xOdrg
	 rwd31zJNV5yJQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afec56519c8so315208566b.2;
        Fri, 29 Aug 2025 03:10:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVvfBvxIHAtFZBL3eBiBNsUWMYmCqYnoxubj+fPAsl2931ukZVN9CUgem2xMpfqMzRZy+/gkMof8wg/pNQy@vger.kernel.org, AJvYcCWVZN4H0hLpSU3O4b4oG37l5yV5nFU3cGbWZgXofgdOLLSNOdHPZu52kLgx17GXKLZ/7f0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8iPd+fXtu3GLh5J3gLlbDhtoy/LQ1fppRSDA5aoHcsEC5qqo8
	P8F+9kD4D9SVFVEIVzFwF8mGsXD2vsf6kZT5JpYg3xAyJ+z4LpPjQgVN5Hij+s+bD/G2UNSbk7E
	09WscYZhso6vp+kd1/a+MTCBp0d/zspA=
X-Google-Smtp-Source: AGHT+IGfMnD3et1X9S6L6LTbSrnZj/K0lDdYWcZTqe9320LEXrhS+WmGBAbSOKMAO9btzm7GZJC/k4F389xneyogIeY=
X-Received: by 2002:a17:907:9443:b0:aff:a36:e6e with SMTP id
 a640c23a62f3a-aff0a361006mr114542166b.57.1756462226382; Fri, 29 Aug 2025
 03:10:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250819121725.2423941-1-maobibo@loongson.cn>
In-Reply-To: <20250819121725.2423941-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 29 Aug 2025 18:10:13 +0800
X-Gmail-Original-Message-ID: <CAAhV-H62_8OUfK_s2WZRHzWbZd5kJib-7m9eiHQkLeCh0kMd7w@mail.gmail.com>
X-Gm-Features: Ac12FXzyz6W1kNNoG_HK2wLpB3u-YKZY-6E89pRgtF-zJhcLX6NHD35j4BP5lck
Message-ID: <CAAhV-H62_8OUfK_s2WZRHzWbZd5kJib-7m9eiHQkLeCh0kMd7w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add sign extension with kernel MMIO read emulation
To: Bibo Mao <maobibo@loongson.cn>
Cc: Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.


Huacai

On Tue, Aug 19, 2025 at 8:17=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> This patch is to add sign extension with kernel MMIO/IOCSR read
> emulation, it is similar with user space MMIO/IOCSR read completion
> handling.
>
> Bibo Mao (2):
>   LoongArch: KVM: Add sign extension with kernel MMIO read emulation
>   LoongArch: KVM: Add sign extension with kernel IOCSR read emulation
>
>  arch/loongarch/kvm/exit.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
>
> base-commit: be48bcf004f9d0c9207ff21d0edb3b42f253829e
> --
> 2.39.3
>

