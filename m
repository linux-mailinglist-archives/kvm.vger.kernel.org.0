Return-Path: <kvm+bounces-36590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44EFDA1BFFB
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 01:50:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B7E4188FBF6
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 00:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C4DCA4E;
	Sat, 25 Jan 2025 00:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ND3Mfqdi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E148489
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 00:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737766221; cv=none; b=MqZiAq/t1JydJ4gXxiXicqmSNvCdh6OxYK9IsoWN3syD9lm5PyZqVVJXrofcloPf5f6+lerTEj8GF/JmIPXQV9FGwnE3aX/XIfQK+A28go7+EdVgoRmf1+C/a/4/Xu1uCEUYD0wfBpV6P56HEMB65oz5JkI58VEY5qSscGrp5Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737766221; c=relaxed/simple;
	bh=oEGupVNDTZ1TZfaKV7p2mr3SO5fE4Coa0z47OYyQvys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=hRsjm4HJIsGeJna5F1YhmhDLMzY3A98JFkRtaO2EjhLkCPr1GceHlm4V1MglQL86TMroazzCoLZCkP7tjOWXV2A1hEwgCb8f4znPxQhcR1rtsgX62C8/5Jl57a1ai/j/xNCgWisrsOK7J5Iio7RyDeK3ck9dEDX1kVh/78Wv/1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ND3Mfqdi; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216405eea1fso53288975ad.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 16:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737766219; x=1738371019; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0i8PhjRzp2KlZn/OgBC0R5Tc8Tj8apF3Z4WwS7zlbko=;
        b=ND3MfqdiUQCbvGduVtzI4P49OLl9p7zrgxTTILMVzV2j8C9d8+Uj9z7VFgxWtxRgX0
         dgYKoqhF6icIQZcX8T6LBFdNLA0CWxWmweCWaQaxFeeioIQobaRrgwVIdhL+vVbLeYgR
         ZB3XOWV2/E+EisZRpD6DYg0V5Us49YaNIkFzTOv8g9FkQE9vQ+MfkHNwPhoKPo3D4e9j
         pYFJoE3s7eUz0ITliOL15xCYmMlhtsgTE8mTj4bAXlOTK/VVZCRgASqEpyIWHKKVePze
         Ok1dFm6VQWT2bImLWxEkZobFyy1hcMOMpvdM05udp0iGr+8lKzzB2cPkKoUKBldhz2R9
         cmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737766219; x=1738371019;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0i8PhjRzp2KlZn/OgBC0R5Tc8Tj8apF3Z4WwS7zlbko=;
        b=ZAxbThDrlQfkv6voQ6EE9Qt1yBWKcSofUF7gosEom68Y8vZZGd9MmgOm/32KbDP8zl
         +YIlncd6vJYREehY1TTuwPrCbaHP8CZk/iPWeEy5j45zTsCog4Lo/VZnIQmlMA+u7Nye
         o42Q2XjEsgNiHnEbRghno6njeY6/Q+cO8uDWZx6ito400dHsh8zUNxiXDX3okPXkMjii
         3XRN1kI30mdtEnau4L/gckSlYT9Dlymprls0rAkZVfEc0OLaqH9UTEU4lJQBUuL//6OX
         PoD8o4afvsupLhZ2TSPrP1f76b578DHuQYx2FqW13la4DA396j/vXoq3aQyYa5/kDuJB
         G3Uw==
X-Forwarded-Encrypted: i=1; AJvYcCXRqkb8smTpSSIqhcp9hQspeI73/+8zAwV/soL8sDdE2J0Z7ry6hoDyWUxix/pyoKs9Gmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF+6UspT11HWymPUCQngCk0+SSyE1YPKlId+QEl/Z62AEhIzd2
	slos9he9Qe7qSi2WshtZvjnSc/4spJia2Vn/aucRh7EOM4iDafZTCYL2rHjQdIOy4EqSIsT76mG
	ZSQ==
X-Google-Smtp-Source: AGHT+IESQ7fgogXW/Au/e5Du8hywDj5Be3G+Eu0iSGzrsRlqChwX2lYnxbj77S5/1Wo9bC1eghKSlPn1yTU=
X-Received: from pfbcj8.prod.google.com ([2002:a05:6a00:2988:b0:72d:8b6a:d16c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734e:b0:1e0:d848:9e83
 with SMTP id adf61e73a8af0-1eb214e526cmr50355103637.25.1737766218822; Fri, 24
 Jan 2025 16:50:18 -0800 (PST)
Date: Fri, 24 Jan 2025 16:50:17 -0800
In-Reply-To: <20250124234623.3609069-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124234623.3609069-1-seanjc@google.com>
Message-ID: <Z5Q1SQ-JI6PdmVbi@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Ensure NX huge page recovery thread is
 alive before waking
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 24, 2025, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a45ae60e84ab..74c20dbb92da 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7120,6 +7120,19 @@ static void mmu_destroy_caches(void)
>  	kmem_cache_destroy(mmu_page_header_cache);
>  }
>  
> +static void kvm_wake_nx_recovery_thread(struct kvm *kvm)
> +{
> +	/*
> +	 * The NX recovery thread is spawned on-demand at the first KVM_RUN and
> +	 * may not be valid even though the VM is globally visible.  Do nothing,
> +	 * as such a VM can't have any possible NX huge pages.
> +	 */
> +	struct vhost_task *nx_thread = READ_ONCE(kvm->arch.nx_huge_page_recovery_thread);
> +
> +	if (nx_thread)
> +		vhost_task_wake(nx_thread);

As mentioned in the original thread[*], I belatedly realized there's a race with
this approach.  If vhost_task_start() completes and kvm_nx_huge_page_recovery_worker()
runs before a parameter change, but the parameter change runs before the WRITE_ONCE(),
then the worker will run with stale params and could end up sleeping for far longer
than userspace wants.

I assume we could address that by taking kvm->arch.nx_once.mutex in this helper
instead of using the lockless approach.  I don't think that would lead to any
deadlocks?

[*] https://lore.kernel.org/all/Z5QsBXJ7rkJFDtmK@google.com

