Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD2456C4A0
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240461AbiGHVVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 17:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbiGHVVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 17:21:18 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F682BB09
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 14:21:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31cdce3ed04so180287b3.13
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 14:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=twUVJxIVhhRUka3ujAGpgx5jyolc6+CWViYPAjBE+SE=;
        b=gGW7BYWFyEalfApr15oYFvpIMQcxD7X1mQiNqiPuiVHYYUJgo4j9T8+HQrwKcnXi4E
         uEYEIa6xfRlrn0clPA2WDvMuAzqAf91T7W2xQHSARkmZ8P1Lz2oyGz5DLXF4tH9Ry9TJ
         NSulr8r64BRrltG4I9PBO5kezDuJpeqU5FtSpSKwFcouadKfcfrj2G0ftpInI2imZOKz
         SM+n0KcxkrqAmu334mXP1Menw+lX76bcByeebg6rmKPRCwX4ejI7DrvTf6emYPf0kcHg
         /DgDGUJ4pRWEXgIDl2tKPrWdfeRCoIuV6Znk/PyHVb51PY7O7o//T5G4QkZZXL6unvXn
         Qp2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=twUVJxIVhhRUka3ujAGpgx5jyolc6+CWViYPAjBE+SE=;
        b=4PEktQNAiw8u9kvOtProaJFy4gJltiVHLK07HxJKu4/qDlYJx9Z/2bSPI7ncy9Rq/t
         kqqKCuMLbMy2mRMIR8KWtuNPX/7YNEWhuMMcBqBo1VTm+QuWjmImtiqs92oNsmPcW87o
         kMb4c/N17HstpTqxnvk9yelBfy5f8gfv9oAJxZum0jaRZ5xBLGUTlnPXTDxl4lIYGi/H
         RKh2+7U31QeagRRcH0YPxfAbQMwTvPTfzKcotbO3XMo8k6aSslVbo9ni7YWHuxmh82Nr
         Uivi36Khxo2lqEbeX7i2uEtIMSDeGU4galQ0KRmzZSldW6tUeIdJ7nkRp5PX2k+6T/Kk
         LB6w==
X-Gm-Message-State: AJIora8t9aZSx9TU3Zlg8m14nRXAejrDFf+I+t7ZVBemRwvpumT3t6dv
        7dUQGT08B8wdmxuCiRekzRaVfgo=
X-Google-Smtp-Source: AGRyM1sGe6ArR8ij03wbQdy/kCKJfdsfrfRo/UOh8N3xvvxXsh3eCjHm+5S8mVUGa8PtuJjzKsK3bH4=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:ff27:d65:6bb8:b084])
 (user=pcc job=sendgmr) by 2002:a81:4eca:0:b0:31c:7a6a:f6d3 with SMTP id
 c193-20020a814eca000000b0031c7a6af6d3mr6573793ywb.82.1657315276782; Fri, 08
 Jul 2022 14:21:16 -0700 (PDT)
Date:   Fri,  8 Jul 2022 14:21:04 -0700
In-Reply-To: <20220708212106.325260-1-pcc@google.com>
Message-Id: <20220708212106.325260-2-pcc@google.com>
Mime-Version: 1.0
References: <20220708212106.325260-1-pcc@google.com>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2 1/3] KVM: arm64: add a hypercall for disowning pages
From:   Peter Collingbourne <pcc@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
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

Currently we only deny the host access to hyp and guest pages. However,
there may be other pages that could potentially be used to indirectly
compromise the hypervisor or the other guests. Therefore introduce a
__pkvm_disown_pages hypercall that the host kernel may use to deny its
future self access to those pages before deprivileging itself.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
v2:
- refcount the PTEs owned by NOBODY

 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 +++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++++++++++
 5 files changed, 23 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 411cfbe3ebbd..1a177d9ed517 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -63,6 +63,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa,
 	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context,
+	__KVM_HOST_SMCCC_FUNC___pkvm_disown_pages,
 	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
 
 	/* Hypercalls available after pKVM finalisation */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index e0bbb1726fa3..e88a9dab9cd5 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -58,6 +58,7 @@ enum pkvm_component_id {
 	PKVM_ID_HOST,
 	PKVM_ID_HYP,
 	PKVM_ID_GUEST,
+	PKVM_ID_NOBODY,
 };
 
 extern unsigned long hyp_nr_cpus;
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index c1987115b217..fbd991a46ab3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -98,6 +98,7 @@ int __pkvm_init_shadow(struct kvm *kvm,
 		       unsigned long pgd_hva,
 		       unsigned long last_ran_hva, size_t last_ran_size);
 int __pkvm_teardown_shadow(unsigned int shadow_handle);
+int __pkvm_disown_pages(phys_addr_t phys, size_t size);
 
 struct kvm_shadow_vcpu_state *
 pkvm_load_shadow_vcpu_state(unsigned int shadow_handle, unsigned int vcpu_idx);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e575224244e6..0dab343734e8 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1031,6 +1031,14 @@ static void handle___pkvm_teardown_shadow(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_teardown_shadow(shadow_handle);
 }
 
+static void handle___pkvm_disown_pages(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
+	DECLARE_REG(size_t, size, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_disown_pages(phys, size);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -1048,6 +1056,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
 	HANDLE_FUNC(__kvm_flush_cpu_context),
+	HANDLE_FUNC(__pkvm_disown_pages),
 	HANDLE_FUNC(__pkvm_prot_finalize),
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d839bb573b49..b3a2ad8454cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1756,3 +1756,14 @@ int __pkvm_host_reclaim_page(u64 pfn)
 
 	return ret;
 }
+
+int __pkvm_disown_pages(phys_addr_t phys, size_t size)
+{
+	int ret;
+
+	host_lock_component();
+	ret = host_stage2_set_owner_locked(phys, size, PKVM_ID_NOBODY);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.37.0.144.g8ac04bfd2-goog

