Return-Path: <kvm+bounces-17783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13EBC8CA1AA
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F29B1F22552
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B85113A252;
	Mon, 20 May 2024 17:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K5rrFlCG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29739139CFD
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 17:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716227983; cv=none; b=UXDZNKj1W0sgQMX732mIp0YS0CMA2PBsA4xioRb/SOykr6kC/08g+xZ1Em1PAeVUXCrBffRyLpJ8AjxYTFe7HOpkEPdSMaHhQKN3QmA6HJsD4oCpBdHUWovf6P8LD3vrCF9qqKA54dnolEyDKFSdZ1+pZPxFhsTdNcg9jVE8AnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716227983; c=relaxed/simple;
	bh=KXbhr0oS4jW/PnztvZDbBs9jmbmcgpyWoUoreIFNtp8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cAzZaUOM1mSKPfRd+PlzAgeQK1qxEL5BymkQ9OY9OyQaNe87JZ3S/W5GQO091MkDnTbo7RpRaypdgZDGku/9cAWLhBgMuFY2ziLFAs4D3xY7kUHT31pmF+EjsJbCusvjDJdrddSM42iuGPeDYaz+UHILOliTVeARAlmDwU3LnqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K5rrFlCG; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-622ce716ceaso102777937b3.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 10:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716227981; x=1716832781; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=U5x/LKmYp/zUDyPjqL9HQa2ghtBprteyuu1DoKW4C/I=;
        b=K5rrFlCGzD4r1mBSYCq74WIDNcECkrK9efL+Mr5BgW60GFGCarBXUaySwIv1MfAgcX
         thlaa4XXWwweRCPXUi4cGUorslCtQiZy7vBBJ2/1ZBAQQWNlDDXiZtw3a8h3Rxy9ODDS
         6aMPnS5eHPCH9YIWZFM8r3LmxBgAVyR4jYp6p5dqyNbsz9nQTUWG1n74DLXFZuX41/nb
         wq2B14HT6uIqfavgwQW+BvoIBqP9U3IlCbFXtwZ8R8+ynHips3AgLwzMpJBDjeenJHbJ
         Gg6ubjc2pXehIAJUEEKY32mwdzaiwq34muuTCx0nEXqME7INTpopsFgkBpsnwXf6P4ps
         NrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716227981; x=1716832781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5x/LKmYp/zUDyPjqL9HQa2ghtBprteyuu1DoKW4C/I=;
        b=H2skRwS5lOI3BJGtWkAxxsrmWwBhiQaLzkowVCxuksfdHKTW61SSCXHMerrtLVpmtm
         FySDxJyXYtd7Jf1YWAfEOrtzEICzub1AdjJ6mXMkFltTeZ92YmnTT8at7IKd71X1d8Da
         mR5rGYZosuH82LY7pJKfAYS8nycih7BLx/OEleomZaoBJZGXdS1S5PWG7s5nT5Rpf4jg
         P6pd9SxSEfZvPBWtJvu6bzEb94qgwE8oGmOQRhkQDdfAnhTIXZeUr/73ROZF9njTTWM5
         rapKkMbhBuPLh0jTZjH5ocdwrad5nV3qoYfG5sv9BBJkD4nj9Ii0zcjmjETVAMrf8ye/
         DSVw==
X-Gm-Message-State: AOJu0YxhRuIacLUkxw8tdealmVKtUgS1Si+aWPxK+lfmlAPf2erwt7HD
	WS5xzYuc6Xn0djAivkgQpEYGgp3i2FzyWxp3hH3sIJs09s+AbDzK+ZS2GFjX5nY7nb1rE7gpJ7b
	spA==
X-Google-Smtp-Source: AGHT+IFUgxXnWpIjz0kEt7c+gRlhzvX8vg2Um/LusDp9/32AiYRkktBL4RkpZ0n5RMcgwtQGO7f/ld1n3do=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:9147:0:b0:618:2ad1:a46f with SMTP id
 00721157ae682-627971ae241mr17759487b3.2.1716227981104; Mon, 20 May 2024
 10:59:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 May 2024 10:59:20 -0700
In-Reply-To: <20240520175925.1217334-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240520175925.1217334-6-seanjc@google.com>
Subject: [PATCH v7 05/10] KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a single
 64-bit value
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin3.li@intel.com>

Track the "basic" capabilities VMX MSR as a single u64 in vmcs_config
instead of splitting it across three fields, that obviously don't combine
into a single 64-bit value, so that KVM can use the macros that define MSR
bits using their absolute position.  Replace all open coded shifts and
masks, many of which are relative to the "high" half, with the appropriate
macro.

Opportunistically use VMX_BASIC_32BIT_PHYS_ADDR_ONLY instead of an open
coded equivalent, and clean up the related comment to not reference a
specific SDM section (to the surprise of no one, the comment is stale).

No functional change intended (though obviously the code generation will
be quite different).

Cc: Shan Kang <shan.kang@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
[sean: split to separate patch, write changelog]
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h      |  5 +++++
 arch/x86/kvm/vmx/capabilities.h |  6 ++----
 arch/x86/kvm/vmx/vmx.c          | 28 ++++++++++++++--------------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 81b986e501a9..90963b14afaa 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -152,6 +152,11 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
 	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
 }
 
+static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
+{
+	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
+}
+
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
 	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 41a4533f9989..86ce8bb96bed 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -54,9 +54,7 @@ struct nested_vmx_msrs {
 };
 
 struct vmcs_config {
-	int size;
-	u32 basic_cap;
-	u32 revision_id;
+	u64 basic;
 	u32 pin_based_exec_ctrl;
 	u32 cpu_based_exec_ctrl;
 	u32 cpu_based_2nd_exec_ctrl;
@@ -76,7 +74,7 @@ extern struct vmx_capability vmx_capability __ro_after_init;
 
 static inline bool cpu_has_vmx_basic_inout(void)
 {
-	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
+	return	vmcs_config.basic & VMX_BASIC_INOUT;
 }
 
 static inline bool cpu_has_virtual_nmis(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7dd76d04b4b0..695fd7683ba7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2570,13 +2570,13 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			     struct vmx_capability *vmx_cap)
 {
-	u32 vmx_msr_low, vmx_msr_high;
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	u64 basic_msr;
 	u64 misc_msr;
 	int i;
 
@@ -2699,29 +2699,29 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_vmexit_control &= ~x_ctrl;
 	}
 
-	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
+	rdmsrl(MSR_IA32_VMX_BASIC, basic_msr);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
-	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
+	if (vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE)
 		return -EIO;
 
 #ifdef CONFIG_X86_64
-	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
-	if (vmx_msr_high & (1u<<16))
+	/*
+	 * KVM expects to be able to shove all legal physical addresses into
+	 * VMCS fields for 64-bit kernels, and per the SDM, "This bit is always
+	 * 0 for processors that support Intel 64 architecture".
+	 */
+	if (basic_msr & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
 		return -EIO;
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
-	if (((vmx_msr_high >> 18) & 15) != X86_MEMTYPE_WB)
+	if (vmx_basic_vmcs_mem_type(basic_msr) != X86_MEMTYPE_WB)
 		return -EIO;
 
 	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
 
-	vmcs_conf->size = vmx_msr_high & 0x1fff;
-	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
-
-	vmcs_conf->revision_id = vmx_msr_low;
-
+	vmcs_conf->basic = basic_msr;
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
@@ -2871,13 +2871,13 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	if (!pages)
 		return NULL;
 	vmcs = page_address(pages);
-	memset(vmcs, 0, vmcs_config.size);
+	memset(vmcs, 0, vmx_basic_vmcs_size(vmcs_config.basic));
 
 	/* KVM supports Enlightened VMCS v1 only */
 	if (kvm_is_using_evmcs())
 		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
 	else
-		vmcs->hdr.revision_id = vmcs_config.revision_id;
+		vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
 
 	if (shadow)
 		vmcs->hdr.shadow_vmcs = 1;
@@ -2970,7 +2970,7 @@ static __init int alloc_kvm_area(void)
 		 * physical CPU.
 		 */
 		if (kvm_is_using_evmcs())
-			vmcs->hdr.revision_id = vmcs_config.revision_id;
+			vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
 
 		per_cpu(vmxarea, cpu) = vmcs;
 	}
-- 
2.45.0.215.g3402c0e53f-goog


