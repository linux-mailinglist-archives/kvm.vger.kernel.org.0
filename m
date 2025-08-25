Return-Path: <kvm+bounces-55668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D0EB34B22
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 21:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79413204F55
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E3B2287250;
	Mon, 25 Aug 2025 19:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nSmyo81L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A7E28136F
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 19:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756151545; cv=none; b=nuRNhukhVKFcjp/A8NFla8yeVef+PZWg0i735b+XFwoj+Lx/RyiBh+Bbi1oD2WBuddAIiALVAUtJfT4Px9czNNppPOVsWfNyft/11fKF93XHZjLjgGf5wQ9E6fVJZfnLH2y4No6WJEtpss1oyPHA0ZjLpH781eMrxBIEHr+PoCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756151545; c=relaxed/simple;
	bh=27LVi33Piq79b4c8wVCJq9OIcPzQn7EWMYuMP0qjd6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iAuMcZrI9yj8roZyj100suJ4LedZpxcm1V4JV3tLWiSJ9uawAGLjnVWJ0JFO2sqpmIqVFlfjsUFcClCuz66XPGQ0aDFpsexd81QMKKGX0TxJrdiRop8AdEefWOl+bowt4pDQxrL555k/qs04Vvt3bDzQLJfD1VeYVr7F0NqZp7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nSmyo81L; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32505dbe23fso3193019a91.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 12:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756151543; x=1756756343; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CCEDB6kqaMG14n95AC3dXml5C4i7TOO+4ulWOjXNjDA=;
        b=nSmyo81LcBHQzTh8icoumB6cImX5Z6mMTTM41NVK7r/CDuhs3+xSrJfFLA/Icx4675
         yHoVaIU3TA/2Irl3IEGdgw58nTdrdbqvkRYNpNnSIm8LCMFUR95J/H29YoUaWgdGnFk4
         kdUHCtbt1zbMnu/VINs+Ew/OLD9LPjI7gNytYT6v+4KPZM5l9CERWnFs2e4tEzi3Z09p
         h4W4AgGpNDmWDVrNLcuLjuMzu0SyVpKPWUHTkP5aqEo4STGIT6ISkBVZ70oVM4GAzOz4
         iFX80/sX82zLyVyKPPnpQw0L/iOLI4gm48eARTqunoY1APNpr8qSVHa03kWj+2AFqgSQ
         WlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756151543; x=1756756343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCEDB6kqaMG14n95AC3dXml5C4i7TOO+4ulWOjXNjDA=;
        b=hbIB4U2+rvFgkIkTnHcNr7ehQ40RAjLk+D6CMz4V1VIUu+VDkdBdmsGCaaM72NkygQ
         ghfWGB1vH062+oEXsb7NvB7AV48T5sjokd3gmY/U0SeAkrmRiNdAeRlX6osXuXW2gNlJ
         c1SGJxY7YZN0LfVRnIKvWas71/9K4zep67bqO4vBSbaPfm1kOD5j9ePRcT1o44iozm+m
         1v9esJ3yFjFJNlwH5YM6z073dG9T77tVOndwPMHwctqWfaIrTyIz1m7QMl3MaLmaNEbB
         dtYA31p69XfPYGuEXxhh177G3Os+/RCeBRYOs08BiY5Ov/evVEjA0aRTgrQ34tszFtJB
         5+SA==
X-Forwarded-Encrypted: i=1; AJvYcCXznZfvF2Z7dBKHVzNflr80u5/Za02jjzeuMN6MXm3Y1eY+Ng9xDN7d8qzvqX08oGKDCcg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4J3fTRuvF5ITGEHC76BahCJaC9AjJPEJvHqz71oUOcXl4akFY
	XX7HuNnwau1g4Fuh4JA9cGkv19YaMSQc6PYbaOET0vtVTjUj9Ewo16q1Eb+P5n6I4mDsbp1xIxw
	d44+prA==
X-Google-Smtp-Source: AGHT+IGdV6Crel2hSBLJu5xj69LCA8mKZyILIoBXiyFz0c96jNGA0JlOa+svdw4ALPEpBZ5tb9n+dMFk9lc=
X-Received: from pjbsg1.prod.google.com ([2002:a17:90b:5201:b0:321:c1e3:6b16])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfcb:b0:31e:c62b:477b
 with SMTP id 98e67ed59e1d1-32515ec9f34mr13649374a91.11.1756151543426; Mon, 25
 Aug 2025 12:52:23 -0700 (PDT)
Date: Mon, 25 Aug 2025 12:52:21 -0700
In-Reply-To: <20250825155203.71989-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250825155203.71989-1-sebott@redhat.com>
Message-ID: <aKy-9eby1OS38uqM@google.com>
Subject: Re: [PATCH] KVM: selftests: fix irqfd_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 25, 2025, Sebastian Ott wrote:
> irqfd_test on arm triggers the following assertion:
> ==== Test Assertion Failure ====
>   include/kvm_util.h:527: !ret
>   pid=3643 tid=3643 errno=11 - Resource temporarily unavailable
>      1  0x00000000004026d7: kvm_irqfd at kvm_util.h:527
>      2  0x0000000000402083: main at irqfd_test.c:100
>      3  0x0000ffffa5aab587: ?? ??:0
>      4  0x0000ffffa5aab65f: ?? ??:0
>      5  0x000000000040236f: _start at ??:?
>   KVM_IRQFD failed, rc: -1 errno: 11 (Resource temporarily unavailable)
> 
> Fix this by setting up a vgic for the vm.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
> @@ -86,14 +90,30 @@ static void juggle_eventfd_primary(struct kvm_vm *vm, int eventfd)
>  	kvm_irqfd(vm, GSI_BASE_PRIMARY + 1, eventfd, KVM_IRQFD_FLAG_DEASSIGN);
>  }
>  
> +static struct kvm_vm *test_vm_create(void)
> +{
> +#ifdef __aarch64__
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	int gic_fd;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, NULL);
> +	gic_fd = vgic_v3_setup(vm, 1, 64);
> +	__TEST_REQUIRE(gic_fd >= 0, "Failed to create vgic-v3");

I don't think this test requires v3+, any GIC will do.

Is there a sane way to handle vGIC creation in kvm_arch_vm_post_create()?  E.g.
could we create a v3 GIC when possible, and fall back to v2?  And then provide a
way for tests to express a hard v3 GIC dependency?

Having to worry about things like this in fairly generic code is quite burdensome.

> +
> +	return vm;
> +#endif
> +	return vm_create(1);
> +}

