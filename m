Return-Path: <kvm+bounces-33062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE6D9E4372
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 352CD166458
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AD21A8F8D;
	Wed,  4 Dec 2024 18:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E4p+d1v2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0402391AC;
	Wed,  4 Dec 2024 18:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733337102; cv=none; b=IYUi73r7UykvVmBVwepjqt/p03gPtEr3AAUhvOp0Pz3Le+sYhdGdezzBEsUUPd9s7DNvIyQiq+9W/pVJLBveGWROB9nZboPtYfJOFXTiXTHQt9jw3m/3buZXilR8Qncf6V9rg0Qb2VuKRUozblLGj/kjkqCTEON7NvtDaurRiQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733337102; c=relaxed/simple;
	bh=MSqRuGMFM0xx57KHFYJ68dNlGmd8TmNYplr3P5UZQFg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F/Jwhsi0ggj8YbEvn2fNlRnRhZTc6VWwM0HludK9gFlxbkNhxsOsT7tjiZPTF5lgtpv0ToEG02+VHEdXV//NRMaTAB/zWGEgAKEPv6rCDsX1/svXj6pzO0BHzFETvIbIEiJ075zgNoVEgaT2w5O03ejnBESy48GHMggnSU/dA88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E4p+d1v2; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa549d9dffdso1496266b.2;
        Wed, 04 Dec 2024 10:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733337099; x=1733941899; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGj4lyZABGpbptmi5AYYQfdcsOzBKvF8wyh41stUwec=;
        b=E4p+d1v2KmYdBZN80Lmjq8v2hJsdEBs/85ovD9wZ6LaBktO/4RCR+B8mLCiEoEzjQ9
         nZRHopJjoRiy6WxfgqgxXkjsvYfFnFEGgQLnBdeT/1n5bjyn0JPKN7x7bp0+XXHaDO6l
         +TXeFI6GLSvBJhyJswqwPkxxG8UINhNZbZqHu2i0T3ZEE+pIHLh0Bo6ba9tiOwnj7y+B
         mh+WGe9nvOAuebGiNPri8J0FrmrBjG0OypUzz16oIZzlEeN/cqw/Gmj67CT+CHjYSP+k
         PDMx60o1FwrFpdue5XDYucrc3m3jOsPa6PyJXvbfUaAt/QSbl2h9KlCwk5MotWXK++oa
         zuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733337099; x=1733941899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hGj4lyZABGpbptmi5AYYQfdcsOzBKvF8wyh41stUwec=;
        b=nimWlD5JN/5Hk+epm/3gUtDslHTZsGz3LkR2qcBxZHll+M56eyi1exkxEelrG6dWVi
         MsZ1CqbHqhZg/omLhHQ1vAeLXS2CShE8my/1vozd7ZcZ5d9UVzm72bcPK95Qj8nPowVq
         8UL6Bvd9oplCPD4PdUpd2tvO8Qf33s5GNnYYBzw18He4BHA5+OjDEKHLpjcdkrNZGG7e
         JgKsg6OgfjnU3oUFky03klC/tp5pupAKjiXdQC/Z1eeDYo9MQtUa73r3F6yzmWJILRjJ
         BySLJSIdYwQrHp97rHwkfd+VprNTV1L6feAGAKZsHOZ33nJCcLbfdiyyQJw6ciEuNu5v
         R85g==
X-Forwarded-Encrypted: i=1; AJvYcCXabWrVBbsRBij4JR7k9u09JyNg3N0M+69yz0LOXEeKty8fMgGPfQWb0exthPwzpRGKmLk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg6Tq2/d8pXiuYb8zueDM1oR2NOU/kEWTpKYLPYr+23TarIV3m
	XTTGedZJBfwlptril0O+Z/O3/UzaqPsMh3zk8K1vZleUPwQ1eDzzm29wmQ2gUm178FB1jsG/mDR
	/HhkPXfLY2JDl5ISeQJVsZaT3SqM=
X-Gm-Gg: ASbGncsVvbPcj3YdfNErZMy20RO0uV2iQbXBDI8KiBF8VvIfCo4OxUScbIHbZmu4xPG
	HL4FoAvtVGCbY3F51kxXusMZXK/RLi08=
X-Google-Smtp-Source: AGHT+IEQeTwmSEzTutR+k2GVtxkmUbI/HF+bbX8DVpLUnXNi6dPM8GqKxdV7NVtvWSsuycrv/pdD9CCfPctxpEJV/28=
X-Received: by 2002:a17:906:3150:b0:aa4:8186:4e93 with SMTP id
 a640c23a62f3a-aa5f7cabf86mr651766666b.1.1733337098594; Wed, 04 Dec 2024
 10:31:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-5-arnd@kernel.org>
In-Reply-To: <20241204103042.1904639-5-arnd@kernel.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 4 Dec 2024 20:31:01 +0200
Message-ID: <CAHp75VcYojM8uYURbaNjquod7n_EJe58Er-57Dw0iaZFc-+i8Q@mail.gmail.com>
Subject: Re: [PATCH 04/11] x86: split CPU selection into 32-bit and 64-bit
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Davide Ciminaghi <ciminaghi@gnudd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 12:31=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The x86 CPU selection menu is confusing for a number of reasons.
> One of them is how it's possible to build a 32-bit kernel for
> a small number of early 64-bit microarchitectures (K8, Core2)

Core 2

It spells with a space starting with a capital letter, some issues of
the spelling below as well.

> but not the regular generic 64-bit target that is the normal
> default.
>
> There is no longer a reason to run 32-bit kernels on production
> 64-bit systems, so simplify the configuration menu by completely
> splitting the two into 32-bit-only and 64-bit-only machines.
>
> Testing generic 32-bit kernels on 64-bit hardware remains
> possible, just not building a 32-bit kernel that requires
> a 64-bit CPU.

> +choice
> +       prompt "x86-64 Processor family"
> +       depends on X86_64
> +       default GENERIC_CPU
> +       help
> +         This is the processor type of your CPU. This information is
> +         used for optimizing purposes. In order to compile a kernel
> +         that can run on all supported x86 CPU types (albeit not
> +         optimally fast), you can specify "Generic-x86-64" here.
> +
> +         Here are the settings recommended for greatest speed:
> +         - "Opteron/Athlon64/Hammer/K8" for all K8 and newer AMD CPUs.
> +         - "Intel P4" for the Pentium 4/Netburst microarchitecture.
> +         - "Core 2/newer Xeon" for all core2 and newer Intel CPUs.

Core 2

> +         - "Intel Atom" for the Atom-microarchitecture CPUs.
> +         - "Generic-x86-64" for a kernel which runs on any x86-64 CPU.
> +
> +         See each option's help text for additional details. If you don'=
t know
> +         what to do, choose "Generic-x86-64".

--=20
With Best Regards,
Andy Shevchenko

