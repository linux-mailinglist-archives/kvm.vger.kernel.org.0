Return-Path: <kvm+bounces-42623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C9DA7B7F3
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 08:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 936F43B774E
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 06:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6991818BC2F;
	Fri,  4 Apr 2025 06:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r7Br7Iol"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019FF847B
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 06:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743749097; cv=none; b=TCNCUwPdcJ8AniGjCs+vVBXFW1cBT2mdZ6MVhsoiC/4la+R/hrVnYXRL0Zasv6zHUc5dFVsYqnE04kk2LCH8LNJ1qOo7LEizDQW+pTS51/L4gwqYezZfCqFOOoaYd/zxlTG2TpHHxBAcnEosQY2DJ+WRto626aYJxS8CWlc41is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743749097; c=relaxed/simple;
	bh=xaQspN8VBU1mg9UKXIgTV9/XqJmgzzuNHA5JflQzSzg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KrMncPo6IPqfNxNkSWzzPhITseV6JMuDJCQpAg29FWWak7FYTh3zzcWIrA64QP3PCmIgNHkhHDexQ9SNGG3roI7QGRMEaaENGWpoIOef4P/LlCfwflgkVhaHKDgN/4789K2QYELiVg7hBecc82t3LyBGcJo3mUFRLNWr+Z3E8+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r7Br7Iol; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4769e30af66so163711cf.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 23:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743749095; x=1744353895; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UprUIafD3wiWxLv/pdXt+iE4g9xi36y1H1+pdGpOCTA=;
        b=r7Br7Iolfwlg5H5j7Rm/U7MHimrek2fafvgH+T4xFJbJusj89/vO4hnNYR/wmxeaK6
         qr/ofDqXOOAfuIIqBdFU32B8JyPqJdC4PTdxsc0nGWKKsoPbWsF2wOROq9ubdcoHKgcz
         Zl0+3VP8ckEEtwhd8ODWu8dlSdQlskbK/M+c6tz07hPqMWEc7qecM/RlHyqiQtT0LVjT
         vvcyw5U9Licc11RdZGFzoMCZaCG77aJb2W5zfkuWDCXFjKkQNiod/7seJVX4LY11tY5B
         Q+6ZWOPSJgfb/rtSNZtmndF6ubpG14C00DTEz8ph+uxKgNjwjB1WbPHRt6c3K8y+Wnm3
         ULlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743749095; x=1744353895;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UprUIafD3wiWxLv/pdXt+iE4g9xi36y1H1+pdGpOCTA=;
        b=K3AV+5oyQXJiOCXeufxFHIoGAug0pp4q+dt3fIaXYLb3ufNKXv5pK5E/Q+vvnSOd1Y
         bHCbYyezupHkm5iEupMGeH9UCD3kGQ8QzMTadqVzlS+WKkWYh8G3qkMVvdSkt/rlGK4O
         gb3wvosdwo3LKDvSn38PmrA/QY6VR0v1oKVFlgGJwyyYYAh/MKq7uQGmrcfBHw2lQ1Pv
         OtephD4fEp5dsP0lVS5D9E761KK1mC/rBBURL7YbNoIfW7niD5YziS4KfZoVb8seIR85
         fc9rlBWbWepPPKJYjshhm4dJmahT9njt8+OJ4Iksb7im3M5Oi5sYQ8usdPmkqfR2ltej
         FjgA==
X-Gm-Message-State: AOJu0YymCnlnGQIOfD0rXQ5zAtYPq7xCxBYJltW16eeW3GgVFZhnCNQb
	V6y6s0xKWP5PDLrAorS7bo8qj2Id+7byydprA4jNWxQc0lq+RZAhhk+stJGtP8LSP4WG94Lkl6k
	t8eC+U78UBMXjCzZuxOGMMabMCBmAPBovRerB
X-Gm-Gg: ASbGncuatxnib/Lc0pLKd9AryAw3hXtZiIRtrsHC4c/FTDBYLNFBAz6Xz0ng5q14891
	JtYGN+9Ugievii7UAzNt/ScIdeo56my3utexZ0dpcAGj3lDvu22WDlEo9Ai5cn9MfJvUOplutXq
	hASWphEGhdKA8JYJbjvfLcv8XfnA==
X-Google-Smtp-Source: AGHT+IE8PTeOdWkNrufM9LP4Mni7kBx8OJpn1b+3SBBF4LelDvTRzrbc2ORNEfG/yRoYwRJ62/ZGLtOHR9udESeJWHY=
X-Received: by 2002:a05:622a:1315:b0:472:8ac:7d3d with SMTP id
 d75a77b69052e-479266c0b39mr1950321cf.29.1743749094713; Thu, 03 Apr 2025
 23:44:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com> <20250328153133.3504118-5-tabba@google.com>
 <Z-3UGmcCwJtaP-yF@google.com> <CA+EHjTzSe_TMENtx3DXamgYba-TV1ww+vtm8j8H=x4=1EHaaRA@mail.gmail.com>
 <Z-6gymjL0S74plfU@google.com>
In-Reply-To: <Z-6gymjL0S74plfU@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 4 Apr 2025 07:44:16 +0100
X-Gm-Features: ATxdqUFjnLSZfub677jgEicHZmUFnkiOD7zKCzw0f_-1HOehmGaCbohxHSlNcyQ
Message-ID: <CA+EHjTzPqLbMvmKiUoP5U1xkCfP+JDnz8A4GmbYV2ZiDSnunJg@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] KVM: guest_memfd: Folio sharing states and
 functions that manage their transition
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Apr 2025 at 15:53, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Apr 03, 2025, Fuad Tabba wrote:
> > Hi Sean,
> >
> > On Thu, 3 Apr 2025 at 01:19, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Mar 28, 2025, Fuad Tabba wrote:
> > > > @@ -389,22 +381,211 @@ static void kvm_gmem_init_mount(void)
> > > >  }
> > > >
> > > >  #ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > > > -static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> > > > +/*
> > > > + * An enum of the valid folio sharing states:
> > > > + * Bit 0: set if not shared with the guest (guest cannot fault it in)
> > > > + * Bit 1: set if not shared with the host (host cannot fault it in)
> > > > + */
> > > > +enum folio_shareability {
> > > > +     KVM_GMEM_ALL_SHARED     = 0b00, /* Shared with the host and the guest. */
> > > > +     KVM_GMEM_GUEST_SHARED   = 0b10, /* Shared only with the guest. */
> > > > +     KVM_GMEM_NONE_SHARED    = 0b11, /* Not shared, transient state. */
> > >
> > > Absolutely not.  The proper way to define bitmasks is to use BIT(xxx).  Based on
> > > past discussions, I suspect you went this route so that the most common value
> > > is '0' to avoid extra, but that should be an implementation detail buried deep
> > > in the low level xarray handling, not a
> > >
> > > The name is also bizarre and confusing.  To map memory into the guest as private,
> > > it needs to be in KVM_GMEM_GUEST_SHARED.  That's completely unworkable.
> > > Of course, it's not at all obvious that you're actually trying to create a bitmask.
> > > The above looks like an inverted bitmask, but then it's used as if the values don't
> > > matter.
> > >
> > >         return (r == KVM_GMEM_ALL_SHARED || r == KVM_GMEM_GUEST_SHARED);
> >
> > Ack.
> >
> > > Given that I can't think of a sane use case for allowing guest_memfd to be mapped
> > > into the host but not the guest (modulo temporary demand paging scenarios), I
> > > think all we need is:
> > >
> > >         KVM_GMEM_SHARED           = BIT(0),
> > >         KVM_GMEM_INVALID          = BIT(1),
> >
> > We need the third state for the transient case, i.e., when a page is
> > transitioning from being shared with the host to going back to
> > private, in order to ensure that neither the guest nor the host can
> > install a mapping/fault it in. But I see your point.
>
> That's KVM_GMEM_INVALID.  Translating to what you had:
>
>   KVM_GMEM_ALL_SHARED   = KVM_GMEM_SHARED
>   KVM_GMEM_GUEST_SHARED = 0
>   KVM_GMEM_NONE_SHARED  = KVM_GMEM_INVALID

Ack.

Thanks,
/fuad

