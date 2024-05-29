Return-Path: <kvm+bounces-18322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7905D8D3A35
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 17:02:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A9D7B24783
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 15:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8872217BB3A;
	Wed, 29 May 2024 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MKs8TXBY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5DD15991E
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 15:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994900; cv=none; b=gzub2H8MbWAH4RSEuTfN2VPwHbVG7NYrxPFhRwfdJD19ZbDPgVdFml+U9O3pOwaGJ5gQsfd/HWqIBRGD2UknfaOOQWwUCUcoc3tQRuTchQ4+SCUYCsy0URkNgddwtdc8gw6iD9hM2qSMBQBk/YE2F2FwC8AIzfiqmI2xtR5//U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994900; c=relaxed/simple;
	bh=2AvoFxo2w3qR0zKbuN6VSypvjNw7+Xedz87CH77xER8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VcU3DCgMu30hWPOIPeA/z/nYa4Q591/7+y/8sjC/qMYjAfQx7Av0vKzJHC/XbTrKAw1bdBPON0iit3w18YtlLA/6K+uJdaXqqERJ/TYBkvVntZ5R+4BBhyCw2TtuDaGBAadlXraj6+HUw+/FvOtObq9JpQdTDI6la1BlmnA0Ex8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MKs8TXBY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f321ff8f88so19331765ad.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 08:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716994898; x=1717599698; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HQtJlnpqrvtnfXVrs6+SglvK2qN8IBEiDPjiKhznP1Y=;
        b=MKs8TXBY0GL18xLcER5NAXUbXY+YS4gR1i9mnGs3aSR0W44chG7/3zW6GSm9zLdcsA
         pC8jkqZtdW3k0OeVqRarWnr43vBYn/JaGKNF7+mdVK9P+N1ccV+jg1gO+/1+bVwm4eHX
         eAsoQrduBmv6DbGUz7LeNg+NGDFEeBlFqtwUPmUfS4ArVCPu4H7/5YBFUAZwbn7OP5id
         Tq8BxdV7lVIl4rO43diKRr1Z1op9rxgKw+ohDEUjvs2s/j103y0WW43MZ4sWfH1WvgYt
         1wsJl3d+vnO34GS6uo38rT5OVIiyUNNlonqbuytZ4H1nZIqYoX2D5wZPyRuVsGf0XkNs
         jNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716994898; x=1717599698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HQtJlnpqrvtnfXVrs6+SglvK2qN8IBEiDPjiKhznP1Y=;
        b=O8+9+fRVe6AI4QKTH82Z242YiYYWmUtUUPr6LgQQj17kOFsRFv4ZH6e+RGH0VT112K
         TPdeK3hQhrqAKAH92OmNt8j+kCcM0I7oU7CJA7BxXwIR5DSlcBs31xkAzGPdUvGyMjNr
         ydtblhyoS1ZSKjHDSEYIQ4St8R/9cdR5ycy5eCJJMKU6Xq7kc8UFXBAc5sPo5VOJgK/u
         Cy5q4e+1u//dMx1C3opVigQjp/7+fmNmdV0PpzgYkkAWO67foCzIA1N6SWmLzm+7yPsM
         REfOgPBqMwQeYP7Gl6dOAjB9ZjvyNq63OKAJnm+RPx/73fHuaIY2mWjblWp+CnwAIfMI
         l1ag==
X-Forwarded-Encrypted: i=1; AJvYcCX1Uckqdod2tkOkZtdTTVr02GNJsDLXj3yZxR9vrDuv3/c9UqACsfuMpv6WxFjb3b/ckoB4zbY1uyxrHL3hXe7WoHxa
X-Gm-Message-State: AOJu0YxcayZWnMt3YAV7pgqmN+xXr/rYfmuZs/hBfwGZ7f4BaQbsyab+
	8Ac9v7l6jrT//PdiAT9FAXJUe3rj2tSUvN1mPMrRfubFNHTTc09Em03/3X48yZcNz8VbqzPZ5CH
	6Dw==
X-Google-Smtp-Source: AGHT+IEMT36NJuMNXTiwX5T2AXx05oLa2ie6XyQhHrzYlcd5jIYTVYLwpA87G66gwlr2MfrRrowg1FQQBGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da8d:b0:1f3:4073:9b1a with SMTP id
 d9443c01a7336-1f4498f176dmr7159325ad.11.1716994898530; Wed, 29 May 2024
 08:01:38 -0700 (PDT)
Date: Wed, 29 May 2024 08:01:37 -0700
In-Reply-To: <e39b652c-ba0e-4c54-971e-8df9a2a5d0be@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522022827.1690416-1-seanjc@google.com> <20240522022827.1690416-4-seanjc@google.com>
 <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com> <Zk7Eu0WS0j6/mmZT@chao-email>
 <c4fa17ca-d361-4cb7-a897-9812571aa75f@intel.com> <Zk/9xMepBqAXEItK@chao-email>
 <e39b652c-ba0e-4c54-971e-8df9a2a5d0be@intel.com>
Message-ID: <ZldDUUf_47T7HsAr@google.com>
Subject: Re: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, May 28, 2024, Kai Huang wrote:
> On 24/05/2024 2:39 pm, Chao Gao wrote:
> > On Fri, May 24, 2024 at 11:11:37AM +1200, Huang, Kai wrote:
> > > 
> > > 
> > > On 23/05/2024 4:23 pm, Chao Gao wrote:
> > > > On Thu, May 23, 2024 at 10:27:53AM +1200, Huang, Kai wrote:
> > > > > 
> > > > > 
> > > > > On 22/05/2024 2:28 pm, Sean Christopherson wrote:
> > > > > > Add an off-by-default module param, enable_virt_at_load, to let userspace
> > > > > > force virtualization to be enabled in hardware when KVM is initialized,
> > > > > > i.e. just before /dev/kvm is exposed to userspace.  Enabling virtualization
> > > > > > during KVM initialization allows userspace to avoid the additional latency
> > > > > > when creating/destroying the first/last VM.  Now that KVM uses the cpuhp
> > > > > > framework to do per-CPU enabling, the latency could be non-trivial as the
> > > > > > cpuhup bringup/teardown is serialized across CPUs, e.g. the latency could
> > > > > > be problematic for use case that need to spin up VMs quickly.
> > > > > 
> > > > > How about we defer this until there's a real complain that this isn't
> > > > > acceptable?  To me it doesn't sound "latency of creating the first VM"
> > > > > matters a lot in the real CSP deployments.
> > > > 
> > > > I suspect kselftest and kvm-unit-tests will be impacted a lot because
> > > > hundreds of tests are run serially. And it looks clumsy to reload KVM
> > > > module to set enable_virt_at_load to make tests run faster. I think the
> > > > test slowdown is a more realistic problem than running an off-tree
> > > > hypervisor, so I vote to make enabling virtualization at load time the
> > > > default behavior and if we really want to support an off-tree hypervisor,
> > > > we can add a new module param to opt in enabling virtualization at runtime.

I definitely don't object to making it the default behavior, though I would do so
in a separate patch, e.g. in case enabling virtualization by default somehow
causes problems.

We could also add a Kconfig to control the default behavior, though IMO that'd be
overkill without an actual use case for having virtualization off by default.

> > > I am not following why off-tree hypervisor is ever related to this.
> > 
> > Enabling virtualization at runtime was added to support an off-tree hypervisor
> > (see the commit below).
> 
> Oh, ok.  I was thinking something else.
> 
> > > 
> > > The problem of enabling virt during module loading by default is it impacts
> > > all ARCHs.

Pratically speaking, Intel is the only vendor where enabling virtualization is
interesting enough for anyone to care.  On SVM and all other architectures,
enabling virtualization doesn't meaningfully change the functionality of the
current mode.

And impacting all architectures isn't a bad thing.  Yes, it requires getting buy-in
from more people, and maybe additional testing, though in this case we should get
that for "free" by virtue of being in linux-next.  But those are one-time costs,
and not particular high costs.

> > > Given this performance downgrade (if we care) can be resolved by
> > > explicitly doing on_each_cpu() below, I am not sure why we want to choose
> > > this radical approach.

Because it's not radical?  And manually doing on_each_cpu() requires complexity
that we would ideally avoid.

15+ years ago, when VMX and SVM were nascent technologies, there was likely a
good argument from a security perspective for leaving virtualization disabled.
E.g. the ucode flows were new _and_ massive, and thus a potentially juicy attack
surface.

But these days, AFAIK enabling virtualization is not considered to be a security
risk, nor are there performance or stability downsides.  E.g. it's not all that
different than the kernel enabling CR4.PKE even though it's entirely possible
userspace will never actually use protection keys.

> > IIUC, we plan to set up TDX module at KVM load time; we need to enable virt
> > at load time at least for TDX. Definitely, on_each_cpu() can solve the perf
> > concern. But a solution which can also satisfy TDX's need is better to me.
> > 
> 
> Doing on_each_cpu() explicitly can also meet TDX's purpose.  We just
> explicitly enable virtualization during module loading if we are going to
> enable TDX.  For all other cases, the behaivour remains the same, unless
> they want to change when to enable virtualization, e.g., when loading module
> by default.
> 
> For always, or by default enabling virtualization during module loading, we
> somehow discussed before:
> 
> https://lore.kernel.org/kvm/ZiKoqMk-wZKdiar9@google.com/
> 
> My true comment is introducing a module parameter, which is a userspace ABI,

Module params aren't strictly ABI, and even if they were, this would only be
problematic if we wanted to remove the module param *and* doing so was a breaking
change.  Enabling virtualization should be entirely transparent to userspace,
at least from a functional perspective; if changing how KVM enables virtualization
breaks userspace then we likely have bigger problems.

> to just fix some performance downgrade seems overkill when it can be
> mitigated by the kernel.

Performance is secondary for me, the primary motivation is simplifying the overall
KVM code base.  Yes, we _could_ use on_each_cpu() and enable virtualization
on-demand for TDX, but as above, it's extra complexity without any meaningful
benefit, at least AFAICT.

