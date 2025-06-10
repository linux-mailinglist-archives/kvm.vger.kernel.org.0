Return-Path: <kvm+bounces-48813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7522DAD3FBF
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2975417B53D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 16:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990D3242D9D;
	Tue, 10 Jun 2025 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pfA7v2j5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA4E1E9905
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749574759; cv=none; b=f+3iDTj1I0Qt6z4Z8+9RkzbSCNDoo1rZaQ/AiQNQnAWY39R55BLvpQ6ZPqqlrB2ttDYuRyw/G5tsroFKmuTqVRLKeqT3PG8+JFfB1iBASa3KZOKRPGidNxLWW0VEQLOioq5WGy/OmLuZ0GOx/p+WFEARdlFdymXXS+IQj6xklTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749574759; c=relaxed/simple;
	bh=8DdNfwjgj139DEq2bn4GfoSJLG+m3GPjIEZGs5Alap8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bRWFifFm1DtM1VbTHXgosEGCIKqm6te9boF8yikDkzQGqbc26fjOCD5/1xvIRCfJCDY+ZlLXOh5ewsej8hQ7bY6mfDbTkJ0gWDZ1SsNzWjTcIuMZe9+0fr1zPI0/J4Z+ujAEy15Tr4MUPCpmp2Hdh561tfUDqtCKh6jmcm8VFS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pfA7v2j5; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6000791e832so194a12.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 09:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749574756; x=1750179556; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8DdNfwjgj139DEq2bn4GfoSJLG+m3GPjIEZGs5Alap8=;
        b=pfA7v2j5jfIqvurgrSP5YdczJl1MJSS/EbA4ezJOQ5tCOf4/bUHT2ZEEj2EvdkhNAH
         k5yX4KVLcAXgT1zsPh5KxP2+kOvww4uv/BimjNj06bX32BMRE0NMIIkXGMaoB9yj6jZJ
         X35P9qtmhYiSx6+zBx0pxQ/nnaVUAABLJM8MsUbcpn98atFomHzbbfhUACErunGWqtw+
         tNuyyVNbNMZ7t0AncfWDc6X9m1iCnsQMkz3+vPAEG2Ft8o3RJ52EMUbbFBUlfO0JmiYX
         ydftAP8JLt0zpOxLB1AN4/oATJ+oeb9WzO7v27nmtijbp+29SGFmhQEZ7Io3T/85+rm9
         0ZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749574756; x=1750179556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8DdNfwjgj139DEq2bn4GfoSJLG+m3GPjIEZGs5Alap8=;
        b=wg0czBZEm4g82SpZqAc0CGPDaXZ69OplVeXzWJ7DATE4MkcTIptDioyBuJnsD4sZTL
         sK6vjfVkJejfPIoIiwNsqjt993zqFzqMi3s/LZE7Z8esC2d7vbZGsruRgE6J500LCoaM
         9z70aej0T7D+Qli/Y2SaK39nsvt6hj/sjtc2LYgyitHmOrLm8ebpVAGPQme6CbUf+ji/
         +iDciiG6G42n/EKdFSv8EM4vxp24PjjwZLy4BwfBBxxi72SAjpG7DJw5HfHXfI7o+Hx/
         2O1vrUmhOOWEa2DobA7nEBHqrP7xTIVclqtXyHgh+TbrEXJXilGr9megwp2CUBvJzvd2
         06LA==
X-Forwarded-Encrypted: i=1; AJvYcCWelDR8/PIN652w0sPAqU2rLVSK4SqmnxbX/DwHMUm4oCYLWi5NZNjC84He9RxIy4wttXQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAr92hMGd4TBGgb+TbXsJM3D3tXZx2sx+TTOP+xrE1owEyaU7N
	oCm2KPRlr+rqZ2ksekQ4trr+TqONywSc8FxSiIRnMv6U48tNi/wDwr0QU9QhxT7UiPwWNaiAQQM
	ELhsQ97A4cVXlFP/2bzrNcsRTvsAeuUjWkrDfLnhh
X-Gm-Gg: ASbGncuwYFoETSrLtuQ5fPpDxmooZFMBJsia/MPQ6YXgw1vbzw4n4T9N2Ryq72Cj1G2
	ns2ZNpccDD00yJnyJowO+fVsOYqFC5UwRZlPe5BBLTugyzPWvVu74yBLbBw619vvJ55QXZaxAhJ
	R5HZnNq5zvDixlwoX3ZnDqMyKV8ru7gJkuecNN50XhZIs=
X-Google-Smtp-Source: AGHT+IFHgH7B3qe7Ezwbp04DhkXrz+YAg7VQFjxBJASIUVt7JokWaJsT/0dNRwXRYWfdz42tsS5PgvinQXkjPY6JLAE=
X-Received: by 2002:a05:6402:4543:b0:608:203f:196f with SMTP id
 4fb4d7f45d1cf-60844a7d7e5mr6673a12.3.1749574756301; Tue, 10 Jun 2025 09:59:16
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com> <20250530185239.2335185-4-jmattson@google.com>
 <574f8adc-6aea-4460-9211-685091a30f5e@linux.intel.com>
In-Reply-To: <574f8adc-6aea-4460-9211-685091a30f5e@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 10 Jun 2025 09:59:04 -0700
X-Gm-Features: AX0GCFtUxEPr7inOMprPmI_sitxPIX2gv1QlRpTuYqs2PDV-GxmAPLTPEpqEiUA
Message-ID: <CALMp9eSS09bzdUs2JPnaQKM6ALWjxJNqWTsNYM5LOnSJjyRanQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2025 at 1:42=E2=80=AFAM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 5/31/2025 2:52 AM, Jim Mattson wrote:
> > For a VCPU thread pinned to a single LPU, verify that interleaved host
> > and guest reads of IA32_[AM]PERF return strictly increasing values when
> > APERFMPERF exiting is disabled.

> Should we consider the possible overflow case of these 2 MSRs although it
> could be extremely rare? Thanks.

Unless someone moves the MSRs forward, at current frequencies, the
machine will have to be up for more than 100 years. I'll be long dead
by then.

Note that frequency invariant scheduling doesn't accommodate overflow
either. If the MSRs overflow, frequency invariant scheduling is
disabled.

