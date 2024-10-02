Return-Path: <kvm+bounces-27822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 665F898E3D2
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 22:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC554B23D95
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 20:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29C5216A17;
	Wed,  2 Oct 2024 20:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F6YCI9X7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28CE1946A0
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 20:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727899337; cv=none; b=Er3+j+Kl4yMjwdqRvbMXj1rWfrmkzV2j281bmQNmtlMGJXjupDH78tjTCdDrd48M8HsrYBZ9BXgll/9GQ+zxrckixPA8knZnTYYg9QEq/hHsXTbd8zbLaVWu6Hc9E/uHredyYTzMItpbwAH6tiFUhPRdbAVZDsKlVzJZV7MQre4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727899337; c=relaxed/simple;
	bh=26ch3VLdZlgASzApmc+sdmN42sQrSbzi8ri/yXB2hcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YBnfehUnktm+vnQwOrjmTGYtsYDZek4W4MkapUGowN5YTsdcsfSsnGuDNalpwiAOTwOzxReB+Qlwe4mqpZWS5Jyi5GblBOHp5tm2XRNffmg5kiQEIXT+tQG4dGoM1FM0KQrqjhcim3r7KKqorTu/raNEC3TaoqIXtN9nzN/1eB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F6YCI9X7; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5399651d21aso118413e87.3
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2024 13:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727899333; x=1728504133; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=felyUMZ1epn3qYN0qQZjWDzIrXK7nsXRUmOCiXehfgQ=;
        b=F6YCI9X7JvHDccGLljtWDsml9Fk9JCWOzOadJ7FR4STve1GUn+OxFA8fjopuxE+sUq
         txxI1BfH7pszy/lcBFHCjG49xAtMEfaLpDLNwzH7SKQrL7PVi7lu/XK1wouZaimjUt6q
         i3Uy4CXRrFl3rrXYlddf8CvoVkXLjopVEcRqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727899333; x=1728504133;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=felyUMZ1epn3qYN0qQZjWDzIrXK7nsXRUmOCiXehfgQ=;
        b=lyF6vNQkrx+s2Zy4ScsseMEOvMM3eyE8aJ9sjMrFS5yYLFBKynm6uM9tF5mIrZTMH5
         K7ISCKZ21qVJu94JTIoHIdimCGcU2bBo7qtvMEOuU018/ANRtDuCSE3xjkkuZqdthJNy
         maT9yIoxQzYeWPPg/QWS/xF5xWrneFANZw9p7Qk5RnQfMR3K6ZfkmFZwn4RGxo95k173
         wnp/tMfZQn5q9rKuvajQc10cJsLgHo/aEGgbImdiGUFgUgsvPun+vudK6oO4ZSPFDgFL
         +XYYDpXEbzh6XHOz0ePXtjyAtu7tBbJp5XWfTmE8POr09US4lecRjscclhCJrLh772se
         KBvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHdb10FTJYA9thozrUlTJnWw5P/3TplZZ4+4vnEk0V1CRp9fem4zG+dkeVuhlKRDLqU90=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkKgpt573rZlAFIE5kY+2GwlHzVJjQUDlGEWcFRDWSVFJBhbYa
	fU+rM9GGNhml/ioEGh1NtTgTPcCnEIBss/66TFfmQ2g+CLQ8TLlf5DNeeRUSkqijJZLFk6m2uW7
	+qliOwA==
X-Google-Smtp-Source: AGHT+IGdH4AHai3EimNffnKXbhEls73vKL0Rjz/dqpkUcdzbRYoADVzY8CTMH01UQJ2WFUi6cAG0gA==
X-Received: by 2002:a05:6512:158d:b0:533:45dc:d2f0 with SMTP id 2adb3069b0e04-539a079e82bmr2297980e87.46.1727899332809;
        Wed, 02 Oct 2024 13:02:12 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-538a0439a72sm2014766e87.202.2024.10.02.13.02.09
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 13:02:09 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5399651d21aso118349e87.3
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2024 13:02:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUvvXoiHWKfKSvuc9KTYw5CJ/z2/QSSX+/YQKJbtLXWLoGg97JWYGE910k5ycyVZhtMpV0=@vger.kernel.org
X-Received: by 2002:a05:6512:e9e:b0:535:6795:301a with SMTP id
 2adb3069b0e04-539a079eb59mr2506573e87.47.1727899328912; Wed, 02 Oct 2024
 13:02:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240925150059.3955569-30-ardb+git@google.com>
 <20240925150059.3955569-55-ardb+git@google.com> <99446363-152f-43a8-8b74-26f0d883a364@zytor.com>
 <CAMj1kXG7ZELM8D7Ft3H+dD5BHqENjY9eQ9kzsq2FzTgP5+2W3A@mail.gmail.com>
In-Reply-To: <CAMj1kXG7ZELM8D7Ft3H+dD5BHqENjY9eQ9kzsq2FzTgP5+2W3A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Oct 2024 13:01:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj0HG2M1JgoN-zdCwFSW=N7j5iMB0RR90aftTS3oqwKTg@mail.gmail.com>
Message-ID: <CAHk-=wj0HG2M1JgoN-zdCwFSW=N7j5iMB0RR90aftTS3oqwKTg@mail.gmail.com>
Subject: Re: [RFC PATCH 25/28] x86: Use PIE codegen for the core kernel
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb+git@google.com>, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Uros Bizjak <ubizjak@gmail.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@linux.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, 
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

On Wed, 2 Oct 2024 at 08:31, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> I guess you are referring to the use of a GOT? That is a valid
> concern, but it does not apply here. With hidden visibility and
> compiler command line options like -mdirect-access-extern, all emitted
> symbol references are direct.

I absolutely hate GOT entries. We definitely shouldn't ever do
anything that causes them on x86-64.

I'd much rather just do boot-time relocation, and I don't think the
"we run code at a different location than we told the linker" is an
arghument against it.

Please, let's make sure we never have any of the global offset table horror.

Yes, yes, you can't avoid them on other architectures.

That said, doing changes like changing "mov $sym" to "lea sym(%rip)" I
feel are a complete no-brainer and should be done regardless of any
other code generation issues.

Let's not do relocation for no good reason.

             Linus

