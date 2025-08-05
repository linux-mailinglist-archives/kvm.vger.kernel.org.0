Return-Path: <kvm+bounces-54046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDC78B1BAAF
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:09:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D19D6269C6
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2EF2BEC2D;
	Tue,  5 Aug 2025 19:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BW51GNMW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034F72BE7A3
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420754; cv=none; b=vBiWWrfgEjSG+zlZw/cVk7W98sphqwxHCPdMvGXDu65TwEEUuTDJWdhOKhPHZ8M4oQX8l0Wa5son9lQ26QWo2HrgpIYIKNKNbX32gR1omDFqHx9PzAQdoojKUXHRfOTyr2nyX7rzLMDxcvBM7GSgJjGenfBKo3pKNZByhOGdoeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420754; c=relaxed/simple;
	bh=Kypk+/CIeqoZ/r5aB2dTj7/V8NMqnRxOmJHlZq0EdRE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hwfe8xmSewb7XFIckTcY5ozG4bpR6aoD43+P49uQYH3m+X/HdlTOl0zuHjAcs/k+1pP+hNNDYUmqX8A2xatH9HCbqdF2XDaoNvjtTHwGFwNVTPg2X+K3xnw+Zob4ya4VAveHdi+N8kSpVnbNOPFGAe3r7HWgoki0gR9WjkGFTGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BW51GNMW; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b427c287cdfso931694a12.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420752; x=1755025552; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fDzHgBJ4HosuuKeQovaY/hyA5EBdxNO5TIzhzBsDnxo=;
        b=BW51GNMWVH2YnQaW3EAEKBoEmp2xSsSuFdC1JyAmya3G5dvRygJX2mHw7svqqzWbgE
         6HV3QWdYCrlSq6I1vSmG2o7xnknLcj1YkTqTr/cNXB3V8B+OyYlI77MPqJZPf41Ka9wa
         xof8napwLg5sCt7w8nbQJvhjK+pd6oi8sxksS0V8r3PHoy/ME8c5iLnC1dCofLFEjhK0
         cD4NqM3A/2ZZzJoU3G9nE9AHAxIOGAuhjH4CGzAtIjDb7nvYq0PAKY9YTTTha5Q9TQ7H
         naVoZ4E3EAsvJilbDjInYGadF6E4XdB0QckCaaXA8fsJSYejV+MkBUKFjbkNjgP0GMPA
         vVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420752; x=1755025552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fDzHgBJ4HosuuKeQovaY/hyA5EBdxNO5TIzhzBsDnxo=;
        b=oKIVBTOg9HbbR1Un5MyCY/z2MLtYmR29Ecvx07+E3bDjNfvKs7MynPHNcGGVetwrXZ
         0KmmTVldlxvJgCrE5nnl6BZZNirJ8QPQXrRqnxnbtxbgSXZSiTc/06ykucvI9NQIUbQ0
         fJlDFNNoN1u7iHKGccxO5sWpJRVvuqQzmLDT+tYUF3zp+lDddPSybY66kqhcAYPjT7A3
         37KidKYzMMQNWGuYlTS3/Ck2bDfp6T5tU5SimpOhZzeOs9sTVIG84K1+CwQJ1aBtUqO5
         agA20yWXhPQPkRZDa+yY5UA5PyLzSn/u21SFhEJVRYPRaw1gIfBywG0TMOs8bYj9/ZLX
         NgEg==
X-Gm-Message-State: AOJu0Yzq7uYh8Y29/aQZDFQiz9n0Xj8eZp02EYAhfcwqJGIGlwa0IHHL
	7Tye97rrpXX2m6zziW/rQBjVcdKO9qAe7pNdiFocbJQEIOVtnqli9/mPv97lX524BrIh3QkMVak
	uh9Ix/g==
X-Google-Smtp-Source: AGHT+IFMZ78t6jlZ4Hg4XAsyFyrTTPw2ebUp6YO0LiIwWC4Id16cUZUsvZRcvyi7Iqfg/ZZ9YEb5MYML3L8=
X-Received: from pjbpa2.prod.google.com ([2002:a17:90b:2642:b0:311:7d77:229f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f85:b0:31f:3cfd:d334
 with SMTP id 98e67ed59e1d1-321161f06d3mr19905789a91.4.1754420752515; Tue, 05
 Aug 2025 12:05:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:21 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-14-seanjc@google.com>
Subject: [PATCH 13/18] KVM: x86/pmu: Open code pmc_event_is_allowed() in its callers
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Open code pmc_event_is_allowed() in its callers, as kvm_pmu_trigger_event()
only needs to check the event filter (both global and local enables are
consulted outside of the loop).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e73c2a44028b..a495ab5d0556 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -491,12 +491,6 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return is_fixed_event_allowed(filter, pmc->idx);
 }
 
-static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
-{
-	return pmc_is_globally_enabled(pmc) && pmc_is_locally_enabled(pmc) &&
-	       check_pmu_event_filter(pmc);
-}
-
 static int reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -507,7 +501,8 @@ static int reprogram_counter(struct kvm_pmc *pmc)
 
 	emulate_overflow = pmc_pause_counter(pmc);
 
-	if (!pmc_event_is_allowed(pmc))
+	if (!pmc_is_globally_enabled(pmc) || !pmc_is_locally_enabled(pmc) ||
+	    !check_pmu_event_filter(pmc))
 		return 0;
 
 	if (emulate_overflow)
@@ -974,7 +969,8 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
 		return;
 
 	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
-		if (!pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
+		if (!pmc_is_globally_enabled(pmc) || !pmc_is_locally_enabled(pmc) ||
+		    !check_pmu_event_filter(pmc) || !cpl_is_matched(pmc))
 			continue;
 
 		kvm_pmu_incr_counter(pmc);
-- 
2.50.1.565.gc32cd1483b-goog


