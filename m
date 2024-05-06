Return-Path: <kvm+bounces-16657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FB38BC6F9
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53E00B21A6D
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E9E14430B;
	Mon,  6 May 2024 05:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S81asPo7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F77143C7E
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973514; cv=none; b=NLsds5NqEyxZEzwxjweNoI+jBCviKA54NRvGY9V912vQnZ4TnX6s1Bh+5VZf1qUd5sEF/HwTmuGqxm1v4z/F6aHpw3E7q4juMrquLY8EeEUbMBkJPShZcnq5/i/8V/Er+40xiSJbLttzI5KxTTKYjjxjbjzEn1T37HEbdeGPZ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973514; c=relaxed/simple;
	bh=laZKn7B0LzkFdKqeIbjSF2U2rTiZjXhjWBNsLqKIUgE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gGRo1i8M7SXhO6HPqmrGdqbaoD2Z1qrtK6kteb7Ws56b85wifTC5nwWLT4zpCKqLidi+/JrcaPgLi9J69MAAdoAeWAO4bTVRHlSOjRxF6KXvWmkOPs1Zgsv8ZCP7k0J4zwk76ufNPu/gvpa5fF8nXBST+Xa5KwFjG6+zZevO6Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S81asPo7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-61d486c9430so1456171a12.3
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973512; x=1715578312; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HQ2MPUey0DqjdXm+LVGYB7JNvbFzV0Tsq+/sM5aPI9M=;
        b=S81asPo7aCOuwLHEUtRsH6T1hXL0hpoFH0pfJBh3XWNcSvdRHyfkRkOWNOhQ3QAVxw
         X7V2wQ5InctpgbnKHGwsiMevk/o+qD5ggZnEPN3buW7eAvE9QtaPt+z6nugxJ9Si4Hc+
         JRX7G5nPXP81go/Z/V/yS+z5wPRdjIsXrNc+37E2YI1k5PBbpKUwI29Wems3U1gLeWXn
         0uT3gguqf1DiZ/z14Zgs0QjBBlr1NP/SNNDRj/s7EeOV+glrMMsPePitLUW91Ccm9xQO
         4CQNkaW2l/uR/Vm6Ge+w/DU/XEWak8M7Uk1333xbdG5yvBgUFajofevdgX61cbbkD12G
         RAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973512; x=1715578312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HQ2MPUey0DqjdXm+LVGYB7JNvbFzV0Tsq+/sM5aPI9M=;
        b=Ps1II4b9i+LuzbvO6VcPV6uXEot8hoLzlAtiNyx0VNp6Fc4HsuyNXxswAGnR3q+X5A
         qZG//6x++YCdWEEtE73Qf8ZImwtL9qDSs3imL6OioNcBHAOEWkQZELNofkZMzf4nMQHY
         TkGCxPUGYeQgbClmeq8SggW85ZMyHn9tsY7QvZzQEsIUAkzxd4JUNYaeTEeG44KXtxms
         WWgTBf8iR83ObPceSDoiqHgIa35XXSBosD3Q4IsWURDXDEvQxDBf24AcihzIyxuFVbXv
         GQYsmEbYorV6RHF9SWw+/pRdVRBpwTBHp7UExIn+yIc5YJgsyON4swNup11AmuTs363M
         avJA==
X-Forwarded-Encrypted: i=1; AJvYcCXCK3bpYIK7PugHL8v5k9hOw6rhHt2xVoj+eWeY2iy+FmOenrRkWYMuy6Au8GH/WuhNEUN/bi48FqQSAgaA/61FfTwd
X-Gm-Message-State: AOJu0YwoHCo1ptv/YUWDQMHM69nUDVq5kxTYR80VI4wszFFV5DM4Phhq
	7izOMk2cQkVyPpLS7WmeaGm/K4DR8VhUpIDu7x5wYA+9atK0NGbE/RdMgRXoDY/SGE2hFYmlPa4
	YRpeYrg==
X-Google-Smtp-Source: AGHT+IFOlgLzRAeS9zU5lJjb1jj3/UeA3eJhFLajc1x1mTDrCNrtnUNRBqely0Cnz9QCdE2MRxm/rx+ZHehW
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a02:483:b0:5e8:58ac:173 with SMTP id
 bw3-20020a056a02048300b005e858ac0173mr23965pgb.8.1714973512262; Sun, 05 May
 2024 22:31:52 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:10 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-46-mizhang@google.com>
Subject: [PATCH v2 45/54] KVM: nVMX: Add nested virtualization support for
 passthrough PMU
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

Add nested virtualization support for passthrough PMU by combining the MSR
interception bitmaps of vmcs01 and vmcs12. Readers may argue even without
this patch, nested virtualization works for passthrough PMU because L1 will
see Perfmon v2 and will have to use legacy vPMU implementation if it is
Linux. However, any assumption made on L1 may be invalid, e.g., L1 may not
even be Linux.

If both L0 and L1 pass through PMU MSRs, the correct behavior is to allow
MSR access from L2 directly touch HW MSRs, since both L0 and L1 passthrough
the access.

However, in current implementation, if without adding anything for nested,
KVM always set MSR interception bits in vmcs02. This leads to the fact that
L0 will emulate all MSR read/writes for L2, leading to errors, since the
current passthrough vPMU never implements set_msr() and get_msr() for any
counter access except counter accesses from the VMM side.

So fix the issue by setting up the correct MSR interception for PMU MSRs.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/vmx/nested.c | 52 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d05ddf751491..558032663228 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -590,6 +590,55 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
 						   msr_bitmap_l0, msr);
 }
 
+/* Pass PMU MSRs to nested VM if L0 and L1 are set to passthrough. */
+static void nested_vmx_set_passthru_pmu_intercept_for_msr(struct kvm_vcpu *vcpu,
+							  unsigned long *msr_bitmap_l1,
+							  unsigned long *msr_bitmap_l0)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int i;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+						 msr_bitmap_l0,
+						 MSR_ARCH_PERFMON_EVENTSEL0 + i,
+						 MSR_TYPE_RW);
+		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+						 msr_bitmap_l0,
+						 MSR_IA32_PERFCTR0 + i,
+						 MSR_TYPE_RW);
+		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+						 msr_bitmap_l0,
+						 MSR_IA32_PMC0 + i,
+						 MSR_TYPE_RW);
+	}
+
+	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_fixed_counters; i++) {
+		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+						 msr_bitmap_l0,
+						 MSR_CORE_PERF_FIXED_CTR0 + i,
+						 MSR_TYPE_RW);
+	}
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+					 msr_bitmap_l0,
+					 MSR_CORE_PERF_FIXED_CTR_CTRL,
+					 MSR_TYPE_RW);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+					 msr_bitmap_l0,
+					 MSR_CORE_PERF_GLOBAL_STATUS,
+					 MSR_TYPE_RW);
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+					 msr_bitmap_l0,
+					 MSR_CORE_PERF_GLOBAL_CTRL,
+					 MSR_TYPE_RW);
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
+					 msr_bitmap_l0,
+					 MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+					 MSR_TYPE_RW);
+}
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
@@ -691,6 +740,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		nested_vmx_set_passthru_pmu_intercept_for_msr(vcpu, msr_bitmap_l1, msr_bitmap_l0);
+
 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


