Return-Path: <kvm+bounces-52903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D54FB0A6BF
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:00:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB6231C40984
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61CA12DCF73;
	Fri, 18 Jul 2025 15:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DStL56Kj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B4384A2B
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752850821; cv=none; b=b+rJsg5ZjJTpiWQ5PkwehwzGnxpFnfbxQ+wrfflzWYKjvsc3879ebB49cz4i0BcTFibw9mLV6uRyQK1ugtIwW1W9BnFJBDlR5dD8GJ0YANO8nHGVC8G4Wfnd86BdfjM3iydI6ocaMjkXviJFbcayKeSkuk+UM5/O82PzMK5vEtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752850821; c=relaxed/simple;
	bh=u5Uimzpn68rKoDXEiNCN9Z2LTkmsdzYhRRN6TNmd3tE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e9JiwfMXRhYEKWP8134VreHfbNHgBOib1dfTdJjleLmCFPWtnV/mW1v2P0VEW0pGN/VSpkiG1ltqgGC913RTP4CaG3UNcnVoCR8mUIQBQNuOgjOgYfNUnZwcQwXIhs75Hf5XaQRS6CEvroDlmjjzSo3/3riGDyI+LHHsw2P2H6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DStL56Kj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138f5e8ff5so2438101a91.3
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 08:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752850819; x=1753455619; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vupMdWkKONZrvWZyxZjI9RuKIWcmnqNg++2GIJkgpb8=;
        b=DStL56KjvtxW57lZb2jud+rfwtIYn9rkOcGnpzQgoCP7Q670+y8Yu6yDMr4MbPcw0y
         jNe6AYRmAuVFQuwL2CSgmXXpxarawumEaaSdhQrO6QQ6prTcWYT+8zSzbxJp8+m1+8uo
         K8NirltQceb+sEYaahB/7N6QenvQ0jhRlGuLkcKK/sURs4OH/gnJWxjEayA0LGO6cKfn
         LevCU9hT9EtV7XeuS306s3VnIrHVclbAGR4qjzEXBKG6cuVJjEbEoXHO0OayYQi2BTVm
         wv7g8YqnB+EZNrAcnb8Q8S9ZsRj/u0F3YUHdVIT1oDsJlSjyMR5OssLtjtl4e/kO1I0U
         5ESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752850820; x=1753455620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vupMdWkKONZrvWZyxZjI9RuKIWcmnqNg++2GIJkgpb8=;
        b=s4enKzKifv/yn+Jl3NE1M8pwM1BlEbD7P8LNCDAR48foTUhS6mjnWkXEc+PEr1lO3U
         79H6FzEquvsrX5YKg7BefuyGLfouZqOGippI9yD6cqDdTEIFmzogM9qlYhKj5btGBYvG
         SKPNeWRCzfpW/CLNKl0vMuJj5n2QmaVAlS2+cUvsbC4UkHrVCRUnHI8Xrqj3Px69sMdP
         qJWa04nz/o6qCRpyuuWyI8gnSKC12obCVs0rV3PFFGpMkVKlLnWGAipB3ngo1I/r048q
         DQhBNpOXzO3Dgx3jgDqQ2jPrfKN1aPY6gUk/TJNQdZyVmp4wOaKhtrqrWywUi/AVWrVY
         9baQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2P0QlCT7fjJDe7p07LvDczVGmoQeBi9/gf2BXfS0FyKu49MMXRM3oDMbDHXcJm78uCxY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7HTEtdPiJIk25tGodS36/2OOM7pzyyqtdErzmy0yUZfCYRyGH
	ay71mviRJtovSg7l/5ONlFayYlG+V+aX6AUSrvkc7SSfT7cq6Mm185juxowMMkMjwNhGqruXtZj
	LyJgPhA==
X-Google-Smtp-Source: AGHT+IFjxELA0BNq1G4E0QijL5FN9/8iFWVvHq5YSj689yONqS6ui827UBJhsYL4QvQGyIsYC6a3QGkZb5I=
X-Received: from pjee13.prod.google.com ([2002:a17:90b:578d:b0:311:f699:df0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e46:b0:313:2754:5910
 with SMTP id 98e67ed59e1d1-31c9f3eea5amr15965053a91.15.1752850819578; Fri, 18
 Jul 2025 08:00:19 -0700 (PDT)
Date: Fri, 18 Jul 2025 08:00:17 -0700
In-Reply-To: <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250716110737.2513665-1-keirf@google.com> <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
Message-ID: <aHphgd0fOjHXjPCI@google.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
From: Sean Christopherson <seanjc@google.com>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
Cc: Keir Fraser <keirf@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 17, 2025, Yao Yuan wrote:
> On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> > In preparation to remove synchronize_srcu() from MMIO registration,
> > remove the distributor's dependency on this implicit barrier by
> > direct acquire-release synchronization on the flag write and its
> > lock-free check.
> >
> > Signed-off-by: Keir Fraser <keirf@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
> >  1 file changed, 2 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > index 502b65049703..bc83672e461b 100644
> > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> >  	gpa_t dist_base;
> >  	int ret = 0;
> >
> > -	if (likely(dist->ready))
> > +	if (likely(smp_load_acquire(&dist->ready)))
> >  		return 0;
> >
> >  	mutex_lock(&kvm->slots_lock);
> > @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> >  		goto out_slots;
> >  	}
> >
> > -	/*
> > -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> > -	 * registration before returning through synchronize_srcu(), which also
> > -	 * implies a full memory barrier. As such, marking the distributor as
> > -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> > -	 * a completely configured distributor.
> > -	 */
> > -	dist->ready = true;
> > +	smp_store_release(&dist->ready, true);
> 
> No need the store-release and load-acquire for replacing
> synchronize_srcu_expedited() w/ call_srcu() IIUC:

This isn't about using call_srcu(), because it's not actually about kvm->buses.
This code is concerned with ensuring that all stores to kvm->arch.vgic are ordered
before the store to set kvm->arch.vgic.ready, so that vCPUs never see "ready==true"
with a half-baked distributor.

In the current code, kvm_vgic_map_resources() relies on the synchronize_srcu() in
kvm_io_bus_register_dev() to provide the ordering guarantees.  Switching to
smp_store_release() + smp_load_acquire() removes the dependency on the
synchronize_srcu() so that the synchronize_srcu() call can be safely removed.

