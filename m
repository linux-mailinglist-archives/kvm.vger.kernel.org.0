Return-Path: <kvm+bounces-53307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3648CB0FA16
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:14:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06797563AAE
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE047228CA3;
	Wed, 23 Jul 2025 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KHqzV1T9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791B2223323
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 18:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294448; cv=none; b=sFxHeRJfNkHq3yrT31dNcoNwrTLof9xhYCyn/8Y/J0LL5FU3D1D+FfHkYTlF4Jro0NfrrfzTPXRj/69RBOZAu/ssT0b8mrjhPka9P3ZS4CSRwxOsQbE+FP+F9HOLQoV9cKnReGnEBWwzSZ8GkEbeMGiP1J8lsTZhHfKDqEfT1ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294448; c=relaxed/simple;
	bh=JG4uReWgGvK254YxhuRwhsavbNKr7T50ZMO/oooWqyU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LhDcQthrEqDcbppPI/YovavGCGZZGa/UkYyxbpB/jbvC9ogGCzEzPLXSpSCOhIf2ePLyV7oKYMt+CDFMQc+kXI8Q2plzyz9E5Ez/XZcxA2ZBCAWAxr1FSUl/DDvsu8cvTmTAPNJ1bTH9BrlQmglpM01KJudIh/SfnVqTacSraqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KHqzV1T9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23494a515e3so641615ad.2
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 11:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753294446; x=1753899246; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eO5dqZ0DhB/OAkXgsZy07YNUuWXJnLDBIhzJwZGa0YE=;
        b=KHqzV1T9+eNjT6tZ6XRjfLa8Um3r3wjiOynyi6iGJQA2kJ39I7Wo5kPShVTEIeaQtt
         EiBKWiRyaCVjwko2G9THc0I8yIRpR1Qe6hexGzAg8T8d9F7q76Nx5h2ZBlx6xLe3Mtes
         Ppn0t6SaLADPOELK+woAps78UbsycYB5KeC6sgJW8qHXiw0AfI4L1ZEKTOUgBo15XtAY
         nakRyLRD6icMuwFXyW8NAiZhEYuO4sG+m+VvGdXhCxJemaTQkVqwJBji3OamUH4EX0rt
         9JY5BM0j+ZZQWojFCNZyEcFnb3+DHCMNVRpIACVjXgptSglI3ypPQo9HpLG5/512XvQt
         3OrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753294446; x=1753899246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eO5dqZ0DhB/OAkXgsZy07YNUuWXJnLDBIhzJwZGa0YE=;
        b=M+uQAW5L8zHkg5yHYC8UyNU0atOvlGI2UdT59K8PMRawmWNX2XFwfScr8f7ckH+OZ/
         ie9W6XWuA+/30jvxsSEIMQL01/nm1YJFtP6IW2iikHIakiOTUUKgYxaNpVbJi4cMmzz8
         e/XZom2CnunF7W2fUI2RUwYW2B8YIJfmnfSsQ1I1A5eJKjoNt1SkfQrOh82DzTfNL2Cy
         2DOSM4tnOxXfyInTxrdNZI+pytzAK5dvMvC4bNpGT7E0xOHEbB9Bz1A8p6akGro/COcw
         bmnNSlNiIuw1i7jS0X0HP+nuHPS99sEEW56PO0vm6jilHcQm+ZnAyHYz27Gk9yg9w3LR
         DEZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiEjmx6sJN57GFrLyQa+ZWk5zUCn6mcXnoa8dp5D9B9KL1oERqs7kd/q0hiptQym1KoSY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN7nNM0h8n/uBIveApcMBRZg10qlBhdsqoqLVZO9dfhC2NJbFT
	nIb+B2FikYrG6Zh3VlYfI1i/tI6aigJ/PAY5TeYNWLK1R5cpa3jrDGymwq9TygEInHnf8ryKExB
	etQM5tw==
X-Google-Smtp-Source: AGHT+IEjAqLPa5W7Efdn/up6DoBz+19wIi12MSCKj7MrbSVpgqTQz1XXEAR5E+PKwmAfbifDD/Fz4Imnksk=
X-Received: from pji5.prod.google.com ([2002:a17:90b:3fc5:b0:312:3b05:5f44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f152:b0:235:e309:7dec
 with SMTP id d9443c01a7336-23f98204604mr31445345ad.26.1753294445204; Wed, 23
 Jul 2025 11:14:05 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:14:03 -0700
In-Reply-To: <20250422161304.579394-4-zack.rusin@broadcom.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422161304.579394-1-zack.rusin@broadcom.com> <20250422161304.579394-4-zack.rusin@broadcom.com>
Message-ID: <aIEmawm9gLflg8zt@google.com>
Subject: Re: [PATCH v2 3/5] KVM: x86: Add support for VMware guest specific hypercalls
From: Sean Christopherson <seanjc@google.com>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: linux-kernel@vger.kernel.org, Doug Covelli <doug.covelli@broadcom.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 22, 2025, Zack Rusin wrote:
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 9e3be87fc82b..f817601924bd 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -183,11 +183,13 @@ config KVM_VMWARE
>  	depends on KVM
>  	default y
>  	help
> -	  Provides KVM support for hosting VMware guests. Adds support for
> -	  VMware legacy backdoor interface: VMware tools and various userspace
> +	  Provides KVM support for hosting VMware guests. KVM features that can
> +	  be turned on when this option is enabled include:
> +	  - VMware legacy backdoor interface: VMware tools and various userspace
>  	  utilities running in VMware guests sometimes utilize specially
>  	  formatted IN, OUT and RDPMC instructions which need to be
>  	  intercepted.
> +	  - VMware hypercall interface: VMware hypercalls exit to userspace

Eh, I wouldn't bother enumerating the full set of features in the Kconfig.  Just
state that it guards VMware emulation, and let the documentation do the heavy
lifting.

> +static inline bool kvm_vmware_hypercall_enabled(struct kvm *kvm)
> +{
> +	return false;
> +}
> +
> +static inline int kvm_vmware_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}

If we do this right, we shouldn't need a stub for kvm_vmware_hypercall(), and
can instead uncondtionally _declare_ kvm_vmware_hypercall(), but only fully
define/implement it CONFIG_KVM_VMWARE=y.  The kvm_is_vmware_xxx() stubs will
probably need to be __always_inline, but otherwise things should Just Work.

So long as kvm_is_vmware_hypercall_enabled() can be resolved to a compile-time
constant (of %false), the compiler's dead-code optimization will drop the call
to kvm_vmware_hypercall() before linking.  KVM (and the kernel at-large) already
heavily relies on dead-code optimization, e.g. we use this trick for sev.c APIs.

In addition to avoiding a stub, if we screw up, e.g. add an unguarded function
call, the bug will manifest as a link-time error, not a run-time error.

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 793d0cf7ae3c..adf1a1449c06 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -135,6 +135,27 @@ struct kvm_xen_exit {
>  	} u;
>  };
>  
> +struct kvm_vmware_exit {
> +#define KVM_EXIT_VMWARE_HCALL          1
> +	__u32 type;
> +	__u32 pad1;
> +	union {
> +		struct {
> +			__u32 longmode;
> +			__u32 cpl;
> +			__u64 rax, rbx, rcx, rdx, rsi, rdi, rbp;
> +			__u64 result;
> +			struct {
> +				__u32 inject;
> +				__u32 pad2;
> +				__u32 vector;
> +				__u32 error_code;
> +				__u64 address;
> +			} exception;
> +		} hcall;
> +	};
> +};

Put this in the x86 header, arch/x86/include/uapi/asm/kvm.h.  The capability
itself goes in the arch-neutral header so that KVM doesn't have to worry about
collisions between capability numbers, but any arch specific payloads should go
in the arch header(s).

