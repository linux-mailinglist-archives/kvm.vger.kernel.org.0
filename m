Return-Path: <kvm+bounces-52940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E55B0AD7F
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 04:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24B5F3BDE6C
	for <lists+kvm@lfdr.de>; Sat, 19 Jul 2025 02:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967791E25F8;
	Sat, 19 Jul 2025 02:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDweOYIX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7239C33EC;
	Sat, 19 Jul 2025 02:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752892643; cv=none; b=Luibdxt2yAozXSo9pojqI+UCNrgbDoVzIE+xQZDpxA+yA+iaeMRPswR4lefbS4+v5pgC0m31FqYm/w0s620m3RSKKgCXudfjC7RV6ld0QlUgVizMG/9z3VcCLGVabiVa02geBfUqlbB2pGkC3L4WcW3n3Kipsp9by6M4ejl3AsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752892643; c=relaxed/simple;
	bh=KIVA6REMN8H6oOLux4sfSiNKNJnFGdIXADK6o7yNqHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5PEtzJlvz1wF0eUmINPTEjRckbEGdx2Er20Frx/3Yp71u6W1td1mHA+ifwgMLH9SUkolZeRyZR8kme9W7ay53UQ9f6Nw+EMIoeRlepM1yPliRwQa26McodZtu4nZY0hmFDJ9q+haRqLELcaKKMEW9EaLYtQ7cpwHUostaQzC/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MDweOYIX; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23c8a505177so25123655ad.2;
        Fri, 18 Jul 2025 19:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752892642; x=1753497442; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mmJMEJ8CBKKO2kYbDPf0j/vMdEOUiylooeiw9fBRZ6k=;
        b=MDweOYIXFTtOXhZcOM+e5HXQx3Y1PgdTzjo2DPQESblqBglgcD6vZVeYwdc57MFOaM
         xUcAhvDU9MnLYPD3OtDjwr35Ax56IWDMxGAeUfBifiLsLa5Fw1zxL7qbAZVUq4GdSQUL
         2I/3WJH53CRG1tUQGQJwddmIP8svcN7uUznMWt0PLiLCMGKusFu95v1KzBmAoiioyApC
         yaPgobefi4FzxNpE0HvBK86QTqdBIQHLQjbq8xifbCR6aU6UuDJAsYNx5IxLKCFpGf4U
         +Q3jk954PRQHEZLCfy8EnUZJKkXfy30IS4cV1yZRGl6fhOgQj7kKYgzirFKGcMJNzLoX
         ZBhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752892642; x=1753497442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mmJMEJ8CBKKO2kYbDPf0j/vMdEOUiylooeiw9fBRZ6k=;
        b=YOi3Oem8oYJAyEGjph3BuWHEOmDMW/fxpVHUI08OHKzhVnxxmXv4khywKcozzXNGND
         2O/VjfGSi4fPKCQfWRudDKi31A1CVlyg15dx3VWm+VdVAIjtJOATwT3FCrMrLm97vgws
         hgdMS6tu9bvJOppit9gq2D0bLNf8ZaZIPNg48X0xe62A9ChxcmxqQ52Bapcp/rCJsnpP
         ckAbH8UsjLlaJPbAxdnlpSQH/eV9ZeI7cu/YKhL5QtG4eCHEGMv+6asOgbHNBNWbod8t
         umdpfMcY4frdiSGCGsCsRHPLzE7j2diQ4cFj2tpDMbkIpERNyRyvaVVP81ee5DaxzbAO
         iEwA==
X-Forwarded-Encrypted: i=1; AJvYcCW/YEeNUGOoUh3z8iurLTKPWOS6B9hpoNykugDARahf5uhQYWsTbAeTEpZjYLH3NQkusoY=@vger.kernel.org, AJvYcCX9vXijpFcgqP7YPDmrsl3x+HhS2TcjUyOVsuB+/TV+eii4Cn+w1u2UuvUfu/mgGMBrCket3MeZ1b1aGjrt@vger.kernel.org
X-Gm-Message-State: AOJu0YxCoIsWKnUSnSFrlW/joOhS581xN4YtalDs6G+uXknkFoxjsaJB
	qEXm+ACBywqOox0PY78dlCPt5SLdWx0uNdUQPe+4hCXOW3jWATg7Zf8O
X-Gm-Gg: ASbGncuOF6pD1llaS8UAa2qqkzXak0VK2pIoEOU35WVYdObIefhtqbvjTzjOlf5g7Pc
	RamIJgWaTNjCDgY/EG5BviAOc/1RWw2nPBcdhminmwc0FYz5RSJyuXSthzAAiTeSTdQkv3IMxae
	3WK321zXK6Gj+oYlysKZsMDKQ+bXIs8abIhJ8wYMf+DC6oImftJreETFKbPyxf2OmZPeOA5qONn
	B+94ql3rTvmjEvKrcnZGBfLqgzfEEhDrYwU4d3hixEG6rXtZrHZOlO2DnfRfb8Bqpv/r6ivPwo1
	+zVY4Le9dQ0f6GB8cx43VvWWEyXyrv3wA5GlgwR9uAATsEtz3uR5UUmEPboCXPeeNumPWUkYuNL
	oUDHMU+LDFXBns3MSM5SA+Av+mw==
X-Google-Smtp-Source: AGHT+IHs5pq3GcJWKuMtDUrc0Y5CYsi9XeqZUlq9pzhl8kPltEUbezNpqEVKb0km9n9B1drEwGrtoQ==
X-Received: by 2002:a17:903:b47:b0:23c:8f2d:5e23 with SMTP id d9443c01a7336-23e3b89a480mr76816525ad.52.1752892641661;
        Fri, 18 Jul 2025 19:37:21 -0700 (PDT)
Received: from localhost ([2409:891f:6a27:93c:d451:d825:eb30:1bcc])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-23e3b5e2cbfsm20297065ad.9.2025.07.18.19.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 19:37:21 -0700 (PDT)
Date: Sat, 19 Jul 2025 10:37:12 +0800
From: Yao Yuan <yaoyuan0329os@gmail.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yao Yuan <yaoyuan@linux.alibaba.com>, Keir Fraser <keirf@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 3/4] KVM: Implement barriers before accessing
 kvm->buses[] on SRCU read paths
Message-ID: <yr5vh2yn25fxa7xeja6gxix6nlqvx7jdwfuurwvf26523vnbiz@5ppp455mjuuc>
References: <20250716110737.2513665-1-keirf@google.com>
 <20250716110737.2513665-4-keirf@google.com>
 <ndwhwg4lmy22vnqy3yqnpdqj7o366crbrhgj5py5fm3g3l2ow3@5s24dzpkswa2>
 <aHpgLnfQjp3qdZOL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHpgLnfQjp3qdZOL@google.com>

On Fri, Jul 18, 2025 at 07:54:38AM -0700, Sean Christopherson wrote:
> On Thu, Jul 17, 2025, Yao Yuan wrote:
> > On Wed, Jul 16, 2025 at 11:07:36AM +0800, Keir Fraser wrote:
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 3bde4fb5c6aa..9132148fb467 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -965,11 +965,15 @@ static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
> > >  	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
> > >  }
> > >
> > > +/*
> > > + * Get a bus reference under the update-side lock. No long-term SRCU reader
> > > + * references are permitted, to avoid stale reads vs concurrent IO
> > > + * registrations.
> > > + */
> > >  static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
> > >  {
> > > -	return srcu_dereference_check(kvm->buses[idx], &kvm->srcu,
> > > -				      lockdep_is_held(&kvm->slots_lock) ||
> > > -				      !refcount_read(&kvm->users_count));
> > > +	return rcu_dereference_protected(kvm->buses[idx],
> > > +					 lockdep_is_held(&kvm->slots_lock));
> >
> > I want to consult the true reason for using protected version here,
> > save unnecessary READ_ONCE() ?
>
> Avoiding the READ_ONCE() is a happy bonus.  The main goal is to help document
> and enforce that kvm_get_bus() can only be used if slots_lock is held.  Keeping
> this as srcu_dereference_check() would result in PROVE_RCU getting a false negative
> if the caller held kvm->srcu but not slots_lock.

Ah, I noticed the srcu_read_lock_held(ssp) in srcu_dereference_check() this time !

>
> From a documentation perspective, rcu_dereference_protected() (hopefully) helps
> highlight that there's something "special" about this helper, e.g. gives the reader
> a hint that they probably shouldn't be using kvm_get_bus().

Yes, I got it. Thanks for your nice explanation!

>

