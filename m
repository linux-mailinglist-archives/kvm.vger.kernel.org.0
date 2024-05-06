Return-Path: <kvm+bounces-16628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C328BC6DB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:32:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E16E1C20AF1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C1DE1420C9;
	Mon,  6 May 2024 05:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hRKEEHKp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4374C634
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973459; cv=none; b=JLta5hb//sxJFi/gJ66BiUqGEkbFWESuJVlrbXxcA8SvaCkEDrIE7ymTV2grBvp0ilb2THHwjOEBRSDlQyGIZos68QsFF/R0HNnosUFpTmA9VYDsSpgUXgzKD1ga4+lnYEG+XTxD+1dIsGYvBpjviLCm1tlVNcGv/YzGkjpOgqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973459; c=relaxed/simple;
	bh=TcuhI6YtfRV8vZ0wePM12+ttkjHXtSSxEaKOd1hHJh0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RfSrFi5ZKksqJ9NmXgi6C3FYYIczimiA54Fn6Qgax4eo0DJySqPTB5bUrFhLrtYkQTe4uHPvRXJwxpFyckka7i7+l/BWwff0pIzIPVWqpAF9p3QuRS7/RdVyk26YgR3X60a2IM90IUZCSOcjLUAlnMoZaIH7NdEMpmKC1UWiCeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hRKEEHKp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cdfd47de98so1693472a12.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973456; x=1715578256; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NKvAH+qt7PJktsvfzUqbHRpuo0JxEbz4NGbgsjYf9UU=;
        b=hRKEEHKpZCuO+/B8yJDSqHLopW4ABbTBwwDWtq+mr5v7WRJ9BIRmRvkUKrCSFPd255
         Rlc97zDDCZfgFHBfWCab/HXU0rRnMoim28GdwMJDGYfJ6Co1nfW+/SujmBzFxpIpy+6X
         aADrTMzHpw1FlexQ+gc0oyCY9xISSudPxb7a3DyZp8WqCS5NH4x+ntPruf6ne8+E8O0D
         e3EmrXVLUNz/JakFfaFDkZsLEXY+aRcEVSIp6/c3lvbXmIMKPBsgHr/Q8VKFGcD3heFZ
         wzEfE1aU5PSrXIBpJ5gR4AHYG0uSOFj/ks/DPqNjHjLvGviq2mvls8fhjYd3EJbc9UM8
         6aQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973456; x=1715578256;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NKvAH+qt7PJktsvfzUqbHRpuo0JxEbz4NGbgsjYf9UU=;
        b=cqa+MnoOB52v3L9+3zjfMa9xvBCx5vaK/OACZ8qqENWL7hM0EQhfHkQLmA7smKIY5W
         i0xlmFMXtxG4YWqWYPkwBqcGXj3t8trBJURCZIaIttgAuB28BNnqXD3VPj+twe8RxjlV
         d0z69Ig1TI4Zo9pKATFmgSRdUEG1ot3jDyoqh4rhO++RNdUo6YvgXzin0av/ulXk3n9z
         NWj81B1hWYkTVHRHe98VmIlq2vrzXSTaBamkjvaewA5Xeq2ugRGoTJYTHTqUYun6GnXN
         MklLl+YuCO9fKSme6qhnlT374U2jl8iC1ntlcOGBudfWa8v/IdbBYOaaTf1Vl7W8gsuD
         Bj9A==
X-Forwarded-Encrypted: i=1; AJvYcCVgy5n8+4YoQT8vWrgtDslkGO0DnwTIuZmxmlFPvVB7JqjB5xAlXo8N4i84z1LVPwhy/76fRQ1Lv4AbO8atRvnjRO+j
X-Gm-Message-State: AOJu0Ywp15nxZbzg8dL++AvJyYnRql6Ia5ZojZbRis/7H3zLMc72KLHs
	7Lmskbv5ZDCMhImnVeqqXgkKuG4Crg39Mvl73QpUGH74ysOAO0x20QYBr/yCiy/QweVD1OC5ulV
	vNlVuZg==
X-Google-Smtp-Source: AGHT+IHljudBrb+DXXqGDN/Sxw1D8P+it3fJKjcYYX55YSsiQYP7KW59ypVe3sa4y6oLZ9DWsNYC41uXPScd
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a65:6090:0:b0:629:af1b:f853 with SMTP id
 t16-20020a656090000000b00629af1bf853mr284pgu.9.1714973456405; Sun, 05 May
 2024 22:30:56 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:41 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-17-mizhang@google.com>
Subject: [PATCH v2 16/54] KVM: x86/pmu: Plumb through pass-through PMU to vcpu
 for Intel CPUs
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Plumb through pass-through PMU setting from kvm->arch into kvm_pmu on each
vcpu created. Note that enabling PMU is decided by VMM when it sets the
CPUID bits exposed to guest VM. So plumb through the enabling for each pmu
in intel_pmu_refresh().

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/pmu.c              |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 12 +++++++++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9851f0c8e91b..19b924c3bd85 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -592,6 +592,8 @@ struct kvm_pmu {
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
index 12ade343a17e..0ed71f825e6b 100644
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
2.45.0.rc1.225.g2a3ae87e7f-goog


