Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B90E4449FD
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 21:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhKCVCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 17:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhKCVCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 17:02:07 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAFBC061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 13:59:30 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g26-20020a63521a000000b0029524f04f5aso2133870pgb.5
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 13:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J5vfKF6W1D5gAeKm4lwrd0QK8zJYwxNEd4UBSUYOqrg=;
        b=hDN95wHzvTbJpve1QOZR6g6uC3sJG+J62rOJrTmrUAvLStwbBBBYKK7dYMU58dR7Pa
         tqxbfn1C45I801HzsjnnOE06SOdzPGy+f/8206Rcx2T9f4EmMfBLjou2X1FxnKjZMLZh
         QVtzJeGBVa8JjJClRNWdAWF0YbpMxhhkyKX+ifSO9sGFo2tDayg5NCiVYFMxYEPtGEvd
         h6Z5AquW377lu23nP+LB0towSMZmBRQ8NVHWPvxCjc5fQVPtzglUjWONSJmMKGuhSuJB
         qUgNilQTMQHwQDmBOvB7uFno0NNxzA92sjXfk8n3BOPG2FW1Vrf0tOkZbDm8zC5aDQq+
         BSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J5vfKF6W1D5gAeKm4lwrd0QK8zJYwxNEd4UBSUYOqrg=;
        b=wPf5ZZY2q/5lWghKaD1waa1lrx5U/tYh2i6bTnuUA+yX7lqBgcckRRSqXUj0FBKBEE
         AJAwWJA8TBNa2p6Mr5hcVTS6sT+a8vZ8zs60Dbff1wO3UWVSG8YSrsJmnZMAopPzmbol
         JkpJAAHMev9StLvaM5hXOQ24/gkObBSaBKJGItLUOxjd7mpfKozCcc4Izx7UwTLb0ekR
         jDBt5ZlcPbKZ+RgbneblIRjRV1JCZ40J3d8tVp6cPcYrq6DykDfmIvV4L4tvXGGcmW2I
         yl+rGJ5eje+THOMSrMfPEHy5fM2CknmHTYWx+iREhtnsFgpIBq2+/hR3qlLqgQVr4CWC
         vmHQ==
X-Gm-Message-State: AOAM531hLiQQw+M8GpgqBda8VeoPVNh3/uZgrYVUuENxhs0529rQH1Fu
        thzR9L43fTIB+JPb5oojvWFCUdwWrYi8
X-Google-Smtp-Source: ABdhPJxXmBmInBVhd+5vuxRRQp1JoR7j588ddxrRxk4y2EDke114rveLBcdn8DAL3DZszVomTr/91YT0bz7o
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a17:902:d885:b0:141:b4ca:7c80 with SMTP id
 b5-20020a170902d88500b00141b4ca7c80mr32624528plz.88.1635973169681; Wed, 03
 Nov 2021 13:59:29 -0700 (PDT)
Date:   Wed,  3 Nov 2021 20:59:10 +0000
In-Reply-To: <20211103205911.1253463-1-vipinsh@google.com>
Message-Id: <20211103205911.1253463-2-vipinsh@google.com>
Mime-Version: 1.0
References: <20211103205911.1253463-1-vipinsh@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v3 1/2] KVM: VMX: Add a wrapper to read index of GPR for
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

