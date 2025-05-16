Return-Path: <kvm+bounces-46914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0891EABA62F
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C19BF1B67E9D
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874E9280A5F;
	Fri, 16 May 2025 23:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q3VauYOt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189A5232365
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436861; cv=none; b=URZl8yIQVmlzysXzWUDMmU1I9//BuJmk50i/ARCQeXAvG48ZCBBuZN/+/3RDkQTOQLiHxKPeQ4QAOczntlVjt7xxvikvZBwrA0DAuA357PuOQr3UCoalRBEU9EJRvSGQIfYo6hXtqR5FLdCHaQoba4mrm0M3r5fAU2KdZ2vie84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436861; c=relaxed/simple;
	bh=I1ALcWIwC8w2ZTqFEjmPzQUw5bLz7mdjqS6Qdf0kmJ0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VOP0TdihIAbnUCmdnNWxBckRrTA9WY1o7RhajH4dDlOR5mfkSuF75dIekq5/NBQJkn3hM7Z0mXE0pMHS0jtRjHRdmO/r+OPTgMVKsYmHGLFtF2sj75VsmplkmH5+sKzeY1VvTpZVarEj5fO92Ce4O0KnBy99mVWt7bIl0cFvre4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q3VauYOt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a29af28d1so2159776a91.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747436859; x=1748041659; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8kDa/puR8zC/TVy/ii11k+vGNrXdae9yxfqU/1udF6g=;
        b=q3VauYOtN04RZ0hh3sol0uU4/jLOh+yA68XJ3uItKyLT3IGd+IUTszJX85M7o6zT0D
         7qy0tqgNdqvp1wmKi2BFS+nrWhz4T0xENqoVxul4ie15EgDjHQij82WJa/3Z1IB4PT7V
         rT8v+FuB8kKWm2gxY70LBr7Br2/n95XjlOV9kVGaUDbPS5vaxCttCDLJ1TFmX6j/g7OC
         0I17Ed9BzisZ1vSGkvxDzJmZN8rFAYUqeSRDCtz3qE/jZgzeKU687JXaGKnp/BuV6eCq
         amyWSsLC908LB5kFMPQtclFcR/1whoRqCGHVG67bUjTwOweZ/N+3j8pM8JsQhLG5pmVh
         mTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436859; x=1748041659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8kDa/puR8zC/TVy/ii11k+vGNrXdae9yxfqU/1udF6g=;
        b=fTlICQlPLtCpjihUKoKHnsjU7RM2RH7mldSqZU40OQV23RAUvbPQStpdhh3EpIpKMs
         VizOBRtuW81wZDklclHYdi3ePHgxtisH4vLKSe1DHPh3E+IvL+WlKIAW/KhXH71ZnIk6
         oFRE5vVhoil8C3dLoehp3iEzbhb915FunKJ4MHA2EeYM/PkiVDMyzCmes+rQUtDX6ovF
         7lci9MRx7J5kKV7Pz/rbF6BA6+djAfq+UAipsb1drO8HqFoSQjmdELl56KtHBEc+xxRe
         LBy4FjPGwYLLlq1SmpWfvDwbK+HiSkcYjHRr5ntqw3VSn7GzvCPYNqtZysr8iUY3bj5f
         n5Qg==
X-Gm-Message-State: AOJu0Ywq8aU6O/v+YBj/+4zT0OLR6nOcF3O8z9nanx6jZ8YRbWfQxzaX
	YeCbsiiBBkwCK4tlx2wjFGpZXTcOvK0xH4/S7hzto5yXKg9aTk4g+f5V7a6CTjjN1SsaSrWnDLD
	S6wxBQw==
X-Google-Smtp-Source: AGHT+IGms52EOzdUpeUySel370WkLvf5qcqXwBrssv6N0gEIpnS2oZ+4XnP+3IKYtmrBjEsQ2ftNzRdpjys=
X-Received: from pjbsb5.prod.google.com ([2002:a17:90b:50c5:b0:301:2679:9d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3e8e:b0:301:1bce:c255
 with SMTP id 98e67ed59e1d1-30e7d5a93bamr7142197a91.27.1747436859419; Fri, 16
 May 2025 16:07:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 16:07:27 -0700
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516230734.2564775-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516230734.2564775-2-seanjc@google.com>
Subject: [PATCH v2 1/8] irqbypass: Drop pointless and misleading THIS_MODULE get/put
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	David Matlack <dmatlack@google.com>, Like Xu <like.xu.linux@gmail.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yong He <alexyonghe@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Drop irqbypass.ko's superfluous and misleading get/put calls on
THIS_MODULE.  A module taking a reference to itself is useless; no amount
of checks will prevent doom and destruction if the caller hasn't already
guaranteed the liveliness of the module (this goes for any module).  E.g.
if try_module_get() fails because irqbypass.ko is being unloaded, then the
kernel has already hit a use-after-free by virtue of executing code whose
lifecycle is tied to irqbypass.ko.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/lib/irqbypass.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 28fda42e471b..080c706f3b01 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -92,9 +92,6 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 
 	might_sleep();
 
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
@@ -120,7 +117,6 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 	return 0;
 out_err:
 	mutex_unlock(&lock);
-	module_put(THIS_MODULE);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
@@ -142,9 +138,6 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 
 	might_sleep();
 
-	if (!try_module_get(THIS_MODULE))
-		return; /* nothing in the list anyway */
-
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
@@ -159,13 +152,10 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 		}
 
 		list_del(&producer->node);
-		module_put(THIS_MODULE);
 		break;
 	}
 
 	mutex_unlock(&lock);
-
-	module_put(THIS_MODULE);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
 
@@ -188,9 +178,6 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 
 	might_sleep();
 
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &consumers, node) {
@@ -216,7 +203,6 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 	return 0;
 out_err:
 	mutex_unlock(&lock);
-	module_put(THIS_MODULE);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
@@ -238,9 +224,6 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 
 	might_sleep();
 
-	if (!try_module_get(THIS_MODULE))
-		return; /* nothing in the list anyway */
-
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &consumers, node) {
@@ -255,12 +238,9 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 		}
 
 		list_del(&consumer->node);
-		module_put(THIS_MODULE);
 		break;
 	}
 
 	mutex_unlock(&lock);
-
-	module_put(THIS_MODULE);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
-- 
2.49.0.1112.g889b7c5bd8-goog


