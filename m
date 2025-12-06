Return-Path: <kvm+bounces-65427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A2DCACA9B7F
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:32:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC595322EB45
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16CC302151;
	Sat,  6 Dec 2025 00:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=google.com header.i=@google.com header.b="RoABzGP+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8F62F9C3D
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980317; cv=none; b=VhEGrSHZYHe2vHeZ/pdDqd8EwHj0NP+PbAB35mFSlZJvednE4dWzmFUsJuTqxl5H+XRIC8ee+1ArKWHC/0x4hqXRihe4vxcaW4yrKC/dFbXBV7wlGl55uW9vINTbJUFYziD/mblTGdTBiOEZB+bCdq6bT3XPrqWWWRw2lOaf2NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980317; c=relaxed/simple;
	bh=bVIn0sl64UFZr8WJm9qTaFNmU6IY7pnSUpqJCc//7XM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A8nVVY+fD7WgcMM3M37rwCa6TOxz1oXIRl04gWPbfL+fBlU1Q8Qnd5tKhmXnY7RkWFrJGSyQwFaJUvPuWu+k89SKiQ26tL4LQ8g4V174zMGDDV8uDVi/KDLj1yCK4UuIEwEjVCHJV0WScjtqEGxO2+mL3Kqc7THGZqUfYaTiqwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RoABzGP+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3418ad76023so4735139a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980315; x=1765585115; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YVw2IrEv6dj1lN2Egcfs+/+7XHiKcsFRJtntJAtFFMc=;
        b=RoABzGP+UBpFV9s0OwCFx+9KD0W8YqoEdZ19ykGLLvCGhum4htOXC7WShw581iwNVk
         +5N9h64+y23pIHG7j244zid9DVpNOAjJoTFbphQTaMmsF1PBPjx7kUuIxa+0VmQpENfj
         w5CX0WQgY5FumteWOFchGWs6uGuJ0pQmzpecXfqMaMlNmq9hgMNphiH3MK8fxc2Xajlo
         GnFlAv14CnLjBy20nyZg2ndwMZWYTg/b9JSvWNQHhfS5sO7IBlJHXJGSgXUWUjL8wysr
         igSDPgQ+W5V7Va4lkVsrXwaNPedaTi3NSvC2yG8yJRA5YfxwG4SS+/mUh8XPQ7k8Tj4e
         7woA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980315; x=1765585115;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YVw2IrEv6dj1lN2Egcfs+/+7XHiKcsFRJtntJAtFFMc=;
        b=f0eGCyBoW84DAue3iU/2o4g8oFWpW1btofqRlZbfBJikB83XIK7kHIfTok3YbS73KF
         wO3Bct8cnJas5d6uZl7OM37wT9BRuJzNAh0ixv6EehjRdD7GNxcKicr1TbiEMipxz+95
         QSCE1eCQuxxtUuWvhv4w4TetVlKV/qG5Q3Imp0Ko7ispclXikwfMSEJAnz+ZLmedSBmw
         7JtyM+fnkQ1/SPlB4cVWT4b2RGoSXJmPdkVnCpYgodLyl0c9Rj6vhPsFkVYTWxbr0TZ7
         B5o8f3evOf0smhKFxVQRWTe+cZ7H21rFggcvLMoFs2+accC6OhgE6AvZjsOQhtI86nDq
         P/TA==
X-Forwarded-Encrypted: i=1; AJvYcCWy6rG9j2f0vd2BaC8zvJkPikkj8j41NsN4jgnpcUtrRACln399jS3zTnGSITypdgNoGMI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyCARCFvJS7gARyUl7HXfVdLvyrDfr5ea6DQoT9xx9sl0LRIZ7
	Mf9d+stfW8KZqPWkfsfUoYxZaX3ckQKxyRw9CIc4UJvM+jQdsmhOLfVF7Lg0sXghFP2c6l5C0Ui
	tk3lldQ==
X-Google-Smtp-Source: AGHT+IH5qbAxlC2vbzunodq4KUrEtCHMXaoxZK4q8nETSOlwObwaBJfEq5OV6dsDt0Oyzwdbj6cNRcmYmOA=
X-Received: from pjbfs2.prod.google.com ([2002:a17:90a:f282:b0:334:1843:ee45])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec7:b0:349:9d63:8511
 with SMTP id 98e67ed59e1d1-349a25e3b79mr670940a91.25.1764980315199; Fri, 05
 Dec 2025 16:18:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:10 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-35-seanjc@google.com>
Subject: [PATCH v6 34/44] KVM: x86/pmu: Elide WRMSRs when loading guest PMCs
 if values already match
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

When loading a mediated PMU state, elide the WRMSRs to load PMCs with the
guest's value if the value in hardware already matches the guest's value.
For the relatively common case where neither the guest nor the host is
actively using the PMU, i.e. when all/many counters are '0', eliding the
WRMSRs reduces the latency of handling VM-Exit by a measurable amount
(WRMSR is significantly more expensive than RDPMC).

As measured by KVM-Unit-Tests' CPUID VM-Exit testcase, this provides a
a ~25% reduction in latency (4k => 3k cycles) on Intel Emerald Rapids,
and a ~13% reduction (6.2k => 5.3k cycles) on AMD Turin.

Cc: Manali Shukla <manali.shukla@amd.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cb07d9b62bee..fdf1df3100eb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1314,13 +1314,15 @@ static void kvm_pmu_load_guest_pmcs(struct kvm_vcpu *vcpu)
 	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
 		pmc = &pmu->gp_counters[i];
 
-		wrmsrl(gp_counter_msr(i), pmc->counter);
+		if (pmc->counter != rdpmc(i))
+			wrmsrl(gp_counter_msr(i), pmc->counter);
 		wrmsrl(gp_eventsel_msr(i), pmc->eventsel_hw);
 	}
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		pmc = &pmu->fixed_counters[i];
 
-		wrmsrl(fixed_counter_msr(i), pmc->counter);
+		if (pmc->counter != rdpmc(INTEL_PMC_FIXED_RDPMC_BASE | i))
+			wrmsrl(fixed_counter_msr(i), pmc->counter);
 	}
 }
 
-- 
2.52.0.223.gf5cc29aaa4-goog


