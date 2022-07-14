Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783715751F8
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239300AbiGNPhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiGNPhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:37:11 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16014AD7E
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:37:09 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k18-20020a170902c41200b0016c40543af4so380181plk.0
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=JkRA3Mpa+i25bXGiM48nrv2DUtxPE5vPtImMAiVJCCQ=;
        b=Esfd8MNtNxWYJPcYQ/wED/Laa6sCw2myW6KT2u8A6wlFKhJXSNSKfH3clFKTZA9/OI
         1+9sB2Ng3bA3kwy9+0cqTgDXvINhiOPmf6pk+0wLY986MmcP6YOr8hUVDyYUf/1LrAAi
         7B67RFadbzS8uMub4k4GdRtSAjq6tiUpPLPhWT5/eeSt9ksNQDdFkLXXMDIsnQPRWPGS
         VeTMT7cR1xl0/FyGhapM84G0P5Bm7JYoT8t5Hb1v9Brddav7LLEpoG6I6NBpgKJnpVcA
         f7c+GXAHCQ9lM4FQmjYyXNvDakR1e+npIwTA2JDiSUdG/kNePxk8sbvbIoyqL+wOQsFq
         3wow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=JkRA3Mpa+i25bXGiM48nrv2DUtxPE5vPtImMAiVJCCQ=;
        b=auIewyzzXI0xJoatyDvOQ7uG3P5lddhFmXgXrf3xiPSU9FO6P5MkXE3fNaU5cTYCL1
         LnuD/iSMqcR1JgTz39ONclIbfNr7dX3PhbyQMhvkQ+oCgEw0pcTPzcGkw4pifRch0U+A
         d2e5Tg23nD1SXZPUWByqVVrGgFLxpeSirfQr072yCTqxmbXgm6qxWUP1T/8wlucYIi75
         Hv8s729mDqqL4mcC5i5D3IOXlpZORoSOU3kGHddaMtTsdBggNeqxyjyEK+FA3l0Eg7lL
         CQTH8aXflGYPY+8YEkHohGIK93YCtyq+4TGPNTliVdI2j3tSPjxvhYd7mDm1r05mdTMy
         OKxA==
X-Gm-Message-State: AJIora9qelTMdz/fso6iJyG3J/3ORtChuly4BPOxlB8020l1jIv81K0H
        xNNvUfctpElRZZjE0kb1kgrg/darkIE=
X-Google-Smtp-Source: AGRyM1te2o3cMfktLglQrxa1ovvTodM+d9kHChmo9hfTBQpm8nd+VQWhs3W1f4B7/eBJjtZy3k1LKzSdG9A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:99f:b0:52a:dd61:a50f with SMTP id
 u31-20020a056a00099f00b0052add61a50fmr8894806pfg.9.1657813029533; Thu, 14 Jul
 2022 08:37:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 14 Jul 2022 15:37:07 +0000
Message-Id: <20220714153707.3239119-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH] KVM: x86: Restrict get_mt_mask() to a u8, use KVM_X86_OP_OPTIONAL_RET0
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrict get_mt_mask() to a u8 and reintroduce using a RET0 static_call
for the SVM implementation.  EPT stores the memtype information in the
lower 8 bits (bits 6:3 to be precise), and even returns a shifted u8
without an explicit cast to a larger type; there's no need to return a
full u64.

Note, RET0 doesn't play nice with a u64 return on 32-bit kernels, see
commit bf07be36cd88 ("KVM: x86: do not use KVM_X86_OP_OPTIONAL_RET0 for
get_mt_mask").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 +-
 arch/x86/include/asm/kvm_host.h    | 2 +-
 arch/x86/kvm/svm/svm.c             | 6 ------
 arch/x86/kvm/vmx/vmx.c             | 2 +-
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 6f2f1affbb78..51f777071584 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -88,7 +88,7 @@ KVM_X86_OP(deliver_interrupt)
 KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
 KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
-KVM_X86_OP(get_mt_mask)
+KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index de5a149d0971..fa4b2392fba0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1546,7 +1546,7 @@ struct kvm_x86_ops {
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
-	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	u8 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 37ce061dfc76..19af6dacfc5b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4158,11 +4158,6 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	return true;
 }
 
-static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
-{
-	return 0;
-}
-
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4814,7 +4809,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
 
-	.get_mt_mask = svm_get_mt_mask,
 	.get_exit_info = svm_get_exit_info,
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c30115b9cb33..c895a3b6824d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7352,7 +7352,7 @@ static int __init vmx_check_processor_compat(void)
 	return 0;
 }
 
-static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u8 cache;
 

base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c
-- 
2.37.0.144.g8ac04bfd2-goog

