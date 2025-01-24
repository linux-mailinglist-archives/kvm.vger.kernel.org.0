Return-Path: <kvm+bounces-36476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78847A1B38F
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 11:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E51501889099
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 10:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66AC21CDA2E;
	Fri, 24 Jan 2025 10:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DKX2h9sn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572F11CBE96
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 10:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737714889; cv=none; b=S1xepyuLAqWMx6B7ivp6LPZ3Z3JplaGrZNSQ3sn3PXfy3XkE22JtQVrSp6rF2T9HOKsgpOIea9HoZmND/hFM8Cpk/3SYzPEOKHe28ptQAovQXu4K6fe+XFCuvpWU+Qw9DxZq7sDMNv/+frXZSFv8rpvB2nqiUZ9H+OvufLfxZzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737714889; c=relaxed/simple;
	bh=iWynrhvbUS8d+nSbeipDlBxH5Cu/xySzyWMGej610+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMbr/1VhZEnF7maFLWQtDsdUhkew03JSg65X681YMpQkBU1SrUqbbYmvNBgU10i9UoyhSZLzBLHf6JECRJy3UDQV/JUHyOPeqj7OusbAuw1c07OP4nhoUVh/xDsvAAfzzSTy2BzLyMK5zLIUR6YOpS4sDdK1Fgv3ytC7p4lS0B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DKX2h9sn; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d3d0205bd5so2934843a12.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 02:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737714885; x=1738319685; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B31b9Y659amBmFooYQKAN4Prn/GzJR6jzsnI1L+WT24=;
        b=DKX2h9snw20zeiYJKYXK7opx3T1yRG76FcEoV9pkfb95huba2ep9zYcEmaAvOrBVdh
         ioBq5ccxRvjrlKqGFvS1hB3RS55+kCUL/Yqv1z7S9TC4v73ZQPq+S5WwrC7RjgVGFEvM
         VPSMbP3nme5HJZLDUK9Iq3zvZvkcXWwqmp6Zk+CBMzrEdcWljIYcy+55XKbdeZZVYMXK
         nH6WZ8cBEMFVP8BanHCMhuAlS8Yj+sCSCK4Fw9Wy+Ys7OHKNa7+/uxIXXaQaV/5v0fnk
         RxNA0We91UDxdngFVmnnL1K/AH8rpwIoVQX1qf/Q5nzJ24mUo5vyKtrd6KQAYyTKpTb9
         cqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737714885; x=1738319685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B31b9Y659amBmFooYQKAN4Prn/GzJR6jzsnI1L+WT24=;
        b=OaV/5CW6xmbHNY57e7YmV3JOD4QY17zUztf3ylxPkY0RWu9t3ODihOOoHOSzNGwvD8
         OX+HMDMVSpVimvyS/B/Yd2hXcD85inWcA73t6diG9FxwQNLcnjuCzNbstE0W9eQApcNl
         LGb3UMOtoskXT2nioAZVuVV0Y60YGuUgX9/v3uLx4fptAExZ+jvW4wqLDQzO2jqOVhhy
         SRFRgE6HIlJ9V/mtdFqAx7mCQa5GezqGMgRKD0WRU5Q5aMV3ckSw6V6n7hnGNyYgZ/pp
         9koUXuGpuyoUOcqt7GmGpQhAC9/LfM3EoFJGBrFoKUvKGUY3tywK2bgvcGNJHUHTcy8k
         91WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWe/2zq7TMTiE/ThwvIzm+ooF9CsnmZFiVLy2U0Ptj2nmbSKzgRg87SosX6GddnY45nNSo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCbsKvTyw0+2+WVJjdxY2LxQHbhtrGYc96zz2fNT0hWfvI/FC0
	xdmu/DYZDcXtl9+Sc2pJU7YfJf+Pp45S3P8HqmzoWPBOd5q6wVZKkA0hEKSZzVSyU0jEDmMpxI0
	t
X-Gm-Gg: ASbGnctJ+8NJcIfqp4LjdNmHlSnuyjoGCgnjc9ZefhCQs3UVQ4QXsHAYSSM0KH50TwX
	EzeVr60X7j1uoISxayOjouiP5SutE+pX7xdYLpsV/hFf2EqBLddimgg5RA9JuN110GAYVOSYmr5
	0MNx3JDtpn12oI6lR+2swhI01o4K+oi+01irVYDvO4Buj73RaLp7fu+fxsoa8Nmlu4vpL9nwKZQ
	Quk7riN6ifKfVCrrrebvoimSFn4Mb+SxmPvXiCaPYkBs+GjLUgNN+a0wG5JsrSCQ95Ohq0P8mWF
	KdlVSZj0VDBBMhv1Gw==
X-Google-Smtp-Source: AGHT+IFXCnE8T5cmgu4AW22jmvnHh+DcpBUmHRTJZ7Eesk9QHxjDz469A1QWt0feqZoYCXhLtg7LJA==
X-Received: by 2002:a05:600c:4e14:b0:436:fa4f:a1cf with SMTP id 5b1f17b1804b1-43891431697mr274493395e9.29.1737714874742;
        Fri, 24 Jan 2025 02:34:34 -0800 (PST)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b1cc8151sm60902565e9.1.2025.01.24.02.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 02:34:34 -0800 (PST)
Date: Fri, 24 Jan 2025 11:34:32 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Sean Christopherson <seanjc@google.com>, 
	Yafang Shao <laoar.shao@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, kvm@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [bug report] KVM: x86: Unify TSC logic (sleeping in atomic?)
Message-ID: <pfx63yk5euw6zsjmmpuetfuhhk7jcann3trlirp6y5u26lljn7@mtbwoswzoae3>
References: <37a79ba3-9ce0-479c-a5b0-2bd75d573ed3@stanley.mountain>
 <Z4qYrXJ4YtvpNztT@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wdbaqrovl7nilhrc"
Content-Disposition: inline
In-Reply-To: <Z4qYrXJ4YtvpNztT@google.com>


--wdbaqrovl7nilhrc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [bug report] KVM: x86: Unify TSC logic (sleeping in atomic?)
MIME-Version: 1.0

On Fri, Jan 17, 2025 at 09:51:41AM -0800, Sean Christopherson <seanjc@googl=
e.com> wrote:
> That's not the problematic commit.  This popped because commit 8722903cbb=
8f
> ("sched: Define sched_clock_irqtime as static key") in the tip tree turned
> sched_clock_irqtime into a static key (it was a simple "int").
>=20
> https://lore.kernel.org/all/20250103022409.2544-2-laoar.shao@gmail.com

Thanks for the analysis, it's spot on. What a bad luck.

Is there a precedent for static key switching in non-preemptible
contexts?

More generally, why does KVM do this tsc check in vcpu_load? Shouldn't
possible unstability for that cpu be already checked and decided at boot
(regardless of KVM)? (Unless unstability itself is not stable property.
Which means any previously measured IRQ times are skewed.)

(Or a third option to revert the static-keyness if Yafang doesn't have
some backing data that it improves generic performance. The robot [1]
didn't like the fourth patch but that one actually adds back the
complexity guarded previously.)

Michal

[1] https://lore.kernel.org/all/202501101033.b66070d2-lkp@intel.com/

--wdbaqrovl7nilhrc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTd6mfF2PbEZnpdoAkt3Wney77BSQUCZ5NstQAKCRAt3Wney77B
SexsAP4ugnX7bR/8XSgs20T+ONn61L0Oj0UHwNeehd/UCvCYPgD/Rexjc/v9SuQj
nEkFpqrRMLlmqMLpaCOvyYn+vzrjPwU=
=/y46
-----END PGP SIGNATURE-----

--wdbaqrovl7nilhrc--

