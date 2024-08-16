Return-Path: <kvm+bounces-24343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFDD95409E
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 06:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2E26B23917
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 04:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC59077105;
	Fri, 16 Aug 2024 04:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b971qGhC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7237E6F077
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 04:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723782540; cv=none; b=nL7wBxDV0aVAhr/0tlQ6X4l4lShsDD0KppOUFLwp2C05qXavmvo+dOUxQnXI+2Q0ZnTl8sKUk2ytz+0ambuSMk5Lk03uBkBL/X8CQF62bJ1vfDL326r+5/atQtcYY80u+BQQwlSAJTXJQCkpC5305xjO3ElWoYKR+NnvB/BxSo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723782540; c=relaxed/simple;
	bh=ByDT93QIRaz0b5OIrhS/Gy2YbA/fcEY9TXdFbTmRyoY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g83QaQXHKHeAGSkV7fkMXXFuLABCiy5NH3so2zBcBxg0r6fWulfM88NZKCca9DAbL8kIXbOcNo+YwZupu+/25lWocbRzFPxvX3e67kv2X+Ml+R2K8g5QpZrk7bSgSxkQBLz32Ns46mPkHfRY/S5kWVTdqcxzKdVFGmk8WKHknGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b971qGhC; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-690404fd230so27965317b3.3
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 21:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723782537; x=1724387337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=76V+p5WBi+LNq0dQVklKGYao/CBfne6Cn1SdVOP9ztw=;
        b=b971qGhCs4H17341dIWuxIan/K6Mq/8pDH3pj0kpfFlWVIhvRO0sYWa9zc8tOUsG28
         PMdkCFqIum3ScSUqRIXn5u6vHdK7qCQDO9m2FU1TK6nkdXGGdHyDXgJtwS7B2ktxWmUa
         je/mJouQE8mYtrHbzG9OSZ3IDvHNgx/AnFbkrQKlA3JyX4StJNTQ5y+z4OZ3KVxWyajx
         s4K1fni4FRQPdjhnK8LmMdxyRMhSKz2wELaNXeE6PVu35xVXtMK/WWlRwLaYQClVsbRo
         ewlhA/LKl0mIXzzPhKKDjyoyqrpkM18XX0UUnyaMKLoy5c9Roj+GT6rbahzcUiOhZk9s
         X7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723782537; x=1724387337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=76V+p5WBi+LNq0dQVklKGYao/CBfne6Cn1SdVOP9ztw=;
        b=W2u6tVyp4YfznG74sHpWt1cQAftjFQaXtAatFZVuCY/O6x/jqxZyK4WSZNAJqA+gMk
         lxvWngrcmk19eFw5isxXjq4/hDErdTINvGVp8JPYyWbF3Yg5LP1oHCr/VN4tagOoN+OF
         u+JgZsQUXMDmz+Zv2J+VDNNyPEKrS/RjWGizERXNEGzQ6TyLkIFN4iG9jam2bQyd+YUX
         QkdiUJnpjy5MiKSnGveyQRFaYIwWGi9nEWJB0lB3jhf8HdmvTg6UmeBfnchc4UXENkON
         EzX8uUUL1/rcGyZxTVAX0W6mEaeyLELl3hU7rLfDcaV52AP/qTiTycGY3Zzje9r93xsk
         2J5Q==
X-Gm-Message-State: AOJu0YzXOWAJi3rLRjqTguk8ui3QQJLB7F2WhsENoXI/Sgb8jVs/HWZm
	uReRjCtaGUdCNI07k9NEhTtmWJrvZGHZ9n5BG3ElBg1e5mzimwG8ZYBy5+vDkhJa7FQ4dq1vYNi
	1Lg==
X-Google-Smtp-Source: AGHT+IGCuSD9mWkjwSN3Merz2iByF8JxicOek8mY5QtDXNf/JTFRsMbA4AkGDKCH6Rx5vw15cu/6Jvjnjis=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4506:b0:69b:5a4d:26fc with SMTP id
 00721157ae682-6b1bc7d1ff7mr34297b3.9.1723782537272; Thu, 15 Aug 2024 21:28:57
 -0700 (PDT)
Date: Thu, 15 Aug 2024 21:28:55 -0700
In-Reply-To: <20240522001817.619072-18-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-18-dwmw2@infradead.org>
Message-ID: <Zr7Vh74T5yIVQyqi@google.com>
Subject: Re: [RFC PATCH v3 17/21] KVM: x86: Avoid global clock update on
 setting KVM clock MSR
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Commit 0061d53daf26 ("KVM: x86: limit difference between kvmclock updates")
> introduced a KVM_REQ_GLOBAL_CLOCK_UPDATE when one vCPU set up its clock.
> 
> This was a workaround for the ever-drifting clocks which were based on the
> host's CLOCK_MONOTONIC and thus subject to NTP skew. On booting or resuming
> a guest, it just leads to running kvm_guest_time_update() twice for each
> vCPU for now good reason.

s/now/no

> Just use KVM_REQ_CLOCK_UPDATE on the vCPU itself, and only in the case
> where the KVM clock is being set up, not turned off.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/x86.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 437412b36cae..32a873d5ed00 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2361,13 +2361,13 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
>  	}
>  
>  	vcpu->arch.time = system_time;
> -	kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
>  
>  	/* we verify if the enable bit is set... */
> -	if (system_time & 1)
> +	if (system_time & 1) {
>  		kvm_gpc_activate(&vcpu->arch.pv_time, system_time & ~1ULL,
>  				 sizeof(struct pvclock_vcpu_time_info));
> -	else
> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> +	} else

Needs curly braces now that the if-statement has 'em.

>  		kvm_gpc_deactivate(&vcpu->arch.pv_time);
>  
>  	return;
> -- 
> 2.44.0
> 

