Return-Path: <kvm+bounces-46919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE08ABA63F
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DA3C1B68407
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C641F28467C;
	Fri, 16 May 2025 23:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p+hE2Wjf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA2928369F
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436871; cv=none; b=NblzBoR8zcUr/S9z3oaZHtuH7uqj+/ez41R8cQQQx/NMTj83EVD7SPjLEM1YnYLfrbMoD5YIGeBH/lY00eTopoC5tavLrQkrITZOQ5wwFLnROy4dALjIwyNLBNJP5IWQzMCPW7SsmzP21f4kBev5A0N1XSNFXgcIQ+XCoLQgmVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436871; c=relaxed/simple;
	bh=3eV70KuPSBCjK3Otg1fXvhrN4aUAqOQEKnpjeLf+MLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LpMRqv7+h1DE8zY3jC8Y/M99RDVV8+T4ve7Xn6zg8NGM4tRA1BnXnaXs9yrjz5nAm/p2yF75XtTUIaCsbc6Hm+jmd3g/D7Pg2njnoDf4dPBuWENSzUC+ga4jbr1DZ8CUBdJqZSHFSNCk0eZbLAm2oDmwyaqDtR8A5viING/RQj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p+hE2Wjf; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b240fdc9c20so2514846a12.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747436869; x=1748041669; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PToc7yVowqyTNBLhp6IJYYBJ3tIDF6DyMy5BFKXkP80=;
        b=p+hE2WjfdEAe1Ti02a6SlYDd04rA4649+me6OC/OD0O5mxHQSZUXOmjH0/Q2LCwkQS
         uJ4kn9MlG0dboTJEHLHQAM9yaGwZMRdiueHHHGf8A/1beknFBtJKf+NnqC9wiXbbZHht
         KHBjyXHFLtXVjyDxlRLD6nAELgpFyzZhy2qJZS3WQHhdYhYZfM+/V5CRMkCYwxD/XTOw
         vkPBfdmF7f4lKKVTj6BkjT9FsfWEjuev9Fr55XakyqYYZkaRYjBmX99C7lkuc+ct5G8P
         ryxerNEG5NbxOuDEGNebh6oZ9j1h3ya7pR3j8WE3hV2w09bK4XG1JACdD+5ooEal4rz3
         wK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436869; x=1748041669;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PToc7yVowqyTNBLhp6IJYYBJ3tIDF6DyMy5BFKXkP80=;
        b=RZHLtvutetuNftklO+RnWsbBT0GBnjzxLkDulmyYWrjOB17wZl1DKGZ6hrOUHwNRbz
         MpgVi+EcthEDmHbek7TM8z5IA3bA1qsv9e7HvpLzeQ7A5UgbTxhhq0ApIDitxvk39Yy0
         y2vNsc+oOPrTyLuAfusmlfv5088VZ0Xp+2OUnTbKxOxXDmk9RpXuyFqem/SXWAeRr8dE
         R1nXA6RJTUTRMIYdA5KDn5QFLB9q7nx/N43Z0FMqENvnJf1/rVDMri+0f1q1RqJXF9xs
         3PEi+eaw27cXYhXMfROm5ShZuKXqBmbD65jug4CKM1mXtkMciwEUc5Oi9JI+AxxC9U5C
         g75Q==
X-Gm-Message-State: AOJu0Yw2AAcMVhG9xIMINoLcpToIufbMifOj9xXvVKampPHZM3tiQ32d
	WxvEVajxRF3qEk8cBGO9T9A4FVmVilOr5fRrWUfK3lvtMy4dOWETKEycaCh23cpHo8jvE810lao
	YTl1W1w==
X-Google-Smtp-Source: AGHT+IFMqF17coq6lIynvImodo9GEBI80OqIy5QNctbeCRw4yO4mG2Xb1BFvJbWtlWRj5T810Vi94FLEzzA=
X-Received: from pjbqj4.prod.google.com ([2002:a17:90b:28c4:b0:308:861f:fddb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c05:b0:301:6343:1626
 with SMTP id 98e67ed59e1d1-30e7d4f91ccmr6639663a91.1.1747436869330; Fri, 16
 May 2025 16:07:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 16:07:32 -0700
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516230734.2564775-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516230734.2564775-7-seanjc@google.com>
Subject: [PATCH v2 6/8] irqbypass: Use guard(mutex) in lieu of manual lock+unlock
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

Use guard(mutex) to clean up irqbypass's error handling.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/lib/irqbypass.c | 38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 6a183459dc44..828556c081f5 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -99,33 +99,25 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer,
 	if (WARN_ON_ONCE(producer->eventfd))
 		return -EINVAL;
 
-	mutex_lock(&lock);
+	guard(mutex)(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->eventfd == eventfd) {
-			ret = -EBUSY;
-			goto out_err;
-		}
+		if (tmp->eventfd == eventfd)
+			return -EBUSY;
 	}
 
 	list_for_each_entry(consumer, &consumers, node) {
 		if (consumer->eventfd == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
-				goto out_err;
+				return ret;
 			break;
 		}
 	}
 
 	producer->eventfd = eventfd;
 	list_add(&producer->node, &producers);
-
-	mutex_unlock(&lock);
-
 	return 0;
-out_err:
-	mutex_unlock(&lock);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
 
@@ -141,14 +133,13 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	if (!producer->eventfd)
 		return;
 
-	mutex_lock(&lock);
+	guard(mutex)(&lock);
 
 	if (producer->consumer)
 		__disconnect(producer, producer->consumer);
 
 	producer->eventfd = NULL;
 	list_del(&producer->node);
-	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
 
@@ -173,33 +164,25 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer,
 	if (!consumer->add_producer || !consumer->del_producer)
 		return -EINVAL;
 
-	mutex_lock(&lock);
+	guard(mutex)(&lock);
 
 	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp->eventfd == eventfd) {
-			ret = -EBUSY;
-			goto out_err;
-		}
+		if (tmp->eventfd == eventfd)
+			return -EBUSY;
 	}
 
 	list_for_each_entry(producer, &producers, node) {
 		if (producer->eventfd == eventfd) {
 			ret = __connect(producer, consumer);
 			if (ret)
-				goto out_err;
+				return ret;
 			break;
 		}
 	}
 
 	consumer->eventfd = eventfd;
 	list_add(&consumer->node, &consumers);
-
-	mutex_unlock(&lock);
-
 	return 0;
-out_err:
-	mutex_unlock(&lock);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
 
@@ -215,13 +198,12 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 	if (!consumer->eventfd)
 		return;
 
-	mutex_lock(&lock);
+	guard(mutex)(&lock);
 
 	if (consumer->producer)
 		__disconnect(consumer->producer, consumer);
 
 	consumer->eventfd = NULL;
 	list_del(&consumer->node);
-	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
-- 
2.49.0.1112.g889b7c5bd8-goog


