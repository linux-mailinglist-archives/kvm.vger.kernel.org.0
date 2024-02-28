Return-Path: <kvm+bounces-10316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0762986BBD9
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 00:03:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B0E1B2634D
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 23:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9178D7D084;
	Wed, 28 Feb 2024 23:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rQ5RFpWq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DED7292B
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 23:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161220; cv=none; b=Q4sprybzsoZN8Z6+YxEM0GAa1VA6QUSC3x5vFvZ4mcnvWDkkgYz4ziG/L3BDb9H6OiVM52s4nhqSGJnEG2d9S376G1+23I7qMMRu4nFsQNZ1IKkGqVnjRyaKY6xn8xk7lAAR5pxYDMVRWaSX7/UU/MjVcUuFBaNgzBm7OFfA8ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161220; c=relaxed/simple;
	bh=w9b+viWMNeKfgV+J2kHVNJBYQcvE+Z5QsH2BWI8zYbo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vxj5Vpn0Q6ZONvE01R6H3plzglYR0695jbzuv4J7diU3QCuYKFsiw4K2uy+2skUlguMabK8LK1S3w+Ha08+HW/uBIbwKteQNI98FKTAijO60MC158xFgRM3vZGGFRx7iSaTPWIJZSWaKu/vnkUyvKPpCk14uJaDRJveyMihi4cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rQ5RFpWq; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-428405a0205so61771cf.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 15:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709161218; x=1709766018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HopOMhsdcEXeddljk1n/xV5v9vRitHQfeTlE00H1als=;
        b=rQ5RFpWqtFrYnTjUnWf/wec8CW7gfi4ss2dES6Dif/YjWa73nYL3NMBtoqtDvHHaYe
         ad25Xd8PiFbwN8aLkdUVX+pWEinmCLNLItCWkDCUTZQeOrvn7qHVzNJLrFxMSe1FNhuW
         mWR1VKR7S0cj/QK9CObk92JkQt/+P4Mpf662aBqaEgWESIuW+HlmdyYb//hIhPOhRfsq
         QJnq69LccTZK/kCRo/NiD6cYxXDhwFlRzVTCGo8Iv3UyLWlAVmmt21kp72T2lfblql9S
         UeiifBk9U6kW6fL9iU9DaPCPRSKiFtKZMDl+vn/Qa2mL+9dO+nfnAEsjjeTBpkDZS1U1
         skhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709161218; x=1709766018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HopOMhsdcEXeddljk1n/xV5v9vRitHQfeTlE00H1als=;
        b=WGT22iFKF+VhQBeDOE9mX/j1bTR+eloBsoAMk/TnNjGI3Up1oT+rHzrvaKDfEnaejk
         bGO9zl6azbEB72h55LKOIcTbftA0J7idXDcgKEeh+utDshbh2CJXkY3hMqYSSzJWKDRa
         35xPAZXrpPA1uMy6mynj1dSxk0Az4btQEQlW/jyEnstbBEJvASDOL0j9Rarni9tbCzvV
         PGMIoMXl1w6vjNzdwPVA+FYG5df+eNeimDqb7qnG38jTOpaUQj/Pxss8Ggj0zrNAbj0f
         rQuGI0TZ6xWaEBmgwZJY3+lCMUdEjhld7jqMHT/Kc5uVIfv04UECNQfsrf1NDRB4U/oU
         X+XQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWMcFYNWy2rns9ZiIWG4Hl1yEQ6U3MSd84yAga2os57YF+HNALD8FRBrCSWjw2ebGjP/dcw25v+aC7QmdG7nIQOAmR
X-Gm-Message-State: AOJu0YypVsYmgaC372lep695OgKJLllfSZRNHPiRAi1xYJqD2eXDrc5v
	xD06HBOocmScYWxksgITnFZB4PdVfNdI52OPk8FvctsIWiQRbHUSaUZ39tapn7cnyFvcaxclIwl
	nd5RSo0uTLXvFq4VYAx7YnZc6SjflQsNzAOXJ
X-Google-Smtp-Source: AGHT+IHEIl48iHJ1KzuHiKAjTB0tNQfgDXVFK6cKBoNpo/4g9vj3G+jFbYTISECOdJryun78YLwqHmKV20w8Yw4SezM=
X-Received: by 2002:a05:622a:250:b0:42e:b8da:1457 with SMTP id
 c16-20020a05622a025000b0042eb8da1457mr19090qtx.23.1709161217908; Wed, 28 Feb
 2024 15:00:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240208204844.119326-1-thuth@redhat.com> <20240208204844.119326-4-thuth@redhat.com>
 <501ac94d-11ab-4765-a25d-75013c021be6@sirena.org.uk> <Zd-JjBNCpFG5iDul@google.com>
 <Zd-jdAtI_C_d_fp4@google.com> <Zd-lzwQb0APsBFjM@linux.dev>
In-Reply-To: <Zd-lzwQb0APsBFjM@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 28 Feb 2024 15:00:03 -0800
Message-ID: <CAJHc60xqbrH5cgSm5URhxF1j-+X7PVD1WkqEBRKENo-GeQnsnQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] KVM: selftests: Move setting a vCPU's entry point
 to a dedicated API
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Mark Brown <broonie@kernel.org>, 
	Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Marc Zyngier <maz@kernel.org>, 
	Aishwarya TCV <aishwarya.tcv@arm.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Oliver,

+cc Shaoqin

On Wed, Feb 28, 2024 at 1:30=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> +cc Raghavendra
>
> Hey,
>
> On Wed, Feb 28, 2024 at 01:19:48PM -0800, Sean Christopherson wrote:
> > but due to a different issue that is fixed in the kvm-arm tree[*], but =
not in mine,
> > I built without -Werror and didn't see the new warn in the sea of GUEST=
_PRINTF
> > warnings.
> >
> > Ugh, and I still can't enable -Werror, because there are unused functio=
ns in
> > aarch64/vpmu_counter_access.c
> >
> >   aarch64/vpmu_counter_access.c:96:20: error: unused function 'enable_c=
ounter' [-Werror,-Wunused-function]
> >   static inline void enable_counter(int idx)
> >                    ^
> >   aarch64/vpmu_counter_access.c:104:20: error: unused function 'disable=
_counter' [-Werror,-Wunused-function]
> >   static inline void disable_counter(int idx)
> >                    ^
> >   2 errors generated.
> >   make: *** [Makefile:278: /usr/local/google/home/seanjc/go/src/kernel.=
org/nox/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.o] Error 1
> >   make: *** Waiting for unfinished jobs....
> >
> >   Commit 49f31cff9c533d264659356b90445023b04e10fb failed to build with =
'make-clang make-arm make -j128'.
> >
> > Oliver/Marc, any thoughts on how you want to fix the unused function wa=
rnings?
> > As evidenced by this goof, being able to compile with -Werror is super =
helpful.
>
> Are these the only remaining warnings we have in the arm64 selftests
> build?
>
> Faster than me paging this test back in: Raghu, are we missing any test
> cases upstream that these helpers were intended for? If no, mind sending
> a patch to get rid of them?
>
I sent out a patch in the past to get rid of them [1], but Shaoqin is
currently making an effort to (fix and) use them in their tests [2].
While we are still reviewing the series, we can apply [1] to unblock
enabling -Werror and Shaqoqin can re-introduce the functions as
needed. But, it's your call.

Thank you.
Raghavendra

[1]: https://lore.kernel.org/lkml/d5cc3cf1-7b39-9ca3-adf2-224007c751fe@redh=
at.com/T/
[2]: https://lore.kernel.org/all/20240202025659.5065-3-shahuang@redhat.com/

