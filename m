Return-Path: <kvm+bounces-41805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 239EFA6DBCE
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 14:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06C751887B82
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 13:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E211825F7AA;
	Mon, 24 Mar 2025 13:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ou7ZU8Lb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D141625F780
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742823689; cv=none; b=IY8YVIDIonI4OCCdyNGZv6VAV//tNWQyz47HkuzybZLzXxa99T2x9kZpN35gqeoE4+sjdp8CHLkIb0oWwUgiwbfLivPigu4CqI3ULB0BaWrFNwIWWQum8mPyPmDtPnRnoALanaDhdOZ/FbEylPzb9XsJdLuDu3dCwxDHZKkDq7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742823689; c=relaxed/simple;
	bh=NoaI0VIXS9nDnrTt+JbrnYNyk4JDEUMVi5yyzjmnMZs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TUWgQ2Kg5c2fxO8C77VQmGCJYj5QRcm7sRvGuen+l3rffPB6klw6N0gJ9yOwPqz2wZpOKlY9uSrTDkxWTKfIM1dM7tmNWspQZZsQmwwocAEPLjfAH1Q4lu86n8nfaJfDknhuFEFEcMC3MVwmIP6DsrB5o8rfRwLZmv1Sg/UOA6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ou7ZU8Lb; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2241aad40f3so64254685ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 06:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742823686; x=1743428486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TOMUBa0uAqlf20qeqn3I3utJD4aHpZ+FGIRL3z6psP8=;
        b=ou7ZU8LbVY/7W2aEhi1Upbob78ioGSWTh4lyohHgOV+r4Lvzo/p0DS/NddMqrr8IZl
         QufYtYD3qxfTaXUHwk993jzmLQ+KWMPsHxu749JqhehLGRBQ87lZTiO1BjqZjkojBmu5
         sXFsAJmaqI9/pWtV235012MCBg8gU7lk4llYecCT2VU4etfrj1aXiwWwS3GSCPyfDswb
         7wzgwn/NHNcqXSeRRZmXqMttRY6nNaMEjG3XqRNfXjFj1jX0j4i/v1E3jU202fKjosVt
         z0875nloLPHowiLGf3ntuvPgT6HIu9N6HJ+pqkivnzpakCA/isAog66SiIsy15tkAGGp
         ENwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742823686; x=1743428486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TOMUBa0uAqlf20qeqn3I3utJD4aHpZ+FGIRL3z6psP8=;
        b=RpgrfKDgbqqdFACChgoPuMexmACVDKamkQaXt5cXNbPhCrGtXRHew7pQnDlr64RPu2
         2PeHyN8II7+ffk/v0zIa1ZEnREVFZph7iE6pN+1yzx/JHmm4A6a/2MqcRcxn611NXKRd
         3gQzMKJxy+jESWf5CMjRnTkIOjh8XwfZeFO3pmd3HRDDLrrKp1+DKxIu21venIq/h+S2
         JGUxb+PVJGASCXfQ1KPNpDXWh2UiUM9L5hR4x1PNAZqGJ9ldenNmz9z0Ol0Qj0tasBhg
         iDohR0xvG7ktG7Dtaj+ZZGEJ26hfa4dOXlwMmvy/FfVqIiPtjyYA6Mffw3UU2z3m5k42
         C9mw==
X-Forwarded-Encrypted: i=1; AJvYcCVE4qTM05xRGv+vqcY68sEQlkJivNf8XHGJGBP2avbO3hX4D1+gtHI89VZKvwZaeV0tm14=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+m2FNGH/e0znNvfMq0cS8Afc5YNFkEsNhu5p2IzLMQZineXBR
	0wXlO/9EEFWgCjjDqroOxBNNCjBaWT7UW4cj9qURRYePmmW71PVaDifvRWZK4VVhMkGMxXf4zPl
	wGQ==
X-Google-Smtp-Source: AGHT+IF1FB4A8qFLi8Ozqi3+nCx7rU7glmRRUDo35MhMjgvHg/5rVBEXCQVZGbO5vn6nku0l/wkKqu1AtRw=
X-Received: from plsu3.prod.google.com ([2002:a17:902:bf43:b0:223:f487:afc6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc4f:b0:223:60ce:2451
 with SMTP id d9443c01a7336-22780c7b70emr208367505ad.15.1742823686205; Mon, 24
 Mar 2025 06:41:26 -0700 (PDT)
Date: Mon, 24 Mar 2025 06:41:24 -0700
In-Reply-To: <Z+ElLSmJHkBqDPIT@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320142022.766201-1-seanjc@google.com> <20250320142022.766201-4-seanjc@google.com>
 <Z9xXd5CoHh5Eo2TK@google.com> <Z9zHju4PIJ+eunli@intel.com>
 <Z93Pv0HWYvq9Nz2h@google.com> <Z+ElLSmJHkBqDPIT@intel.com>
Message-ID: <Z-FhBHJW2cJb9eZG@google.com>
Subject: Re: [PATCH v2 3/3] KVM: x86: Add a module param to control and
 enumerate device posted IRQs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 24, 2025, Chao Gao wrote:
> On Fri, Mar 21, 2025 at 01:44:47PM -0700, Sean Christopherson wrote:
> >On Fri, Mar 21, 2025, Chao Gao wrote:
> >> On Thu, Mar 20, 2025 at 10:59:19AM -0700, Sean Christopherson wrote:
> >> >@@ -9776,8 +9777,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> >> >        if (r != 0)
> >> >                goto out_mmu_exit;
> >> > 
> >> >-       enable_device_posted_irqs &= enable_apicv &&
> >> >-                                    irq_remapping_cap(IRQ_POSTING_CAP);
> >> >+       enable_device_posted_irqs = allow_device_posted_irqs && enable_apicv &&
> >> >+                                   irq_remapping_cap(IRQ_POSTING_CAP);
> >> 
> >> Can we simply drop this ...
> >> 
> >> > 
> >> >        kvm_ops_update(ops);
> >> > 
> >> >@@ -14033,6 +14034,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
> >> > 
> >> > static int __init kvm_x86_init(void)
> >> > {
> >> >+       allow_device_posted_irqs = enable_device_posted_irqs;
> >> >+
> >> >        kvm_init_xstate_sizes();
> >> > 
> >> >        kvm_mmu_x86_module_init();
> >> >
> >> >
> >> >Option #2 is to shove the module param into vendor code, but leave the variable
> >> >in kvm.ko, like we do for enable_apicv.
> >> >
> >> >I'm leaning toward option #2, as it's more flexible, arguably more intuitive, and
> >> >doesn't prevent putting the logic in kvm_x86_vendor_init().
> >> >
> >> 
> >> and do
> >> 
> >> bool kvm_arch_has_irq_bypass(void)
> >> {
> >> 	return enable_device_posted_irqs && enable_apicv &&
> >> 	       irq_remapping_cap(IRQ_POSTING_CAP);
> >> }
> >
> >That would avoid the vendor module issues, but it would result in
> >allow_device_posted_irqs not reflecting the state of KVM.  We could partially
> 
> Ok. I missed that.
> 
> btw, is using module_param_cb() a bad idea? like:
> 
> module_param_cb(nx_huge_pages, &nx_huge_pages_ops, &nx_huge_pages, 0644);
> 
> with a proper .get callback, we can reflect the state of KVM to userspace
> accurately.

It's not a bad idea, but it comes with tradeoffs too.  A little bit more code,
but more importantly enable_device_posted_irqs wouldn't reflect KVM's internal
state, which could result in bugs if KVM were to check the module param directly.
I don't think that'd be likely to happen, but given that pretty much every other
"simple" param in KVM reflects KVM's state directly, it'd be an easy mistake to
make.

That, and being able to set toggle the param when reloading the vendor module is
actually valuable, as there are setups where kvm.ko is built-in, but the vendor
modules are not.

