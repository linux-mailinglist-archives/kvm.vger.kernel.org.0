Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2BC49455C
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358137AbiATBHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358079AbiATBHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:07:32 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753B0C06173F
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:32 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t1-20020a6564c1000000b002e7f31cf59fso2665592pgv.14
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rr7/xdS9A1Cq2w8MHIPc7fJOr4VT50gYLmjh7LotzWE=;
        b=lm7IIDCcB6NMu3Iyn7ddQbGmSBJrUq3LlR+awXTl6j+43AEWJT8VxiuJhtr+2YFi5k
         WUbO3LnrIFQGse/VMN6nEE3abh8iRKcuDyptPD9VOP6rK5l0toLkouQqEJpZMwfCWn9R
         zfG87U6BcfEqv2SESInjOIeejxAhmTKa71JPas9nEUKis0pcKEAeOj6Y9Ym1jvFKwzuZ
         bLgbmJXI1X68SXOKNm5UGw+T0oV0Fs9CW8c2sz5Xn5UpMbRzb27n31XQcFlEK52+0B+0
         UmEWgTUehVbHHuQWEXsfj/4jkBeZGNy5q83X1hOJNG6inY1fCvI6ZZZrhD4/htIbaYND
         yb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rr7/xdS9A1Cq2w8MHIPc7fJOr4VT50gYLmjh7LotzWE=;
        b=e3AxsOyCJiLuyUxWg0R44vmG88Lxy0Jc782vL4L7zNmdlVIDYrYhslt/OkRmY8ZXfO
         cuSaMEocuCZ31u0spkaAilw2mJCe7SskBwdOsiIlEe1zsKp++R2IfOAmYYdMI0bZlzdW
         25TZ1pSVjuruPXv8Msmo/ccvV4bmFWRfUuJt6GFLD1UOE7BMRJHjB6A+oJwEv2g/HgRn
         ll/7yjp+Z6F6X4eyijfFT5BitG9eq4gJski86sZ+tJDBvhNxEsJqAbG6JTQXRyWPrUgQ
         smE/yCTLGrvyDYmHOv7FjmaA2yvyvd3TWr0CMNwx7STqfQdcGjYaICGkapmzlnZIpQ6D
         5+1w==
X-Gm-Message-State: AOAM530wDl9RslaTUtohmg/Z+BwK2CSaSQus7FHF3m8K40DWjUJEXCLn
        PJmueAlNEcSLepsE/2Aww+FtVn4mQbM=
X-Google-Smtp-Source: ABdhPJz4p6vz9khH27uhFpqdGrJHMj8406rn4ySWvLKzbIKS9p0iBcbIv0LQAP7NED2W6kvXjgrmEP41G5M=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:888e:0:b0:4c4:3ad:9eee with SMTP id
 z14-20020aa7888e000000b004c403ad9eeemr18324235pfe.13.1642640851937; Wed, 19
 Jan 2022 17:07:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 01:07:15 +0000
In-Reply-To: <20220120010719.711476-1-seanjc@google.com>
Message-Id: <20220120010719.711476-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220120010719.711476-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 5/9] KVM: x86: Pass emulation type to can_emulate_instruction()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the emulation type to kvm_x86_ops.can_emulate_insutrction() so that
a future commit can harden KVM's SEV support to WARN on emulation
scenarios that should never happen.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/svm/svm.c          |  3 ++-
 arch/x86/kvm/vmx/vmx.c          |  7 ++++---
 arch/x86/kvm/x86.c              | 11 +++++++++--
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 682ad02a4e58..c890931c9c65 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1482,7 +1482,8 @@ struct kvm_x86_ops {
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
-	bool (*can_emulate_instruction)(struct kvm_vcpu *vcpu, void *insn, int insn_len);
+	bool (*can_emulate_instruction)(struct kvm_vcpu *vcpu, int emul_type,
+					void *insn, int insn_len);
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index edea52be6c01..994224ae2731 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4257,7 +4257,8 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
+static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					void *insn, int insn_len)
 {
 	bool smep, smap, is_user;
 	unsigned long cr4;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a02a28ce7cc3..4b4c1dfa6842 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1487,11 +1487,12 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
-static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
+static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					void *insn, int insn_len)
 {
 	/*
 	 * Emulation of instructions in SGX enclaves is impossible as RIP does
-	 * not point  tthe failing instruction, and even if it did, the code
+	 * not point at the failing instruction, and even if it did, the code
 	 * stream is inaccessible.  Inject #UD instead of exiting to userspace
 	 * so that guest userspace can't DoS the guest simply by triggering
 	 * emulation (enclaves are CPL3 only).
@@ -5397,7 +5398,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 {
 	gpa_t gpa;
 
-	if (!vmx_can_emulate_instruction(vcpu, NULL, 0))
+	if (!vmx_can_emulate_instruction(vcpu, EMULTYPE_PF, NULL, 0))
 		return 1;
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55518b7d3b96..2fa4687de8e4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6810,6 +6810,13 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
 
+static int kvm_can_emulate_insn(struct kvm_vcpu *vcpu, int emul_type,
+				void *insn, int insn_len)
+{
+	return static_call(kvm_x86_can_emulate_instruction)(vcpu, emul_type,
+							    insn, insn_len);
+}
+
 int handle_ud(struct kvm_vcpu *vcpu)
 {
 	static const char kvm_emulate_prefix[] = { __KVM_EMULATE_PREFIX };
@@ -6817,7 +6824,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
 	char sig[5]; /* ud2; .ascii "kvm" */
 	struct x86_exception e;
 
-	if (unlikely(!static_call(kvm_x86_can_emulate_instruction)(vcpu, NULL, 0)))
+	if (unlikely(!kvm_can_emulate_insn(vcpu, emul_type, NULL, 0)))
 		return 1;
 
 	if (force_emulation_prefix &&
@@ -8193,7 +8200,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	bool writeback = true;
 	bool write_fault_to_spt;
 
-	if (unlikely(!static_call(kvm_x86_can_emulate_instruction)(vcpu, insn, insn_len)))
+	if (unlikely(!kvm_can_emulate_insn(vcpu, emulation_type, insn, insn_len)))
 		return 1;
 
 	vcpu->arch.l1tf_flush_l1d = true;
-- 
2.34.1.703.g22d0c6ccf7-goog

