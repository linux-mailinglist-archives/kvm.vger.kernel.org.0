Return-Path: <kvm+bounces-45000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C7D3AA579E
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 23:43:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E67D1C23EFA
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 21:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D042222A0;
	Wed, 30 Apr 2025 21:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p96prS/2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9722749E2
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 21:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746049316; cv=none; b=unwE8ssTRRPFCbgJa4jHCf5afktorYxb1HsnFNu2NwX+0mvriSxQPAkvIROAq/Xdb3yKvswnTB1EyEGALZdEDH+mmhALTyJwHm6+mf1cBV2PQMm3Qcy3AHpt39KXvb2ermmvBPC4zPnbh/I8k/ZsXGu56ZtPj4mmej/0bUuSHAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746049316; c=relaxed/simple;
	bh=mGwiaQ7TH+sIKDNrEb7lzXc0Qw8YiXCCaz5ackF09Ng=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E/AT/xOSPdDSQx0qNZkdSTBpH5gkLgp3sdQHlI5HwyxYX7fA1xnW65FTrEnAOQO8TGJyNxUkKDUXXgo3Jfth7HRSskrdt0bc/ySCkth7OMZ6UHk2dIXDcqQPBiLDMgsch7bKcfi1mC2quZMRFqG3XIR0fmjS4jE/B0sfxM9+pm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p96prS/2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30872785c3cso524289a91.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 14:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746049314; x=1746654114; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rPPCPUomRK7S/tvky4KsIS9QMkz8k3qEWnlfYdUkuh0=;
        b=p96prS/2QT4wDqctyKih1COtym1o9eBdQ+mFQIgl/EJK3pLKv/SAkiv4ARDeeddZvx
         70O7MYFaYZRYTEcdMJBfvBeXSxAJ6NpN63LYYYKyW2SeNTgm2O04VMkFgJ//6F53CaQ6
         0DgeOUl3BJiY4zERt+tOMxIGvWQvHlC8IvlqkRg21Nf4KqKvEB6P8jKMMim+HTw3EFLn
         zKcnAqNWsJg/CjM1f8gN5Xe7rZVPSqBgxjIY09ifU5ghF/eEeCt+7unK1KA4YSk+NXE9
         eO5wEfyR0sLHJsEbD27C0lp5nLvXSmEI5LXsrq2YcoDv89YiTVli9/OBxKlFHRZgWsz7
         fQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746049314; x=1746654114;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rPPCPUomRK7S/tvky4KsIS9QMkz8k3qEWnlfYdUkuh0=;
        b=BIc8mf0YPJpGc7/ZiCc174gOHb79HpN8x+20lNel5/sz32/iVN/dEt7GDis2iocuh+
         G3RxrmkLPVxoadOcrKnyzO3SlJW9aPvgh/BAC5m5cUBABGdVUDzxlA6UzKOwEfOSLy7V
         P/1WxZPgtS6kHV3HB/H+Nr0dv9fOTyFkZIV2j7iL3llIwss8jtxFrzwvqobmPjgorZ/N
         6mhYkKuOB7OefBeTfLcQvr18tHvmdh3uUN04SI/R1hCTwaiGzQVWVsATUIGyip2Os/OF
         MBD1uRx0pnnJlc7tdsJxHcQrGu435eDEqnnNiuW417FmP5BOndmM/A/JHgHKdPKKFxrv
         vmOA==
X-Forwarded-Encrypted: i=1; AJvYcCXupYtdHPX9k0vLOZl0e05YGk5bBzwSbSIuL8U+DLUaWvRE9nqEisbq/5GjB24okTWGcEg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0IeQJggn9bDkcmJZsdU43XdwOcgY1NEQ7UkQ2p+mX+ELgkzF8
	7XGiuhVEvrGAmQsy29y072S98EK4YafRdTwTKrgIcPfDEDByg9cY5oSu7ADdeJkECerSzd7UOKX
	W0w==
X-Google-Smtp-Source: AGHT+IESizk+VPqy/xkdt1Ruy0dJJHg5vbR/3pjM/O8Vds4uhqDFE+H6/SOjjRDEx34ufKVjoWEbNuxyNbE=
X-Received: from pjbqi13.prod.google.com ([2002:a17:90b:274d:b0:2fc:2b96:2d4b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2cc7:b0:308:65d4:9dda
 with SMTP id 98e67ed59e1d1-30a400d3543mr1059213a91.16.1746049314110; Wed, 30
 Apr 2025 14:41:54 -0700 (PDT)
Date: Wed, 30 Apr 2025 14:41:52 -0700
In-Reply-To: <20250429225550.106865-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aBApDSHblacSBaFH@google.com> <20250429225550.106865-1-jthoughton@google.com>
Message-ID: <aBKZILBdDfx-Gwi3@google.com>
Subject: Re: [PATCH v3 5/5] KVM: selftests: access_tracking_perf_test: Use
 MGLRU for access tracking
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: axelrasmussen@google.com, cgroups@vger.kernel.org, dmatlack@google.com, 
	hannes@cmpxchg.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mkoutny@suse.com, mlevitsk@redhat.com, tj@kernel.org, yosry.ahmed@linux.dev, 
	yuzhao@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2025, James Houghton wrote:
> On Mon, Apr 28, 2025 at 9:19=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > Using MGLRU on my home box fails. =C2=A0It's full cgroup v2, and has bo=
th
> > CONFIG_IDLE_PAGE_TRACKING=3Dy and MGLRU enabled.
> >
> > =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> > =C2=A0 access_tracking_perf_test.c:244: false
> > =C2=A0 pid=3D114670 tid=3D114670 errno=3D17 - File exists
> > =C2=A0 =C2=A0 =C2=A01 =C2=A00x00000000004032a9: find_generation at acce=
ss_tracking_perf_test.c:244
> > =C2=A0 =C2=A0 =C2=A02 =C2=A00x00000000004032da: lru_gen_mark_memory_idl=
e at access_tracking_perf_test.c:272
> > =C2=A0 =C2=A0 =C2=A03 =C2=A00x00000000004034e4: mark_memory_idle at acc=
ess_tracking_perf_test.c:391
> > =C2=A0 =C2=A0 =C2=A04 =C2=A0 (inlined by) run_test at access_tracking_p=
erf_test.c:431
> > =C2=A0 =C2=A0 =C2=A05 =C2=A00x0000000000403d84: for_each_guest_mode at =
guest_modes.c:96
> > =C2=A0 =C2=A0 =C2=A06 =C2=A00x0000000000402c61: run_test_for_each_guest=
_mode at access_tracking_perf_test.c:492
> > =C2=A0 =C2=A0 =C2=A07 =C2=A00x000000000041d8e2: cg_run at cgroup_util.c=
:382
> > =C2=A0 =C2=A0 =C2=A08 =C2=A00x00000000004027fa: main at access_tracking=
_perf_test.c:572
> > =C2=A0 =C2=A0 =C2=A09 =C2=A00x00007fa1cb629d8f: ?? ??:0
> > =C2=A0 =C2=A0 10 =C2=A00x00007fa1cb629e3f: ?? ??:0
> > =C2=A0 =C2=A0 11 =C2=A00x00000000004029d4: _start at ??:?
> > =C2=A0 Could not find a generation with 90% of guest memory (235929 pag=
es).
> >
> > Interestingly, if I force the test to use /sys/kernel/mm/page_idle/bitm=
ap, it
> > passes.
> >
> > Please try to reproduce the failure (assuming you haven't already teste=
d that
> > exact combination of cgroups v2, MGLRU=3Dy, and CONFIG_IDLE_PAGE_TRACKI=
NG=3Dy). I
> > don't have bandwidth to dig any further at this time.
>=20
> Sorry... please see the bottom of this message for a diff that should fix=
 this.
> It fixes these bugs:
>=20
> 1.  Tracking generation numbers without hardware Accessed bit management.
>     (This is addition of lru_gen_last_gen.)
> 1.5 It does an initial aging pass so that pages always move to newer
>     generations in (or before) the subsequent aging passes. This probably
>     isn't needed given the change I made for (1).
> 2.  Fixes the expected number of pages for guest page sizes > PAGE_SIZE.
>     (This is the move of test_pages. test_pages has also been renamed to =
avoid
>     shadowing.)
> 3.  Fixes an off-by-one error when looking for the generation with the mo=
st
>     pages. Previously it failed to check the youngest generation, which I=
 think
>     is the bug you ran into. (This is the change to lru_gen_util.c.)

Ya, this was the bug I initially ran into, I also encountered more failues =
after
applying just that fix.  But, with the full diff applied, it's passing, so =
good
to go for the next version from my end.

