Return-Path: <kvm+bounces-47022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 198A1ABC77A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E0BE7A860D
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57A2210F5D;
	Mon, 19 May 2025 18:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F2udmMHR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801E921B9C3
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680934; cv=none; b=H/5PBz8dxGd29+QobccMpmzddzgj17FDRxb7+QcNE+1LmH/FEDNUsOzeFWYAc9A+PS6NBfywI2jwHdgc/9Mzxb4vHwRlvQtZFTGChH7/B0AJsY4J+mANkBtLy7Lcj/Hx7dlhGYpGsxHj/hlBJn7NZ+D0V0tujOOLT8k/MZYRKBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680934; c=relaxed/simple;
	bh=UE8/70vVcn8RJqxygSl+zg8PpaIOYhcmQEHooPSRrU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CW0hLVBYB2dIGCqz0wNUQQPtRurz+e8mr4gnPzE3Dvl/whV/sJtIYoDgTEbCigbzWxviyK2TWq5bOz5z5uUOycIhEgAqWgbGsjJV6rYUwQ3raBrNkbTAYtJP4lgRQ4yXUV5n1xY63UeIhOM+tPCV1rLnhCl1V1i70o2U5A9ZlNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F2udmMHR; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e0fee53eso2689899a12.1
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 11:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680933; x=1748285733; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GosnGkQOmy9sXouNtT7tWd/cC5UULc5QRQ9laeft/XQ=;
        b=F2udmMHR62OgAJHdkjFVPxdzL91wGF2CXdp8dhihNxQF7fffCmJ4btSLN2CnwjizT3
         UpFEPOXS3CkNWlxRLgKLehtwNVbHSKKrR0X5/s72B9781b/NEvbzxvLHojxCmjTfzqyz
         GL1RnCqpUYTQZoIsZw2bp19ZUM9Upqymr0bkYgS4dtuoG6UXHdDJ1DcsiYMZP3A3VoMN
         v9qeVQOo9usXAjKk//wi/MRC8mWZmdeWaaXAKxRaDTztGNdagkBd98PvLL9ANpXy2PI+
         ihdCwNnnF4z2Yyo7C2ErCUIWKIUSwZ6RRPmKvB+AYTg9281qcCMrw+1jiU6p8XnT0H7m
         R4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680933; x=1748285733;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GosnGkQOmy9sXouNtT7tWd/cC5UULc5QRQ9laeft/XQ=;
        b=pNeLrffhshcPpWo+NEapcWwHD3ZuC8EjE7Dy5Q8sAHe3JI0fyYZOHFTf85qRKRWYeZ
         1Uoi/LuGzebkdP7v2zLIdpOrkEPyXzIRjogs6fSTlNL0WQtdBM2Cbitl9SEIRjsO+gUU
         L4e8e2cfYQuLcVYXw/3PbtbvVmG2Ldl9vYLwZq+vXr3tsQf7/7Pl96rtc/geDluVGAcF
         i4scbna8t843Y5V2NC+9YJ19zdn/gNr6Ig27oV1QqHZqL+n1RcKT2hUSkgKz1zCrO6+2
         MTMVHdDF3UqUXOcEbWliGkJw6VOfLmLxnzVMh5F2LDtlHwpeH3ZvHaBNHmxZDWyyIf5M
         mOXA==
X-Gm-Message-State: AOJu0YxqD8DA7t4tCX9xFQRBDBim701BsJwPFWi7vxN3yx31Aoaix7le
	9pYAG0Gb3yg1I3wEe7xCgyyCuAOYd0ZlP/eu3bJoPnL9FIvTAK2CtCzQ+xdIsPWhQa3mcnsF949
	Avqz76g==
X-Google-Smtp-Source: AGHT+IF5OGdkKzCp0nPm0pKGJ5Cn3yYZjvTFKZ+Ma7nDq38yX66bRfuqL3GsDOCYJOnomMI2NGvjW+Q4CXU=
X-Received: from pjbdy14.prod.google.com ([2002:a17:90b:6ce:b0:2fc:1356:bcc3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3a89:b0:215:d9fc:382e
 with SMTP id adf61e73a8af0-2170cc5f59bmr19216538637.13.1747680932959; Mon, 19
 May 2025 11:55:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:10 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-9-seanjc@google.com>
Subject: [PATCH v2 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>, 
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
index 03252badb8e8..b8f6502372b0 100644
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
@@ -82,7 +82,7 @@ EXPORT_SYMBOL(remove_wait_queue);
  * the non-exclusive tasks. Normally, exclusive tasks will be at the end of
  * the list and any non-exclusive tasks will be woken first. A priority task
  * may be at the head of the list, and can consume the event without any other
- * tasks being woken.
+ * tasks being woken if it's also an exclusive task.
  *
  * There are circumstances in which we can try to wake a task which has already
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
-- 
2.49.0.1101.gccaa498523-goog


