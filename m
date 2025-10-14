Return-Path: <kvm+bounces-59967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFF7BD6F07
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:14:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id ADD444F6FBD
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36AF25F98A;
	Tue, 14 Oct 2025 01:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="axnOG0Kq"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E00265606;
	Tue, 14 Oct 2025 01:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404271; cv=none; b=LdgVLhVW5nyDtaMJgYHE7MJwEKK/l+Qa7LKSDZqXC1vtbM+LgkpWM7Kq1pArSCFwKh1crrAzAS2ePr5mCl8n6PlFKpetumnI9XEzGmUuZtW+K+cqwGGHNgeec05qO1qe32d+2XaJWQhkJBRAQxinTAlixwkTn+S7U+6ebIj5bZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404271; c=relaxed/simple;
	bh=4qAU/CekUVTMQPdeH8cXgNd9NYz7bBb77S1wyBfW2Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMcz+T/waTtqAF+TfnA7ry6xVc6ok0oXJpIZl6gb5+371U7bxMR8pyMT/nlLZuL3Pg6aa5uIJJhcJtU4XlBLJSft25zbDQC4jCwrymiaZfsrWZPs6c4mvuN2X8Ch+8GWqyHuo8vDq3yAx2ZZ9nww9y8ejsUJZsxZnKA7gPvbKDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=axnOG0Kq; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1T1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:10:00 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1T1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404201;
	bh=Svn5IHqlqVy8iAL66I+/dNlVJcrycsEeFrmaqzlyJFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axnOG0KqKwIl/bVLNdzbdCDXDQHWOIHDGyiztqVd4R2deRawHbWSWLLeCbYqRgeLd
	 dc2T0gboduFwADL1DmeevLzlBCG16eB8rpHQAHiS/qELv8b9xfAvj2/VNWCC1IbBcA
	 ofYIG3cvEFoBr5Z58pA+zWcIy3h0ihrwCf18Yn4ZFiX/CGXQl+7uITEa42zNMd4UsA
	 ap1AYdp3ZQETERMauILcreQNvcPSjLvldEPZAMCPRWBW/PHeySkwk7t0sbmEDEUfEO
	 VFNKrP++pwRDoaRKIHaaBEsZHvxeyUA3fV7lpc/57VE5vkHiuA1d2fR/n+J6jgeg/J
	 pBBKydVb4+2CQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 06/21] KVM: VMX: Initialize VMCS FRED fields
Date: Mon, 13 Oct 2025 18:09:35 -0700
Message-ID: <20251014010950.1568389-7-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
References: <20251014010950.1568389-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Initialize host VMCS FRED fields with host FRED MSRs' value and
guest VMCS FRED fields to 0.

FRED CPU state is managed in 9 new FRED MSRs:
        IA32_FRED_CONFIG,
        IA32_FRED_STKLVLS,
        IA32_FRED_RSP0,
        IA32_FRED_RSP1,
        IA32_FRED_RSP2,
        IA32_FRED_RSP3,
        IA32_FRED_SSP1,
        IA32_FRED_SSP2,
        IA32_FRED_SSP3,
as well as a few existing CPU registers and MSRs:
        CR4.FRED,
        IA32_STAR,
        IA32_KERNEL_GS_BASE,
        IA32_PL0_SSP (also known as IA32_FRED_SSP0).

CR4, IA32_KERNEL_GS_BASE and IA32_STAR are already well managed.
Except IA32_FRED_RSP0 and IA32_FRED_SSP0, all other FRED CPU state
MSRs have corresponding VMCS fields in both the host-state and
guest-state areas.  So KVM just needs to initialize them, and with
proper VM entry/exit FRED controls, a FRED CPU will keep tracking
host and guest FRED CPU state in VMCS automatically.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.

Change in v4:
* Initialize host SSP[1-3] to 0s in vmx_set_constant_host_state()
  because Linux doesn't support kernel shadow stacks (Chao Gao).

Change in v3:
* Use structure kvm_host_values to keep host fred config & stack levels
  (Sean Christopherson).

Changes in v2:
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() to decouple
  KVM's capability to virtualize a feature and host's enabling of a
  feature (Chao Gao).
* Move guest FRED state init into __vmx_vcpu_reset() (Chao Gao).
---
 arch/x86/include/asm/vmx.h | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h         |  3 +++
 3 files changed, 71 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index dd79d027ea70..6f8b8947c60c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -293,12 +293,44 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_IA32_FRED_CONFIG		= 0x0000281a,
+	GUEST_IA32_FRED_CONFIG_HIGH	= 0x0000281b,
+	GUEST_IA32_FRED_RSP1		= 0x0000281c,
+	GUEST_IA32_FRED_RSP1_HIGH	= 0x0000281d,
+	GUEST_IA32_FRED_RSP2		= 0x0000281e,
+	GUEST_IA32_FRED_RSP2_HIGH	= 0x0000281f,
+	GUEST_IA32_FRED_RSP3		= 0x00002820,
+	GUEST_IA32_FRED_RSP3_HIGH	= 0x00002821,
+	GUEST_IA32_FRED_STKLVLS		= 0x00002822,
+	GUEST_IA32_FRED_STKLVLS_HIGH	= 0x00002823,
+	GUEST_IA32_FRED_SSP1		= 0x00002824,
+	GUEST_IA32_FRED_SSP1_HIGH	= 0x00002825,
+	GUEST_IA32_FRED_SSP2		= 0x00002826,
+	GUEST_IA32_FRED_SSP2_HIGH	= 0x00002827,
+	GUEST_IA32_FRED_SSP3		= 0x00002828,
+	GUEST_IA32_FRED_SSP3_HIGH	= 0x00002829,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
 	HOST_IA32_EFER_HIGH		= 0x00002c03,
 	HOST_IA32_PERF_GLOBAL_CTRL	= 0x00002c04,
 	HOST_IA32_PERF_GLOBAL_CTRL_HIGH	= 0x00002c05,
+	HOST_IA32_FRED_CONFIG		= 0x00002c08,
+	HOST_IA32_FRED_CONFIG_HIGH	= 0x00002c09,
+	HOST_IA32_FRED_RSP1		= 0x00002c0a,
+	HOST_IA32_FRED_RSP1_HIGH	= 0x00002c0b,
+	HOST_IA32_FRED_RSP2		= 0x00002c0c,
+	HOST_IA32_FRED_RSP2_HIGH	= 0x00002c0d,
+	HOST_IA32_FRED_RSP3		= 0x00002c0e,
+	HOST_IA32_FRED_RSP3_HIGH	= 0x00002c0f,
+	HOST_IA32_FRED_STKLVLS		= 0x00002c10,
+	HOST_IA32_FRED_STKLVLS_HIGH	= 0x00002c11,
+	HOST_IA32_FRED_SSP1		= 0x00002c12,
+	HOST_IA32_FRED_SSP1_HIGH	= 0x00002c13,
+	HOST_IA32_FRED_SSP2		= 0x00002c14,
+	HOST_IA32_FRED_SSP2_HIGH	= 0x00002c15,
+	HOST_IA32_FRED_SSP3		= 0x00002c16,
+	HOST_IA32_FRED_SSP3_HIGH	= 0x00002c17,
 	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
 	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
 	EXCEPTION_BITMAP                = 0x00004004,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c6477cb36854..07e75c134c32 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1459,6 +1459,15 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 				    (unsigned long)(cpu_entry_stack(cpu) + 1));
 		}
 
+		/* Per-CPU FRED MSRs */
+		if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+#ifdef CONFIG_X86_64
+			vmcs_write64(HOST_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB));
+			vmcs_write64(HOST_IA32_FRED_RSP2, __this_cpu_ist_top_va(ESTACK_NMI));
+			vmcs_write64(HOST_IA32_FRED_RSP3, __this_cpu_ist_top_va(ESTACK_DF));
+#endif
+		}
+
 		vmx->loaded_vmcs->cpu = cpu;
 	}
 }
@@ -4311,6 +4320,17 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	 */
 	vmcs_write16(HOST_DS_SELECTOR, 0);
 	vmcs_write16(HOST_ES_SELECTOR, 0);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+		/* FRED CONFIG and STKLVLS are the same on all CPUs */
+		vmcs_write64(HOST_IA32_FRED_CONFIG, kvm_host.fred_config);
+		vmcs_write64(HOST_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);
+
+		/* Linux doesn't support kernel shadow stacks, thus SSPs are 0s */
+		vmcs_write64(HOST_IA32_FRED_SSP1, 0);
+		vmcs_write64(HOST_IA32_FRED_SSP2, 0);
+		vmcs_write64(HOST_IA32_FRED_SSP3, 0);
+	}
 #else
 	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_ES_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
@@ -4822,6 +4842,17 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	}
 
 	vmx_setup_uret_msrs(vmx);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+		vmcs_write64(GUEST_IA32_FRED_CONFIG, 0);
+		vmcs_write64(GUEST_IA32_FRED_RSP1, 0);
+		vmcs_write64(GUEST_IA32_FRED_RSP2, 0);
+		vmcs_write64(GUEST_IA32_FRED_RSP3, 0);
+		vmcs_write64(GUEST_IA32_FRED_STKLVLS, 0);
+		vmcs_write64(GUEST_IA32_FRED_SSP1, 0);
+		vmcs_write64(GUEST_IA32_FRED_SSP2, 0);
+		vmcs_write64(GUEST_IA32_FRED_SSP3, 0);
+	}
 }
 
 static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -8698,6 +8729,11 @@ __init int vmx_hardware_setup(void)
 
 	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+		rdmsrl(MSR_IA32_FRED_CONFIG, kvm_host.fred_config);
+		rdmsrl(MSR_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);
+	}
+
 	return r;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f3dc77f006f9..0c1fbf75442b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -52,6 +52,9 @@ struct kvm_host_values {
 	u64 xss;
 	u64 s_cet;
 	u64 arch_capabilities;
+
+	u64 fred_config;
+	u64 fred_stklvls;
 };
 
 void kvm_spurious_fault(void);
-- 
2.51.0


