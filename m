Return-Path: <kvm+bounces-16646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4688BC6EE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8031281023
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69879142E84;
	Mon,  6 May 2024 05:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FXAHM5CT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8176D1A8
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973493; cv=none; b=rnq0J4CXGfJcuSrDTJpjfh3QOSHz/1wlJDBzeL82tiHpL7DJkbeDmM9aU/WRCQQ/WNYU8FrEYZhobPpUjxQrYMCWwblTNP8V2ShV3v89XMlcPHkFfWGahMKSu7oq8xrRQdEp+TyUdwR24wW0tdFFFJMzqchcaKY7sNdaW7eRXdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973493; c=relaxed/simple;
	bh=evSli3NAj4WbxdzLmmZfmiPpcNPG89F5e7Sxn5O0/Lo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZRi1A5ZTkvQMRxt6m5H0o6ucU3Lz0h7TAmhVQijyv1qCqWsJp1TO+Vdb3qoCyfKCEDrt0x58cbE4nl1P7FdVO8SBwS/zoK19j68ev82ePhod8uyISESRuz5Zt8xcgr/GRLSj3rRxya+GdOQEvaszRDQCp5ktkBUzb120A4pzJQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FXAHM5CT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2b337e189ecso1315891a91.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973491; x=1715578291; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YkkRhC7xWUKBiiz4GKM9s/sAUAcbbjoLnZssYdYoz/8=;
        b=FXAHM5CT62ojaC0jALrmPCQpIrF9mWgu8A0Zy0Q84nONHhFcknosmcClNYEjGMu+pe
         kxej1kq6jajcWcPTPljx+i0V4AHOmfY1IPo/I4Fxbzju1D3r8RDihKbJatW8Pxutvt/r
         DJxO1oO6PFugcqX5QUUrrgjoA3ZxbOFIUMOpclETAWen8eo2Nq4hWXjPpcvmfWx1oTg5
         /fDNIWvbIkTxdZKIPVzP+FMinjhnSbpRTVDZIPVppOfKCjKa09SkoK3eywwLiUM7jPAP
         MzBIdsgwLzTFjBqMHqi6it1wxab/K5yOqX/8hbSSE57zPG5+46MJH0AYCmczyZScNMQ2
         8DcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973491; x=1715578291;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YkkRhC7xWUKBiiz4GKM9s/sAUAcbbjoLnZssYdYoz/8=;
        b=Bzq2NC/zhiGtPRAleg3TTiGCYdCK6Vi4i+WB9mxHcaF/cH6OydAUgzlAsI0+ScipMR
         qWBQ5nHC98rAKA0ULYZcYzqJrGjTDIqo6pqEYv4HQFhp96Wd5PRWVwksITULI9TGaEHd
         9YQ/xSoqX73ZNfwaqlZ2QUzJpevDjOnnP/7QX2ue+CCDi4R/x6IFCZkLxRDqGd5Vvz8L
         sDwJZw0x1sElyg7jY7Y7X+WXiEHoSrxgfbK2wWbBwBblwRr3RmLf/tMlvk8O4VDWaoQY
         69TLexgKFVRKxBJjZukUuRb0toqYG3GOfVAnpdVf9CHeXHU8+xcDH6McjM8CU0JE4EmL
         wDgg==
X-Forwarded-Encrypted: i=1; AJvYcCVmdLdBsP9xxY+FdoRsmmoouhH1FIAt49A3awGeM6qsqJ9eHGZkXLuv3odIxIyNkQKuL1KsAKqhhF4TtUY7ZeTUcLQd
X-Gm-Message-State: AOJu0YyDccm86yYXseo4o/wAP0jeHOLloQLenaJxM42ENo6s39E1ub2C
	YfYMXIiljVhjHh1y0tJ5/XpqJ0lA9X4X7s2OQy5bmqULtLQLkhsLt5ZJI7ONtDQa7vR05xcv5k7
	+PJccqQ==
X-Google-Smtp-Source: AGHT+IGRTG5gjtCQEnEZ1ORPy9DoaNo2+UcgU5rYTNyOUU5qv0J4oSd+UHDwdytny5jPQc/1hKCguQXHil/m
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:90a:5147:b0:2b3:90eb:7b46 with SMTP id
 k7-20020a17090a514700b002b390eb7b46mr31389pjm.7.1714973491054; Sun, 05 May
 2024 22:31:31 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:59 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-35-mizhang@google.com>
Subject: [PATCH v2 34/54] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL at VM boundary
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

In PMU passthrough mode, use global_ctrl field in struct kvm_pmu as the
cached value. This is convenient for KVM to set and get the value from the
host side. In addition, load and save the value across VM enter/exit
boundary in the following way:

 - At VM exit, if processor supports
   GUEST_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, read guest
   IA32_PERF_GLOBAL_CTRL GUEST_IA32_PERF_GLOBAL_CTRL VMCS field, else read
   it from VM-exit MSR-stroe array in VMCS. The value is then assigned to
   global_ctrl.

 - At VM Entry, if processor supports
   GUEST_VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, read guest
   IA32_PERF_GLOBAL_CTRL from GUEST_IA32_PERF_GLOBAL_CTRL VMCS field, else
   read it from VM-entry MSR-load array in VMCS. The value is then
   assigned to global ctrl.

Implement the above logic into two helper functions and invoke them around
VM Enter/exit boundary.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 49 ++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9857dda8b851..54a56eda77f4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -598,6 +598,8 @@ struct kvm_pmu {
 	u8 event_count;
 
 	bool passthrough;
+	int global_ctrl_slot_in_autoload;
+	int global_ctrl_slot_in_autostore;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 62b5913abdd6..c86b768743a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4421,6 +4421,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
 			}
 			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
 			m->val[i].value = 0;
+			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autoload = i;
 		}
 		/*
 		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
@@ -4448,6 +4449,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
 				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
 			}
 			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
+			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autostore = i;
 		}
 	} else {
 		if (!(vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)) {
@@ -4458,6 +4460,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
 				m->val[i] = m->val[m->nr];
 				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
 			}
+			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autoload = -ENOENT;
 		}
 		if (!(vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
 			m = &vmx->msr_autoload.host;
@@ -4476,6 +4479,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
 				m->val[i] = m->val[m->nr];
 				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
 			}
+			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autostore = -ENOENT;
 		}
 	}
 
@@ -7236,7 +7240,7 @@ static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
 }
 
-static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
+static void __atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 {
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
@@ -7259,6 +7263,46 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
+static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
+	int i;
+
+	if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL) {
+		pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
+	} else {
+		i = pmu->global_ctrl_slot_in_autostore;
+		pmu->global_ctrl = vmx->msr_autostore.guest.val[i].value;
+	}
+}
+
+static void load_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
+	u64 global_ctrl = pmu->global_ctrl;
+	int i;
+
+	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
+		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
+	} else {
+		i = pmu->global_ctrl_slot_in_autoload;
+		vmx->msr_autoload.guest.val[i].value = global_ctrl;
+	}
+}
+
+static void __atomic_switch_perf_msrs_in_passthrough_pmu(struct vcpu_vmx *vmx)
+{
+	load_perf_global_ctrl_in_passthrough_pmu(vmx);
+}
+
+static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
+{
+	if (is_passthrough_pmu_enabled(&vmx->vcpu))
+		__atomic_switch_perf_msrs_in_passthrough_pmu(vmx);
+	else
+		__atomic_switch_perf_msrs(vmx);
+}
+
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7369,6 +7413,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	vcpu->arch.cr2 = native_read_cr2();
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		save_perf_global_ctrl_in_passthrough_pmu(vmx);
+
 	vmx->idt_vectoring_info = 0;
 
 	vmx_enable_fb_clear(vmx);
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


