Return-Path: <kvm+bounces-42718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 186A3A7C494
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BC1E173D53
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1DF22DF99;
	Fri,  4 Apr 2025 19:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y3AZY5Pg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD41D22D79A
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795644; cv=none; b=ZouFG3q/TrPpfV5SDHiVdXOdFtUjcDCt0oo/nupghUWPN9OWUvVgp2Q4dnvxQElYgDPmk7aNApaDyhmJGjSM4QKDcgGq39FX7YSv/tTHDwHJc457MQe14oJWS1v4QUOR1+9YQ8zjKfgR4tU0vAZytvENgIGHW/0fDD0FePW5x+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795644; c=relaxed/simple;
	bh=NSXiAizTL3IE0tHV1Xvoqym6aO30iQa3+NNj5eRfrOk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZXrv2zyQLzkqMSULELhjLENL2MTEafKIXwefwLCaeX7dw4u3ZzlDvuExdKXAIF4FflQYPJq9qzQHdlFdORu3cjZSeVjEKQPXaJ5RGCp1eGBrI0lQPAnwH5pbvzfamC6OoJAmP3eFPNWtgDJE/7dcVfMyRg3AVTf5gyfZ0HXhRww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y3AZY5Pg; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736fff82264so1863153b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795642; x=1744400442; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4tJsBeG4t1G+TPijwvZhdI7bM9ZuzjVrHlwd3hub/NM=;
        b=Y3AZY5PgV+xWcumpNe9bf9R4aCotdPjQwxL0h7WAiUe8o8krSrcXjpo9XkeWvEDcXr
         oWXKllbnWpZJk4zGCLDplLQGM9a1u6WZNF0gBBjPvmlG6vzzpyr4VVIjNHQIpvQ/VeHb
         M4rpVgTMMW0e50+neZFRkS9HFe6KcTIqAioFUHyZuSR91A+bXZx5Ymbd8WgI3IbJDm8X
         7CZXC5UsCIFVEJzF8WLb5oR7b3F+pn2qPCf95PfasGgZpbsqadqNkCkrWVoRDW9Y7Y2k
         vEDcCrtg/76wD7dv0G9tG0Nj1dDkG5UN5Hnirt29keZOCvCsEZAmU7cp9/Tz6ejLKDuA
         ictQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795642; x=1744400442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4tJsBeG4t1G+TPijwvZhdI7bM9ZuzjVrHlwd3hub/NM=;
        b=lbFMI82ZwxG5DyEodVWsNXvB4SixBiTGlv5IlvOt9aONsS+K2O14YISBxsxKz2A7Z6
         GxSMmCL1bnJZqJQnOGSYSXim8vt6gxrd8BlrreEiZKVG9fNAhA+XBPpAJSYkYqZ3dLF5
         cP4Wb9pbuhXGqvp2JwYCV7t/UeWi+GMi3HyRy1YpxCYpjdb9OztKIXV6xQ9J+rxSqLSW
         SdqOGyJ9Xy2DDyauBzuosSh8O4On5zxWib0SY4Wd8ewhVNNDYyMRIhKMMCyTYz3gBA0e
         OXq5/zqOcGwJpkt1PWgfWhMVVAHO4/dNZrH/t30iYUEuLVR/9+YJFXrb1MDtmzW13zrO
         SfDA==
X-Gm-Message-State: AOJu0Yzpat4jaFhosf2plwgH0ltg6A+oss9Bgt/ZK7aV1OA1eCf1VPmM
	QHFOmn1qzIGHmrRn0XhkNUSdXcn0gZbg1wVQXOXnAfNiPJq3Xqunm5aucSOUN7ffRhAfUJJV5CM
	SLw==
X-Google-Smtp-Source: AGHT+IEScd25fZRgSV6IjIzWui2u8dQv3YbcYlwFjvNFPD/+/iSxPK7V9mIz4jseM9arXmR9ykpZDrdm3xw=
X-Received: from pfoc24.prod.google.com ([2002:aa7:8818:0:b0:736:a1eb:1520])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3996:b0:730:9637:b2ff
 with SMTP id d2e1a72fcca58-739e5a567admr6139702b3a.7.1743795642377; Fri, 04
 Apr 2025 12:40:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:47 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-33-seanjc@google.com>
Subject: [PATCH 32/67] KVM: x86: Nullify irqfd->producer after updating IRTEs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Nullify irqfd->producer (when it's going away) _after_ updating IRTEs so
that the producer can be queried during the update.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 52d8d0635603..b8b259847d05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13608,7 +13608,6 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * int this case doesn't want to receive the interrupts.
 	*/
 	spin_lock_irq(&kvm->irqfds.lock);
-	irqfd->producer = NULL;
 
 	if (irqfd->irq_entry.type == KVM_IRQ_ROUTING_MSI) {
 		ret = kvm_x86_call(pi_update_irte)(irqfd, irqfd->kvm, prod->irq,
@@ -13617,6 +13616,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 			pr_info("irq bypass consumer (token %p) unregistration fails: %d\n",
 				irqfd->consumer.token, ret);
 	}
+	irqfd->producer = NULL;
 
 	spin_unlock_irq(&kvm->irqfds.lock);
 
-- 
2.49.0.504.g3bcea36a83-goog


