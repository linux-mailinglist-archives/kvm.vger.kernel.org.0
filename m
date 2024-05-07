Return-Path: <kvm+bounces-16927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0628C8BEE7C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 23:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 842801F26292
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 21:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D68573163;
	Tue,  7 May 2024 21:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ttsqER34"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2551858AB8
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 21:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715115616; cv=none; b=adPYGGhM7OjPPkDvFiengjEiPzG/H2g3zArf7tZ2e9MSUntga1U5d1Kc2SoEMcCgkKyvmPO3SGoODmZpgFU2zX7atNSdQujTWVFDGdOr0RjfWoJ63RZ43r9JfY+atqNTTkZkVzu1y/0DT1bUeodcnlR91TXdz/Y071Pu6JhHV9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715115616; c=relaxed/simple;
	bh=KGaBxlKzHGddtI5cT3/iPp6MeXwNxT3uYaVqVaOo3wo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XNnCzGFwyTxQtlpXUUScBh5mGxUd90UiwFrLQKBY7E/j49U+g94v77L4J2okkRzGjmUzlrrb9ndgYq1scHsYz24pjVyWIf1Ilny2qlk1GNAk9wbygCdI/zRC4VI0IvZwRpFcS4PnP7xlaCd03TCx5aLvyVIF0oHJp7A8zFNjW8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ttsqER34; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61bb09d8fecso65457687b3.0
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 14:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715115614; x=1715720414; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gt0HQZF6AKIfqYkEueAoLR6ql6u8oX1eFDCyfBRdfyw=;
        b=ttsqER347XtN/ZjV87StpMgg2aEaU5QHpdBZuoSflbpKv7hpcR1L/FQ8YWu8ECMYfV
         aik4LcSgHZXQlA7YERfB9DpKjkSRWAUDoc2AIE3+pNTMrl7utHRgeJsmE+cGOEKxKaDz
         A7y9nuAfwDsC9ESPuNBkew9jrUyARqFRGu6zlKgCW2scr+RCoIlKI9ZDM/ANJWqyTjVq
         KIdEjnUQL05kiFdPLU9PdCDTsoBbaNRJJrTPL5y9SkB/phIeReLY3RtfJXe4aE5aGgMz
         f0ot2iJVgWo9VWAF9NpBFcIQs3TXijiaQjBs8VYmCevgf3gzwq02qVoP/wT5O9VYhuWe
         nlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715115614; x=1715720414;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gt0HQZF6AKIfqYkEueAoLR6ql6u8oX1eFDCyfBRdfyw=;
        b=waIm+WW3r/B4YBtORwBy7NEcRdglNVo7hZ0AZnMv1VpXJQd+HRx7jyOAw6eVgLspey
         ulunPMwlkc8WIfflMts0dh0ljmSL+6iHcoZGw7t5Xb2GbnRmvOvEhd7vDsZV9bgYNUit
         paofnvnMd/s2t7CqHdA61Vp1YxmDk0mAyFX2Wb94dt3pcMp8FrsTmCkv13fEjmOuvbeR
         Yr3x9nJYLTPaVvJ/kcLnzV8mlCgwSSIH4iWtRb1emW/Sx5kwKMCYS5R08258sZ8u5inF
         tBf5kWA7640JX/MlG/8Ju/PJdWBdnNj/qiXZ1oqqGIf9yNLKZSBEuwZsLQ0lHQZL6lb4
         Sxdg==
X-Forwarded-Encrypted: i=1; AJvYcCVt8nWvUIg0oMZKm1Ttp70aaGpEMVFfNo3epwUIPUrBwRaaJs7d6qGgiYVECbH/NB01POyd7JW+hcQx9NjidHZBUkIu
X-Gm-Message-State: AOJu0Yyx06lwlgz+HJcvXPBAbA6pk4w8hqL+H2k9QalIuJtX1OSFmxM9
	f6MyX6raTOfQBWJaxFvE8ra1xOQ0asXRfs+DbwTcMKHTS5aItJsq83mk+T+gsSTOesDHi8OVecj
	PyQ==
X-Google-Smtp-Source: AGHT+IGyXnV0t6LTC2+6Qm+s+jCXY/9iy23P8kf+tZ7wZU82m6+nn3Hh/XAbuULfL6Zy9qX11RYWuRk32vE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2b43:0:b0:de4:5eaa:4b67 with SMTP id
 3f1490d57ef6-debb9da3339mr78675276.11.1715115614194; Tue, 07 May 2024
 14:00:14 -0700 (PDT)
Date: Tue, 7 May 2024 14:00:12 -0700
In-Reply-To: <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240328171949.743211-1-leobras@redhat.com> <ZgsXRUTj40LmXVS4@google.com>
 <ZjUwHvyvkM3lj80Q@LeoBras> <ZjVXVc2e_V8NiMy3@google.com> <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
 <ZjprKm5jG3JYsgGB@google.com> <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop>
Message-ID: <ZjqWXPFuoYWWcxP3@google.com>
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
From: Sean Christopherson <seanjc@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Leonardo Bras <leobras@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang1211@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, May 07, 2024, Paul E. McKenney wrote:
> On Tue, May 07, 2024 at 10:55:54AM -0700, Sean Christopherson wrote:
> > On Fri, May 03, 2024, Paul E. McKenney wrote:
> > > On Fri, May 03, 2024 at 02:29:57PM -0700, Sean Christopherson wrote:
> > > > So if we're comfortable relying on the 1 second timeout to guard against a
> > > > misbehaving userspace, IMO we might as well fully rely on that guardrail.  I.e.
> > > > add a generic PF_xxx flag (or whatever flag location is most appropriate) to let
> > > > userspace communicate to the kernel that it's a real-time task that spends the
> > > > overwhelming majority of its time in userspace or guest context, i.e. should be
> > > > given extra leniency with respect to rcuc if the task happens to be interrupted
> > > > while it's in kernel context.
> > > 
> > > But if the task is executing in host kernel context for quite some time,
> > > then the host kernel's RCU really does need to take evasive action.
> > 
> > Agreed, but what I'm saying is that RCU already has the mechanism to do so in the
> > form of the 1 second timeout.
> 
> Plus RCU will force-enable that CPU's scheduler-clock tick after about
> ten milliseconds of that CPU not being in a quiescent state, with
> the time varying depending on the value of HZ and the number of CPUs.
> After about ten seconds (halfway to the RCU CPU stall warning), it will
> resched_cpu() that CPU every few milliseconds.
> 
> > And while KVM does not guarantee that it will immediately resume the guest after
> > servicing the IRQ, neither does the existing userspace logic.  E.g. I don't see
> > anything that would prevent the kernel from preempting the interrupt task.
> 
> Similarly, the hypervisor could preempt a guest OS's RCU read-side
> critical section or its preempt_disable() code.
> 
> Or am I missing your point?

I think you're missing my point?  I'm talking specifically about host RCU, what
is or isn't happening in the guest is completely out of scope.

My overarching point is that the existing @user check in rcu_pending() is optimistic,
in the sense that the CPU is _likely_ to quickly enter a quiescent state if @user
is true, but it's not 100% guaranteed.  And because it's not guaranteed, RCU has
the aforementioned guardrails.

And I'm arguing that, since the @user check isn't bombproof, there's no reason to
try to harden against every possible edge case in an equivalent @guest check,
because it's unnecessary for kernel safety, thanks to the guardrails.

