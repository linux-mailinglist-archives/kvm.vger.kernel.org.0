Return-Path: <kvm+bounces-66724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7BDCE50D2
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 14:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1A61300D166
	for <lists+kvm@lfdr.de>; Sun, 28 Dec 2025 13:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC8026056C;
	Sun, 28 Dec 2025 13:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="fQuozb4s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20854F9C0
	for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766929610; cv=none; b=hLLQGsGWf5k/N8p0oyWXKyZkYHZjy8i82Db4YUUFBDRxPKj3VsBpGWefV33OJWqfvS+gnW1bGl3X8fzmDfHuBjWEyi61fUuoWgBRfplRGCUANjat9eFtt+wOsuAxZVLA7MSsUxpEKwedHMdyMMbqM+L0pwyjJmiKCPTzhxxs9+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766929610; c=relaxed/simple;
	bh=qz2EpIgyf//vEb2FjkXoztZUuK4dLJ2baPo7y+61YYk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q63xCwpdUt2P6PjfenOUYH9G/kbbmSz8GbqN6VfXJi5mc260qlJ7nIP7mw2YyD+LD+7p9uTuKuVwmaGL8qQKoVCe1N/948QxL3JopQOil0n+IDiV2K5MY7dY3dvdlWEAEMhA+5xG32MeBmMM0pA04/b3jzfAva65NXRak0A3Ljk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=fQuozb4s; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b7633027cb2so1504975966b.1
        for <kvm@vger.kernel.org>; Sun, 28 Dec 2025 05:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1766929605; x=1767534405; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QmyVj6XGPrQWTnO1cmBaHu2RF/dDjLmm14QhvwLLo4=;
        b=fQuozb4sCSNgGu/oEoN0IqWVIHkN+aNOo2eVeSrhZvRzMo4es/foZd18ZEA1/MDxhV
         VZO/35dwCsNtiZCYk/Aj3qF3WXiXuhWKGts9UOMYo/+VVvmT5CgAqDE4RVg/vDqsnij6
         ZNRWh+QYWSxdryYfoBldV2vzPSqq1Jn0TnqyquEAoEzEtFGfXGdSKHdxI2rH+LOG+HH8
         n6pNr/bZQDNerQbEsfB1onlqs2RSKe17vesemGslox7TxshWGAHw1AN47K85wAGAeehM
         bCIBC23GpE6D0YEOf22H//Ua9OsebhGBU6bXDjMixO2WFlafHN4bHGnFdysxutIDioL/
         4wZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766929605; x=1767534405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0QmyVj6XGPrQWTnO1cmBaHu2RF/dDjLmm14QhvwLLo4=;
        b=oSQQXQ/FcWiIwn7foRrRuDBUR5BjEPK43XxJhBLX54gKupfgDV9yRZ8eBGegEZhpdT
         cpyRI+txVgHf2SNkRBibQlSziqpVLmjwrQHN0iv/iS9D5Sq9dxvOXeuIXYK6fCHFysjY
         kzL/CK7Aaomgah4fi6HMksIVtFwzXPZExzyw19ZE/RIVlo2qQSkc7R/6yz2qcszA6Cxh
         HkYl/6WXj4DevX5SjZQRwrAGjGb83OCbs2aEV0wubzMrLeuQ2krKQTKG/6jeQZ0VzYFU
         SGMMMiS7zwHy1zYQYGkNJ1zyy57LLiovYQxUFYsgvGKbUWcmxDazQw+qgww3CButvo9I
         cKVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRdOhd22cWsNKjMtysGvoRdrOKGsy+qNRJoGRtRsA4Q4dFIgu51RyoEit40za5dGVWa2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgPLnYcjjwUGGdCkjQgyZz3ksSpzZttsBxExCydXXU8IU13joc
	sng1B8B/1iKC7miFT4NxXY9MJv+lFk10GPBKqfddHNVnPhgCAOz6M7Uz4JjQd//vMq5+gUw8KOQ
	r5JxRWk3ODUGdG7wIOjNl2KwLF81CbQRARIt7Jo5YnA==
X-Gm-Gg: AY/fxX43XJjY21F1HkGTaSbsReESnQvwpQn2hJSi4IdX0LprpeENlgYSp06xilODzLh
	c5Y+GPBIVSlEmJN4lWYD3WbFouUxlDsgXl10kEiX4EKrd9x6fQCi5ay/+NT9UMQ1W+890NgAaMJ
	V9M1Mha0riEO6aBwxI08JFsiu0ZTI55RBcVJDDRC1lIljrd7n5eE53P37nOOtAZFjgrTAaEL1k6
	TQvg7NfqZTBDDIcQzHp3n9fVd5oU6tS2zs3/ULFZQBwhW2b1fMcSlk3olt7lDyw6wEWLAyM53hc
	JzHN3RXHlfpxezziuqcv2qN+t/k=
X-Google-Smtp-Source: AGHT+IEdC99j0nCePFhLwmZTnJWkgU+x4D2zxqHSfh/qzCdOT5Mo/lWPNRvdETHSYcJYPuMj/crY4IJKLKDSNORCHKs=
X-Received: by 2002:a17:907:6e9f:b0:b7c:e4e9:b13f with SMTP id
 a640c23a62f3a-b803717d9b0mr3040706066b.39.1766929605212; Sun, 28 Dec 2025
 05:46:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250523101932.1594077-1-cleger@rivosinc.com> <20250523101932.1594077-7-cleger@rivosinc.com>
 <38ce44c1-08cf-4e3f-8ade-20da224f529c@iscas.ac.cn>
In-Reply-To: <38ce44c1-08cf-4e3f-8ade-20da224f529c@iscas.ac.cn>
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Date: Sun, 28 Dec 2025 14:46:34 +0100
X-Gm-Features: AQt7F2p1_7ko8w_PwIifz2AmUk0sbTmFCv2I3iETmZt8Ofoon78QtnnXQgqC8zk
Message-ID: <CADGDLFjttq5knxRpqktHVEbwTWEAwgJ-p50ajV=Q8b31cZvJxA@mail.gmail.com>
Subject: Re: [PATCH v8 06/14] riscv: misaligned: request misaligned exception
 from SBI
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Deepak Gupta <debug@rivosinc.com>, Charlie Jenkins <charlie@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vivian,

At the time vector emulation was added in OpenSBI, I asked Nylon if it
was going to be backported:
https://lore.kernel.org/opensbi/CAHCEehJ7JDhhF_C8jngHezfBJjWp+0m6Gzvsphk+BL=
MvyYdEXA@mail.gmail.com/

Seems like it wasn't backported :) So yeah, it definitely needs to be
added to the kernel misaligned handling code.

Thanks,

Cl=C3=A9ment

On Thu, Dec 25, 2025 at 11:14=E2=80=AFAM Vivian Wang <wangruikang@iscas.ac.=
cn> wrote:
>
> Hi Cl=C3=A9ment and riscv maintainers:
>
> On 5/23/25 18:19, Cl=C3=A9ment L=C3=A9ger wrote:
> > Now that the kernel can handle misaligned accesses in S-mode, request
> > misaligned access exception delegation from SBI. This uses the FWFT SBI
> > extension defined in SBI version 3.0.
> >
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <cleger@rivosinc.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  arch/riscv/include/asm/cpufeature.h        |  3 +-
> >  arch/riscv/kernel/traps_misaligned.c       | 71 +++++++++++++++++++++-
> >  arch/riscv/kernel/unaligned_access_speed.c |  8 ++-
> >  3 files changed, 77 insertions(+), 5 deletions(-)
>
> This causes a regression on platforms where vector misaligned access can
> be emulated with OpenSBI (since OpenSBI commit c2acc5e ("lib:
> sbi_misaligned_ldst: Add handling of vector load/store"), because this
> disables that with FWFT. This means that vector misaligned loads and
> stores that were emulated instead get a SIGBUS.
>
> This happens on Sophgo SG2044 and SpacemiT K1. Notably this causes these
> platforms to fail Zicclsm which stipulates that misaligned vector memory
> accesses succeed if vector instructions are available at all [1].
>
> I'm not very certain why vector emulation support was omitted in this
> series. Should we perhaps add the same emulation support to Linux as
> well for the sake of these kind of platforms?
>
> Thanks,
> Vivian "dramforever" Wang
>
> [1]: https://github.com/riscv/riscv-profiles/issues/58
>

