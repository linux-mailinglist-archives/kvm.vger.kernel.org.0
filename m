Return-Path: <kvm+bounces-37902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC23A312A2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 18:19:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C98BA3A6E3C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8351326216B;
	Tue, 11 Feb 2025 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cAUiq5z+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A6F2505A8
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 17:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294352; cv=none; b=glHkPDjvWELk3lOrVFqxPwgTdw0fCY9acAyqSc5/tx/0RoVRTMZQigE+F3jOTo+BKbigmgQq67StJX/hBTexkt4lLRs0ikbyNw/MFkZpBV5XK1DQ10gRWv8BaXHzhsrvLtbOC8YBgKRGZID5NC0CTz8osffbGPPL473NlWpke6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294352; c=relaxed/simple;
	bh=QFsrA7xobpYNL6pqMqCdD5vFegspPx/LJhcRXcW0REw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDbK+/fS5x8HqbxO+tlRS0zk/7B6oq/zXH9DjJ7fpdx0V1PWzjHVuHQsORS+fc1AsTtesea6Z0uaFsKl5AxiEgcYAsqzaQXn5x8ixSTHPt29SwfB6UWE3m3FGfnK/TfFCpOxjEnD5cCRwboesMePaVAoQE9YEcgSqDGAA37hpAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cAUiq5z+; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5de6ff9643fso5150073a12.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 09:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739294349; x=1739899149; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TbDB2T78gRRSnhZlNQEvX26YaZx1qd9LDVzTCLA7eDo=;
        b=cAUiq5z+82AvN5yZHkSE54UUdFzP6M/7lOq/uM4fZ5vaYj31RvCfVYePUm8bT9I3A1
         IDjShv3suSejgMnUnzp6h6UebXWywb5V2ojwBAOLqJ+Vcli5Ulkm1P9SmFmkmBTb4YG5
         MysESN209LdoDovJJuuwWxpIvUoIJmAZoBzJWbbqtGi8hgF+gOWebgCzkNeO4ENBgVh4
         iA82poGunATyYb6KMxqyYQl3b2b6L6x31fgI7FBHQfav0x+p0u0LZoItC9Sunm0Ci2lO
         6TMRE5ztcq3QKF3flC0/UrZ774S8lEAaPFycmUTehkL3WiZaI9q2ppa+70v+SfY06R6H
         vJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739294349; x=1739899149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbDB2T78gRRSnhZlNQEvX26YaZx1qd9LDVzTCLA7eDo=;
        b=O6cBJkQ+GBFqSSFkrtXbtcwVXUOnQIoVMo1f9M6z7s2gwO7lx/KjbV4nfH+x485IVF
         KGO67gEoL4VBRnlStHvWK6XPQ/JHglczqZSOdWy8C6FSI/h8ibSvjDkwiqOou1riCYuy
         M4rGuhmFWSp7zFvPWcFCzkunA+KBaM78O1S0eBEciC9NPnlgFHaJsQelltB0eeDbe6t2
         aqPrmq8kF8PGM0/VlIuAOYEg8+YwC7jIKReNlnoS6BJ11Xm2cObvtv36btXt1oXKgcjg
         uN0FM5nudKXMp4DYkrMMool4QROaRntZNZofGCmqnriBCEt9M6EiytzELy9Ei53tED2L
         XwDg==
X-Gm-Message-State: AOJu0Yz8fas2P/HRGwRYQR5oHy9u1E4LTSHp1hIQ17f6H0soFW/bVx6C
	iUB08KnGxWIZBBBerUCoPE3nfRy63XtfphhR/TftNFYq1dXW5fmKCXSnqCffJiGO19dwO6aDWac
	+JHu+
X-Gm-Gg: ASbGncvRIuDs4DGap9nEKxGWVXjhMvP5QjIwSs/n6PgNMIK3al2sfLJmDt6iPAEHiC0
	MhKSkCtHV5TtD3VJrFkK/jBxl6j0tUyVFtdj4q8oZYiF2Lami9MxsPIEZXBclZAEtF50M4M1mSq
	yMbqcpCz3xcbK20OMKBty2Kb/EOirR9qd7gc66LPqutyaGmHCfbK8vWmqnh4JcWd3El2XG8yF8K
	Zmi7qGeFvJSDrua61freJ4bXO5yqloSaGliBNq+PV5BcEZRmLXngetIYwXM8SG0MQo50hvZZnsN
	e91uWyGpg4gYeYEj9sVdNiGXCAHlzq5FcyigweeDsh58xytSMrrv
X-Google-Smtp-Source: AGHT+IETwHheJ1VO/jmGJCeiPpzkB30iOpJM0PGYNAYejh8MHif7Zl42B4EJpywng8Lk3dfH/tNK3g==
X-Received: by 2002:a05:6402:40d1:b0:5dc:7fbe:72ff with SMTP id 4fb4d7f45d1cf-5deadd7b87fmr10452a12.2.1739294348970;
        Tue, 11 Feb 2025 09:19:08 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5de525f35b7sm7671829a12.53.2025.02.11.09.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 09:19:08 -0800 (PST)
Date: Tue, 11 Feb 2025 17:19:05 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, keirf@google.com,
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org,
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com,
	fvdl@google.com, hughd@google.com, jthoughton@google.com
Subject: Re: [PATCH v3 08/11] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
Message-ID: <Z6uGic8dipeVLHhA@google.com>
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-9-tabba@google.com>
 <Z6tzfMW0TdwdAWxT@google.com>
 <CA+EHjTy3dmpLGL1kXiqZXh4uA4xOJDeTwffj7u6XyaH3jBU26w@mail.gmail.com>
 <Z6t6FSNwREpyMrG3@google.com>
 <CA+EHjTyU5K4Ro+gx1RcBcs2P2bjoVM24LO0AHSU+yjjQFCsw8Q@mail.gmail.com>
 <Z6uBd-L_npR_VqVY@google.com>
 <CA+EHjTw1AboQg3Uzj5ptanxu6NPeonERpFZ+40RDUJkBFw2tqg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTw1AboQg3Uzj5ptanxu6NPeonERpFZ+40RDUJkBFw2tqg@mail.gmail.com>

On Tuesday 11 Feb 2025 at 17:04:05 (+0000), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Tue, 11 Feb 2025 at 16:57, Quentin Perret <qperret@google.com> wrote:
> >
> > On Tuesday 11 Feb 2025 at 16:34:02 (+0000), Fuad Tabba wrote:
> > > > Sorry, yes, that wasn't clear. I meant that kvm_mem_is_private() calls
> > > > kvm_get_memory_attributes() which indexes kvm->mem_attr_array. The
> > > > comment in struct kvm indicates that this xarray is protected by RCU for
> > > > readers, so I was just checking if we were relying on
> > > > kvm_handle_guest_abort() to take srcu_read_lock(&kvm->srcu) for us, or
> > > > if there was something else more subtle here.
> > >
> > > I was kind of afraid that people would be confused by this, and I
> > > commented on it in the commit message of the earlier patch:
> > > https://lore.kernel.org/all/20250211121128.703390-6-tabba@google.com/
> > >
> > > > Note that the word "private" in the name of the function
> > > > kvm_mem_is_private() doesn't necessarily indicate that the memory
> > > > isn't shared, but is due to the history and evolution of
> > > > guest_memfd and the various names it has received. In effect,
> > > > this function is used to multiplex between the path of a normal
> > > > page fault and the path of a guest_memfd backed page fault.
> > >
> > > kvm_mem_is_private() is property of the memslot itself. No xarrays
> > > harmed in the process :)
> >
> > Ah, I see, but could someone enable CONFIG_GENERIC_PRIVATE_MEM and
> > related and get confused? Should KVM_GENERIC_MEMORY_ATTRIBUTES=n
> > depend on !ARM64? Or is it KVM_GMEM_SHARED_MEM that needs to depend on
> > the generic implementation being off?
> 
> VMs that have sharing in place don't need
> KVM_GENERIC_MEMORY_ATTRIBUTES, since that presents the userspace
> view/desire of the state of the folio. It's not necessarily an arm64
> thing, for example, CCA would need it, since it behaves like TDX.
> 
> I guess that KVM_GMEM_SHARED_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES are
> mutually exclusive. I cannot think how the two could be used or useful
> together. We could have a check to ensure that both are not enabled at
> the same time.

Right, that should be a matter of adding

	depend on !KVM_GENERIC_MEMORY_ATTRIBUTES

to the KVM_GMEM_SHARED_MEM Kconfig I think then.

> The behavior in this patch series is that
> KVM_GMEM_SHARED_MEM selects GENERIC_PRIVATE_MEM.

You meant s/GENERIC_PRIVATE_MEM/KVM_PRIVATE_MEM right?

> Also, to help reduce the confusion above, I could rename the variable
> is_private in user_mem_abort() to is_guestmem. WDYT?

I actually don't mind the variable name in that it is consistent with the
rest of the code, but I do positively hate how the definition of
'private' in this code doesn't match my intuition :-) 

