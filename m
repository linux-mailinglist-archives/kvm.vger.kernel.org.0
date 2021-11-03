Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401EA44484C
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 19:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhKCSgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 14:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhKCSg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 14:36:27 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83E6C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 11:33:50 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n9-20020a170902968900b0013f23b51142so1502450plp.8
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 11:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J5vfKF6W1D5gAeKm4lwrd0QK8zJYwxNEd4UBSUYOqrg=;
        b=To0pew1bYcekjF4Ldq5rjlQpbzzSeeCXehNV77kz2dvXRRMBkbbIm6yMN4WnRfwQzq
         s1/Hnpi9zbJ6ULjoqxYkxerz8TvwSqQ4j6oSJ3ZYKTO7gOUs7Sn3vIA7+ZAIAtEtNVAT
         fSPrXdhlZb4Xi890mAC2fRXzuYdNRpv/1czBHMZKiUgwOvJ2CQxhwTON1bO2MlLX91th
         JHHv6kvT84/PyjSCGCwfXiCNzDlkkEqcHr52wt3t9TXjJMF6scvmSAFprAuuruy9LxBO
         UgW4l9LQ7VgbdO3h4Nd+l5r6059C1CP9D7FMRIeMvGovYJY49BjemuNqaD5dWngY+tbP
         xGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J5vfKF6W1D5gAeKm4lwrd0QK8zJYwxNEd4UBSUYOqrg=;
        b=UMnCemlaAdp4GGtk3HssfPKrvHvLRB0UvbtB5GHPRzjlzcpK0R702sjR+dFsCk7Qi7
         /8Ng5m7cMAsShC1G172neYOQoxvTC75timYfHB7B2x0NFU9hhgbC8yFY7oAWKmbcsgtm
         DOxSBqwvcZkXXSmVO27c4skat5rKQPF2RozH2AwlfD5rvOslRxVpd/yOqO8UlIU0LBwC
         8aDTCEp3WKBQyajrmnWY2pHHCq7N6xelyGZvvHRo/lu1DwVW4E/QgWF5BdtKEv+GK/LH
         XkYGMRnVmWKjE1l8uJW2hvrIrfdIR/7R3VnUAEpUeZFbDANB5QePtWzD+VwCYr+u6MhL
         P9/g==
X-Gm-Message-State: AOAM531z6rT+IYtDl2UAQdsciEuJdPXJvv00jS1aMHHLFSs2dsfzrjBW
        OP47hbTjzJGrXvFdxb0Ab97sFMPXDyrU
X-Google-Smtp-Source: ABdhPJwC4fvy2sGmysq37/bAuht9+nkpD/vRteKePPgPc/w35pQ2gLI8Z0wLKbfoL1Y90YyHELXppPMrt35o
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:2293:b0:481:fe4:c9df with SMTP id
 f19-20020a056a00229300b004810fe4c9dfmr22559109pfe.69.1635964430317; Wed, 03
 Nov 2021 11:33:50 -0700 (PDT)
Date:   Wed,  3 Nov 2021 18:32:31 +0000
In-Reply-To: <20211103183232.1213761-1-vipinsh@google.com>
Message-Id: <20211103183232.1213761-2-vipinsh@google.com>
Mime-Version: 1.0
References: <20211103183232.1213761-1-vipinsh@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 1/2] KVM: VMX: Add a wrapper to read index of GPR for
 INVPCID, INVVPID, and INVEPT
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

handle_invept(), handle_invvpid(), handle_invpcid() read the same reg2
on VM exit. Move them to a common wrapper function.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
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
2.33.1.1089.g2158813163f-goog

