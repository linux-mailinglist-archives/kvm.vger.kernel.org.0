Return-Path: <kvm+bounces-54037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5516B1BA9C
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0613518A4B57
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2039E29C34B;
	Tue,  5 Aug 2025 19:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vifgQNSl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF6629B78F
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420738; cv=none; b=frk6dudICeUWauRIeP4rtu6YBhRg8ylgD9cZ8zkftMdP7IEmwzArCtoWRzhUMEKEurJs4efOCi2ZS7nItqxh+W5cyCQU7nJaEeEvQ5BHdQ61jklUclmPJ5vDdnASuV5tEi8E7rv0lLo0nX6ZFwBw3u9eQDFyJGriFyLgf9hdRcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420738; c=relaxed/simple;
	bh=EeTLHsTvTDj8Ey13p+W1lWhVKS1l/trEcm4QlAWCCfk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EAKLqZTV2tMellBSzn/uQaUeTLlYli50FkrEjRUSGmDp9e1/G3ypO5jKGDkMOOO+h2aeYyIG9Qovpi8SvL2b1aYgC0Xw1E2sU+kPHptWiMzk2DwdJdLgTPgOSk1A9UU1jqJXz9GNSBd1Z7WxVNuZRTSrqChuEqQ2uix/sSnvf3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vifgQNSl; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c37558eccso4674239a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420736; x=1755025536; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFfqB1AL/AlReFpKct61YHUAJLOWiS9uPENYpzvXzio=;
        b=vifgQNSlzMOGOuStBxRmuNl0aZUJ10qkAGHDWeaM5yx+IoglD1zhkMxuvWxfMRlDH1
         MUgb5A0yipp5sWDVicH+EwxKz7KjPxcgXPTuXu/V6qw1xaL1hbjFDdZcgqCdbhaBTDXw
         shcsj89AKlWuUnJfmu2eJCONQWNSE5pQco8OZYt7a/VR3v8YFK6sixM2go3XO7jXzuoa
         aN6qDdgRelX/8aIHCZjvNbLSya114K7jYk0GYu8VefdpGXsiiOkUNhFCmPYf9yGc/EbK
         pADQA4r4eK3qevwGF+LuW+s5ZkRNSspdwy0fxFvJHEGxuDgcTwNfxcCimDtNmqQcDudW
         yozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420736; x=1755025536;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZFfqB1AL/AlReFpKct61YHUAJLOWiS9uPENYpzvXzio=;
        b=M24/GNQ1SYwTNxFLPqfFevwiVa18EgR9Xqf8oxSIuemL9oOvwgtxD4sydPiEG+KiNI
         6pqP+INfFaRGVStw/XJs4h3nWnxmUPk79SMpApsLl4ivU+C6vXvE7ppIq6xVIEF3mP8Q
         A66A7dWBjvrp9JYV21p3oY6qGhP2PAP1kB2v10eA6MizZ/OLV5NgNWpQR+tj6hKh9TiN
         syfXyABA4GP+pWLj5kmEgnF94jKa5lvuKnfuhEk1gU8eqeozM3GbmxNYuZs00YaVS6WV
         b522lng3AEhrILLBwWih4FbVaTldtWru/lp6ObQEPBKnhfePdtBDzsVAqsyzhzFm+CtO
         9uzw==
X-Gm-Message-State: AOJu0YwkD54lrC/4QU3JmaGGYoFGjS2H9GY1HIGk68V1J3zSYrT/zgqk
	KVGrrnYFJB2dxYP8CtUKR892i2gXOomQK+5XsA7rLmZzNAeoopN1+vecVWSZO/ZuwRt/8Gbxx9m
	jn3Pfug==
X-Google-Smtp-Source: AGHT+IHBWzHfL+L7GB3q7VFL96dyhmem4ajYx6SknmEz91pFfowhZsGDKVn++VKvzcmUoICFnKZXrj3SyWA=
X-Received: from pge13.prod.google.com ([2002:a05:6a02:2d0d:b0:b42:3711:3de7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a20:b0:240:1d4f:720b
 with SMTP id adf61e73a8af0-240314553a2mr238202637.23.1754420736287; Tue, 05
 Aug 2025 12:05:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:12 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-5-seanjc@google.com>
Subject: [PATCH 04/18] KVM: x86: Drop semi-arbitrary restrictions on IPI type
 in fastpath
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Drop the restrictions on fastpath IPIs only working for fixed IRQs with a
physical destination now that the fastpath is explicitly limited to "fast"
delivery.  Limiting delivery to a single physical APIC ID guarantees only
one vCPU will receive the event, but that isn't necessary "fast", e.g. if
the targeted vCPU is the last of 4096 vCPUs.  And logical destination mode
or shorthand (to self) can also be fast, e.g. if only a few vCPUs are
being targeted.  Lastly, there's nothing inherently slow about delivering
an NMI, INIT, SIPI, SMI, etc., i.e. there's no reason to artificially
limit fastpath delivery to fixed vector IRQs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8c8b7d7902a0..ea117c4b20c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2145,13 +2145,7 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(vcpu->arch.apic))
 		return 1;
 
-	if (((data & APIC_SHORT_MASK) == APIC_DEST_NOSHORT) &&
-	    ((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
-	    ((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
-	    ((u32)(data >> 32) != X2APIC_BROADCAST))
-		return kvm_x2apic_icr_write_fast(vcpu->arch.apic, data);
-
-	return 1;
+	return kvm_x2apic_icr_write_fast(vcpu->arch.apic, data);
 }
 
 static int handle_fastpath_set_tscdeadline(struct kvm_vcpu *vcpu, u64 data)
-- 
2.50.1.565.gc32cd1483b-goog


