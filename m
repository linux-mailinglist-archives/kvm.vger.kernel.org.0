Return-Path: <kvm+bounces-33097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 637EA9E49C6
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 00:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2077F288615
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 23:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EC4B206F19;
	Wed,  4 Dec 2024 23:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQ6my0+P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66090206F1A
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 23:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733355220; cv=none; b=k3Z1GvonKjMe5CkI6uH3+UPA86hhvhBgWbHEz14xXrL1/Jiuz6KiYXB5mqmAR+8gWw5jwS/kAtizHmAYzCqhQaPGa8xsM0CYlYWLsqoqEFzJwLbqEDqf4k62Hl0df7i9mJEuHeoLPmzbObM8rHrVg3oWpNMHHeE6DZA8O2xCKEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733355220; c=relaxed/simple;
	bh=sZe8DIbzPwMfs/xLDhyn+o7Khr47svgEAlMqJ5RfcI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ng/462XnA02hItCSSnSjkx3wCxaOSz2DXLB2uV+uqUcuW6qyOvdWIE2yXqZGRsn44XqMGAo8wPx+XGlXbwtbir4FmBY6EAie19TL+WiO8XU9Cpy7f356sYod5eNwDdKiSv/ZlyA50NQSpMJQg1tc3a28Tb444DDMvu3/+73zlpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQ6my0+P; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa560a65fd6so59943566b.0
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 15:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1733355217; x=1733960017; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NWC7guZheExcmhaMVwsCPe87jgz0IEzjxPFX8O+PaBg=;
        b=WQ6my0+POj/B26Id5fDFdzhQNxklocPA8f8NRNS+RMrpgcBHoYJ0a6DiaeHvPuIvvK
         Fsi/e6obTC9jcE1SGGpK2XdBo8lB5wFGhmUn5AdkoS604AL8QuhuFfxQ4obwiTtWvmWm
         xzcqGH123jsbZGYIfFeT3nlAYT6mFnnUQAFOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733355217; x=1733960017;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NWC7guZheExcmhaMVwsCPe87jgz0IEzjxPFX8O+PaBg=;
        b=E+GllUlviDwtMOR/YwqOse/25dVqMFxPMaZIScFTFSPA3GRSeVm2vBgU6llc+Oq3b6
         Hj/b9KuWS+f3TPpII42+JvbySyrKbE9oUawYsURjwR7ymvjmKBgJ7O+vXabhbVwOJdPf
         MHmhP6IDu069gTMEdybodHEvZW+rm7kvG2sPfHfLU1DAIulWteP6+P/SjbtFWxqt2RVT
         r41WpUthjuPFvJkdJJ+7/lIitcn/TwR0aTntna+Wilt8wJb9tFdM6yDTLCbzGy+snZhw
         e40M5ijoqruxTZhevZghrS/+yL60xv20/atqsKbwVDLp7rQUVkIzEfVRP5WWdwJy42VE
         mRvw==
X-Forwarded-Encrypted: i=1; AJvYcCXBcRcg+gv/wvSK5pALi0GbdgbgWDO0iG6iWj4ABG6hJr2UDWa72AQ8c1aEFbzzQ1KVH0o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6l2IU2A9jNGd/fkMcUzj1jJ2siGDpdsLK9TIfzmwsdB3DFnnO
	s5FcClNI+cllBmeuhwYmvs+EGuv8OAgDAM2RMz+Ji1fuAtWtiWutVPFvljItdAJm86lZZdt7emJ
	9k7I=
X-Gm-Gg: ASbGncvTzCzd4ss9XoIq2IPhKQfwiSb2yutHNk19nhy/rBdSbom6+Iwv86cIdkyx3ST
	jd95WMHoZZJtyqDSphU80T4+FE4C6N7HqmLOTAKTCY/VMP1dDujWHjDUUn4mK2qgKf7uN+d8pJ0
	3keuFHF+uePhLftsK0TXHce7TZcW8grKSyZVmJU6MIS5zThDWk62hUd5inuR8FPzY73rax/eE4T
	IbxuI4InwSTlAEVtBwmDsPdmQLoswoYrcceRASMnIVXChn2N9mJmPq/hYOIZX67N4DnFz/jt54x
	ptE5JUY4HaDGHKbGmBR3Hjas
X-Google-Smtp-Source: AGHT+IH8fPoVzHWupxAEvtsXhJXMPk/JESCrXNdq1ZaMR6Z0ywKw4u2KzhSj2Wj/rXbDNSr/Zyxc3Q==
X-Received: by 2002:a17:906:1ba2:b0:aa4:e53f:5fbe with SMTP id a640c23a62f3a-aa6218ff8b5mr108817166b.19.1733355216838;
        Wed, 04 Dec 2024 15:33:36 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa625ea256bsm13645166b.75.2024.12.04.15.33.35
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 15:33:36 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d10f713ef0so2654327a12.0
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 15:33:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVaVYuCQ3KApuk0ILSrRxUndvjsZF85sf2WZ2A9J31gO/tVR/jJITHN4T4d8HHEAr4KPJk=@vger.kernel.org
X-Received: by 2002:a17:906:f5a3:b0:aa6:112f:50ba with SMTP id
 a640c23a62f3a-aa62188c9e3mr133284866b.13.1733355215584; Wed, 04 Dec 2024
 15:33:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204103042.1904639-1-arnd@kernel.org> <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com> <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
In-Reply-To: <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Dec 2024 15:33:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
Message-ID: <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Sean Christopherson <seanjc@google.com>, Davide Ciminaghi <ciminaghi@gnudd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Dec 2024 at 11:44, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I guess the other side of it is that the current selection
> between pentium4/core2/k8/bonnell/generic is not much better,
> given that in practice nobody has any of the
> pentium4/core2/k8/bonnell variants any more.

Yeah, I think that whole part of the x86 Kconfig is almost entirely historical.

It's historical also in the sense that a lot of those decisions matter
a whole lot less these days.

The whole CPU tuning issue is happily mostly a thing of the past,
since all modern CPU's do fairly well, and you don't have the crazy
glass jaws of yesteryear with in-order cores and the insane
instruction choice sensitivity of the P4 uarch.

And on our side, we've just also basically turned to much more dynamic
models, with either instruction rewriting or static branches or both.

So I suspect:

> A more radical solution would be to just drop the entire
> menu for 64-bit kernels and always default to "-march=x86_64
> -mtune=generic" and 64 byte L1 cachelines.

would actually be perfectly acceptable. The non-generic choices are
all entirely historical and not really very interesting.

Absolutely nobody sane cares about instruction scheduling for the old P4 cores.

In the bad old 32-bit days, we had real code generation issues with
basic instruction set, ie the whole "some CPU's are P6-class, but
don't actually support the CMOVxx instruction". Those days are gone.

And yes, on x86-64, we still have the whole cmpxchg16b issue, which
really is a slight annoyance. But the emphasis is on "slight" - we
basically have one back for this in the SLAB code, and a couple of
dynamic tests for one particular driver (iommu 128-bit IRTE mode).

So yeah, the cmpxchg16b thing is annoying, but _realistically_ I don't
think we care.

And some day we will forget about it, notice that those (few) AMD
early 64-bit CPU's can't possibly have been working for the last year
or two, and we'll finally just kill that code, but in the meantime the
cost of maintaining it is so slight that it's not worth actively going
out to kill it.

I do think that the *one* option we might have is "optimize for the
current CPU" for people who just want to build their own kernel for
their own machine. That's a nice easy choice to give people, and
'-march=native' is kind of simple to use.

Will that work when you cross-compile? No. Do we care? Also no. It's
basically a simple "you want to optimize for your own local machine"
switch.

Maybe that could replace some of the 32-bit choices too?

             Linus

