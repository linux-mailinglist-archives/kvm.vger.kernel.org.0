Return-Path: <kvm+bounces-42411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E5DBA78384
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D87816B732
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C197221579;
	Tue,  1 Apr 2025 20:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qGfT9SO9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAAA21E0BC
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540423; cv=none; b=R+fJOUh/Dkt5O0jtd+K37wgMVtN5oeu6ulcH8IkNKgYcs0dnb32SLq1EgpNKLX1YuxeruJ6THstB+dKPCqHFQ9SxUka7wx+fjGj1LJMzBYNJEjmvoJBHafQvHS0TRV52Usc4Ohn1z6tRBbFUmswSW/XS7VEgD9u8WYfX2986zzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540423; c=relaxed/simple;
	bh=V7OL3Q/3J2xWKwnmIlSC3LoKokZ3iR0JrDzpSaKTdhE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DSMWFzpGEMIoIurUgdQoG85KnqSt1HVYxID2LfoiVCZSJyTIzvw4/a2PKAnwYSzBG4/zo/PeuYisoqAYVOp9LLqKXn7k+Zi/K8iTMehkbWzo6iaaPKVX3u0hET1cCxY9Q3kF65fqdfJNtE4xqoinsnwUd7ljc+dyU7XAVZ8SRm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qGfT9SO9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff7f9a0b9bso9451852a91.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540421; x=1744145221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hAOHDZe9hVA1LcrHBl8ILklpk5SqTyz1Lg9oNtA6EC8=;
        b=qGfT9SO9RBnPGlw4gIUZCxTZpC07aSiJWDJT4WjMDM64dl+zIYdeV56USeA7rEij6v
         pmvTivzaioWglX5Vs3GwKiUlfDH1IXnBkXC7vnHnneaNalAvoQmLUbIp4csryWG5+tjZ
         UnnzWVhOhc7M2qdv085XnlWkZx7MLmjBFcysL4azU42Z0yG+v2TLZk5SlEGN2YYDTlPC
         VXDsSxQcaybJyld7Uf+9I2BShpImty6NaOEK3NUmZUn46zt945XknHRLxA1IcnXvVjKZ
         Ub5Q5a8oGGe3+nEJlEJ2GQl9AB2mGMxwUNJBsDKv1wH0aOFzMgQte1afncVlcelu8hpd
         8gvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540421; x=1744145221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hAOHDZe9hVA1LcrHBl8ILklpk5SqTyz1Lg9oNtA6EC8=;
        b=cCLmbA4UHMsuFDWs4mUo1xh7tQr0sXpzkqIRtjv0y//H+qmS3FMLJKJslABRkP+byw
         M9/vq+lffnCKy14XUjO32n8iHt5fydisHiQXmHHtFgoA4CvbWJ5D6SxdtSfhgEKdKtnx
         gDSncYHfcWl1w/8nj7EleIjvnuZYHz8kjCFUQ9Yd2HLcnK42T3Lya8Y1So5I/MdUyUG+
         9Hs3eFO2kvri2afX5FWnfKxyejQ02gfzt3F901gw6Y7/JOxWqkBMV4hG0jK0EORHgWEq
         KfrNBixAkzee0eGWEuCQoghrUaa+kCinqc5j2AZjbwGhi1VLA1hDn2FSGPildoP7/V5/
         SPmw==
X-Gm-Message-State: AOJu0YzovfeWj9ucOr9CoF7PUlKXfZRxayrRvVDHFSeoLIlb/KS1w6rw
	Yk6cTJehJNAcMkuQXSGjaJKJLmjao6kNGx4QZcgb1+r+CPFtb/kvFbYhL/Bgppaqlqr26NR91iM
	YRQ==
X-Google-Smtp-Source: AGHT+IHU4ej+9xtm5sDkWeeRPmRGXEXSjICfBn2mdGglMLGC+glAIOtURcbT/pNs0Pm5Q7kEH8DQAnKQF70=
X-Received: from pjbqb11.prod.google.com ([2002:a17:90b:280b:b0:2fe:d556:ec6e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1344:b0:2ff:6788:cc67
 with SMTP id 98e67ed59e1d1-3056096950cmr5544504a91.34.1743540421162; Tue, 01
 Apr 2025 13:47:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:20 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-9-seanjc@google.com>
Subject: [PATCH 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Drop the setting of WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() to
differentiate it from add_wait_queue_priority_exclusive().  The one and
only user add_wait_queue_priority(), Xen privcmd's irqfd_wakeup(),
unconditionally returns '0', i.e. doesn't actually operate in exclusive
mode.

Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 kernel/sched/wait.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 80d90d1dc24d..2af0fc92e5d3 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -40,7 +40,7 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
 {
 	unsigned long flags;
 
-	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
+	wq_entry->flags |= WQ_FLAG_PRIORITY;
 	spin_lock_irqsave(&wq_head->lock, flags);
 	__add_wait_queue(wq_head, wq_entry);
 	spin_unlock_irqrestore(&wq_head->lock, flags);
@@ -84,7 +84,7 @@ EXPORT_SYMBOL(remove_wait_queue);
  * the non-exclusive tasks. Normally, exclusive tasks will be at the end of
  * the list and any non-exclusive tasks will be woken first. A priority task
  * may be at the head of the list, and can consume the event without any other
- * tasks being woken.
+ * tasks being woken if it's also an exclusive task.
  *
  * There are circumstances in which we can try to wake a task which has already
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
-- 
2.49.0.504.g3bcea36a83-goog


