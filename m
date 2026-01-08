Return-Path: <kvm+bounces-67409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C83FD045A0
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 17:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 903583037BD2
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 16:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBDA22B8C5;
	Thu,  8 Jan 2026 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YUCD2KUW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D483C263C8A
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767889216; cv=pass; b=VjmJAjvfCXe4LPQNTvzNXCYfEqzh5jY+F1zr8aNjOTipe04YGjX2JjCnrd5ZDFByS6cIwn6kuf2r91Q48eKhqDdwDCzcB3OxyaLHjdr0AB0PDVEP2rlOJky/OExRdH6CYrfx3hs8vYwg+1k+ycYHomx2AGjC97GTDCSN3MZ587s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767889216; c=relaxed/simple;
	bh=PQslf1nBWkAECYlPx7V6ROJBsVJ/orbrweZgGpC4pu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cSoPEDfbRqKrGXiQcziQsun3BqK79mmePPxtpXFdHh4GXebx4dBW33fX5sUY5Puqcb0G1nbSi4O3+hhWqa2HiKPRWWSD5yiGBe1FPMlsGNrwCp4zYvGJck4GmD0/MZv9MVR73XgWJRn5UTntJMPyu6xXybYyjhp1ItePVWoro84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YUCD2KUW; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee147baf7bso1036141cf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 08:20:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767889212; cv=none;
        d=google.com; s=arc-20240605;
        b=cAbi2/aOakk7SVnsCCJA+jSddI6GwgE/bUEwGZcULdfDWFSrsn9G0uKi6zsR/tQWtE
         ll2dWz7Q1PBnb1r9Wr21DBudCUCjzUGXFf4pjoYUU03arYikqQ++ooXDebA881N+cxcO
         l134XkVL7OhXrTGwTvHfhW7iX+8oMmMOKN4mH/NE3n537aQSJidx54buxzMsf7OtmPRN
         Kykc+vl4Bo9ybAHz1XSSQxH4gFw1Yfaz6XNePa01kiAJ/RAB2S/M6ZHiNq5pNURJiHO+
         zJ4mAv/029PLcZXQXo1e+Bkz3iq0sUGG5W84PuS2n+d1bcQHOggFe0jcN9kDTIeShUIG
         ATsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vwmKkVXSip/S40O81aRXL9QdzJwbud5lWPyLOxwiQv8=;
        fh=48BTGyDnGixocY8Hti4VKZ+O6CG1I/HGCEqOoLsMceU=;
        b=DufpHTeHniN7KrXLqAmdrvMCAiT0jNFb+u7Yrqjj6TAXZuunAFFKOn/Zlj/JYy4MRo
         uHZO7Vp6+HumCa5PAZ82zs5i8ms1cQTzh7JuzoF1488iBlgFdjj8cXPsgSEvaGASybIw
         8g+5osw/8vqSbk+Te784vWKJQK3OdFmue01XtQj6ilFtNH5rGN4ocPa0RzVgydUl7Xjk
         iOLu8mbKNsvuy0Xgm+g7oi7RThTJcVeBBz5gYj0dHOjfqjSdRyXszJb1VLO2By5HmUCb
         2j2waQpkN5jHMD90E9Gu1YBqgOjAa7kp1/BErfwUNJkvkH1Fhm31bup7hF7IrFn1MlYs
         tJZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767889212; x=1768494012; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vwmKkVXSip/S40O81aRXL9QdzJwbud5lWPyLOxwiQv8=;
        b=YUCD2KUWQ4gi3ViEKGVqn8QQurG0EaBKakVjCsHQRFz9y+LnNHgek/2bI8KUQmufbK
         vWn4NH62pDYycrDT6R+DscBEBkwNG82FHoJIT3WNWMQwKWmXDx7VPPIu+NE8L+BKJJO4
         mtB/nZUZ5L9wjpV+pDntfH/g7w4C+h9rVfGbeorDaq4bQ5F3M2AyCEvLiX/fP/o9IkmJ
         xK2fQ0Q8TUi5C+PaX5eSnUR6ssKmgHuCKSYLm1XAnjn51ld1MPK2M6Ra2DUt1+wMFstN
         gyfgZbPrfrGwyHNHRRR4kl6EF/3G64Ol6b/gaQJgKNBk07tChniQWXXFW/+8Nus7j3zM
         vtRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767889212; x=1768494012;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwmKkVXSip/S40O81aRXL9QdzJwbud5lWPyLOxwiQv8=;
        b=m9uMZfQ2LCU+zg9axRzANdUwoK57QNzC2AzaVr63GSrmQh/ZrvqQ/5lHNxRjWk2Tbl
         l9tkHGPt2xYKN4OQlmqcSrbZX+3KmcVgcn1So3M7yT/Zq0lBEN3jVJBLo2CnkC6oI0nl
         OvgYF6owmw/2LrDNignY8yuAiudFSZd7rgjxKcUkVET1NJeJFxaHRYa36JNwC6M2LqSr
         znQiqhxMvQl/knyTzBC1MaqmhVp7o78H4HBSY1QnxcYD2IbtLy+FodmAhpJSby90HVb6
         0BmIy3B2OsaqdG3l3qilKaYPi/ZpLUqwD002Y8eLT2r/3Ucz3Tk7yhBT5yS0wVF4mfJ2
         ZLEg==
X-Forwarded-Encrypted: i=1; AJvYcCUMYqSX7LkGQ17zO77vv/xb95Jyc1/ijsaD54fwfBGr+QNELYNm6OQ4dFYfviFCYzgdhM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxndJAsy6MwxbXWcyZAJKv0waaJzJYJLdidxB9kfBN82YihPSa6
	EtWnIoHAjpY3P1r1auLXhwgc4iBBaqeSafbHDPfXerDqO8op0YbIfZx+11SsPO12lkUW47Rttrt
	b8Gg4vdFGDyGEyv/kjgsbQU+TWm8vG4rPSJA2qHfL
X-Gm-Gg: AY/fxX5OD0b/NBJEescx/UoIK++Bmt1DHHvOSs3H4lOWTwqemaJD7vR6TiorLnc/L7L
	sU/OxKzbPj05w7WOG/2dsdU73OFaxdzjN/xWbUssiWLqOL/EIoEt1ftpWO9O5U0+uv0bKxHC9M0
	Aqt6hgzddCqfBes7aZce2YdvEGlyS4nA++3kdgB8llpNKs426zJFLg6SNWe9t3Gm6OJghRHpfO5
	lGLZpjpNqk8PayxtJGzjWluIVdT2wwa4bllkeRD61OGLpu7sTUmEGvlU3o4PqbrbM3JdhYSPSdX
	S1EH1pQ=
X-Received: by 2002:ac8:6a1a:0:b0:4ff:c103:49f1 with SMTP id
 d75a77b69052e-4ffc1034cd3mr7852131cf.6.1767889212251; Thu, 08 Jan 2026
 08:20:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-2-8be3867cb883@kernel.org> <CA+EHjTxdSnpFHkm6o85EtjQjAWemBfcv9Oq6omWyrrMdkOuuVA@mail.gmail.com>
 <3c8b4a5e-89f4-47e0-9a5d-24399407db0c@sirena.org.uk> <CA+EHjTxLkLjPj=1vwDqROXOUXi2LhOQb90WP6dFaTiYG1nWovA@mail.gmail.com>
 <e50b4923-ee45-43de-9d4e-344546c635bb@sirena.org.uk>
In-Reply-To: <e50b4923-ee45-43de-9d4e-344546c635bb@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 16:19:34 +0000
X-Gm-Features: AQt7F2qnUAAJolhK9_-R6BxIXN3MEwPRzr3Wsfe1tbgWe2D8WrIhfrxwTrYHhW4
Message-ID: <CA+EHjTybF+aq2b2vhcEqi6U_sJjtt7ngzMZ9UcJ15G-Kqj=A9A@mail.gmail.com>
Subject: Re: [PATCH v9 02/30] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
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

On Thu, 8 Jan 2026 at 15:57, Mark Brown <broonie@kernel.org> wrote:
>
> On Thu, Jan 08, 2026 at 02:09:34PM +0000, Fuad Tabba wrote:
> > On Thu, 8 Jan 2026 at 11:54, Mark Brown <broonie@kernel.org> wrote:
> > > On Wed, Jan 07, 2026 at 07:25:04PM +0000, Fuad Tabba wrote:
> > > > On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> > > > Should we also preserve the remaining old bits from SMCR_EL1, i.e.,
> > > > copy over the bits that aren't
> > > > SMCR_ELx_LEN_MASK|SMCR_ELx_FA64|SMCR_ELx_EZT0? For now they are RES0,
> > > > but that could change.
>
> > > My thinking here is that any new bits are almost certainly going to need
> > > explicit support (like with the addition of ZT0) and that copying them
> > > forward without understanding is more likely to lead to a bug like
> > > exposing state we didn't mean to than clearing them will.
>
> > I understand the 'secure by default' intent for enable bits, but I'm
> > concerned that this implementation changes the current behavior of the
> > host kernel, which isn't mentioned in the commit message. Previously,
> > both the feature enablement code (cpu_enable_fa64) and the vector
> > length setting code (sme_set_vq/write_vl) performed a RMW, preserving
> > existing bits in SMCR_EL1. This new macro zeroes out any bits not
> > explicitly tracked here.
>
> The behaviour is unchanged since we're always choosing the same value in
> the end, it's just a question of rearranging when do it which is the
> explicit goal of the change.  There won't be a change in behaviour until
> later on in the series when we start potentially choosing other settings
> for KVM guests.
>
> > In terms of copying them over, if they were set from the beginning,
> > doesn't that mean that that explicit support was already added?
>
> That's a bit circular, with the new interface if someone updates the
> kernel to set some new bits they're going to have to update this code as
> part of that.  A part of the goal here is to make it harder to make a
> mistake with remembering what needs to be updatd when.

Fair point. If the intent is to enforce a strict known state and force
updates here when new features are added, that makes sense.

Would it be worth adding a comment above the macro noting this
difference from sve_cond_update_zcr_vq()? Something along the lines of
'Intentionally overwrites to ensure strict control of enable bits', to
save future readers from getting confused...

Thanks,
/fuad

