Return-Path: <kvm+bounces-42531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2308A79955
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 02:19:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC6B33A96F2
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 00:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F23E7134CF;
	Thu,  3 Apr 2025 00:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rHzLNgdn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7853D531
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 00:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743639582; cv=none; b=c2mtpBuDQWoxrACcTGEzKkIdpTAPGgHc0emWQlD4CZIAm/XdIQ1gbVk/cKzQi1hLGAeEaDba5bCiXikuTGzWWOcfGwUH9BAho1BzhAT3iLfYXyCT1ACZsP8mINjw9dgHABHsWiiab86roSJkG5VAfyXD0o78Xig4EOTSlBxTh+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743639582; c=relaxed/simple;
	bh=wRL+LhgFwhn1QQmACMn+zc2j51ZeoWRMx48GJXzzxpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sVWH4KPalNNhjA4vvwzqNtRdYjPt+L9VXikerLq4vpGY368GjI5G5/oLKd471H8N5c5w6R3zEvgICQ0q7hCZ6zg3f0ZIK5sRbZWPQIoAENkpwTzuKcXXGxPHa6YVlZouN7uDQeCnCrgcyZCjbE4pP/5ZFyP8m8NB6kry9rJEDKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rHzLNgdn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso297936a91.0
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 17:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743639580; x=1744244380; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=giq31tPMYQR9GJOjdMUA5ykRfg6GYvMlM/OohhUUb8g=;
        b=rHzLNgdn18bTacFu1p2/9+I6wgz7FAkpJvuLmTROuruXPeUjcMJV7PMkXit6Vw+OgX
         348A/Enh/PnieYWeF9vy91hw1aAkpuJgfU7HPLcBcxZ5mOcv1Bm6f/JMxsSmt0Jw/1d8
         B8vbXq//GI5NTRCW+tfyq1eMRG/rjwREQMAXwdnb3hXl3LQqZwbu1RYxlBmD2R1mSMPY
         6oQoWMs6IKC/ZA8So50cYhr0q9fadUM9XdZesad+n+MjNApBhlbyGoXi9n21v3HiHpY+
         eHnsqIluCMHJhKNRyjicLMUTjjg3Qs0PgcpYgzaA28I3geTpXuFR0xAeI0fN1JnVFi5W
         zmpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743639580; x=1744244380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=giq31tPMYQR9GJOjdMUA5ykRfg6GYvMlM/OohhUUb8g=;
        b=wEHVSRFg55GKzvgdODbSnCn1EK4Ra4TQTXrJ24vWFTr9JlUf1U706Dd5+prK3XNsHO
         x5U36MrvBNL9vn72AHdUK1+//d9cW4OyExqzD/Up9rbe2kE8sveb6pGLFet3dPzqtJ2z
         DTNJiY3PFs0iqDHxA02xDq8mFd3PquDNduzTFec/KFWrdchynmghUdPcmU2TOHIjz7pO
         EUUj2FhF1LmpayhBOdXvHKl9/wI9VdAW6JlAvI6lPYn0UgeLUdeYaT/IR07ZWv1gfzFa
         6qqeIf3g+h2erx4wrq+gl/g21tod/de53qVqAUm624fnUvoZ+IplXIDyUevkH02jaxXX
         fCVQ==
X-Gm-Message-State: AOJu0YzgwoVrL1JE1I8KUxp58KZLAQcgUWYGIotG4d1pFO5LryowSyYx
	sPqSNpfvSH53zaiEpqBKmqnq14+oBsBNNNnmCXuvS5Dkc0LjHrSkVSOitoe0WrXjljm+GwIz6m2
	rtA==
X-Google-Smtp-Source: AGHT+IEALDHXaWn7DLHhgLj4jdYjci9jQvHFqEsuIO7fXG0v8/sr5fTQJ+kpqo4OZSalhy2Upmggi3qyPYE=
X-Received: from pjbli6.prod.google.com ([2002:a17:90b:48c6:b0:2fa:27e2:a64d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2648:b0:2ee:90a1:5d42
 with SMTP id 98e67ed59e1d1-3056eca1a6bmr7764389a91.0.1743639579925; Wed, 02
 Apr 2025 17:19:39 -0700 (PDT)
Date: Wed, 2 Apr 2025 17:19:38 -0700
In-Reply-To: <20250328153133.3504118-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com> <20250328153133.3504118-5-tabba@google.com>
Message-ID: <Z-3UGmcCwJtaP-yF@google.com>
Subject: Re: [PATCH v7 4/7] KVM: guest_memfd: Folio sharing states and
 functions that manage their transition
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
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

On Fri, Mar 28, 2025, Fuad Tabba wrote:
> @@ -389,22 +381,211 @@ static void kvm_gmem_init_mount(void)
>  }
>  
>  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
> -static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> +/*
> + * An enum of the valid folio sharing states:
> + * Bit 0: set if not shared with the guest (guest cannot fault it in)
> + * Bit 1: set if not shared with the host (host cannot fault it in)
> + */
> +enum folio_shareability {
> +	KVM_GMEM_ALL_SHARED	= 0b00,	/* Shared with the host and the guest. */
> +	KVM_GMEM_GUEST_SHARED	= 0b10, /* Shared only with the guest. */
> +	KVM_GMEM_NONE_SHARED	= 0b11, /* Not shared, transient state. */

Absolutely not.  The proper way to define bitmasks is to use BIT(xxx).  Based on
past discussions, I suspect you went this route so that the most common value
is '0' to avoid extra, but that should be an implementation detail buried deep
in the low level xarray handling, not a

The name is also bizarre and confusing.  To map memory into the guest as private,
it needs to be in KVM_GMEM_GUEST_SHARED.  That's completely unworkable.
Of course, it's not at all obvious that you're actually trying to create a bitmask.
The above looks like an inverted bitmask, but then it's used as if the values don't
matter.

	return (r == KVM_GMEM_ALL_SHARED || r == KVM_GMEM_GUEST_SHARED);

Given that I can't think of a sane use case for allowing guest_memfd to be mapped
into the host but not the guest (modulo temporary demand paging scenarios), I
think all we need is:

	KVM_GMEM_SHARED		  = BIT(0),
	KVM_GMEM_INVALID	  = BIT(1),

As for optimizing xarray storage, assuming it's actually a bitmask, simply let
KVM specify which bits to invert when storing/loading to/from the xarray so that
KVM can optimize storage for the most common value (which is presumably
KVM_GEM_SHARED on arm64?).

If KVM_GMEM_SHARED is the desired "default", invert bit 0, otherwise dont.  If
for some reason we get to a state where the default value is multiple bits, the
inversion trick still works.  E.g. if KVM_GMEM_SHARED where a composite value,
then invert bits 0 and 1.  The polarity shenanigans should be easy to hide in two
low level macros/helpers.

> +/*
> + * Returns true if the folio is shared with the host and the guest.

This is a superfluous comment.  Simple predicates should be self-explanatory
based on function name alone.

> + *
> + * Must be called with the offsets_lock lock held.

Drop these types of comments and document through code, i.e. via lockdep
assertions (which you already have).

> + */
> +static bool kvm_gmem_offset_is_shared(struct inode *inode, pgoff_t index)
> +{
> +	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
> +	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
> +	unsigned long r;
> +
> +	lockdep_assert_held(offsets_lock);
>  
> -	/* For now, VMs that support shared memory share all their memory. */
> -	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
> +	r = xa_to_value(xa_load(shared_offsets, index));
> +
> +	return r == KVM_GMEM_ALL_SHARED;
> +}
> +
> +/*
> + * Returns true if the folio is shared with the guest (not transitioning).
> + *
> + * Must be called with the offsets_lock lock held.

See above.

>  static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)

This should be something like kvm_gmem_fault_shared() make it abundantly clear
what's being done.  Because it too me a few looks to realize this is faulting
memory into host userspace, not into the guest.

