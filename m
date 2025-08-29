Return-Path: <kvm+bounces-56332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF4FB3BF50
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:33:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13C8F17366D
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09FB032A3E9;
	Fri, 29 Aug 2025 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="YREQ55ny"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8CD31064E;
	Fri, 29 Aug 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481589; cv=none; b=LIy2EBa2nn2vg9EOwNxRKUDj+HN4QRQVP5KuMcqjogPZVdM0V7tSiuBAIYoEBJfA/sQvQ0XNw6fIrMzj2DK5GD2dyaqkzjDUUUoat+glaKinb8b48qokLDSANG9KLTYJYni04oNRZqNLdmweUwiDxf9lMGvmvbUF5ZDI889SvGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481589; c=relaxed/simple;
	bh=EGpGXYVcUI1OeD/pXU/+42Bw7A6JpLCbkE05mGKwu6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O43x4CutMM2o1TTFntv1PeNQL8eX3E+hJu66IMO64K3tU3HLFgu13PjMMGWtGqJtx9ZmmIbv84kxHcaHfhBY+BT3a3dOYE5IP2BFyW3t863SYwP/dpLXDGr8bpAWdz3bAzD+JyKGaG34zMRwOrsvtOT+2UU5ZQQzQWxx7W1NSek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=YREQ55ny; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo482871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:13 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo482871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481534;
	bh=febSAquEyZNB4upRK2xjrDEFN+GEHBHhYW+/4ob2MDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YREQ55nyPG4vo4VnJ7/Yl+E/A336mnU5pBIqRKXfDb/ZKh1dX55tL5YfSKVSZxzzv
	 5eozUDTjosrMeRUp7s+rd766vIfu72UnO9y2THsJ7AoBrx9hOeiHG94snLfKg3k95B
	 MfSy7toC5ajZCqjQPGF+6DhoTUrh1ZTeBvW1BxpHDXPwNCsaMueA8dZrudv36AdBon
	 /mUaYtaoSRmftwSEE7oehedSMJUS6JT96caTKoFe96izbmRUE9C5ASfH/98Jhi87Qb
	 ewieuTz0Vrgk920poWf3eBvTw5xlnX8lJ0ZBMWLwuBieZT1+mYtemP85+DUskd4Wwn
	 hcTIPAssBpfcA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 02/21] KVM: VMX: Initialize VM entry/exit FRED controls in vmcs_config
Date: Fri, 29 Aug 2025 08:31:30 -0700
Message-ID: <20250829153149.2871901-3-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829153149.2871901-1-xin@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
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
index 1f60c04d11fb..dd79d027ea70 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -109,6 +109,9 @@
 #define VM_EXIT_LOAD_CET_STATE                  0x10000000
 #define VM_EXIT_ACTIVATE_SECONDARY_CONTROLS	0x80000000
 
+#define SECONDARY_VM_EXIT_SAVE_IA32_FRED	BIT_ULL(0)
+#define SECONDARY_VM_EXIT_LOAD_IA32_FRED	BIT_ULL(1)
+
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
 #define VM_ENTRY_LOAD_DEBUG_CONTROLS            0x00000004
@@ -122,6 +125,7 @@
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
 #define VM_ENTRY_LOAD_CET_STATE                 0x00100000
+#define VM_ENTRY_LOAD_IA32_FRED			0x00800000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 590e0826ba08..3b5e2805a06d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2623,6 +2623,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		u32 entry_control;
 		u64 exit_control;
 	} const vmcs_entry_exit2_pairs[] = {
+		{ VM_ENTRY_LOAD_IA32_FRED,
+			SECONDARY_VM_EXIT_SAVE_IA32_FRED | SECONDARY_VM_EXIT_LOAD_IA32_FRED },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 840e48a2fcc5..e577af1003d8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -488,7 +488,8 @@ static inline u8 vmx_get_rvi(void)
 	 VM_ENTRY_LOAD_BNDCFGS |					\
 	 VM_ENTRY_PT_CONCEAL_PIP |					\
 	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
-	 VM_ENTRY_LOAD_CET_STATE)
+	 VM_ENTRY_LOAD_CET_STATE |					\
+	 VM_ENTRY_LOAD_IA32_FRED)
 
 #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
@@ -515,7 +516,9 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_ACTIVATE_SECONDARY_CONTROLS)
 
 #define KVM_REQUIRED_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
-#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
+#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS			\
+	     (SECONDARY_VM_EXIT_SAVE_IA32_FRED |			\
+	      SECONDARY_VM_EXIT_LOAD_IA32_FRED)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
-- 
2.51.0


