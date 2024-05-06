Return-Path: <kvm+bounces-16614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 769728BC6C8
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 371212816FD
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EA84654B;
	Mon,  6 May 2024 05:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JAZ7xSHq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84136495CC
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973434; cv=none; b=dwZtP5/orCvVfo/mQnFZCZh/XeWK7MmqUWsvxGrXin/vc13aQZy56keVLsWaaINNu51Jrt9lQ5qZa6BnwbXldFaAUzjtfepjWtCmQ04XKkPOsmFYugPKZxtitE0BlXjfPM77wZcM48N0pHl7PpuB5XqdEKWV5ez8gxg81zxeEW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973434; c=relaxed/simple;
	bh=4W0yLa6oBQ/HRA1qRoRsk778I56HckekrC7N/x6LuBQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TOoBGCZxYiWBNXQhqj4sOaPLTyJu5zebxG/k6eaAKSa7Wvr/cQJgIzNlsf/43ovBtwQWLyGfLf1ljz3XyBKOz6UGncd0B34SHAglR6+BXOQKq2swWkVT3N37x5gz1Cp0BIa6D/hFrYMRibFaGTXKCkGzDCKUPAeiaIblC4o+snU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JAZ7xSHq; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f3efd63657so1620127b3a.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973431; x=1715578231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=U8NsbyTwuJobhAQmcgiqFL5cgPms3xpU1WY3K3ROCJw=;
        b=JAZ7xSHq6eUB/GX3CPa222L5XkxUmsXg49hDAXT2AowBeV28tNdJXmXlFLzW/aH5yT
         gz8wZLWLe1raY1/ittOakWy43p9HP53PYvTwrYvoPCd3hgVJfiOaFvgqQaO7pw9/btxV
         07ve/LxbD2QVbI4lDdbQbWa6MLSGd+NHxjuSxTi+K0ts2FGXB6jy4ernKTHRl+08I7X8
         ptBto1iVENLaLK6DN9r2nrjbFrOUZhaMmRdxYRiJTc+MkyPtriC62lBsoe4cG+oaTR+2
         bu8wvHgH99r90Cn7I+s9oXU1pWSKXJyXiQ+LYWKhIuxmPpldsKsOPa+3YC/B1+F4je0P
         yF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973431; x=1715578231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8NsbyTwuJobhAQmcgiqFL5cgPms3xpU1WY3K3ROCJw=;
        b=kPbqrPyrLe6Wiue2sBXWd1uIGszaxQstw1BtFkoR1kMWBp+UJCUtsH79C3x9ICDESY
         57Qwa9JAlGCUTCP9y4Zmr43fcAixVFTR+r08b42ApewmJWmbxKjCZbI4ryF/tA5vstzl
         5oBlrQAXAv66r28A9rv7leYEwlbjwcERs6ALPD35LRV1NfkBmfFjKRxJIgcO7Jk44fr3
         1aAi85rygTEOHSUqqOup3U7YtdnHY7dlEm1VHH2+Rk3OXZ6DjTviVAhkbLPGgf2GHNd9
         oM02Cn5n1nKlsCFlWTjKJOejUllNTKfj4Lvu5DVbchU3lhs11eACONOEufzqbxW2mO+B
         zpTg==
X-Forwarded-Encrypted: i=1; AJvYcCVHXhRcRWvotP6mjhjMxZueG2WGpm3vIoLNpgJrPlP5LVaU/U6e99UcFT21O5/xx1XEMFvj0aSaiPUgezVfUayfr61O
X-Gm-Message-State: AOJu0YygWDlLXeM5HoOu7LU+O0ApC9UCmCOGZAr3Pi6zY7rqBAL3/CZr
	EUX3qqS5MVTgUnLfE6nO4+fsh9NgIHljlFgyqwrBKbaGOmNH1Q2X16evHTbAnZ0RQG7w3/lQ5uF
	h4ys7Tg==
X-Google-Smtp-Source: AGHT+IHmvVH27HQl/P8w/FpVWvPHsGrMZu+/fj4Rdo3TMiGnLUSHb1D2dIB9PAzUg5StYItR8iyUPuTIsG9m
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:3904:b0:6ed:95ce:3417 with SMTP id
 fh4-20020a056a00390400b006ed95ce3417mr271076pfb.5.1714973430736; Sun, 05 May
 2024 22:30:30 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:27 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-3-mizhang@google.com>
Subject: [PATCH v2 02/54] KVM: x86: Snapshot if a vCPU's vendor model is AMD
 vs. Intel compatible
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

From: Sean Christopherson <seanjc@google.com>

Add kvm_vcpu_arch.is_amd_compatible to cache if a vCPU's vendor model is
compatible with AMD, i.e. if the vCPU vendor is AMD or Hygon, along with
helpers to check if a vCPU is compatible AMD vs. Intel.  To handle Intel
vs. AMD behavior related to masking the LVTPC entry, KVM will need to
check for vendor compatibility on every PMI injection, i.e. querying for
AMD will soon be a moderately hot path.

Note!  This subtly (or maybe not-so-subtly) makes "Intel compatible" KVM's
default behavior, both if userspace omits (or never sets) CPUID 0x0 and if
userspace sets a completely unknown vendor.  One could argue that KVM
should treat such vCPUs as not being compatible with Intel *or* AMD, but
that would add useless complexity to KVM.

KVM needs to do *something* in the face of vendor specific behavior, and
so unless KVM conjured up a magic third option, choosing to treat unknown
vendors as neither Intel nor AMD means that checks on AMD compatibility
would yield Intel behavior, and checks for Intel compatibility would yield
AMD behavior.  And that's far worse as it would effectively yield random
behavior depending on whether KVM checked for AMD vs. Intel vs. !AMD vs.
!Intel.  And practically speaking, all x86 CPUs follow either Intel or AMD
architecture, i.e. "supporting" an unknown third architecture adds no
value.

Deliberately don't convert any of the existing guest_cpuid_is_intel()
checks, as the Intel side of things is messier due to some flows explicitly
checking for exactly vendor==Intel, versus some flows assuming anything
that isn't "AMD compatible" gets Intel behavior.  The Intel code will be
cleaned up in the future.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240405235603.1173076-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  1 +
 arch/x86/kvm/cpuid.h            | 10 ++++++++++
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/x86.c              |  2 +-
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16e07a2eee19..6efd1497b026 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -855,6 +855,7 @@ struct kvm_vcpu_arch {
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	struct kvm_hypervisor_cpuid kvm_cpuid;
+	bool is_amd_compatible;
 
 	/*
 	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index bfc0bfcb2bc6..77352a4abd87 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -376,6 +376,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_update_pv_runtime(vcpu);
 
+	vcpu->arch.is_amd_compatible = guest_cpuid_is_amd_or_hygon(vcpu);
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 856e3037e74f..23dbb9eb277c 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -120,6 +120,16 @@ static inline bool guest_cpuid_is_intel(struct kvm_vcpu *vcpu)
 	return best && is_guest_vendor_intel(best->ebx, best->ecx, best->edx);
 }
 
+static inline bool guest_cpuid_is_amd_compatible(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.is_amd_compatible;
+}
+
+static inline bool guest_cpuid_is_intel_compatible(struct kvm_vcpu *vcpu)
+{
+	return !guest_cpuid_is_amd_compatible(vcpu);
+}
+
 static inline int guest_cpuid_family(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 992e651540e8..bf4de6d7e39c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4935,7 +4935,7 @@ static void reset_guest_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 				context->cpu_role.base.level, is_efer_nx(context),
 				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
 				is_cr4_pse(context),
-				guest_cpuid_is_amd_or_hygon(vcpu));
+				guest_cpuid_is_amd_compatible(vcpu));
 }
 
 static void __reset_rsvds_bits_mask_ept(struct rsvd_bits_validate *rsvd_check,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47d9f03b7778..ebcc12d1e1de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3470,7 +3470,7 @@ static bool is_mci_status_msr(u32 msr)
 static bool can_set_mci_status(struct kvm_vcpu *vcpu)
 {
 	/* McStatusWrEn enabled? */
-	if (guest_cpuid_is_amd_or_hygon(vcpu))
+	if (guest_cpuid_is_amd_compatible(vcpu))
 		return !!(vcpu->arch.msr_hwcr & BIT_ULL(18));
 
 	return false;
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


