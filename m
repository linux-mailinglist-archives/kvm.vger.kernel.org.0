Return-Path: <kvm+bounces-28024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C17991B7E
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 02:07:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D411C2830DB
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 00:07:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA582F2E;
	Sun,  6 Oct 2024 00:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YQC/QiF5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3338923B0
	for <kvm@vger.kernel.org>; Sun,  6 Oct 2024 00:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728173256; cv=none; b=YN9eqvnOBUPO5acmiBXqX78XvHGrbivvsfDG05PXTL/bV0uKBn/rlvjTGZtg79rQAInyh5FtLpZgg5ZGE77HSRm7My15UlzMRmcrSXrr5Rqu5gQCY/Ew1GdQcc8jDORpBG3U08kWOywHPGP/ITYPH5HX5QsBam22qEXROEZ75IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728173256; c=relaxed/simple;
	bh=7PhV7mSmrjXdm322I5AhDI6uiC32DXT2Ek81VrbJ7rA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V8DxSxVDyFqygjJvg4mRVwdeAzOnZpbkwqbgtteYGShXHe9lDwkMi0q4GCEMGMil15fWO5jbFH9htiXLx/TLvs0XKZLRJ+ZOSuDtHwcBPqyoaMQeybtrflHIkD+weTOcbuMGU97wZ0dXu3Xe/UzyyVGpSbYrKJpSJjnJTv0xLB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YQC/QiF5; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8d4979b843so447452666b.3
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 17:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1728173253; x=1728778053; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zwWtZnU6O3CUnR/7Ge8+NpuQOrJwSLSqT8+8zcDG8JI=;
        b=YQC/QiF5y1xIr8EIQO1MbZoC5RfUGS/schUsJs7jQGJqVOfO7AKf1ELVgJo4/5WtXt
         8PWzIQWBfGtOgvyAjrnP4kqVaCm/x5DrTmXa2I/iHsgeMxwclbye68O9Z4AI8nojDK9K
         hIvXjn5TLkJ3mumzp9SVFirP8oyEBO9m75yr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728173253; x=1728778053;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zwWtZnU6O3CUnR/7Ge8+NpuQOrJwSLSqT8+8zcDG8JI=;
        b=kXcd9WsiRsqPVe316f9Un3EidutamfJHVB9G4r9r1upfLVLd/6i8jiqu61x+fou7sC
         wlVwN+SCScTpYDNxuztLpz0vIFlkhosqDFqp4cyvUyUVu17G5/EZXem7AlmbwKPEMOvF
         zNw8jITbzf9HLB6mtrau3I+/l1Wu7xlRvAYEtEONj/xkg5BNoDcdbRy0lgU5BP53MK5F
         43EV00UY+GNGmkDhKYqNF9Dca64WKq6moFeRPFy6gAfTY9PdYL8VZfVsfx8tJ2Xyt+qu
         CqQQF4NfjiKAGaXHs8GtNMyr5yL2LUtAY7w/VRHSAHmwxoUZ9iYQl059Nt3+7uBHObiD
         y1mw==
X-Forwarded-Encrypted: i=1; AJvYcCX6ksV2WeZa3rxztMVeb1HeFoKKHmPIrBC3vcNHheA9rYFM3KhmqFIA8GTs+XrgpvQqBsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYqu2UqhPt+yQQ4Nga3Ek4dD4L0LNvTUolgiZSWLfDxtaHm5VE
	A3F35uc9UrKo+1GnGElHM9PCRmn+45I45QpwUFXC0J/QlhTSxP5sXfBFyItiQ2H2kze8JSEwah4
	v1ihfTg==
X-Google-Smtp-Source: AGHT+IF73XR0rGSQ8hQGN7aWH8S7ODRMBojEtGhx6vRVYEIv/ZgB57+AOvHLfgWKZtdABoLFx6F8RA==
X-Received: by 2002:a17:907:6ea6:b0:a99:3a81:190e with SMTP id a640c23a62f3a-a993a811a16mr351842566b.36.1728173253370;
        Sat, 05 Oct 2024 17:07:33 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a992e7d702bsm188385266b.187.2024.10.05.17.07.32
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Oct 2024 17:07:32 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c88370ad7bso3905150a12.3
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 17:07:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW1qn4/Ld1/KKnuNa24K4jNSXCAaMDQYtvmzuX6IEu7ey8m4fs02pP8W4SIle0HhZIfRBI=@vger.kernel.org
X-Received: by 2002:a17:907:9693:b0:a99:3d93:c8bc with SMTP id
 a640c23a62f3a-a993d93cc22mr339286866b.13.1728172818387; Sat, 05 Oct 2024
 17:00:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240925150059.3955569-30-ardb+git@google.com>
 <20240925150059.3955569-55-ardb+git@google.com> <99446363-152f-43a8-8b74-26f0d883a364@zytor.com>
 <CAMj1kXG7ZELM8D7Ft3H+dD5BHqENjY9eQ9kzsq2FzTgP5+2W3A@mail.gmail.com>
 <CAHk-=wj0HG2M1JgoN-zdCwFSW=N7j5iMB0RR90aftTS3oqwKTg@mail.gmail.com>
 <CAMj1kXEU5RU0i11zqD0433_LMMyNQH2gCoSkU7GeXmaRXGF1Yw@mail.gmail.com>
 <5c7490bb-aa74-427b-849e-c28c343b7409@zytor.com> <CAFULd4Yj9LfTnWFu=c1M7Eh44+XFk0ibwL57r5H7wZjvKZ8yaA@mail.gmail.com>
 <3bbb85ae-8ba5-4777-999f-d20705c386e7@zytor.com>
In-Reply-To: <3bbb85ae-8ba5-4777-999f-d20705c386e7@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Oct 2024 17:00:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgkgnyW2V4gQQTDAOKXGZH0fqN=hApz1LFAE3OC3fhhrQ@mail.gmail.com>
Message-ID: <CAHk-=wgkgnyW2V4gQQTDAOKXGZH0fqN=hApz1LFAE3OC3fhhrQ@mail.gmail.com>
Subject: Re: [RFC PATCH 25/28] x86: Use PIE codegen for the core kernel
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Uros Bizjak <ubizjak@gmail.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ard Biesheuvel <ardb+git@google.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Juergen Gross <jgross@suse.com>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Masahiro Yamada <masahiroy@kernel.org>, Kees Cook <kees@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Keith Packard <keithp@keithp.com>, 
	Justin Stitt <justinstitt@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Kan Liang <kan.liang@linux.intel.com>, linux-doc@vger.kernel.org, 
	linux-pm@vger.kernel.org, kvm@vger.kernel.org, xen-devel@lists.xenproject.org, 
	linux-efi@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-sparse@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sat, 5 Oct 2024 at 16:37, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Sadly, that is not correct; neither gcc nor clang uses lea:

Looking around, this may be intentional. At least according to Agner,
several cores do better at "mov immediate" compared to "lea".

Eg a RIP-relative LEA on Zen 2 gets a throughput of two per cycle, but
a "MOV r,i" gets four. That got fixed in Zen 3 and later, but
apparently Intel had similar issues (Ivy Bridge: 1 LEA per cycle, vs 3
"mov i,r". Haswell is 1:4).

Of course, Agner's tables are good, but not necessarily always the
whole story. There are other instruction tables on the internet (eg
uops.info) with possibly more info.

And in reality, I would expect it to be a complete non-issue with any
OoO engine and real code, because you are very seldom ALU limited
particularly when there aren't any data dependencies.

But a RIP-relative LEA does seem to put a *bit* more pressure on the
core resources, so the compilers are may be right to pick a "mov".

               Linus

