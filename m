Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818C844B21E
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 18:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241248AbhKIRrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 12:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241230AbhKIRrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 12:47:20 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9C3C061764
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 09:44:34 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id i3-20020a170902c94300b0014287dc7dcbso3315608pla.16
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 09:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=azJvZCYQiOEvzpk5HIvvri7jM+tzmkHzZTh2NDFW5hc=;
        b=KIp5poo5TTGtQDEuzmQQXTpR8ugcfA7uD3t1HUw0igbgihdAPDiT8J9ASMZUrbF+UX
         tGXbZ9q/btSjGyv6JANX/kkq8qlgIx6rDVSCNxDwhDFk1FcOHntTr+UXuULU0ezylVE0
         q5CgQeu0u6mibuY1Bzs+jZxHnMIqC5qNigSAkon6T7RphOO+eGyvQQgo676wsXt09Qmv
         PdLny/Kv2SgkYSg09Cs8PmusC8e1R/zScjtf7j1fT6qnJndCKB/fOLiQ6f/6GnEB9hb9
         ztJJNETMyetRBfnnUDn0qA5IK1Z4B4qSrqKCwYyFW5R5JTANX46W/8bA2yPYSysQMJhD
         hOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=azJvZCYQiOEvzpk5HIvvri7jM+tzmkHzZTh2NDFW5hc=;
        b=cJcSLZR9nERTu+01kD/QxqTpdQt0ZpoER3g+eQjbMwF0QaYLOc+KP8UgWqJQp/7Z8Q
         MJotQ9S5Ab+KehY02nybWwaES0BwVxq8X6mEB9KH7mELCb0QLZNPtsDOmN+Errqx69i/
         fnNwnFV0VPnenSX/7gamzp8nqVgYTN8U5bc/EkvlEXDPtkubQO5wrgnkqE56fggul03L
         Z/u82YlIHvQBuNpT//HdYjNt4ldiGg7PYRyLeJ/V9mByFK4s5LLg7Ce2GSS7SN/0aWhV
         Ww/7/6jbHRd7hr491iVZ9qrYPWybPl59ftjY5y0kmdKbDh3ge0H6NDNGlr4msuec4AuS
         lnIg==
X-Gm-Message-State: AOAM530kz6+xCbxZeaIDc7AI++8iQmSAwJMoW/bmgBlbpzfSDbp+vSU1
        q6IcYNRc3xFNYxM/6i4KIx6JQQ6s75r0
X-Google-Smtp-Source: ABdhPJw/dFG+OXFojjhEYYutAIBtZJNpp/MW1Wc8cfjsfPdmBRdkxZkqcheb/tNRcmCa2wKcuQqFQo9kleIa
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a17:902:e849:b0:142:c85:4d3d with SMTP id
 t9-20020a170902e84900b001420c854d3dmr8740313plg.75.1636479873707; Tue, 09 Nov
 2021 09:44:33 -0800 (PST)
Date:   Tue,  9 Nov 2021 17:44:25 +0000
In-Reply-To: <20211109174426.2350547-1-vipinsh@google.com>
Message-Id: <20211109174426.2350547-2-vipinsh@google.com>
Mime-Version: 1.0
References: <20211109174426.2350547-1-vipinsh@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 1/2] KVM: VMX: Add a helper function to retrieve the GPR
 index for INVPCID, INVVPID, and INVEPT
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

handle_invept(), handle_invvpid(), handle_invpcid() read the same reg2
field in vmcs.VMX_INSTRUCTION_INFO to get the index of the GPR that
holds the invalidation type. Add a helper to retrieve reg2 from VMX
instruction info to consolidate and document the shift+mask magic.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 10 ++++++----
 arch/x86/kvm/vmx/vmx.c    |  4 +++-
 arch/x86/kvm/vmx/vmx.h    |  5 +++++
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b4ee5e9f9e20..f73d4e31dd99 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5379,7 +5379,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	struct {
 		u64 eptp, gpa;
 	} operand;
-	int i, r;
+	int i, r, gpr_index;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_EPT) ||
@@ -5392,7 +5392,8 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 		return 1;
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
+	type = kvm_register_read(vcpu, gpr_index);
 
 	types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
 
@@ -5459,7 +5460,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		u64 gla;
 	} operand;
 	u16 vpid02;
-	int r;
+	int r, gpr_index;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_VPID) ||
@@ -5472,7 +5473,8 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return 1;
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
+	type = kvm_register_read(vcpu, gpr_index);
 
 	types = (vmx->nested.msrs.vpid_caps &
 			VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 71f54d85f104..e41d207e3298 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5494,6 +5494,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 		u64 pcid;
 		u64 gla;
 	} operand;
+	int gpr_index;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
@@ -5501,7 +5502,8 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	}
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
+	type = kvm_register_read(vcpu, gpr_index);
 
 	if (type > 3) {
 		kvm_inject_gp(vcpu, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e7db42e3b0ce..95c9bca45cdd 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -522,4 +522,9 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 
 void dump_vmcs(struct kvm_vcpu *vcpu);
 
+static inline int vmx_get_instr_info_reg2(u32 vmx_instr_info)
+{
+	return (vmx_instr_info >> 28) & 0xf;
+}
+
 #endif /* __KVM_X86_VMX_H */
-- 
2.34.0.rc0.344.g81b53c2807-goog

