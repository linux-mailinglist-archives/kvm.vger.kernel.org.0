Return-Path: <kvm+bounces-32289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B030C9D52EA
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67D37281ACF
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A441DE899;
	Thu, 21 Nov 2024 18:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ktVOWZII"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8091DE3D8
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215204; cv=none; b=q/DV6E1Btex8E7cy5/BIk72zWUcuOuL8E5gDZiPWY33KzuXCze7bxvxVUNAeIlUQFpBKzyADmTNsWw/TcfqqPgJqadWq4nd+HUiPi+JFddpNtn7rldjRtwgdRKE1dOBjnNgHjkxo42s6FS8bv9N8/5LPxUJy+Ngikfq0rHUZRoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215204; c=relaxed/simple;
	bh=1MOR7DCPmoVrL2EupOMAwcUroCAGOgOeQudXxZyVN2g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Uh4rRIo468IqaMcU8SSvJuD/y6dQY7o9SPdYwU4aJcv/gmCvy1RzWdptrGa22XZH6aOv0GvN83GOc4s7xikrgUqM8NSJQ0q2RmFAo62mKWsDZ6GyKKRESr0HfJMaqFwt3q936DNTyXwTSewgeRQOyXa34DhBOwEtx+VBGXIULZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ktVOWZII; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eae6aba72fso24218117b3.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215201; x=1732820001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yX+GRl14cPObJa/kACzBQrLOUmiZNTxc+R8PcnYIGO8=;
        b=ktVOWZIIM9e6kSmCyKrD20l+GKNugXeKhziRNR5qitJmewhveDSbmql9bIyJ9T+jNp
         vrZjxMwMO3dZW0op2r6VOPwFb9uRu2SDNUCCl8lCgYKjco+U26fepAXc79EnhWfZ3a6A
         xQ+8xBNM9sdW6Fikelon+mBeFOHrF0bnr64KIWbR56Hsw8SwB1WEIte7oFiYsHwVQ+Hj
         unX1vsq2LqutNwCtnA253MTVKR17RUJbPLdni7X9MU8LU4uAg4fKK6CNCI3CObeWccBw
         6yb3flmEGYNFIlTLGWp3fU6mCSrga81+eJKUA3fuY7HqjGYBVkvDRZ8TMvWfNtRz+AFt
         JEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215201; x=1732820001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yX+GRl14cPObJa/kACzBQrLOUmiZNTxc+R8PcnYIGO8=;
        b=igRo8LLtSCyMWhyk61cO87nQA/CXpl4Ba9ac0xISFFUYchweLuxed0X33MLLQSX2K2
         9gTbNIYDHC4flkJPRpY5Tsbi9tTqCmHQ69IYlJcpNLAyfFeL6vbYnKSo+gq+j7U5riKb
         hpUIy6m9osgMxomPpTAqw99FTsLDVB9iWKbpYsIae7JQeKTkQr2WbJsSBVgYw2Si8LbE
         Srgklk8hdCGEhnPiIGvYajl0KxYyLIW/GGsxKaMqmY9Pr2mJYl7C8XxUKdL0/yW4QBjt
         kQ1ilIuMM+XRwDwXo0hRS8NKtO3BGLEnsp/MTfnLGXRnVpKo3eLDQ8zLyimPjlrcOJKy
         r+vQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUuxddOUpsC/OwEJzP9eCuJxlht6bp+2nsg19NtbE+QIMd9nA5ips6In1yCIdO1eLA4jI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi1BGeVQ6l+vEsN6Ydmbece7Tj3geM0S6G9zPUjk9hedadQvs5
	JXjoRbGXx+U4dwqB5KP3WThfUl7OyvV0QvQdNSUy9G7Si67iE6eGoFcIRBIbhp8PojNjAYF2NfU
	zVTPFhA==
X-Google-Smtp-Source: AGHT+IEaIdHhehjQ/cZzYbs1B5PHMTwy0M/hKHYmKCVWAh5XULvcYUBoSgtrQsU3NFy0g50qZrAVQfI3lmYy
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:690c:67c1:b0:6ea:1f5b:1f54 with SMTP id
 00721157ae682-6eee07bb768mr3687b3.0.1732215200906; Thu, 21 Nov 2024 10:53:20
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:52:54 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-3-mizhang@google.com>
Subject: [RFC PATCH 02/22] x86/aperfmperf: Introduce set_guest_[am]perf()
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

KVM guests need access to IA32_APERF and IA32_MPERF to observe their
effective CPU frequency, but intercepting reads of these MSRs is too
expensive since Linux guests read them every scheduler tick (250 Hz by
default). Allow the guest to read these MSRs without interception by
loading guest values into the hardware MSRs.

When loading a guest value into IA32_APERF or IA32_MPERF:
1. Query the current host value
2. Record the offset between guest and host values in a per-CPU variable
3. Load the guest value into the MSR

Modify get_host_[am]perf() to add the per-CPU offset to the raw MSR
value, so that host kernel code can still obtain correct host values
even when the MSRs contain guest values.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/topology.h  |  5 +++++
 arch/x86/kernel/cpu/aperfmperf.c | 31 +++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 2ef9903cf85d7..fef5846c01976 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -302,8 +302,13 @@ static inline void arch_set_max_freq_ratio(bool turbo_disabled) { }
 static inline void freq_invariance_set_perf_ratio(u64 ratio, bool turbo_disabled) { }
 #endif
 
+DECLARE_PER_CPU(u64, host_aperf_offset);
+DECLARE_PER_CPU(u64, host_mperf_offset);
+
 extern u64 get_host_aperf(void);
 extern u64 get_host_mperf(void);
+extern void set_guest_aperf(u64 aperf);
+extern void set_guest_mperf(u64 mperf);
 
 extern void arch_scale_freq_tick(void);
 #define arch_scale_freq_tick arch_scale_freq_tick
diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index 3be5070ba3361..8b66872aa98c1 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -94,20 +94,47 @@ void arch_set_max_freq_ratio(bool turbo_disabled)
 }
 EXPORT_SYMBOL_GPL(arch_set_max_freq_ratio);
 
+DEFINE_PER_CPU(u64, host_aperf_offset);
+DEFINE_PER_CPU(u64, host_mperf_offset);
+
 u64 get_host_aperf(void)
 {
 	WARN_ON_ONCE(!irqs_disabled());
-	return native_read_msr(MSR_IA32_APERF);
+	return native_read_msr(MSR_IA32_APERF) +
+		this_cpu_read(host_aperf_offset);
 }
 EXPORT_SYMBOL_GPL(get_host_aperf);
 
 u64 get_host_mperf(void)
 {
 	WARN_ON_ONCE(!irqs_disabled());
-	return native_read_msr(MSR_IA32_MPERF);
+	return native_read_msr(MSR_IA32_MPERF) +
+		this_cpu_read(host_mperf_offset);
 }
 EXPORT_SYMBOL_GPL(get_host_mperf);
 
+void set_guest_aperf(u64 guest_aperf)
+{
+	u64 host_aperf;
+
+	WARN_ON_ONCE(!irqs_disabled());
+	host_aperf = get_host_aperf();
+	wrmsrl(MSR_IA32_APERF, guest_aperf);
+	this_cpu_write(host_aperf_offset, host_aperf - guest_aperf);
+}
+EXPORT_SYMBOL_GPL(set_guest_aperf);
+
+void set_guest_mperf(u64 guest_mperf)
+{
+	u64 host_mperf;
+
+	WARN_ON_ONCE(!irqs_disabled());
+	host_mperf = get_host_mperf();
+	wrmsrl(MSR_IA32_MPERF, guest_mperf);
+	this_cpu_write(host_mperf_offset, host_mperf - guest_mperf);
+}
+EXPORT_SYMBOL_GPL(set_guest_mperf);
+
 static bool __init turbo_disabled(void)
 {
 	u64 misc_en;
-- 
2.47.0.371.ga323438b13-goog


