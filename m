Return-Path: <kvm+bounces-16902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F9DB8BEAE3
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 19:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF3BB281EA6
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECEF16C87C;
	Tue,  7 May 2024 17:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WGKgC/qL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA5A16C857
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 17:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715104558; cv=none; b=S1CzjpB1gxSVe7sirtgKa4H//6pymVVUzyoFAwy+grIfr12NTZjcoyjj3vpNd136Zy26zhvueOAy1er9DtRzpPdih9D2Ecww5IJALcGpRzUB5i/sRlfWQMpLNa6nUjCV8UZrb0DIoUpJ8wseHpmNQKqIytYzBpPSFM2TPE9IZE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715104558; c=relaxed/simple;
	bh=i1B0BczLSo3SWF7MKkmZ007UspXePFGAXjtEUDsAbtE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kMJ3yrVhElhjd7SAxsBi239phZ8Q+GYIgL31clJlk0DovMpS+p3I4QEYt6UvKXz8G/oNdqrGbNicFYgDpt5pZKSVWys4tbvLJE2/gT1thMq9poHoEKNdsGC0AAurSNiBdXbg7PKBcGEnyGMGnT4JGS9qhBfZ2AV9/MqegZ4x1YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WGKgC/qL; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-61cb5628620so3994419a12.3
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 10:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715104557; x=1715709357; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U/zdljaT58TeUovqBD+WPeAJgx4d8t4+C/lLtRXXISU=;
        b=WGKgC/qLLGDzqckkvrqP7f1LsoRyBJ91zHpkQ75EQG/sElibpIdyYY7zGP23rKsK7X
         YbR1/n4r2qJjORhPoCGFAC+WoMhQUStqt68dt0l8U0LwkDQGz3yHS4eWHGuqTGG2B72k
         NL4OhYBy0Imjefoo9mC7p/5hEIF2yzH8HWGmD6Fjfv4tcLpe5lwGlnera88zxYWyRUs6
         M1BS2OtHx23GDzJ1Z3/0kh9zRX3kaP+UD9rO4MycvZYvzPHeVJdTmwxIQcmXCsfWE+RC
         1yM39swBkFGQpZ0iorAU7aWCQR5TRwUbCetfw7VkWGNYP28f7Bklsu657QI+9vL1GLWy
         t4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715104557; x=1715709357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U/zdljaT58TeUovqBD+WPeAJgx4d8t4+C/lLtRXXISU=;
        b=A3CSgm5ZMKizFeMaXvDOmDNqPx14gluCeUiD7rzr+vIvKR2xa2mSIv4yuOa9U6SuAw
         /pOa5SG05Cr7EsyJxqBq0nMwZ+tX/s8WODkRq8yTbIENGSev/wHMqUOEQxvq4qAodr7s
         L6Gk613XXHNlUPpcDw21IjA1J1N067NJN6k6/JZdvPGh2r7K4Y7CpdXckQJxBAVdSMKH
         zvDBGGpYu0LfRqwATZx/llkLPtcDzFwSRfJ9JAV3XW0zUSzqlWxNo00muWOVK+ApQEVu
         kowk/c7626OLdMn9P/tNa0oKuJbg7YgfxzLl0hrcWUo2fDH0mFMiuIQNYeEZHtT3sTOF
         dL5A==
X-Forwarded-Encrypted: i=1; AJvYcCUFO1UJk6NKBJga3KuG0+2GXPMzE6bAbQYHErC4qCyjP/1NiH0xSatZuBNq5FD/mTyjhdHJde7SfeHSf2dHWLhHypC+
X-Gm-Message-State: AOJu0YwtEK5I4wsAaXWdaqONzOn3fdIXw3wHOZ/6BpJCfy0k1n0UGtSz
	cvhhOQ+No2hcRy0WueuMtqdac7DsRcag9USRHb/MjUgOGdqtbwbWaj09voA4cwaeX1wWKUZDzCU
	JhQ==
X-Google-Smtp-Source: AGHT+IFeM0B7my9SeMqYR5n+RtBG5AhiHXPGjV0Tz0oCPILMUffxAWA/E9oddAskv4XRf7h+1SVeBgTe8hc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3ecb:0:b0:5f7:fca4:6d2f with SMTP id
 41be03b00d2f7-62f24b1978bmr1264a12.7.1715104556721; Tue, 07 May 2024 10:55:56
 -0700 (PDT)
Date: Tue, 7 May 2024 10:55:54 -0700
In-Reply-To: <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240328171949.743211-1-leobras@redhat.com> <ZgsXRUTj40LmXVS4@google.com>
 <ZjUwHvyvkM3lj80Q@LeoBras> <ZjVXVc2e_V8NiMy3@google.com> <3b2c222b-9ef7-43e2-8ab3-653a5ee824d4@paulmck-laptop>
Message-ID: <ZjprKm5jG3JYsgGB@google.com>
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

On Fri, May 03, 2024, Paul E. McKenney wrote:
> On Fri, May 03, 2024 at 02:29:57PM -0700, Sean Christopherson wrote:
> > So if we're comfortable relying on the 1 second timeout to guard against a
> > misbehaving userspace, IMO we might as well fully rely on that guardrail.  I.e.
> > add a generic PF_xxx flag (or whatever flag location is most appropriate) to let
> > userspace communicate to the kernel that it's a real-time task that spends the
> > overwhelming majority of its time in userspace or guest context, i.e. should be
> > given extra leniency with respect to rcuc if the task happens to be interrupted
> > while it's in kernel context.
> 
> But if the task is executing in host kernel context for quite some time,
> then the host kernel's RCU really does need to take evasive action.

Agreed, but what I'm saying is that RCU already has the mechanism to do so in the
form of the 1 second timeout.

And while KVM does not guarantee that it will immediately resume the guest after
servicing the IRQ, neither does the existing userspace logic.  E.g. I don't see
anything that would prevent the kernel from preempting the interrupt task.

> On the other hand, if that task is executing in guest context (either
> kernel or userspace), then the host kernel's RCU can immediately report
> that task's quiescent state.
> 
> Too much to ask for the host kernel's RCU to be able to sense the
> difference?  ;-)

KVM already notifies RCU when its entering/exiting an extended quiescent state,
via __ct_user_{enter,exit}().

When handling an IRQ that _probably_ triggered an exit from the guest, the CPU
has already exited the quiescent state.  And AFAIK, that can't be safely changed,
i.e. KVM must note the context switch before enabling IRQs.

