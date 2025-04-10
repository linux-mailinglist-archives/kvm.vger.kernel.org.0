Return-Path: <kvm+bounces-43104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20261A84E4F
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 22:41:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC9A6445627
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 20:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E962290BBA;
	Thu, 10 Apr 2025 20:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ocw97+Ha"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3EC259C
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 20:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744317571; cv=none; b=TOT04VLJ2Kn7bNEdM4EpAdMSfgsdmpAgij1rDGKQS4V5t4T5t+0p9S0rozJibJ6m1Ut8dmOtZjQJ3DXyYDINXR8CHHTelZqm9jzrmxPQj9Kf3cTfTFcFyLc1/UqCbKjXDxvl0V9XzXEhCDglc2udHGQd3z8hHbmO4gBrOYC7EKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744317571; c=relaxed/simple;
	bh=+/Da14Q8O99O8gD5GOsB3AbvKUabJM3yMtDdDBWWncs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C7is4zNMeUVMe/AgRKyGPHphmejKjdwPjy2dIypWYeUodXNnctEI+3FS1ZUlLDqzuIkV3M3ZEzhaPL00fZ14sxRROmRu0mrnwph39Cx5Y+fh6eJNXMriZsPg5DGdnVbTpdlgJRv9czv+PqTm/2Che+lFoJYEGdmPexjYXStiZ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ocw97+Ha; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-225107fbdc7so11040015ad.0
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 13:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744317569; x=1744922369; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5re5XUGW9IF95wVSy2NMQsySIZSn9P1138cF5o6XU38=;
        b=Ocw97+HaMov/ANgXnKfvCJQg9Ax6f7nZj881fQP4+4/vpEUgpQLYjohS9TNoqosflX
         g1DFF97ab1q+oYWle+AvRoLfhr5xjEyhV7+TvUL0j0CNIHJty3RhoxrNi+nsNxisUFeH
         MX64yz7WyUVBoQ090wqCF2HARl98qNU1aRx+QqqH4GLBnB6+pGYw6b33QPZNEqraXFnm
         98V+7eQRYpLC51DoWOW+eGYlOJRtitfO6EJku6/VDYpFeRCQkTvMR0Km7qKPHf4Cp7VN
         7YWirSA6aNhY/JCq2VS9yTml51VbCo8iy9+iQ7P32beMxUYnKXHO0VmrWzmQ7dD6n02P
         n81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744317569; x=1744922369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5re5XUGW9IF95wVSy2NMQsySIZSn9P1138cF5o6XU38=;
        b=MG3eiIkvvbpbv1ohaMJSZI9rNOE4B3TPofJbIquLHid89aYoBX09CZPE6p/lJORFdz
         dEFPlV7HT5RTzkZ9Pz63/d/jlbTHNZORU7rpJBHwBcI3gOHeQQGTlKYaPOHff/sy149x
         +gY7oTkhZGo01IOp1Cy7iFYKmrp/WESU/w+DwEyXhj+2yE5mgjzxv4rtVOuY+eCYkdpS
         SIYzR+6Z1Ut8RH1AUdWEnpHcolqWvBzc5GTP1MnQzhIUxbTjgg6XdtPeYfmY3YccAu2N
         Yx5kyep1xp7EyJDNMTcCAgDHMQszcGyjH2UiOPf6rLJdckei/dyoxTWt7pWpO6QCH5yr
         laZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEvLATeQfB03TUsijL3mzBK4ma7xa0EO7ehWOojd2tb6HZfELET8AALuDP6tAPMk4jUvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEg8v/HnBl4Ukufk4eGTSzqpFf3kK28E37vk30sSB2D2Iiz9kl
	ZjuMOiwzX75Za1zPcgo2d/gp+dch0zKX9c79/jd45LK0mN/jssqdAAk7vonNkRBBD5ic4d15ix/
	BAg==
X-Google-Smtp-Source: AGHT+IEzT83HzgjEOFZbsaMCZV5hBRnM3M3IalG5XVGaEH7NXrikjfnOtjVPlPzcWgW0Lywqicmh7WKqSSM=
X-Received: from plblc7.prod.google.com ([2002:a17:902:fa87:b0:21f:40e5:a651])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c6c:b0:215:b75f:a1cb
 with SMTP id d9443c01a7336-22bea4a3453mr2764715ad.9.1744317569509; Thu, 10
 Apr 2025 13:39:29 -0700 (PDT)
Date: Thu, 10 Apr 2025 13:39:28 -0700
In-Reply-To: <20250410-mmio-rename-v1-1-fd4b2e7fc04e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250410-mmio-rename-v1-1-fd4b2e7fc04e@linux.intel.com>
Message-ID: <Z_gsgHzgGWqnNwKv@google.com>
Subject: Re: [PATCH] x86/bugs/mmio: Rename mmio_stale_data_clear to cpu_buf_vm_clear
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 10, 2025, Pawan Gupta wrote:
> The static key mmio_stale_data_clear controls the KVM-only mitigation for
> MMIO Stale Data vulnerability. Rename it to reflect its purpose.
> 
> No functional change.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
>  arch/x86/include/asm/nospec-branch.h |  2 +-
>  arch/x86/kernel/cpu/bugs.c           | 16 ++++++++++------
>  arch/x86/kvm/vmx/vmx.c               |  2 +-
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 8a5cc8e70439e10aab4eeb5b0f5e116cf635b43d..c0474e2b741737dad129159adf3b5fc056b6097c 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -561,7 +561,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
>  
>  DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
>  
> -DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
> +DECLARE_STATIC_KEY_FALSE(cpu_buf_vm_clear);

Could we tack on "if_mmio" or something?  E.g. cpu_buf_vm_clear_if_mmio.  FWIW,
I don't love that name, so if anyone can come up with something better...

I like the idea of tying the static key back to X86_FEATURE_CLEAR_CPU_BUF, but
when looking at just the usage in KVM, "cpu_buf_vm_clear" doesn't provide any
hints as to when/why KVM needs to clear buffers.

