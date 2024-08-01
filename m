Return-Path: <kvm+bounces-22859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB84944268
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19AC5B213A4
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCC314C582;
	Thu,  1 Aug 2024 05:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F++i3+9+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F1A14B963
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488401; cv=none; b=M8PhqhNIYEdJgq/+ea+cK69Tf/m+U+YC7LrmGJO6ZD+mpbWuJ+RfmRmHAXtXNPkcpUBpLpMSExOXawv5VNa2XT1cTLEBXpQvZxOCKCYOszEfbzRbDwBIbYGcu2gDqIoTpVDRwANPhaIowgyPF65IsEClbP+FiSDiDlsaSWZQqYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488401; c=relaxed/simple;
	bh=ojdh7gBepq1i+vJ4JUVSIiOIMMPBmE/ya/kGYtZEtqg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uzPHemSE+Q+l8HJj7c2ZDq2gscQk/eGJRESeGajgPCJtpIj7lh1h6K5TjRJ5w+7vQHhoS3xxIpFKmayKuZQg9zE6I24Ok3OKjEW37hview2lstIZ2UOkZt2+LXvQ3i2MhaFY9h8JC59GPY2UZV7G8IVSQg5wEy3KvEc4DaF7aVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F++i3+9+; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fee7c9e4a4so50472865ad.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488399; x=1723093199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ay8cbgGhApv7UrgYb1tWI0u4K4Q0eozMprgv8HJaiyI=;
        b=F++i3+9+z9ifooDIAx3k9ljd8lRyB9fFUzeKk1cx5r0bdHIJP32FGnN1X1wuougz6v
         4yLcz0nswu9UbElpWFWL/xOlbo+y5kiAUWkM3JkwNG0f2SJCtNkZUzME9YeNKfGIk6TH
         fIFuDLWAozBWm0umn1U7YbacOE/2h3iASetj8ZZixNNMHSz6vYiEVnhFMg9qZ/I0bKg6
         MmSfB3xy0TB6NCIMpZVZTJSR+MrleDX72XOsG9yh1EWjxpuMZIBKEoQcxrLKw+4Pzgvs
         XROwhc6WuHf450zI31Fi/81nkSt8ZeL9SpelUo5WlRPAdkMtjvQTnjrACvt0ouVYSJmt
         XUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488399; x=1723093199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ay8cbgGhApv7UrgYb1tWI0u4K4Q0eozMprgv8HJaiyI=;
        b=DW4y/rwH1GOYiBgMM7KKHjMYLORp9/m1DNr+pxDiHOvb8Jz4jNzsyzEmifCVn9LIw/
         HpZtX2iPGEGGPbGHQI+itHXvaJdN06UomQOyAt2rVJRH3p+CZHrFgSZJAhQf1Q4VReQu
         XURu6A5hKei4Jqj0lrggdp0t/9lcExsAHklLsDCvtzoYAmfugawhvnh3hZuYZferG+RF
         rjfQi1SrJRg2Nlep07GlYK8blUpeo/KPMhbuRlOwngsizf9pE/8Ek6qeLIATUNPhl9A9
         beTKuYKNcWJ0PWa3YzgzC1EEvafg3dt10qInw3oUMwPqsacsILnNberyDnHCrO45fn23
         zu+w==
X-Forwarded-Encrypted: i=1; AJvYcCVAQjaUCruTYxrFg/2DqYzecUP2trSpcfDsa1y3owwkmdrl76c5OEKPF17L8mS3w5Wo+jWEbK+XIbWUd3lhDubtYE8L
X-Gm-Message-State: AOJu0Yzswho1D7XhoxM2iNToBuh/w2XdmAoqL/g/ttWlYoPZFPk9HtwA
	/5t0JzAiOZPAZva272BnHyCJUytv7Ww1tSx+feZRZYbM08iS4EXph91r29t7z+9r9j7+po+vNzl
	9wgXYXA==
X-Google-Smtp-Source: AGHT+IEwEBLnMnRl/c01wVz7uda9D8/WxO5N/unYavTUeXIqaEhGa1vexGz1gywI9cCh9deL5W3O+pD2i5B7
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:903:41c4:b0:1fb:5f82:6a61 with SMTP id
 d9443c01a7336-1ff4ce7a0d6mr958315ad.5.1722488399367; Wed, 31 Jul 2024
 21:59:59 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:35 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-27-mizhang@google.com>
Subject: [RFC PATCH v3 26/58] KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
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

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

In PMU passthrough mode, there are three requirements to manage
IA32_PERF_GLOBAL_CTRL:
 - guest IA32_PERF_GLOBAL_CTRL MSR must be saved at vm exit.
 - IA32_PERF_GLOBAL_CTRL MSR must be cleared at vm exit to avoid any
   counter of running within KVM runloop.
 - guest IA32_PERF_GLOBAL_CTRL MSR must be restored at vm entry.

Introduce vmx_set_perf_global_ctrl() function to auto switching
IA32_PERF_GLOBAL_CTR and invoke it after the VMM finishes setting up the
CPUID bits.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/vmx.h |   1 +
 arch/x86/kvm/vmx/vmx.c     | 117 +++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.h     |   3 +-
 3 files changed, 103 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index d77a31039f24..5ed89a099533 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -106,6 +106,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL      0x40000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 339742350b7a..34a420fa98c5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4394,6 +4394,97 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 	return pin_based_exec_ctrl;
 }
 
+static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
+{
+	u32 vmentry_ctrl = vm_entry_controls_get(vmx);
+	u32 vmexit_ctrl = vm_exit_controls_get(vmx);
+	struct vmx_msrs *m;
+	int i;
+
+	if (cpu_has_perf_global_ctrl_bug() ||
+	    !is_passthrough_pmu_enabled(&vmx->vcpu)) {
+		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmexit_ctrl &= ~VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
+	}
+
+	if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
+		/*
+		 * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm entry.
+		 */
+		if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
+			vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);
+		} else {
+			m = &vmx->msr_autoload.guest;
+			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
+			if (i < 0) {
+				i = m->nr++;
+				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
+			}
+			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
+			m->val[i].value = 0;
+		}
+		/*
+		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
+		 */
+		if (vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
+			vmcs_write64(HOST_IA32_PERF_GLOBAL_CTRL, 0);
+		} else {
+			m = &vmx->msr_autoload.host;
+			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
+			if (i < 0) {
+				i = m->nr++;
+				vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->nr);
+			}
+			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
+			m->val[i].value = 0;
+		}
+		/*
+		 * Setup auto save guest PERF_GLOBAL_CTRL msr at vm exit
+		 */
+		if (!(vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)) {
+			m = &vmx->msr_autostore.guest;
+			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
+			if (i < 0) {
+				i = m->nr++;
+				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
+			}
+			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
+		}
+	} else {
+		if (!(vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)) {
+			m = &vmx->msr_autoload.guest;
+			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
+			if (i >= 0) {
+				m->nr--;
+				m->val[i] = m->val[m->nr];
+				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
+			}
+		}
+		if (!(vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
+			m = &vmx->msr_autoload.host;
+			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
+			if (i >= 0) {
+				m->nr--;
+				m->val[i] = m->val[m->nr];
+				vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->nr);
+			}
+		}
+		if (!(vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)) {
+			m = &vmx->msr_autostore.guest;
+			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
+			if (i >= 0) {
+				m->nr--;
+				m->val[i] = m->val[m->nr];
+				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
+			}
+		}
+	}
+
+	vm_entry_controls_set(vmx, vmentry_ctrl);
+	vm_exit_controls_set(vmx, vmexit_ctrl);
+}
+
 static u32 vmx_vmentry_ctrl(void)
 {
 	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
@@ -4401,17 +4492,10 @@ static u32 vmx_vmentry_ctrl(void)
 	if (vmx_pt_mode_is_system())
 		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
 				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
-	/*
-	 * IA32e mode, and loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically.
-	 */
-	vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
-			  VM_ENTRY_LOAD_IA32_EFER |
-			  VM_ENTRY_IA32E_MODE);
-
-	if (cpu_has_perf_global_ctrl_bug())
-		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-
-	return vmentry_ctrl;
+	 /*
+	  * IA32e mode, and loading of EFER is toggled dynamically.
+	  */
+	return vmentry_ctrl &= ~(VM_ENTRY_LOAD_IA32_EFER | VM_ENTRY_IA32E_MODE);
 }
 
 static u32 vmx_vmexit_ctrl(void)
@@ -4429,12 +4513,8 @@ static u32 vmx_vmexit_ctrl(void)
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
 
-	if (cpu_has_perf_global_ctrl_bug())
-		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-
-	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
-	return vmexit_ctrl &
-		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
+	/* Loading of EFER is toggled dynamically */
+	return vmexit_ctrl & ~VM_EXIT_LOAD_IA32_EFER;
 }
 
 void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
@@ -4777,6 +4857,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(VM_FUNCTION_CONTROL, 0);
 
 	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
@@ -7916,6 +7997,8 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	else
 		exec_controls_setbit(vmx, CPU_BASED_RDPMC_EXITING);
 
+	vmx_set_perf_global_ctrl(vmx);
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7b64e271a931..32e3974c1a2c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -510,7 +510,8 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |                            \
+	       VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
-- 
2.46.0.rc1.232.g9752f9e123-goog


