Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DAC584815
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 00:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiG1WSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 18:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbiG1WSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 18:18:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4531578DF3
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:18:04 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e123-20020a636981000000b0041a3e675844so1458792pgc.23
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 15:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=pMK326Dzz47oLnHyTt02WlUweZBXPrgublIXKnjlXLs=;
        b=IvZ6eY8kvJcRYMajPsxpgxvKuckIcFz2KmQGWJT3C+CW0DMU6PL4Bzlo/ENRyL7+Eh
         G4XPhKndip03jPsiYTgmDx7Nqkrir7S6G7+PU38jq9t0OfJMV/WtPrODlMQLvyxUTufx
         5TMmb2kdBBkjAgG77RIctTQrYXKdbBvxxRYbJ/KWqNRuVVucT4ygC5ft/NB48/1XcDKa
         SmXFcw84BJD/PCg2WMCvUY04QtzHYuURIkkpCB1B9Xs0pW0mv+XsLjMy+Y1kcu+sFxCL
         6JKgb7FNFJ/iSDx1rtTBO7UjxPqWQhDVHFDNm2ErVESeA5KRhqkS6eatTOc6YLOUkhR0
         nznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=pMK326Dzz47oLnHyTt02WlUweZBXPrgublIXKnjlXLs=;
        b=P1u5NQ7l0loXIgYr4W8HOq0dvsP8zx4MAYTZiDLjGSSsJsprhab+nYOGQaMCsIOtQg
         4pqgmKEo6z3kPmKJhEEPU3YG9kYqCP/jni0g4NNg1SHQsVxl4JnbN2awsGgCVbYe5ELt
         NBHDGmTebNoB1E7jely5z1t+TC44SdjLWO2OJHXpBei+4iQwNdih4XHD8++cgXkKaf4s
         e3ukjzzKZLm3VeEKjWrpQiPKyRY89Xthj8iBLc2CJ8wU5slwMjfirjxwjZRYZj7Dnwvb
         oP7axREzu8ZC3y5OE9eQ4ma4qmRhDUMbIXK5ZDwVqRrds0XkpgvbYz2Ra5J3dgWv+GXE
         cSbw==
X-Gm-Message-State: ACgBeo3mp/G4Eszjjfw/7Xm1YWSNteYDuK7nyffK/Qjc2IFoU+ahC9EL
        noHJbhkzcWp5d0eUVMwniVzBlLFD92U=
X-Google-Smtp-Source: AA6agR5J0r9RC8k4KPKoyp4aR5OSquWQ0jV/zZ0nJrOMiCYTbB6yzXApQ30OuliGZc5Et0WralgBhkcYjrM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1d90:b0:1f2:5f47:ca6c with SMTP id
 pf16-20020a17090b1d9000b001f25f47ca6cmr1522492pjb.162.1659046683830; Thu, 28
 Jul 2022 15:18:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 28 Jul 2022 22:17:56 +0000
In-Reply-To: <20220728221759.3492539-1-seanjc@google.com>
Message-Id: <20220728221759.3492539-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220728221759.3492539-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 1/4] KVM: x86: Tag kvm_mmu_x86_module_init() with __init
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
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
index 8e477333a263..2975fcb14c86 100644
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
2.37.1.455.g008518b4e5-goog

