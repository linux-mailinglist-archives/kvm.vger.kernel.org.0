Return-Path: <kvm+bounces-34376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA2D9FC8AA
	for <lists+kvm@lfdr.de>; Thu, 26 Dec 2024 06:45:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31A7E163023
	for <lists+kvm@lfdr.de>; Thu, 26 Dec 2024 05:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29ADB16F271;
	Thu, 26 Dec 2024 05:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="skluJqV6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA9A12F399
	for <kvm@vger.kernel.org>; Thu, 26 Dec 2024 05:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735191913; cv=none; b=es/Hzw+SCHWo5ZnuPfvS0RNFSOI2uofxk7MndaoSsxRoSQLSHa9//1GfK38yQ4xXtUW7+jtr+lQCHMHHgNi9NKxqVvpueN0s3WhA33jKdu1FrUkg/09CguW7sibZR0GfWL89we9ffk4EIgxa88hsrqYYrq8SIvvSAKPoIgwlrig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735191913; c=relaxed/simple;
	bh=m81onEt5mBhxE0I5u90Ex9Re8Un86YaX8Lx/mmJSSeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E/e9mBqRcPJC+hPUBNvQGxUwO+yCkrf6kASKZ6iMYmK4LA5oyt8gQB92+ndtO3utlMjj8t/Vk0UTJckbsRC51G0V86/VcyLrihMdrP85fEFNTzm1JEqxvpdl1pojRUw87032nX9HooA/tYp4bSsQfholZC0fe2TgPB1n50a1yOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=skluJqV6; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a81324bbdcso48500505ab.1
        for <kvm@vger.kernel.org>; Wed, 25 Dec 2024 21:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1735191909; x=1735796709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtyao9XCxuyrcti0Hf6VyClk0WR8AztwUzkNYeymagE=;
        b=skluJqV6tsHuWb+XLeG2u8ryK2wkDDERyQSj0ZcJLd22YWnNOiUxGd4TAtK+/RRl7P
         hHBGbW4wHD1MRA6f2DS8+1BKj2sNDYyKdEDio8raqA17Wkc8kHeAJxrkIpg9kk69e6Cg
         WBuDi0wLGMCmCmqQ+5O0n0LNH2HYxKqDybT8N3hp5e+Ae70+k9M2+fdwDlBZVB/NUViT
         YtVsmdmVWtkbgq3f+pwId9Lummmy1ar2FIrl5kViGv8rZWy2WBAdja+oiauqRMEFR+Ti
         SXDOW/FjSfsaIxUeAkoSwB5VUFoAGfedgGkxwlAViMObJDlbBO/nG7MEANrQ6ORBA/e1
         322A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735191909; x=1735796709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtyao9XCxuyrcti0Hf6VyClk0WR8AztwUzkNYeymagE=;
        b=dpoKQnswLAXcUZAbR4jpD+qG9lIc6ozvCqVGaSCQFrRRD0IFJ0goNX9RdaPksOShY9
         Fb+fLs60aKW6emRr9Dd4ZvuhTPzdyguZf2SwO3NZ0N+AyFeXww1cJtiB/RhTlxpspuCb
         C5D9UN0Yq6JDD8HuO2M7haWC5sZXUIcJBKe+B05iElUTPBo94TEzC4mkK+LOQSV2xAIH
         Ep0lspz4VtyuwMI8rMtPeQBp9cdfwQdY7pys2FCINYEidWfjP820hLJu9AaVif8JKCx/
         oL9bUvve3r4L2w2YGQpojTjcTGOCSNMvzRwtNap4KS+NumG+bVF2T2Y8EkAkNwdIEOSm
         Q30g==
X-Forwarded-Encrypted: i=1; AJvYcCWFtWi0gA37Biz7TAO9l/hsny0Za9QxqUHuraDvn+O270BUqL9rCvZrarrwnbwFHBAfwCs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX/h9wDBOOQIW41ZZ3vmIS6/Ic/gZ0gON/7x/o7ldHIherWVAe
	z+BWyCczJwPWfE2wxQEAmkzQ1f4uEM99tgrQIC95vMTw/g6y8S8NMyZTIXATwKnVKYxPc3Ot24J
	+Wbz5saxMyGPmhpXIXMCkqbUpY/UZrnEgmZ1OHFn1BNNF+NUFoGQ=
X-Gm-Gg: ASbGnctzvIwWUl4x4TpS0J+IZTL38rsiE7QZosoXsNYk+DKNbYG/KDunLBxQlgC2KN/
	Ck4P4fuw8gpWiAN5bpappX5sBS8y7VrV0vJ3kzpo=
X-Google-Smtp-Source: AGHT+IH6nTvJDAU6yLG9KF1CpMHiiYEaH6tsSIwR7GjbeccZhTbSi1E4UP7pA8+hFaBPCq5M2TKrAVu5a9b2j+IbiRM=
X-Received: by 2002:a05:6e02:2185:b0:3a7:c072:c69a with SMTP id
 e9e14a558f8ab-3c2d1c919b7mr205304125ab.3.1735191909080; Wed, 25 Dec 2024
 21:45:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
In-Reply-To: <20241224-kvm_guest_stat-v2-0-08a77ac36b02@rivosinc.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 26 Dec 2024 11:14:56 +0530
X-Gm-Features: AbW1kvYzlavyORKjBXtG1i2VfPZykEW7uxAUbLOaIZK7inugX45lU3EM1rz5dco
Message-ID: <CAAhSdy1whfogfDAZaDK9YCTSFw_+qYR3+nHGhAg=3EqZ-_4E1A@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Collect guest/host statistics during the
 redirected traps
To: Atish Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Quan Zhou <zhouquan@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 25, 2024 at 2:34=E2=80=AFAM Atish Patra <atishp@rivosinc.com> w=
rote:
>
> As discussed in the patch[1], this series adds the host statistics for
> traps that are redirected to the guest. Since there are 1-1 mapping for
> firmware counters as well, this series enables those so that the guest
> can collect information about these exits via perf if required.
>
> I have included the patch[1] as well in this series as it has not been
> applied and there will be likely conflicts while merging both.
>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
> Changes in v2:
> - Improved commit messages in PATCH3.
> - Added RB tags.
> - Link to v1: https://lore.kernel.org/r/20241212-kvm_guest_stat-v1-0-d1a6=
d0c862d5@rivosinc.com
>
> ---
> Atish Patra (2):
>       RISC-V: KVM: Update firmware counters for various events
>       RISC-V: KVM: Add new exit statstics for redirected traps
>
> Quan Zhou (1):
>       RISC-V: KVM: Redirect instruction access fault trap to guest

Queued this series for Linux-6.14.

Thanks,
Anup

>
>  arch/riscv/include/asm/kvm_host.h |  5 +++++
>  arch/riscv/kvm/vcpu.c             |  7 ++++++-
>  arch/riscv/kvm/vcpu_exit.c        | 37 +++++++++++++++++++++++++++++++++=
----
>  3 files changed, 44 insertions(+), 5 deletions(-)
> ---
> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
> change-id: 20241212-kvm_guest_stat-bc469665b410
> --
> Regards,
> Atish patra
>

