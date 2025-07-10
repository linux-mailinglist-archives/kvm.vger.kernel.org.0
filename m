Return-Path: <kvm+bounces-52068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43F85B00F4D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EB6C5C4D1B
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 23:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3B62C031B;
	Thu, 10 Jul 2025 23:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ns11KrTg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEC42BE63F
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 23:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188981; cv=none; b=ecOSE56Hkeqdk4DduwcYszwv+9CR/4hnPl/PbpPMb86uQP+v6MBcIj/cxDKZudsywjq3iyZnKPS+6qvupX3wJobjTrrg/k5g9Gm+rHAhexoR6U1+cNNXnTUvI+55XA7rI35xfCnTFZm4JEvMvnTVSsFKAMeL5oNMs7SgPvc3TvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188981; c=relaxed/simple;
	bh=Imhpk93MYLp8xwLOAgb07FPvQgj67wyrPnSesGvWOhg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MFIsJ4Wan9DID1KolyZB3d/te84X0TLXjie1X6qythbiB/je1HaJfQjvG5SFR8qhfJrw4HuQ9aHTDW1Xjm7lwITyx7Nrt+bLhdJ9FIljkIhfdWBnLdXKi0Igz8tEuweJwn27xgLGaD1SdZiTCBlvQzi09Lurc89cBFe3ll9Al2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ns11KrTg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-312df02acf5so2099242a91.1
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 16:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752188979; x=1752793779; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vc4gFx6otObzph4vmcdpjljmy/wmOvcgw6O6DXvqQUk=;
        b=ns11KrTgbS08jYLZt5K+8VZ+5NRz62DB0uE77+Z4u36YOWMwLP9Dg6jIlWvZuYrl71
         bLyiNoCNVpYvSztVSBBea/HP9MPz/QkxZuDw4PQWcgyjJ5F3y/PLNmpNMoCrnQRUnkUN
         WK+SshohnLlOCDMwCv2+bvlUrUoKlZ1o/jdRAfOMb9YbmtB5k/AjFzpPVGoxTiOfBvbw
         LC5Ej0N8ITzSaDCRgA06s90pAoX3jf27o5Fglbv+DqI2WTc7i4tuxDq+JiV7xQ5CVoII
         cKmt4LR9fG9rnsSsNAq9gQ5P0ZjGe4nh3of7d09cML7K3UkGI3tec6sAj4TDoBE0NkC7
         ynZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752188979; x=1752793779;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vc4gFx6otObzph4vmcdpjljmy/wmOvcgw6O6DXvqQUk=;
        b=jv9DkpsTDPL1Fc7Lc5bfe+mZg9olcLRlS4B9NjOdX/dWh3Cd6Um902iyev1Sy+e+cZ
         AwpOFX4acQhCdXJoVGtu7J7NFplf3BTQ5Hf9Xr4w7WAdXSolDpHWJsrCLsXkLBMV3YYH
         2Fx6ACGUrLrkMNKyjCcB3wXNi0aLwai93+Lil0e+EIw1gATVq7W+8tmTHFtmFtUhfBL+
         zidf4n3ej6Ma4OnpX9vyJMW6lBtcRqSSpyhPU/moxKo/MHUHHmeOvK7D9kad/k0Nx8e/
         UYQyXKianOLPAMDi0jkWLL69dDuXYb/LEI5khhy9uq04khUF6hh0/gUZgSF6gh3XUOMR
         Jbcg==
X-Gm-Message-State: AOJu0YwTz5Iug9TdaPNGezNXx9vieHCLA16bHr4x1Yr0WEzWrJpO3h//
	Tj0EZQ/ys8nqS8Ks4aiqatcMZCHiKqM2hR1eUKOzyrb5aSHGy1DT5MOXspVAmjldzHLBFflUQ4f
	5THkUWQ==
X-Google-Smtp-Source: AGHT+IE+dyK2d0uR86qfpkwgq8AVI1vUVbhbMbwUukxTkGUUqxum4AWqrZhpfpFloZnZbssgldsJ/GbSzP4=
X-Received: from pjbee8.prod.google.com ([2002:a17:90a:fc48:b0:31c:2fe4:33b4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:568f:b0:313:d7ec:b7b7
 with SMTP id 98e67ed59e1d1-31c3d0c25b6mr8663625a91.13.1752188979183; Thu, 10
 Jul 2025 16:09:39 -0700 (PDT)
Date: Thu, 10 Jul 2025 16:08:50 -0700
In-Reply-To: <20250626001225.744268-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626001225.744268-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175218136720.1489574.7636607289998193683.b4-ty@google.com>
Subject: Re: [PATCH v5 0/5] KVM: x86: Provide a cap to disable APERF/MPERF
 read intercepts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 25 Jun 2025 17:12:20 -0700, Sean Christopherson wrote:
> arm64 folks, y'all got pulled in because of selftests changes.  I deliberately
> put that patch at the end of the series so that it can be discarded/ignored
> without interfering with the x86 stuff.
> 
> 
> Jim's series to allow a guest to read IA32_APERF and IA32_MPERF, so that it
> can determine the effective frequency multiplier for the physical LPU.
> 
> [...]

Applied to kvm-x86 misc, with the thean typo fixed.  Thanks!

[1/5] KVM: x86: Replace growing set of *_in_guest bools with a u64
      https://github.com/kvm-x86/linux/commit/6fbef8615d35
[2/5] KVM: x86: Provide a capability to disable APERF/MPERF read intercepts
      https://github.com/kvm-x86/linux/commit/a7cec20845a6
[3/5] KVM: selftests: Expand set of APIs for pinning tasks to a single CPU
      https://github.com/kvm-x86/linux/commit/e83ee6f76c33
[4/5] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
      https://github.com/kvm-x86/linux/commit/df98ce784aeb
[5/5] KVM: selftests: Convert arch_timer tests to common helpers to pin task
      https://github.com/kvm-x86/linux/commit/95826e1ed359

--
https://github.com/kvm-x86/linux/tree/next

