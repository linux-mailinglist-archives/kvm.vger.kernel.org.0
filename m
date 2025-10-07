Return-Path: <kvm+bounces-59590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E70A1BC2318
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 18:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 456E0420E55
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 16:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63DFC2E8E0B;
	Tue,  7 Oct 2025 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mTnC0+SU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C012E7F30
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759855851; cv=none; b=l9wprQgxi0tErvVhuCLThtmdNq6Q6T5M5Ycq1uLQ3Fnep+BLZL6pNdS1dySzpB1IJdbfhESs7CSDKvA/WhxclZG7hV1+7DclMPXQs63qMjdBx3wUMyeaUMjeJoSMJ1usuUHGBlh6GB+5PWNSIn6damvB3sd+o2bqAHmA3l8yykc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759855851; c=relaxed/simple;
	bh=uyGJ9wn5buBaY6MGmGBS4Gz7ce6hg5JCV9qWRna1FFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aLH74d3+IEv8H0KrgZjE/cEfaEpsoBh0XqHBLFivu0sKnv+ysXuVIy5xEs3ah55qATO5Az/a46DS9+cl5CwGRNBte09x0tk5/WEnhplNWBML9RGEFOEivDB7FClaGyToj3n3p+aBjuOjs1Bb5Wr8xQZcnI5beRTD/XhHGaG0JT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mTnC0+SU; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-57ea78e0618so7410316e87.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 09:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759855848; x=1760460648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qeZ4XDgQ6DyKwKqrcoC8/9t0LHZzFxjwDccZTjHFTaQ=;
        b=mTnC0+SUfNLD+Z3RWsHPWEZida4KlnBnJZE4NsFeX+YbAWMYSm8a56XPOl1rxaRg4v
         f16cKvYMj8aWID+yAt0M9JWDu78WEWz3QSrxiK5EeqhKYIvMfd9rL9LeUVSXq5zqzFea
         meMEx1w1PmgA/rAi1ZzqUWWNe/53eRibjLtFLGOWJsU3LlBYfppNsCUCl2iFAPc3A2DF
         Lis2T18ozInqDMPVcepeTZQQvNHKX/IjfYXk9Pfn9Sj2rpy9WTN4fznHbLLuVRH58Umt
         phN44Jmk+GAA2UX0sndcR4HsF8Ddcd7wki/YfRfkwj2/CQlK00116lpPm/eASI8FKtgv
         90/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759855848; x=1760460648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qeZ4XDgQ6DyKwKqrcoC8/9t0LHZzFxjwDccZTjHFTaQ=;
        b=Xv5CdjHArBWGStgOZJvB+mlZ0LqOYCgzXm61vFyTGWg5CPHyg9B2rZZD5PG+RPAJxv
         FhDjWgkZox+KADRPpYkuJNzUEEbXp0f9+Nhd9YativitB1F+uRXm/IqCiIDdciqIgro5
         9+1Z/L14Awm8/ua+6CG1IPRGaCirtJ/Cb5jOgt5Z0L4nCnL6XD90KeVaKUtHVRlyCmKw
         4P0E/9XiAz3j6Kx1odc1frUQlBfMQAe5o5fOAW/OOD5RvKZsn0Lf2M6z3gn1Up5aFiuB
         GruA26RFXrCxpeaNkZiQqfp8e9QWiSMmaZEGOTb0rj8E21TWUMcxpHUyvXt6liZYn0p9
         7aUw==
X-Forwarded-Encrypted: i=1; AJvYcCW3yKMU6k94EGrcMLysu9CpSVZnx28EUJIHZ1lDKVWQ8uGa+ZHqbA/raFxM6dT+IzdR0G0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCk9kQ7ZxEnnMIrYkhVE1lqjq7rtr75AiaydeVonhVMNSnGyFE
	h3+DO7zWGk00VNlM2xBiYB3R/DE4fSRRAb0c27ByP1e3T3PoRlZ6a6O334fe82Ep4/NWERDdLfk
	o9fVks6oU2Jp1ADahUjqtoS/nihg2Ep6dfE8jyWRt
X-Gm-Gg: ASbGncs3JRcVoSPSliqCLSC9ce1hPKH1W4C8A2zocWMtNrVJ5EaOyM+aGXw0nKzwVgd
	7/g6okh8YYlqCgHWvS5s+EDQVb45Nvve6A0z/mZO6SY49Mdk2omgIqExGHVu3PKk8/ePi64/BmJ
	4OgUfxZNq9ZSgP/KOj7SouBaGAqQbUMh9Z6RYnqBcs99XduQgeoZ5Veao9HNJHYiI155OurBNEg
	RKwszuf0qdWMOD7AfLAlF2OBd84fn8uerp48g==
X-Google-Smtp-Source: AGHT+IGlJgwQGEf0vzt0iuMqZ0Q/3B5wNSB8RlWM05q8qkhQUfszu75UfeZenkZMb/XBGK6avKY5JjXuhw+68Fb/I/g=
X-Received: by 2002:a05:6512:3f02:b0:58c:787c:5f05 with SMTP id
 2adb3069b0e04-5906dd7ada3mr121303e87.52.1759855846077; Tue, 07 Oct 2025
 09:50:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250724213130.3374922-1-dmatlack@google.com> <CALzav=c0Wgcc60_dGJuYffS3f3vD9mpdSjFguaE00L1Zr-YcbA@mail.gmail.com>
 <aOVCmIu0Dv7vJ0M5@google.com>
In-Reply-To: <aOVCmIu0Dv7vJ0M5@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 7 Oct 2025 09:50:18 -0700
X-Gm-Features: AS18NWCMTjd5Ianir1w6T399jrV8GYXPXDvKsIysDv-DtdU6jZCzve4cer1YDyc
Message-ID: <CALzav=dH4F0_pXTBSkQDMiog2Y-=7VVyHYUW4s01uySaLY=XKg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: selftests: Use $(SRCARCH) and share
 definition with top-level Makefile
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 7, 2025 at 9:40=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
> On Mon, Sep 15, 2025, David Matlack wrote:
> > Google's kernel build tools unconditionally set ARCH=3Dx86_64 when
> > building selftests, which causes the KVM selftests to fail to build.
>
> I'm pretty sure we can simply override the user.  Does this fix things on=
 your
> end?

Yes, that also works.

