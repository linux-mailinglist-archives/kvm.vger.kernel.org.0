Return-Path: <kvm+bounces-42190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21792A74EF0
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65F21188C249
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D8C1DED58;
	Fri, 28 Mar 2025 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="a3SOG3gR"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83D81DC747;
	Fri, 28 Mar 2025 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743181994; cv=none; b=R1XY6HuSqVfZd5c1w2fQ5lARCyl1h1b1SHalvrSoAotbZ6jGlnFvOrIgSGtya8Zr1h4owOVdKW4KAEZOuYei/b5VLKGCtbPpLR1YgL/jittSFMaQNN+H3e8zb+mCc8TaxSNpTZbEp64ybqftRQvE1N6+3SUmXrf1PKFa8E48B7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743181994; c=relaxed/simple;
	bh=abag9AonvLCYy3voC2/uID8NTPKl/BAYAjiPkFNXhQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XojSDp6hR8is32VWGx9HMKs0jlqrhvlVP7zevOjMNkBGAONsDW8sEtTDuDmuAHthu/SyZAZPJritZoBGxQOk6NWYfK58v29XaUUO5oHjyIcl2WsYLAv+wahnpM9GmKJgIRe8mVxc6vC4XH8YazAOoeibQuSTKKu81L/qe1aRiSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=a3SOG3gR; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52SHC6vY2029344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 28 Mar 2025 10:12:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52SHC6vY2029344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743181936;
	bh=LI90Y/ZXpDLk0NabS4prbhHOsL3son9i/mm3krWTyZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3SOG3gRoNIgENNp9p3KAcNEIoFeQSVvy4YV5KyR80oL76F9mz1Z1sSx+LWpAMTtU
	 uWokzqpw25Je/FTfS2hiaxi5FFU59r4gZ7/dKWmvHgT98FFIHVGqCG3z45URZrgQ4+
	 8q9LnAQHW7fwvw3IINxjlXTotprsSRKMHHQENFkPT2nuNuynaF3vQBaz6zZeDCM7ph
	 DI3mlvT/gSV1oL05nthFqjMX8LzfAH7G6NXYWOwplErGUfkoKzP1Iwh27iF03IjJbT
	 oiPPD6tmjrBBYcC0D05cPLxTWqaSx6qlFwLPAfNpolQtt0w3OIUgpIsLPNnmsQwPU0
	 qblVQkn9xccxA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
        chao.gao@intel.com, xin3.li@intel.com
Subject: [PATCH v4 02/19] KVM: VMX: Initialize VM entry/exit FRED controls in vmcs_config
Date: Fri, 28 Mar 2025 10:11:48 -0700
Message-ID: <20250328171205.2029296-3-xin@zytor.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250328171205.2029296-1-xin@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com>
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
Reviewed-by: Chao Gao <chao.gao@intel.com>
---

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
 arch/x86/kvm/vmx/vmx.c     | 3 +++
 arch/x86/kvm/vmx/vmx.h     | 7 +++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 47626773a9e1..5598517617a5 100644
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
index f1348b140e7c..e38545d0dd17 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2634,12 +2634,15 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_IA32_FRED,		VM_EXIT_ACTIVATE_SECONDARY_CONTROLS },
 	};
 
 	struct {
 		u32 entry_control;
 		u64 exit_control;
 	} const vmcs_entry_exit2_pairs[] = {
+		{ VM_ENTRY_LOAD_IA32_FRED,
+			SECONDARY_VM_EXIT_SAVE_IA32_FRED | SECONDARY_VM_EXIT_LOAD_IA32_FRED },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d0e026390d40..d53904db5d1a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -486,7 +486,8 @@ static inline u8 vmx_get_rvi(void)
 	 VM_ENTRY_LOAD_IA32_EFER |					\
 	 VM_ENTRY_LOAD_BNDCFGS |					\
 	 VM_ENTRY_PT_CONCEAL_PIP |					\
-	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
+	 VM_ENTRY_LOAD_IA32_FRED)
 
 #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
@@ -512,7 +513,9 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_ACTIVATE_SECONDARY_CONTROLS)
 
 #define KVM_REQUIRED_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
-#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS (0)
+#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXIT_CONTROLS			\
+	     (SECONDARY_VM_EXIT_SAVE_IA32_FRED |			\
+	      SECONDARY_VM_EXIT_LOAD_IA32_FRED)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
-- 
2.48.1


