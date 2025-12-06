Return-Path: <kvm+bounces-65416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 861A2CA9D7C
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 02:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 779DA3015124
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 01:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E81E2D877C;
	Sat,  6 Dec 2025 00:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bixWkv78"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B012D5957
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980294; cv=none; b=R+6oAxRwNTmx1DDEwTCXifscFB7O3E8puouCEALtz2QhQZqIVlmKL7ucl/Vzo1GqFLXIa7nxmcr6hHEM77dbTpjofcSA2CN160kzzBEyeXH/vvwV3J/Iu3xG3A7OcrutCj1U8IKU4ekCJirV4hjG0frSVNQVqkcpEUv8nT/96fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980294; c=relaxed/simple;
	bh=O/jVTq5Qhwa5T0yytQs5FBna5XRpIRNeziQvPpiH8po=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a64QIDUEftIw3iT+CZYvUPJJfr2roaYfuqMbUagS8oPRDeei5kJiD/og4FPJoUH8x4q4X/4wKrGkUkOu+kV7/ViOrNo0HRm7a3SHGksH8rT4wd1KBdRdhkG8tm9kxCz6WIIuLERoOjcN563oqnQBasKKHBQQYHxGuDNNXNAg2Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bixWkv78; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7c240728e2aso4692582b3a.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980292; x=1765585092; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XDWqFeiOQLKkxB3EbvG31YUh6Q8If2ANhLHUmz0BNv4=;
        b=bixWkv78EyRWIJkWbMv/yM67O5ssC+QKW+D/0xsnFqPt2hoSkHvtgI2mBiK5hhxxDw
         xJNgh1ow72gdkzPSaDfy3LN03Cejoiy2SqjCoaYyfDIV9hvBG/iYrsEb6doZjzibhgFG
         GMDz58Nwhc20qiDwUH/mgZjoM2jcZv23cT5FXuVaiyXzmOw6x0cE74wbYAAnh38ayiNx
         QlnLw6R1Pv2tZTdJfSbrICf0sCR2XqeinDr93jZ22ubxdnxxJJ3L7TdvUHOvgTmyBxOW
         taf64A9bQqH9gV1zrmNKqzfHdp5hya0rsttG2UeRCCG5XwcR3yVfZLtZ41iSXDaj+wpL
         k4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980292; x=1765585092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XDWqFeiOQLKkxB3EbvG31YUh6Q8If2ANhLHUmz0BNv4=;
        b=nMWrzW7UkO5uWrSRh12jDvP7Ffc/VcfApUosoYT5Yokv0EVvkln++IFRONg6TwtPkl
         2SsTQiIMPbrac1VJFAsfxXEDfbf4CFWrYifrnuV8Eg3PmtbkASi74X35T17V++autaY6
         WdAK3aIEo9UcME+O8z/4z62ibyBmOaU9Hbmh1qMQgva0gwrLIsRHELSDQN3CXK3KI6bL
         2Ruq6s+FBcOSmsEL21n8+rgcwKeFDcppP70RUKFn0unvNnXjl7Li3k4FFRBus1/NYXZn
         w4TYtjGZJx0DnUn5kTcnObusw7ZfYmy486R7LCN7l+NgIbdwBhgI41tIfVrELZM9nagR
         W0mg==
X-Forwarded-Encrypted: i=1; AJvYcCUtuinNaMJTYsR3JM14z7RKHL7Yxk73gjfeJSnHULyXrOgN/LWba5mVcjD869uYgtwY56A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEyI5UefJzqXZefrZX7UZ3IoQcn2P0I2GSCqiLX2PVPrgbYqvd
	iMhYuYWgWde2uvEylt74cfELmGDzZ0R4n2taSNnxsyi5ruZl1O0DxXh5aEfZLXzwulVL5fyKtDN
	y7HNnKA==
X-Google-Smtp-Source: AGHT+IEUzuqWf57QLYzTtVTMaTDzv0I3kjHOLmfOTP6Jt6doQKesYDsCDJnJjl04ZJwHyBMoU/64HyX4VwM=
X-Received: from pgar12.prod.google.com ([2002:a05:6a02:2e8c:b0:b63:2a80:d077])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f81:b0:334:912f:acea
 with SMTP id adf61e73a8af0-366180175c0mr936268637.59.1764980292181; Fri, 05
 Dec 2025 16:18:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:59 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-24-seanjc@google.com>
Subject: [PATCH v6 23/44] KVM: x86/pmu: Bypass perf checks when emulating
 mediated PMU counter accesses
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

When emulating a PMC counter read or write for a mediated PMU, bypass the
perf checks and emulated_counter logic as the counters aren't proxied
through perf, i.e. pmc->counter always holds the guest's up-to-date value,
and thus there's no need to defer emulated overflow checks.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: split from event filtering change, write shortlog+changelog]
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 5 +++++
 arch/x86/kvm/pmu.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 57833f29a746..621722e8cc7e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -381,6 +381,11 @@ static void pmc_update_sample_period(struct kvm_pmc *pmc)
 
 void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
 {
+	if (kvm_vcpu_has_mediated_pmu(pmc->vcpu)) {
+		pmc->counter = val & pmc_bitmask(pmc);
+		return;
+	}
+
 	/*
 	 * Drop any unconsumed accumulated counts, the WRMSR is a write, not a
 	 * read-modify-write.  Adjust the counter value so that its value is
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 356b08e92bc9..9a199109d672 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -111,6 +111,9 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 {
 	u64 counter, enabled, running;
 
+	if (kvm_vcpu_has_mediated_pmu(pmc->vcpu))
+		return pmc->counter & pmc_bitmask(pmc);
+
 	counter = pmc->counter + pmc->emulated_counter;
 
 	if (pmc->perf_event && !pmc->is_paused)
-- 
2.52.0.223.gf5cc29aaa4-goog


