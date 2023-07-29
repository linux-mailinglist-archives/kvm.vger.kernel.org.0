Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C08767A25
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 02:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjG2Atk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 20:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbjG2AtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 20:49:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CEE44AE
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d1851c52f3dso2422798276.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 17:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591661; x=1691196461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RfXXcqZt8v+vEMviQaB4ha8ro96aOmyFYUDExhL33FE=;
        b=D+29wkyjLypapSHoJge1mpaMfPBHgyoydIEBosT6gdt3ZIvLSr9lW379+2twDS+9NN
         x8d9jNCpmbUF5qFqVmqFdk+q9BOi6GRROVAhUNufVZHuH6xCedDb3S1GXzaf2+a6ZkYX
         WcXffBZ+IgjsHuqASHKxYMFPAvTTogbstpNmvwdmcZfL5QGGqsYFEVkYc1tStEL2L7sv
         dyx2fHZlILnrsMXJcxTxFXr21doH+/dcswCPHamiZcg0CTfh3gRu70ahmuRwaMmXANTi
         8kjx7ldkDSK4tsFuKQyxCI2MgK/iVhypCHeoILCPx/DAHwGdTB54OBNagVdOVid8O9KI
         lAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591661; x=1691196461;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RfXXcqZt8v+vEMviQaB4ha8ro96aOmyFYUDExhL33FE=;
        b=WLIfaKCxGzFbq7v4FwmDpjm1g1Yro5Fn0u/Kyp9BoepXEX8RBqb3+Arf4vkS4wW7MJ
         9VoFHpBQx7WMlhXtAAdA/Kig5DzoPNC5O14zMvpS/TA1+X4MBpKIXrJ3CwnMtBVCVz3f
         JQ9UttuaviDnxOlsFCJ07aF5BlMlRh0nIo1ytBIofCDp3zaQAd0rG3BcTNdzcoUQEFqf
         NGm3jv6/7sbL0GDdTWfXwkSLHOAVkue1YrWfh9OJO8naJpYoeOpgP6h7BNBtq+e55CFA
         THNTskdDhcSUxwqNavXlxwVpsrZqRdaHq7bcB/xswrHAhNFodCYG/SeQyI4j086qalMY
         pofg==
X-Gm-Message-State: ABy/qLZL5imQM2o0Jh6j1Nt1iDdkZ8fqt9Q6V5s2a0sZ3+5hX5lcYY0A
        w7GabYwjOt/AOukMU4X+d10zBx8GA2E=
X-Google-Smtp-Source: APBJJlERmrEreSp3KWVd66uKyABQJknJ32dmGyLRrH0CXCcgkp0WqemQ/bWIBdjSnDq4poF74oFl4nwqsdI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:b0:cf9:3564:33cc with SMTP id
 w15-20020a056902100f00b00cf9356433ccmr24322ybt.13.1690591660993; Fri, 28 Jul
 2023 17:47:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 17:47:19 -0700
In-Reply-To: <20230729004722.1056172-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729004722.1056172-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729004722.1056172-10-seanjc@google.com>
Subject: [PATCH v3 09/12] KVM: x86/mmu: Replace MMU_DEBUG with proper
 KVM_PROVE_MMU Kconfig
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
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

Replace MMU_DEBUG, which requires manually modifying KVM to enable the
macro, with a proper Kconfig, KVM_PROVE_MMU.  Now that pgprintk() and
rmap_printk() are gone, i.e. the macro guards only KVM_MMU_WARN_ON() and
won't flood the kernel logs, enabling the option for debug kernels is both
desirable and feasible.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig            | 13 +++++++++++++
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/mmu/mmu_internal.h |  4 +---
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 89ca7f4c1464..4e5a282cc518 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -138,6 +138,19 @@ config KVM_XEN
 
 	  If in doubt, say "N".
 
+config KVM_PROVE_MMU
+	bool "Prove KVM MMU correctness"
+	depends on DEBUG_KERNEL
+	depends on KVM
+	depends on EXPERT
+	help
+	  Enables runtime assertions in KVM's MMU that are too costly to enable
+	  in anything remotely resembling a production environment, e.g. this
+	  gates code that verifies a to-be-freed page table doesn't have any
+	  present SPTEs.
+
+	  If in doubt, say "N".
+
 config KVM_EXTERNAL_WRITE_TRACKING
 	bool
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d46f77734f30..21ced900c3e9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1695,7 +1695,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 static void kvm_mmu_check_sptes_at_free(struct kvm_mmu_page *sp)
 {
-#ifdef MMU_DEBUG
+#ifdef CONFIG_KVM_PROVE_MMU
 	int i;
 
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index cfe925fefa68..40e74db6a7d5 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -6,9 +6,7 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
 
-#undef MMU_DEBUG
-
-#ifdef MMU_DEBUG
+#ifdef CONFIG_KVM_PROVE_MMU
 #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
 #else
 #define KVM_MMU_WARN_ON(x) do { } while (0)
-- 
2.41.0.487.g6d72f3e995-goog

