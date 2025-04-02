Return-Path: <kvm+bounces-42530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C1CEA79928
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 01:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39DCC1894507
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 23:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A9D1F8744;
	Wed,  2 Apr 2025 23:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hxwGibG+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1131F6679
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 23:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743638202; cv=none; b=hQq54m+a+VQDXMovzY81EbG0PcLUG0iaydf2IDUGqE2i85UPkA37z65FOJ59KNha6v3xk+cB8vcueD0zKOrVUzT8IPGP/bp9qrd4G55qExl4ae2Znor1DqcetFHqn7c9kiwiDo7jQSzOMy7Qw9BGnUIgzROp8XEXIaXk2vxZwyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743638202; c=relaxed/simple;
	bh=nNa8PH8NePgpbzvnqhnNn/kePEDAWggcqoTK0ZxFYMo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Thhh/5El8XGhkIpJMQ9Fq0KKcRPwDLDfLg3lcnt+f9CkeKrJAakjjYcyLOIWVMNFIKttbaNmjhtROyF85qKSLhe5lozpM1xFpGIDwgSfoXmElq8HGsbeS1Rn9EIMME8eSVPzaCPk9DTP3FeW/1SI2+pzRm4zNPEPwVg5kPysHdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hxwGibG+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-224347aef79so4972795ad.2
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 16:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743638199; x=1744242999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4vIm6df2fo6Fewjd44SIeiPxj02slwP9HDZ1sfVq81A=;
        b=hxwGibG+xuBTBdL2s/owjlSALLNnMQJpWNl+gipwSk14mDm4D4Iuz7+l8mHKkSA/n6
         /DlqQtopdQ/K/fDG9SDK70PRdrveWAWGLPtJkCjxbq+8QKr1oRbFld7Vt0XAk4cHWZJD
         jGlgOrIajwRGKwMEg0KsALV/w6Ki5jJ9JNAPjPkV2+Q578iIfPpjVmBRTvLBG9V9xsbw
         HyC/qaYGmoExgoNWt4BWAWAjT0Oq9nH4AaRB3HZtDg8g8KWm6AhnVY4xJsXsgHmqRV5s
         hIMnJbHNaDQijMWWYBPkwHsE1j1jkAr3rVXVEs8WVn/n/EfFVZePAuDnUHDN8lcPGUFX
         1lDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743638199; x=1744242999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4vIm6df2fo6Fewjd44SIeiPxj02slwP9HDZ1sfVq81A=;
        b=bs0d1TA4wjSx+2hEt9WNbjzoT8zHPaDz7nG/1cWXeOiU71i7QCFSn1AWtyjIs9TxqY
         kKEnDCLBIgUidSMIXg5dsfp+/pTD8Q4a/Q5newlQSAyg9ZeuiNLR/EoXiT5apF2Bi7Jq
         uJrCFxmE3bcQCJ6YWWb14phRjwwzWy/jtxbe2DZwh3SB2Io8rSrNnEvriSoy5zq5ozEr
         Z7cYcgu4/wlLt5ansOA/MvGEnJftiEZKcACBTy692bciygFy9fDCV2CGA0wM1BOtuIGd
         RQImJQs8CooeuF2Pb1RfbWtPokYj9XyaT7gaQ4CkEoDmUU4L5b6pGSdaRNMCtIbpUm8n
         KEGA==
X-Forwarded-Encrypted: i=1; AJvYcCVC+dzGhOb3wPR0Sjn0CUicW2H4AgrJgOpnHMYx7pCeWeM4m4qI1qBKsyBVDLxKacnqcqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyszKPtCkI4UfFqxK9e68TiLVwvpLpcnDQi/ntiutibxGPb49jw
	HwnpBsOkn2Hdu1XVYwHOeWiZf2KGcBkge03OgpKRV1ZSMZeKR8Tkg1zwOlS4hgBNcecNWwU1gvo
	6zw==
X-Google-Smtp-Source: AGHT+IGFMwLksy4XiBzz9HIDdqWCU4ltuYagyIkABhVEC+CyeQTlhxy73EaRBIaDFauOrErYz/GyNbcvcZ8=
X-Received: from pfbg6.prod.google.com ([2002:a05:6a00:ae06:b0:736:3d80:706e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db05:b0:21f:1bd:efd4
 with SMTP id d9443c01a7336-2296c65f460mr54081795ad.19.1743638199570; Wed, 02
 Apr 2025 16:56:39 -0700 (PDT)
Date: Wed, 2 Apr 2025 16:56:38 -0700
In-Reply-To: <diqz1puanquh.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328153133.3504118-4-tabba@google.com> <diqz1puanquh.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <Z-3OtjCJYyMXuUX7@google.com>
Subject: Re: [PATCH v7 3/7] KVM: guest_memfd: Track folio sharing within a
 struct kvm_gmem_private
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 02, 2025, Ackerley Tng wrote:
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index ac6b8853699d..cde16ed3b230 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -17,6 +17,18 @@ struct kvm_gmem {
> >  	struct list_head entry;
> >  };
> >  
> > +struct kvm_gmem_inode_private {
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +	struct xarray shared_offsets;
> > +	rwlock_t offsets_lock;
> 
> This lock doesn't work, either that or this lock can't be held while
> faulting, because holding this lock means we can't sleep, and we need to
> sleep to allocate.

rwlock_t is a variant of a spinlock, which can't be held when sleeping.

What exactly does offsets_lock protect, and what are the rules for holding it?
At a glance, it's flawed.  Something needs to prevent KVM from installing a mapping
for a private gfn that is being converted to shared.  KVM doesn't hold references
to PFNs while they're mapped into the guest, and kvm_gmem_get_pfn() doesn't check
shared_offsets let alone take offsets_lock.

guest_memfd currently handles races between kvm_gmem_fault() and PUNCH_HOLE via
kvm_gmem_invalidate_{begin,end}().  I don't see any equivalent functionality in
the shared/private conversion code.

In general, this series is unreviewable as many of the APIs have no callers,
which makes it impossible to review the safety/correctness of locking.  Ditto
for all the stubs that are guarded by CONFIG_KVM_GMEM_SHARED_MEM.  

Lack of uAPI also makes this series unreviewable.  The tracking is done on the
guest_memfd inode, but it looks like the uAPI to toggle private/shared is going
to be attached to the VM.  Why?  That's just adds extra locks and complexity to
ensure the memslots are stable.

Lastly, this series is at v7, but to be very blunt, it looks RFC quality to my
eyes.  On top of the fact that it's practically impossible to review, it doesn't
even compile on x86 when CONFIG_KVM=m.

  mm/swap.c:110:(.text+0x18ba): undefined reference to `kvm_gmem_handle_folio_put'
  ERROR: modpost: "security_inode_init_security_anon" [arch/x86/kvm/kvm.ko] undefined!

The latter can be solved with an EXPORT, but calling module code from core mm/
is a complete non-starter.

Maybe much of this has discussed been discussed elsewhere and there's a grand
plan for how all of this will shake out.  I haven't been closely following
guest_memfd development due to lack of cycles, and unfortunately I don't expect
that to change in the near future.  I am more than happy to let y'all do the heavy
lifting, but when you submit something for inclusion (i.e. not RFC), then it needs
to actually be ready for inclusion.

I would much, much prefer one large series that shows the full picture than a
mish mash of partial series that I can't actually review, even if the big series
is 100+ patches (hopefully not).

