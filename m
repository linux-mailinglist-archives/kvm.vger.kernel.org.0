Return-Path: <kvm+bounces-42405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81096A78377
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:47:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93DF016CBAC
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3371821660F;
	Tue,  1 Apr 2025 20:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QJRmlX0m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5FA214229
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540413; cv=none; b=WDbxYLAhYWfch09cN3Ccb6qxWjMI5UlhUG6MQHHwlhj9pcsWRbe42zDiBepNqbj8JQ3/O9J99KYCFs2nTp8hT07AHiUwBUaI5ywVjF2oE8SRSD9MlNRFTFVHf592KL93ajFQVLKvni/73b/cuvQUlLuu12TSLZPQyjlTBrUAQ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540413; c=relaxed/simple;
	bh=NEcVsWkrtlEatK+Y5SErb33iB70xl7AybVaIH/Yq9FU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mq4UuTKbcHv2/LOtlTpJEyBZ6/Qnz+9IHL8ITas8d7AQFxxDD3V9jOPUonnEKzvobdsY/nVeBbc2EyMWe5FE81nWZVxwnEmyCa8VROJuVLN8I/h2sqKe1k6bVL+AiQDiSL2KNPx2qJbqP24MmAUWTnhdpti9Mcyk1BUab8NEXwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QJRmlX0m; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-227ed471999so95586985ad.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540411; x=1744145211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j8aM8OQNKmiMYC4fpWY1Tcz4TDYVMXdrg7MtQvLe+/k=;
        b=QJRmlX0mTrHvzBAE9nceVI/BKw2gf4+m9Ju2Ej37vUwGOO3w0G7DT9WiDAoNQM/ZYU
         PanPZy7adQotXtjpoPJhz6s57JNS7Lar+KWzOxlgIwGyFmQHfeXglTOnDZlyjZf7k+vC
         Wd5jJbMniavzjs8OiUFteiqP6r8HTKPjDnnyf0t1ZfGyz6ylGBYbq5hHn10lK18OCl42
         xBYOsZYpDicGhS4Cw1KGPZ5qEKoYf2yVuqG9pW3htw8beAHvkKWKuOpAiD/Ym9n6TWwa
         Tmbi7bGfN9mNsOvgh8U4kPFFD2uc7hDYywN58D8QgzV4C0cBinQT91jabx7BLjYzfRoj
         zjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540411; x=1744145211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j8aM8OQNKmiMYC4fpWY1Tcz4TDYVMXdrg7MtQvLe+/k=;
        b=oQ8+EALOEjMxwBrysP4dNyF2oshr5iVqoQ+ugUqw6NL0VvyJFoIOXPwOKNMiDqVsZA
         Lj7ecSLFmmqk479r2CFZBEQqw2bUe1vKixEt03CPunx8Cwp+qWTPbPXojkVCrq4lYcNp
         ZfGHxUjkr1a0LWbdfN+bXyzrd8BJDz8YfD/od4zRPdS05zRWcfqOwkVANzURhx4rUA9K
         BgakZd0Ne+we31HrZhNwQWnDw24sWPgZ0cGqv39bHhNYMbl4DQlHLrRlxEMceAb/Xe5B
         S8UibMR2alcrCPFhD6zHbOnTpWQ5jOhh1o6fHwi6SrioPgEplTHNxmwMcT0kxCjeGlUl
         UPqQ==
X-Gm-Message-State: AOJu0Yw9uC61JRxx06fQLUte0y4CYAZ4eOeFra+lk2WKQNp7+taOWiKz
	56/Nt3yfvxG25ADszf27hK9MA80CL7oquXb0j09LETzJYiSRNNJaRQqKiAlWL5FFrib8QAf2Mx7
	KOw==
X-Google-Smtp-Source: AGHT+IHk4c/1IjO1MwiDzaYInvb39GIpeBXBReykLE1mG0z4QyNEUAZvNPkX1TcPikaWCjInx7JyJFujPu0=
X-Received: from pfbcw10.prod.google.com ([2002:a05:6a00:450a:b0:736:3a40:5df5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c411:b0:220:f7bb:842
 with SMTP id d9443c01a7336-2295c0ed243mr67188835ad.42.1743540411361; Tue, 01
 Apr 2025 13:46:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:14 -0700
In-Reply-To: <20250401204425.904001-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401204425.904001-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-3-seanjc@google.com>
Subject: [PATCH 02/12] KVM: Acquire SCRU lock outside of irqfds.lock during assignment
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

Acquire SRCU outside of irqfds.lock so that the locking is symmetrical,
and add a comment explaining why on earth KVM holds SRCU for so long.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 01c6eb4dceb8..e47b7b6df94f 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -401,6 +401,18 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
+	/*
+	 * Set the irqfd routing and add it to KVM's list before registering
+	 * the irqfd with the eventfd, so that the routing information is valid
+	 * and stays valid, e.g. if there are GSI routing changes, prior to
+	 * making the irqfd visible, i.e. before it might be signaled.
+	 *
+	 * Note, holding SRCU ensures a stable read of routing information, and
+	 * also prevents irqfd_shutdown() from freeing the irqfd before it's
+	 * fully initialized.
+	 */
+	idx = srcu_read_lock(&kvm->irq_srcu);
+
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	ret = 0;
@@ -409,11 +421,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 			continue;
 		/* This fd is used for another irq already. */
 		ret = -EBUSY;
-		spin_unlock_irq(&kvm->irqfds.lock);
-		goto fail;
+		goto fail_duplicate;
 	}
 
-	idx = srcu_read_lock(&kvm->irq_srcu);
 	irqfd_update(kvm, irqfd);
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
@@ -449,6 +459,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return 0;
 
+fail_duplicate:
+	spin_unlock_irq(&kvm->irqfds.lock);
+	srcu_read_unlock(&kvm->irq_srcu, idx);
 fail:
 	if (irqfd->resampler)
 		irqfd_resampler_shutdown(irqfd);
-- 
2.49.0.504.g3bcea36a83-goog


