Return-Path: <kvm+bounces-17815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C118CA55D
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 02:21:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35A181F222E5
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 00:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3874BA55;
	Tue, 21 May 2024 00:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NYhTmonl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B598BEF
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 00:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716250897; cv=none; b=ZyXR2niLaIzWg0+BID7ucbWvvkm8nolQSNAlBO7qPveA2TVDwKZZx9fm1BajTYF9y92vCHgRDi5RdwK3/nJ4HXD0Bp78lKHCjfNy6qL736RLpDNFf0Y2aafVma3EltS9zdwsSr+wtZOU3t2RhfvsukdSGo9SKO/Ffwlsc6Sm0zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716250897; c=relaxed/simple;
	bh=7FgnFOkdDgFgsLvHLPfWZW/CX/nmh1MR9HxCA63N6To=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fi//usXKvPGsQuk1GJSSSRDNsxlB7QRiE1qd4YHd9gImfrxRpMSTFsafuTvb9CMWfTFuPxBRu3+0AGP4g0jJl3Ab7FOGEkwO+AnTD6/QiGYE+cS6auK7n6reB1tcYuI46yJMH8744hg1uGwhe7rKCoiGc1aynxfiz+qizhlNnhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NYhTmonl; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ec5efb0a33so137945975ad.3
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716250896; x=1716855696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vCsUNW09v7zKL9dHQIPxnsYeWbnXda/uqjR3962X8Sw=;
        b=NYhTmonlgKmICgZSj7JdhyP6TbV1kx3IyOJpx+S9FjCKlM9PXgHNmB8KWyGQMDQnZO
         1HJiVYrIdDQh/WYBrreOYqQ+jPveDskSLRZnBcLUQFRXKUu9Ylaq/OEVMnIMZ3enHYCz
         lV3HPRkxFU/8LTj6OoZcPJzcpMzLXjEx2WXXm8cMfFsKpCM8Z8Y3774m8dbUXbuiPI8D
         y2u1JpK/T4BhN/HW5n/Vy/cMFspWnZthr4SvBPgp5uaHlBqS9vE/ud9sA3GZRAm21QLn
         gKLcwOUtHFs6n6WpJiW7OVtCTznGbDViOte9kZ44HPAnRos7BC3W8EwmLSPq2wCyD4sw
         XVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716250896; x=1716855696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCsUNW09v7zKL9dHQIPxnsYeWbnXda/uqjR3962X8Sw=;
        b=FI7lHxsuaTvnuQcjRLm0XHv8C3f0olhtellB9rMW+cUtuLhB/zR4OdXVRyQfE23bmR
         UvzdhlFc96kMRGgXG3GrUCdTDryMY2Tfx7Mcl9rSDljr0qPwikYVj1pKj23/PCbkWiv0
         D/MmOtbzzjMHI+nJwb5Ke7CGRdgWnOTHkiKKaSRW6bQO5zBUoeWTJtpVKw8prp3lqNYb
         AB4cF9x1J4wGp6DAi98EB7gn2lHUVq9Mmsc/9Y7gv2V/d62E/Kzkb2ew7j3vq42oNNTC
         3wanfNFeerlZ0H7cDm+w39mobnlru9ULgFw5sMobKOEAOzwzwr+R3ldDPRtghooVUhH1
         ZBhw==
X-Forwarded-Encrypted: i=1; AJvYcCUKbth+8TlrNfVNhyRk+a6Df8tOVHzZynyTHEr1L8U0iJZ3mXz7+LCUf9n9KtC8OOINVu8G8cpqSyd7dzuYkFFcIjUG
X-Gm-Message-State: AOJu0YzMAKrDCF4BKmIrgL1Gg88W8EiXCcfSUD11g+gEfyIDQwMVRrfb
	7mnsDWGIeGxDzsbNLCF40FedgrHfjdaSYPOHMm8gUGj0XvcKfIxn315t50fOxyo7licddx+6wfR
	C5Q==
X-Google-Smtp-Source: AGHT+IFxzN3S5GWGI/l51QGeOMjMRUVaTWeDpDg6DeGTkRhJYNGCzw8IB3pNF5rRVMRY1KKkob34Qk2rbm0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c40d:b0:1eb:4c47:3457 with SMTP id
 d9443c01a7336-1ef43c0ffeemr27830225ad.1.1716250895850; Mon, 20 May 2024
 17:21:35 -0700 (PDT)
Date: Mon, 20 May 2024 17:21:34 -0700
In-Reply-To: <b1def408-f6e8-4ab5-ac7a-52f11f490337@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com> <20240518000430.1118488-3-seanjc@google.com>
 <78b3a0ef-54dc-4f49-863e-fe8288a980a7@intel.com> <ZkvbUNGEZwUHgHV9@google.com>
 <b1def408-f6e8-4ab5-ac7a-52f11f490337@intel.com>
Message-ID: <ZkvpDkOTW8SwrO5g@google.com>
Subject: Re: [PATCH 2/9] KVM: nVMX: Initialize #VE info page for vmcs02 when
 proving #VE support
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, May 21, 2024, Kai Huang wrote:
> On 21/05/2024 11:22 am, Sean Christopherson wrote:
> > On Tue, May 21, 2024, Kai Huang wrote:
> > > On 18/05/2024 12:04 pm, Sean Christopherson wrote:
> > > > Point vmcs02.VE_INFORMATION_ADDRESS at the vCPU's #VE info page when
> > > > initializing vmcs02, otherwise KVM will run L2 with EPT Violation #VE
> > > > enabled and a VE info address pointing at pfn 0.
> > > 
> > > How about we just clear EPT_VIOLATION_VE bit in 2nd_exec_control
> > > unconditionally for vmcs02?
> > 
> > Because then KVM wouldn't get any EPT Violation #VE coverage for L2, and as
> > evidence by the KVM-Unit-Test failure, running L2 with EPT Violation #VEs enabled
> > provides unique coverage.  Doing so definitely provides coverage beyond what is
> > strictly needed for TDX, but it's just as easy to set the VE info page in vmcs02
> > as it is so clear EPT_VIOLATION_VE, so why not.
> > 
> > > Your next patch says:
> > > 
> > > "
> > > Always handle #VEs, e.g. due to prove EPT Violation #VE failures, in L0,
> > > as KVM does not expose any #VE capabilities to L1, i.e. any and all #VEs
> > > are KVM's responsibility.
> > > "
> > 
> > I don't see how that's relevant to whether or not KVM enables EPT Violation #VEs
> > while L2 is running.  That patch simply routes all #VEs to L0, it doesn't affect
> > whether or not it's safe to enable EPT Violation #VEs for L2.
> 
> My logic is, if #VE exit cannot possibly happen for L2, then we don't need
> to deal whether to route #VE exits to L1. :-)
> 
> Well, actually I think conceptually, it kinda makes sense to route #VE exits
> to L1:
> 
> L1 should never enable #VE related bits so L1 is certainly not expecting to

Not "should never", "can never".  If L1 attempts to enable EPT_VIOLATION_VE, then
VM-Enter will VM-Fail.

> see #VE from L2.  But how to act should be depending on L1's logic? E.g., it
> can choose to ignore, or just kill the L2 etc?

No.  Architecturally, from L1's perspective, a #VE VM-Exit _cannot_ occur in L2.
L1 can inject a #VE into L2, but a #VE cannot be generated by the CPU and thus
cannot cause a VM-Exit.

> Unconditionally disable #VE in vmcs02 can avoid such issue because it's just
> not possible for L2 to have the #VE exit.

Sure, but by that argument we could just avoid all nested VMX issues by never
enabling anything for L2.

If there's an argument to be made for disabling EPT_VIOLATION_VE in vmcs02, it's
that the potential maintenance cost of keeping nEPT, nVMX, and the shadow MMU
healthy outweighs the benefits.  I.e. we don't have a use case for enabling
EPT_VIOLATION_VE while L2 is running, so why validate it?

If whatever bug the KUT EPT found ends up being a KVM bug that specifically only
affects nVMX, then it'd be worth revisiting whether or not it's worth enabling
EPT_VIOLATION_VE in vmcs02.  But that's a rather big "if" at this point.

