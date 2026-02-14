Return-Path: <kvm+bounces-71084-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMgiOg/Qj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71084-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:29:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7272013AACE
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B237E30BE331
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFD328FFF6;
	Sat, 14 Feb 2026 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3Jy/U5PC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF91529E101
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032436; cv=none; b=uZppffqPEtnIeai8Rx08iHhHSMstSMGQXtiraRUOQFVo1mX6SAkSWAZVeMo3VOhQKThrQ/oV/3e1nUnfR+ztbH3e2wEb7xCjrWfcwIKNiUJslCDLbudHwhQJNP4j+qHDrKfi/f+PEiI2PKLHf+ObAoLTx+3uO+PsU9wP813Pi4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032436; c=relaxed/simple;
	bh=f74NX1koICdcmf3x7Z0AXOlx6psRB/2lx2ODBYt41oE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZGt71K8PpEbUWsjhS6/3+F0Hd5mb4L5YX9s6vU1ti1jfdH+IC13RFe30U99RE6DcDLMiuAoHzHQXZEZpcQ1QKnCgS2vjCm6H1TtEdXZvvhTjcGV6XWJExLgQnXWEYf5+/0uM20cMSFzQXvZw26foXxMbfUqn64uOv47Om3qrkr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3Jy/U5PC; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354bc535546so1515660a91.3
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032433; x=1771637233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qVKdMdext7pNokZXu6Az08qOVw2l9S4d2dq/07UMlK8=;
        b=3Jy/U5PChy8jWuexnNCBmzdUfI2jdqIkBveDClMa9s0jaiZuZPT6PNrInYtzrY2Tto
         e+wuupOJGra2XYb1lsYBIJdDYQpX6N4JzDQB6q3iHlHWoBJGNmSzNWMoPnX4HKhi7v0B
         SCiM2SaH/WMYEWY/oTfDgT9V4b1EUbXH5NoCbDolvFS97psJ3BrGL6mjGVFdNtIX8eH+
         P+g1Pop/DEAFtaRO87VFxMNoeyK24U2q6sDQI0f6JUXHaaKtrd0ocOO0/Sj+MOkje8Ks
         unTm6tax7IGawx54oqPf1vH+HUm5/C06n0VQttcAkS9cRs6/iM2Lqi6pJtxzfo6txjPi
         j5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032433; x=1771637233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qVKdMdext7pNokZXu6Az08qOVw2l9S4d2dq/07UMlK8=;
        b=kRs5dzY+mP7QhAKJmQPvyEx/nfMKqtOiM5YvtN23qlRezlo0CI777fy/OUcv4C5U60
         evoa1gRgM1oPaaOC3Iaqs7DQbfQLiqzopWYOdjX2dJMVys5hFyji9MaCNSwvohExcG4/
         6FKdZlXPVseDHXkeBcWG/rYdlksEMsqVLH+7HJKNwzU/hOYOuwFgW/g74Jlqpc/Butxq
         SXo2SaMr+nlNGMqNpL6bSkI594u0fd80dKK7k8NCg1jqqN7wcxKqYX+ZTc8mBRQFWX/d
         Y5BAsLUBFxiFwVFEVqC2oe2i6udVNwJZvFi0Yc+qzg9Ll1nC4CwlfYNi/GupPstVdze3
         J4Nw==
X-Forwarded-Encrypted: i=1; AJvYcCWbj5Zfy/HV6ATJm98GP+rJclxIKitKFeBzeMFLeMBmvafvACLkt4FAQzTtKa0UmWNPmHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyixVzM/y6WPL9baDdxbxt2y/eDNOoewm8ZkQc2RRlN44+e8SWL
	/czoDBfuKUnW+E8aiJca5iZ7X4lkcpo0pF1IdyjPSOv6ruaqJZE9gHByHyc5NNJRnrP+kLkbZop
	kTCkBTQ==
X-Received: from pjbgi4.prod.google.com ([2002:a17:90b:1104:b0:356:216c:ed75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5282:b0:34c:635f:f855
 with SMTP id 98e67ed59e1d1-3584481e367mr1194611a91.7.1771032433065; Fri, 13
 Feb 2026 17:27:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:50 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-5-seanjc@google.com>
Subject: [PATCH v3 04/16] KVM: VMX: Unconditionally allocate root VMCSes
 during boot CPU bringup
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,storage.googleapis.com:url];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71084-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 7272013AACE
X-Rspamd-Action: no action

Allocate the root VMCS (misleading called "vmxarea" and "kvm_area" in KVM)
for each possible CPU during early boot CPU bringup, before early TDX
initialization, so that TDX can eventually do VMXON on-demand (to make
SEAMCALLs) without needing to load kvm-intel.ko.  Allocate the pages early
on, e.g. instead of trying to do so on-demand, to avoid having to juggle
allocation failures at runtime.

Opportunistically rename the per-CPU pointers to better reflect the role
of the VMCS.  Use Intel's "root VMCS" terminology, e.g. from various VMCS
patents[1][2] and older SDMs, not the more opaque "VMXON region" used in
recent versions of the SDM.  While it's possible the VMCS passed to VMXON
no longer serves as _the_ root VMCS on modern CPUs, it is still in effect
a "root mode VMCS", as described in the patents.

Link: https://patentimages.storage.googleapis.com/c7/e4/32/d7a7def5580667/WO2013101191A1.pdf [1]
Link: https://patentimages.storage.googleapis.com/13/f6/8d/1361fab8c33373/US20080163205A1.pdf [2]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virt.h  | 13 ++++++-
 arch/x86/kernel/cpu/common.c |  2 +
 arch/x86/kvm/vmx/vmx.c       | 58 ++---------------------------
 arch/x86/virt/hw.c           | 71 ++++++++++++++++++++++++++++++++++++
 4 files changed, 89 insertions(+), 55 deletions(-)

diff --git a/arch/x86/include/asm/virt.h b/arch/x86/include/asm/virt.h
index 131b9bf9ef3c..0da6db4f5b0c 100644
--- a/arch/x86/include/asm/virt.h
+++ b/arch/x86/include/asm/virt.h
@@ -2,10 +2,21 @@
 #ifndef _ASM_X86_VIRT_H
 #define _ASM_X86_VIRT_H
 
-#include <linux/types.h>
+#include <linux/percpu-defs.h>
+
+#include <asm/reboot.h>
 
 #if IS_ENABLED(CONFIG_KVM_X86)
 extern bool virt_rebooting;
+
+void __init x86_virt_init(void);
+
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+DECLARE_PER_CPU(struct vmcs *, root_vmcs);
+#endif
+
+#else
+static __always_inline void x86_virt_init(void) {}
 #endif
 
 #endif /* _ASM_X86_VIRT_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e7ab22fce3b5..dda9e41292db 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -71,6 +71,7 @@
 #include <asm/traps.h>
 #include <asm/sev.h>
 #include <asm/tdx.h>
+#include <asm/virt.h>
 #include <asm/posted_intr.h>
 #include <asm/runtime-const.h>
 
@@ -2143,6 +2144,7 @@ static __init void identify_boot_cpu(void)
 	cpu_detect_tlb(&boot_cpu_data);
 	setup_cr_pinning();
 
+	x86_virt_init();
 	tsx_init();
 	tdx_init();
 	lkgs_init();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fc6e3b620866..abd4830f71d8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -580,7 +580,6 @@ noinline void invept_error(unsigned long ext, u64 eptp)
 	vmx_insn_failed("invept failed: ext=0x%lx eptp=%llx\n", ext, eptp);
 }
 
-static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 /*
  * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
@@ -2934,6 +2933,9 @@ static bool __kvm_is_vmx_supported(void)
 		return false;
 	}
 
+	if (!per_cpu(root_vmcs, cpu))
+		return false;
+
 	return true;
 }
 
@@ -3008,7 +3010,7 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 int vmx_enable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
-	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
+	u64 phys_addr = __pa(per_cpu(root_vmcs, cpu));
 	int r;
 
 	if (cr4_read_shadow() & X86_CR4_VMXE)
@@ -3129,47 +3131,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	return -ENOMEM;
 }
 
-static void free_kvm_area(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		free_vmcs(per_cpu(vmxarea, cpu));
-		per_cpu(vmxarea, cpu) = NULL;
-	}
-}
-
-static __init int alloc_kvm_area(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct vmcs *vmcs;
-
-		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
-		if (!vmcs) {
-			free_kvm_area();
-			return -ENOMEM;
-		}
-
-		/*
-		 * When eVMCS is enabled, alloc_vmcs_cpu() sets
-		 * vmcs->revision_id to KVM_EVMCS_VERSION instead of
-		 * revision_id reported by MSR_IA32_VMX_BASIC.
-		 *
-		 * However, even though not explicitly documented by
-		 * TLFS, VMXArea passed as VMXON argument should
-		 * still be marked with revision_id reported by
-		 * physical CPU.
-		 */
-		if (kvm_is_using_evmcs())
-			vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
-
-		per_cpu(vmxarea, cpu) = vmcs;
-	}
-	return 0;
-}
-
 static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		struct kvm_segment *save)
 {
@@ -8566,8 +8527,6 @@ void vmx_hardware_unsetup(void)
 
 	if (nested)
 		nested_vmx_hardware_unsetup();
-
-	free_kvm_area();
 }
 
 void vmx_vm_destroy(struct kvm *kvm)
@@ -8870,10 +8829,6 @@ __init int vmx_hardware_setup(void)
 			return r;
 	}
 
-	r = alloc_kvm_area();
-	if (r)
-		goto err_kvm_area;
-
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
 
 	/*
@@ -8900,11 +8855,6 @@ __init int vmx_hardware_setup(void)
 	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
 	return 0;
-
-err_kvm_area:
-	if (nested)
-		nested_vmx_hardware_unsetup();
-	return r;
 }
 
 void vmx_exit(void)
diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
index df3dc18d19b4..56972f594d90 100644
--- a/arch/x86/virt/hw.c
+++ b/arch/x86/virt/hw.c
@@ -1,7 +1,78 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+#include <linux/errno.h>
 #include <linux/kvm_types.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
 
+#include <asm/perf_event.h>
+#include <asm/processor.h>
 #include <asm/virt.h>
+#include <asm/vmx.h>
 
 __visible bool virt_rebooting;
 EXPORT_SYMBOL_FOR_KVM(virt_rebooting);
+
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+DEFINE_PER_CPU(struct vmcs *, root_vmcs);
+EXPORT_PER_CPU_SYMBOL(root_vmcs);
+
+static __init void x86_vmx_exit(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		free_page((unsigned long)per_cpu(root_vmcs, cpu));
+		per_cpu(root_vmcs, cpu) = NULL;
+	}
+}
+
+static __init int x86_vmx_init(void)
+{
+	u64 basic_msr;
+	u32 rev_id;
+	int cpu;
+
+	if (!cpu_feature_enabled(X86_FEATURE_VMX))
+		return -EOPNOTSUPP;
+
+	rdmsrq(MSR_IA32_VMX_BASIC, basic_msr);
+
+	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
+	if (WARN_ON_ONCE(vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE))
+		return -EIO;
+
+	/*
+	 * Even if eVMCS is enabled (or will be enabled?), and even though not
+	 * explicitly documented by TLFS, the root VMCS  passed to VMXON should
+	 * still be marked with the revision_id reported by the physical CPU.
+	 */
+	rev_id = vmx_basic_vmcs_revision_id(basic_msr);
+
+	for_each_possible_cpu(cpu) {
+		int node = cpu_to_node(cpu);
+		struct page *page;
+		struct vmcs *vmcs;
+
+		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+		if (!page) {
+			x86_vmx_exit();
+			return -ENOMEM;
+		}
+
+		vmcs = page_address(page);
+		vmcs->hdr.revision_id = rev_id;
+		per_cpu(root_vmcs, cpu) = vmcs;
+	}
+
+	return 0;
+}
+#else
+static __init int x86_vmx_init(void) { return -EOPNOTSUPP; }
+#endif
+
+void __init x86_virt_init(void)
+{
+	x86_vmx_init();
+}
-- 
2.53.0.310.g728cabbaf7-goog


