Return-Path: <kvm+bounces-42409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F153A7837E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA3E87A3952
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A0A21E0AD;
	Tue,  1 Apr 2025 20:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DyouEwtd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85A921C160
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540420; cv=none; b=TnukqSovK2kIcfkgzgnUZegndKS25wc86OtY17lHnab4JJ+sCcW70t8qtrSIctjUQY0EpHQpZ+Ci9KUhBgGJofwFafPTl3hQjskyXWmtUpWotuJ7bSeIIKU9aV675b/av7DYQMPUNx9CLwhR3kpn5remvH6cKGXfVD7v0FpqZrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540420; c=relaxed/simple;
	bh=9Y4jQuNr81blf0kL+x4SZ577lsTpKSVZZgUjgP8+H94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E1IILmiQxPhyWep/icPUkMch8kESeMW0CG9YBRybMkpdpxW8RY93RsfNadJxN0okyFIt6uH/weXord9wK6sswTwlottt0DEeztvPAemFWoCkwKHdhAdUVSbS3Ypi391FOWPE7zY/haRqwLfwjp9zSGX6p4HBaBFY2udtUvqQp1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DyouEwtd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff854a2541so9883608a91.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540418; x=1744145218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XAZ6HcZyPVHZNs/NiQeU2YPtsx7wIdUpIqdNXxdK3gA=;
        b=DyouEwtdq9yHvK0FwVUiAsw9Dozv6SbcJPwqoqEuYa1kyrPC5COKuksUahOSqDZM7N
         wm2c6flS7j8aczykkShGZSGuR/Bea3iEqkd54eQnJQQP0uQ1tXuRZGViFsrrUJ1pdQI8
         d4rYi4e5YbiRBLEdlL4nZ0hiGLfKwQ9tZqVleXm66N7rLnSMXFDhJ75vRHIp4SNSFx02
         Xgk3GwQ6VmF/YsBJ7vf1zG7prF1MT7wweHeg5ic9+bJvUjgE3lbD+6ME+bEohWKHufKe
         ennvaLaPtuSgfuM785vTewTt9qwneaKZwIbvo6djhNCWYVNIHHsx2HTvFun0IHfPwTcY
         5iCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540418; x=1744145218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XAZ6HcZyPVHZNs/NiQeU2YPtsx7wIdUpIqdNXxdK3gA=;
        b=VpbrTpPSnsfaDwdrPaKWKJfZSXgYAgmaNDn8gtG6Di5LPASD5UzhC2VBhhJtVF+jkF
         8JovdufArXuQSu32C7dldKxHaud0s+FHFIBdUuc4M1vBaARDjAT89OIWc6XwJLOSgeNs
         7lr0jqeJFGDxdxHpR9FnpOVfACMSyGiO0Rr4vdKLn0W4BXMCgyzvyKPOmhYyOE1nM9Kj
         ga/AUVdRtX6z0cXMqBjwS6U15uyro4eG4s22cGxgArYWsOTULewUksK1uDScGFRrbabD
         jZt3glLJFhEWRYCkg5+6bpqBOTMFtnrWOogJKq81oVNFEIB5mAE7GnZOp4Ch+uCv0iPA
         ugSQ==
X-Gm-Message-State: AOJu0YyFh6bOjeJuXPuJJSeNaWJpml0b1RRNSzVcR6J9UVxyIHZX79I5
	e9bpdA7atfosEO+KjtN4ZNbsHglaXlyP8qVPTes/++BCiRPz+b92EBFX59e7dh5WJWri36tdDQz
	2UQ==
X-Google-Smtp-Source: AGHT+IFdQSCduwNTHLV/nec9/i/BvW+thtXD97niBCIJ/k+4mEqw+xFFVLw5YdqLnoDpAq+BRV3lhigqiIM=
X-Received: from pjk16.prod.google.com ([2002:a17:90b:5590:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:574b:b0:2ee:9b09:7d3d
 with SMTP id 98e67ed59e1d1-305320af3e0mr18907665a91.19.1743540418245; Tue, 01
 Apr 2025 13:46:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:18 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-7-seanjc@google.com>
Subject: [PATCH 06/12] sched/wait: Add a waitqueue helper for fully exclusive
 priority waiters
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

Add a waitqueue helper to add a priority waiter that requires exclusive
wakeups, i.e. that requires that it be the _only_ priority waiter.  The
API will be used by KVM to ensure that at most one of KVM's irqfds is
bound to a single eventfd (across the entire kernel).

Open code the helper instead of using __add_wait_queue() so that the
common path doesn't need to "handle" impossible failures.

Note, the priority_exclusive() name is obviously confusing as the plain
priority() API also sets WQ_FLAG_EXCLUSIVE.  This will be remedied once
KVM switches to add_wait_queue_priority_exclusive(), as the only other
user of add_wait_queue_priority(), Xen's privcmd, doesn't actually operate
in exclusive mode (more than likely, the detail was overlooked when privcmd
copy-pasted (sorry, "was inspired by") KVM's implementation).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/wait.h |  2 ++
 kernel/sched/wait.c  | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6d90ad974408..5fe082c9e52b 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -164,6 +164,8 @@ static inline bool wq_has_sleeper(struct wait_queue_head *wq_head)
 extern void add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 extern void add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 extern void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
+extern int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
+					     struct wait_queue_entry *wq_entry);
 extern void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 
 static inline void __add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 51e38f5f4701..80d90d1dc24d 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -47,6 +47,26 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
 }
 EXPORT_SYMBOL_GPL(add_wait_queue_priority);
 
+int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
+				      struct wait_queue_entry *wq_entry)
+{
+	struct list_head *head = &wq_head->head;
+	unsigned long flags;
+	int r = 0;
+
+	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
+	spin_lock_irqsave(&wq_head->lock, flags);
+	if (!list_empty(head) &&
+	    (list_first_entry(head, typeof(*wq_entry), entry)->flags & WQ_FLAG_PRIORITY))
+		r = -EBUSY;
+	else
+		list_add(&wq_entry->entry, head);
+	spin_unlock_irqrestore(&wq_head->lock, flags);
+
+	return r;
+}
+EXPORT_SYMBOL(add_wait_queue_priority_exclusive);
+
 void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
 {
 	unsigned long flags;
-- 
2.49.0.504.g3bcea36a83-goog


