Return-Path: <kvm+bounces-59181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D9EBAE0ED
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 225B63AF0BA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEDF246BB0;
	Tue, 30 Sep 2025 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mLrl8Gbx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4EC3C465
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 16:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250065; cv=none; b=B1bEg9btlTX6Qv2LbgcaAH5PkQ0H+OoRT5zSjbEgYEPhdjMnsRy4AD47F7GWGn/DxbWf6BfhKujdIuZrXMwzgtJw+QbAECf89qgA9MdGBd3xNBTodMs4GUrNuh4HtPV/msnj5t7iuAnfDS1j6QWb/rWEKcam0mqoQzc2G7X48Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250065; c=relaxed/simple;
	bh=TzPIt5QqZ/ncsUjXjePi75S8DUEZ/jVmGu8XXDEiJAM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VGSbKkQZ8MJFM8KZAjLWOtX4L8EtYcjp+2U7yQ7I+bWfmnK6cBAM10uvRI1gwdSqhluTEH6lJ9S1DQa+hUwI8GJLSm7Kdv45nm4hmeiQGigWC2t0seBajLAMlxf4+ORSPOZYXG4VHg+e4hkAi1pva0exh0W2E3ijB4SIxmocPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mLrl8Gbx; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b59682541d5so6131887a12.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759250064; x=1759854864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ts11PRKQJbECWFlSkrZaC2Cq1Up8eQN07d9pIiZQ+5k=;
        b=mLrl8Gbx8P/xaEvvVhl9dZlhF0gROHdf67ZZwcZEczk1C61fTGzTaUf/0wZhsfPX4t
         TJINk2ZRMiQlwCJB4eoxbFCngN/WnW9KpGTwOiP4KbDFeZRg5hq9Yfs5dfyAk03av6l1
         u+R+cHNU+XF9g4VXntrYdu8E8/APH7DGb/tBO1uNXuCGiPoQvr27faNZKIkF1nCnItpg
         t3WAwREU3P9IqJ+VC0W4SexOc/YT8CziDSU6+ByBFufw/0NnLSq52m8yz9GmUPTB76Of
         hw3dsqu/bXSQVlj7FHcCuIStm8cVa7LfVBLQjV7ZEjDW+8H303TxTQpPizU1UODDRDIf
         T/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759250064; x=1759854864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ts11PRKQJbECWFlSkrZaC2Cq1Up8eQN07d9pIiZQ+5k=;
        b=OVyB8ERLlQFazgMDd0cCyOe4pAVSXSKUc+EB2uRTZY9bzixO4fmvkzQKsQ6fBy+m7d
         PMjAS90o4VyfxsxNGBMRD2rX+itNHkvG3DM9BP8Qsozzn4B/atM+h/sTTB/Cf5cLS4eR
         1H8L3Bq1VFoGrvt5SSOS3osRI5n2SbyPPko/0Gqj6nXGhExMphAmTP74wzhkRzdcAFwE
         /7hMxBcu7GCrLdEfuy3tF9wegkr/vGoiSrl9RCUCDINybRLgeRPSho6llH9aPLldpmdN
         pMdZ+WGF0SgNon48nTY+Mn9IU/AFpklXFkWp841wiizv7pZVFJs5OtNEBa9Yi7m+56W5
         Ghpw==
X-Forwarded-Encrypted: i=1; AJvYcCV6lnBKEKeISg06edc8BMoTTXoXcgslbk/9XWCxq9CTaPvYJ+jaSrMSMmDVCYACVkPwex8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTzrdHUQCZOftE+3JIfyBD+MMUiyuaOmCsFOt/OyTuxicf0UlP
	L+eVXWjnXvo6JlzlP3tPkGIY4nGFRPBJYci4dffILJ2/OmaAhFlcJ1yb16D48adjPx5jF8zGtwe
	BemMr8A==
X-Google-Smtp-Source: AGHT+IFX4CBMrBfFxnkGRFgOYRHXTZmNWaYLzdc89aJiDnP/g8eaLWlThAkjYKzlvZmnAhY1DXZxav01xFw=
X-Received: from pjzg20.prod.google.com ([2002:a17:90a:e594:b0:339:9a75:1b1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38cb:b0:338:3dca:e0a3
 with SMTP id 98e67ed59e1d1-339a6ec7e16mr119884a91.16.1759250061911; Tue, 30
 Sep 2025 09:34:21 -0700 (PDT)
Date: Tue, 30 Sep 2025 09:34:20 -0700
In-Reply-To: <aNwFTLM3yt6AGAzd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919214259.1584273-1-seanjc@google.com> <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com> <aNwFTLM3yt6AGAzd@google.com>
Message-ID: <aNwGjIoNRGZL3_Qr@google.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 30, 2025, Sean Christopherson wrote:
> On Tue, Sep 30, 2025, Yan Zhao wrote:
> > On Tue, Sep 30, 2025 at 08:22:41PM +0800, Yan Zhao wrote:
> > > On Fri, Sep 19, 2025 at 02:42:59PM -0700, Sean Christopherson wrote:
> > > > Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
> > > > and use the helper kvm_set_user_return_msr() to make it obvious that the
> > > > double-underscores version is doing a subset of the work of the "full"
> > > > setter.
> > > > 
> > > > While the function does indeed update a cache, the nomenclature becomes
> > > > slightly misleading when adding a getter[1], as the current value isn't
> > > > _just_ the cached value, it's also the value that's currently loaded in
> > > > hardware.
> > > Nit:
> > > 
> > > For TDX, "it's also the value that's currently loaded in hardware" is not true.
> > since tdx module invokes wrmsr()s before each exit to VMM, while KVM only
> > invokes __kvm_set_user_return_msr() in tdx_vcpu_put().
> 
> No?  kvm_user_return_msr_update_cache() is passed the value that's currently
> loaded in hardware, by way of the TDX-Module zeroing some MSRs on TD-Exit.
> 
> Ah, I suspect you're calling out that the cache can be stale.  Maybe this?
> 
>   While the function does indeed update a cache, the nomenclature becomes
>   slightly misleading when adding a getter[1], as the current value isn't
>   _just_ the cached value, it's also the value that's currently loaded in
>   hardware (ignoring that the cache holds stale data until the vCPU is put,
>   i.e. until KVM prepares to switch back to the host).
> 
> Actually, that's a bug waiting to happen when the getter comes along.  Rather
> than document the potential pitfall, what about adding a prep patch to mimize
> the window?  Then _this_ patch shouldn't need the caveat about the cache being
> stale.

Ha!  It's technically a bug fix.  Because a forced shutdown will invoke
kvm_shutdown() without waiting for tasks to exit, and so the on_each_cpu() calls
to kvm_disable_virtualization_cpu() can call kvm_on_user_return() and thus
consume a stale values->curr.

