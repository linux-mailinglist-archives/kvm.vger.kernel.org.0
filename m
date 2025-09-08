Return-Path: <kvm+bounces-57005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F63BB49A5C
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 21:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E6401B27273
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 19:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C3F2D46D8;
	Mon,  8 Sep 2025 19:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z2YH7Uvw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75482D3ED9
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 19:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757361146; cv=none; b=Wamd53f/hyTtChHX3JdUhLDCtyXw9eDKIm0VpW5UwzHq2G/jC7lhtVeyCMa4qjecLYuuYO1CjGU1J8IYGKTm8wWIadN3JJg64LjHVF8CWbb20a6TbTup6iaXeAfR4ZUrSKj8x9DQGEpK/v+s/wFvHQICriIGxsgmSTDMlYDQ7yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757361146; c=relaxed/simple;
	bh=ni41cp1kJj0k2/vDWCHyxCjBN8Adfrh4nUQNG0JAfr0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ghYy8AgXmDzlhJAMJ4GUSjOS0zQW8F15B1IMcCajxZUYEvy5FG8gJ4dponfY+UuUlpzsEQ+nmp3EvsKXaI3fqFC03M5h/KwkU3PXpRmj0GTx+I0ymbMwNBA6H6lL/tly3R3miO6xKymku7ZjA6YONI2xcKg5gqCQsp9K/t1MLYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z2YH7Uvw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32972a6db98so8203467a91.3
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 12:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757361144; x=1757965944; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5WmHxV7Lreaj5eVFu8hF6qzhJomNY/sSV63hQxdrkJQ=;
        b=z2YH7UvwPHG7hOnsoUEJAbW5/zfEZUnPeGWx1nBphACZjKch98yX1KPeI9m/K6QCEa
         YQuox+R4y1dSujCmUX3Z+Lf+7PgiI30juQCWKwUxHQnrB0/YN8c3v5i7iwj7iTcQsfs0
         wzZ4fDMnYo36fsgEPhAZN7O/mkHLgN0d8f8J5harw8RbG78HCXvuAsvte2vQk9vmLcA3
         Cbd16EISVJwjqUjXVKan6fUJdN+Y2WQpzUEx63Jx59EP7vC5KzUaZQ4GMo+FL/MxMplA
         8yIYDMh9cZrpwtzzdwXobLE3atlkqgSFn0al5IAo03NyZukluiWjCxGDt5riekzMnaU7
         vYYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757361144; x=1757965944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WmHxV7Lreaj5eVFu8hF6qzhJomNY/sSV63hQxdrkJQ=;
        b=cPJ9ExSARSPGyYTtggXszAj3Aw5nugVNJWcR0Dil/lJ0ffMTLWm4yEu2NATPLWPAf8
         iQvbVXcZk6fcSTXw5yrqG/M+5GwJh/vVj2X3NlYK3bwSFltQ7AC5eot49lmI8MiAeafS
         0vcxUUpuDFP5VruoeJnNQAY3TgY+rhoW2RxiYBmtzaTIIOXfwditXIx3ecoVQzCUg86H
         Lp3wRLoT7GPt2Ulx4v3eGiHw7LHG4tWBC2tSa2bmb1rvtgLDL8MKHya6DJCOj7zpLCnw
         LWTjnyiZjWvO1/1yVKLATM/THJpj8O4MXtSigzj87UiWKAzUz9erfnrUcSZKgs8xBiUF
         +KlA==
X-Forwarded-Encrypted: i=1; AJvYcCXhGHffYiVw8f6A/yInfhzff0+CSNFFiV171Wd+Vh0y1+00yFVXmp/8ofhKFlOmUV07NVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEvn7d84CcixIgfFZN23+tDKd/AtWVp+pZhVLhfhMd2KmMTS2f
	yrWt0PJYDJOUG53+D2a9qQXyEe+Kt2sNO/tr3bgdH4WAIp/vshrRb7ubD1hkWCWzsjBgGnEN4F+
	eKGzIog==
X-Google-Smtp-Source: AGHT+IExCPRBqVtXN8qVa8YjvqbzwvBpn9IxtzEsHXQ/2kgRMpC8TgSSgM/sP14o8i1EVRy2DO9MXQPJ5wU=
X-Received: from pjbsj13.prod.google.com ([2002:a17:90b:2d8d:b0:328:116e:273])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5185:b0:32b:d851:be44
 with SMTP id 98e67ed59e1d1-32d43f0b8e9mr11203024a91.11.1757361144105; Mon, 08
 Sep 2025 12:52:24 -0700 (PDT)
Date: Mon, 8 Sep 2025 12:52:22 -0700
In-Reply-To: <20250819090853.3988626-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819090853.3988626-1-keirf@google.com>
Message-ID: <aL8z9vZOAeQvTBKF@google.com>
Subject: Re: [PATCH v3 0/4] KVM: Speed up MMIO registrations
From: Sean Christopherson <seanjc@google.com>
To: Keir Fraser <keirf@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 19, 2025, Keir Fraser wrote:
> This is version 3 of the patches I previously posted here:
> 
>  https://lore.kernel.org/all/20250716110737.2513665-1-keirf@google.com/
> 
> Changes since v2:
> 
>  * Rebased to v6.17-rc2

Note, looks like you missed a tested tag from Li on patch 4:

https://lkml.kernel.org/r/b778c98abb4b425186bfeb1f9bed0c7a%40baidu.com

Nits aside, this looks good to my eyes (though I haven't tested yet).

Marc/Oliver,

Can you weigh in on the vgic changes when you get a chance?  And a more expert
set of eyeballs on the memory ordering side of things would be nice to have, too :-)

As for landing this, I'd be happy to take this through a dedicated kvm-x86 topic
branch, or I can provide an ack on patches 3 and 4 (there's basically zero chance
of this causing a conflict in x86).

> Keir Fraser (4):
>   KVM: arm64: vgic-init: Remove vgic_ready() macro
>   KVM: arm64: vgic: Explicitly implement vgic_dist::ready ordering
>   KVM: Implement barriers before accessing kvm->buses[] on SRCU read
>     paths
>   KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
> 
>  arch/arm64/kvm/vgic/vgic-init.c | 14 +++--------
>  arch/x86/kvm/vmx/vmx.c          |  7 ++++++
>  include/kvm/arm_vgic.h          |  1 -
>  include/linux/kvm_host.h        | 11 ++++++---
>  virt/kvm/kvm_main.c             | 43 +++++++++++++++++++++++++++------
>  5 files changed, 53 insertions(+), 23 deletions(-)
> 
> -- 
> 2.51.0.rc1.193.gad69d77794-goog
> 

