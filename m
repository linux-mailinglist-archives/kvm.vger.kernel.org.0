Return-Path: <kvm+bounces-68166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA08D23577
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 10:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B801730B2116
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 09:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4BB343201;
	Thu, 15 Jan 2026 09:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y+TIzgsj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DE832E6BC
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768467791; cv=pass; b=XrD/osIht3nBWeo0R4O78QeU8U1dC47LGDnqpGaYydE0bNsxJJk3XkhrctF7gF0E/BcyV48pjIRUkgg3eeNMtCBZCxHXx4cHxHpv6pg8jx4Ds/B4cGEfpzfJLfMu0aoQFgqArDUZ34LNoNmAWCQqm+n9EpYRHTl9u5xFh3Y7wBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768467791; c=relaxed/simple;
	bh=03g5GHo7VUuroNdnNffpeJG0qnrQfvR4X6uMf/z1OKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MqwlZRNoT+D/XX4vzuuj2yUd7aFPuG2S3eyPJUfZbOi5liGhW4KGaeoDERi3c79wALN82CoNFFNO8kVBvaAj1hXGz42VfA0zng1AKTH4PEBJxjT3I+60Za26C+DAwvhNMyKQCod7+ZQFpz89Obqrtmvl+6JPTmuIoaZeNqTKFh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y+TIzgsj; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-501511aa012so446331cf.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:03:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768467788; cv=none;
        d=google.com; s=arc-20240605;
        b=ZcPQdq6+zXkNR07SMF6Rf2TQi26x0tiO7w3gf/BIe9h+a18LW5nGJgMHtWMnmch+/W
         L5BMtfh1IAQKWa/vn7f/5Dg9kP9T+fC50OOggnbjKAvJlGosjznTRsL1V1PhaWVC1OVz
         GKPVT7041iISLV6aeul6uAUREMfTAGPmQOsM5rp/pEO7Qor3stpgpIA5+77VpfhfMDT3
         b/1ri9pRAIiThfwPIT3Iq8Zy/TUJj2m4szkPJbAFx/B9oIxeApOBpFmoyKqwUBNacgbe
         ccefeJzY+p4byvI9bswbUdtok1pIgj/uCIA2pogmkB5mF4XqQZTrwyxCzuch12jOWBVN
         1Wqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jaHTBHlKT0XpapwOdZ2HklxNZ/MZMO/Ynn29Wqw5zNk=;
        fh=eHwPTZIhX4yd403juZ3wCQwnzWlIHToGuzcBasrMqSQ=;
        b=JQhWVuVL7jAbNrgm+0TcK2WxxVRs9z0VUhNeUEM4MGc8/zlhBm9gOJ/DJZTmraLwbF
         F2dmHv0Sf9aorxZk9lE+kHdxaizj4EHoBUhQcohNZNimWGPhfPcIhug+8l9KDaRnqYKm
         QwzxqHvdyLD+aPKi6rbM5L7LVdw4Zq8tPkhHe3X8a0vqEtpZ3WCxlyF6tgAI3WEXO0eE
         l+ygAHcWBGhyPNvISOTwRq5COTCUFnjsTr0rmzheS1+2Zrz0NgpYh8mXZCttHDKjA/Hd
         gu3IhR3uSW0PrVRO9+aCfaLg+cesNOzwLWLcJdeVeBDroTN/MVZZJ5oVzEpo4npSuK01
         HUoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768467788; x=1769072588; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jaHTBHlKT0XpapwOdZ2HklxNZ/MZMO/Ynn29Wqw5zNk=;
        b=Y+TIzgsjwX0wqyLVxHk1V9ZPIbOXuA9OZSYYibpJez1wFrkQujaRFOo5p1sGkl6fgj
         LU6bpaiZtR9+7pL1gjOyJyuMOP3+ihoibFETGmuyNoIdjWuuJMXbCyr4Z0P90eaN3eQB
         h9hvaEOE47igHK8xd1x0aJZVoURBgg5zQ7CWNpwwoIkD6AXlhTuUDHnNPS+rm+VV+NH9
         8rZx9qCAkzjg7MVA5OjbSq2lhVvt5AN48pR3jVKYjqHQbBmAnYwClOtgLMh9YaWZ83Ui
         JF5XEiFMQsi2pbet37O5LZz/pNq7yUnZnGk3uMpUT9MGOrDvvI6oquIOHZwLBBodRCBc
         rtnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768467788; x=1769072588;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaHTBHlKT0XpapwOdZ2HklxNZ/MZMO/Ynn29Wqw5zNk=;
        b=TP3HtgKoBNdLqUqY6mJwODFgBLG1dzeKg0FP0pD2TIy1HLNtiJowU+W424bQC49CpC
         O7jKa+cjAo2ozf3VlycI9LiRgIiWuHNMX1DBr6RGnc9aWu7KkyrH3OSXhlKJT4KamGtA
         26O+2KSypJ3bfQU149plGQiR+hXKzrIcmcVE/A7Jns9Y2yVLa2ksWTchEYWc+s9oBbpK
         cpea/Iz3YQHLu3hdKeooh9p+IIJdZGtMMYbm3bwI5s/X21hRNUPyu+haXmClM2L1Tab8
         Y3lasV9SN52/nyn9QKSw8CfsS98QbjOWkPJ9Kk8uEac6ISM06/O5qsdeek8GfQKpqAGy
         aEIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAQJHo75O97PNlZHF4vkaHUlVWqflfP5urwKFF6Ey5hAHWh+lvfFHbW1xyDmn6byAykQs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc4Zug/MCaGjzQJ/Y3nyeDc955T2pO25N3Ekur1DgIY7gFRVO4
	uZU+Fl9rLjBPgjE8S8txzImQ5pZ1c7Rnym7jgbF7oPNxyxHf4FOVsBrOAGy7BA2btRFfAz+RiDg
	wWCizzI9M49FUwUjaqaSkXmqab5I1Np533ZbkaZUX
X-Gm-Gg: AY/fxX7UJUSCamzW8rcm7VtT2jD0WzrWmc1QByxXTF0W1P8FiowVL8gOURXSxFdvyO3
	FJukLPlbMztNT/vgtgU6yhMdfL9tiI7E6+QNTcegcyTLCskofRPBirGBpGX+/nCc8q8NvoCeWuG
	mH22xEEvwswsbQgvG/2N6duSQiHk4rRkom8k1DGDzrBq7Duhjq6uSg37tyqAnEumqWTP7G57Fuh
	8EffFFdcwCeP4wkocHePPqKB4ufug/7FQ74NVv3TR4vu+KwyLVd57YFzoKI5CiWice9N7xF
X-Received: by 2002:ac8:5dd3:0:b0:4f0:2e33:81aa with SMTP id
 d75a77b69052e-5026ed4f925mr5343061cf.11.1768467788106; Thu, 15 Jan 2026
 01:03:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-23-8be3867cb883@kernel.org> <CA+EHjTyYcrWwBR0AwwdWFfOSwbmTMOhSee7y_-vrMfOxphrvqw@mail.gmail.com>
 <5a053bb6-5052-4664-b0cb-f05d56d4679d@sirena.org.uk>
In-Reply-To: <5a053bb6-5052-4664-b0cb-f05d56d4679d@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 15 Jan 2026 09:02:31 +0000
X-Gm-Features: AZwV_Qg4xCZRn6ebTpsQyf1oiKPYkQGhv7VLsovgzCpdoBOU9QpCHpXoiLQKrWU
Message-ID: <CA+EHjTwMs6BzZwtcNjyZnxLb9Gs01B1RcDvo1RB-f2w98eMzFQ@mail.gmail.com>
Subject: Re: [PATCH v9 23/30] KVM: arm64: Context switch SME state for guests
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

On Wed, 14 Jan 2026 at 17:28, Mark Brown <broonie@kernel.org> wrote:
>
> On Tue, Jan 13, 2026 at 02:24:56PM +0000, Fuad Tabba wrote:
> > On Tue, 23 Dec 2025 at 01:23, Mark Brown <broonie@kernel.org> wrote:
>
> > > +#define sme_cond_update_smcr_vq(val, reg)                      \
> > > +       do {                                                    \
> > > +               u64 __smcr = read_sysreg_s((reg));              \
> > > +               u64 __new = __smcr & ~SMCR_ELx_LEN_MASK;        \
> > > +               __new |= (val) & SMCR_ELx_LEN_MASK;             \
>
> > Similar to what I pointed out in patch 15 [1], I think you need to
> > preserve the other bits, since SMCR isn't just about the length.
>
> This does preserve the existing bits?  It reads SMCR, masks out and then
> replaces the length.

You're right. Sorry for the noise.

Cheers,
/fuad

