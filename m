Return-Path: <kvm+bounces-46915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E36E1ABA632
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54FFD4E2BC1
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5320C281502;
	Fri, 16 May 2025 23:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1SJwF6jV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D50280A20
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747436863; cv=none; b=lCcRMF3b2qwTovZTVG6B282Nk9Gq3PY70O7oCi0VU4k8vygpY2FyoSzAIX4kBlCPUmrar4GN9TkxTCB1v6vgtSnHnBZLaXDJyOcN+XGLurR850/JHqXLlu/iDRAxLfFwltZBSR8wh/fcwfv/Q7hChlWQM23PbVR4hOKZx0Fql6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747436863; c=relaxed/simple;
	bh=53lKZIp0QEDIxAnbUsZj0HBAIqsGZWy+CnuC9aywW/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pWciLXriy0UwUuxf2a+Jnu1aNzo9feP0s8bDoAEy1/tKAP530IyvAuaBDTKxY73lYpZzir3HlAEGn+saX4rr3Ul7HUKNIaWBneVPmiuEB1CC7XDgvNNQ4TlFJpHpHKnIrOatXE8wNTlfHLV7Vv13vgGGTjsppvoy6tylHRjjW74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1SJwF6jV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7394792f83cso2011131b3a.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747436861; x=1748041661; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NfgqeidfxQ2kyf1sJo8U3YZ4JNEzadROFUB65CCKoYo=;
        b=1SJwF6jVGsvJoqd7rhdiq8l+du2JROSxasleJXx2a1zJBqZXLji5/fkOVoQd8NqSxH
         pNbdrk+mTqX9TtvCsHE9HjJx4j4svaV/P+xtnm5hvPCBHWSCe+8YF0ryxYnvVk396c7P
         HqRhRQUNx4qcWu4S8rhczJaraF8RFGo49QbbzrwurKLMl/mra89bohu8veF+4h79eTtg
         aRCSabpnOqgoyKNFKPk+nuxLMYD3KSBxT7XUxuY/37Txi6a9jsNwgpHMKs6QCiP74kor
         hQtv0ZfL9YKNKqgbmc27MPeh6w3DYczy0gSFLlu1Sw4zg+pwyaniaaaC29hA6smVkhGk
         1gBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747436861; x=1748041661;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NfgqeidfxQ2kyf1sJo8U3YZ4JNEzadROFUB65CCKoYo=;
        b=cWR8BUB0jldHKFc9jbgBVwPKuoOQYlUkCTcAmmvSQ5yiepwBCARDE6+dZfCsLaiqwA
         C2qyfo8IuraPSDZVYuwyKmSKSbhqSDmpcpwyfFdLggk8iNAGxXZEhM5xRboBT/p8fHqj
         h7d000Mdbjji9etzcnGgbrSd27fsPXsnXXkERoMnbMJzX0RFb3WclOQg7MaE3eLX/kr5
         Wzn/YM6ig8c4LNwLo44UsAhKpCGun52F4Ek999Q2+wEvOZLi5mJLnTEv53hUpLlS9+d+
         mDVRDqz2CI2K0UubL0CRMao2FEzXILtLaIqN8S+YEdIE+aTX87TINGId6YNK4h/jkMsB
         UshQ==
X-Gm-Message-State: AOJu0YzG4FsYdDBpr88aBVo2k7Y5Dam9+SJ9ZV6WxNhJ0dNC+B4jeCkW
	nEZ+xDX4FxQu4zCvWGc0AJj4cBS3Tzgi/H3A4ipasdNEGTo9PRGyWvnWjBsFREoVLlU0FhhKeZy
	b4tpqMg==
X-Google-Smtp-Source: AGHT+IEpuk3JhFswrcOYHhuNZFtNFDjaC6SxgeOCtP19MsiXoVMuiAOEkn9SRzfq0mcswFVBZevjQHeWqN0=
X-Received: from pfst15.prod.google.com ([2002:aa7:8f8f:0:b0:742:aa0f:2420])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ac6:b0:736:32d2:aa8e
 with SMTP id d2e1a72fcca58-742a97a16bbmr6249072b3a.6.1747436860987; Fri, 16
 May 2025 16:07:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 16:07:28 -0700
In-Reply-To: <20250516230734.2564775-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516230734.2564775-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516230734.2564775-3-seanjc@google.com>
Subject: [PATCH v2 2/8] irqbypass: Drop superfluous might_sleep() annotations
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

Drop superfluous might_sleep() annotations from irqbypass, mutex_lock()
provides all of the necessary tracking.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/lib/irqbypass.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/virt/lib/irqbypass.c b/virt/lib/irqbypass.c
index 080c706f3b01..28a4d933569a 100644
--- a/virt/lib/irqbypass.c
+++ b/virt/lib/irqbypass.c
@@ -90,8 +90,6 @@ int irq_bypass_register_producer(struct irq_bypass_producer *producer)
 	if (!producer->token)
 		return -EINVAL;
 
-	might_sleep();
-
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
@@ -136,8 +134,6 @@ void irq_bypass_unregister_producer(struct irq_bypass_producer *producer)
 	if (!producer->token)
 		return;
 
-	might_sleep();
-
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &producers, node) {
@@ -176,8 +172,6 @@ int irq_bypass_register_consumer(struct irq_bypass_consumer *consumer)
 	    !consumer->add_producer || !consumer->del_producer)
 		return -EINVAL;
 
-	might_sleep();
-
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &consumers, node) {
@@ -222,8 +216,6 @@ void irq_bypass_unregister_consumer(struct irq_bypass_consumer *consumer)
 	if (!consumer->token)
 		return;
 
-	might_sleep();
-
 	mutex_lock(&lock);
 
 	list_for_each_entry(tmp, &consumers, node) {
-- 
2.49.0.1112.g889b7c5bd8-goog


