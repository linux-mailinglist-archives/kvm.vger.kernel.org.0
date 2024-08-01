Return-Path: <kvm+bounces-22870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E5C4944273
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54E38287678
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59D3146D7A;
	Thu,  1 Aug 2024 05:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yrR89s0U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6421014E2DA
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488421; cv=none; b=sSCgcqlrwSaVIaVchWUcXjkbIrc2u5Dn/F5A96g0R3fwaqqvY3FXrGquDr7VKOlm0LDcIo3bXW47cYOMwE2Yr5GjJFpRGhPV4ejIoXZ/bkKVhjDeoorbNgrBMkOvjFT81GvpSB1vNClmN/H26niq98R+7hRZCEkEMwxV7Qllxo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488421; c=relaxed/simple;
	bh=sb75vcFDzulmDk5HWuW7Gc/aQrD0/kwRNadd+yKPw4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QkgSfG7k+UW0ke4sWBlTwjh/GNy76bdwnjhTsFRmI1wwGZTvf3ey6i13nG6BWbxEiIF2SKDh+6e48v8e+hbZOeH/UYl70pKcs8bBn+A0tbAEe9fv38lK6l33gGVFolaqVhQujDrN2KclMk/5kgVHthjn6iQQ2ohoAJ8h1We2flA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yrR89s0U; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-710415c77f8so3215209b3a.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488420; x=1723093220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4LXh7OlsGwBv50TmKUUaww/CB75T5vSYKtw0XszKyZY=;
        b=yrR89s0Uv23V7DMZvRpv36a0YlkWB+7PYzX5AGGBxfZlY1UOAly6LQRNIZdtVVLERS
         1n0h5c9mxr+w0TL/24GzmKcyl7nRGTG44HkW/hV0cVjXEXcQX43nUy/iJFGID+5vxd+r
         BjRX/+J+RC4GCElg+R+hCzmSVQsMrjEhdgN35tjsjtlokVZ9l/LitrImx7Z8z4K72DyN
         0+k4fIZBWkDt31k8r5v99LWjb14VbYaECziCNhSDW2xxRPrmse5kVgfzSHJgqiiwIIOZ
         jDTXvXcylfvfy620jJyM5P03BRtmMa5e5STI+ZI3TJdvKkXZCQqd9t9z0eowU2L9dvMO
         tvWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488420; x=1723093220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4LXh7OlsGwBv50TmKUUaww/CB75T5vSYKtw0XszKyZY=;
        b=HFm6/dHERX269czn7yDWJcFtLT54sgfIDS+N6pr8Uh48Tw23dbziFkEWYsjnaT9wlZ
         PBPO5rgm03tG4cdAwpoNOADInVhqmN1CTS3z/aUwIOsO1Aloa6uXWlyN8DSgx5dDC+ve
         CxqV+XtGED8RLCHpV0lA8Rg0E3Wmca/IftqcYkKqHFI9xlagekY0/t5979Xa7k9GKiuj
         6A66R9fhRhbpSfV7Nlb4BSO+6nRX3wAUsJJ25G1vj2GGF5YncqBzrGIkUFV7pD5Ve4F5
         IkAgXymNISpDC8NZk3PXJ1BCtcLC0SwUarsjO1zy8EksEMvN7gKD7iG76eqa+LAAE24c
         ZpIw==
X-Forwarded-Encrypted: i=1; AJvYcCW8Enw5m9QOGRpE42g/ZhBgspgZa3qRG+deEyyWO5fdOibXBDQZWQ0x0lvr7+l/3spcBGW2TNP6Gx6SOCgT7RDgJlbY
X-Gm-Message-State: AOJu0Yx2Gx8I//9T3WqZiiz0SZd9TitDSSpKC9gB9KClsUkv9k2+HS8Y
	UApzrrownLn5ZZ+PIxoWs08x9nwTxYxhSWUjlQTfvOW9YKuC6MBU7a1Rp+vG5gILA/VJ3Ye7J5R
	D7wOflg==
X-Google-Smtp-Source: AGHT+IES1CCMjPABx118HgeIt67Wypa61/tdVQ+2nUZ0kx+7i1ZzblE7ArThsw7cytD3amKIUuGUyKIxXBq2
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:8583:b0:70e:9e1e:e6ed with SMTP id
 d2e1a72fcca58-7105d6acf2bmr5625b3a.2.1722488419524; Wed, 31 Jul 2024 22:00:19
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:46 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-38-mizhang@google.com>
Subject: [RFC PATCH v3 37/58] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL at VM boundary
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

Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 49 ++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 93c17da8271d..7bf901a53543 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -601,6 +601,8 @@ struct kvm_pmu {
 	u8 event_count;
 
 	bool passthrough;
+	int global_ctrl_slot_in_autoload;
+	int global_ctrl_slot_in_autostore;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 41102658ed21..b126de6569c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4430,6 +4430,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
 			}
 			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
 			m->val[i].value = 0;
+			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autoload = i;
 		}
 		/*
 		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
@@ -4457,6 +4458,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
 				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
 			}
 			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
+			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autostore = i;
 		}
 	} else {
 		if (!(vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)) {
@@ -4467,6 +4469,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
 				m->val[i] = m->val[m->nr];
 				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
 			}
+			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autoload = -ENOENT;
 		}
 		if (!(vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
 			m = &vmx->msr_autoload.host;
@@ -4485,6 +4488,7 @@ static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
 				m->val[i] = m->val[m->nr];
 				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
 			}
+			vcpu_to_pmu(&vmx->vcpu)->global_ctrl_slot_in_autostore = -ENOENT;
 		}
 	}
 
@@ -7272,7 +7276,7 @@ void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
 }
 
-static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
+static void __atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 {
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
@@ -7295,6 +7299,46 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
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
@@ -7405,6 +7449,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	vcpu->arch.cr2 = native_read_cr2();
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		save_perf_global_ctrl_in_passthrough_pmu(vmx);
+
 	vmx->idt_vectoring_info = 0;
 
 	vmx_enable_fb_clear(vmx);
-- 
2.46.0.rc1.232.g9752f9e123-goog


