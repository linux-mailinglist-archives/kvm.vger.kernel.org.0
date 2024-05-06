Return-Path: <kvm+bounces-16627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4FE8BC6DA
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E57E61F21FA0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D374CB30;
	Mon,  6 May 2024 05:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PyItCzCd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CC7141991
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973457; cv=none; b=Wx4ZNKyzs1LlsWx9Jlc4Jhv1g6s/m0jQRi5xL+6e5WuXGid95C2oMQhluDdtdW2IfH+0KRdtUjiZZovegqXreJuDcutYPLxKOge9mzR/X/xMAbN7JnCBZTkzBNiek6Pa+fLVyfj1I7Qx4+8nnsne8KCTV+ezJZsKeftXbKxxh3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973457; c=relaxed/simple;
	bh=axXGoCh7l8uzYDbpdd06wjzQ/DYDeeRzm4D2kIW0ztc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uZb6UvNQMScR5IV7eD9ZhIRkRoMFamlY25wmi8tcOdHFBPoHSa3YfvzLSKhdldeaWbaRNw5EFNm+1IBmBmNlgQBUzvAHnaozniW0pzKCAGk52RaylWDr6Wxelne59IY/oFuSxRb2XakcD4BAI5/KVtqyIqPlwXri8SXbyonaLSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PyItCzCd; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61e0c1f7169so48750487b3.0
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973455; x=1715578255; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YiAnoNTTnM32AWlXaYzjbxhPUzFZy9RnLwB57VLfHao=;
        b=PyItCzCdkgNpgllcGh7HifJf23U/mjyw2e2rR+vtfX5rT91LNjreQwPjAbyHyinr1j
         yZwfYWEAkQ4IchUTUFhsJGz+vvbiIipKqTiZQ5TDsdtCnRHGH2acpKgFqycHeWqpdCvl
         ESXQVsrZS15O7cpIvFHJBWct3r0S3WMlcWzXG46faBveGVp89la0exvVajVEWReGhhmu
         W1lYOE/nb2/3t6j/3WpI+UMhz+9q9XsY3spJaN0X9R/0rTbT5C6w61OhfgDeU45JdSE/
         8VJNceR0/gOLPc+zMTexuS0z/B8YGUkW5zcKflf32qnU+gXRyc7jgUAbVeREx+R4emoF
         4OyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973455; x=1715578255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YiAnoNTTnM32AWlXaYzjbxhPUzFZy9RnLwB57VLfHao=;
        b=dPtltRpp2Eizto3gnrBQJj98bKGUEg22F8xWd5egzGIwzbGV21w4w+2JZIRhGXrJw0
         ejNwt/Pr6/K2h3U/BsBm5haB8W/z39ieDsQqLWAWW3rt6lS6wzAusCiF3yqHICw2hIei
         hzWK+m1uXcHE/KJFQpk+zdJsDjbFmHXWP4bnZzczn815yELaCUlajYZrJ8R1FsG5N5vs
         GXGlgriXvSJ4W5NhhNMqJurwSLTVkrjOGFSy3yD4KSVpHj4dwWvBzOkhucMiaAUZTMRb
         75gEnQy20hDzfoiXYt/659tzIcIa36Dn3j6qslYDxMXE3LIRx9OnKFMu3p3We4STv/aq
         nJdw==
X-Forwarded-Encrypted: i=1; AJvYcCUqHGtJZTNuTc2xLkQaZDoWGq9xLb4Fqx9+cvDgVHVkKpAqqhLhRGKw8NQ55gGlcJtkBbmvi4wGPSRRu7gjBAU0R9c3
X-Gm-Message-State: AOJu0YxBC4khXMfDwiiyB7TDDTTfSTXKYHQQ5pY9oI2yF25jA6lhJy3F
	ZFG+gAK7TOEFSn1Gb3Tzdv+PLg5+7ibaOTdOfIdHMxWqR2Y2hpI1BD5jTlQtjNe0Rw73zpwtOjH
	7MiaLCw==
X-Google-Smtp-Source: AGHT+IEZwq4DZsVHGkClTMqS8xYu5RVURZZBSsYyS3F5zpORvWcA+ZqbXl85Qns/C44IKwM8UsVN39Fu2xFG
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:102a:b0:dd9:2782:d1c6 with SMTP id
 x10-20020a056902102a00b00dd92782d1c6mr3579579ybt.1.1714973454896; Sun, 05 May
 2024 22:30:54 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:40 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-16-mizhang@google.com>
Subject: [PATCH v2 15/54] KVM: x86/pmu: Introduce enable_passthrough_pmu
 module parameter
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

Introduce enable_passthrough_pmu as a RO KVM kernel module parameter. This
variable is true only when the following conditions satisfies:
 - set to true when module loaded.
 - enable_pmu is true.
 - is running on Intel CPU.
 - supports PerfMon v4.
 - host PMU supports passthrough mode.

The value is always read-only because passthrough PMU currently does not
support features like LBR and PEBS, while emualted PMU does. This will end
up with two different values for kvm_cap.supported_perf_cap, which is
initialized at module load time. Maintaining two different perf
capabilities will add complexity. Further, there is not enough motivation
to support running two types of PMU implementations at the same time,
although it is possible/feasible in reality.

Finally, always propagate enable_passthrough_pmu and perf_capabilities into
kvm->arch for each KVM instance.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.h              | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  7 +++++--
 arch/x86/kvm/x86.c              |  8 ++++++++
 arch/x86/kvm/x86.h              |  1 +
 5 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6efd1497b026..9851f0c8e91b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1402,6 +1402,7 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 	bool enable_pmu;
+	bool enable_passthrough_pmu;
 
 	u32 notify_window;
 	u32 notify_vmexit_flags;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 4d52b0b539ba..cf93be5e7359 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -208,6 +208,20 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 			enable_pmu = false;
 	}
 
+	/* Pass-through vPMU is only supported in Intel CPUs. */
+	if (!is_intel)
+		enable_passthrough_pmu = false;
+
+	/*
+	 * Pass-through vPMU requires at least PerfMon version 4 because the
+	 * implementation requires the usage of MSR_CORE_PERF_GLOBAL_STATUS_SET
+	 * for counter emulation as well as PMU context switch.  In addition, it
+	 * requires host PMU support on passthrough mode. Disable pass-through
+	 * vPMU if any condition fails.
+	 */
+	if (!enable_pmu || kvm_pmu_cap.version < 4 || !kvm_pmu_cap.passthrough)
+		enable_passthrough_pmu = false;
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2dc68a25a53..af253cfa5c37 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -144,6 +144,8 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 extern bool __read_mostly allow_smaller_maxphyaddr;
 module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 
+module_param(enable_passthrough_pmu, bool, 0444);
+
 #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
 #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
 #define KVM_VM_CR0_ALWAYS_ON				\
@@ -7874,13 +7876,14 @@ static u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
+	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
+	    !enable_passthrough_pmu) {
 		x86_perf_get_lbr(&lbr);
 		if (lbr.nr)
 			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
 	}
 
-	if (vmx_pebs_supported()) {
+	if (vmx_pebs_supported() && !enable_passthrough_pmu) {
 		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
 		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
 			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 51b5a88222ef..4c289fcb34fe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -193,6 +193,10 @@ bool __read_mostly enable_pmu = true;
 EXPORT_SYMBOL_GPL(enable_pmu);
 module_param(enable_pmu, bool, 0444);
 
+/* Enable/disable mediated passthrough PMU virtualization */
+bool __read_mostly enable_passthrough_pmu;
+EXPORT_SYMBOL_GPL(enable_passthrough_pmu);
+
 bool __read_mostly eager_page_split = true;
 module_param(eager_page_split, bool, 0644);
 
@@ -6666,6 +6670,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_lock(&kvm->lock);
 		if (!kvm->created_vcpus) {
 			kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
+			/* Disable passthrough PMU if enable_pmu is false. */
+			if (!kvm->arch.enable_pmu)
+				kvm->arch.enable_passthrough_pmu = false;
 			r = 0;
 		}
 		mutex_unlock(&kvm->lock);
@@ -12564,6 +12571,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
+	kvm->arch.enable_passthrough_pmu = enable_passthrough_pmu;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a8b71803777b..d5cc008e18f5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -330,6 +330,7 @@ extern u64 host_arch_capabilities;
 extern struct kvm_caps kvm_caps;
 
 extern bool enable_pmu;
+extern bool enable_passthrough_pmu;
 
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


