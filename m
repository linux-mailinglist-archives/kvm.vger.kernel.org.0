Return-Path: <kvm+bounces-16635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3B38BC6E2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3BE3B21990
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADA2142648;
	Mon,  6 May 2024 05:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OD4kYmIk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C480F142625
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973472; cv=none; b=F8RzExBFp6v5LqXwPvywpiegb18E1wi/icFxN1kkG544zZEdSYxdxhWcV1SZPp3dwA4qtHBVotAIBAkM7Cc1Z2gIHvRPpZeSsP4E/26gBjpVhWo1SEDtnaLgsvRVOrY8CVRu6tJCXahlFnZJEH1LkXFhuaVn+uOdYll2ESc61Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973472; c=relaxed/simple;
	bh=XM29vpecCiZp1KknJCG3naAFJYGZHXZbY/Z/VhhUoho=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A6uNNow/Mh2LPO3b8MXsGZrt3J3Jg+x/vlFPNEQqeqJbhQc1eMvvAJbuwgtQVDLege2ijLrumH7T6EQ+YO1tDBTObRQfq7RxdPAU9DctseytZZd17bxxtofKpwZmdG2d++wXHa7BJvKk/lZUGhWWysTuV8mxpAgdPAcywzOmJyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OD4kYmIk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1ec5ce555f6so16557285ad.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973470; x=1715578270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gTx6noZ6DKNT2htxMj+3XNwZouTTiws51/mPTM/eomo=;
        b=OD4kYmIkVOJPUEvI8wjvqUym1+hnWQ9CKDyqxyKKMCSapFDRur0bybzOEsTYJgCNw+
         Ym39WqIvcHK+uEEoC8JinD3OXIUMP9dOzOQsXFDfP1iOERxsqfY+6bZ/6Rcq2PFqHxyR
         xCwbWByiXlkkwXbbILJioT2DCyRZKttTtTW9TYBToDraFiUlZMVfx1kL1nmUs47vY8fI
         O0guelgsrPB5Hhv6u6luqnouZur3HePlkUPt0SFs+cocTmtRC8YXk/wJN6i7Hcahh9Sc
         Km7zxy+JcAP6ejsLnYPI0d/GltS0CXfVDj3oMcUqV7ngiiSYxMIVb1gS0WyH6TV1Zx3k
         7y2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973470; x=1715578270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gTx6noZ6DKNT2htxMj+3XNwZouTTiws51/mPTM/eomo=;
        b=msPOnBnG9HC0vPVfa/cfIq3TRsH8CSuL7+zw/ZFJ4Asvqmf/ssXGHn4QEusXxWjwEJ
         HJfep1x6YI/lRvaxUE2iFi0j4pzGiBWBO5e1/XGoQydas0LISfxNCASLI9XlJRIPJJPl
         g4vQugcOkqyHPPTndKBFpijnlPOsi7vi2ak95MuLqqgnXUVyFtsE0hQB2THNq/jpFhWd
         FSQMgkfhKtIeTiELPdyjFyOIsfdMNV90kw8dfVHqwEv+fvd7E+vRyd193IxgXGPG9KFe
         g7XfVmFIRYXwADRpKoXoivdxGiQ3zRSqp1uhsVgC0pgRxmagMf1o3v/iQGsAPHQG0UY7
         /fSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcbgPqhXo08fuuqZdqcGkJCzu6uPLs3hdY7RLGe/MTDuOjEr2MT8akmdwo2j16/O/QI/2HHM6+rsJ/N0vDxdtPt9fe
X-Gm-Message-State: AOJu0YwLuds6aL1BUe/LpxxcX8170YFuYa7Cbe6ofv4Ed/tgyw5ZOp4a
	T+GRZ3MjFYKjJF4bQBJ9mwVUt4zkcEEKbhdacUvuPbXuTgzn6N71WzNAlJAzqg1QlUyOyxNVWeV
	0bkeYog==
X-Google-Smtp-Source: AGHT+IFZ0MCw/e7qn2a29netXIAibpfDk0eLQNDd86cqkpu87iBJEfEtaP5K/YWY1fKKve+tYuJCvDKrvZ/v
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:90a:4307:b0:2af:d65f:f89e with SMTP id
 q7-20020a17090a430700b002afd65ff89emr28972pjg.0.1714973470190; Sun, 05 May
 2024 22:31:10 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:48 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-24-mizhang@google.com>
Subject: [PATCH v2 23/54] KVM: x86/pmu: Manage MSR interception for IA32_PERF_GLOBAL_CTRL
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

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/vmx.h |   1 +
 arch/x86/kvm/vmx/vmx.c     | 117 +++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.h     |   3 +-
 3 files changed, 103 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 4dba17363008..9b363e30e40c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -105,6 +105,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL      0x40000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a18ba5ae5376..c9de7d2623b8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4385,6 +4385,97 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
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
@@ -4392,17 +4483,10 @@ static u32 vmx_vmentry_ctrl(void)
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
@@ -4420,12 +4504,8 @@ static u32 vmx_vmexit_ctrl(void)
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
 
 static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
@@ -4763,6 +4843,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(VM_FUNCTION_CONTROL, 0);
 
 	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
@@ -7865,6 +7946,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	else
 		exec_controls_setbit(vmx, CPU_BASED_RDPMC_EXITING);
 
+	vmx_set_perf_global_ctrl(vmx);
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 65786dbe7d60..1b56fac35656 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -504,7 +504,8 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |                            \
+	       VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


