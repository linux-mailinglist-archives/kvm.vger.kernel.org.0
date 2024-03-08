Return-Path: <kvm+bounces-11342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95549875BF6
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 02:28:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51E04283853
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 01:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266DC22638;
	Fri,  8 Mar 2024 01:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z3eMkDpS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042C463C1
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 01:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709861304; cv=none; b=P+C3o4wOSY0/wNjucMgYaiJeX6r+bLVW4eKLA6X89t91jz5N9v+RbR0i0jWqPwQ8xrPGefyU/BpZfT7K8i/1yZEs59ttKYxvgk1rtIIcjShj0qcYHHEtoK9FnGVoZCUFTeQDwnqCTnFgz3mv/TKDIk/whzw8UakdWu825zYSaZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709861304; c=relaxed/simple;
	bh=WdRzAXoOjri8cM1mBf2nyZ1olyPeorHKC2ja6oHUC8w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CSz5Gh5xc+VsF5vfdLo/TG+uJFqP2Rz5ltt+nF9LVJYiZW83J396EcjPA5mTnmntwlJO6Aq+1QUZkTpOAoz6oO2ItjrR1h3GWRCUvod3tqKgmV5b9hzVM94pU4NS9bQiFB7jRqApoUgFwD2XC3TWEbIUawRNrxoHiinznRqh/FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z3eMkDpS; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e5db5599afso1399813b3a.3
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 17:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709861302; x=1710466102; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Q7HJDONtRmF9iMvjCwghqWgvN0CigeogTDpvGQ69zI=;
        b=z3eMkDpS/6+PetwDBmlpRG7eOoJ7Yj2yffijPFTBRNMv8KatRYJpOndk24nc1kc8Yh
         mSG6DwOaG1HZZwRZb8J5qB2qcxHBMPXLQaQuuUCi9byCqvijNj9/sEFj0PuWZibUuURD
         aQywtjzDegzBpLk6xbOqZdpSTSCJ4KzjvfiEsyluBFQAdFHJ96jHCY8gkbsjbRX7uTNm
         AJJqeLknQBb4NNPLQ8j4u3PZBrCtbWlxsQUNALHWlFZwE3TBo1ha1LziDMcqe+lhoIom
         A8g/QYhi+H5QGMOcP+8gIwxpUhPhlQxMHbzevdpPltsipTpxbMqO0/wq/Etgu6GBKu6S
         4xdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709861302; x=1710466102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Q7HJDONtRmF9iMvjCwghqWgvN0CigeogTDpvGQ69zI=;
        b=MkvDu5DqeQoTie81dDAGOprX5WKIfLA8PdoiT3zF6e0P5Drp7HHlTrFCjHVhMD7gzP
         OjtEEF3CZu03mqOigi1xltuJSgP5ZbBpzwQR2ZO9hs4MhG5rZUUbUrXxPvZlqYt3xDPV
         r2si42t6pU9v9pYgSRe2DXh57Mh81B4TvblBw4hwLYl92ZInmXxbkaqBdZywWhNDK0zK
         OLjBXfLytjplt1RwSK3u3Uf51PwpHVb6lATrRydAMj8mi2xcCHcFAL0esNWYNicF7TbG
         Zv6uUIuXwZXLB3VG/G40htwCZ7HncvEaXfASXMuOWKzCnKNObPRiykHg6FyQMUH5DzkH
         1fWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/rX+fmEDf9xqcSBuQNZ3KmzTQyHPxbFj5z9fVNDmgUkx1iwCJLKY0aJEXs55Py/gASEqAqsGw4K47033bbpk0xd/D
X-Gm-Message-State: AOJu0Yyqf7ymm5i4QdzXGSPf7S14Bkr2Zo8uCLM+kQ5p6ezy8iRNhW77
	BA8/776o4KHRG4/+/1eKBJqKhvncNjUFtdnfUvsZcYM4h7JJFLIRDnvKosrS9fl+2wTGrnRd+4s
	XGA==
X-Google-Smtp-Source: AGHT+IHdYWUzvYdf15FnyNO896HQz1OFemDtQKuALNWeOLBq+TJIPqRQI68uDP5g8qHfZP4vcbtwxAcqddw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9398:b0:6e5:35c8:eefa with SMTP id
 ka24-20020a056a00939800b006e535c8eefamr382394pfb.2.1709861302144; Thu, 07 Mar
 2024 17:28:22 -0800 (PST)
Date: Thu, 7 Mar 2024 17:28:20 -0800
In-Reply-To: <ZepiU1x7i-ksI28A@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <c50dc98effcba3ff68a033661b2941b777c4fb5c.1709288671.git.isaku.yamahata@intel.com>
 <9f8d8e3b707de3cd879e992a30d646475c608678.camel@intel.com>
 <20240307203340.GI368614@ls.amr.corp.intel.com> <35141245-ce1a-4315-8597-3df4f66168f8@intel.com>
 <ZepiU1x7i-ksI28A@google.com>
Message-ID: <ZepptFuo5ZK6w4TT@google.com>
Subject: Re: [RFC PATCH 1/8] KVM: Document KVM_MAP_MEMORY ioctl
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@linux.intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"federico.parola@polito.it" <federico.parola@polito.it>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, David Matlack wrote:
> On 2024-03-08 01:20 PM, Huang, Kai wrote:
> > > > > +:Parameters: struct kvm_memory_mapping(in/out)
> > > > > +:Returns: 0 on success, <0 on error
> > > > > +
> > > > > +KVM_MAP_MEMORY populates guest memory without running vcpu.
> > > > > +
> > > > > +::
> > > > > +
> > > > > +  struct kvm_memory_mapping {
> > > > > +	__u64 base_gfn;
> > > > > +	__u64 nr_pages;
> > > > > +	__u64 flags;
> > > > > +	__u64 source;
> > > > > +  };
> > > > > +
> > > > > +  /* For kvm_memory_mapping:: flags */
> > > > > +  #define KVM_MEMORY_MAPPING_FLAG_WRITE         _BITULL(0)
> > > > > +  #define KVM_MEMORY_MAPPING_FLAG_EXEC          _BITULL(1)
> > > > > +  #define KVM_MEMORY_MAPPING_FLAG_USER          _BITULL(2)
> > > > 
> > > > I am not sure what's the good of having "FLAG_USER"?
> > > > 
> > > > This ioctl is called from userspace, thus I think we can just treat this always
> > > > as user-fault?
> > > 
> > > The point is how to emulate kvm page fault as if vcpu caused the kvm page
> > > fault.  Not we call the ioctl as user context.
> > 
> > Sorry I don't quite follow.  What's wrong if KVM just append the #PF USER
> > error bit before it calls into the fault handler?
> > 
> > My question is, since this is ABI, you have to tell how userspace is
> > supposed to use this.  Maybe I am missing something, but I don't see how
> > USER should be used here.
> 
> If we restrict this API to the TDP MMU then KVM_MEMORY_MAPPING_FLAG_USER
> is meaningless, PFERR_USER_MASK is only relevant for shadow paging.

+1

> KVM_MEMORY_MAPPING_FLAG_WRITE seems useful to allow memslots to be
> populated with writes (which avoids just faulting in the zero-page for
> anon or tmpfs backed memslots), while also allowing populating read-only
> memslots.
> 
> I don't really see a use-case for KVM_MEMORY_MAPPING_FLAG_EXEC.

It would midly be interesting for something like the NX hugepage mitigation.

For the initial implementation, I don't think the ioctl() should specify
protections, period.

VMA-based mappings, i.e. !guest_memfd, already have a way to specify protections.
And for guest_memfd, finer grained control in general, and long term compatibility
with other features that are in-flight or proposed, I would rather userspace specify
RWX protections via KVM_SET_MEMORY_ATTRIBUTES.  Oh, and dirty logging would be a
pain too.

KVM doesn't currently support execute-only (XO) or !executable (RW), so I think
we can simply define KVM_MAP_MEMORY to behave like a read fault.  E.g. map RX,
and add W if all underlying protections allow it.

That way we can defer dealing with things like XO and RW *if* KVM ever does gain
support for specifying those combinations via KVM_SET_MEMORY_ATTRIBUTES, which
will likely be per-arch/vendor and non-trivial, e.g. AMD's NPT doesn't even allow
for XO memory.

And we shouldn't need to do anything for KVM_MAP_MEMORY in particular if
KVM_SET_MEMORY_ATTRIBUTES gains support for RWX protections the existing RWX and
RX combinations, e.g. if there's a use-case for write-protecting guest_memfd
regions.

We can always expand the uAPI, but taking away functionality is much harder, if
not impossible.

