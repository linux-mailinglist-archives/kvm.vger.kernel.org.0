Return-Path: <kvm+bounces-13294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 189798945EC
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 22:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAD5C282EC9
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 20:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C074253E1E;
	Mon,  1 Apr 2024 20:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xq+anBcx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738042E410
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 20:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712002889; cv=none; b=MjO6YnqeZfvzv3zcGau1JU5MG4h1l+OAzRoEThHhoqhNxyurvGeaiizpjyme0hYDPza88yllzSw0LWemcXmx3Qpf+3O80ST94p1ydls9ai0JXwo43lNCUrIRoI7a4lW31STTYsBDVeBKRCzaKWMtfT0Co7U/gjOXuLh9SJC/BA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712002889; c=relaxed/simple;
	bh=xi8fNfb+f7ixAYxOIg8qOE321OOUGkU+4oppUXoLRsU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WhfB65KVSLZgayJaXSOMHGWJRYqZpJ2C1Sii4nHJukISvQUoNobRkQYdGUYg08PeeXPIpVaJ1k4zBIdaLNXGDQLOEbL9GIMDLrSNZ7oZLWqrGps/qIVCACU9MXPLATxJ3jMzeV2QOVyvMwI8zPNWF6T9bwhRLz+RqoxQ8dfnwd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xq+anBcx; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc58cddb50so7577060276.0
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 13:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712002886; x=1712607686; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EXuQrJxq8hh4Q4PrrL+1pUvmc/UlgSCH8mpU+iMNc/A=;
        b=xq+anBcx66qyZQercVDaUpKLfhNQcMjDe9r/pF6FsIdAtQkudxq3maBQbSZorqZvmT
         jKmG6Gdmtt0FGbFKmwiFqEc+TR7OcM484R2qtboyVX7xZ14iGnj1BB5wbRYnY6VVgxQF
         6h1nBWVlrdqyMoijeIzIHwz5SvKaUSdg+bxs63BQqb7FqrpGcOwi1lXNVJzhqewhZLOs
         w+ZyPSap7dXcSfBUopbT0wRr4yonEEQqtj/P6YUgAmZ9daRhXLEbM7+nF5qo8NYLRZmN
         tPD4/sX4OHNKtHdz+l+mxNULNvUS2+HqqbJTy6lFUn+fFmbGPFKsqitnMosApJFCfHxf
         nHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712002886; x=1712607686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EXuQrJxq8hh4Q4PrrL+1pUvmc/UlgSCH8mpU+iMNc/A=;
        b=v2azzYEsGgWnMUPWkzJ0TzKLPdr1CHs5hkXYls9/vYiVR6/AqmVbkoDyAUQY8edbfe
         8ecGU93W9k5GcKpUKl9MN/Tqh1KR2E+9y/63NQC7tQdezXyDzJABVJdySHFnf/1rVKlK
         f5WYmTXQPWolv4Xu2h9wF/hJQHYplNxQld6KG/xXydNlrSIE3TeceAhzuXSL2SNAj4eW
         ukFlFgvlEvH2K+FXs9LSCyn0lCopZ9EDDf426VWBnkUlMoCqNQjNSZzR5IbKa53RckVb
         Giy93PoK+/OacibAboU4i/vv50y8imLZkqSje1RRZbbfP/IHC4R5CZp9dwvrCHShLfDv
         MeKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUG/7WCrLfUZ5XMiO94R+MLw+9R+ykjO+gz4ueSf268Qt2Vd1AKr4KFSm7Mcgd5v5Fpi0ZVGiLv/KLOkTgHtubsF+oS
X-Gm-Message-State: AOJu0YzhmMavMWEhZxB9x+HeKPoWEcgMAHuidUpdzmgMtvyLId4BjPnn
	Oq4ifCncd4qnYxOSMJnpNx8lvdWR+xu+b7m5GZ27bp7tzq+/HAAFVho1L+hOBifOs9RqdYMKBDq
	ZWQ==
X-Google-Smtp-Source: AGHT+IF9bN9rMKRDiKGIJtYfo638VzxlHSURX9J2Qs9hT7nu5H17e7f7Ql/BLpIFbwZluzOjprKPqs6RiH8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1002:b0:dc9:5ef8:2b2d with SMTP id
 w2-20020a056902100200b00dc95ef82b2dmr3291799ybt.4.1712002886627; Mon, 01 Apr
 2024 13:21:26 -0700 (PDT)
Date: Mon, 1 Apr 2024 13:21:25 -0700
In-Reply-To: <20240328171949.743211-1-leobras@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240328171949.743211-1-leobras@redhat.com>
Message-ID: <ZgsXRUTj40LmXVS4@google.com>
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
From: Sean Christopherson <seanjc@google.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang1211@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 28, 2024, Leonardo Bras wrote:
> I am dealing with a latency issue inside a KVM guest, which is caused by
> a sched_switch to rcuc[1].
> 
> During guest entry, kernel code will signal to RCU that current CPU was on
> a quiescent state, making sure no other CPU is waiting for this one.
> 
> If a vcpu just stopped running (guest_exit), and a syncronize_rcu() was
> issued somewhere since guest entry, there is a chance a timer interrupt
> will happen in that CPU, which will cause rcu_sched_clock_irq() to run.
> 
> rcu_sched_clock_irq() will check rcu_pending() which will return true,
> and cause invoke_rcu_core() to be called, which will (in current config)
> cause rcuc/N to be scheduled into the current cpu.
> 
> On rcu_pending(), I noticed we can avoid returning true (and thus invoking
> rcu_core()) if the current cpu is nohz_full, and the cpu came from either
> idle or userspace, since both are considered quiescent states.
> 
> Since this is also true to guest context, my idea to solve this latency
> issue by avoiding rcu_core() invocation if it was running a guest vcpu.
> 
> On the other hand, I could not find a way of reliably saying the current
> cpu was running a guest vcpu, so patch #1 implements a per-cpu variable
> for keeping the time (jiffies) of the last guest exit.
> 
> In patch #2 I compare current time to that time, and if less than a second
> has past, we just skip rcu_core() invocation, since there is a high chance
> it will just go back to the guest in a moment.

What's the downside if there's a false positive?

> What I know it's weird with this patch:
> 1 - Not sure if this is the best way of finding out if the cpu was
>     running a guest recently.
> 
> 2 - This per-cpu variable needs to get set at each guest_exit(), so it's
>     overhead, even though it's supposed to be in local cache. If that's
>     an issue, I would suggest having this part compiled out on 
>     !CONFIG_NO_HZ_FULL, but further checking each cpu for being nohz_full
>     enabled seems more expensive than just setting this out.

A per-CPU write isn't problematic, but I suspect reading jiffies will be quite
imprecise, e.g. it'll be a full tick "behind" on many exits.

> 3 - It checks if the guest exit happened over than 1 second ago. This 1
>     second value was copied from rcu_nohz_full_cpu() which checks if the
>     grace period started over than a second ago. If this value is bad,
>     I have no issue changing it.

IMO, checking if a CPU "recently" ran a KVM vCPU is a suboptimal heuristic regardless
of what magic time threshold is used.  IIUC, what you want is a way to detect if
a CPU is likely to _run_ a KVM vCPU in the near future.  KVM can provide that
information with much better precision, e.g. KVM knows when when it's in the core
vCPU run loop.

> 4 - Even though I could detect no issue, I included linux/kvm_host.h into 
>     rcu/tree_plugin.h, which is the first time it's getting included
>     outside of kvm or arch code, and can be weird.

Heh, kvm_host.h isn't included outside of KVM because several architectures can
build KVM as a module, which means referencing global KVM varibles from the kernel
proper won't work.

>     An alternative would be to create a new header for providing data for
>     non-kvm code.

I doubt a new .h or .c file is needed just for this, there's gotta be a decent
landing spot for a one-off variable.  E.g. I wouldn't be at all surprised if there
is additional usefulness in knowing if a CPU is in KVM's core run loop and thus
likely to do a VM-Enter in the near future, at which point you could probably make
a good argument for adding a flag in "struct context_tracking".  Even without a
separate use case, there's a good argument for adding that info to context_tracking.

