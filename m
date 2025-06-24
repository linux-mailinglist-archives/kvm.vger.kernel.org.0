Return-Path: <kvm+bounces-50585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF875AE7261
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:38:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 560E55A45F6
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8BC25BEED;
	Tue, 24 Jun 2025 22:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lYszVeyS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACA023BCE7
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 22:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750804671; cv=none; b=GTe4W2grd1c5IDi+YK5PGjHKEMrDYDnmnlTr3qDFuCEKfurwkQsxzAnllpWCyIUNA1U46a3y2q/jHvneEz7SBtwFcZMXmxSJVqYonbXXcd9PxgpUwIy462oVCynBM2+A4v+sEZLgNACkFfGwga9DSTkFXL9BjIOv/D7+WgNLuFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750804671; c=relaxed/simple;
	bh=yqvkvZZvlS9/bOgEqxYcbtsKWtITOAr79gDOJhHlSdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tGvCjCETRsPSbMs92GzQWHufT6258jE9GlcUvkmIfO+b8xZZx6QynKoEHkbjIjuTyaTcxrqWKXiS5RJ2UvlSadvsLpq2/lKdCIGzinP4DYc//GkctPIz87wamwyG9Rhs/sDwlvYXTzErYUbzgukHu7frEL4QoIPgp+gefYRufIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lYszVeyS; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6098ef283f0so4412a12.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 15:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750804668; x=1751409468; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+LTR+yGLGyDG4mNtaRppoEfvrEV+3aBoT+/CzTmxE0=;
        b=lYszVeySNFnimMDm6VzBsCp+jjuKB8Bdl++GDlbUA3uxtDj+Djf/fcV4S58ws/m8wt
         14BMHM6WmB6G5xbMnvNjoH4rMeJjE7LWggWucg6os3tf4i1NbSWMV02JImbYZXOjWybu
         osnYJeywGZZCj9d1ryl0Say+gap60WfS+bWVc04hdiJBbNvWRkR854ZZpL0Y9FwWCRq1
         ZV14kXulNeJhNT2xKI3JtqGv+Gzvh5anz+nsjeWl3shJWdAJWU5mEjHnlRT4lUoh/6RG
         kMX2gmOPs9r4KJhXkSlJKIYuMc4vPy2ZKpmo8KZ9qZzHLWbRYuo9hp7MCWsWdhIqReVz
         9dOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750804668; x=1751409468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C+LTR+yGLGyDG4mNtaRppoEfvrEV+3aBoT+/CzTmxE0=;
        b=qYxPMJcN6tYCxk/gwZ2Q91udtSbb/nI1Gr94Jn/+r8d5EA/88YKgqbyyoU+ub17Sld
         RX/AeMPq8tiA5GIF58S/2ZZCPYX8M3cffwM6FNLRxOBoLC+KYLhAzKpIVW/yCin4pbdQ
         lNle4gv1WYQnru+LRKFBCNkOJLI0y4/P0Vzmq33nOvCukplWLyWgkbu/cnrOz9hWXsw6
         LphLSoNXT2UYjsYQgG7C3QebvE7Jcw+JZL+TuN+p7F60T5hUvkY3/8AbBhtNtklImuue
         vn+wNJAkf9elzMc/XDZUCqezUcfbRUCpu3t5ayeXObQGplAtlZfoLozdsxmM7kKPaC6b
         F4bg==
X-Forwarded-Encrypted: i=1; AJvYcCXp8Tyz/jDhhN20fBKm/BY2yHwA7gWjtb46ZbZK926ktWfpnwGHK/g2IT8or2j5QNm540I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCJSTX6vNZZQ4+7IR66Qn25iPI3iDfU6vv+USPbHulbrgHZWz1
	yu3vfOJejJqhA5NP4R1xtaH+nD59EOGz947mldPyxtVQZuuhGBjWlmrN1TasdIw+YfKYw/U2FFK
	r7SXYBxy+HG9CnhBaBDKffyy466+mwgy3F0d/96dZ
X-Gm-Gg: ASbGncvaI900Y60E4DEaC55iF7uB6brXPouJK4dfFIwR7271+7Rktc8+bNHe5kd7A1P
	43ut4C7WQmGeqU1jx38x5ErA6YQ02K8ErO8gn5LVnoF2P0SgMRBgiHU/GJ71HqAXbV0aCY26+sn
	KQMxD98RT23eHrHMonPDCwvdbPYr8XksfLDcrQpu6FtYo=
X-Google-Smtp-Source: AGHT+IENVZRLEn7PEDj6/WLvBEeRzhLq2UIfYqLVR56owc5IlIdrL2fzNuFAVT2CGwacJMIV98SfSWSfg6sa081HAUI=
X-Received: by 2002:a05:6402:44d6:b0:60c:3b41:6306 with SMTP id
 4fb4d7f45d1cf-60c4fd3ffccmr570a12.7.1750804668109; Tue, 24 Jun 2025 15:37:48
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com> <20250530185239.2335185-3-jmattson@google.com>
 <aFsaH97Qxn7nUA86@google.com>
In-Reply-To: <aFsaH97Qxn7nUA86@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 24 Jun 2025 15:37:36 -0700
X-Gm-Features: Ac12FXyBUxK5P-foDM5mpKN6vUellwixIkbV-6MHUnNPTBeC3YvEcmK6uwCkcqw
Message-ID: <CALMp9eTBP5UJZu+++44XXNAn+xOFoBNwHb1JYgbG+EzwH7Uc-Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] KVM: x86: Provide a capability to disable
 APERF/MPERF read intercepts
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 2:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> This needs to be rebased on top of the MSR interception rework, which I'v=
e now
> pushed to kvm-x86 next.  Luckily, it's quite painless.  Compile tested on=
ly at
> this point (about to throw it onto metal).
>
> I'd be happy to post a v5 on your behalf (pending your thoughts on my fee=
dback
> to patch 1), unless you want the honors.  The fixup is a wee bit more tha=
n I'm
> comfortable doing on-the-fly.
>
Please do.

