Return-Path: <kvm+bounces-36301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C9DA19AC5
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 23:17:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E05F216A5CF
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 22:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 701BC1C7B62;
	Wed, 22 Jan 2025 22:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GVpznsGm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430FE149E17
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 22:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737584213; cv=none; b=LY49uTvdbbDWjS6T/h9Rd018L9JaQgExiH4tJeQCyUIYJK8RO4STS2EncoFWfCp24mwHgjg9xpKH8RTbSEFhFjCS8YB07nYBKekcAOOhtaJas0fFBZxc6Vj/H/SiVPFTYpGUvGddW8Xp7LqungEAuFYaJv2pd8sYf0+xZDLG9xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737584213; c=relaxed/simple;
	bh=YRBj9r1/vH8+ADkRAd/xRm3bNslcVk24kKUS21NY9Ok=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=mezAdd1c9mMVOgGIn+lqBPCMRFG9mqkluTI0fubHl/TW3OYoZzbl81yak7z3a0K4ZZMNkzERBdxVCs4rSekbisNc+2kG0cIcRjQC/mKA0ySAeEb7lrDfZIiWNZkMSs68t9cRdhoTfnfQc2cONMkXxvz0IZoYHr3m2nrtz5BZyeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GVpznsGm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166855029eso4074465ad.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 14:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737584211; x=1738189011; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l3V32wmuFdo3eyYq3ItjWLe5TmAQhDXOPpNz76RK2rI=;
        b=GVpznsGmzj9rnZ/j1XSVzUZ8f3vZwlw4A88OBya4wtYH1As6k5/qzjrYoxPjxeWq5P
         BrL5ibvINg5FmRDhEP3uxlH69QSKUBtazxBevoh1637D/O+byatT4OQmvjOvL8KkzkD8
         /zTE/BgymQwnRoNLiYkQik4Qo1lmYg9x2fVQ5OganGy5R5QMtSwSQr2IGtgaOZc9frAa
         8I9HC4eY5tPzqYus/30YBqvkJql7VKw+SG8mI8vHRX492f5gjcb48AJAAF4timEp3nLe
         h40lxy/9mwBxXMLxU6ASp9Ov63rT6tRNYSx1X7DUEVIr+MT38oMSm0K7AHOdbaFjV071
         GTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737584211; x=1738189011;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l3V32wmuFdo3eyYq3ItjWLe5TmAQhDXOPpNz76RK2rI=;
        b=GmdlKJiQJyN4JVoNnFBJ1ADgpB1uoyr2pO1Roj0k87w84FH2H7l3Nc0nbSSYO8nPht
         ZNgnJqgccNfoCrdCpK+yXl01UuHe1cb8TEFbuSand37L6TOg1IOeSBG4MN+Nh+6b18kP
         qK5CLslY5tTwpgPhSLXEbAWKdfX10Wcv0aehZWmEikEscujXsB7XDBscOhND6G5QJeeU
         Ny3pDllYAs4GPM87CybQQh5Z8dbcpFz4ybGCVlirgfRpp5pbdLp84AylSwuKrW0pn9y5
         dCJBg7g56udGU7XS3b/cQcbfISxw1e9PwXVkR3gih6PzStT4JOr+46l1qdPD/zzV32v+
         aV0A==
X-Gm-Message-State: AOJu0YzuLPZO3BBs7Dnp6V1B2p55j8lT6gS3LL+AB7nb1+rlJ07q76YA
	go2mOSag+tW0/SkLZ2DwoF2Gj/iomh5sQab4H/AIKSNA+KRezJg/zdZWyg9plkkQv0CKXyqvFBo
	rbPzlh9XaNw+C1/V+AdUarQ==
X-Google-Smtp-Source: AGHT+IHawiM1cnWjjBgTMESBdCjxT4zEuIO00j/eJjzTR5bXkQ6p3w/HrFV8L27JfxuD2cLer72tmGSBr5cfS1Cwuw==
X-Received: from pfbjc33.prod.google.com ([2002:a05:6a00:6ca1:b0:728:e508:8a48])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:8412:b0:1e1:96d9:a7db with SMTP id adf61e73a8af0-1eb2147021cmr35174465637.4.1737584211338;
 Wed, 22 Jan 2025 14:16:51 -0800 (PST)
Date: Wed, 22 Jan 2025 22:16:49 +0000
In-Reply-To: <20250117163001.2326672-7-tabba@google.com> (message from Fuad
 Tabba on Fri, 17 Jan 2025 16:29:52 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzikq6sdda.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

Hey Fuad, I'm still working on verifying all this but for now this is
one issue. I think this can be fixed by checking if the folio->mapping
is NULL. If it's NULL, then the folio has been disassociated from the
inode, and during the dissociation (removal from filemap), the
mappability can also either

1. Be unset so that the default mappability can be set up based on
   GUEST_MEMFD_FLAG_INIT_MAPPABLE, or
2. Be directly restored based on GUEST_MEMFD_FLAG_INIT_MAPPABLE

> <snip>
>
> +
> +/*
> + * Callback function for __folio_put(), i.e., called when all references by the
> + * host to the folio have been dropped. This allows gmem to transition the state
> + * of the folio to mappable by the guest, and allows the hypervisor to continue
> + * transitioning its state to private, since the host cannot attempt to access
> + * it anymore.
> + */
> +void kvm_gmem_handle_folio_put(struct folio *folio)
> +{
> +	struct xarray *mappable_offsets;
> +	struct inode *inode;
> +	pgoff_t index;
> +	void *xval;
> +
> +	inode = folio->mapping->host;

IIUC this will be a NULL pointer dereference if the folio had been
removed from the filemap, either through truncation or if the
guest_memfd file got closed.

> +	index = folio->index;

And if removed from the filemap folio->index is probably invalid.

> +	mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	__kvm_gmem_restore_pending_folio(folio);
> +	WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
> +	filemap_invalidate_unlock(inode->i_mapping);
> +}
> +
>  static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
>  {
>  	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;

