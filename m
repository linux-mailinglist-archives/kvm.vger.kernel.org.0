Return-Path: <kvm+bounces-63170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A29A2C5ADA2
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4CF96348429
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2D523EA8C;
	Fri, 14 Nov 2025 00:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FYewPZaZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD6A2192EA
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763081610; cv=none; b=V9cTLN7x04AWBF6ucbHkhvtjtwvEfzOZE3cfEeT7+7QE9l+NM2APvKctoWrQnYI5wwkCtniDB9IRDPkHMwJ5KyaqKBtgByBsoRXqKVy6ItuLzM0hD8l20Q0X89CMf08NZxUZzjIqmAqrOsEa5QCjsjaBCSrsUbyqNm01Fzfrl2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763081610; c=relaxed/simple;
	bh=sk2uMggCq1ckhCBdGx9muJo7+MWiHKvDO30mLbByhn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CiHXGtjgG0UP5U4ruizbHmxY3OvjQzo3q842dEiOcRYQNng5Koc+Z65SaOuq+rI29rubKhnEU35B+gV3Oo7m2ahvI0j0rjXwAl9RN6Iq8eyMJHCKhC0Z1ID2mYMyMoH9deSyzoT9m/jvdOmW6a1WpeuvF/42F7YlxrRNSEcvk7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FYewPZaZ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477741542bcso25615e9.0
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 16:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763081607; x=1763686407; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sk2uMggCq1ckhCBdGx9muJo7+MWiHKvDO30mLbByhn8=;
        b=FYewPZaZnXJz+oeofuFC+cW8dJW2Cw9bTYXju3ALNuURgkGkEUjkc2r1JdJO/yY06D
         XCpMXFM76mHmg9RSDohlps9BzQxwDZTcsuQ/91+zyg5v7IHjC6oWIsdH1CCRIsGrSExd
         VqmqdAbdWLM/Duz3fydlAeJ2P2z52viqthm3Q/skGQw6YfA81di0o9aocCCJBaXyYI7m
         rd3FBwMzDwENc82rXnhjncLLkmQCXX40bGXmQZZcSm9baNWZtnpeBg/ianCfHzVf20Ax
         luYw7vfPL1tQlKp4ebXMt4nnLdfP4d7jwr9ShfSljaLcjWLMwEFsHxn43Ski7F/ukW6S
         trGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763081607; x=1763686407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sk2uMggCq1ckhCBdGx9muJo7+MWiHKvDO30mLbByhn8=;
        b=GstUrzvdVSZD32eoVZCZx7vvqwXft8qTTHG43doqTszpA2xodP+lgqWE4W7UOsL5oc
         DFEQM4cl9MqXqIYvJWRhY0toKrLFhc/T1Am7NGg9lfFbbBjtEZ0ZWielUxGA17p7NnAc
         m7jrt8xsXGX+VTdWIRK6wU0hCKikNvyHUB3lBaVpvrEewU0FG90I1qwzx1bFCmWYRcEY
         kV493bzO9aBArrPWZycTw1LIPcQVNEbkx+6Kp30OfICUMgfZLHwEH4bi+5fYxiRisPYW
         KRMcv+kt9h0nrgHocBNFPbahFQyxuU7m3TUgf0PO1lklj/ZQQ6vdyJ20LPMB0+/6KED2
         IXMw==
X-Forwarded-Encrypted: i=1; AJvYcCX6R57VCk/Y2jv0tvYeZ9WFt4nzi4m78Feq5XS+NUF3OBFHNPR5CE3sBuUOQg3ndvJD81U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU6nSF8rYvrGrvOnQmRXW/bkt24IuhVXtRCvVnL6TSK9LkXGzR
	BIGkPfi67QAQdE0pv0Cpo+yU9R9gbMKxfCpaRIkdnjVLxAtMnk4pgVcDVe5TDRZqnKXIejyRQJi
	er/AOU7jhOJoWeumUqTylJX4OMjdBNuvNUjcbPR4b
X-Gm-Gg: ASbGncvQz4Z/KLRqVCKameMeUlmJIaZMMERAkCOi/DENhoWVZuzZMd4pRiopEOeU1mt
	EoMP0kvR5hGn7ChIJJjNPfdYeueQUbTp6gLWSp5RO3I2TalzLVGadav1UAerQcYYXkD5HkdA/aP
	p3VQyj3qlIA2u5fjZJB8cQ1kXrGu2Wlh76+IdOqrSnGAvFt2Rq/OYep3Xx8achM334K7AJR6b3L
	josPsCwc6TpTT4xI+Xvl8r5NuwZKXMxNdQ1VWOKlVFwOizAXgw/bSSC0r2Ap6wibgeSIuKKI4G3
	9RVgYtkehv2ai7hKNRVmZmXyjg==
X-Google-Smtp-Source: AGHT+IE3vstJm3oWP95qkqRJjs5fszSUCVzNUiug16EQF/JXNPVFpZq7hEiC3L8y9CW/kpoGUurTym+p6tSTb8UVNrk=
X-Received: by 2002:a05:600c:a20e:b0:477:86fd:fb19 with SMTP id
 5b1f17b1804b1-47790b10751mr266505e9.9.1763081607050; Thu, 13 Nov 2025
 16:53:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251013185903.1372553-1-jiaqiyan@google.com> <176305834766.2137300.8747261213603076982.b4-ty@kernel.org>
 <CACw3F51cxSgd-=D46A6X6GptEZS8-JZ_MnB_yK_ZR1wktunYRA@mail.gmail.com> <aRZc1SqU01Cyxc5Y@kernel.org>
In-Reply-To: <aRZc1SqU01Cyxc5Y@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 13 Nov 2025 16:53:15 -0800
X-Gm-Features: AWmQ_bmZ-_H-myZL0CSQJa9c5c9xb22UWf4fE3TvV1ETbHc5zzWFdDRoRMYRrbg
Message-ID: <CACw3F50ti1cXOLwhyEbM8OCmwEaDDXK-r3QT+qfz2=a0yCTBjA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
To: Oliver Upton <oupton@kernel.org>
Cc: oliver.upton@linux.dev, maz@kernel.org, duenwen@google.com, 
	rananta@google.com, jthoughton@google.com, vsethi@nvidia.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:34=E2=80=AFPM Oliver Upton <oupton@kernel.org> wr=
ote:
>
> On Thu, Nov 13, 2025 at 02:14:08PM -0800, Jiaqi Yan wrote:
> > On Thu, Nov 13, 2025 at 1:06=E2=80=AFPM Oliver Upton <oupton@kernel.org=
> wrote:
> > >
> > > On Mon, 13 Oct 2025 18:59:00 +0000, Jiaqi Yan wrote:
> > > > Problem
> > > > =3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > When host APEI is unable to claim a synchronous external abort (SEA=
)
> > > > during guest abort, today KVM directly injects an asynchronous SErr=
or
> > > > into the VCPU then resumes it. The injected SError usually results =
in
> > > > unpleasant guest kernel panic.
> > > >
> > > > [...]
> > >
> > > I've gone ahead and done some cleanups, especially around documentati=
on.
> > >
> > > Applied to next, thanks!
> >
> > Many thanks, Oliver!
> >
> > I assume I still need to send out v5 with typo fixed, comments
> > addressed, and your cleanups applied? If so, what specific tag/release
> > you want me to rebase v5 onto?
>
> No need -- I took care of the issues I spotted when applying, LMK if
> anything looks amiss on kvmarm/next.

I took a look and everything looks fixed, and thanks for nearly
rewriting the documentation!

>
> Thanks,
> Oliver

