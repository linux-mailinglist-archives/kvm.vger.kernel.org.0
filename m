Return-Path: <kvm+bounces-47017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E86DBABC770
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9106E4A253E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05046215F53;
	Mon, 19 May 2025 18:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hCaOgk59"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C134211A19
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 18:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680926; cv=none; b=RbRgc+Ud5G8w6hAfTq5HZtuloAMrA75QoC3CQob53DWxiu2WPhBNJsHU3Yh4qBKu2bi9JWxLv4PmIRif+juWlie2aBY5vhX5PqM6AbNBI5FjOhiYPM+WqYi4kG1MDMmj38/bUdj/FDeSZ2diKXAKmJ27T3SjdoYpLCWzTYNxH/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680926; c=relaxed/simple;
	bh=0kgGSVpa4vF1VM/Tm68ip0ARKg16qtEPfsv+8/D7xvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uIgBuqCdx7vmZ+OcbDbskyY/yK5hzgK7YtgOumuolf1P7bL5mMXXjqlUvXjN3fKlyGti6SEaenQsU8sporPXTPnjUnmSRmsUZhOK0WptYJK7tOwKY2rZcFB7ZZKMTtPfOYxb+2lnQVsygM185DgtdUi/83Pck0H0eDcm3CnRE/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hCaOgk59; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so7235009a91.3
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 11:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680924; x=1748285724; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+VBvSn0/1OEly0dhJhpJ5/xbewUf32J5agAZ9eTZnMo=;
        b=hCaOgk59U49wmSFx3wTSCz4I0DbWkzyfCFy7KZm83tBhq4KrFF1B3wB+YpcvKJH8pG
         tVZX6REd3W8J7gskhQ4sF5iWUEOPgWjceUXBf7+u64PFOxeVNksTlsy1cBA14VI8TppC
         RZ/2sM4XQ6WYSngvGIFKId26tGWz3lu6vGErU5CIFubuwm+6QZvqQrmobTmGo2rUFeMV
         007T3Dl/67+3N+VA0CYoYHo9Q5RIss5/xGrc4KuKlW4SYx/jjI4QrVAL80xRVgeXKME3
         aCxZKydP3otWuTt27ePpFd0RlFUrGj4zSlzwDl55kGLWcuW8H0iaQIcLrxOu9L55kkgM
         vufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680924; x=1748285724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VBvSn0/1OEly0dhJhpJ5/xbewUf32J5agAZ9eTZnMo=;
        b=IYA4HzN3zus5ALSGR3bqs/RE4DjvA/4jmJdUHnryG/8dgcfWQ9hhIyRT1mfH9ZCFg6
         ZC2ofokV9ZH4juRrcWPEffnvn03AzLcDFLGLjgN5nfHKqCrv59GEJSf8+RwjMVbiJPre
         iZfIurfrJkWEDysBqza3Xz7Rsq/It69kWSXG+k6mIm1ePt+FXjuRZ1E1+mZ3d2h4WbQj
         YwVu1YAb5nRl73IFxEH5J4sxn1HhM4m0itRpgAYD2qp6sFkCo/kkZJrJoe5DUNjeTwPV
         wjiywY2oMhvkv6R0ynBlgrR/DMgxP8PsiPf6ushwUzm0memqtY1eJOwE15f/EcYGTwwq
         v81Q==
X-Gm-Message-State: AOJu0YzhyckXyGIKG3OcnQaHIOrhAW7oG2JiVAgILcb07qAIXrl60puN
	onv0AhacfVfR0057NOyDHkXSgK4J1MFe+PRG/aFjyd+Px1Z/DxvH7Ie9YvPWz3UoqgvNq1lNCtr
	yLCgv9w==
X-Google-Smtp-Source: AGHT+IGXg/F9gxTP1pqaycZUwOUHp+ak6N7UkX/Xq88IlBNICngR1I/Ww9ctAKD/SX/RDw3McfSZyBJElK0=
X-Received: from pjg13.prod.google.com ([2002:a17:90b:3f4d:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c08:b0:30e:6a10:bb41
 with SMTP id 98e67ed59e1d1-30e7d5a85c1mr21315362a91.27.1747680923944; Mon, 19
 May 2025 11:55:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:05 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-4-seanjc@google.com>
Subject: [PATCH v2 03/12] KVM: Initialize irqfd waitqueue callback when adding
 to the queue
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

Initialize the irqfd waitqueue callback immediately prior to inserting the
irqfd into the eventfd's waitqueue.  Pre-initializing the state in a
completely different context is all kinds of confusing, and incorrectly
suggests that the waitqueue function needs to be initialize prior to
vfs_poll().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 42c02c35e542..8b9a87daa2bb 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -256,6 +256,13 @@ static void kvm_irqfd_register(struct file *file, wait_queue_head_t *wqh,
 	struct kvm_irqfd_pt *p = container_of(pt, struct kvm_irqfd_pt, pt);
 	struct kvm_kernel_irqfd *irqfd = p->irqfd;
 
+	/*
+	 * Add the irqfd as a priority waiter on the eventfd, with a custom
+	 * wake-up handler, so that KVM *and only KVM* is notified whenever the
+	 * underlying eventfd is signaled.
+	 */
+	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
+
 	add_wait_queue_priority(wqh, &irqfd->wait);
 }
 
@@ -395,12 +402,6 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 		mutex_unlock(&kvm->irqfds.resampler_lock);
 	}
 
-	/*
-	 * Install our own custom wake-up handling so we are notified via
-	 * a callback whenever someone signals the underlying eventfd
-	 */
-	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
-
 	/*
 	 * Set the irqfd routing and add it to KVM's list before registering
 	 * the irqfd with the eventfd, so that the routing information is valid
-- 
2.49.0.1101.gccaa498523-goog


