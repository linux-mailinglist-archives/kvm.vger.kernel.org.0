Return-Path: <kvm+bounces-50576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69279AE7185
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 23:25:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D49917C6C3
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B973C2580E1;
	Tue, 24 Jun 2025 21:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EghSdVJs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E5125A2CF
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 21:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750800344; cv=none; b=CohVdGpj7Qc0MipOJqfJ7iFxPVYyC42MasZ9fTKdFKzu7jJkYFaO8sxHjHnwgmH2eCYoTVhkda7lwpfcltOo81wXMGvgMofqtIB2zckdQc5+i9gFzvYd+htUct0GK0dbOBJ2nKWaWOzPcep7KDhNtfoVNxIhdTtTOe1cQlZqR6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750800344; c=relaxed/simple;
	bh=V7VDQ47jH9iNdsT2T46dzLpNy/9xIELQI+h/me3PTyA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OeUP8CrHsWHGDnR++Uer7jykeS31iaFJBXaIuiMzlbyLF79N8qgA/SjVTz6eDAyfORFgCR52PKKBb+ptu/zJ0RRzM81naKEyvlCgQvnwgWdfF/vvXc/yaqQWNWfu2uDzv0ipbkhvbAn/T//kswkawCN7vzr/JdkOAriirLH/Jss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EghSdVJs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so7912313a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750800342; x=1751405142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5XSerilfAD61ZoTQIVntI3Kk9baU60Yfysak4jiQVwY=;
        b=EghSdVJshJOfGL3AjEEKj9ipoSdgRGx53wDFUsXzu0+dzaPUk5m1m2g7Nay945Cdf7
         veVv1+lNQvO+uPHaIYOU9zM4LiXv1kPo3RjiJZthdMTWlvjSOtbRKMm5qz+77RH+cEzA
         /4mKWKLjQRLBqi73+ZJYvqac0O3upJPwxVbFlXKDw2j0KUdCH6nRC/b9PvNvUdfkep3b
         2jnQwMjPyms5PoIy7x2bF2gSQU5ka8OoyZgR+cfKnfM7+H/AXcnXMQOnn9E+beNea+F0
         6y3Gza1bLpvRHAj+hb23YVoR9Z3A7ws9GdjItn5g8xu4o5LWC7dEpTHRTucVd9T1Vd3m
         k1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750800342; x=1751405142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5XSerilfAD61ZoTQIVntI3Kk9baU60Yfysak4jiQVwY=;
        b=W3m9puGd2SnhhVRSjroy6lW57U8R/rkeLFs8Hh2LWwpByc/eQCtGog6skxe7SVQi53
         2NqidFQTM8oITwRNCeOCwmQYNUmahpcOqhSc9GORrPp+aglezwWkqOhZcf6I4luwkh57
         lfcsjUbv2Oqa7+hAkUpcATelBxHDTkKJH8K4HZv1s5uoMHbTwR77TWo3TWE9anTYEzQy
         lRUMYOJAq7dZ79/1HqhSjn6S+5XS/yo3kq4AOASCv7naMly1RWw/e3WZDwSvJApv7oly
         q0fNLSzJv59+tk0eHPFnedeiXepezvsOujAfNOvGqCrDHMF0oFbTLhCRt1qgaDO+QL0c
         EYVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWr+a9qkXl9tff6bFHrYSHeUlJhICUvPut2RYFQ6812OpGfQk9pD/ce7nvPOCdb3V4CSGc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIbwZHtD3wSr2ItlsR2nfx26OHQLKT4szsrVeA6qbkWCYQXFIU
	15tosDi4hIlBRaswhe/GCnPitiG5INbPacMJer42rlDrkBW1XGinRnf4LklrBKgwsmf+zPQCxnk
	oFiTRzA==
X-Google-Smtp-Source: AGHT+IGkM/XNg35LvSqspwm0qZtEc6PDjLpvf8bq2CGQisDevIpjEsk0tBTVA+YS1W0lXTWRmPNzHlZU19o=
X-Received: from pjvf5.prod.google.com ([2002:a17:90a:da85:b0:2fc:e37d:85dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c09:b0:311:c939:c84a
 with SMTP id 98e67ed59e1d1-315f2632d6emr575525a91.15.1750800342686; Tue, 24
 Jun 2025 14:25:42 -0700 (PDT)
Date: Tue, 24 Jun 2025 14:25:41 -0700
In-Reply-To: <20250530185239.2335185-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250530185239.2335185-1-jmattson@google.com> <20250530185239.2335185-2-jmattson@google.com>
Message-ID: <aFsX1anrZGWFsbF-@google.com>
Subject: Re: [PATCH v4 1/3] KVM: x86: Replace growing set of *_in_guest bools
 with a u64
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 30, 2025, Jim Mattson wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 570e7f8cbf64..8c20afda4398 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6605,13 +6605,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			pr_warn_once(SMT_RSB_MSG);
>  
>  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
> -			kvm->arch.pause_in_guest = true;
> +			kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_PAUSE);
>  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
> -			kvm->arch.mwait_in_guest = true;
> +			kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_MWAIT);
>  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
> -			kvm->arch.hlt_in_guest = true;
> +			kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_HLT);
>  		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
> -			kvm->arch.cstate_in_guest = true;
> +			kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_CSTATE);
>  		r = 0;
>  disable_exits_unlock:
>  		mutex_unlock(&kvm->lock);

Can't this simply be?  The set of capabilities to disable has already been vetted,
so I don't see any reason to manually process each flag.

		mutex_lock(&kvm->lock);
		if (kvm->created_vcpus)
			goto disable_exits_unlock;

#define SMT_RSB_MSG "This processor is affected by the Cross-Thread Return Predictions vulnerability. " \
		    "KVM_CAP_X86_DISABLE_EXITS should only be used with SMT disabled or trusted guests."

		if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
		    cpu_smt_possible() &&
		    (cap->args[0] & ~(KVM_X86_DISABLE_EXITS_PAUSE |
				      KVM_X86_DISABLE_EXITS_APERFMPERF)))
			pr_warn_once(SMT_RSB_MSG);

		kvm_disable_exits(kvm, cap->args[0]);
		r = 0;
disable_exits_unlock:
		mutex_unlock(&kvm->lock);
		break;

