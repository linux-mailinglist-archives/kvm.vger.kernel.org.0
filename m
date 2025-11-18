Return-Path: <kvm+bounces-63573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A31C6B096
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A2B6634AB44
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16ACA349AE6;
	Tue, 18 Nov 2025 17:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wCikBGPE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D6A36C0AA
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763487565; cv=none; b=CXYF//0t0u7ncohrvmcmOV5Ho5MizNBudHLqguVvcztjl/vlCch9QqyN/vZTkXE2mdthEH/Ea839MYeVZHyREIxeV4syeRoPlBudEG2qWaV96okr+45rtvCc21SGQB2ji9JpCGA0Coh2sUV9MmVU9pN3NNYXE5asIlv+borEZH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763487565; c=relaxed/simple;
	bh=UcF6Pykkyi63rCvazLlSMYyYidvgpcr89v6pzjeimrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gyUplR3nl1D/87vTRnDPG75eUVkp86YF30rN19DcY/nbLLt8RKJvRA4mU+s09YyBjcEAeZuzirRYR6YP2mSW5bUFO4oJQxYvWes7LOopPaJFeXkLgfYsGqpa+uKJItlaOqp1fppzfHjaqI5ASko4GT/QzhAFkDt5veNpxkpxUL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wCikBGPE; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-429c82bf86bso3396102f8f.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763487562; x=1764092362; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJTWU6bp6aXeqE8Hu/Ko1Jy1DeU3HnzgdG88qtQi+To=;
        b=wCikBGPE+M2rmvdxYn9EGcxs5l4XLJSGI8bEn66vu6MEOC0CqBeanA6TLFvwVfJcPf
         jNtHqMtKq7SHYU/QONJleNnG39oky5SCqlEIFJR5FX4ZF2Z49rBcwKI9b/2YmcOmizK2
         2XVIz2ANGWxMXedWUfuPlV0cJ5NtWaqorAv0d5CWdthdLOo3j5q47LLicKuu9R2ZOpmL
         tSqgbVMIYrCA01EzTMFWQFI851eMzAhY9B9qF7aOOU0YID4myt7Vl2Rh+5KFNnqjfApD
         081nppYEb/oWiiqfS2Jr3jQqS5/GunS/dtLR/aTrotAdeLHu4z6NciYADgKLZRvKAXa2
         rpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763487562; x=1764092362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZJTWU6bp6aXeqE8Hu/Ko1Jy1DeU3HnzgdG88qtQi+To=;
        b=JMzX6KFreIizU+eqgki410zLFhsCGJXfNDgjdc0w87CBNf3JX5az2EeBnT//39KPZ0
         fEnJQxMa5Fpn2Dw987dUa21VRjulIzeJMXTVumT4NCGk0kWQu4eHac7mXqhGpXsNPyn8
         RubK1P6adBl8LGpWDw970M6FbxPh3xxZpKCKjXxj21/5AqrI8cWk7gsqW5AodZ8eA7IW
         8FDpR+mq5m5Xi2HeQhDQGfEQdIe840le/UyLQ7WUFGFwh3FoDyvDT62b8g3oeTPWmomj
         a9GFWtnOHB9q/5JhPqTS4cKwWysrBd4BrVNJzwwun3gCZod1gXEzuUZ9iqWZDBbWTJ0t
         9mXw==
X-Gm-Message-State: AOJu0Ywm7dPn7wwgM5RKOQjchUZr0A+RqMUwxIhyvi0EXQ1P48OB0RzU
	AluKw9cRZqkAxt6gZwC41631nPdW8L0nqKLyersXsafMm8tcnWxYMFhcZ6mkqbjk/pTb1Br+fCY
	5I4/U6K+Zi8/snFxA7/Vm4y/lvfw0jzSblDTuYjb2
X-Gm-Gg: ASbGncv6VRjNJNWvFkzlUcUC5hcxrtTSt5Gz5b2XcPOmcFr8KL8EenyavJov9uU+HYO
	ve/5EF9oHu0JgJPSgLWWeIznpVkcZw6TAZBeI8p9tb650Dpgp3hStEb3KJp4ONrb65fuIr8du1/
	Bi33W0mgLbSqJH8/5a8kcKy/DaA0yOT840LT9fGQnTvvlcg/7OAjOuT1CpwzxMrCgtMriSsxC2W
	GC5myuIZh35f+E3dUgvzBEW+A/+OVXbIqCC7AWyDY3tOlMsneb4jfPDgI8jwaiffl4M0rJAVSDT
	dV2ucBTU+0BRF+3lBc65KSjNxatgXA==
X-Google-Smtp-Source: AGHT+IH8RK5yCY+D+71GIgNbP5U4edrUAvafYp8izdPJO6GPWuR2bstklYGLXfz6mDPp1Vn19Zni6iSnvMlqTkzCpAw=
X-Received: by 2002:a05:6000:1846:b0:42b:549d:cdfd with SMTP id
 ffacd0b85a97d-42b593393d8mr15582247f8f.2.1763487561394; Tue, 18 Nov 2025
 09:39:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117234835.1009938-1-chengkev@google.com> <20251118-bfc923508a761fc0df77ee36@orel>
In-Reply-To: <20251118-bfc923508a761fc0df77ee36@orel>
From: Kevin Cheng <chengkev@google.com>
Date: Tue, 18 Nov 2025 12:39:10 -0500
X-Gm-Features: AWmQ_bmQ1rCvu97Qv8NZPaD_wVI7otUcnQbes4bKKmoRp6R4Hr4s1844lShvdck
Message-ID: <CAE6NW_aETd5qGsTWLFLe_pm4vQHr1HaVucu4Mk1aqV0HO_wpWQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] scripts/runtime.bash: Fix TIMEOUT env var override
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, yosryahmed@google.com, andrew.jones@linux.dev, 
	thuth@redhat.com, pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 11:30=E2=80=AFAM Andrew Jones <ajones@ventanamicro.=
com> wrote:
>
> On Mon, Nov 17, 2025 at 11:48:35PM +0000, Kevin Cheng wrote:
> > According to unittests.txt timeout deinition, the TIMEOUT environment
> > variable should override the optional timeout specified in
> > unittests.cfg. Fix this by defaulting the timeout in run() to the
> > TIMEOUT env var, followed by the timeout in unittests.cfg, and lastly b=
y
> > the previously defined default of 90s.
>
> Missing sign-off.
>
> And let's add
>
> Fixes: fd149358c491 ("run scripts: add timeout support")
>
> even though that commit didn't document the intention at all, because I
> agree with the assumed intention documented with 7e62eeb72fe3 ("scripts:
> Document environment variables").

Done. Thanks for pointing that out!

> > ---
> >  scripts/runtime.bash | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index 6805e97f90c8f..0704a390bfe1e 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -1,6 +1,5 @@
> >  : "${RUNTIME_arch_run?}"
> >  : "${MAX_SMP:=3D$(getconf _NPROCESSORS_ONLN)}"
> > -: "${TIMEOUT:=3D90s}"
> >
> >  PASS() { echo -ne "\e[32mPASS\e[0m"; }
> >  SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
> > @@ -82,7 +81,7 @@ function run()
> >      local machine=3D"$8"
> >      local check=3D"${CHECK:-$9}"
> >      local accel=3D"${10}"
> > -    local timeout=3D"${11:-$TIMEOUT}" # unittests.cfg overrides the de=
fault
> > +    local timeout=3D"${TIMEOUT:-${11:-90s}}" # TIMEOUT env var overrid=
es unittests.cfg
> >      local disabled_if=3D"${12}"
> >
> >      if [ "${CONFIG_EFI}" =3D=3D "y" ]; then
> > --
> > 2.52.0.rc1.455.g30608eb744-goog
> >
>
> Thanks,
> drew

