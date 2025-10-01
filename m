Return-Path: <kvm+bounces-59231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AC723BAEDA3
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 02:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4EF1B4E1F3B
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 00:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0539B652;
	Wed,  1 Oct 2025 00:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FlVzb5Ie"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D2C3C17
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 00:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759277354; cv=none; b=C+wJGJcV2CCz7Az6/oHxdWGUgLEcRSn4UNjUIWlU73GnQW5ep1CXXFGSGlisipcenCC/oLeazNE2kHUolyFQuVPeJOlWKnDkZpXCruN45ei3qYXAYI1EHLZg9Mr5+ErZf71rx+ta+zTC/SCV9hd5kFXMDSSTlt2mXx3GPGksRDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759277354; c=relaxed/simple;
	bh=0Iw9iuAwT2IPLSBMbT2SNcSiFIe4t8mpFaOBM+D3eFs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ezcI45LRjM9Lu3P2jmbrpp0lPCcoAgcVp2cFABLaIYngOyL/9Hq4x9ledQNEXYkyFdGAZbpYfGEDMr5Mse0+LQD6PK9HzAqUlwPIPB/UIhrwENeechqxdOtbMKPnuGZ63wZpjGd21AIYv+FL7dMEBmOE6YyniYZujzJgbERQFZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FlVzb5Ie; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28d1747f23bso26291105ad.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759277352; x=1759882152; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NZaBe0K2iz4Ve4SNmKGp+0aX5t53tPftezY7VMX/ZW0=;
        b=FlVzb5IeLF9uVfG6NnRQK8PHyVvPTgMM/C7RhUa1RhyJo08Idb/Co9yXa3/RguBLBo
         OVvPlb2P6niRU/5JwyLN0z2h33pnNsLZlKOu3eMyKKgWObCEWmje7MUGsQhdbe/WTaaD
         5uFYuTJxobZD6cW0wXeF64bUXBZwlatw9YPhMwPS0tNfMuUNwhqU8wjcxwqzRWkXHnlm
         Lpg3x6Ywi6AKT52oeeuJYllEDE75NM++l3q/tUMQwQB/c7b5dR3iROzVd+pshYyyiSXS
         S4k430mwcWKjWs6sDdLDTzu4vPpXPJKtnzip6W1wyROWPX9X5jQQSECbObgHfsFtAA5v
         4qBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759277352; x=1759882152;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NZaBe0K2iz4Ve4SNmKGp+0aX5t53tPftezY7VMX/ZW0=;
        b=CpLMcgzTZuLIdZujpxlbku1a6fYJEr5wKxZKFvMCbZyioyfSR2N+6LOwXgqDKlgxDZ
         41ySnT7oyS++m+Ip2sJwlT3amA+uZc8/7luzxzh7uCEVlXKKo7vL2jqV5muvb6v1ZQzM
         YA2JhrfhTWtuNs9pc6MWxMdH9ACXZKMnr6jKIHGaME6fb9ENnLnpPsWOyjn3I2nYAW+Q
         HVufEQQxfwzXtU3bhJJaldRkxmmL34/O4dQuXwJJ7fC/O2qOz+/w5gx54huRimaIvYdj
         2MGvQXtnvOZ4/AFtA29sDbEGUMrQdWB/datAuPY8bgbMg3Y4KyGgeTO2pWoCNbgELmYI
         roMg==
X-Gm-Message-State: AOJu0Yxof1cZOLKHiaqkjWLBvitV50ICln+YTrTynQ5dh+QAq7+jkxpY
	P46ZRJk15FFjV1mNPFzaTdDIoB7T4meczyMAiOIc4j7KwoA/26DT2OjGjTbu1qaD1d4UcO7XvGC
	tfhWPjg==
X-Google-Smtp-Source: AGHT+IEQr7X8zhrCcE7yur6wxLh3lSN3M1C/+U8kGIxy4Ja/7HgbLk0MlkSEQOAK7i11sdbL4d1PXCPOAb4=
X-Received: from plbml6.prod.google.com ([2002:a17:903:34c6:b0:269:99ad:5abe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebd2:b0:250:1c22:e78
 with SMTP id d9443c01a7336-28e7f26f2fdmr18119465ad.1.1759277351793; Tue, 30
 Sep 2025 17:09:11 -0700 (PDT)
Date: Wed, 1 Oct 2025 00:09:10 +0000
In-Reply-To: <aNxwzc0a_xtTW7Ih@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqzecwjnk95.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTyY5C1QgkoAqvJ0kHM4nUvKc1e1nQ0Uq+BANtVEnZH90w@mail.gmail.com>
 <CAGtprH-fE=G923ctBAcq5zFna+2WULhmHDSbXUsZKUrin29b4g@mail.gmail.com>
 <CA+EHjTxvufYVA8LQWRKEX7zA0gWLQUHVO2LvwKc5JXVu-XAEEA@mail.gmail.com>
 <CAGtprH_TfKT3oRPCLbh-ojLGXSfOQ2XA39pVhr47gb3ikPtUkw@mail.gmail.com>
 <CA+EHjTxJZ_pb7+chRoZxvkxuib2YjbiHg=_+f4bpRt2xDFNCzQ@mail.gmail.com>
 <aC86OsU2HSFZkJP6@google.com> <CA+EHjTxjt-mb_WbtVymaBvCb1EdJAVMV_uGb4xDs_ewg4k0C4g@mail.gmail.com>
 <aC9QPoEUw_nLHhV4@google.com> <aNxwzc0a_xtTW7Ih@google.com>
Message-ID: <aNxxJodpbHceb3rF@google.com>
Subject: Re: [RFC PATCH v2 04/51] KVM: guest_memfd: Introduce
 KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 30, 2025, Sean Christopherson wrote:
> Trimmed Cc again.

And of course I forgot to actually Cc folks...

> On Thu, May 22, 2025, Sean Christopherson wrote:
> > On Thu, May 22, 2025, Fuad Tabba wrote:
> > > From a conceptual point of view, I understand that the in-place conversion is
> > > a property of guest_memfd. But that doesn't necessarily mean that the
> > > interface between kvm <-> guest_memfd is a userspace IOCTL.
> 
> ...
> 
> > A decent comparison is vCPUs.  KVM _could_ route all ioctls through the VM, but
> > that's unpleasant for all parties, as it'd be cumbersome for userspace, and
> > unnecessarily complex and messy for KVM.  Similarly, routing guest_memfd state
> > changes through KVM_SET_MEMORY_ATTRIBUTES is awkward from both design and mechanical
> > perspectives.
> > 
> > Even if we disagree on how ugly/pretty routing conversions through kvm would be,
> > which I'll allow is subjective, the bigger problem is that bouncing through
> > KVM_SET_MEMORY_ATTRIBUTES would create an unholy mess of an ABI.
> > 
> > Today, KVM_SET_MEMORY_ATTRIBUTES is handled entirely within kvm, and any changes
> > take effect irrespective of any memslot bindings.  And that didn't happen by
> > chance; preserving and enforcing attribute changes independently of memslots was
> > a key design requirement, precisely because memslots are ephemeral to a certain
> > extent.
> > 
> > Adding support for in-place guest_memfd conversion will require new ABI, and so
> > will be a "breaking" change for KVM_SET_MEMORY_ATTRIBUTES no matter what.  E.g.
> > KVM will need to reject KVM_MEMORY_ATTRIBUTE_PRIVATE for VMs that elect to use
> > in-place guest_memfd conversions.  But very critically, KVM can cripsly enumerate
> > the lack of KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_CAP_MEMORY_ATTRIBUTES, the
> > behavior will be very straightforward to document (e.g. CAP X is mutually excusive
> > with KVM_MEMORY_ATTRIBUTE_PRIVATE), and it will be opt-in, i.e. won't truly be a
> > breaking change.
> > 
> > If/when we move shareability to guest_memfd, routing state changes through
> > KVM_SET_MEMORY_ATTRIBUTES will gain a subtle dependency on userspace having to
> > create memslots in order for state changes to take effect.  That wrinkle would be
> > weird and annoying to document, e.g. "if CAP X is enabled, the ioctl ordering is
> > A => B => C, otherwise the ordering doesn't matter", and would create many more
> > conundrums:
> > 
> >   - If a memslot needs to exist in order for KVM_SET_MEMORY_ATTRIBUTES to take effect,
> >     what should happen if that memslot is deleted?
> >   - If a memslot isn't found, should KVM_SET_MEMORY_ATTRIBUTES fail and report
> >     an error, or silently do nothing?
> >   - If KVM_SET_MEMORY_ATTRIBUTES affects multiple memslots that are bound to
> >     multiple guest_memfd, how does KVM guarantee atomicity?  What happens if one
> >     guest_memfd conversion succeeds, but a later fails?
> 
> Note, my above objections were purely about routing updates through a VM, e.g. due
> to having to resolve memslots and whatnot.  I.e. I swear I'm not contradicting
> myself by suggesting we reuse KVM_SET_MEMORY_ATTRIBUTES itself on the gmem file
> descriptor.  I'm pretty sure past me didn't think at all about the actual uAPI,
> only the roles and responsibilities.

