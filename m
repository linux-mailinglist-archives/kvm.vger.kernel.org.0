Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E549A4297BE
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 21:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhJKTsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 15:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbhJKTsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 15:48:38 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D999C061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 12:46:38 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 3-20020a620603000000b0042aea40c2ddso7957354pfg.9
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 12:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=USWZuA42U/QdDhA/fHCg+4AfqImFzDShWDW5TcIgstE=;
        b=PCX8tqSJqlHZW7ppIUhhl82m02ww06ipMjlcSukzw60eV1DC1JFfZQov3EUVtrMhqv
         i1c2DYrjg47zjo5j+H9DiOJZODHnj8N7B/6Oo1xHWclDDN4kMbpFztxwjWnRkEbL8Ldz
         8ipDeS/dl3mw/yMWqVn3IVuq3YfqqQTpBXUjXPub2KIOjKVm3FrzSalu+TttA8/eu+Xr
         su+lz03b1G9qad3VqcJkqmHI3ZGyFkMfHRWljnP+Xso5pY6b2JyDE9yKFH95HuRdf28L
         fi5ULDDclY4Y0z9slsgXJTUlBEi+mEHuopc78C9s4S1W/CC9EzdzTU/budtAiCcTmQbS
         ugvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=USWZuA42U/QdDhA/fHCg+4AfqImFzDShWDW5TcIgstE=;
        b=tyTGqvDiMoN3dz1SczUJkSOiP3RIiaAOGRO0IZKPX+bj/bSrudh5uuw/LXzbwCmRWN
         lJp4GIt8GUzz8staxjCG3tEPEjOUGPONVSuZ6NKGEcaRruXCw+Hm/sx+7pF/JEEoUIw5
         w7HxGmlJmdvAYQ7NvR1vqLbxykjXG0t94VvLXxgAsYcPvjBL0V7zc69pOcNgrGf+ybEX
         qIgHSBnsxsXZtb4NEhS3MUBtEyI1Rg9P0Ub4GIbyoKTHo4CM/E8pBVyT/p9Nhc06iVuv
         CeaFK7k6fFO2VyqtWLOLDiRYhR2T4sGnacWeaSgb3SxIfPfT2SZAfWYqBCeKTfV19iKE
         Yt+w==
X-Gm-Message-State: AOAM532VN7PIl8boPg1cWAtZVysv0x1OqBoFFwF1qgsQf+IMR070Cut3
        pJ2KftNx/HSlhaSJnFVv+gEQlFXHuMz1
X-Google-Smtp-Source: ABdhPJxX7BbtgeFDBPLvl3CztWhO8ssl3rZNi9sIk20/UkWgSRXllqKCRAtJL47Z/IofMenTI5QX5T9Kfc8O
X-Received: from vipinsh.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:36b0])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:8b89:: with SMTP id
 z9mr1042346pjn.89.1633981597843; Mon, 11 Oct 2021 12:46:37 -0700 (PDT)
Date:   Mon, 11 Oct 2021 19:46:15 +0000
Message-Id: <20211011194615.2955791-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH] KVM: VMX: Add a wrapper for reading INVPCID/INVEPT/INVVPID type
From:   Vipin Sharma <vipinsh@google.com>
To:     pbonzini@redhat.com, seanjc@google.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a common helper function to read invalidation type specified by a
trapped INVPCID/INVEPT/INVVPID instruction.

Add a symbol constant for max INVPCID type.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/invpcid.h |  1 +
 arch/x86/kvm/vmx/nested.c      |  4 ++--
 arch/x86/kvm/vmx/vmx.c         |  4 ++--
 arch/x86/kvm/vmx/vmx.h         | 12 ++++++++++++
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/invpcid.h b/arch/x86/include/asm/invpcid.h
index 734482afbf81..b5ac26784c1b 100644
--- a/arch/x86/include/asm/invpcid.h
+++ b/arch/x86/include/asm/invpcid.h
@@ -21,6 +21,7 @@ static inline void __invpcid(unsigned long pcid, unsigned long addr,
 #define INVPCID_TYPE_SINGLE_CTXT	1
 #define INVPCID_TYPE_ALL_INCL_GLOBAL	2
 #define INVPCID_TYPE_ALL_NON_GLOBAL	3
+#define INVPCID_TYPE_MAX		3
 
 /* Flush all mappings for a given pcid and addr, not including globals. */
 static inline void invpcid_flush_one(unsigned long pcid,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index af1bbb73430a..f0605a99e0fc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5392,7 +5392,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 		return 1;
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	type = vmx_read_invalidation_type(vcpu, vmx_instruction_info);
 
 	types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
 
@@ -5472,7 +5472,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return 1;
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	type = vmx_read_invalidation_type(vcpu, vmx_instruction_info);
 
 	types = (vmx->nested.msrs.vpid_caps &
 			VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c8b2b6e7ed9..77f72a41dde3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5502,9 +5502,9 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	}
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	type = vmx_read_invalidation_type(vcpu, vmx_instruction_info);
 
-	if (type > 3) {
+	if (type > INVPCID_TYPE_MAX) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 592217fd7d92..eeafcce57df7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -522,4 +522,16 @@ static inline bool vmx_guest_state_valid(struct kvm_vcpu *vcpu)
 
 void dump_vmcs(struct kvm_vcpu *vcpu);
 
+/*
+ * When handling a VM-exit for one of INVPCID, INVEPT or INVVPID, read the type
+ * of invalidation specified by the instruction.
+ */
+static inline unsigned long vmx_read_invalidation_type(struct kvm_vcpu *vcpu,
+						       u32 vmx_instr_info)
+{
+	u32 vmx_instr_reg2 = (vmx_instr_info >> 28) & 0xf;
+
+	return kvm_register_read(vcpu, vmx_instr_reg2);
+}
+
 #endif /* __KVM_X86_VMX_H */
-- 
2.33.0.882.g93a45727a2-goog

