Return-Path: <kvm+bounces-52937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B82B0AD78
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 04:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDFC71C43AA2
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 02:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA7E1C5D7D;
	Sat, 19 Jul 2025 02:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XfBPK90D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6DF224D7;
	Sat, 19 Jul 2025 02:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752891505; cv=none; b=jvDU6gjSsa+k+0tZhxClMmfXQtPD3zopF9XCUHHmm0M6+uvns4MZjg61psFBTNwgDOhB/32zmxxggM+infbS2BVtaYme8DJQUxRh06+r9KnXTB1VfZCHsHKQFZzCkrfn962t5nLCJawyyd0vp94uDkGtHhykFgDD1XL4BBGTobs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752891505; c=relaxed/simple;
	bh=Zk/o38lPu0GsIj9gRObIbM29T5weVpXkSDm8WmFPFmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h1Hqcpfl5rORK4wtt3CsC/NJSajifgWCBUsianMf4BpbSc+fM6Hcf2GaRoZSI9qIi6RLdysgMmhRK9gNf7Mpa7jqnIuXdWbw1UINKYpldkumQJyj8izW7NTfgqd6T6pemWVGLO9F1acoM/1d+VT0oN+UcEUUjww9lo8isC9BCRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XfBPK90D; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31c4a546cc2so2329900a91.2;
        Fri, 18 Jul 2025 19:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752891504; x=1753496304; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Scnqs5pk340zKN/IMxaD8uFN1w3h3QowSgutbiQPbOA=;
        b=XfBPK90DS71475VJO37F/UHGvLpjzgqvKSxrvoKR7iETMvl1vWrbu0ImxkrmVETlR4
         Aq3D+BZkOXweYYVW77+3l4fCng5W45+YICsx4bjiX3biWyza64fLfXJO0oCcFOZSLmaT
         exFJbT1r2NT85d2VWHEAxnEeG/p9jPcPv6StipJ5Eec1mOWAuDGScJRwZZMLn9xRiVlT
         NEJu1xU2+iZemV+6aHofk/wp7IZtjjcqBaRj6pTmJOdXqWRzNF6oTPX+g9wuJGvHKzaM
         VQhkg9DlGXChLGn3bEHDkxAWm+rCXDXpiFpybP9nJjvn/Z59OvB1SdnULCB3T0jlRiXg
         9+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752891504; x=1753496304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Scnqs5pk340zKN/IMxaD8uFN1w3h3QowSgutbiQPbOA=;
        b=CM9ukoWqjWYUlXZZPm4jclKLyIBw1rC6zuNB3eLgaEKgKHwHYbT/nUuSZ/Vb2KbqC6
         Ydb1oJwfqaMThjUzF66DYHOEmRm+pzGalXJ2HMI+j53pywrwZIOpgs+V+fufVCu8OeOD
         sm8VGX31KZSvNzSW06bA1wPLGZkbKjn1oBeq/xqRgFPp7lsRhnbpDIRSZJ9LtZMrIGdt
         4V/kRyJw/xTPioci16Xm1sZMsKz//5KZ+CpcFmFx6l9vaRAclqE3rBRHrMRY3SS6NDBb
         jcrwd2pkTUp6cls1xdW+eclI5UobONV9xQqUtSZYQf5w1P8EyFOPMjlewTpkCivyjrlD
         tUew==
X-Forwarded-Encrypted: i=1; AJvYcCX/DLQtQBQ30JgDl8+N05zmBPtskb8kKCAVe/LmsyBguQ6hFvO/+bDIz+HXCzzuysvHHcpYluIDfNL2aaiL@vger.kernel.org, AJvYcCX4PR+aUtuLnzokDbRr1eaj6Ub4t7rnj8Bz33aeHf6GpLkmcD5RkM6g9fNz+ehvep2/4cc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkflBNOE35jHcZOeLHDQcQhtN4nxYv+7hDBh47N28JERXqD+Dc
	rJaDdtgJtpdlnggjfQnL52AFaFOTVQ8DjDJWcvaf9Z3IzWs7/DKFU2hr
X-Gm-Gg: ASbGnctV1KgUciHxPQe+CbTLb7GfD50KuYsrdwvSHkFB3CJvGeNU/+0TLMjxfWT/NzU
	1yLi59+uM7eu8tfVqYmZcKa7I8Tpd9XiF0Wbp3eaDzQ4xQXK/vq2KW9Zjr01GnAZDpYSU3GRTCG
	x/+swCIs66p9V2CAcF8ysKzKSXbfCRuquqrQPqtqmz2lIG4CtyeaQl8Vz0oTDeHNjSQamE3xyC+
	gPprwxHSXhUrB6SlULqcNOzMpWDx+45jBwcSx1qIHlNv8bLH5zjcIgX4v0eceZBbCvQK0XnsZzv
	j7+NdbP/DktF2grJbiOaPUJ2BqnU/d2gvZ183bGAa4E3A/z3qDhsBQnW1nu3IkSuOdFmSNL+azI
	GgNB96QCQUft2JOs1wUf7LRCz5w==
X-Google-Smtp-Source: AGHT+IHXIiFPtH//gJNmM/1/06X218/c+AnTD0afEkaxcRjYT0TB+ufmUNpan+0zr5nVWSbonniezQ==
X-Received: by 2002:a17:90a:d60c:b0:312:ffdc:42b2 with SMTP id 98e67ed59e1d1-31c9f4b409bmr17155214a91.23.1752891503580;
        Fri, 18 Jul 2025 19:18:23 -0700 (PDT)
Received: from localhost ([2409:891f:6a27:93c:d451:d825:eb30:1bcc])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-31c9f1ba530sm5900828a91.4.2025.07.18.19.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 19:18:22 -0700 (PDT)
Date: Sat, 19 Jul 2025 10:15:56 +0800
From: Yao Yuan <yaoyuan0329os@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>, Keir Fraser <keirf@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Explicitly implement
 vgic_dist::ready ordering
Message-ID: <5zpxxmymnyzncdnewdonnglvmvbtggjyxyqvkf6yars2bbyr4b@gottasrtoq2s>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-3-keirf@google.com>
 <kb7nwrco6s7e6catcareyic72pxvx52jbqbfc5gbqb5zu434kg@w3rrzbut3h34>
 <aHphgd0fOjHXjPCI@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHphgd0fOjHXjPCI@google.com>

On Fri, Jul 18, 2025 at 08:00:17AM -0700, Sean Christopherson wrote:
> On Thu, Jul 17, 2025, Yao Yuan wrote:
> > On Wed, Jul 16, 2025 at 11:07:35AM +0800, Keir Fraser wrote:
> > > In preparation to remove synchronize_srcu() from MMIO registration,
> > > remove the distributor's dependency on this implicit barrier by
> > > direct acquire-release synchronization on the flag write and its
> > > lock-free check.
> > >
> > > Signed-off-by: Keir Fraser <keirf@google.com>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-init.c | 11 ++---------
> > >  1 file changed, 2 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > > index 502b65049703..bc83672e461b 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > > @@ -567,7 +567,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > >  	gpa_t dist_base;
> > >  	int ret = 0;
> > >
> > > -	if (likely(dist->ready))
> > > +	if (likely(smp_load_acquire(&dist->ready)))
> > >  		return 0;
> > >
> > >  	mutex_lock(&kvm->slots_lock);
> > > @@ -598,14 +598,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
> > >  		goto out_slots;
> > >  	}
> > >
> > > -	/*
> > > -	 * kvm_io_bus_register_dev() guarantees all readers see the new MMIO
> > > -	 * registration before returning through synchronize_srcu(), which also
> > > -	 * implies a full memory barrier. As such, marking the distributor as
> > > -	 * 'ready' here is guaranteed to be ordered after all vCPUs having seen
> > > -	 * a completely configured distributor.
> > > -	 */
> > > -	dist->ready = true;
> > > +	smp_store_release(&dist->ready, true);
> >
> > No need the store-release and load-acquire for replacing
> > synchronize_srcu_expedited() w/ call_srcu() IIUC:
>
> This isn't about using call_srcu(), because it's not actually about kvm->buses.
> This code is concerned with ensuring that all stores to kvm->arch.vgic are ordered
> before the store to set kvm->arch.vgic.ready, so that vCPUs never see "ready==true"
> with a half-baked distributor.
>
> In the current code, kvm_vgic_map_resources() relies on the synchronize_srcu() in
> kvm_io_bus_register_dev() to provide the ordering guarantees.  Switching to
> smp_store_release() + smp_load_acquire() removes the dependency on the
> synchronize_srcu() so that the synchronize_srcu() call can be safely removed.

Yes, I understand this and agree with your point.

Just for discusstion: I thought it should also work even w/o
introduce the load acqure + store release after switch to
call_srcu(): The smp_mb() in call_srcu() order the all store
to kvm->arch.vgic before store kvm->arch.vgic.ready in
current implementation.

>

