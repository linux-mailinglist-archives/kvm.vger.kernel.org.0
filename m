Return-Path: <kvm+bounces-16636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D528BC6E3
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 448AC1C210C4
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BA7142654;
	Mon,  6 May 2024 05:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vEX0iRSM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E938B142642
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973474; cv=none; b=U8aqYIj+Z9qXPP9ugnWkpLQHKmx5jTAEuhTIlpYUdrcj5W1r6NEE6i02RQKjqENRvhzuLOx2MJVrm+mBVKn1Nef03WmxZddTPNC6uytDGh8urcBQgWzdyf+RenSPXbOGI2l006Fq5SBhXC6zWvPyjU6vF+zxrd9jJLHCLOIhF5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973474; c=relaxed/simple;
	bh=PQ8TZ4RdD/Jae2B0ivSZpwQfAobjsC7KWmCl3Fg01VE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JEGt95bb4SKDrypf2rup+vOmiQF3v2B5U/5TUdojp0KfWklSJtMPFDQyfPBeQHH7EdE9Yi70rx7y+e0YxnGM0Fivti3ZM55Ul0H8fQgOD1K9bVUrswcXoO8d6VDgWstdhqe5J/0JNv9Ow1XHPYayvQ68aAgLIdhl40dzt3ANkgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vEX0iRSM; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso1891633a12.3
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973472; x=1715578272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=o2/OcGHonEVRuBkvEWvgnmnK73UbAHSL5D04uHdACOo=;
        b=vEX0iRSMdA8vFQNztsM9ZS+k8ip1J8/a9BBBJRbupJMgkS3UMbGcl6knpqoZVGn9RQ
         pCDWhh41nGN1uWEIdp3GMT6H6w+Sw7Do7NFxKg4aDVytZqj5H9GEwNzaMemlwEWCnH/y
         LzazANT+rUFIalas3KKl3/xkhbtTjNqAu/BSSGfPQdMcsU/jGq+FIzORcn2FTZ1xPPZG
         sJqdQHxPDw2QPSGVunQ/y4PpoFjqEJKMW9GCe4BHZQ4wTtt3+XiGtxZpqrgeRMZWNZ9c
         0q9hePGr9In8sXSmIAgU6iASXvJELn9ZHLrabUyeOOwVecxkYOH62wSFZP3bLlw7a+Va
         4lQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973472; x=1715578272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o2/OcGHonEVRuBkvEWvgnmnK73UbAHSL5D04uHdACOo=;
        b=CgdnPPOv0YXuIfnMRPtPmJfm0r5oICvhhusII1OdgcD+U+O4qT/Vgaa3qwlDZs7rf3
         eSZdMJ+YTi8DXDEuXCMFdDR1sDqVlUPJqFXXdXGwYYEbN2683OQvkOhFex97FhPQjig3
         Qd57/uq9Caa+upciNbiiAh1wLanxm6IEmL4fua2yWog7zzSSj4E6mIT2JYc6AjNN0KmV
         pULcklKhBJ7SClwqgroRAsrF7oiotG75ZU+9or9sQ88lVTmJSRPbF5YlSvMpaNY+Ozwx
         AqMWGw1GaWDmpko4khfFxXBEkvRU2Tc2ULKHM89Ybpw3eMxwSMXtQfczNByDJen7/veW
         g1SA==
X-Forwarded-Encrypted: i=1; AJvYcCV0wxG4fKyBZAaYTROalQ3elbbweFXBZeo9X4dexFFWEptZDd41sg1ahbKiib/ufpqNQ3HWtxfHcq1nQyvoENGFms+S
X-Gm-Message-State: AOJu0YzDXQC/AAJ69jLweLI8LyZW21XZcEDxUDeQ2xUria/sgfOFeJJW
	XfuWqOKpes2JIdT9IzOqQTfnIHo/SZ+W8X4w4BKWWl6D0iAzFBXgqBqw90RgCte4NG9eGlqFhTE
	mYeZ6Lg==
X-Google-Smtp-Source: AGHT+IGL7l6kwX5BiDLtsOcJyMOB8di78i9k/4OsIdwSa1KRjrJPvD3bfQxI+9zXl9CrQUBGBQlDp4NrzR3d
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:744a:0:b0:61a:da48:a5fd with SMTP id
 e10-20020a63744a000000b0061ada48a5fdmr24264pgn.6.1714973472106; Sun, 05 May
 2024 22:31:12 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:49 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-25-mizhang@google.com>
Subject: [PATCH v2 24/54] KVM: x86/pmu: Create a function prototype to disable
 MSR interception
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

Add one extra pmu function prototype in kvm_pmu_ops to disable PMU MSR
interception.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h | 1 +
 arch/x86/kvm/cpuid.c                   | 4 ++++
 arch/x86/kvm/pmu.c                     | 5 +++++
 arch/x86/kvm/pmu.h                     | 2 ++
 4 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index fd986d5146e4..1b7876dcb3c3 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -24,6 +24,7 @@ KVM_X86_PMU_OP(is_rdpmc_passthru_allowed)
 KVM_X86_PMU_OP_OPTIONAL(reset)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
+KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
 
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 77352a4abd87..b577ba649feb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -381,6 +381,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
 	kvm_pmu_refresh(vcpu);
+
+	if (is_passthrough_pmu_enabled(vcpu))
+		kvm_pmu_passthrough_pmu_msrs(vcpu);
+
 	vcpu->arch.cr4_guest_rsvd_bits =
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 3afefe4cf6e2..bd94f2d67f5c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1059,3 +1059,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	kfree(filter);
 	return r;
 }
+
+void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
+{
+	static_call_cond(kvm_x86_pmu_passthrough_pmu_msrs)(vcpu);
+}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index e1af6d07b191..63f876557716 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -41,6 +41,7 @@ struct kvm_pmu_ops {
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 	bool (*is_rdpmc_passthru_allowed)(struct kvm_vcpu *vcpu);
+	void (*passthrough_pmu_msrs)(struct kvm_vcpu *vcpu);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
@@ -292,6 +293,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel);
 bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu);
+void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


