Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955164E32FE
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiCUWt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiCUWtU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:49:20 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E6D476A55
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:19 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q13-20020a638c4d000000b003821725ad66so6584546pgn.23
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dc2dPnRhrgxNQaDjtZuInpm9Efgh6hIcIz8o5ukUhwE=;
        b=DrKMziogyI2ZhedcH4G4Ei3Fu4JW8Wd2ZTt1gxzXIfpkq12wquOjlp5QgHBMbewKm9
         CP5kTVW4LXSe0XcE32gMbU1rEM657zM0PXCVTfV17toFk2abzj+qdRdsRBCpxFSK1Aq2
         9U47CMdKDp2HDj6EC1vM6HJ0t8cxsqqsTx1v8HiQ+ivLm5qFug9GNWwWtn5wSeSO/E/n
         LScUWVhL/lggw07xDM41WkRpqBIAvRDzWpFEFg/8yDLoR5qZ966Iynnia4oIjYoUqrTI
         o5nXq/cMf7D3TiuEk0ZZjdKM/2ASj1QViEcvI5+hIxgReIqaYpNs4dyGwnGd0/sKMhrv
         5/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dc2dPnRhrgxNQaDjtZuInpm9Efgh6hIcIz8o5ukUhwE=;
        b=IP/4nj2UcUbCmkjYzOX0Wwqh4EcT44asFbSKoQvE2fBwaf46/FiOH5RkoBeDzQMACS
         HG5Ro9+OW9TGEQ9b6Xgr9MzfkGbvVKIA4tDgEF4//Eyx4bxKcG+NMOb41Wlf4OJRtXaS
         kpJjygZKpSc/BH8/CqJ7oHq9jY0wCRiW2P8jzNslIUn6KSxzSldIdgfdGRyZ5lV0xU7Q
         WnvVXXU1RZSSH/WR15vnaL9CmcuHZmsTk969EF9lLgrRM1n4l/yjB3jc2Yh9rXgNJyEi
         Om3WeaLPuTe2l3kMSwbO7BhxMjK8vsnUNzuNtJRzsqzMRogbNhFgg4MEOLsjVLPIcmhf
         W5Kw==
X-Gm-Message-State: AOAM532U8sIH73PA85TrQtPW3RORvynYYzvSHC+/BWW8ntCAWFuYkXVG
        I6NrJYTwK6iMM5FRzLtFHnxD+iJr/c/D
X-Google-Smtp-Source: ABdhPJwY9ONxbMbgKA2YXXCdUVpfkviwbC45/b5RPsVV/bTsSoz5nQe6v31EiqywvFgrUIfJbfybt3mHY/8h
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1824:b0:4f6:dc69:227e with SMTP
 id y36-20020a056a00182400b004f6dc69227emr26416628pfa.58.1647902659439; Mon,
 21 Mar 2022 15:44:19 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:43:56 -0700
In-Reply-To: <20220321224358.1305530-1-bgardon@google.com>
Message-Id: <20220321224358.1305530-8-bgardon@google.com>
Mime-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 7/9] KVM: x86/mmu: Add try_get_mt_mask to x86_ops
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add another function for getting the memory type mask to x86_ops.
This version of the function can fail, but it does not require a vCPU
pointer. It will be used in a subsequent commit for in-place large page
promotion when disabling dirty logging.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 2 ++
 arch/x86/kvm/svm/svm.c             | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c             | 1 +
 4 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 29affccb353c..29880363b5ed 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -88,6 +88,7 @@ KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
 KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
+KVM_X86_OP(try_get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f72e80178ffc..a114e4782702 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1422,6 +1422,8 @@ struct kvm_x86_ops {
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+	bool (*try_get_mt_mask)(struct kvm *kvm, gfn_t gfn,
+				bool is_mmio, u64 *mask);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b069493ad5c7..e73415dfcf52 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3944,6 +3944,13 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	return true;
 }
 
+static bool svm_try_get_mt_mask(struct kvm *kvm, gfn_t gfn,
+				bool is_mmio, u64 *mask)
+{
+	*mask = 0;
+	return true;
+}
+
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4600,6 +4607,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
 
+	.try_get_mt_mask = svm_try_get_mt_mask,
+
 	.get_exit_info = svm_get_exit_info,
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 69c654567475..81e9805ed1d8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7813,6 +7813,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vmx_get_mt_mask,
+	.try_get_mt_mask = vmx_try_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
-- 
2.35.1.894.gb6a874cedc-goog

