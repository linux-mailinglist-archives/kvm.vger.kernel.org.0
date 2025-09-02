Return-Path: <kvm+bounces-56621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4EAEB40C30
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 19:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 479211B65E24
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 17:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0AD345737;
	Tue,  2 Sep 2025 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qRYtg7lZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AC52D5C91
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756834650; cv=none; b=G+CeT9L7VFmdmAyrxORm59FvgUJERGQd3RGlWp8rjpCz8ZJ2w8tCVs8v42y8Ex0jHYYzqrCxMCHymvAVBwEPOz8Z2RUqm1BmN8bjwWWk1QG8kJKlxnRUZLRxD7iDcR6pl1X1slehNTVkPLke3ugrkpNH+oKgAbFsNmNxBudcD1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756834650; c=relaxed/simple;
	bh=UonqYJLVNakVOY6o6lPFaWpzfXcM97G+FXJjHUjRXms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VbAAqNTcM9ZlipIOZBLBSOXN2LulBmuu8kRVeacAnTtFq3Jgk3/MUO5/y/1RupEmLeDmh/EpFk6+aI3m7jkLw9ELVhPLd9tWWNyfVWs5Motr0rl2Gz8N8a878UJ0IqiUb5jx9wIz4N8jDAgoNPALaQn7U+6cDYQa/8EvfJVoHyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qRYtg7lZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32b51b26802so288361a91.2
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 10:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756834649; x=1757439449; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z5SO6Rfnd2zRTNKmu49rD4GYcuQHp/i9kQ66dZ48xrs=;
        b=qRYtg7lZpLGvANpctxiC0zLcVffLh+yU3D22JZpWgs283i6fygWBj2Y3XCYEB4v0v9
         WHa7FvUDvnRqgKERZg8vAWMSLIXXAxysYjFcWcyfspCaWDdU+B6PWYY7ON8gAt7RnZ76
         ugInlPtBsxI/9hdGBlazMYyKUXeTvjdFPQQiFo4n5H0DuvN3ibCJbB0/qNhmb/ZxWzai
         tYVm5GtPuEe7adZb9D5SoQ/53lory0g5ETeqSVVO+qHcirgqGhXjPKrTjbKmg9HVQ92b
         WmSeZce+osUpUvnFdfTKz8QxFr5PggA1yvo3S9tm5pnrKaPOpvZ+XwEJMk537/SSfl5P
         KnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756834649; x=1757439449;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z5SO6Rfnd2zRTNKmu49rD4GYcuQHp/i9kQ66dZ48xrs=;
        b=BFzSp8Y+uUbqBWpSfytE6c1CI+4iIyjTUCf/oLF/7+AII6acMtx2aZ6v0IYcaINnXB
         pFGq1nHsw4E8twrjozGtFjeV61ssiYDNGD9BXOVr9Mel6PDHte5CqIzXHIXUx+0Qje1t
         yUm4kRYb4mtoZ0gcO3uDzyC6QINri+v8A+ltSk3fts9fvmKuVMTohQbZHMIqUTSrf/Ai
         AsoqprpXEOt0S/Rqt4mPCSahoA8ebD+qPwObD+qxcOa8yuXdruPGoq483vMJfVyGiCew
         gO7BmBV/YwQxNBapLtUIPh1KzQnj/LjdFut0pxPKo87bz/oHyhJKJUSsWx1l/De2WFar
         VVIw==
X-Forwarded-Encrypted: i=1; AJvYcCWDM1Qn/2iTOX84yamMjNldqgYXKYZDO5w5+7259PGPWMGULkLlPo2FT/3RNSoDHKbB4aI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDzwry8dAkOPWe0b09WaF0h2K77oVA7ukCxwKBJ8duQy+l6oue
	uhLi9S8tizvHeUV78hBREyfQynEhcmHyP9xuU6cvYOaeajx4NVt5ulcBbvA2zzYdU2JoRuiWvD/
	BY/mFkA==
X-Google-Smtp-Source: AGHT+IEiqfPJUyct4fFBcu0bR/Eu7HWia2o0j4MX/eBkmoNoywellJvAZIebualblVHJhISyhTr8W0gnrwM=
X-Received: from pjbsy12.prod.google.com ([2002:a17:90b:2d0c:b0:327:a21a:7e8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d45:b0:325:42f8:d73f
 with SMTP id 98e67ed59e1d1-328156bb311mr19310229a91.17.1756834647846; Tue, 02
 Sep 2025 10:37:27 -0700 (PDT)
Date: Tue, 2 Sep 2025 10:37:26 -0700
In-Reply-To: <87fe45aae8d0812bd3aec956e407c3cc88234b34.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094149.4467-1-yan.y.zhao@intel.com>
 <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com> <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
 <87fe45aae8d0812bd3aec956e407c3cc88234b34.camel@intel.com>
Message-ID: <aLcrVp6_9gNrp1Bn@google.com>
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_page_demote()
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Fan Du <fan.du@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"tabba@google.com" <tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	"kas@kernel.org" <kas@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Chao P Peng <chao.p.peng@intel.com>, "zhiquan1.li@intel.com" <zhiquan1.li@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Jun Miao <jun.miao@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "pgonda@google.com" <pgonda@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 02, 2025, Rick P Edgecombe wrote:
> On Mon, 2025-09-01 at 17:08 +0800, Yan Zhao wrote:
> > > The cover letter mentions that there is a new TDX module in planning, which
> > > disables the interrupt checking. I guess TDX module would need to have a
> > > interface to report the change, KVM then decides to enable huge page support
> > > or not for TDs?
> > Yes. But I guess detecting TDX module version or if it supports certain
> > feature is a generic problem. e.g., certain versions of TDX module have bugs
> > in zero-step mitigation and may block vCPU entering.
> > 
> 
> We had talked in the past of not checking versions because it would require KVM
> to keep logic of which features in which TDX module.

Checking for features is different from refusing to load broken modules.  I don't
want KVM to rely on version numbers to query features, because that relies on
"newer" module versions always being a superset relative to "older" versions.

> If there is a flag we could check it, but we did not ask for one here. We
> already have a situation where there are bug fixes that KVM depends on, with no
> way to check.
> 
> I guess the difference here is that if the behavior is missing, KVM has an
> option to continue with just small pages. But at the same time, huge pages is
> very likely to succeed in either case. The "feature" is closer to closing a
> theoretical race. So very much like the many bugs we don't check for. I'm
> leaning towards lumping it into that category. And we can add "how do we want to
> check for TDX module bugs" to the arch todo list. But it's probably down the
> list, if we even want to do anything.
> 
> What do you think?

Could we taint the kernel and print a scary message if a known-buggy TDX module
is loaded?

