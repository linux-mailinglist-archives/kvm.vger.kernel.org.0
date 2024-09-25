Return-Path: <kvm+bounces-27469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4414798652D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 18:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 461241C2533C
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 16:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1DA712AAC6;
	Wed, 25 Sep 2024 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fKKlZtPp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E31A81AD2
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727282877; cv=none; b=rwviTMBy3OhvePcBBT4VBdVMsMXp9D0NHue5s5T3NHdGQKewvu8KbO5e8cUVv/2NMQNdN5jfXs5qOPWbClWeMyLJVRLEoB5oBy2GDQsuU6CnxVf1YVxBk2W4/rQ+O32STRjtWpn/gQ+LihI2gCxWw5PyhjcdPncR7Fny7ss6Wm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727282877; c=relaxed/simple;
	bh=/t+YSp2gvbsBW9hsAIIEsn2fOHY2XQVupxHXFI22op4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ifcdq8HZGIy3PIsSPBmAQ3ckOn2ZUKfMjhlpI4SMKaoq/Z2yv1iNEBK0XpyRgQnVWlXygGImeNDDwKWUe2R8fI0LFCjXBylxH46/DdehIk7cB258LpFKIuwzWkGlWVyttSXPhHMuDBbzkg/+OxMnQLrHakQ7i6+g+KLlGar+0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fKKlZtPp; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a8d29b7edc2so7523466b.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 09:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727282873; x=1727887673; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nj8+qG2S/Bk0hHBrSluJoVQqRkgSfLVqxLrwhmmQqfQ=;
        b=fKKlZtPpLtCUB9mT5iXgGBgaaOYEJSHEIp/nc5Jo4nW1F5quHzM9fn/97I+e1dfV4+
         H/7r937sNSbEBimJo7v2XP4gjrVhHfftfrK1cmpCPM6avy0s4PjQWWNj3Nt8pAz78kcQ
         sAz8o+mk9xpOnezyvwUu0/Qv2OAR+NgniuNe0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727282873; x=1727887673;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nj8+qG2S/Bk0hHBrSluJoVQqRkgSfLVqxLrwhmmQqfQ=;
        b=J/jmtgDL9AQKTlQQzd/rPzQ8VoLXiesDKYQJ/OH3FDEbSIwvqGtu1YZ4mU+6xZoE30
         USaYMgbAA31XabOWEcsiNLSdkCQvpdF8cRDVBauA8lCYe7eSHJJVulOqToq+Vmodj5PX
         H96+FFbeMHXchpKpPYuDBmrFSiP4/68fUz9B+aTH9vNF5am/R8qktCItQWHTp/pOJs0M
         c+5jbOX907UG53HOlZLpIevbJo/jXmcFraO/lfLQsSX7GVFkmm59RXjhPc7bIeK1rcbe
         BvG90CcYtivPMzXR7G2GEkwOILUZjQj+onI0gLzIcefVIGnzMHZdAUb6T6SlUnBZADA7
         uGYw==
X-Forwarded-Encrypted: i=1; AJvYcCXFIzk4GUPPgXvPwYi6Sqlxs8+WuNyZr2Eyew1km33PB4dz8zjQAhkEFzw9ZVAzI4NDVVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPRWvrTsNAGf/6aYyW2wuGo9wtNE0xEWzEhxoJM2NizgKUoDNo
	jFAlHsSHsHId0SxVHJoEOiqRa9Igs95uJ+Qgn9UUCjhJdigGRV08uR1vvi3InEdDNixWec4W4nR
	I4b+EWA==
X-Google-Smtp-Source: AGHT+IHwvjowZvBC2eEFcdsnDO2fVMyfeY0TmWtPZ+krXI/4Sznf6TdYkFpEfzmcSfJ7YewifFQQUg==
X-Received: by 2002:a17:907:7207:b0:a86:6da9:72f4 with SMTP id a640c23a62f3a-a93a036a910mr380631566b.17.1727282873407;
        Wed, 25 Sep 2024 09:47:53 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9392f34291sm234804066b.14.2024.09.25.09.47.52
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2024 09:47:52 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-37ccd50faafso208852f8f.3
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 09:47:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW568mGaxMsD6q36W6dqQZda89qfQT8KBNq15Q/eYekiFP+cn1MGCZ6D8mn/Scz/Uvy1zE=@vger.kernel.org
X-Received: by 2002:a17:906:f5a9:b0:a86:9d39:a2a with SMTP id
 a640c23a62f3a-a93a0330c37mr309689066b.8.1727282382886; Wed, 25 Sep 2024
 09:39:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240925150059.3955569-30-ardb+git@google.com> <20240925150059.3955569-44-ardb+git@google.com>
In-Reply-To: <20240925150059.3955569-44-ardb+git@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Sep 2024 09:39:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiLYCoGSnqqPq+7fHWgmyf5DpO4SLDJ4kF=EGZVVZOX4A@mail.gmail.com>
Message-ID: <CAHk-=wiLYCoGSnqqPq+7fHWgmyf5DpO4SLDJ4kF=EGZVVZOX4A@mail.gmail.com>
Subject: Re: [RFC PATCH 14/28] x86/rethook: Use RIP-relative reference for
 return address
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
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

On Wed, 25 Sept 2024 at 08:16, Ard Biesheuvel <ardb+git@google.com> wrote:
>
> Instead of pushing an immediate absolute address, which is incompatible
> with PIE codegen or linking, use a LEA instruction to take the address
> into a register.

I don't think you can do this - it corrupts %rdi.

Yes, the code uses  %rdi later, but that's inside the SAVE_REGS_STRING
/ RESTORE_REGS_STRING area.

And we do have special calling conventions that aren't the regular
ones, so %rdi might actually be used elsewhere. For example,
__get_user_X and __put_user_X all have magical calling conventions:
they don't actually use %rdi, but part of the calling convention is
that the unused registers aren't modified.

Of course, I'm not actually sure you can probe those and trigger this
issue, but it all makes me think it's broken.

And it's entirely possible that I'm wrong for some reason, but this
just _looks_ very very wrong to me.

I think you can do this with a "pushq mem" instead, and put the
relocation into the memory location.

                 Linus

