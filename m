Return-Path: <kvm+bounces-37489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A9C5A2AC43
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7611E3A067D
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC20A1EDA0D;
	Thu,  6 Feb 2025 15:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1lRK8uym"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04E61624D3
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738854987; cv=none; b=RB2nJ6pefjYwmzvzkXN1fGWrHuEHZ97KWrgcpeWbtvuS2NrUbWkdCxo8osgSPVhil14OCC1SNeCzXXALKUrIrNZi3F04gKE1tVd9lwapa3ghQvtg1bq30e95hZRk0y9ey3mvF+uPeTei7iL1uES1ScsYh2WA6hhuvV82LqTguhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738854987; c=relaxed/simple;
	bh=wrUO/pv3wuaL79TztGdwTHBbUZYh8NrHCiOXYPaysQw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QVIWZjqmXaAcXqhNoQkVeuczaccDSj4YRMvR6llaQ0SNC/muID/nziHBI0oZ3HlsG0ZBfe/ugBFsR91iijl031AQwtzohu0cU/pZjYxhPLYOczz87s7xyURHfD8VAlZtEnPPdz3f66Hg1q3aFlrd8hXPzSa2nDL2Y0oOnQ8+uNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1lRK8uym; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21f1e5c641aso36548035ad.2
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 07:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738854985; x=1739459785; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/O+gmVjEiO0izHw1wyAH52hjvhtcTqnj2hmp9TBo5bg=;
        b=1lRK8uymqlKIs6snVbz/1dDLNX0RLawoBPiyPtfDI9tGq9BTqjMubT8i+h+NfvhCqe
         vIBBEiPenmYFnNAOagZUKSWGinRQtj66CHHBxFK3ZHS3IUasijflKJTe3DUYoJQH4UGL
         CGySGfqaXcfsAnBGW0trMyF9D/hMhcDeMUs3ieb2vFRkl3QVZjEAv68OjZLqUwMyJmj6
         9yTDtcEZBLUszhD3IMC3Eo445+bxjMQMJdElyD01zVbiDeMpGKvdnsfmbsTXrognOF3c
         6bD/2aHHkdZpzmnl7+Ba7tUD+KWlYnZiXOFxuXMjp70vn9EVuU7F/n2z8Q7QZsm56YkN
         80EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738854985; x=1739459785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/O+gmVjEiO0izHw1wyAH52hjvhtcTqnj2hmp9TBo5bg=;
        b=CPf95AQVce5CGlFsfmz9xrFrSR0GPvc6v6sFLSCXtIkxzQ8CHQJKy8TecQ/rAmM41m
         OfNLqRO30MIzj7Sm0J+ADkBbQ9Padkj/x/5XvB/QoemBzmOXdUVXpfz2t9Livj/vbPbw
         2GwxDRtLlc/2EK3dBHDHLoB46o90UM1lJd6w0H1XG4iX0aWRnlQuSbNtQmXgPdRy4HJM
         wgbvTY6KHZeYoRKq3RnmibeN7AR70nU7c7X1FV7G7cOH9d3DGeazgvx91BvMqR4r8+Re
         LHbSfocFRuACRDVeoh7dHhGRQwdg60nYHkr2sdJuuVfjfTykeCSuqe3S891xRm3UsiNd
         G2Bg==
X-Forwarded-Encrypted: i=1; AJvYcCUvtpihagBLppqc8uDSGlVnBeGssuaV6SYFh9Yz/PKbIrrWkrMX8VMyyJMpWKpG0alGlEE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/bWPySuf6Un8tss2hMnRr6TmE5sOr8mDWCP943uCheNabD+b4
	NRF0ZuKQ8elO8WpLKbjTHww66WTniaeFNIhKzcFBmy3WNg/Qe4ZIWtH+22depKUgPjIKBFFVZZ5
	UAw==
X-Google-Smtp-Source: AGHT+IEqoERbvjL8QRLQoY1mFC+xOoqWn74MjyilsWi+ixkfWOF6DG/8rz3OjKhU93twnCTVaEwniXbu6Nc=
X-Received: from pgbft13.prod.google.com ([2002:a05:6a02:4a4d:b0:837:acbb:873a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d705:b0:1e0:cf39:846a
 with SMTP id adf61e73a8af0-1ede88ab90amr14153239637.29.1738854984884; Thu, 06
 Feb 2025 07:16:24 -0800 (PST)
Date: Thu, 6 Feb 2025 07:16:23 -0800
In-Reply-To: <20250206022656.3752383-1-fuqiang.wng@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250206022656.3752383-1-fuqiang.wng@gmail.com>
Message-ID: <Z6TSR8UmtNNHFeUQ@google.com>
Subject: Re: [PATCH] kvm: delete unused variables iommu_noncoherent in struct kvm_arch
From: Sean Christopherson <seanjc@google.com>
To: fuqiang wang <fuqiang.wng@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	wangfuqiang49 <wangfuqiang49@jd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 06, 2025, fuqiang wang wrote:
> The code of legacy device assignment is deleted entirely in commit
> ad6260da1e23 ("KVM: x86: drop legacy device assignment") and the
> variable iommu_noncoherent in struct kvm_arch is also not referenced by
> any other code. So it is deleted in this patch.

Someone else beat you to it by a few weeks, I just haven't applied the patch
yet.  Thanks!

https://lore.kernel.org/all/20250124075055.97158-1-znscnchen@gmail.com

> 
> Signed-off-by: wangfuqiang49 <wangfuqiang49@jd.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index b15cde0a9b5c..98555afb6f10 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1354,7 +1354,6 @@ struct kvm_arch {
>  	u64 shadow_mmio_value;
>  
>  	struct iommu_domain *iommu_domain;
> -	bool iommu_noncoherent;
>  #define __KVM_HAVE_ARCH_NONCOHERENT_DMA
>  	atomic_t noncoherent_dma_count;
>  #define __KVM_HAVE_ARCH_ASSIGNED_DEVICE
> -- 
> 2.47.0
> 

