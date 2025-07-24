Return-Path: <kvm+bounces-53379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA3FB10BB2
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1A6B583DA9
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C032D9EF3;
	Thu, 24 Jul 2025 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jeH0vze7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2C113BC0C
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 13:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753364317; cv=none; b=XVACH/Cl/qGGTL65lr8ldlu26V+RkKokKCwYv0633ZcEmtw7uFjZOlSbWiVAufZ/UMovXysjLQFOZg59xrKoFCzo9G4lSRafN4C5TplJKcXXOyebhOg0ys0oGulTbDXGqLzXWcYtnY1NxTNdgyhvgpZYkf1EPq03IXCTaijrleE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753364317; c=relaxed/simple;
	bh=m/wAqpkQt/2RUTnKv++HTuPYU+CI570SgF46+i7FkLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GY7K/gAx/tWqnQGfXGZgvZSPVvL3ny/6zm3mF7DRNthb2x+wqbgyEPJLRFy24T2EuLr+JXfTMSxEGH/kVVZqafsYi3U6KUaiZl4TunudnAQpPVAvMNKW62Hy3DYUc/LDgjvr0YbbSFLVVhYB38rZuu+EOmnqYTYXYlBEizGw3Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jeH0vze7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313ff01d2a6so1089817a91.3
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 06:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753364316; x=1753969116; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pnOCmnwynw18L73v17uRUHZaF/x2KzABpPPoldpodcM=;
        b=jeH0vze79ZWziYZ2+7EE4fA/JYOyHvotSa2STb9WnotJEN4A4DpILMP2bXuucR43Ho
         VrzEWYRWoAveqWWY6MfpSJbs5IBUcQJz2hAnZETbS1SCd2pVEM8udbHVksVRTiQmLvwh
         KSeGa2KgKql9XdBTgUo26bXhAvPC+Bbq9Yf8yIKQCK5lXWwLfYfzTnzj3JdYkTsE9uhU
         RQF1EC0B7H6MF2zCaLJBeR77LErE8a5hsOMi44DGGZDdzn2q/WOyUB+SIyYEn/CgZfeQ
         pul/a4xdu7p35kEsmhmJqT5vzbysv3ef6U/nmUqx6R/CZn9IrwVXZq2Qs1zh5C1G3Uk2
         /BDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753364316; x=1753969116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pnOCmnwynw18L73v17uRUHZaF/x2KzABpPPoldpodcM=;
        b=ltA3Wug1NxSS7PVkw1doaj83SiBJ2j9nk1FPQcPf41kM5GiyTcQ88wRaY8OKaJqIn7
         teIxojyI1H7xfm0W95h1Rllu30SyGJS02bkQSL1nuMXvbwIR7queWAOQYbu3iBZ7V2y5
         ROX4XprJMFV69rKzlO3G78F/g5biKKkoh1gaDNLo2yR+a7OX32KYcE8Uq1XC6k6QM+SL
         2iQ4tmbHMje5PdfWXbXGzVC/Twq4tWcQE4Lr9knRZClN8j55Pom8P/MKzb5oKOMasCf/
         LxiRFl4Y/BWQ5MTGSpfEGcdSSImNr6kyFYa/MdSGt5aBn0R6DpcWNXnII/9k0TXutkcZ
         eabQ==
X-Gm-Message-State: AOJu0Yy/XWYQhNZJpyXJqW8SV95OHdqS1pGEnA5XGb01NQuiBoj3Qk5U
	8BCH5nZraLsfx6MsROsgLyvJFQm5d1ycxIt/ZTT/eTJxbfRgiT9fx6tB0/hhj0S3SHI8hScTqFB
	pFbQDzA==
X-Google-Smtp-Source: AGHT+IHKP5c6zCcsaBVGeUC9JnWHdf7x1ONH0Dz2EiRHoSL15bjGbff8VU+lzJo4qe+hePB23V/EWsWs/xc=
X-Received: from pji5.prod.google.com ([2002:a17:90b:3fc5:b0:312:3b05:5f44])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e184:b0:311:a314:c2dc
 with SMTP id 98e67ed59e1d1-31e507484acmr10767595a91.14.1753364315840; Thu, 24
 Jul 2025 06:38:35 -0700 (PDT)
Date: Thu, 24 Jul 2025 06:38:34 -0700
In-Reply-To: <2025072400-amendment-thieving-675f@gregkh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <2025072400-amendment-thieving-675f@gregkh>
Message-ID: <aII3WuhvJb3sY8HG@google.com>
Subject: Re: [PATCH] KVM: x86: use array_index_nospec with indices that come
 from guest
From: Sean Christopherson <seanjc@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kvm@vger.kernel.org, Thijs Raymakers <thijs@raymakers.nl>, stable <stable@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 24, 2025, Greg Kroah-Hartman wrote:
> From: Thijs Raymakers <thijs@raymakers.nl>
> 
> min and dest_id are guest-controlled indices. Using array_index_nospec()
> after the bounds checks clamps these values to mitigate speculative
> execution side-channels.
> 
> Signed-off-by: Thijs Raymakers <thijs@raymakers.nl>
> Cc: stable <stable@kernel.org>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kvm/lapic.c | 2 ++
>  arch/x86/kvm/x86.c   | 7 +++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 73418dc0ebb2..e10d6ad236c9 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -852,6 +852,8 @@ static int __pv_send_ipi(unsigned long *ipi_bitmap, struct kvm_apic_map *map,
>  	if (min > map->max_apic_id)
>  		return 0;
>  
> +	min = array_index_nospec(min, map->max_apic_id);

This is wrong, max_apic_id is inclusive, whereas array_index_nospec() takes a
size/length as the second argument.  I.e. this needs to be:

	min = array_index_nospec(min, map->max_apic_id + 1);

> +
>  	for_each_set_bit(i, ipi_bitmap,
>  		min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
>  		if (map->phys_map[min + i]) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 93636f77c42d..872e43defa67 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10051,8 +10051,11 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
>  	rcu_read_lock();
>  	map = rcu_dereference(vcpu->kvm->arch.apic_map);
>  
> -	if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
> -		target = map->phys_map[dest_id]->vcpu;
> +	if (likely(map) && dest_id <= map->max_apic_id) {
> +		dest_id = array_index_nospec(dest_id, map->max_apic_id);

Same thing here.

> +		if (map->phys_map[dest_id])
> +			target = map->phys_map[dest_id]->vcpu;
> +	}
>  
>  	rcu_read_unlock();
>  
> -- 
> 2.50.1
> 

