Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BED358948A
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 00:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbiHCWuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 18:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbiHCWuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 18:50:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B5422B29
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 15:50:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x11-20020a170902ec8b00b0016d6b4c5003so11308980plg.15
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 15:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=oBCv022ttB7721Z3didtrTXQbQIFya4DDNpwzpvFOME=;
        b=nRGmFYXYob2GdMUmzVPtyDqEUR4f1txFj3eI4VVHWcJD5TA26Ng57GTnR4wknp5irR
         0OjY1XipvycfJdRNf4cc71TTbsTPrBJeUVhTaCTBop1TxwnSpeZOMIPzmYbk8/os/5H2
         dZGzbuS51W74pjnEjrCc420YzLoWTRHYj3jfXF2zQ0Sxqd7lA2Vc9qoeRkuYRxytuf4B
         wC87A7OWoSqN281vU9v6pWnZog8E6ukhTBQTVMdRgoOdiosuA/Wmy0a3Fxj8wrqdhsDu
         5GzDArttSXC1Av+hAzUYdVU5L2QaGTQvgtdlS6A8hDClbG1w3kyjHoNyZ8+b2nY0kvAs
         WPqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=oBCv022ttB7721Z3didtrTXQbQIFya4DDNpwzpvFOME=;
        b=aP2CUegQXheaQidVr6SPk1X+l2YdbxVxjKpKt9Hryb8jv1o3iIq8nc5VfYMF7FbLqs
         41iEqc0cOJahEJd6ycku60TR+6GzuOD69sRi/A50vqcnSVygT8pVKnlxLbzK2sDPueIW
         1dPQN69UDyjHASuo1fEiUCCPORtvBDIOYi5bgidwV4pmjep/lZ/S4K03FKQ9BV8b9gkV
         d33FjWf5/tWnuTtZZS4fsBgggtgSh9LPySiH5LpUcszPf0vIEgh7NZOxN3uzjybX3+yK
         65POYAxsRyKdp6YxE4O5G6sKlsJdArnTcfC46ywdArF+WVons3Q3uK4cnA1dFX8UBRLd
         Z8HQ==
X-Gm-Message-State: ACgBeo0QzEOnTkDHHSEo9ckyHE0nJ6yTw4Bza9mM+jFIQCSl3IzkXdqf
        0e+CeBq6hFLZTWRqnRZk37GYXJyjYy0=
X-Google-Smtp-Source: AA6agR7zPv57RHjUR3ZuU8Q/z+8q2Zn/VqyRgZ6WKpbjtCSR6GN6cuMeCSID45bhPnD2EN5qVoBQ84eyTR4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2303:b0:52e:526e:10e3 with SMTP id
 h3-20020a056a00230300b0052e526e10e3mr2678199pfh.77.1659567003637; Wed, 03 Aug
 2022 15:50:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Aug 2022 22:49:55 +0000
In-Reply-To: <20220803224957.1285926-1-seanjc@google.com>
Message-Id: <20220803224957.1285926-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220803224957.1285926-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2 1/3] KVM: x86: Tag kvm_mmu_x86_module_init() with __init
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mark kvm_mmu_x86_module_init() with __init, the entire reason it exists
is to initialize variables when kvm.ko is loaded, i.e. it must never be
called after module initialization.

Fixes: 1d0e84806047 ("KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded")
Cc: stable@vger.kernel.org
Reviewed-by: Kai Huang <kai.huang@intel.com>
Tested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8281d64a431..5ffa578cafe1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1704,7 +1704,7 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
 
-void kvm_mmu_x86_module_init(void);
+void __init kvm_mmu_x86_module_init(void);
 int kvm_mmu_vendor_module_init(void);
 void kvm_mmu_vendor_module_exit(void);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3e1317325e1f..bf808107a56b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6700,7 +6700,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
  * nx_huge_pages needs to be resolved to true/false when kvm.ko is loaded, as
  * its default value of -1 is technically undefined behavior for a boolean.
  */
-void kvm_mmu_x86_module_init(void)
+void __init kvm_mmu_x86_module_init(void)
 {
 	if (nx_huge_pages == -1)
 		__set_nx_huge_pages(get_nx_auto_mode());
-- 
2.37.1.559.g78731f0fdb-goog

