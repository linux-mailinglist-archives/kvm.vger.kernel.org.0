Return-Path: <kvm+bounces-32458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 382329D8996
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 16:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFC31169490
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFD11B412D;
	Mon, 25 Nov 2024 15:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qM8nhMu9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C55A1B3958
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732549478; cv=none; b=kbS8aGb0ehwEwD1cQywvsXrA9fhawoQfmQfZaiaEnMMjYR1VV546RtwyDJQ1TAqkWSGS4tmnwAHeyVT+COXjeurbiGvIo7hBC0snuw817zOGBTfB6m+2NIBg+gDe+Gw0wmf5DfE0wpA34E0vhLkQUo6n7Hb4BVzWakI7xDI9IHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732549478; c=relaxed/simple;
	bh=k0J7cdgG8ks0yKGQsm7oyOmsZLIKOC2JOO6K0l0qCvQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X3RvulXExNawfjoGj5MS92TDbUezwxQ1KYgEu1rg8XAsrAvzBZv6u/P93l+Mwj9sAjMn0GYHMM8AFFU55stavDVByjQCqM2ctVSZnH3pmhJPqMYCGkYxfd68sOScvb3fAiHoQnJRrl79J3Fb8PoLc3zCqNgYyqcCeuJwTCa2rYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qM8nhMu9; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72501c1609dso1506424b3a.2
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 07:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732549477; x=1733154277; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s49siFswnYJqise7IBA67ylLigPWlT1O8x62ECi7gWY=;
        b=qM8nhMu9DwVwkr/jZrjmx9sMPOindmqvxUqrdNqX+bGyi65Rjx70CyXy6HojPkhsye
         dr0C8x8zq5H1U2V5gyQSlv8CiVbsi1h9kb43KeYTymrVg4WOPPIbuocWPj8wlY3Ehc5s
         4x/lP320GYCsmgJJlZUW5pY4yfhs31K7dftoI7PBExevV1kZ84zhIpmphjCH7HD87LJG
         qmJhr5crNdxlzTqGqnNeY8IHVc+uUIlk8TCo8tzF4/gVkXVS127V/u2ifkCW14pChFOz
         7v0mZT+Npj7V8a8QwD7L5q+tWnnw+O9We124j1LVs11mKlL/qOwc2TwOKEN/GwF7nHwG
         r6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732549477; x=1733154277;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s49siFswnYJqise7IBA67ylLigPWlT1O8x62ECi7gWY=;
        b=TMD+RjgUUYLJ/wmIYr5SL5PZ4dRsxLeWy4Bc7cSswIb7PsoriAEKE073Q05WevU3xl
         WjWBIHoiUa5YHgjwQeCzAy9wBbgAbqXN7JqW8qYF7p2NaCK21h0Pyswsx4EvEWlmOCRT
         IUjpb7HxLSLx+3Kh4rW+f+bhPeiWKKpQduICJoagHthWxgzxWernoNGgpacT3wa33MWT
         ve7ocCbqkwEmpj0+SNfdyG3RYtj3q74p1uIj5OgtpX1wxl9WoRrnZdsDtGMvLS1Trpd3
         bG/sh81Bc2wpJqj0PbWNMS+6qDmH0WcgzBqlX/FN7t5amJPczjVJrhlLjdFijqnRg3nH
         vZ+g==
X-Forwarded-Encrypted: i=1; AJvYcCWs2K0wEz5/uG2F6qUZZHzlRz3Ob4lf+oacJ5BgyO6smTTpK3fqMMQHfBtq34YGflwId6M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvdT+uvsVS3ErmrfRg3vPipaP+XqOk97XS6r73PmJshUyRi9uQ
	GQL9fGbJLGwXk0M/dFze5+3Ap0Nwfkg/3ZQvjDP4sPqW5BBbCLW3pMXuhUIpX/8+UqE1fNcIMMH
	7+w==
X-Google-Smtp-Source: AGHT+IFhBxq93qQHLR1eb3eUOxjNGlaFOEGalzPBmpyOIfTBB2kKogtVIU5S2oVaZxk5JZeZRsg/VdkBF/Q=
X-Received: from ploh14.prod.google.com ([2002:a17:902:f70e:b0:206:fee5:fffa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2288:b0:20c:98f8:e0fa
 with SMTP id d9443c01a7336-2129f21a154mr204435955ad.11.1732549476840; Mon, 25
 Nov 2024 07:44:36 -0800 (PST)
Date: Mon, 25 Nov 2024 07:44:35 -0800
In-Reply-To: <6903d890-c591-4986-8c88-a4b069309033@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241115202028.1585487-1-rick.p.edgecombe@intel.com>
 <20241115202028.1585487-2-rick.p.edgecombe@intel.com> <30d0cef5-82d5-4325-b149-0e99833b8785@intel.com>
 <Z0EZ4gt2J8hVJz4x@google.com> <6903d890-c591-4986-8c88-a4b069309033@intel.com>
Message-ID: <Z0SbYzr20UQjptgC@google.com>
Subject: Re: [RFC PATCH 1/6] x86/virt/tdx: Add SEAMCALL wrappers for TDX KeyID management
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	isaku.yamahata@gmail.com, kai.huang@intel.com, linux-kernel@vger.kernel.org, 
	tony.lindgren@linux.intel.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com, 
	x86@kernel.org, adrian.hunter@intel.com, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 22, 2024, Dave Hansen wrote:
> On 11/22/24 15:55, Sean Christopherson wrote:
> > On Fri, Nov 22, 2024, Dave Hansen wrote:
> > I don't know the full context, but working with "struct page" is a pain when every
> > user just wants the physical address.  KVM SVM had a few cases where pointers were
> > tracked as "struct page", and it was generally unpleasant to read and work with.
> 
> I'm not super convinced. page_to_phys(foo) is all it takes

I looked again at the KVM code that bugs me, and my complaints are with code that
needs both the physical address and the virtual address, i.e. that could/should
use a meaningful pointer to describe the underlying data structure since KVM does
directly access the memory.

But for TDX pages, that obviously doesn't apply, so I withdraw my objection about
using struct page.

> > I also don't like conflating the kernel's "struct page" with the architecture's
> > definition of a 4KiB page.
> 
> That's fair, although it's pervasively conflated across our entire
> codebase. But 'struct page' is substantially better than a hpa_t,
> phys_addr_t or u64 that can store a full 64-bits of address. Those
> conflate a physical address with a physical page, which is *FAR* worse.
> 
> >> You know that 'tdr' is not just some random physical address.  It's a
> >> whole physical page.  It's page-aligned.  It was allocated, from the
> >> allocator.  It doesn't point to special memory.
> > 
> > Oh, but it does point to special memory.  If it *didn't* point at special memory
> > that is completely opaque and untouchable, then KVM could use a struct overlay,
> > which would give contextual information and some amount of type safety.  E.g.
> > an equivalent without TDX is "struct vmcs *".
> > 
> > Rather than "struct page", what if we add an address_space (in the Sparse sense),
> > and a typedef for a TDX pages?  Maybe __firmware?  E.g.
> > 
> >   # define __firmware	__attribute__((noderef, address_space(__firmware)))
> > 
> >   typedef u64 __firmware *tdx_page_t;
> > 
> > That doesn't give as much compile-time safety, but in some ways it provides more
> > type safety since KVM (or whatever else cares) would need to make an explicit and
> > ugly cast to misuse the pointer.
> 
> It's better than nothing. But I still vastly prefer to have a type that
> tells you that something is physically-allocated out of the buddy, RAM,
> and page-aligned.
> 
> I'd be better to have:
> 
> struct tdx_page {
> 	u64 page_phys_addr;
> };
> 
> than depend on sparse, IMNHO.
> 
> Do you run sparse every time you compile the kernel, btw? ;)

Nah, but the 0-day both does such a good job of detecting and reporting new warnings
that I'm generally comfortable relying on sparse for something like this.  Though
as above, I'm ok with using "struct page" for the TDX pages.

