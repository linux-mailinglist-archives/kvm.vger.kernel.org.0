Return-Path: <kvm+bounces-62480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE0FC44D96
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 04:40:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7465D3B0D6E
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 03:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516F92857EA;
	Mon, 10 Nov 2025 03:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XgnCPLtC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068792848B4
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 03:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762746002; cv=none; b=HJh87VpFh9NGhQLdhAiA//A0ypoXCjw9XjIYZrb4V9yT1dMrm5yrkzMbg5pNHd2M4mbx0Wr9CxUjQweKuXWJpfeLGnkOoyzt1Ki4bhRS0NCfxGCiHRrKCultt8Tkv6vJl9edYIks9yLWGrxB+hZO5NDBxg/hfW48W4jnFh2xSVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762746002; c=relaxed/simple;
	bh=9fSVaG1uC1BiaaraAMlQRxKUAMgCSO5mz0dNmTqscUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehYlHMS/8eZxvdZErL2qGFQPlPEcKrErTstnkQpDZsWCWcdq7cwyOS0dINs2Nn3z+N2vyTclA4qw1ORAICyzSufiW7tGzCDBndXcqUpYAbkjOnlFqt3rZ7eMaVjwsfrYr9DPMAqRXH/XIaAQ/GM/v7t+YNO0Qqj4ibODvKpqG0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XgnCPLtC; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-298145fe27eso7447125ad.1
        for <kvm@vger.kernel.org>; Sun, 09 Nov 2025 19:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762746000; x=1763350800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kyHdinwOK0g1o44QvaD951QSRNsd3g9ZIX/MxVLDNPY=;
        b=XgnCPLtCVigIljv8y+CSnw6JNOAamiWNdKO4Ol8P2mtKBOaVp8MBzm+EZ7i918jvKq
         YTnHmQiph8wgKqHDTTUAwzEfwm1SBgbLSrrbvUWOA4xP2MDZVVY9wr2kIkom+bmEiOtQ
         2UyJw+740wRIYAqnFYU3qKRhx4Bp+AG2G5lMt+/5Eec63hL9augL67Z90FZe5W63zgDb
         mEagfuRbUmJM6OuGR74nMSV/pYVZ5skO/c01xSNl6x+wCHmrd3+L2dRt3z3kVQ7zLgBG
         ZRAVpnbYrTC4pi3zPw1ClKtYj+43c/EvSaoINaKpV5wuDX5XS6L/BsDeQYjnk2S5pPiG
         6+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762746000; x=1763350800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kyHdinwOK0g1o44QvaD951QSRNsd3g9ZIX/MxVLDNPY=;
        b=CGmSpl9U4K38MRQyXYdISYs6/TpBtbOM2HO07jZLdUGFdc6hYAGqTPsuWqJ9Rgu+js
         ne/ULo80kQIsQkqunZRmtJK+Z7OMdLmf2wZ7mD1gObcPxhL9lyj1q/0xogWwzwMlfmWd
         jmPcuWSKu9PpvOqnGtMya/8HCeOykzhGIMzefn6M0DMkQAY8w1w7GwEgJDVgEcIAn75o
         ujTq5dyXbT327YdOUHQj7MuiI8jg2Q3fyzqDz8CSQGDcif4pqCrry9xt+mirJM0jIIG4
         WunK1KPn6UQmGn7KyZqTjFFuiFXVVk86+YZRtthLkgX702v2fWuRLCf3VdZvaaiKpxmX
         04LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUrOM3Fjl43ESQkSC+/Fldqge1oyBgBLBkv5kleQOupLOAZ2rVkuiykp4IYYhT8iB4O+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfkY8BmVqs55mxR5+95eyZ3IaAjf46u9AwM6nB8h/9DC18bUdA
	VX0UCGzhual1fvWJWgsUAsWBA0McVfH26v37ZgQ/PVtq2GMb4M0J86HJ
X-Gm-Gg: ASbGnctfR0QWaz745BGrVoJ/yNZXD123k23+X7wgNz8JPZPWHfHzzdXxSmRln1EjQRz
	Uw1Y5W6Xiar7mo0MLOfidfp0wMgahPJCMeMBF/fSNmXNWEgk3KmTV3AHATIn2ouvy8DIu9h+7ae
	5Bur7qrLDVPqhFcamGk4UQciUjEXbgeudAHO/vRzEqwtOHsI0cpnh2ycotN1QvIBfKmI7IevL6J
	wQVJob6aa3F8cOUB7jsCIr1vvvn5xSnNX4Z4fd7VDc0L92B/CgKUBjO2e/2N6VyMpYWdBr7cfA1
	oqDG/9fNWAsfsbZpDiTR+YfcK5ujoy5LOVxSPwf0wf9q6d+swOehJdCNNrOhjeoAYym6T26PnSD
	mP3N1s91srSjgsw+1WNTVOALqVK0DWpfi20s4q8vN3a5HwKWATZHkbv+N6AKbDZYAxo2GEMaHzJ
	v4bkrCjAkU
X-Google-Smtp-Source: AGHT+IFpEw2uaxPZOv2frrYrOOFzZim7qBgUpLz1BMg7jwJmYB9wgwu99U615UVe3F+N/pX5E14Y6Q==
X-Received: by 2002:a17:903:1a0c:b0:297:fc22:3a9f with SMTP id d9443c01a7336-297fc223c26mr50766735ad.38.1762746000290;
        Sun, 09 Nov 2025 19:40:00 -0800 (PST)
Received: from wanpengli.. ([124.93.80.37])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2964f2a9716sm131118915ad.0.2025.11.09.19.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 19:39:59 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 10/10] KVM: Relaxed boost as safety net
Date: Mon, 10 Nov 2025 11:39:54 +0800
Message-ID: <20251110033954.13524-1-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110033232.12538-1-kernellwp@gmail.com>
References: <20251110033232.12538-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

Add a minimal two-round fallback mechanism in kvm_vcpu_on_spin() to
avoid pathological stalls when the first round finds no eligible
target.

Round 1 applies strict IPI-aware candidate selection (existing
behavior). Round 2 provides a relaxed scan gated only by preempted
state as a safety net, addressing cases where IPI context is missed or
the runnable set is transient.

The second round is controlled by module parameter enable_relaxed_boost
(bool, 0644, default on) to allow easy disablement by distributions if
needed.

Introduce the enable_relaxed_boost parameter, add a first_round flag,
retry label, and reset of yielded counter. Gate the IPI-aware check in
round 1 and use preempted-only gating in round 2. Keep churn minimal
by reusing the same scan logic while preserving all existing
heuristics, tracing, and bookkeeping.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9cf44b6b396d..b03be8d9ae4c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -101,6 +101,9 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
 static bool allow_unsafe_mappings;
 module_param(allow_unsafe_mappings, bool, 0444);
 
+static bool enable_relaxed_boost = true;
+module_param(enable_relaxed_boost, bool, 0644);
+
 /*
  * Ordering of locks:
  *
@@ -4015,6 +4018,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
 	int try = 3;
+	bool first_round = true;
 
 	nr_vcpus = atomic_read(&kvm->online_vcpus);
 	if (nr_vcpus < 2)
@@ -4025,6 +4029,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 
 	kvm_vcpu_set_in_spin_loop(me, true);
 
+retry:
+	yielded = 0;
+
 	/*
 	 * The current vCPU ("me") is spinning in kernel mode, i.e. is likely
 	 * waiting for a resource to become available.  Attempt to yield to a
@@ -4057,7 +4064,12 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 			continue;
 
 		/* IPI-aware candidate selection */
-		if (!kvm_vcpu_is_good_yield_candidate(me, vcpu, yield_to_kernel_mode))
+		if (first_round &&
+			!kvm_vcpu_is_good_yield_candidate(me, vcpu, yield_to_kernel_mode))
+			continue;
+
+		/* Minimal preempted gate for second round */
+		if (!first_round && !READ_ONCE(vcpu->preempted))
 			continue;
 
 		if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
@@ -4071,6 +4083,16 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 			break;
 		}
 	}
+
+	/*
+	 * Second round: relaxed boost as safety net, with preempted gate.
+	 * Only execute when enabled and when the first round yielded nothing.
+	 */
+	if (enable_relaxed_boost && first_round && yielded <= 0) {
+		first_round = false;
+		goto retry;
+	}
+
 	kvm_vcpu_set_in_spin_loop(me, false);
 
 	/* Ensure vcpu is not eligible during next spinloop */
-- 
2.43.0


