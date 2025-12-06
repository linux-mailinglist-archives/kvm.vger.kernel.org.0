Return-Path: <kvm+bounces-65447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 77154CA9C36
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DF3E9302E13A
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F45131A807;
	Sat,  6 Dec 2025 00:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qDPc6Aiq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A750731A06F
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764981815; cv=none; b=LLSckq/hsfYaELwsLDWfaep2D5PzfE/p+a+Rr/PCo7J+jMvjn0RcTiLrRZnbhYU1lnvxn0V0ugyBKctGU4sh64LYwwti+Dz782E1m5x0zPvvMhu7/7Eoc7I0pIQyUK2VC5TW0AiDiYV3U9455XPHY+G0M4EH5eoO750fteuYjw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764981815; c=relaxed/simple;
	bh=PweGGT8dcZgxuINZD4eC15xtjEWtlEQ43EHnvSh8rlk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lhz0KzV8Z9QdiMFQBzQu7gtIUj5ZcfBVcygDGldT8HcsoEJxkDHlA9kp+F0HZEZJlwd0LNoD+iHVlhsPbDbvYcym+1hjSxrl3MXK3lv2puPl0b+G4guiYOfzqpG6a2Q3n8TTz0T4QTZF7aYxcwJKG9nxg1iYFPEWPcxO/gJ/oLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qDPc6Aiq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340d3b1baafso3714381a91.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764981813; x=1765586613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iwA/2R3/erTvUP5/JcSpQX87XH1JoU7paa3KDPV68VY=;
        b=qDPc6AiqBsKhp8XvxLYfKlnbI1FMzih3kqr2bgYOLFShA7nnnf0zKIYXhXLFAaBrKA
         DpjJA9gMHrcu2bjh+o66drac0w4h42QHYls++T+ADIoC3wPiLXRC1vDAB6vENVDTkt4/
         5eoHkttIOTwdWCUUzm8yF12O8ucA8+p+jkijaSnVCPAH4jnbzM8bBzQpgQ3Z7qdnvMto
         jc+Shmb3OEq72heedOO48YAGn1jTwJJPJ//JD8qHZstETb1rp9Fx26A4qaNpNIvpx1rb
         Rl7cGHYR7sDuqsmqugL6/gvYOwhDRMvGh3MFvyiGx2zdz58RBZkBwGJeySYkImr0HGaj
         1iGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981813; x=1765586613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iwA/2R3/erTvUP5/JcSpQX87XH1JoU7paa3KDPV68VY=;
        b=O7vorQXFNsyQfksFiBt+JhXZDsKRGWcpHPFbKa/RfIsBzm93D+Q6xlZGvEruYHhy7J
         8HtVHmKju4fZ6Xsoq4CElJnYipQhlUIMUviWrYoPHsVUFEZ+5uqDVc8MYJH+QvRCYLxP
         G8+6gRssuiJaKzW+Y4/9XjsFlI+z5I0vql6cFwfS6TdzxFgfabSf2owAWxrFbc24vVPD
         HhVvvGcahmlKG3aif6I9aZSgqaHjYW12tV1dJPb1b8eB6JtjEpAfA/re0ZWYY8a5bfiU
         pFaGvzziv8PCSEkhOsRJoeW8sMDdyWxxa71S4qHphmVLhHr7fBzaB1xfAfkQQ5P0dXSn
         wrKQ==
X-Gm-Message-State: AOJu0YzQHf9jtyekSIUsPAJOl5UQrQKOgoBmY+ovTDZ7u6roG+Qy6Cf8
	7OMYZgYPxmcopUU6/e4VZL8/Uc4skE6AhX9amWy4WTiSxDBDKyJcqhSPuNr8HYa4a29KOPm2jNi
	s3F1Neg==
X-Google-Smtp-Source: AGHT+IF1wlLw5tKP2MahScWnqNYKosVf7VJShq5yWFU+gWkqFVQfBU7CnHJcvzoWX84E13Jq/9xcqgql1Os=
X-Received: from pjbhl15.prod.google.com ([2002:a17:90b:134f:b0:340:9a37:91a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:164d:b0:340:48f2:5e2d
 with SMTP id 98e67ed59e1d1-349a24e3b3emr720458a91.9.1764981812967; Fri, 05
 Dec 2025 16:43:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:43:11 -0800
In-Reply-To: <20251206004311.479939-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206004311.479939-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206004311.479939-10-seanjc@google.com>
Subject: [PATCH 9/9] KVM: x86: Hide KVM_IRQCHIP_KERNEL behind CONFIG_KVM_IOAPIC=y
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Enumerate KVM_IRQCHIP_KERNEL if and only if support for an in-kernel I/O
APIC is enabled, as all usage is likewise guarded by CONFIG_KVM_IOAPIC=y.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..8a979c389bc0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1222,7 +1222,9 @@ struct kvm_xen {
 
 enum kvm_irqchip_mode {
 	KVM_IRQCHIP_NONE,
+#ifdef CONFIG_KVM_IOAPIC
 	KVM_IRQCHIP_KERNEL,       /* created with KVM_CREATE_IRQCHIP */
+#endif
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
 
-- 
2.52.0.223.gf5cc29aaa4-goog


