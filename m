Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6829F557100
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 04:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377796AbiFWCTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 22:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377535AbiFWCTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 22:19:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE6F3CA5C
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 19:19:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a05690212cb00b006454988d225so15988492ybu.10
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 19:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wT4jHGlHPHF9dlfcKzGZH8nhD8vpeQwEkQou9JzLU60=;
        b=RVgxxUJl2hpXa33b+kJtJXbExaoizJzs1IRtinNk7nfyr7rfAQugUZA7d+RrpYEKbL
         lxHsdenRl/U81vQWHbh2ieO7b0GgcNVgtAhi1jrLMUgeR2LQmBpGScCtRjSisDCCaNgw
         zdPf2LmgZwlaYXYa6Bcw8e323ZhLCyGNLakWlg9g8HJ/vvSbzKJfCY5eMJrUzBoC+ios
         G2TiaYtk35xp/tudhc3eyll3CHRE2CqXUFC2BmGOE4Thxb5xXeM6xtAEDe+RLRGLZeIf
         n317+ev8I08NprsuGzNYGVhK0NJX54k1qixYjDwqClxClfhLPNYSu8+7KEWWyZxdW6dh
         W8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wT4jHGlHPHF9dlfcKzGZH8nhD8vpeQwEkQou9JzLU60=;
        b=k5e16MQsZuANSdY5vKu0QAXSttvo0CoRtF1syXanlqcVh4Mra3Pgr6y1lZPxT5SG1/
         5a5p+xDlYz/uC0Rn7v7A41LJCLjsFBiKiAkxkoDoTBwFdyC4bpUT5mKLoxu1tk6d1hFl
         leEeYPrFZzOREj/DstwWHau+i1hlZaBfLaWPwozPxqiOw4pMnj22T3yWTS1km34ovBWt
         p3SZFvz3vqhTZ3YYs4v1Ttw8PWXDXGy1zMELEQmTWP/HfmZOI0W4aAdVhnTZUe8rE4Vl
         +QEdMXHr2+i7HSUSfnM0jBY22ItCQXR922jmw1Nb9XEW3mfP9nTEVfHTrL9YlU6dDH5E
         WCBA==
X-Gm-Message-State: AJIora+MHnyojOEPRdsLz3EKJUD7nIoWjF37H7fUDt0QpG2lpy7qCGV+
        bUjLjP/00312gZHbDxHlDsk/oNw=
X-Google-Smtp-Source: AGRyM1ub1xVH1VRZd14aVuV55xQTwS7KIATb7Hw6lN8inguHsebJ3kq2h0VMLDkavIHjfGw2R83JCkQ=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:ba6f:123c:d287:a160])
 (user=pcc job=sendgmr) by 2002:a0d:dd81:0:b0:317:cd05:1d94 with SMTP id
 g123-20020a0ddd81000000b00317cd051d94mr8038901ywe.189.1655950778275; Wed, 22
 Jun 2022 19:19:38 -0700 (PDT)
Date:   Wed, 22 Jun 2022 19:19:24 -0700
In-Reply-To: <20220623021926.3443240-1-pcc@google.com>
Message-Id: <20220623021926.3443240-2-pcc@google.com>
Mime-Version: 1.0
References: <20220623021926.3443240-1-pcc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 1/3] KVM: arm64: add a hypercall for disowning pages
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
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 +++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++++++++++
 arch/arm64/kvm/hyp/pgtable.c                  |  5 +++--
 6 files changed, 26 insertions(+), 2 deletions(-)

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
index ddb36d172b60..b81908ef13e2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1055,6 +1055,14 @@ static void handle___pkvm_teardown_shadow(struct kvm_cpu_context *host_ctxt)
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
@@ -1072,6 +1080,7 @@ static const hcall_t host_hcall[] = {
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
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 756bbb15c1f3..e1ecddd43885 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -10,6 +10,7 @@
 #include <linux/bitfield.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
+#include <nvhe/mem_protect.h>
 
 
 #define KVM_PTE_TYPE			BIT(1)
@@ -677,9 +678,9 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	/*
 	 * The refcount tracks valid entries as well as invalid entries if they
 	 * encode ownership of a page to another entity than the page-table
-	 * owner, whose id is 0.
+	 * owner, whose id is 0, or NOBODY, which does not correspond to a page-table.
 	 */
-	return !!pte;
+	return !!pte && pte != kvm_init_invalid_leaf_owner(PKVM_ID_NOBODY);
 }
 
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
-- 
2.37.0.rc0.104.g0611611a94-goog

