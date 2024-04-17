Return-Path: <kvm+bounces-15031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ADF38A8F48
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A768B1C20D8D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE43E85948;
	Wed, 17 Apr 2024 23:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zRC+zDi/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7C0FC1F
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 23:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713396460; cv=none; b=KVifsz6LKZISKLWmrYnZEjIvwuXic5MITyx9W6GHE+MZJHgmYEV4crAOTnHqtz9R2MMkl0Yf8OBlkbJAOlIqh5Go3deUeGAXXnaMNJHsyeYUUyj/XbDeDArMEuLunjYSxEVo0hZ3XHpHz/6BsnVnE3PylvWgCYMOuGmy0rf6bKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713396460; c=relaxed/simple;
	bh=sm5qWoL4TEVBvLhxN3SGp78DDIogApq/R3F3I+iYIyw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cq6T7Nh88llbypeugavr4pMa1ma9h5+TAh+nuo/VexD2p4Qg3zYw5WUiPUQdQmeg9A9b5bxUt9dyoQvK1Cnz21vJSHwWuppd7iewkrcDZKquoSkKsN0uRKF/pAdNsftPD4q8fpWFkXX2+x6BX1rtV1fEzzwoiQCxg5HIjqpFP6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zRC+zDi/; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ed25eb8e01so298248b3a.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713396459; x=1714001259; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E6/yv8l0tAnEX2YrJeZG4x+G9i8KZY08S/JjSb9nTEM=;
        b=zRC+zDi/FEYqcAPjoo/zPu6uANa5STSXfrGTeRdjFSqQoux6oIwSDO1pVYMt+Dugrd
         oe5inh0ICWW145A/Fdsq1hZKymY9lI/USDxjaqFGZ5eU35nfR6jCu/qTq+Mt1qsORIFr
         HvKgFXsVWhtxtR6oe9odwYMCj85uavqVcixJ0JuLkiqAxK6swHCU6riLl4MnXIlqvOlj
         Yw7+Oh+l7gqV5O2EDkI1fwTnBGBzxuIezsXH1vK0SEoucy9D+F47bR5OhnbGFquU3qWn
         3sX2Xojd/WQt5M3ZgN78l6R3R5jMOJpap6emZ7NABOcfZp57gNQvrcAEcQhTFXp7Oeeu
         Xjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713396459; x=1714001259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E6/yv8l0tAnEX2YrJeZG4x+G9i8KZY08S/JjSb9nTEM=;
        b=a1f6sOdZ+y8Sqo1CLir+nIR0N5wXM5YBwVR3q3/emFiVF4sMfwesOD5gb0eurWnucw
         VahyscF/OVkkpiEVkgrAmz9hzD8AOORfFhU2ooRWTAgmVWKuY3Stxmf424yQMAKYiQmy
         XeiHUVQHKR8j+igBF0Pk85URIJFHZ/8/f7l3jP3IGCMU5jttOXyMdis1R8aG+y7jyuTB
         wPCmE3Z9bwpRutng8m7GQSpCcKvbEJGTuEUKdKm3mzD+qD/+A8ImTPWT34fCQvp7bgHw
         x/O7hagOZNX4HP6t7rmK6Rv2yna4yPM2qka/jJ7dpmxCMnZ2Svf4Tm5KlJJfc1iuoVwO
         YMyA==
X-Gm-Message-State: AOJu0Yx1sb8YbORHWFqR1JaDzVjoZwBCjV4iMFEyM8fB8IsnG00NVzVq
	Jk9h32S3l4j84mpKhUjsXe5JofBMOgSi0CWwQIakWaD3Mo7Y3/fpH2vFZIokRVasFuuUayF2Ist
	tog==
X-Google-Smtp-Source: AGHT+IHRmT8hE59YdeqOABN9tJyRZX+WT2IsjNfAQcQ0lhinhviSJraFpoR1lplfXvbmmqqfGWbU0WcTco0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4616:b0:6ea:afcb:1b41 with SMTP id
 ko22-20020a056a00461600b006eaafcb1b41mr94251pfb.2.1713396458918; Wed, 17 Apr
 2024 16:27:38 -0700 (PDT)
Date: Wed, 17 Apr 2024 16:27:37 -0700
In-Reply-To: <20240222161047.402609-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <20240222161047.402609-5-tabba@google.com>
Message-ID: <ZiBa6dUWwp8_341k@google.com>
Subject: Re: [RFC PATCH v1 04/26] KVM: Don't allow private attribute to be set
 if mapped by host
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 22, 2024, Fuad Tabba wrote:
> +#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE
> +bool kvm_is_gmem_mapped(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> +{
> +	struct kvm_memslot_iter iter;
> +
> +	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), gfn_start, gfn_end) {
> +		struct kvm_memory_slot *memslot = iter.slot;
> +		gfn_t start, end, i;
> +
> +		start = max(gfn_start, memslot->base_gfn);
> +		end = min(gfn_end, memslot->base_gfn + memslot->npages);
> +		if (WARN_ON_ONCE(start >= end))
> +			continue;
> +
> +		for (i = start; i < end; i++) {
> +			struct page *page;
> +			bool is_mapped;
> +			kvm_pfn_t pfn;
> +			int ret;
> +
> +			/*
> +			 * Check the page_mapcount with the page lock held to
> +			 * avoid racing with kvm_gmem_fault().
> +			 */

I don't see how this avoids a TOCTOU race.   kvm_gmem_fault() presumably runs with
mmap_lock, but it definitely doesn't take slots_lock.  And this has slots_lock,
but definitely doesn't have mmap_lock.  If the fault is blocked on the page lock,
this will see page_mapcount() = 0, and the fault will map the page as soon as
unlock_page() runs.   Am I missing something?

I haven't thought deeply about this, but I'm pretty sure that "can this be
mapped" needs to tracked against the guest_memfd() inode, not in KVM.  While
each guest_memfd() *file* has a 1:1 binding with a KVM instance, the plan is to
allow multiple files per inode, e.g. to allow intra-host migration to a new KVM
instance, without destroying guest_memfd().

