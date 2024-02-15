Return-Path: <kvm+bounces-8819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1948C856D85
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 20:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4D5628EBE8
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8FF913A254;
	Thu, 15 Feb 2024 19:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FLQMcszJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F212913A247
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 19:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708024686; cv=none; b=TkvT5r5JV16Zx7URPV0l/8OuP4tkCGd56dtbu+rhBLegv09NX6vyFwVkJ1hAg53aBS+1iJsellqjpFzYV2N/rSU7D5+yuQP7ty8pb5PcMrIRsb1M4pZuHVjzfq7y3NoaEw8mCHgYMQkz0iKc2HVgP/CbTiracHzVxw7RDRiq6Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708024686; c=relaxed/simple;
	bh=o3id02ShTaAJP/qkPl05c1vDDNiTkgunU+ojuRRB+Nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q2ETdp750bvrAeNHm0UwkYL+hv3c+ASgSOtWmkO7/YLIW91fTB/joRKbnHyuDeGzBWv4kzopy6EUk2YWzhrS8PPuSl/eSwVF+HZv1gqsqV989g54jz8t7AD4CNSRu5dZhof7zdquSqWYXxBNzYJsZqwAxOhCEzZswqKU4FlC8FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FLQMcszJ; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-563d56ee65cso429564a12.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 11:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1708024683; x=1708629483; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KITCyNjL2swPBA9ngw1xqwUThE0CIbT81b+KJugWYzs=;
        b=FLQMcszJSnXEOxj9lap5AlQXdTlVLiuUJ2FR4jzmrn4Cpsv30SbyxE7dEVXF+D9RSn
         O5YuNGMXWB/l965R7J3GJBwqS6sz0B2TPeumnz4JShSRXLJ5vpq9AT9smcf/oB4BHSoN
         sx+ZjRnp3CnGGadIqCuaN+cXLLU6zuGid7Dy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708024683; x=1708629483;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KITCyNjL2swPBA9ngw1xqwUThE0CIbT81b+KJugWYzs=;
        b=swpVgkua4vZ8gKAjeNh1V+S9hHTsSk7lJ8OYlkQRwysxhk0SSFSZEtpmRuGx1az91e
         KD4HNRllM/XKYSL2soSe/x7XnukuWzTuqjzuA7eipxfj44GOUo9E9TYHpgFWCUbnsIJ0
         sA9aA82Kwzwf0qgipAs290CAHfSMfVQXqUPgRd3NYoJ+Ek78bopVEAc9faTQTCc5VS/o
         EdbKxObfur+B/+ArhyIyHkbGQQLH8ePVeEixv5TLO1sW4L3/3QKri1tzamXJNbdvBUSA
         D0krDdkoTnP6ORR3Ebky95M0yg218/XzyYBpTtk5IsEF66PeVvQ7k9PRA9l3ZmTQ731q
         /q7A==
X-Forwarded-Encrypted: i=1; AJvYcCUK7SA9umrDsm03vZHWT6SJNZrnc9JK0PncWI2DGu1+RYJNJbJn8msPAlKfH+gEaTYwFOvgMLl51wxVNU9DmLQb3o7D
X-Gm-Message-State: AOJu0Yxe8dr+eQmy1ONvH2HmxqPgJ+4PzpErT9QoYlslij4ByHNxfRqp
	obJuiODvERy0wxgPRz3OrF0GzNJ3CnpoCPy2M3wivKUIa/JVKKTem5hlWy/B74ggLz9hbUpR7s+
	uAeY=
X-Google-Smtp-Source: AGHT+IETfR5pWg+cU5XAt5VxCiX7fy2mdkUjfQrZlpwF+OpsGvOZkOTdpp1zd2DXO9yMtT85KEwsRA==
X-Received: by 2002:a17:906:1b59:b0:a38:7541:36f6 with SMTP id p25-20020a1709061b5900b00a38754136f6mr2010031ejg.21.1708024683028;
        Thu, 15 Feb 2024 11:18:03 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id vo6-20020a170907a80600b00a3cf8cb80c1sm829799ejc.156.2024.02.15.11.18.01
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 11:18:01 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-55ee686b5d5so1636104a12.0
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 11:18:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWWjDNBe9EWMk/pI71Kdbv52j2Cndx3cx8NwL/RNjIuXPmOchG1l0MkXkVf25epWi7FFG5/So8CgxfifTDLmehDGWeo
X-Received: by 2002:aa7:c31a:0:b0:55f:d95c:923 with SMTP id
 l26-20020aa7c31a000000b0055fd95c0923mr2173374edq.25.1708024681342; Thu, 15
 Feb 2024 11:18:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com>
 <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
 <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
 <CAHk-=wiRQKkgUSRsLHNkgi3M4M-mwPq+9-RST=neGibMR=ubUw@mail.gmail.com>
 <CAHk-=wh2LQtWKNpV-+0+saW0+6zvQdK6vd+5k1yOEp_H_HWxzQ@mail.gmail.com>
 <Zc3NvWhOK//UwyJe@tucnak> <CAHk-=wiar+J2t6C5k6T8hZXGu0HDj3ZjH9bNGFBkkQOHj4Xkog@mail.gmail.com>
In-Reply-To: <CAHk-=wiar+J2t6C5k6T8hZXGu0HDj3ZjH9bNGFBkkQOHj4Xkog@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Feb 2024 11:17:44 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjLFrbAVq6bxjGk+cAuafRgW8-6fxjsWzdxngM-fy_cew@mail.gmail.com>
Message-ID: <CAHk-=wjLFrbAVq6bxjGk+cAuafRgW8-6fxjsWzdxngM-fy_cew@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: Jakub Jelinek <jakub@redhat.com>
Cc: Uros Bizjak <ubizjak@gmail.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Sean Christopherson <seanjc@google.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Feb 2024 at 10:25, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, 15 Feb 2024 at 00:39, Jakub Jelinek <jakub@redhat.com> wrote:
> >
> > Can it be guarded with
> > #if GCC_VERSION < 140100
>
> Ack. I'll update the workaround to do that, and add the new and
> improved bugzilla pointer.

.. and I also followed your suggestion to just consider any gcc-14
snapshots as fixed. That seemed safe, considering that in practice the
actual bug that Sean reported seems to not actually trigger with any
gcc version 12.1+ as per your bisect (and my minimal testing).

HOWEVER, when I was working through this, I noted that the *other*
part of the workaround (the "missing volatile") doesn't seem to have
been backported as aggressively.

IOW, I find that "Mark asm goto with outputs as volatile" in the
gcc-12 and gcc-13 branches, but not in gcc-11.

So I did end up making the default "asm_goto_output()" macro always
use "asm volatile goto()", so that we don't have to worry about the
other gcc issue.

End result: the extra empty asm barrier is now dependent on gcc
version in my tree, but the manual addition of 'volatile' is
unconditional.

Because it looks to me like gcc-11.5 will have your fix for the pseudo
ordering, but not Andrew Pinski's fix for missing a volatile.

Anyway, since the version dependencies were complex enough, I ended up
going with putting that logic in our Kconfig files, rather than making
the gcc-specific header file an ugly mess of #if's.

Our Kconfig files are pretty much designed for having complicated
configuration dependencies, so it ends up being quite natural there:

  config GCC_ASM_GOTO_OUTPUT_WORKAROUND
        bool
        depends on CC_IS_GCC && CC_HAS_ASM_GOTO_OUTPUT
        # Fixed in GCC 14.1, 13.3, 12.4 and 11.5
        # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921
        default y if GCC_VERSION < 110500
        default y if GCC_VERSION >= 120000 && GCC_VERSION < 120400
        default y if GCC_VERSION >= 130000 && GCC_VERSION < 130300

and having those kinds of horrid expressions as preprocessor code
included in every single compilation unit seemed just nasty.

              Linus

