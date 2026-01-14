Return-Path: <kvm+bounces-68016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CC667D1DE56
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 11:14:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BDA033050180
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 10:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31C038E5CC;
	Wed, 14 Jan 2026 10:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WS2mfg6M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E380238E124
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 10:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768385349; cv=pass; b=DJPejSiqNmLx5dWpxDv+M/i4UayE/KH5HhAX6kaeVeDZLnNacnONcmzMpgt1odH8WFvI5G6v4m9t7EKn1BxMnS0jHcGKUyjW02Jw4iAgmOdKFX2ObHABwHB9upkq+SNPr/lE4Awj5hNhhHrE8upTIFdAYigaqMcnmKgHNV9mz+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768385349; c=relaxed/simple;
	bh=cboAZC/N7GAkgRpHFH255dWg88gOhZq5k/rXBB7Or3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t0M2jV5KYFK/f4yZ6WC1NFB/HqeW1r1BiaBDwxxZBwD5N5iy4/WQd5sukq7kso+2aRpPjImIdVeZuf79g2h28bznWKG/9qhL1kG2bcF5pHaPn30H9HjV5lobdfOPBQJbITrVrs6MGWwhm0v7E1E9Xc92Sk5FNZHui2DpGfVM+XY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WS2mfg6M; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47ee0a62115so41595e9.0
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 02:09:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768385346; cv=none;
        d=google.com; s=arc-20240605;
        b=L90CxsfnkqksXW4oO5H3FJU503AXWO1dnZ+aIvrY0wcFcrcPnw9G4xeqDX21Sj5cft
         Ccd1fI1zfgGEwX/gfSIA/RHdgIT0IvscaZXZUe5gHVF56uWxZteZ7NPZ8OpFbi5bCY3P
         Z/xBerYaFSYnmVwElL20NAS+D9KBgLzMhd/tIrwzsN5e5RCXwgA+5TILYsvq8aWIU9Qz
         Mvly4t+oVfr9fAnRLwbDb/MAwFLCkx2h2+WOc8KJHblwSLpkFr6PYKKWeKTg+4rv+pfJ
         0GubOIVJc8hWIV5fVSftXmoD7uk6gWOS0H53MYCwqi/g2D4R5iaWFozrEY5YMseTj8KH
         F9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9I9WuN49vDzL3jcHM+WJ2QBCVFtv9a9q6bPtMasJkpo=;
        fh=8etLiyskVPImz1po+bHavzZkBDs9SeZ1tapHsbg/m+k=;
        b=fYAh2zSDfOCPlVH7/Wt5hDFpcPwOtcMgWcUEbGDkQlv8kN+B9xc7cpMyUB6EsUUAOY
         i0J6W7+TkPdXWGWCV7OFHq0hhMMUNbXsARaK+5q3szZkAGst5+KKGDwryMNhtNzS6eWY
         9JHFF3Hh7tNz65dzzZ/sLDZiZHLtp+fiwLbUixLHFn3J9lol7bCCqUZ8YRAc9XdzNLBC
         UzsJu/SCg8fceTD95YGre+e+7JUNSjYxQcEEIonroJWzHk++HbUIjOUyH43aJVPjTdjO
         gpQ3PYjtSDO8kAa9V+/LLMLkEBBODwowSQT3xR99uc3nxnQ8/PWJKE5yT3o76u0RYTTA
         1TIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768385346; x=1768990146; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9I9WuN49vDzL3jcHM+WJ2QBCVFtv9a9q6bPtMasJkpo=;
        b=WS2mfg6Mholga+XaO3LxfBMg4FKpWFmyqEjQVIGBvI2yMufZGzr/Zu8+5AWvMK8ALX
         Ad/onzJ/+aCIJO2aEgo7O+ERV2n5IATh74K+K79iZGECOP47UibHgfvnUkVh9JizeL+g
         jLFoIYs9Gtds0IVI6fPi9wIs1VXXlx/ORnzHPIW3h62xuJpVhjOF9flBxwf8ErzJ1si7
         UXFcyGwgA/A4KM05swg+8ZCw4GFY9N0tv7ReZNaSM1x+4sv/3A+Q6sB7Eu7hQfCLjsjn
         ULDhs5GwgqYknpkV9dlFWLvilm1NNFzfttr83OpFSwmMAEcunDmuQ81nuwsazV91iZ1G
         mqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768385346; x=1768990146;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9I9WuN49vDzL3jcHM+WJ2QBCVFtv9a9q6bPtMasJkpo=;
        b=hcHZOKgSsqR92LYnGV4y8VDf41NUOq1wF/64/XcT7SNTAFmlzYeqGOqjxfdIcfW4Vc
         Pt81bJZfdnmO4pjFCaf9WHBWx3fPCLffYIKYm8IK5J6LoWqy28CI3ctQ6oQ3XoVjOkIO
         MHlfSzklu6HVECp6C+NTnXjRZIKHev3TwvWFSuCDxCAreZwng3eQEUPhFN73Ys8X/2qt
         AP9Yf+VmKWVc60tKnaf0F15AoFElF9xN55pq7LV34csD0jvPzJmmqvfFq4a7fYtvhsf4
         CKeU4GM1po3eaNQd4LbNpgpnIZHaJLWIjN0yFGmqafC/NhIXRpNtMAePpc5huSDpH6Pe
         Zb2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVwMBEyAT8qiBJI7zJXdVfxJlvo3Q1kXxYYOZoghEYnvGlgeLtoXDYN7wyx5jeaEj6Z0Nw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyymynGf8L4JPNiJB3xbLyFN4LWopH9NlZf6DT08DOg1U0urtWc
	9CYYXdB9InkVcABiEw0TSND0Ig529hqZZy8lAI2tPwtIxENgX1XOsxp5EZOBlbJzTmsyyS7mYuY
	DOzjPgKBoxG0v5ARNXCnWJDd9plTyXrRV/xfu9AOG
X-Gm-Gg: AY/fxX4/ip3brx/IyoUDcniFpxBBHGD7liPQmbAkDKQcymE8o0X4cIT10lIqyIZvzsR
	XPGN1oeODbRBdqkxv4o9v+0grDebX/ORaPJc5C4i+SUreVWMmRy/rr1ZqvZsPPaAFakJCI/Dgl6
	lKmE5TUfbRZqQ5k+cYBbG1QDVdZGSRRaUKz5Xh9DYFq9fVsw13BLH3PWpBCuK7tThbFUg1oy/pl
	tCZeLwJdCQljtpREIzog2LjrczSxS0tAiYuxwYyqm6tVH7huiz9ItA28UGSv5INjKTHVLUXnSQP
	PEPXWXdK+u9zS4lgpCgJPSjR6A==
X-Received: by 2002:a05:600c:4c09:b0:477:772e:9b76 with SMTP id
 5b1f17b1804b1-47ee452990amr280725e9.7.1768385345996; Wed, 14 Jan 2026
 02:09:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-19-8be3867cb883@kernel.org> <CA+EHjTwQ4fLBE1YXoB6M0eamSgGDW=nfLaC+-_surBfVbh3byQ@mail.gmail.com>
 <6f0e94ab-7c9c-4705-a90b-aea09ca629de@sirena.org.uk>
In-Reply-To: <6f0e94ab-7c9c-4705-a90b-aea09ca629de@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 14 Jan 2026 10:08:27 +0000
X-Gm-Features: AZwV_QjZbcO1T13jUPtvWgDAfMEoLsYIn7-Rzu9SF6LWm46DZ1iruQdxKvCCi9Y
Message-ID: <CA+EHjTwJw0D2w3oGC_ZSJsciUgiACoLAcRQv+_QSsA_bJKYj+A@mail.gmail.com>
Subject: Re: [PATCH v9 19/30] KVM: arm64: Provide assembly for SME register access
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 Jan 2026 at 19:20, Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Jan 12, 2026 at 05:59:17PM +0000, Fuad Tabba wrote:
> > On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> > > +void __sme_save_state(void const *state, bool restore_zt);
> > > +void __sme_restore_state(void const *state, bool restore_zt);
>
> > Would it be a good idea to pass the VL to these functions. Currently,
> > they assume that the hardware's current VL matches the buffer's
> > intended layout. But if there is a mismatch between the guest's VL and
> > the current one, this could be difficult to debug. Passing the VL and
> > checking it against _sme_rdsvl would be an inexpensive way to avoid
> > these.
>
> This mirrors the way that we've handled this for the SVE and for the
> host kernel.  We don't really have any good way to tell anything about
> problems if things go wrong inside the hypervisor.

I know this is how we've handled this for the SVE, but back then we
only had one VL and one mode to worry about. The chances of something
going wrong now are much higher.


> > > +SYM_FUNC_START(__sve_get_vl)
> > > +       _sve_rdvl       0, 1
> > > +       ret
> > > +SYM_FUNC_END(__sve_get_vl)
>
> > Since this is just one instruction, would it be better to implement it
> > as an inline assembly in the header file rather than a full
> > SYM_FUNC_START, to reduce the overhead?
>
> Actually this isn't referenced anymore so could just be deleted.  It
> mirrors what we've got in the host code, we have to hand assemble
> everything because we still don't require binutils that supports SVE,
> let alone SME, and that's done with macros that do argument validation
> which don't play nice with C.  Even with an assembler that supports the
> instruction using a SVE instruction from C code gets annoying.  It has
> crossed my mind to inline but it never seemed worth the effort
>
> > > +SYM_FUNC_START(__sme_save_state)
>
> > I think that this needs an isb(). We need to ensure that SMCR updates
> > are visible here. Looking ahead to where you introduce
> > __hyp_sme_save_guest(), that doesn't have a barrier after updating
> > SMCR. The alternative is to call the barrier where it's needed, but
> > make sure that this is well documented.
>
> I think we should put the barrier where the update that needs it is.

That's fine, but then we should at least document this.

Cheers,
/fuad

