Return-Path: <kvm+bounces-38263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0C1A36B19
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43379188CD28
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D08B1624CA;
	Sat, 15 Feb 2025 01:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3CKMF/Vc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589A7146D57
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583416; cv=none; b=cpayGsqZdWYY/ynB5vlHBu5CbuPkJJFDMDFZvR2fuWan9b0pVQXw5Oay5dtGoQnuAqY0LKDqOYYZSb6+7qBauCjX5f6c9+d0gODe2DKw8WuKgjxzlOAjYdvGYhB0CWHgR47wewaBSB2/08UBLdLycBP73Sg+7fwAz7e3MYPiPl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583416; c=relaxed/simple;
	bh=g2UtA37LTLnaBI/4XrlLogCALh/D7CCUimiX5kJFwyQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LRLjgYe9rwLGXleYXTSRNvsRJh30LzG6k2V0s9oZ/51YMU7u1m8/MAwpCztbL3qlp90Z17bBgFr17G2Wl4fjTaTky1Ql3r/q4+KRJbbB6q9fYGC5RjIvlDKnYk6mxMn6hki2MQ6DsOqcYVS25MkJA8oY8C8E15X8xnAiZvTj0Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3CKMF/Vc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f46b7851fcso8454012a91.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583413; x=1740188213; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Uy9reQyVdJbAJ0FPCNe5rNP+p5qm8ddnVApJHMSA5Ck=;
        b=3CKMF/Vc++xI95NLGAUGEHLU5n9KLKS0SmoCx3+OyP0EpYKfrSyZ1LAlA0mGhQo+cW
         YyBpkkpxCyCB/XdAgAQKbIDqPe5R2tHAsGN8E2+3XOb4w8v8c3KRJRFDty7gsh/0jRQS
         iDj4iC1RHlmd6pns1CLT27Q5XRieQNEyngBJOUTHkVUKY+9uwjgKE3EyshYKUFQza7gK
         59MRIjIJNz/Pv4CxUQ0RVNBvP4dmE3Jz6eGV0tlSuXXzesG3ki91C4J/mF86mrUj4/eG
         nGDgRYm6nRy3JTgZUYYzhvMqDcvQsNpgbqk+R0FXd837jz3XpZP52QlSXMG+zbocEQ9j
         Ayag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583413; x=1740188213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uy9reQyVdJbAJ0FPCNe5rNP+p5qm8ddnVApJHMSA5Ck=;
        b=UmuXdhBcGnm+e1FGh+MWbPXFpfaG3vUSCVKMoLFWhe7VVm5N6NGBV+EgPOY++T+t2I
         N/JINZH9fcwuA95yjhsgfhQqKk7g+Pf0Q36KApU2GQ+mn/aJ33aXSCJbeoouhfVyTQAQ
         acWzHm8Y/fea2QnCMag+FNQAgT3IfBWLEFjui9IU2ADiyq9baLL+e9QeGOIW3wDBtle7
         nqdPyK4e040zRD2yGl1FtwQsPKwynVI7cJKPNDuhpNQ8znmhpWd5EnEafFJdiwz2BmsF
         yJhhVzX2ff0k5KAMPNptacDPbwVdaVRn/9S4PFo6qvQtgoYc0eXIYaH97BoT4GxY7w8Z
         qA2g==
X-Gm-Message-State: AOJu0Yxa1xJ85g5c/fQFHj2VnZe4/I1qGWl2yrqN7munFs3lMsg5An2a
	oF/tQuXlzqdVp3T0ipKyncG0IqPx+UTCcfbAjn/cJYWUUAx+zO0a+UJdETLOhI8jpyhfASFP6UR
	XNw==
X-Google-Smtp-Source: AGHT+IH3/69V9qwTKWvz/CsJbONgT65RLc3QIgbQavfteLmCbKtUQLUMesOhZ7kFWVm6c4mSl1+6J1UUryc=
X-Received: from pjbeu15.prod.google.com ([2002:a17:90a:f94f:b0:2fc:1eb0:5743])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c8:b0:2ee:ab29:1482
 with SMTP id 98e67ed59e1d1-2fc40f21294mr2286075a91.16.1739583413637; Fri, 14
 Feb 2025 17:36:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:26 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-10-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 09/18] x86: pmu: Use macro to replace
 hard-coded branches event index
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Currently the branches event index is a hard-coded number. User could
add new events and cause the branches event index changes in the future,
but don't notice the hard-coded event index and forget to update the
event index synchronously, then the issue comes.

Thus, replace the hard-coded index to a macro.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index e672b540..befbbe18 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -50,6 +50,22 @@ struct pmu_event {
 	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
+/*
+ * Events index in intel_gp_events[], ensure consistent with
+ * intel_gp_events[].
+ */
+enum {
+	INTEL_BRANCHES_IDX	= 5,
+};
+
+/*
+ * Events index in amd_gp_events[], ensure consistent with
+ * amd_gp_events[].
+ */
+enum {
+	AMD_BRANCHES_IDX	= 2,
+};
+
 char *buf;
 
 static struct pmu_event *gp_events;
@@ -493,7 +509,8 @@ static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
 	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
-	unsigned int branch_idx = pmu.is_intel ? 5 : 2;
+	unsigned int branch_idx = pmu.is_intel ?
+				  INTEL_BRANCHES_IDX : AMD_BRANCHES_IDX;
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
 		/* branch instructions */
-- 
2.48.1.601.g30ceb7b040-goog


