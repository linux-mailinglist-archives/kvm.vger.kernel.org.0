Return-Path: <kvm+bounces-29861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC0C39B359F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92AB41F22F1A
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 16:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F3251DED71;
	Mon, 28 Oct 2024 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pay5G7sV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D6A1DED53
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730131311; cv=none; b=uDzd/ZhrKNTuKg42RwQMOolt4zUWU2QwQywODhLSaZQaHnH2T/CupE9xl5GXiy/mXHtS47GPUuq6JfIkMJEnpypEtsjT9AgtBoMnPj48bcVIL7SDIRldXMMUL9tONqywwVnB3e7l1E/cHP3O2aBReRGsNV+CUCVS9TpYEewv+GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730131311; c=relaxed/simple;
	bh=7PRNa+uQzRKDZOo/peK7GEezP1r6PlJrVhbHzVtCDD8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KePTkaAoA4wc9lC5s7WuqQ0TmiAIiuDSo74qgalDf4SSDgf3AdbJ/BLhNUrlMZ9j05ea+lBLLoyMGdjxSbFyKpPrskkbUrYpxqZSSGaPL9B4cJYRnzmJFLK5YfWRuihV47PmYnkP7yOag3YXbxsOytIrOZQ+ujyM+eQhsGSkmi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pay5G7sV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e292dbfd834so7348085276.3
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 09:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730131308; x=1730736108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r02bHDcQ9tRemd8lnxwsawjLvScs8VGZuPjD+oM8q8A=;
        b=Pay5G7sVGRk7lZ4U2mLLuVB2WbBKDDdMjILAYb8IF7MVO2z4M9mjicrXyQSfpUeIMX
         lci/LRt6KYF3lM7gAKMIhHAhGk0Wt8oPWsQ3hHuWGL05zg2mFe1NUC9dfYogDfgnMCbG
         wOA6jtVdenJr8Y0jqFsTGMVSHL9Hgm27GlIwKndyZ3ospRtxwHLb/GSd/l2svu8wJwrz
         lIoDubslXLQBRZ6RKmQbqkQDX7WI3XVRu55/yC0f1EEvAst9RszwzfFNTK5dmzVFmGvY
         nREhdojBH1rEUempstGVxgC3//zV6nrJnqsY/9mHK0odwCI6w4WaszljbdaWAt4HeHQc
         u3QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730131308; x=1730736108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r02bHDcQ9tRemd8lnxwsawjLvScs8VGZuPjD+oM8q8A=;
        b=VH9IZxiarfFRlAwFaEjYPGbtarZ4eMv+wAFjsIk1+SrvL9aoximhCp99O4s1LIJdjG
         YEa1tue01yESdDn/unBMDItP6iFyVerNM4RzB21Fc+copX+0Sa2alOm5r5IavkygWgbG
         I8br4u69sv0rRl1pBcnonMO8jJQf7g3LC/aYwystG9QQbCenActNT+ZH4Jdrh2pHAE4N
         f5g/Rs00KYqzd4hPCudvjulZSCul6Fuy/dRWLlNDHzV84zleD7EhopUgYPldtKueU6iK
         MCujiCyijhw3fgNcax++odHZaHc3h9Sv8xz8JnWWvIfFXy0utAvZZH3r4vw/egW7mLjz
         lW/g==
X-Forwarded-Encrypted: i=1; AJvYcCU3jKCiTesQ93KRzi/T+3Vfd6kAFzMjeBBbltzL4o1OFL8CVCYPvCmVs+/QU4SdHjoqlmU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL+75Iv7J+AHU8qvzg2HJbwdJtaISxS3Gv/iFJczgbtQ1GbTgt
	7mFHQiYPB4r5LeCSypJomul4PqMV/kHnk2w5b0cU8QDM1KMAyroLE1xdsEnnCgA46TIrr48uWne
	DPg==
X-Google-Smtp-Source: AGHT+IEKUP2ZAMuHgHcmbZspRBm/ZQWf9eWaTd80Q0jLh5BNLTlzUUdtWo+08mkzloiLxpY8tEw/bnordWw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:7810:0:b0:e2b:d28f:bf28 with SMTP id
 3f1490d57ef6-e3087a48962mr44938276.2.1730131308346; Mon, 28 Oct 2024 09:01:48
 -0700 (PDT)
Date: Mon, 28 Oct 2024 09:01:46 -0700
In-Reply-To: <c8e184b7acf1e073c0d6cf489031bc7d2b6304b0.1729864615.git.namcao@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1729864615.git.namcao@linutronix.de> <c8e184b7acf1e073c0d6cf489031bc7d2b6304b0.1729864615.git.namcao@linutronix.de>
Message-ID: <Zx-1ahdKLH3o2MHj@google.com>
Subject: Re: [PATCH 04/21] KVM: x86/xen: Initialize hrtimer in kvm_xen_init_vcpu()
From: Sean Christopherson <seanjc@google.com>
To: Nam Cao <namcao@linutronix.de>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, Kees Cook <kees@kernel.org>, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 28, 2024, Nam Cao wrote:
> The hrtimer is initialized in the KVM_XEN_VCPU_SET_ATTR ioctl. That caused
> problem in the past, because the hrtimer can be initialized multiple times,
> which was fixed by commit af735db31285 ("KVM: x86/xen: Initialize Xen timer
> only once"). This commit avoids initializing the timer multiple times by
> checking the field 'function' of struct hrtimer to determine if it has
> already been initialized.
> 
> Instead of "abusing" the 'function' field, move the hrtimer initialization
> into kvm_xen_init_vcpu() so that it will only be initialized once.
> 
> Signed-off-by: Nam Cao <namcao@linutronix.de>
> ---
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> ---
>  arch/x86/kvm/xen.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 622fe24da910..c386fbe6b58d 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -1070,9 +1070,6 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>  			break;
>  		}
>  
> -		if (!vcpu->arch.xen.timer.function)
> -			kvm_xen_init_timer(vcpu);
> -
>  		/* Stop the timer (if it's running) before changing the vector */
>  		kvm_xen_stop_timer(vcpu);
>  		vcpu->arch.xen.timer_virq = data->u.timer.port;
> @@ -2235,6 +2232,7 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
>  	vcpu->arch.xen.poll_evtchn = 0;
>  
>  	timer_setup(&vcpu->arch.xen.poll_timer, cancel_evtchn_poll, 0);
> +	kvm_xen_init_timer(vcpu);

I vote for opportunistically dropping kvm_xen_init_timer() and open coding its
contents here.

If the intent is for subsystems to grab their relevant patches, I can fixup when
applying.

>  	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm);
>  	kvm_gpc_init(&vcpu->arch.xen.runstate2_cache, vcpu->kvm);
> -- 
> 2.39.5
> 

