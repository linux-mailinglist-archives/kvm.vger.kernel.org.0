Return-Path: <kvm+bounces-34682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E886A0446F
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 16:29:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B99393A6933
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623731F2C59;
	Tue,  7 Jan 2025 15:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zVziXXTD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9861F4E3B
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736263649; cv=none; b=MBYoW89pFqHUdcqp3ag+G3Ejrhe1a0UoHPbk5sd6x4t2iaMa7KFG2dqzDteY5hVPOa7Xgl37YrZNYdro/Bpe1EotzRmFhFCIu+2D5fWIPfLgAZxo6FzBKs51Ueb4EqTO7IoGpDAAyUvDjspMqDijkE8jD2xI1RrJWO042AVbI14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736263649; c=relaxed/simple;
	bh=AmlJgbsuul1rBCaUHVkF0P4TMqgdkYk6jomD3ra2D/E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UGguASfwRWN4p9oE0yZ7jEU3zU9DIjLwhh3of91BIG96wa3eiWS+YzWwj8nVVvjRyGIlhyo4BELtl4aDsmjbZxM+a3PfpJKs3iZH11oZynnIRpgwc1k3mfeZnIm+riU9qQwBGFs8Tb/J9i5Lxfd3vV62uYxY4cO/nvBk57DnAbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zVziXXTD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso23011580a91.0
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 07:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736263647; x=1736868447; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PhbOktcDC2G4nf3S3vNfTz6DCRsQplSZcBnRNB2+Lto=;
        b=zVziXXTDPB4TgdWPEMFL1AWR27rE8ag+pXUOs84ZiiQaB07FL4M8QcDXHymMsj832/
         AZQF+QkQAiUdVVtgFg//MjG9hWDOh3Hu4ZoufAkfyHOzcTQ7vH12momhNp36wMnlQ5xa
         JIOkVd6MGNCYxCsbK+PDn+Fw52ubeNz+fRHdUak+QfNPjqyus+qAQKyZ9iNRMPIms2B+
         N81nyjV0wfgkrW/J06QabRfNvg2dE4qHcvQBjNZBbb1MATiOVLidhaCTwoCI8eY01JvK
         lcnyKmmzkaX9CaTK0IcU3QiyC6zEks5kdfeFgsBriPSmY8a8B+xOLdNsUwS2iAReTtso
         lgJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736263647; x=1736868447;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PhbOktcDC2G4nf3S3vNfTz6DCRsQplSZcBnRNB2+Lto=;
        b=Jm339UfW6CT9XKMLteFSldtJkmlLcddbn5X7KmH4poQppRBOBBqlZc3geDxyvX8/tF
         VXyhd5ho8C38YlFVJRBHD0QJ/u/QizDzrOh5YH2QC4f6ZFUqTeJcQpP2ikZBGz8szZEl
         89Wl07TTvO8D83OSAfk4sOHDw2uRGbL2qGHf/ky4ssA07cC3dh0DMY27eFTE9IU7ssVG
         0uQIN1RjHH83+N0+N48TibykrQ44/zMTMK48eQk4jaBifMMvzxl7gmsFWFCco/PI0WHF
         RXNZBUFvkKnIAHfpwmo9jmq5Nu1+hZz00JNZXeYEyo2E79h5IraNZjb8bIQVG4pleVd6
         6AEA==
X-Forwarded-Encrypted: i=1; AJvYcCUcC4zi50kw/FwM9Hnj2Vd6JCPdf/DEAcdQn34K3aBNvAy1p9+MJBAtSlDJJbvHsX86zu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRkAAXTIrzDe24LNG+99oVcZoU7L5TnrSFtYOJp3F+Iir8XbVn
	fQp4U4frcsJsR5u2oLot+f0RDD6sOkoNARGT1zbO2Lr1ihm+cfLsq3lmR6XueWnsdxezHugpiOh
	t0w==
X-Google-Smtp-Source: AGHT+IEQ5BI5wX+dah1kOybqABvfBBX/VME4UFx4fiWXMSJ0dbBG+5ni1rYO5EwPVTUrp/g3lW8STtUh4is=
X-Received: from pfwy1.prod.google.com ([2002:a05:6a00:1c81:b0:727:3a40:52d7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:9319:0:b0:725:ef4b:de30
 with SMTP id d2e1a72fcca58-72abde2ff67mr82879728b3a.14.1736263647178; Tue, 07
 Jan 2025 07:27:27 -0800 (PST)
Date: Tue, 7 Jan 2025 07:27:25 -0800
In-Reply-To: <20250107042202.2554063-2-suleiman@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
Message-ID: <Z31H3dkAktjUO2tR@google.com>
Subject: Re: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
From: Sean Christopherson <seanjc@google.com>
To: Suleiman Souhlal <suleiman@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="us-ascii"

KVM: for the scope.

On Tue, Jan 07, 2025, Suleiman Souhlal wrote:
> It returns the cumulative nanoseconds that the host has been suspended.

Please write changelogs that are standalone.  "It returns ..." is completely
nonsensical without the context of the shortlog.

> It is intended to be used for reporting host suspend time to the guest.
> 
> Change-Id: I8f644c9fbdb2c48d2c99dd9efaa5c85a83a14c2a

Drop gerrit's metadata before posting.

> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> ---
>  include/linux/kvm_host.h |  2 ++
>  virt/kvm/kvm_main.c      | 26 ++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 401439bb21e3e6..cf926168b30820 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2553,4 +2553,6 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				    struct kvm_pre_fault_memory *range);
>  #endif
>  
> +u64 kvm_total_suspend_ns(void);
> +
>  #endif
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index de2c11dae23163..d5ae237df76d0d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -889,13 +889,39 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
>  
>  #endif /* CONFIG_KVM_GENERIC_MMU_NOTIFIER */
>  
> +static u64 last_suspend;
> +static u64 total_suspend_ns;
> +
> +u64 kvm_total_suspend_ns(void)
> +{
> +	return total_suspend_ns;
> +}
> +
> +

Extra whitespace.

>  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
> +static int kvm_pm_notifier(struct kvm *kvm, unsigned long state)
> +{
> +	switch (state) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +		last_suspend = ktime_get_boottime_ns();
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
> +		total_suspend_ns += ktime_get_boottime_ns() - last_suspend;

This is broken.  As should be quite clear from the function parameters, this is
a per-VM notifier.  While clobbering "last_suspend" is relatively benign,
accumulating into "total_suspend_ns" for every VM will cause the "total" suspend
time to be wildly inaccurate if there are multiple VMs.

> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
>  static int kvm_pm_notifier_call(struct notifier_block *bl,
>  				unsigned long state,
>  				void *unused)
>  {
>  	struct kvm *kvm = container_of(bl, struct kvm, pm_notifier);
>  
> +	if (kvm_pm_notifier(kvm, state) != NOTIFY_DONE)
> +		return NOTIFY_BAD;

This is ridiculous on multiple fronts.  There's zero reason for kvm_pm_notifier()
to return a value, it always succeeds.  I also see zero reason to put this code
in common KVM.  It's 100% an x86-only concept, and x86 is the only architecture
that implements kvm_arch_pm_notifier().  So just shove the logic into x86's
implementation.

> +
>  	return kvm_arch_pm_notifier(kvm, state);
>  }
>  
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 

