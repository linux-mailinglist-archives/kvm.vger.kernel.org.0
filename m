Return-Path: <kvm+bounces-18695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF8528FA636
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 01:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14B321C229A8
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 23:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B84F13CABC;
	Mon,  3 Jun 2024 23:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPAg1TcQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECC313B582
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 23:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717456183; cv=none; b=JQxcgXNO7RktjSQCZ6Ib3pc0uJTzDWnS3npIhpkc7l6tMF5C8V8O0nXq40WwTq629Bsxh7GKvAnbBNMDVeUqippkB6olPynO7YgXz1RBBXRvsqr0WR/feEUXmbbYyDKjs6t8CGX17/wYTmg1g2f34DjvzkzD0CctLtZfkXNMMR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717456183; c=relaxed/simple;
	bh=2Cr/MGTyJ4s8a/RPdFiVjhQipAiRLd8O9rwOV2oOFDo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=grb22fDD6QT4AxK0CVtSKBLmtjFXjS/emi8p95JAOYFuDtVGygnvSy9VyjBrsKqz0bfJsq22cg0gXRm0h4J13OBqfaUW+AxrzYIVT21fMpTHKXqRh+/JZi0NFeG/3qoGHey0q7PjaxxjVbCHKTxpUGfV/zfVqZHSkQDawHIr88A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPAg1TcQ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-629f8a92145so66673857b3.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 16:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717456181; x=1718060981; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y02Vd8LvL6qGr5hcAc4CbRMglkCqCK2c6hpSKvjJ2uI=;
        b=PPAg1TcQOyj5oppIutTOTFo3HqA08PkfrVKgeXjOjFm2wb0MDnvBlKi8HaMRQUgUWN
         sqHkYYw8Rl1vpyb871FlhqsiLzROh+kOpl369j3As76QF3HXdykSzbGSGN5sdin0dEyc
         ZUW8sPYCvBIwEu2W0KF2RBMDT7ixIMBgWBKB47oDUZK4bH71U7ZirwftNJwknM4S50IG
         kk5Tto4xlVybbzGjidXWTgoGAWkRBWQgKSJEEKHE6VEohX6bpQuXa6PsxY8Q1iChoP+J
         2mbfpLflQnzXsPmtZEmjy/saus0jI/Sx2Sn18BuD+tSNmhyBr4hghLQSGG/gXE/tAc9Z
         3j8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717456181; x=1718060981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y02Vd8LvL6qGr5hcAc4CbRMglkCqCK2c6hpSKvjJ2uI=;
        b=uZpF8ATht6zTgzmxiqzwiPNQ2jpgNjlDkuUoLFaCuwDjl/PfyGQtEjy0C+CNJgTx2c
         Erb0NvZe4ECao4uPvqwA1rdMuc+ff7ON/ni8Sgoj4x9XQ2ysaBL30pdLrFPC/qa1gHy1
         Za0dnNYf4vGpVwe92mCw1UxfKRS2jUL1GB/FIjoRF6eLGS3AWdKXBNcAUfXMP2TRikeP
         movp+QK8VCyl9tYs+vTGbRX2Jt9JCVCo8JDNrlJ8r49AzNSIYQadZCrMGgsb+UwVVl2l
         DbhzX8racEPfVuNWGQXbaYzWw0ekfnGRZs/S5S83VCFF2hxobb53wg5fx+4kyLxh6l2s
         VO7g==
X-Forwarded-Encrypted: i=1; AJvYcCVsLBdDldNUtBzl5ULTbUTBF8aTCSiW3TQFsCfeBK81M7rT4jNvohxWjT5OGh61toPVFLi48xGDCyST8hWyCwFiPbIG
X-Gm-Message-State: AOJu0YxH6I/BxuHURapNao4zZO56eRxGuHlWqO090lkiaccnlIWrcBIE
	XMg0xhrhy5JIV4NFRSzqBLmoJBAT85/b6lQYs17GELzMXAoDkrhiUW/MQqJgNS9EjNYYWqyXAzX
	5CQ==
X-Google-Smtp-Source: AGHT+IHv91dfGU48unxQQNFVBx5skY4P7CBePNs3Gz411kNZuxA9n6TJniYIRO/g3YEXV60ceyvbnmsNXec=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:385:b0:622:befc:2e97 with SMTP id
 00721157ae682-62c796bdd36mr25532117b3.4.1717456180940; Mon, 03 Jun 2024
 16:09:40 -0700 (PDT)
Date: Mon, 3 Jun 2024 16:09:39 -0700
In-Reply-To: <20240528-md-kvm-v1-1-c1b86f0f5112@quicinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240528-md-kvm-v1-1-c1b86f0f5112@quicinc.com>
Message-ID: <Zl5NM5S4Trrqog_t@google.com>
Subject: Re: [PATCH] KVM: x86: add missing MODULE_DESCRIPTION() macros
From: Sean Christopherson <seanjc@google.com>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, May 28, 2024, Jeff Johnson wrote:
> Fix the following allmodconfig 'make W=1' warnings when building for x86:
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-intel.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-amd.o
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  arch/x86/kvm/svm/svm.c | 1 +
>  arch/x86/kvm/vmx/vmx.c | 1 +
>  virt/kvm/kvm_main.c    | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c8dc25886c16..bdd39931720c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -53,6 +53,7 @@
>  #include "svm_onhyperv.h"
>  
>  MODULE_AUTHOR("Qumranet");
> +MODULE_DESCRIPTION("KVM SVM (AMD-V) extensions");

How about "KVM support for SVM (AMD-V) extensions"?

>  MODULE_LICENSE("GPL");
>  
>  #ifdef MODULE
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6051fad5945f..956e6062f311 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -74,6 +74,7 @@
>  #include "posted_intr.h"
>  
>  MODULE_AUTHOR("Qumranet");
> +MODULE_DESCRIPTION("KVM VMX (Intel VT-x) extensions");

And then a similar thing here.

>  MODULE_LICENSE("GPL");
>  
>  #ifdef MODULE
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 14841acb8b95..b03d06ca29c4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -74,6 +74,7 @@
>  #define ITOA_MAX_LEN 12
>  
>  MODULE_AUTHOR("Qumranet");
> +MODULE_DESCRIPTION("Kernel-based Virtual Machine driver for Linux");

Maybe "Kernel-based Virtual Machine (KVM) Hypervisor"?  I personally never think
of KVM as a "driver", though I know it's been called that in the past.  And having
"Hypervisor" in the name might help unfamiliar users.

