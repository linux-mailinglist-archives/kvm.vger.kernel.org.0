Return-Path: <kvm+bounces-26601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F97C975D80
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 728FE2809B3
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE4E1BF7E5;
	Wed, 11 Sep 2024 22:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IcHEw9JU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A111BF303
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 22:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726095383; cv=none; b=LmCV1D6YX1F/cWI/+ZhBL5CG3hLeWIvDSeuevd78sVHpRqp4TvSQwY4hKcG4h7wkwCT5fYQgphNojPgs3PRvUKpxnCmWF9p7ChZgpBBaV/bra8pUb01y2S5cmdRXLBtkUwB4bpZkh0HgpG3+lst0fyBSlHh6OR2KBzMvjAPtAAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726095383; c=relaxed/simple;
	bh=ipxZRueJPfM2kml61M9W8yJZ32U+VLyyM0JqXDqlqBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k4uirgKJOEvaoZEu0kDmMwBSVNqwp1lbJ/CUuOhcIKaWheUibKidKVL2ST9VxNv2b3I+yoQ3xji6SWsGn8yJq4Hhv1j3yzyx5trbe5MofiH4HNdu4H1lKuconZ3QkI21VC3TPeTWQ/neeZYZjNDk0OS6QOWQWwkxxmItnh4+IyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IcHEw9JU; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1a7fd2eb36so867821276.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726095381; x=1726700181; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mBS3D2KdJA6HsOBF2WNnyBQbckZXPd9OPRyAx0Hk9Is=;
        b=IcHEw9JUhC0FwVkiG9HCZEMnNg+R8OBzt9NCj2Yn961V2AbK7m2xy5tuzPpUPDAQcL
         xHeLT5XTZHJCItV206li6cgDf7Y9K77jo4pjmaj7g61lmUR/sr4egSG7BUCvzWKG20wn
         RMDds6WjQpalefCM0SrHvY+x1aU7VXPoQrFgiHabE0/RjwSypjA3Geukf6It4u0mOftx
         KB2DU5wt6YISZjw1AN9iSkVfiaUH/EgArtJM9qdJft1I3jGS+cEgoVDpBRhLIXRx7k/b
         MgU74wBI1hwfxrziGqIexIhC10fZBXUi2KOXbacgni2f419VEVbPc+DlL6lnbgt0b48V
         O4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726095381; x=1726700181;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBS3D2KdJA6HsOBF2WNnyBQbckZXPd9OPRyAx0Hk9Is=;
        b=OPgI4QEV0U8gtITvHmuSin4sg+jfg/4+zduryJ9cHcGH17b/OaMYCz3A9KRJersS0J
         CKiPeuORRMQDpuBGoesdaCx+/Tv4oroVgN7WlOcWs7pp9kh0LAVh7NSw0K/GFR6m447C
         oquGlMIcGLG2vQ/WMJTfkS1WFKfMHxKCKQ/na84rfPG3lMgl2z8qAqNtB3XSGke93MiW
         ywvBtOcLRXC+57ylHQQz7bygy9toHYxY425MKbvXIypiCNyjdwwOhA7cIXXtqrrMWWlN
         GPCHX7QbWDiFxcQW11LypcGcEZPqfP8lXOiXWWftiRi9Tvs0ctFLwsvg8jvCzMW7nocw
         jcfg==
X-Gm-Message-State: AOJu0YwplASAdvV/ITTmEIQBZPal1O66tgj7N46jWeh+QTdhFU3AGwvR
	pODD23Ys0oT6lDc/M8FiVpiM5eOfEF4DiiUL6IW54KLZPbg9oMq8Fz1IrYihAw3ENpPuT5wSw4h
	KGA==
X-Google-Smtp-Source: AGHT+IEoqmUAJ1tvpPAJVzioyGi+fn8A8xKnd0a1Zk3H0MPaPxV6IznaYWnB2Res1beHC7Hgla2hvlhylw8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2946:0:b0:e13:e775:5a3c with SMTP id
 3f1490d57ef6-e1d9db9e484mr1092276.2.1726095380603; Wed, 11 Sep 2024 15:56:20
 -0700 (PDT)
Date: Wed, 11 Sep 2024 15:56:19 -0700
In-Reply-To: <20240911222433.3415301-6-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911222433.3415301-1-coltonlewis@google.com> <20240911222433.3415301-6-coltonlewis@google.com>
Message-ID: <ZuIgE2-GElzSGztH@google.com>
Subject: Re: [PATCH v2 5/5] perf: Correct perf sampling with guest VMs
From: Sean Christopherson <seanjc@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Will Deacon <will@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 11, 2024, Colton Lewis wrote:
> Previously any PMU overflow interrupt that fired while a VCPU was
> loaded was recorded as a guest event whether it truly was or not. This
> resulted in nonsense perf recordings that did not honor
> perf_event_attr.exclude_guest and recorded guest IPs where it should
> have recorded host IPs.
> 
> Rework the sampling logic to only record guest samples for events with
> exclude_guest clear. This way any host-only events with exclude_guest
> set will never see unexpected guest samples. The behaviour of events
> with exclude_guest clear is unchanged.

Nit, "with exclude_guest clear" is easy to misread as simply "with exclude_guest"
(I did so at least three times).  Maybe 

  The behavior of exclude_guest=0 events is unchanged.

or

  The behavior of events without exclude_guest is unchanged.

I think it's also worth explicitly calling out that events that are configured
to sample both host and guest may still be prone to misattributing a PMI that
arrived in the host as a guest event, depending on the KVM arch and/or vendor
behavior.

