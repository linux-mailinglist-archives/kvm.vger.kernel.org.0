Return-Path: <kvm+bounces-43784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD23A961E2
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E4E7188763C
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8737C27605F;
	Tue, 22 Apr 2025 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="YreaAE1b"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292CF267392;
	Tue, 22 Apr 2025 08:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310243; cv=none; b=hMHF0f8IM8cUYruZd+NsDZKmR2ebd1/s0ghf8aexHA1MDL6BZI1I1kfSqj/H/ODKpFnPI3lWLoSXnAWCgCmx4CigLnGjyse3m+6PMrG0VKURLB0CxCDiEeDOW5wHN3H7x/ER3ckt35IBim+K4ezEgsq5zAdSTcsThKmd3SslWVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310243; c=relaxed/simple;
	bh=YLeiixYMp17/XaElSSudzh1yHVlwCyB9YLewUez/bLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2ZM5e1xtdVAphYRfKMJxxvwpdOvFcjZyp+fHkOjdC67PmTs+W9dT/03y2uFauCzHhzBXFTYCreMfbCRvpENOOR5FgUZwHmUb8oQEJkfNobIOjmZRNAh6XO0MLP2zX01mo/UFQlUmgZOIFA4u46pKGwiO4oMM0qjY8N8gV5lrzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=YreaAE1b; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9O1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:40 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9O1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310162;
	bh=mQ56Cdr59Ix+D1+VlxlBq9nRvtyoizRT1tcHxxOdSyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YreaAE1bBxLeGD94yQsuRGK8Y5PYgYhVXVGbG+bCsK/9wMmPjs4xtG1dHGEYBqRda
	 m0bH5rOYOSW0B4cKA9Ir3UM+NiFcxEmQhkuMZSoEYaNCH9AANvR3g6XyHT4ZVDLrPc
	 NcXAWvHSkZHRpxUuL31u3nYoJg5/uqq6pFHs04Dm6VKKeidfHNf8xPRlvo3OMLSMQ7
	 x6UNpM9UCBLesy0o6R5LG84vpbth/c4Ktc2KeL9V5G7iDyZDaVJl60+Ay/Mhj7Rj6+
	 SwOqTsmwZYo63uNUJGzR0YD2XK2Tfls2otD3shWT0Obsj5iA/K+8FZFJw91uTGL479
	 aRcrxR3ykhc5A==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 10/34] x86/msr: Convert __rdmsr() uses to native_rdmsrq() uses
Date: Tue, 22 Apr 2025 01:21:51 -0700
Message-ID: <20250422082216.1954310-11-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__rdmsr() is the lowest level primitive MSR read API, and its direct
use is NOT preferred.  Use its wrapper function native_rdmsrq() instead.

No functional change intended.

This change also prepares for using the alternatives mechanism to access
MSRs: uses of native_rdmsr{,q}() don't need to change, but the approaches
how they perform MSR operations are binary patched during boot time upon
availability of MSR instructions.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/boot/startup/sme.c               | 4 ++--
 arch/x86/events/amd/brs.c                 | 2 +-
 arch/x86/hyperv/hv_vtl.c                  | 4 ++--
 arch/x86/hyperv/ivm.c                     | 2 +-
 arch/x86/include/asm/mshyperv.h           | 2 +-
 arch/x86/include/asm/sev-internal.h       | 2 +-
 arch/x86/kernel/cpu/common.c              | 2 +-
 arch/x86/kernel/cpu/mce/core.c            | 4 ++--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 2 +-
 arch/x86/kvm/vmx/vmx.c                    | 4 ++--
 10 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/boot/startup/sme.c b/arch/x86/boot/startup/sme.c
index 591d6a4d2e59..5e147bf5a0a8 100644
--- a/arch/x86/boot/startup/sme.c
+++ b/arch/x86/boot/startup/sme.c
@@ -524,7 +524,7 @@ void __head sme_enable(struct boot_params *bp)
 	me_mask = 1UL << (ebx & 0x3f);
 
 	/* Check the SEV MSR whether SEV or SME is enabled */
-	sev_status = msr = __rdmsr(MSR_AMD64_SEV);
+	sev_status = msr = native_rdmsrq(MSR_AMD64_SEV);
 	feature_mask = (msr & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
 
 	/*
@@ -555,7 +555,7 @@ void __head sme_enable(struct boot_params *bp)
 			return;
 
 		/* For SME, check the SYSCFG MSR */
-		msr = __rdmsr(MSR_AMD64_SYSCFG);
+		msr = native_rdmsrq(MSR_AMD64_SYSCFG);
 		if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
 			return;
 	}
diff --git a/arch/x86/events/amd/brs.c b/arch/x86/events/amd/brs.c
index 3f5ecfd80d1e..06f35a6b58a5 100644
--- a/arch/x86/events/amd/brs.c
+++ b/arch/x86/events/amd/brs.c
@@ -49,7 +49,7 @@ static __always_inline void set_debug_extn_cfg(u64 val)
 
 static __always_inline u64 get_debug_extn_cfg(void)
 {
-	return __rdmsr(MSR_AMD_DBG_EXTN_CFG);
+	return native_rdmsrq(MSR_AMD_DBG_EXTN_CFG);
 }
 
 static bool __init amd_brs_detect(void)
diff --git a/arch/x86/hyperv/hv_vtl.c b/arch/x86/hyperv/hv_vtl.c
index 13242ed8ff16..c6343e699154 100644
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -149,11 +149,11 @@ static int hv_vtl_bringup_vcpu(u32 target_vp_index, int cpu, u64 eip_ignored)
 	input->vp_context.rip = rip;
 	input->vp_context.rsp = rsp;
 	input->vp_context.rflags = 0x0000000000000002;
-	input->vp_context.efer = __rdmsr(MSR_EFER);
+	input->vp_context.efer = native_rdmsrq(MSR_EFER);
 	input->vp_context.cr0 = native_read_cr0();
 	input->vp_context.cr3 = __native_read_cr3();
 	input->vp_context.cr4 = native_read_cr4();
-	input->vp_context.msr_cr_pat = __rdmsr(MSR_IA32_CR_PAT);
+	input->vp_context.msr_cr_pat = native_rdmsrq(MSR_IA32_CR_PAT);
 	input->vp_context.idtr.limit = idt_ptr.size;
 	input->vp_context.idtr.base = idt_ptr.address;
 	input->vp_context.gdtr.limit = gdt_ptr.size;
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 8209de792388..09a165a3c41e 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -111,7 +111,7 @@ u64 hv_ghcb_hypercall(u64 control, void *input, void *output, u32 input_size)
 
 static inline u64 rd_ghcb_msr(void)
 {
-	return __rdmsr(MSR_AMD64_SEV_ES_GHCB);
+	return native_rdmsrq(MSR_AMD64_SEV_ES_GHCB);
 }
 
 static inline void wr_ghcb_msr(u64 val)
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 15d00dace70f..778444310cfb 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -305,7 +305,7 @@ void hv_set_non_nested_msr(unsigned int reg, u64 value);
 
 static __always_inline u64 hv_raw_get_msr(unsigned int reg)
 {
-	return __rdmsr(reg);
+	return native_rdmsrq(reg);
 }
 
 #else /* CONFIG_HYPERV */
diff --git a/arch/x86/include/asm/sev-internal.h b/arch/x86/include/asm/sev-internal.h
index 9da509e52e11..d259bcec220a 100644
--- a/arch/x86/include/asm/sev-internal.h
+++ b/arch/x86/include/asm/sev-internal.h
@@ -96,7 +96,7 @@ int svsm_perform_call_protocol(struct svsm_call *call);
 
 static inline u64 sev_es_rd_ghcb_msr(void)
 {
-	return __rdmsr(MSR_AMD64_SEV_ES_GHCB);
+	return native_rdmsrq(MSR_AMD64_SEV_ES_GHCB);
 }
 
 static __always_inline void sev_es_wr_ghcb_msr(u64 val)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index de1a25217053..10da3da5b81f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -164,7 +164,7 @@ static void ppin_init(struct cpuinfo_x86 *c)
 
 	/* Is the enable bit set? */
 	if (val & 2UL) {
-		c->ppin = __rdmsr(info->msr_ppin);
+		c->ppin = native_rdmsrq(info->msr_ppin);
 		set_cpu_cap(c, info->feature);
 		return;
 	}
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 1ae75ec7ac95..32286bad75e6 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -121,7 +121,7 @@ void mce_prep_record_common(struct mce *m)
 {
 	m->cpuid	= cpuid_eax(1);
 	m->cpuvendor	= boot_cpu_data.x86_vendor;
-	m->mcgcap	= __rdmsr(MSR_IA32_MCG_CAP);
+	m->mcgcap	= native_rdmsrq(MSR_IA32_MCG_CAP);
 	/* need the internal __ version to avoid deadlocks */
 	m->time		= __ktime_get_real_seconds();
 }
@@ -1298,7 +1298,7 @@ static noinstr bool mce_check_crashing_cpu(void)
 	    (crashing_cpu != -1 && crashing_cpu != cpu)) {
 		u64 mcgstatus;
 
-		mcgstatus = __rdmsr(MSR_IA32_MCG_STATUS);
+		mcgstatus = native_rdmsrq(MSR_IA32_MCG_STATUS);
 
 		if (boot_cpu_data.x86_vendor == X86_VENDOR_ZHAOXIN) {
 			if (mcgstatus & MCG_STATUS_LMCES)
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 9ab033d6856a..185317c6b509 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -482,7 +482,7 @@ int resctrl_arch_pseudo_lock_fn(void *_plr)
 	 * the buffer and evict pseudo-locked memory read earlier from the
 	 * cache.
 	 */
-	saved_msr = __rdmsr(MSR_MISC_FEATURE_CONTROL);
+	saved_msr = native_rdmsrq(MSR_MISC_FEATURE_CONTROL);
 	native_wrmsrq(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits);
 	closid_p = this_cpu_read(pqr_state.cur_closid);
 	rmid_p = this_cpu_read(pqr_state.cur_rmid);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1547bfacd40f..e73c1d5ba6c4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -380,7 +380,7 @@ static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
 	if (!vmx->disable_fb_clear)
 		return;
 
-	msr = __rdmsr(MSR_IA32_MCU_OPT_CTRL);
+	msr = native_rdmsrq(MSR_IA32_MCU_OPT_CTRL);
 	msr |= FB_CLEAR_DIS;
 	native_wrmsrq(MSR_IA32_MCU_OPT_CTRL, msr);
 	/* Cache the MSR value to avoid reading it later */
@@ -7307,7 +7307,7 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 		return;
 
 	if (flags & VMX_RUN_SAVE_SPEC_CTRL)
-		vmx->spec_ctrl = __rdmsr(MSR_IA32_SPEC_CTRL);
+		vmx->spec_ctrl = native_rdmsrq(MSR_IA32_SPEC_CTRL);
 
 	/*
 	 * If the guest/host SPEC_CTRL values differ, restore the host value.
-- 
2.49.0


