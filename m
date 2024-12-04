Return-Path: <kvm+bounces-33058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 201719E430E
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 19:11:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31813164AA2
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 18:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B5123919F;
	Wed,  4 Dec 2024 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bQgvKdKt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296E5239188
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733335878; cv=none; b=IE6ecyffI3+5uG1vSN8KtKPAcdGcWc15aKQiJ/Hnyuq9w8Y/aKIVLMbtICzBRY8Rp1daZmt/O3ZoSkLzQTN6dxxDvQXbzJxEkkIQboLUlVeYq/nbiiEmaVHEDHU+ftPBiXOXQHH/seSMPekW+sJKa88STXvQnOj0KXr4HrKoilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733335878; c=relaxed/simple;
	bh=X6BEDT6fDm7D7Y0nWW+xKECtJAeRFs5IERZbxKQu3YA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=huemsts0zhwiraE/sUH26IOXX++ruYo3OwVNB1B5igmEfTSjinlAD9olO72T2PL2b9O0ImVyOmjxD7Vbws1rNN9Hrt9fHf5DiGdyqCOeUpJA56WcuahKSWV1orNGnJOjkNBfdhlWXYNd/iVyXASHW23FNPWbNKOVTQrV554czsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bQgvKdKt; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9ec267b879so114152466b.2
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 10:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1733335874; x=1733940674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsHq11mNN/cIeDGdLbelslfoGN88pEnsDmEEyawNX0M=;
        b=bQgvKdKtmQIh+0ohEA8WTbSZF+b1Byo5G2ZaIHDe25BE/UeVd4MUhqGWoNPz2rxM83
         4uJm+/QBMFxlYu9hbemGi16ymWc7Q1NYJtGXJmG9XDLMFYd5nUQNqewzVL6h9ROiJmpz
         TlS5PyQYbEKMMsr1K1yBKxC7cJtyJsgcbzs6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733335874; x=1733940674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UsHq11mNN/cIeDGdLbelslfoGN88pEnsDmEEyawNX0M=;
        b=LMgnOKzqW8yPTBGC37G8rgAuq0yGiFehBhBdVQp4/8g0jTq9CuvTxlfxCNifEFkO4e
         sGezsfxb9WWlhzvZjMKfGsoQLH0sNckNG/ZZqbVJ3x+Zx0Uusts3XjA+PAoRQh4PcbR+
         ksxEt7etnxkzhf7CMSnkgnOX4h+q2BtL5bbgFNkjTvpdFZW40iLypcgSg2UIL1snfsgK
         nner/ZEByj2HbEiKMXwuVeMNdMhNrAJoPHeEa7kgjiHJ35tLXGjXvmM39nni5H39Wfro
         DdEJCz0yuskQ3QSvWEQHuD0BNMUiFR5hZwbos7tIPW+KNR6zoH459pwEr6zZ7tmbtEf1
         Bi9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVXavCIWT/i/108h1uuZB8O4Z9+eQapaY+tLMuCKfpo6Y1nPm1G4d23BkAymfQKzTROtNk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0bHpVowrNCDVa5SFFYXoHA07uXouvDWP7c6zi5LUITmMEa/Ku
	t6yNg8saRDpHs7TjiHGxprkDgOUZErhGwztco0QmJRdZs8TIBunL1dTpXPqtHgDu8D7sIrdEF94
	zfVs=
X-Gm-Gg: ASbGncvhyfg/HKCgFrL4umArO2hrqTs0bJ2Z0Bcl/lu8YzXNhItXoRGUnclHdJ25RtP
	oA/jE6RD3AHudgz8kLLWUUTLPTDtsFQlUz0SK/P6nQUy+wZBgwubFpQ6+lkENvHWXJbSyPTWICG
	6kAX3WgWRoWakSvjaZhzWuoQWie+vU5SOYQgxyO+YgngunaTJzoCzqo9WnWdF6srjqr5ErUsH6M
	RK4eegAsHsP1KefsHzMf3a3aRpTxfijwxJwVQ0w4OpsRsewZbVv8eCRcNuKNhPXf4MRvCmBjwAM
	RtrCW9zKd+I/JJDfxZ91JxXh
X-Google-Smtp-Source: AGHT+IFocnDbO6YHvudDVpw3TyRMqWCpTHkMJ4pVwwYFsfLz6TOU+GiCuw3enVvZ85LfrZi+HtAAlQ==
X-Received: by 2002:a17:906:23e9:b0:a9a:f82:7712 with SMTP id a640c23a62f3a-aa5f7f57cbfmr721688066b.52.1733335874166;
        Wed, 04 Dec 2024 10:11:14 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa599955e08sm760405766b.194.2024.12.04.10.11.12
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 10:11:12 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d0e75dd846so5385910a12.3
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 10:11:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUJUGVOe8z7gFT3b7toRnHXg5UpeAHkqkdLSuXKCUZNGOvO58v91Kmkaxb3FXBPja+Ff7Y=@vger.kernel.org
X-Received: by 2002:a17:906:3d22:b0:aa5:392a:f5a7 with SMTP id
 a640c23a62f3a-aa5f7f57ccamr725005966b.57.1733335871860; Wed, 04 Dec 2024
 10:11:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-10-arnd@kernel.org>
In-Reply-To: <20241204103042.1904639-10-arnd@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Dec 2024 10:10:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
Message-ID: <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Davide Ciminaghi <ciminaghi@gnudd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

  "On second thought , let=E2=80=99s not go to x86-64 microarchitectural
levels. =E2=80=98Tis a silly place"

On Wed, 4 Dec 2024 at 02:31, Arnd Bergmann <arnd@kernel.org> wrote:
>
> To allow reliably building a kernel for either the oldest x86-64
> CPUs or a more recent level, add three separate options for
> v1, v2 and v3 of the architecture as defined by gcc and clang
> and make them all turn on CONFIG_GENERIC_CPU.

The whole "v2", "v3", "v4" etc naming seems to be some crazy glibc
artifact and is stupid and needs to die.

It has no relevance to anything. Please do *not* introduce that
mind-fart into the kernel sources.

I have no idea who came up with the "microarchitecture levels"
garbage, but as far as I can tell, it's entirely unofficial, and it's
a completely broken model.

There is a very real model for microarchitectural features, and it's
the CPUID bits. Trying to linearize those bits is technically wrong,
since these things simply aren't some kind of linear progression.

And worse, it's a "simplification" that literally adds complexity. Now
instead of asking "does this CPU support the cmpxchgb16 instruction?",
the question instead becomes one of "what the hell does 'v3' mean
again?"

So no. We are *NOT* introducing that idiocy in the kernel.

                Linus

