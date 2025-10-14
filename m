Return-Path: <kvm+bounces-59968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 98459BD6F19
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7547D4F72D2
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D122FFDF0;
	Tue, 14 Oct 2025 01:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WAIfhome"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0CC2FF666;
	Tue, 14 Oct 2025 01:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404274; cv=none; b=icSMCA/Og+bhY9Oj2RmLr31iiZZNdroaM4ttx+fUvYZ+sH4NAQ9a97sLLeGjcPchJMlFwn9wWuEAwKu7bBKqd2VwchCPuZ7GAMgUJCcPsg1NlIkNCyJS9qjMOLKYQ7b3onxJV9w7FNkBahp4VDSBEaPWO5llxs/MSrzyL89r6Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404274; c=relaxed/simple;
	bh=PRgNw8+DpyWqIKiGDIuiM04mCn/JXAudwfJ7jdF0tjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBlyBywJ+7tOz2AfnyzUa/hWSnu/07QC5IZpoBXANqV/P0hsswPpJp8vyyXr//T2KfJj2NOSmYWqDKsEwweY/1td+CUrnFCisSpC8laG5IrHnWbqe26Lf1iznCpUXdwotg2d0Lw2J68sz8C2yu8K7SpohaFTGjLW6gtFLAoSxKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WAIfhome; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1P1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:09:56 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1P1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404197;
	bh=RuCCs0vzhv8Sxi9AkluLc3vZa3XQmGm8bw39m275Ogo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAIfhomefLUYfyCi8Gy54GxkUL0wPIQhLhfqRw0b3ZxCvtnDkC1i7G8aVyY74eV/p
	 SFAWq3u16EOcOFfmOJftrkXo8Cj8Na5mcxhOzv06AjswiKdrExiU0PqDZxoequ2kiS
	 hqFk5GcuXd4KT+v9gSP1kAIqJYUtdgjRKk+8qMSaU11PiE0j+ZmI3oIXwKtf7gqW58
	 pdIAk6Ud1rdGW1jErqSiFpYG8+vrNYcmLGYpwStsNcEOXVMHQykYnvQCt2eEbE0TCV
	 /LsBJtTWY+KVpw8UsxrAbfwxRn2zRWDJp2mxxpoaDGidZOmek3lnpu+sQNvcsPcFqy
	 L0kOdm78iIVWQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 02/21] KVM: VMX: Initialize VM entry/exit FRED controls in vmcs_config
Date: Mon, 13 Oct 2025 18:09:31 -0700
Message-ID: <20251014010950.1568389-3-xin@zytor.com>
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
index 255158595e77..d881f1c133fa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2622,6 +2622,8 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		u32 entry_control;
 		u64 exit_control;
 	} const vmcs_entry_exit2_pairs[] = {
+		{ VM_ENTRY_LOAD_IA32_FRED,
+			SECONDARY_VM_EXIT_SAVE_IA32_FRED | SECONDARY_VM_EXIT_LOAD_IA32_FRED },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b2724aab48d2..2cf599211ab3 100644
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


