Return-Path: <kvm+bounces-53296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A0CA1B0F9CF
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:58:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC8057B6E1E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12143246789;
	Wed, 23 Jul 2025 17:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="mSZK8gnI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A69523D288;
	Wed, 23 Jul 2025 17:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293282; cv=none; b=TvAXGg01ALTYN7M9HzeOMcdA4ZRBZQj3VCEswUwrSkXjtY4j9/gIFgiL0LegFEZ9GhPFa4hPuqmsLpkznLWOBOdwdJJGrFJRHP1kpdeQFG/NXMu1e8VYstFCtEQ2V0IGB1eVoXF5u7wZNG77YxSwMn9lr5QKjoNU+Jldg1HFJwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293282; c=relaxed/simple;
	bh=/gutJcM4arTMByvbZfk3KluI2+D980tBXtJ5GhFHKZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKjxDjZgguCCNtRJ5QC27xMF7J62D0miXP+QHrtAKroF4S4mcIprgQfmQnXn2/GyK9k312jT1M5G1Z8vMPRW2KjCj+3cKeVUwgDkRxjMiSSLrj+TKzr+nMlQm04EdjaQ0HWgOcvl0Rk1BfgtuBUvxZ9cuIYRO2IePhPKddZwLHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=mSZK8gnI; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrfxq1284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:47 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrfxq1284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293228;
	bh=GJkPKHhxeHZQ2rloiYOXgmmG+qEVAmh+lbVKbqnN2ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSZK8gnIvlS3ck43HMHNXsdBBJaeF7Brl8Coo0nIcMAhMKzJAdWZKp7Pe0b1V/3Ny
	 GvKEUqQ7iNqzE87Lwt0X/B0P76Z3Vv3Hbu3u9oxb2RZmEgPfAMbCZA3laq680WGFIo
	 l3ILhK/iL5/35l9gi8oaPOP1KTm/EKd0f669vgrOPUhsFkfHwfqedWh+9wMlhFykDW
	 ONeV2Dbbhj5rQt8Rvm8rtn67XOvevTXik16IK7blGeBZOpTILfvvHtEJoUIM4pWsVE
	 6UfUL/za/h/SRVy2Icbk1fZQ9rVSB6TYBaXVpoB3AFPZ3F51MItt7gqr+La/0MLr4C
	 GK9nlxaisOmXw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 02/23] KVM: VMX: Initialize VM entry/exit FRED controls in vmcs_config
Date: Wed, 23 Jul 2025 10:53:20 -0700
Message-ID: <20250723175341.1284463-3-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Setup VM entry/exit FRED controls in the global vmcs_config for proper
FRED VMCS fields management:
  1) load guest FRED state upon VM entry.
  2) save guest FRED state during VM exit.
  3) load host FRED state during VM exit.

Also add FRED control consistency checks to the existing VM entry/exit
consistency check framework.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---

Change in v5:
* Remove the pair VM_ENTRY_LOAD_IA32_FRED/VM_EXIT_ACTIVATE_SECONDARY_CONTROLS,
  since the secondary VM exit controls are unconditionally enabled anyway, and
  there are features other than FRED needing it (Chao Gao).
* Add TB from Xuelian Guo.

Change in v4:
* Do VM exit/entry consistency checks using the new macro from Sean
  Christopherson.

Changes in v3:
* Add FRED control consistency checks to the existing VM entry/exit
  consistency check framework (Sean Christopherson).
* Just do the unnecessary FRED state load/store on every VM entry/exit
  (Sean Christopherson).
---
 arch/x86/include/asm/vmx.h | 4 ++++
 arch/x86/kvm/vmx/vmx.c     | 2 ++
 arch/x86/kvm/vmx/vmx.h     | 7 +++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 97f7e0545534..1879de94457d 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -108,6 +108,9 @@
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
 #define VM_EXIT_ACTIVATE_SECONDARY_CONTROLS	0x80000000
 
+#define SECONDARY_VM_EXIT_SAVE_IA32_FRED	BIT_ULL(0)
+#define SECONDARY_VM_EXIT_LOAD_IA32_FRED	BIT_ULL(1)
+
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
 #define VM_ENTRY_LOAD_DEBUG_CONTROLS            0x00000004
@@ -120,6 +123,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_IA32_FRED			0x00800000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 85632de1dddb..463fc4a65788 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2591,6 +2591,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		u32 entry_control;
 		u64 exit_control;
 	} const vmcs_entry_exit2_pairs[] = {
+		{ VM_ENTRY_LOAD_IA32_FRED,
+			SECONDARY_VM_EXIT_SAVE_IA32_FRED | SECONDARY_VM_EXIT_LOAD_IA32_FRED },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 20194412bed3..32829f98af2f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -484,7 +484,8 @@ static inline u8 vmx_get_rvi(void)
 	 VM_ENTRY_LOAD_IA32_EFER |					\
 	 VM_ENTRY_LOAD_BNDCFGS |					\
 	 VM_ENTRY_PT_CONCEAL_PIP |					\
-	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
+	 VM_ENTRY_LOAD_IA32_FRED)
 
 #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
@@ -510,7 +511,9 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_ACTIVATE_SECONDARY_CONTROLS)
 
 #define KVM_REQUIRED_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
-#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
+#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS			\
+	     (SECONDARY_VM_EXIT_SAVE_IA32_FRED |			\
+	      SECONDARY_VM_EXIT_LOAD_IA32_FRED)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
-- 
2.50.1


