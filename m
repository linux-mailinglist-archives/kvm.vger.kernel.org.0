Return-Path: <kvm+bounces-43675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E711A93C82
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 20:03:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8508447BB4
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 18:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D127223328;
	Fri, 18 Apr 2025 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RNkVP7Ow"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E6C22170A
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744999402; cv=none; b=h3sUc40LKK8TvP2HxlnmW0/PO8yArxMFw2YOPIFlsYCmfMCBFNL8/zNtXdzfoW2i1n+1qr+lLTKf5RVv7YOJfIHndCMRhZ7uYg12U7FlOr5F91nHMLZUE8KcoFAzctZfHFPO4Wl2c9GPTiUitnOrklGVbQvyQ9lqFwMQDtUKD0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744999402; c=relaxed/simple;
	bh=1YG7DuypvUO2eH+ZtNma3tnBVmRMdQt3rkXfWDkxfvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FA39MgEySTmt2pd+fiMnYYM//uPD368+xdKSAhhEGV5jzmW+K9YVWaEP7bWKyviuDH8KaIJbLcQ78VqbA1lH9IZOUyTnV935X7arUTfndlQ79XMq/8yxA6ROyBgAI8jyDp9cU+FjsmAJfK9W5xCvQ/bZyAoHbIjYlsqlO3EK3o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RNkVP7Ow; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff64898e2aso2574367a91.1
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 11:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744999399; x=1745604199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rqJHg5UYMXwn+mNlrL5oxyZCVbhJU0UNvh0766Pzt3w=;
        b=RNkVP7Ow+ZXf59m9XKNn8w8xsZoToQ9upST6cMiOeg357tp+4V3UgTNM7DDO/zqvbM
         QpGArvz31DMfOloWu8Hwslnxblsy0pioclQHvuI+jyaO5mzJ3pmHSPDN9uxai/PpHFhK
         2Mw/0XjFQv5PRqwNmkei0Fc5hhwZG5T9wIifLN1zNPA2TfwaHVAV+WalVh/BQQKaU/73
         YZ2aX89oYvRHlDfCTnMhqXLOQoSpiCojl8T+JDCt3PmSGWDGBZXDRzMMLIovnyx8WFl5
         W3Wvy7YhGQr5MaKJDH820TqExF8HEmobAu5g8MYoR59tqA4V3U9+faOfcqG7hAlTSdt/
         IDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744999399; x=1745604199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rqJHg5UYMXwn+mNlrL5oxyZCVbhJU0UNvh0766Pzt3w=;
        b=mKLvOqy4yRoiMFtLlyRGwaaEkvYgidV+Jk4laSF3KpgF8j6oOcvijxho01d5upmGeF
         wZ4VfczcFZgnoICbAWWRVkODvJDHF+8qJX5xVgZCef3ccmvaWGZS3P0QmEtCV7hB+8oc
         gcWba+LYQT1UW/1D16jDgCeKUvUNYsDktxMjLilCC8NXmsowWYXFLXHoRSvqnMqU+SFN
         BIdvkkJUwXBAZ2fKbu8l6t4vvcWnu9pg5xN4gSl8yfW/cWKZ76PG3klK0L/Tpp87qm/v
         Onv1lvBThGNbM2WOpa6HkpgajwpsMptxvXBGH4fljwTSWDyFv0HR7UZ0NURXToqZj5e7
         Bthw==
X-Forwarded-Encrypted: i=1; AJvYcCXeSjGuHpEDs8Kh1JaPEIy/6uQQQhGZNlExfWJWp31rqqxsZg9Lwumf4P1y12nGkVe9qx0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWw2DQG2CnuuaYWnlUF2wCJWpKYknnw76XkIK6+5hNTlW+qXgM
	oSowudhKrO7Lo7ayDsxtm2tre/ymTCs/5ScBUkIrilKcU2NVdySvsyvM7JHIgqxlBmv8JwukeUr
	NzQ==
X-Google-Smtp-Source: AGHT+IFCmvZ0T+9eNap/pJTWsl4JOWWblp3uZelMKEtnIjAjt7ekoYrCZmpLXyNDhFs3e4WXHrwgxFD2ZsI=
X-Received: from pjbsn15.prod.google.com ([2002:a17:90b:2e8f:b0:2fa:b84:b308])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18f:b0:2ee:c30f:33c9
 with SMTP id 98e67ed59e1d1-3087c36106amr5592365a91.14.1744999399596; Fri, 18
 Apr 2025 11:03:19 -0700 (PDT)
Date: Fri, 18 Apr 2025 11:03:18 -0700
In-Reply-To: <20250418171609.231588-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250418171609.231588-1-pbonzini@redhat.com>
Message-ID: <aAKT5mLHVV7rz830@google.com>
Subject: Re: [PATCH] KVM: arm64, x86: make kvm_arch_has_irq_bypass() inline
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 18, 2025, Paolo Bonzini wrote:
> kvm_arch_has_irq_bypass() is a small function and even though it does
> not appear in any *really* hot paths, it's also not entirely rare.
> Make it inline---it also works out nicely in preparation for using it in
> kvm-intel.ko and kvm-amd.ko, since the function is not currently exported.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h   | 5 +++++
>  arch/arm64/kvm/arm.c                | 5 -----
>  arch/powerpc/include/asm/kvm_host.h | 2 ++
>  arch/x86/include/asm/kvm_host.h     | 6 ++++++
>  arch/x86/kvm/x86.c                  | 5 -----
>  include/linux/kvm_host.h            | 1 -
>  6 files changed, 13 insertions(+), 11 deletions(-)

...

> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 2d139c807577..6f761b77b813 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -907,4 +907,6 @@ static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
> +bool kvm_arch_has_irq_bypass(void);

...

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 291d49b9bf05..82f044e4b3f5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2383,7 +2383,6 @@ struct kvm_vcpu *kvm_get_running_vcpu(void);
>  struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
>  
>  #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
> -bool kvm_arch_has_irq_bypass(void);

Moving the declaration to PPC is unnecessary, and IMO undesirable.  It's perfectly
legal to have a non-static declaration follow a "static inline", and asm/kvm_host.h
is included by linux/kvm_host.h, i.e. the per-arch "static inline" is guaranteed
to be processed first.

And KVM already have multiple instances of this, e.g. kvm_arch_vcpu_blocking().
If only for consistency, I vote to keep the common declaration.

>  int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
>  			   struct irq_bypass_producer *);
>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
> -- 
> 2.43.5
> 

