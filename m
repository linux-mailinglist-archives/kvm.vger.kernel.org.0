Return-Path: <kvm+bounces-13507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 785C4897BEF
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 01:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E1D22840D8
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 23:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146B1156C41;
	Wed,  3 Apr 2024 23:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3wfA4fc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB0115696D
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 23:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712186137; cv=none; b=TYIUqgtCOcBKj8sF5uO4pkF7+as7qHZ0UbBkXDIzHtaMEKzoXFSzUty22K7jqei5R38d/H7D0UgXJDQ7oAsB5WGtipQad5pKmPo9ttwnBFZQG+aQ3Cy/2oqJ670FxvlMxKFfR4uIzRFcdSTAQ3xtQvM41CeoI61HEykD+uqZIlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712186137; c=relaxed/simple;
	bh=qNXU/bUrc0L/NLVUkTSuOdRJ6SCODkDxrzDMtdi4DyU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=obxtzL8YbTogziYaOus/gMGdJSl5GFkrOKO9l72LwheT9F4qP4jdQjJZAws7Bp5/uP3zmLuNeRQSqkYEW1v5275KgEDLOAVCM5h2RUlYwlhFyPobbSdD59Jr2ZdCndhgOVXZPuKl/hyFBpq8SqZx5/kFTzJek97jJysxtinG1bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3wfA4fc; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ea80a33cf6so286149b3a.1
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 16:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712186135; x=1712790935; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IB8YIURPP9Hr/QwsBdTaRFjE5dnhh/l5+FEwiaO3zio=;
        b=F3wfA4fcW6LlM2GZ0QNMjYGd334clyCfrnaotPL9u2ZjLof3IAresrrIy6Jv6XMOF3
         aW5eWsdY4OLCzwT4ws+TuJYtMQTr5LcbUlTah41IlbyHAZgdEon9GvtjQ6agQuLwRJLs
         Wvif4H0aI4zA9o6kz8bla1ayvQKk4JmvqDWisboVsGx0up6B7wLqDlXXCDMADxG6CPU5
         SuMBHMYsoz7UY86IHFSpXDQs7NYdJ43tt5oK3hwgck7vCEnbTnkWHD9fToiuUR7Y6Uk5
         Q0+v85xkmGJBttyunJGWMInLwmDttvfhClucW8NBe1jKof+ZTsCZLo4LNBeyjLOXw2iq
         s1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712186135; x=1712790935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IB8YIURPP9Hr/QwsBdTaRFjE5dnhh/l5+FEwiaO3zio=;
        b=V5iuuUS9uslu012gxdia+XhBg5+a9dtL5UGpX61Ocak6hU7UbbocvpqdeojToy6aAz
         PiutfA7kuFUFOoIQZAPUEa51Mu65lGVhE9PdcESQtwAQaR+8RfLaOgUcqqWbKBmnttv7
         xCatUcxZjlFP0RyOSjQsjtF+dviygBgyHyKTw1DLhOwl3uV/ophgt3t4zRiT0uef2YwL
         Id1I8pkMf+F3O9JZuJL6Aj/CBBs4n20XIX2yvFag1nNYFk1kT9ssPZsox5ihTqtVWUNC
         ly4llNgZsXiOrpEjamLSKLVueBN+wX7zTBT/SX3J7x4TQFxrmM+DS8vvZKJwIywDB4C9
         R1mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPg7jDyXzpRHnPoatYu8oiEIh3K2SnXVEAuYg3BnK6G/NDTOd4vxgq1jt44Lwr3IGbOme0/W2m7IU1rGUfabTkzNN4
X-Gm-Message-State: AOJu0Yy8g3WO+svT+gAUojlZn/eA2E60yPiqUUo/KdNkwJvcqI9YbLID
	vmBuRb07pVMrc/s9wnPuspdlm/sI+zxmMhxviSIwosHqA3jSyrUuerA7x/qr5UNFO+tdUZLjhl+
	0qw==
X-Google-Smtp-Source: AGHT+IHM2Gi4Oz11LLDFw68UYLc1qaCz0J93vLN5P6N52qnWfR4AFa7CZZ5/Z9OAygbOKXpXYQsncRkeo0Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:983:b0:6ea:f815:a428 with SMTP id
 u3-20020a056a00098300b006eaf815a428mr66918pfg.1.1712186135077; Wed, 03 Apr
 2024 16:15:35 -0700 (PDT)
Date: Wed, 3 Apr 2024 16:15:33 -0700
In-Reply-To: <20240319162602.GF1645738@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
 <ZekKwlLdf6vm5e5u@google.com> <CALzav=dHNYP02q_CJncwk-JdL9OSB=613v4+siBm1Cp2rmxLLw@mail.gmail.com>
 <20240307015151.GF368614@ls.amr.corp.intel.com> <20240319162602.GF1645738@ls.amr.corp.intel.com>
Message-ID: <Zg3jFRZp8F514r8b@google.com>
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{, pre_}vcpu_map_memory()
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Michael Roth <michael.roth@amd.com>, Federico Parola <federico.parola@polito.it>
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 19, 2024, Isaku Yamahata wrote:
> On Wed, Mar 06, 2024 at 05:51:51PM -0800,
> > Yes. We'd like to map exact gpa range for SNP or TDX case. We don't want to map
> > zero at around range.  For SNP or TDX, we map page to GPA, it's one time
> > operation.  It updates measurement.
> > 
> > Say, we'd like to populate GPA1 and GPA2 with initial guest memory image.  And
> > they are within same 2M range.  Map GPA1 first. If GPA2 is also mapped with zero
> > with 2M page, the following mapping of GPA2 fails.  Even if mapping of GPA2
> > succeeds, measurement may be updated when mapping GPA1. 
> > 
> > It's user space VMM responsibility to map GPA range only once at most for SNP or
> > TDX.  Is this too strict requirement for default VM use case to mitigate KVM
> > page fault at guest boot up?  If so, what about a flag like EXACT_MAPPING or
> > something?
> 
> I'm thinking as follows. What do you think?
> 
> - Allow mapping larger than requested with gmem_max_level hook:

I don't see any reason to allow userspace to request a mapping level.  If the
prefetch is defined to have read fault semantics, KVM has all the wiggle room it
needs to do the optimal/sane thing, without having to worry reconcile userspace's
desired mapping level.

>   Depend on the following patch. [1]
>   The gmem_max_level hook allows vendor-backend to determine max level.
>   By default (for default VM or sw-protected), it allows KVM_MAX_HUGEPAGE_LEVEL
>   mapping.  TDX allows only 4KB mapping.
> 
>   [1] https://lore.kernel.org/kvm/20231230172351.574091-31-michael.roth@amd.com/
>   [PATCH v11 30/35] KVM: x86: Add gmem hook for determining max NPT mapping level
> 
> - Pure mapping without coco operation:
>   As Sean suggested at [2], make KVM_MAP_MEMORY pure mapping without coco
>   operation.  In the case of TDX, the API doesn't issue TDX specific operation
>   like TDH.PAGE.ADD() and TDH.EXTEND.MR().  We need TDX specific API.
> 
>   [2] https://lore.kernel.org/kvm/Ze-XW-EbT9vXaagC@google.com/
> 
> - KVM_MAP_MEMORY on already mapped area potentially with large page:
>   It succeeds. Not error.  It doesn't care whether the GPA is backed by large
>   page or not.  Because the use case is pre-population before guest running, it
>   doesn't matter if the given GPA was mapped or not, and what large page level
>   it backs.
> 
>   Do you want error like -EEXIST?

No error.  As above, I think the ioctl() should behave like a read fault, i.e.
be an expensive nop if there's nothing to be done.

For VMA-based memory, userspace can operate on the userspace address.  E.g. if
userspace wants to break CoW, it can do that by writing from userspace.  And if
userspace wants to "request" a certain mapping level, it can do that by MADV_*.

For guest_memfd, there are no protections (everything is RWX, for now), and when
hugepage support comes along, userspace can simply manipulate the guest_memfd
instance as needed.

