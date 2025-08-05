Return-Path: <kvm+bounces-54035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 411B8B1BA99
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:06:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 736CF18A11BA
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC38F29B22F;
	Tue,  5 Aug 2025 19:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ibcI1tvj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D04B29AB1D
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420734; cv=none; b=lejHNEHnJiNF1BFtqCib9k/C1YLplvWeP75YXKzxjQytzzlh1r2EujvfMSV7o44fz/xh01C0KCSaZ99WxuGjOuZPhs29Hjjl8woVgSdo3XrWnJPMHJ8FbW61umK+wu1/H7XGiZBfx0hbTLaylvqFosJzVNZDXMAgwm5Pe4CUfis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420734; c=relaxed/simple;
	bh=HbVZXzciHuWe7qp7KdZ5PNobwj23hgNSTftSTqFbOGU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L+gUHWPE1hNTWbyDa1HQi++QoMfMNcLwBDdBb7KMTbkha7Uwbr0hLJ7so8OygTYEZTOb1Vpmjlq2I/nizII9ku5LrjILjF9Q+wBwgUThfBy/Q9PBfAD3dLuvX1qyJD/AAAvnq7RqTMVRhosJ7DmG+8wpJjsrBHf6j9pCDEfuzYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ibcI1tvj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23fd8c99dbfso47143095ad.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420733; x=1755025533; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kwv2uoNl6IM1Rm8d9mEpWGTse8EQAo0NkYkscIAw3C4=;
        b=ibcI1tvjNbqUSANSvbxo28wHlhJnfNiOzbaEHt+4P6izhIQCVKQjBXRpJI1fAzx/9m
         zvyb3JxieOrk1IBSIY2FqFsUjdBG7AqfxyU/AWK0Ffxs62phJngae1V8jvOeyOXXqLPU
         /W5/WE6d9jUItdVoc7eOaQ2+kFq3aFhRA/3jx7QfemrlYwn4LMAxDCMen9Qzlm+/IO/f
         D4MK8VVmac5msYAdA9+4vrs6UQ+57wtfePzpDsH1L8o1BX38f4+/qeulSaObOyze9C+J
         qYYROdOIT/z3edGVfsBpgocGyDceqsjSYQlXPpzrmqxST6z2JcFQ3HWtLxKFHWoecEgN
         +ECw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420733; x=1755025533;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kwv2uoNl6IM1Rm8d9mEpWGTse8EQAo0NkYkscIAw3C4=;
        b=Ebs0P8u6IGhZhI3KDCZQJvg4iMWKofcBxWV+8DFJVVHSwbWX1cfHcHXEz9CkTjlobh
         eulEm2fg5ieOCzkpdqKafW1Hx8rffgEfbJX+mJkfjssOwbYY1yx23VzxmBxcv7Q8aUo+
         C32W4R4FLXW5NBNauAxGoEbfJDPQ9/vAIUNrQxkMbESaMUmVm/0N62g8bWxBVBIBDJlA
         Ad09Yy08Y1qsGo1f7cn35XLZV5+kieuMdIWjyso05CV4NFsFwPMBISRnde5OP5PVRwIi
         3bQqSzJygwXF0LQEncEYBaTEEyhU4leJL8TTPNAIslGrO3LnsxiabxuCTDhh3ZtSSBDu
         nsiA==
X-Gm-Message-State: AOJu0YxkkOaQFeMOSng0qdPeliGFuOuJSLRaVXLsRwnRAYfeQAsgodH2
	mXGn744LanK+5uYQs2E9VQzcuh8i1Vg/4hYEz4YzWWgJzl3avrows9pb9lWlYL29YIpdRO/j9Eg
	v2UQaHQ==
X-Google-Smtp-Source: AGHT+IECGQbfrhzAcpL9CeFtEuwum+PP5UpXCFSrhMP8ea/+VjUuaLEHCKh0Fq5BBGoQCFW8zYtB28FTAYc=
X-Received: from pjbnd10.prod.google.com ([2002:a17:90b:4cca:b0:311:f699:df0a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2284:b0:240:5c0e:758b
 with SMTP id d9443c01a7336-2429f671811mr2057625ad.50.1754420732956; Tue, 05
 Aug 2025 12:05:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:10 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-3-seanjc@google.com>
Subject: [PATCH 02/18] KVM: x86: Add kvm_icr_to_lapic_irq() helper to allow
 for fastpath IPIs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Extract the code for converting an ICR message into a kvm_lapic_irq
structure into a local helper so that a fast-only IPI path can share the
conversion logic.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8172c2042dd6..9f9846980625 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1481,24 +1481,30 @@ void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
 }
 EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
 
-void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
+static void kvm_icr_to_lapic_irq(struct kvm_lapic *apic, u32 icr_low,
+				 u32 icr_high, struct kvm_lapic_irq *irq)
 {
-	struct kvm_lapic_irq irq;
-
 	/* KVM has no delay and should always clear the BUSY/PENDING flag. */
 	WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
 
-	irq.vector = icr_low & APIC_VECTOR_MASK;
-	irq.delivery_mode = icr_low & APIC_MODE_MASK;
-	irq.dest_mode = icr_low & APIC_DEST_MASK;
-	irq.level = (icr_low & APIC_INT_ASSERT) != 0;
-	irq.trig_mode = icr_low & APIC_INT_LEVELTRIG;
-	irq.shorthand = icr_low & APIC_SHORT_MASK;
-	irq.msi_redir_hint = false;
+	irq->vector = icr_low & APIC_VECTOR_MASK;
+	irq->delivery_mode = icr_low & APIC_MODE_MASK;
+	irq->dest_mode = icr_low & APIC_DEST_MASK;
+	irq->level = (icr_low & APIC_INT_ASSERT) != 0;
+	irq->trig_mode = icr_low & APIC_INT_LEVELTRIG;
+	irq->shorthand = icr_low & APIC_SHORT_MASK;
+	irq->msi_redir_hint = false;
 	if (apic_x2apic_mode(apic))
-		irq.dest_id = icr_high;
+		irq->dest_id = icr_high;
 	else
-		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
+		irq->dest_id = GET_XAPIC_DEST_FIELD(icr_high);
+}
+
+void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
+{
+	struct kvm_lapic_irq irq;
+
+	kvm_icr_to_lapic_irq(apic, icr_low, icr_high, &irq);
 
 	trace_kvm_apic_ipi(icr_low, irq.dest_id);
 
-- 
2.50.1.565.gc32cd1483b-goog


