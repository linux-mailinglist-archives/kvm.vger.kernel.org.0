Return-Path: <kvm+bounces-59933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BFC02BD5CAF
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 20:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B07FC4EBA57
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 18:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2293E2D8DD0;
	Mon, 13 Oct 2025 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V1WO8Xxs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952772D837B
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760381573; cv=none; b=nIxV3jaYWk9bLwGgvf2ByXAu7d5otiyjPwh+R8md+IQZZyFk5DBj604NdD5QadK4fFSJOBhdvQHC6+XJCuC7+/6FUf2cXyU/YRJrcelKeIoQUBnC/WfzAHsoiiA27U6UsRwJ+nvo3Rdm1Mv/mq3VqsWnouZj3V1ZTP6PY97JMUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760381573; c=relaxed/simple;
	bh=iUk2UdMf7pERxk6w7Llo5j8YKBarUI/BPofhsYl7ZmQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cn3okg/YJzhL6wRYu51pYV2lN0+pQ8tVVe95auZe8U2mc1YIK06xjb+Szgf0jQol8MuFu9G/TjxHcicbd2EJ5jZeOaHPT1UJUiVOa9TMCPaV9sTSmoYT86weSnrdZANp72Av7miXVlcPn1OZ8SVQ0b9hx5qrZjbI3beJoXIY3VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V1WO8Xxs; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so22535a12.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 11:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760381570; x=1760986370; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Re5H/O2EjTXsidOVadl49AyAMlZCly7+yKfYOFvGPQ=;
        b=V1WO8XxsZJPuxZ78p+SN+1Wed5ojmiHoH5AlMg6daAd6yHFkJdM1V30IN3jMjlRIM1
         D/GHVy4A1ColStG3Wqx44to7zQELLiV9t1EZBoXxJiBOSPzNBy59rDB5PGbBOGCkIPGE
         RWCZGEubj7uYuD+o9Itjeb0fda/jk24Wt2NUofBrobVbo4Ns8UFqT+Os+lPqeflgKCVU
         0gieyu7vNvuAa2R+y4G2K2xmy0jbzI4rqJBF7OYQvaOGGTj2NwgQKtwi12kwK+MH7IFk
         ealopVV1o4A72XkwFYnYCSPL4dT9sPajjy3hKN8/5ELBA9lIKYewZUUXPeLT0TCNXzmQ
         fCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760381570; x=1760986370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Re5H/O2EjTXsidOVadl49AyAMlZCly7+yKfYOFvGPQ=;
        b=sVvpzzJDXFJ6mnIwT+8V69offqQkPU8/NFz9UPWFjdokdvNzu4CPj+KTRDtq/jwBTi
         Z6yCt44m1lKR4TLqHnPM6UJ92rx+qOYzzXdnR6VKKhA6gZzReYH4cHUb5FN8s6qNrQug
         rSsh5cQxALkC1TsfkY48iJchvwUFwD+EbagICCWe1TqQVXuwaZGHm+apD9g7m96YIgrr
         uAatuMnkDn3WVm3mND8vfH8yVmC8tkG3VHikjvSGGynYjJbJtfDSGLkAs4379qI57k0r
         F8LJHKkLQ+wUzurmO56W7/P7iE7SdZYrq9mf9xuAPWVLBNT8C+V3mvIAMMyHlocZAMkA
         gYfg==
X-Forwarded-Encrypted: i=1; AJvYcCUplzPyxdpZwnHAGbQCNoRROoM4kffOkjPBaUp6frk68S99Db5YimYK5Y4iXUbTJsBH1Fo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0A1A9aaOginwKw5XH5pN27yOb15DhcFBwngWcW104pf8L8HXL
	wlPg12D0uwf+nDt9OBOVlQyCpvUi5SvIsIq2JmdmPoTsfr82zJmnyt6cv/KOe5p3itqwuBZHsud
	GVp4PdSo6V8r9CLSIMAHioSDnQwzYw3px68nWnlg2
X-Gm-Gg: ASbGncsr7qvLKr9GbuW/DWhA4twVPhkbTk4CCUKUWAMUNLshBXvx745j2BaPHuJwQwK
	GPoUMKUFZaTOKIEQRDNU2dBzuyBXmzOjV5Ek4I9n8XwRwwUtpl/EwEXQO+boNMhd5EG3HC8TQFC
	/UTe+rLj3IfqC5WHBixGBrEobxZawttJ9Hesz0kkzbvQtbNohCEZvohZh0oZyKn+oysbejv/8ka
	wBIwMVXsX/tph/T+QzVLd6cmdqCDVX3
X-Google-Smtp-Source: AGHT+IGjMm2akrmfnLsDJ0iB6NildCG1lCop2Q8XTbJJNu9nQzttFSJPMYZduDDnWEIei4uujvTHcEVhI6nPtTT49gw=
X-Received: by 2002:aa7:d889:0:b0:634:90ba:2361 with SMTP id
 4fb4d7f45d1cf-639d52e9f0emr630105a12.7.1760381569759; Mon, 13 Oct 2025
 11:52:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-11-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-11-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 13 Oct 2025 11:52:36 -0700
X-Gm-Features: AS18NWDzaWCEhjI7Qfv6rqXIYOx0uL1PdtbeaJ4kWvwOyK8bYylvN6PL8Eg-vc4
Message-ID: <CALMp9eQ-KnS-nEGFOvTjNJNOiayumQSiScHixCpPa23pnVBq8w@mail.gmail.com>
Subject: Re: [PATCH 10/12] KVM: selftests: Move EPT-specific init outside nested_create_pte()
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:06=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> Refactor the EPT specific initialization into nested_ept_create_pte(),
> in preparation for making nested_create_pte() NPT-friendly.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  tools/testing/selftests/kvm/lib/x86/vmx.c | 71 ++++++++++++++---------
>  1 file changed, 43 insertions(+), 28 deletions(-)
>
> ...
> +
> +       /*
> +        * For now mark these as accessed and dirty because the only
> +        * testcase we have needs that.  Can be reconsidered later.
> +        */
> +       epte->accessed =3D *leaf;
> +       epte->dirty =3D *leaf;

Not your change, but it seems strange to set the 'accessed' bit only
at the leaf. The CPU will set the 'accessed' bits from the PGD down as
it does the walk. So, to only have an accessed bit set on the leaf
requires the existence of some software agent to clear the higher
levels.

Reviewed-by: Jim Mattson <jmattson@google.com>

