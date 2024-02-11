Return-Path: <kvm+bounces-8513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5852A8508C1
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 12:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B63D282955
	for <lists+kvm@lfdr.de>; Sun, 11 Feb 2024 11:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F5D5A4E0;
	Sun, 11 Feb 2024 11:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bzCE1iNQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CCB39AFA;
	Sun, 11 Feb 2024 11:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707649969; cv=none; b=SBgOR6AY0HcNyESo+wfsyrfOiwW5K7ASsVciGlgVu9DXpWZEkG9rOa3RF/Qq9Xc6ToiuwtC626DCW4IX7rh7q7etxd94Wu8ENOQ4GVF0an+pNi8IStr1s5nGlB/pzHqTAu9Rocxk+vZ9Fypnux/rqkLlkhcHtZzeA1M9g+DhujY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707649969; c=relaxed/simple;
	bh=La7OPyJ0cjFPI7znPBQgdOqzPHNAmopoa+ktdnSjphQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HdPoGvgRlPU5jwRrhOms2I2DBQ3Kualo9DQnEN+h8iiGA/nXHleELeCxlNRt1WH1N1ru+EK+I91L/mF9bCFdi1NXhgmMZAT5GbiFUpNPIz4Xnh3w9J6TC1sEcyGLGTrr+nygT4HmElq0wjTTUpPs24PSFOCge1aHk2TNWN8Ss1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bzCE1iNQ; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5601eb97b29so4276069a12.0;
        Sun, 11 Feb 2024 03:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707649966; x=1708254766; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwWjRV8qTzo9Iole9rjuD+6F66lQhLbrMJXfy7CCdXo=;
        b=bzCE1iNQOJqMravghe6PQYNt31HJn7dKt4oOqnHvso5KOD4a3hiW6qQeVqJISIIe/c
         xIZcXAVoktO+uv6sB6yMpnDdlPYIJ0NKq+wyU4WTGI54SYVsaFeYUxIGmsqMnFpgv5jm
         fVvR6ZfzCKlghU3Yk8Rz7oDUsqkSsm4JEWK4So1i0Ogbeme/lpkUu9I17J9xu4bDDJgC
         GcJZ/q/Heju6dR7cgtAK2pI13CE7XTiH+ztR4UBDaGT+78w8qRsfCmh4xtzevF+oB05S
         79MXNaZulQ4OqjToMU/Y0O7+5s8PsRakTAy0bhtn69AiDKqS/dQ6GUNCe6keJCljsMNd
         cuPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707649966; x=1708254766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vwWjRV8qTzo9Iole9rjuD+6F66lQhLbrMJXfy7CCdXo=;
        b=D6XosIiBuximfPTLN5KnLNpEFEbLCX1JBc9+AMHNSg8HFOGHDJ+ImDlQQ/FVIbM3Tx
         2fSFPDYGbHuuLAGIoYimUC+fCLKiWJXPrMvWYXXIiOtOlsU5H260siO3c5xm6iV/EBr+
         z7F9SbkwOKgZBSkVKEa0saGkocUEf6hvPgKzexT2VjDMtCywDRYwr0JjuIMiH5W4/gF8
         kechyZt3fT6n9d+Bl5tusP+lD4JjZEM9TqpTj3wMdiaGOTMQFc9/mqAEtKEpXf8Jng8U
         kv2zd28lsQeGMk6x70Vcn5NV3ChDZqLeJG6IaV34YZq6nZ4XTEQEQk+LAdNhhdev5GRa
         GRHg==
X-Gm-Message-State: AOJu0YxXL2ARe8bplTvGy5wKGtxH+Nsdkys3J2BdAT4YXatz//e2SWen
	q5rp7h/aDv4HPBSNPHyboh+GdZAM9P9RR5HUMAmsF2i3xTrTKV/Qaqu2e5TyqhOW4VuA+iNzki/
	ZgMz28Hq0hBOCTkgPI1p0waIOTXs=
X-Google-Smtp-Source: AGHT+IEk4NsIkh/bQ8xGrcFwouYTG0zuxY30NGnUhMZWOYnOjkHklsBYif0ToU3kdsPrdEirWzUcRKmCun/TRRo/q4s=
X-Received: by 2002:a05:6402:528d:b0:561:64e6:b5c with SMTP id
 en13-20020a056402528d00b0056164e60b5cmr3499040edb.7.1707649965896; Sun, 11
 Feb 2024 03:12:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240208220604.140859-1-seanjc@google.com> <CAKwvOdk_obRUkD6WQHhS9uoFVe3HrgqH5h+FpqsNNgmj4cmvCQ@mail.gmail.com>
 <DM6PR02MB40587AD6ABBF1814E9CCFA7CB84B2@DM6PR02MB4058.namprd02.prod.outlook.com>
 <CAHk-=wi3p5C1n03UYoQhgVDJbh_0ogCpwbgVGnOdGn6RJ6hnKA@mail.gmail.com>
 <ZcZyWrawr1NUCiQZ@google.com> <CAKwvOdmKaYYxf7vjvPf2vbn-Ly+4=JZ_zf+OcjYOkWCkgyU_kA@mail.gmail.com>
 <CAHk-=wgEABCwu7HkJufpWC=K7u_say8k6Tp9eHvAXFa4DNXgzQ@mail.gmail.com> <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
In-Reply-To: <CAHk-=wgBt9SsYjyHWn1ZH5V0Q7P6thqv_urVCTYqyWNUWSJ6_g@mail.gmail.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Sun, 11 Feb 2024 12:12:37 +0100
Message-ID: <CAFULd4ZUa56KDLXSoYjoQkX0BcJwaipy3ZrEW+0tbi_Lz3FYAw@mail.gmail.com>
Subject: Re: [PATCH] Kconfig: Explicitly disable asm goto w/ outputs on gcc-11
 (and earlier)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Jakub Jelinek <jakub@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, "Andrew Pinski (QUIC)" <quic_apinski@quicinc.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 9, 2024 at 9:39=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, 9 Feb 2024 at 11:01, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > We should also probably get rid of the existing "asm_volatile_goto()"
> > macro name entirely. That name was always pretty horrific, in that it
> > didn't even mark the asm as volatile even in the case where it did
> > anything.
> >
> > So the name of that macro made little sense, and the new workaround
> > should be only for asm goto with outputs. So I'd suggest jmaking a new
> > macro with that name:
> >
> >    #define asm_goto_output(x...)
> >
> > and on gcc use that old workaround, and on clang just make it be a
> > plain "asm goto".
>
> So here's a suggested patch that does this.
>
> It's largely done with "git grep" and "sed -i", plus some manual
> fixups for the (few) cases where we have outputs.
>
> It looks superficially sane to me, and it passed an allmodconfig build
> with gcc, but I'm not going to claim that it is really tested.
>
> Sean? Does this work for the case you noticed?
>
> Basically this gets rid of the old "asm_volatile_goto()" entirely as
> useless, but replaces it with "asm_goto_outputs()" for the places
> where we have outputs.
>
> And then for gcc, it makes those cases
>
>  (a) use "asm volatile goto" to fix the fact that some versions of gcc
> will have missed the "volatile"
>
>  (b) adds that extra empty asm as a second barrier after the "real"
> asm goto statement
>
> That (b) is very much voodoo programming, but it matches the old magic
> barrier thing that Jakub Jelinek suggested for the really *old* gcc
> bug wrt plain (non-output) "asm goto". The underlying bug for _that_
> was fixed long ago:
>
>     http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D58670
>
> We removed that for plain "asm goto" workaround a couple of years ago,
> so "asm_volatile_goto()" has been a no-op since June 2022, but this
> now resurrects that hack for the output case.
>
> I'm not loving it, but Sean seemed to confirm that it fixes the code
> generation problem, so ...
>
> Adding Uros to the cc, since he is both involved with gcc and with the
> previous asm goto workaround removal, so maybe he has other
> suggestions. Uros, see
>
>     https://lore.kernel.org/all/20240208220604.140859-1-seanjc@google.com=
/

I'd suggest the original poster to file a bug report in the GCC
bugzilla. This way, the bug can be properly analysed and eventually
fixed. The detailed instructions are available at
https://gcc.gnu.org/bugs/

> for background.
>
> Also adding Jakub since I'm re-using the hack he suggested for a
> different - but similar - case. He may have strong opinions too, and
> may object to that particular monkey-see-monkey-do voodoo programming.

This big-hammer approach will effectively disable all optimizations
around the asm, and should really be used only as a last resort. As
learned from the PR58670 (linked above), these workarounds can stay in
the kernel forever, and even when the compiler is fixed, there is
little incentive to remove them - developers from the kernel world do
not want to touch them, because "the workaround just works", and
developers from the compiler world do not want to touch them either,
because of unknown hidden consequences of removal.

Please note, that the kernel is a heavy user of asm statements, and in
GCC some forms of asm statements were developed specifically for
kernel use, e.g. CC-output, and asm goto in all of its flavors. They
have little or no use outside the kernel. If the kernel disables all
optimizations around these statements, there actually remain no
real-world testcases of how compiler optimizations interact with asm
statements, and when new optimizations are introduced to the compiler,
asm statemets are left behind (*).

(*) When the GCC compiler nears its release, people start to test it
on their code bases, and the kernel is one of the most important code
bases as far as the compiler is concerned. We count on bugreports from
these tests to fix possible fall-out from new optimizations, and the
big-hammer workaround will just hide the possible problems.

So, I'd suggest at least limit the workaround to known-bad compilers.

Thanks,
Uros.

