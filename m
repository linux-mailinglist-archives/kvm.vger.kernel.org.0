Return-Path: <kvm+bounces-46932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B14F5ABA929
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 11:42:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DAE7A007A1
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 09:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06581E25E3;
	Sat, 17 May 2025 09:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjzydM0N"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107301DFDB8;
	Sat, 17 May 2025 09:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747474924; cv=none; b=RjtzQZKp8M/OFHWs37CgtN9YtOzXMV/8bH6RzCQVcULUjYyLyEjCv60SmxjJT3h/KN2UeqWe2G+98yFl2ZMiFQ5RnF1m52hufVXehpEzbpc5PiwwDMEeG/yfLge7OzOOvCHiaPDGXsYCYGQJWKsw8bYtoVK6YtptsGekE4x+cQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747474924; c=relaxed/simple;
	bh=eDeDabNwcWfJu2jBsdTWP/G2OPRP7QdzQUUI03NVF0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q1i4EHDKaUeJ3DlgNlj+MCymUMwqZjTxb2kSSUZGi8j8vixs9W1GA3r9Q1SCD14bWZ33rRfoFtc1j/iwZTdVQn+EaHAYwoRmerjLsoNRI3rOd704C/dyLPicFmnWI+0u2dm4irbxta2IFOW0VDQ+DSz0/nREtY4m9IMV3nkwXo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjzydM0N; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875EFC4AF0C;
	Sat, 17 May 2025 09:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747474923;
	bh=eDeDabNwcWfJu2jBsdTWP/G2OPRP7QdzQUUI03NVF0g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VjzydM0NxqAeSXH+oT/PCkwUbxftaGCIg569FuKlcsNtQ2Pms+tZRLHdoY9kCKJ2x
	 TWmauFv5CWWXyxhTTF1LTCGMphCE1qQx0ifIHM65O407o5y92Io1IpHTL3m6faAr5u
	 ikC0wwXghheoJktqv+Qo18axmMYG75eSgptGK0UpxXo0YkJvjRGszkg6ErKUUMJWDo
	 Yz1SE8hrJIY9ldLqqIgunbl1jcAXfpXFsBCRrZmoksf4nIbFe3sS/9Vk14RywuYzCe
	 LvOV1GdxNsAlz3QtwBtRTIBjZy0nifdkGkKwnAqkmW5pMdgmsZeLfe7tjEvU+5MDxZ
	 1zPp9U0jYreXw==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-601a5747638so474749a12.3;
        Sat, 17 May 2025 02:42:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHmPEkf8B5RUoByzNQcvB1AV/+ZgoB/V8UTwzbp+LrRdmAUFBlJCKtCTnUcY1WQ/pWw+KKycGj9BbFbebM@vger.kernel.org, AJvYcCXyj+mY4gSzOyp23ZXivIg0oJTEaeDDjCxgnCOJhHJGaFA+HATRMttpOOJCHaO0RJUpSKA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUhi4DUJIMjNt7415t6Gw1bVQYJ7hJrxAPdVqKPxnVDTDIV67r
	JUTYf5ScvIGQVEJ3KkiRCZ5GAjlt9psBK1eqxIjtakrO4j6tLYh0xLrlcY/dNuy1yU2evlMa/aU
	+mEE6tKsQvLfZB0mi1NL9kZn9YPVzxD0=
X-Google-Smtp-Source: AGHT+IEInOnJ1vjFH6Xx+hiddjM6eKb89zZrWzJS84K6z2zwAKvoQFyEkGQ7czzq7kh1+HyRmc4SqbOJPH+T8tpy0ls=
X-Received: by 2002:a05:6402:354a:b0:5ec:fb3d:f51f with SMTP id
 4fb4d7f45d1cf-6008a590b61mr5440273a12.10.1747474922061; Sat, 17 May 2025
 02:42:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250427024505.129383-1-maobibo@loongson.cn>
In-Reply-To: <20250427024505.129383-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 17 May 2025 17:41:50 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4hry0LfUwbPmURc+bbcAXG13wO2cHfdjcoijeezNhO5Q@mail.gmail.com>
X-Gm-Features: AX0GCFuQ-eyvvmAjNoTGSwrGGUJVGNDX9DTRsfOGp6JXoUyI1GrnKuVgZS2AQ7s
Message-ID: <CAAhV-H4hry0LfUwbPmURc+bbcAXG13wO2cHfdjcoijeezNhO5Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] LoongArch: KVM: Do not flush tlb if HW PTW supported
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied, thanks.

Huacai

On Sun, Apr 27, 2025 at 10:45=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> With HW PTW supported, stale TLB is not added if page fault happens. With
> EXCCODE_TLBM exception, stale TLB may exist because last read access, tlb
> flush operation is necessary with EXCCODE_TLBM exception, and not necessa=
ry
> with other memory page fault exceptions.
>
> With SW PTW supported, invalid TLB is added in TLB refill exception.
> TLB flush operation is necessary with all page fault exceptions.
>
> ---
>   v1 ... v2:
>     1. Add kernel doc notation since new parameter ecode is added, which =
is
>        reported from LKP.
> ---
>
> Bibo Mao (2):
>   LoongArch: KVM: Add parameter exception code with exception handler
>   LoongArch: KVM: Do not flush tlb if HW PTW supported
>
>  arch/loongarch/include/asm/kvm_host.h |  2 +-
>  arch/loongarch/include/asm/kvm_vcpu.h |  2 +-
>  arch/loongarch/kvm/exit.c             | 37 ++++++++++++++-------------
>  arch/loongarch/kvm/mmu.c              | 18 ++++++++++---
>  4 files changed, 35 insertions(+), 24 deletions(-)
>
>
> base-commit: 5bc1018675ec28a8a60d83b378d8c3991faa5a27
> --
> 2.39.3
>

