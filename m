Return-Path: <kvm+bounces-22852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD76944260
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41404B23136
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1751914A617;
	Thu,  1 Aug 2024 04:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aQZOis27"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE33F14A4D4
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488388; cv=none; b=K+2xIC8DNjBGeRz5x04TjGU2/pZfpFOvqypc1f+BGXGqQfXF3AgX7S+2SXSG1W15q4JXxg7Q7ZPtnZlq/uH/BL80UdO/FMKXPlK29gN6VnEVjuZZJNyzZUksPQAgiDkyXrzofdfQQLnB1jJk+DYhDxO32URmMbDIx1e4GFtBWSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488388; c=relaxed/simple;
	bh=E22tkx3zDeo4zxqMBL7eB1aOxoR/sVYOfdyHuCgXr1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gy0FQMDNxHkCxT6eE9MX4vCF6j7NoQxR1QDHtyy+vtl6hMlRXw1APykNErotDmd2uNIJYrvjLe8X7lVKhYbPJocKhOHob8g6lhOenGzqNqKnnrfSP8/GDa5XurS6dyYymAw7priFw6rIrKobWJF9AVLNnZ5+IjFu1yXp9I+x9I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aQZOis27; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66619cb2d3eso139771277b3.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488386; x=1723093186; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lAIIlQl06GPQqqS5dtZbchIOgiDTPlp/q2IQgaaszaw=;
        b=aQZOis2717LAOgYisVzqOAPo903uENzztzfqiH6fKfAcrXM2nlt3T7he6cvur1a+v1
         t3L2SO06UH5Fc1VtAhX9HT582ijeiN8knK55MJj3nX2QvyKHtoiGDnTTQqzkK60Zq/h2
         4e5a4RClfwsCxCNy02WL49nikOMasFhLw4w2wiBBXll2mGlEfu3jyl+rYHaryExXMR6O
         np0uPHnHN/Fv1Im0VYRAd69WdbUcaHZMhuZRFD8P0OV2KXk+pVM4mwpg73LgMLpl4bir
         aZQJXccDFxRzmypMIhBx7IGmT8eX25grk5J+S5af8HiZpum2oRO/MJ4o4xTTfpYjb2IG
         /03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488386; x=1723093186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lAIIlQl06GPQqqS5dtZbchIOgiDTPlp/q2IQgaaszaw=;
        b=eRcItX/YB1d27g2VKayJE6jS2n/1OFf3C2guoR9+alCfh+DOTM1MqqxzC90nfBKM1m
         HFtclg/n48XDkmK73KdrGWGOi1OcJ7uW2dbUFVn0Rq1CeH2qWm4HJUDqP/EPCxaa+iKY
         dbOAK93NGQDdhUMBx1ufqadvCneVdgrE4BGsXtvPpwip2xqGS+y8ahwwXoAOvlp23PyF
         PvNFRYKYd44XSEKRrWS5XSfPhdt0IZRsuKZnpF+T92CrlAUSjx9RrBftbG5RZcWClCYn
         Pnq7ugRR4UGNlU3XwFIvqUtNY+gxh0isEqcgchaaR8QBOceXQErWzyLPGlfwhOA/9AK5
         XZDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTyoVF/TTbpWce7fsvzsCAexC7tvBt1G0DfNwFjOh9bABjKF0+ij2kdGif2LgkG29dWU6iyCGKbXUpiE27CobqAti8
X-Gm-Message-State: AOJu0Yz6ROCcCXKX5JnlAcpT6xCpUESR2wH3kt9ZWPuqANw8X2KYncgD
	yYubAc9OLNtaPcjjghrI7Adg34VqDcai+XV7iwas78J6UOO0kg4u77QPww+BzRG4+TXq7zhHZWY
	O9nRqOg==
X-Google-Smtp-Source: AGHT+IEcLS+CVskEAhC1qKZwJ4KFeyFPlH+JmrOrYLRNgq6/u9XRbf1EMVU/nXXhW/F6NC8SnzPZxAxE1/Mv
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:690c:85:b0:669:e266:2c56 with SMTP id
 00721157ae682-6874f03562amr1170967b3.6.1722488385912; Wed, 31 Jul 2024
 21:59:45 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:28 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-20-mizhang@google.com>
Subject: [RFC PATCH v3 19/58] KVM: x86/pmu: Plumb through pass-through PMU to
 vcpu for Intel CPUs
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Plumb through pass-through PMU setting from kvm->arch into kvm_pmu on each
vcpu created. Note that enabling PMU is decided by VMM when it sets the
CPUID bits exposed to guest VM. So plumb through the enabling for each pmu
in intel_pmu_refresh().

Co-developed-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 12 +++++++++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a15c783f20b9..4b3ce6194bdb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -595,6 +595,8 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	bool passthrough;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a593b03c9aed..5768ea2935e9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -797,6 +797,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 
 	memset(pmu, 0, sizeof(*pmu));
 	static_call(kvm_x86_pmu_init)(vcpu);
+	pmu->passthrough = false;
 	kvm_pmu_refresh(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index be40474de6e4..e417fd91e5fe 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -470,15 +470,21 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa);
-	if (!entry)
+	if (!entry || !vcpu->kvm->arch.enable_pmu) {
+		pmu->passthrough = false;
 		return;
-
+	}
 	eax.full = entry->eax;
 	edx.full = entry->edx;
 
 	pmu->version = eax.split.version_id;
-	if (!pmu->version)
+	if (!pmu->version) {
+		pmu->passthrough = false;
 		return;
+	}
+
+	pmu->passthrough = vcpu->kvm->arch.enable_passthrough_pmu &&
+			   lapic_in_kernel(vcpu);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
 					 kvm_pmu_cap.num_counters_gp);
-- 
2.46.0.rc1.232.g9752f9e123-goog


