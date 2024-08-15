Return-Path: <kvm+bounces-24324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF92953984
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50374B22DD9
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD4C45948;
	Thu, 15 Aug 2024 17:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yI/0MUIZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5907E1AC8AE
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 17:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723744509; cv=none; b=fk5m0vNxA/d4gIFZs35Ya4ZbEMoHVxWjL5rxUAiS+pqhlD2LMgj9DOFuhPe1YisuTAuX4JPtuk7212y/xRgHQtHOvJYwvtYRyIn7cYI4fOD6U9Oq23Y+VsFtyrBKwi+5gzFYHGXoj8RStvS/eFkmkf3zZfBhx0ekbb+MATVxnpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723744509; c=relaxed/simple;
	bh=Tgkn5j1kYPTVpggK52qKZWgM1t8Gz8XaS4ZES3Zbgow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BeYwFjThMXrXsItflkZS4Wv0zYmDDyzhMoBfhrLBlt0Ac9sqpWwSeIzSz7cuRuaG07rEkDSRbmQBf5pmgqCddWXrzB448xjsKapISw5c1ycCilh06YZetSe2vgJSFVzFn4NgdQIvOFR8bwzVGK2dXNPQJXBN9yBDXv8wUo2rHYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yI/0MUIZ; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a6135eso1837390a12.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 10:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723744505; x=1724349305; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jw42O4Ff2HO8SgGAiIajt3yXkZ/7KaY5K9z1+AIipQg=;
        b=yI/0MUIZjXrcL47RFseT88JBLEyEwloDNZctf5YqgDZHGsQwgz8e7Ezg1SPNpP1LUn
         s7mg3Li7ZaK8FpFEWXG766OiPnjfpSt9qUGkYrKlhH8XOK/lak6HhBsnPjrYd1hKI28i
         A6EvK5nN5zvF24cyHHXEim3n8wvehwGd/bt9kgWT9+usr7gs+CNx7sNJn9GOSvsnUlm2
         QEVzqKYITBrGO98KDeAWusxBkSPGpSEYT4vZqy4SdX1jKlt4r9wqVle0fCYsm5xbnN52
         3zT7kiFkcgFDplmJmGirEnfHg7uPB2I1ZtR59D9WoNth+I+ADqbgUo0bBaMPa8c4U5PR
         tbRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723744505; x=1724349305;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jw42O4Ff2HO8SgGAiIajt3yXkZ/7KaY5K9z1+AIipQg=;
        b=wegV/of8/NjK0Xy6piK6Cc2lHcOr9citPpHajnLFx4bIuHoquNPIIslxC4fs2K2yKO
         zJEAijvV90WPd4D3fKYzTWpI/IceUiR9AXAwGLlIcIh/AMXpfZybSE7uUnOokqcIMimo
         jV1sOJu5ePvf3jGITb7zUqk/dbYcAFnm8oMJgh7phhvUve+P1eIiqsomX4qq/X7gGvxk
         cWtXEOaOU8FFree4WFcj2PKPplAnr5xOGyE65IiH0hoVIVEwhz81rCMdoR2hdGW3xHAE
         uPs9Ig0m7a3AbaGULvpJhR/m7MwefmmUqSfhWR1ycIoHWT7Q1qA+Zx06AiB0dLDUZDE1
         dJIg==
X-Forwarded-Encrypted: i=1; AJvYcCUz+ZndNNYfQUW6XQl0+YtqC4eY9HeDxl4pe/fEeqYj8N2EWIbEPvz+vQcMPkolGwz6uk8M9n3Qa6Fe/fK7+A0ITB6g
X-Gm-Message-State: AOJu0YyVzLmArhgi1rnWY/gY6JKfotIuhbnm12RLoA05Rk+ti9Vpl+D9
	WR0ytBZBE0Bn4DSr4gxAHHDUXGmQkvXCbjCwlfgG+CMFqSN1BNnHcNrvz+x4Ck73yJ9GRCX3yhA
	yZ07zQf87WKnO/exciuLWikkcCW0lQ9FQm5ClkQ==
X-Google-Smtp-Source: AGHT+IHguy3eQzFTIlLDOvSVCF35knPAw3D/fYtKe/Zh9diigsn4hGipWPiAUcKwXmU7/rQ8B7bVjOBUDIwqp2e1n58=
X-Received: by 2002:a05:6402:5cb:b0:5b4:cbba:902a with SMTP id
 4fb4d7f45d1cf-5beb3a3bd84mr3636991a12.4.1723744505269; Thu, 15 Aug 2024
 10:55:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814224132.897098-1-pierrick.bouvier@linaro.org>
 <20240814224132.897098-2-pierrick.bouvier@linaro.org> <CAFEAcA-EAm9mEdGz6m2Y-yxK16TgX6CpxnXc6hW59iAxhXhHtw@mail.gmail.com>
 <Zr3g7lEfteRpNYVC@redhat.com>
In-Reply-To: <Zr3g7lEfteRpNYVC@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 15 Aug 2024 18:54:53 +0100
Message-ID: <CAFEAcA8xMjd2w5tT-sMcHKuKGXbqZg4HtTerNFG=_YpNRVVhxQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] meson: hide tsan related warnings
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org, 
	Beraldo Leal <bleal@redhat.com>, David Hildenbrand <david@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-s390x@nongnu.org, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Richard Henderson <richard.henderson@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Aug 2024 at 12:05, Daniel P. Berrang=C3=A9 <berrange@redhat.com>=
 wrote:
>
> On Thu, Aug 15, 2024 at 11:12:39AM +0100, Peter Maydell wrote:
> > On Wed, 14 Aug 2024 at 23:42, Pierrick Bouvier
> > <pierrick.bouvier@linaro.org> wrote:
> > >
> > > When building with gcc-12 -fsanitize=3Dthread, gcc reports some
> > > constructions not supported with tsan.
> > > Found on debian stable.
> > >
> > > qemu/include/qemu/atomic.h:36:52: error: =E2=80=98atomic_thread_fence=
=E2=80=99 is not supported with =E2=80=98-fsanitize=3Dthread=E2=80=99 [-Wer=
ror=3Dtsan]
> > >    36 | #define smp_mb()                     ({ barrier(); __atomic_t=
hread_fence(__ATOMIC_SEQ_CST); })
> > >       |                                                    ^~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >
> > > Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> > > ---
> > >  meson.build | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/meson.build b/meson.build
> > > index 81ecd4bae7c..52e5aa95cc0 100644
> > > --- a/meson.build
> > > +++ b/meson.build
> > > @@ -499,7 +499,15 @@ if get_option('tsan')
> > >                           prefix: '#include <sanitizer/tsan_interface=
.h>')
> > >      error('Cannot enable TSAN due to missing fiber annotation interf=
ace')
> > >    endif
> > > -  qemu_cflags =3D ['-fsanitize=3Dthread'] + qemu_cflags
> > > +  tsan_warn_suppress =3D []
> > > +  # gcc (>=3D11) will report constructions not supported by tsan:
> > > +  # "error: =E2=80=98atomic_thread_fence=E2=80=99 is not supported w=
ith =E2=80=98-fsanitize=3Dthread=E2=80=99"
> > > +  # https://gcc.gnu.org/gcc-11/changes.html
> > > +  # However, clang does not support this warning and this triggers a=
n error.
> > > +  if cc.has_argument('-Wno-tsan')
> > > +    tsan_warn_suppress =3D ['-Wno-tsan']
> > > +  endif
> >
> > That last part sounds like a clang bug -- -Wno-foo is supposed
> > to not be an error on compilers that don't implement -Wfoo for
> > any value of foo (unless some other warning/error would also
> > be emitted).
>
> -Wno-foo isn't an error, but it is a warning... which we then
> turn into an error due to -Werror, unless we pass -Wno-unknown-warning-op=
tion
> to clang.

Which is irritating if you want to be able to blanket say
'-Wno-silly-compiler-warning' and not see any of that
warning regardless of compiler version. That's why the
gcc behaviour is the way it is (i.e. -Wno-such-thingy
is neither a warning nor an error if it would be the only
warning/error), and if clang doesn't match it that's a shame.

thanks
-- PMM

