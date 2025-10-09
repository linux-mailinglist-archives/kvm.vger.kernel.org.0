Return-Path: <kvm+bounces-59743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC320BCB26B
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 00:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF9AB188DB95
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 22:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE66D287250;
	Thu,  9 Oct 2025 22:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H7istZyj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E46272625
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 22:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760050548; cv=none; b=AVz7PAa7Lk5y6j3HtaNf4gdiPmM9Vt1vgXlYYV5ghOlt2YPRuTE6+sIflIxFH+FtlQwmLKw6K5YYsWjvaojv9mbxikCq4ZzckJP25qWe4kkA2YnZic/0PfOO45Lt88YCa4YavIbgidIIZUYlv28i6/t7ur8fdwaxJs+J+CaD2rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760050548; c=relaxed/simple;
	bh=L/uOVVJxa0Vjg6Rg2XdGp0L24W+XSU7os1JdPoYNL4g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sb+lTNaQQ+uvzTUyQRSQOdGSsZXAEUaTdep3n2xLf87ZPHx4HsdhezK4TgjiC1KWdsOcS39lW3kN/BsKJhK4TJg7t0oXU0u4hEkIqqlrxnrrkn0WrYP7HtkxBq6gPRNvpLFkyK2X85xjr3E3zs7UI3l7TAdoQnhdqwwLawXfPiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H7istZyj; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-634cc96ccaeso2056a12.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 15:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760050544; x=1760655344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/uOVVJxa0Vjg6Rg2XdGp0L24W+XSU7os1JdPoYNL4g=;
        b=H7istZyjCwC4HX/3Hb5ocNSI7PYwVdrXv6xAeOLkMTiy0TKKnoazdqbwXK+TwCEtdj
         w55fmlu1j+lElm4orYUiHvECXPulmvkYoW25nAJKAdRoRdp2nqxMLyl3cXTZaVFIF/NN
         9oWKchkSrea87fwv6JAOGT90/0fzmIrld0aIOt54TYo2HimvSqN/kkfxQvExqicsbdbt
         9t+1PSOCjqtIp8UU7m1HWt3V0hkEx4gyR+CY11Z6tnnCPI/RfpnYhaeXyCeLia2fDNR2
         s1GpLYvFFSkRV4PR+EFPpv0hmsFUCUuRHggVcEXTACgL6anSoceS5QjUDE9opwsCckYZ
         MXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760050544; x=1760655344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/uOVVJxa0Vjg6Rg2XdGp0L24W+XSU7os1JdPoYNL4g=;
        b=FmoxswermPWvm0obH5e3ZQFgPa/uM7R3DMojqbmoCAFVvK+nciDHmDjXlFtwNRupf/
         JX3l3KzD20lV/PBhNKz3ueKbethPXNxEuHr7cjYf1xn//BMbD+fRgCxM+bxWP8MChGQT
         vOyMuC/CSzK69UeAfI6ww4rkIm9VH+Ji6u9a/c/IL2tuksAf8etPv5qwbEfqS+E+Qbm5
         KDg+bz3K+p+sOpI/1xENyO61QhK+PDBzIquROGc3WQvaPMOGVbwz8HaxLyq5bX8zSlKm
         rbLbgdAw0uwzo+SaMUuEQ1FuYqqdQe1VFZPm+j50ipdx0EYNVkk5wL0TVFrXaJbN/fGH
         Ioyg==
X-Forwarded-Encrypted: i=1; AJvYcCUwjKzphSLxw1aS7zOojFpJbruKxEi+2c3BLzgodaLYuB21xEYIINlb/WUleHGOtwWzI2Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrMM5s8RNkXdHruw6RC1rXDR9oxRmg6dJAL3DbyEpaapN9Oh+C
	1A0As+m//2tzsuQJpFIXOfgeJGJgBlUZ+4XlvUAEiAwzpHYeGRsaHVj63JON4qf7nJWCwTiyWFm
	C7Gb7MuarCf86GWBVl6g8kIuEApOFiQqZfUgQ/7VI
X-Gm-Gg: ASbGnctR9rVcThFtLml3W6gFYrK10NsntYHyiUlvp3Udb/6V5hlmcTVf5WjQ5J6KqxF
	+/DO31Y74/CcMA+9yYNFGjRMMwrS7dPD4qvhVLsp5BOEIWw2vBmxZXsgwQCR8OwHns/w27AfQTu
	Lg8lVYdOy8SR4h6ova5UC0VelRjrd4Y8BqAWlx6NvYvIJ+paR9oLsaMXNKnxHfocxzqnckNZhu7
	6QeCi1CUQZ1/yvmF1JKaXGeKSFSliGlYtJmVe1lki5xcJ8X
X-Google-Smtp-Source: AGHT+IFtEIp1lPIe1h+vRaxhMKax87qlktoQDl5DPpMmr89GoDxH8/qbNe1TY3lmDd/nEtpZKLV/ufs5dB6mUjMCM60=
X-Received: by 2002:a05:6402:70d:b0:62f:c78f:d0d4 with SMTP id
 4fb4d7f45d1cf-639d52ea25amr280278a12.6.1760050544364; Thu, 09 Oct 2025
 15:55:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-6-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-6-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 9 Oct 2025 15:55:32 -0700
X-Gm-Features: AS18NWATDdsUyWZvLc2joY1-sJnSzc9Iy__XCFHTGQXE8gB6pObIfutGF2HxCok
Message-ID: <CALMp9eT5DjpTy_UcU_99uHjSWymk09riWePTCzZG7RyHb5KFUw@mail.gmail.com>
Subject: Re: [PATCH 05/12] KVM: selftests: Remove invalid CR3 test from vmx_tsc_adjust_test
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:02=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> Checking that VMLAUNCH fails with an invalid CR3 is irrelevant to this
> test. Remove it to simplify the test a little bit before generalizing it
> to cover SVM.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Is there value in moving the invalid CR3 test elsewhere, rather than
just eliminating it?

