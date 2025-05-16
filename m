Return-Path: <kvm+bounces-46918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B4DA7ABA64E
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DE5F7BA07A
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFA9283FCE;
	Fri, 16 May 2025 23:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y7kY1pKJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBEB2820D7
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436870; cv=none; b=HYqdZ1flgWXwLff18f9vbMZ2pnfIkamtGbFzB6blm4WmVwM2UlSwcIXOxmltoVaSeVgbxLYHTs/Lzolc38NjlBWHL76O9Kx8b5hqyrDELRujDpaTGaKE5G6qb4xlOiYm+J5d9OB1jcDTk7o3dW202hJeExiQ1kU/gEufS+1WslM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436870; c=relaxed/simple;
	bh=9fbaq6CwF6vLyggy/XV/8/w2/CV/cudq3CDw85TXlSE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WBzEv9GnegUJZFjxAY/qwVir1YSlDfkQz9Z1DZ4aBb6GGCJPQnyhkCLdsQcymDFID3DekAEi64Jah7YMC/AdB1pXnEjCsfoWMbH76fO2gy12k0m2Cp3ZPHo8hUBwsi+1UfFEJk8u52WYFstfLJZMCo3w1+HrgI0Q8WbFDZAj1wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y7kY1pKJ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b090c7c2c6aso1652505a12.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747436867; x=1748041667; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oe5thiWbXg0oQhkHd+uP+1sLcx+Gwe9eK60YPiQS+Fw=;
        b=Y7kY1pKJnFIDf1qHpybNFR4/E0j2z6oX/y1xW/ATRroSbZ7hmZEXBf7/eOhY5NkUh2
         +Du3R2D7tR7Ik4wNPhgmPsyoAnYraDYJ1bCF4uyUlMe9Cmqq9NE0DY/x+2gyfrEMGajP
         xKMdIU9yKF1JxoRWSWgxGAi7tx8L6IvSYf3Z16VLOqVskEGpboSEzwHlDJA6yKGicWxq
         FrPV4EIJ+ATB5o/ziDxtPibMBDQCe3MDenYxenI7R1ecDlmoCaoGXlpFpFB93+fHxYZO
         SblxSlI3Llr9mBmdJag2fLpy8fz2mhgEvAmBzkBfPh1F7uG6Vw50qajc4eRllUka3t/W
         vaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436867; x=1748041667;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oe5thiWbXg0oQhkHd+uP+1sLcx+Gwe9eK60YPiQS+Fw=;
        b=LcqEKgKeSm1dxfgnn83npJFs3sjev9grxOOyzd23ZIN3XX3G0LE1czBIzbTdIkaAtZ
         KttOHj9mtLUNTS/f4ylLk0TpLXL4d47soblB7XWTPgEJq3FvAo2JbDZ798HwoIxT26ls
         vw1cDIemRSv4VbD3CCajsRAjBD5xMF2OHpkJIVskXx/9T+Cdpj2XvRcKpC5vUXMQ7C8w
         Z7hwe4WGgUDBb+Bpp0f+flElf+DQKewS0lmDytxnVvuoJ+FHgUDcBLNoFrbCWCGr7ENq
         45Wm7ar8YF61Glym1DeIjUqQls3XRwmmIvoqApbhNwt9xwF1mcMjoniNe/c7orxHRHyI
         2KrQ==
X-Gm-Message-State: AOJu0YxxW894URJDA+bjukHIPfR6Zur95zpjtpu49QhzfPoCsf1rc+hi
	WmX8gx7cjgc/AiE13AgXnFzYQqa4o+Cw2A6sVe/iOYgLtZI0556XMztfw4b9wcwx63zgJPaat3I
	jRVzZLQ==
X-Google-Smtp-Source: AGHT+IGwhN0lFa7qi9dcKhCQf1tbewsw4jw8vfokJ04Lk3TJnvb2OFxjdzkHkOC3oXEw4fYXmMusrSpK3XA=
X-Received: from pjboi16.prod.google.com ([2002:a17:90b:3a10:b0:2fc:2ee0:d38a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f96:b0:1f5:7280:1cf2
 with SMTP id adf61e73a8af0-2170cc66b99mr5833370637.12.1747436867484; Fri, 16
 May 2025 16:07:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 16:07:31 -0700
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516230734.2564775-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516230734.2564775-6-seanjc@google.com>
Subject: [PATCH v2 5/8] irqbypass: Use paired consumer/producer to disconnect
 during unregister
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

Use the paired consumer/producer information to disconnect IRQ bypass
producers/consumers in O(1) time (ignoring the cost of __disconnect()).

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/lib/irqbypass.c | 48 ++++++++------------------------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index fdbf7ecc0c21..6a183459dc44 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -138,32 +138,16 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_producer);
  */
 void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 {
-	struct irq_bypass_producer *tmp;
-	struct irq_bypass_consumer *consumer;
-
 	if (!producer->eventfd)
 		return;
 
 	mutex_lock(&lock);
 
-	list_for_each_entry(tmp, &producers, node) {
-		if (tmp->eventfd != producer->eventfd)
-			continue;
+	if (producer->consumer)
+		__disconnect(producer, producer->consumer);
 
-		list_for_each_entry(consumer, &consumers, node) {
-			if (consumer->eventfd == producer->eventfd) {
-				WARN_ON_ONCE(producer->consumer != consumer);
-				__disconnect(producer, consumer);
-				break;
-			}
-		}
-
-		producer->eventfd = NULL;
-		list_del(&producer->node);
-		break;
-	}
-
-	WARN_ON_ONCE(producer->eventfd);
+	producer->eventfd = NULL;
+	list_del(&producer->node);
 	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_producer);
@@ -228,32 +212,16 @@ EXPORT_SYMBOL_GPL(irq_bypass_register_consumer);
  */
 void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 {
-	struct irq_bypass_consumer *tmp;
-	struct irq_bypass_producer *producer;
-
 	if (!consumer->eventfd)
 		return;
 
 	mutex_lock(&lock);
 
-	list_for_each_entry(tmp, &consumers, node) {
-		if (tmp != consumer)
-			continue;
+	if (consumer->producer)
+		__disconnect(consumer->producer, consumer);
 
-		list_for_each_entry(producer, &producers, node) {
-			if (producer->eventfd == consumer->eventfd) {
-				WARN_ON_ONCE(consumer->producer != producer);
-				__disconnect(producer, consumer);
-				break;
-			}
-		}
-
-		consumer->eventfd = NULL;
-		list_del(&consumer->node);
-		break;
-	}
-
-	WARN_ON_ONCE(consumer->eventfd);
+	consumer->eventfd = NULL;
+	list_del(&consumer->node);
 	mutex_unlock(&lock);
 }
 EXPORT_SYMBOL_GPL(irq_bypass_unregister_consumer);
-- 
2.49.0.1112.g889b7c5bd8-goog


