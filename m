Return-Path: <kvm+bounces-11702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86285879F7F
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 00:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BB992839F9
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 23:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF15F46B80;
	Tue, 12 Mar 2024 23:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gU+eK7wZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FBB446AF
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 23:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710284624; cv=none; b=Y003ZMn52SJ0S3WYfxw6TaTe2rX4j5kg8anjl2HlaYsSozL/iq0H/fgmxBXOEn6w8xLV6c4wnmzooxaUpICAuQHjueMh/g+/bYYCRQwnxEnBKnYmRQn31WAlnwjKROUTSpY8slg68NLxOytlU0PvQBmqeFxd8A0wgmjsvgywkZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710284624; c=relaxed/simple;
	bh=K83M/gOkLwVJy/iWndMZQ3/mNyjmwqZz2ejy3OkYwbg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=imAPK8+ne2Q0G+MzWabpBlaalaDI47bb1M4SIS5bowyiP7WIupypYPVghQcXSEttKfs2whjCdE1xC0taazvmUNi+achx7HhO/XL+Bph+ZyHWI04gjFT939ntQaZ7q7qOXTqQUaan0MBb7UnQYSSY91RzFPoy+5wir8xSjsR6Ujg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gU+eK7wZ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a6051556dso14375137b3.0
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 16:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710284621; x=1710889421; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wycjXUpdcjRTIVTczU6imQHDHg2SNIM+Jho2dwX/OCo=;
        b=gU+eK7wZOirO+4AKADjq8rdh5s3BlFPD3pS5rbtcxiI4ifhXJ2dbQeusGewybbbcke
         acXJuxAIYPZAM76RVI8sp88E11IHRw1Oi8LBqe7B++9+UONOH21omNMKcad1Ykt/QV4K
         8QrIVKuYGxg/FSQ2OQc018P+S9UjQqjnHeR/uwoy4vgnE8mWjz1pLrQ3BtcNZVBpEzwD
         jjspoCH4sf+N5U9a4+3iCjzGVcfQOMX1TtDRcwisoslHHbnR5YBw//0n70jYEApqeQmK
         QVl5KAMLGMi1WCFxKQU4XA9rVyjs9LTeAHWfEc9MhUzJqoWO89zG7fopj7AiS0eSJs2I
         e0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710284621; x=1710889421;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wycjXUpdcjRTIVTczU6imQHDHg2SNIM+Jho2dwX/OCo=;
        b=npdq18kdvkOMAWjkxZroLH9sQJhWUgffflmUpxEyx16PiwWy6B+xczcE3R3OcJrqZ8
         TU7Ed8pkeTECOJyLXAT6WvZvFsXVjWFjPbOmVR8EDugjkAsh90ubpuzld6H3MEYIHf2j
         V5gHrsc+IoLWKmjbfLdoGtCh6w+GQIvJYj0AkmYLhoS5EmdI3zjzmk4JZEN3FehNnD0G
         bTHVD68km7nT4i/mojOfPA1Iy31gOfimg+ul8hNuhkvzpNwPuBDsWpq9kjC+F9laKEdH
         jqPVTJ1mMpD4zUT3HW4EKL0dWd4juGgQQPk4qDtjN82y3jyCIEP58nmtBNEc8ZCiDd2n
         Hw7A==
X-Forwarded-Encrypted: i=1; AJvYcCXbHbymX9IILO0gCCwx6crbjmb9oSbspUfmeBNPMkTqkXeyKgGeqQapLFbQgU+a//KV+AAbTlubXaLjWCyrlt+TggIh
X-Gm-Message-State: AOJu0Yztcwhcrfumlpqr6iIHOWtBPBmzadeDZWdNAlFGVlbSV70MnceZ
	HIM9FLTWh6YsneAJCg+RoCaBcu3yE6d5ftHqr0wVkdDOtg/WjyYMMqN8W1N808tgcdH6wcqf1AS
	xDA==
X-Google-Smtp-Source: AGHT+IHRIsSL43ZWHDYJyv+wWduH/mp7DvjWIBy12G8JAyQ7ZviuKBfYKWxrd22+duGrw/tAqkI65WqHd18=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:84c:b0:609:f189:1f59 with SMTP id
 bz12-20020a05690c084c00b00609f1891f59mr169425ywb.4.1710284621474; Tue, 12 Mar
 2024 16:03:41 -0700 (PDT)
Date: Tue, 12 Mar 2024 16:03:40 -0700
In-Reply-To: <fc3102f42ef6a1efa93d5bc75c9ed8653554cde2.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
 <Ze-TJh0BBOWm9spT@google.com> <6b38d1ea3073cdda0f106313d9f0e032345b8b75.camel@intel.com>
 <ZfBkle1eZFfjPI8l@google.com> <3c840ebd9b14d7a9abe0a563e2b6847273369dcd.camel@intel.com>
 <fc3102f42ef6a1efa93d5bc75c9ed8653554cde2.camel@intel.com>
Message-ID: <ZfDfTIIxVBhLzqqk@google.com>
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{, pre_}vcpu_map_memory()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "dmatlack@google.com" <dmatlack@google.com>, 
	"federico.parola@polito.it" <federico.parola@polito.it>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 12, 2024, Kai Huang wrote:
> On Tue, 2024-03-12 at 21:41 +0000, Huang, Kai wrote:
> > On Tue, 2024-03-12 at 07:20 -0700, Sean Christopherson wrote:
> > > On Tue, Mar 12, 2024, Kai Huang wrote:
> > > > > Wait. KVM doesn't *need* to do PAGE.ADD from deep in the MMU.  The only inputs to
> > > > > PAGE.ADD are the gfn, pfn, tdr (vm), and source.  The S-EPT structures need to be
> > > > > pre-built, but when they are built is irrelevant, so long as they are in place
> > > > > before PAGE.ADD.
> > > > > 
> > > > > Crazy idea.  For TDX S-EPT, what if KVM_MAP_MEMORY does all of the SEPT.ADD stuff,
> > > > > which doesn't affect the measurement, and even fills in KVM's copy of the leaf EPTE, 
> > > > > but tdx_sept_set_private_spte() doesn't do anything if the TD isn't finalized?
> > > > > 
> > > > > Then KVM provides a dedicated TDX ioctl(), i.e. what is/was KVM_TDX_INIT_MEM_REGION,
> > > > > to do PAGE.ADD.  KVM_TDX_INIT_MEM_REGION wouldn't need to map anything, it would
> > > > > simply need to verify that the pfn from guest_memfd() is the same as what's in
> > > > > the TDP MMU.
> > > > 
> > > > One small question:
> > > > 
> > > > What if the memory region passed to KVM_TDX_INIT_MEM_REGION hasn't been pre-
> > > > populated?  If we want to make KVM_TDX_INIT_MEM_REGION work with these regions,
> > > > then we still need to do the real map.  Or we can make KVM_TDX_INIT_MEM_REGION
> > > > return error when it finds the region hasn't been pre-populated?
> > > 
> > > Return an error.  I don't love the idea of bleeding so many TDX details into
> > > userspace, but I'm pretty sure that ship sailed a long, long time ago.
> > 
> > In this case, IIUC the KVM_MAP_MEMORY ioctl() will be mandatory for TDX
> > (presumbly also SNP) guests, but _optional_ for other VMs.  Not sure whether
> > this is ideal.

No, just TDX.  SNP's RMP purely works with pfns, i.e. the enforcement layer comes
into play *after* the stage-2 page table walks.  KVM can zap NPTs for SNP VMs at
will.

> > And just want to make sure I understand the background correctly:
> > 
> > The KVM_MAP_MEMORY ioctl() is supposed to be generic, and it should be able to
> > be used by any VM but not just CoCo VMs (including SW_PROTECTED ones)?
> > 
> > But it is only supposed to be used by the VMs which use guest_memfd()?  Because
> > IIUC for normal VMs using mmap() we already have MAP_POPULATE for this purpose.
> > 
> > Looking at [*], it doesn't say what kind of VM the sender was trying to use.
> > 
> > Therefore can we interpret KVM_MAP_MEMORY ioctl() is effectively for CoCo VMs? 
> > SW_PROTECTED VMs can also use guest_memfd(), but I believe nobody is going to
> > use it seriously.
> > 
> > [*] https://lore.kernel.org/all/65262e67-7885-971a-896d-ad9c0a760907@polito.it/
> > 
> > 
> 
> Hmm.. Just after sending I realized the MAP_POPULATE only pre-populate page
> table at host side, not EPT...

Yep, exactly.

> So the KVM_MAP_MEMORY is indeed can be used by _ALL_ VMs.  My bad :-(

