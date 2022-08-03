Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E1B58948E
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 00:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238551AbiHCWuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 18:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238292AbiHCWuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 18:50:11 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F3E4D4C2
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 15:50:08 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31f56f635a9so153483947b3.4
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 15:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=SPa2O+7Mze0bsq8ap8FmcbiFuFSXZGJKxHFkzvC7sT8=;
        b=mDV2yaRQ40EVKU/eNX/FCSCMbrm3jI3NTGk+xe5bhVD9DzGKwvGcHuXotUJbowBoaE
         cjVjtTKgs+CH4nn/bvEP5KVZaboce2sBNMMbfqK5N22Xgtj95BsewTqXyj4tixPlQBbJ
         l3adCyQl/4S9dz7hR29gXjSqueoATUfHAqSZEJPnLhsA3taMs/cB89DrBOigZpQjNgqp
         A9NALz2pEEzsY/k8KKqZ2eld7+xe8ZT32e4cDLzMxXjPhEDbyrIB4WACv4XOGoNX8mlK
         Rak3qAyp2O3eDEn9wVvJq8MXcgd95xZKoXMARo54eAS1dPnbfMTY8jfp1AGf8mI69jRP
         hofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=SPa2O+7Mze0bsq8ap8FmcbiFuFSXZGJKxHFkzvC7sT8=;
        b=jaFUy+XowH1xB404IemyIkNilRr6XWKdhtkhVajCwWD8GWTPwqSusiEwcRs9pLGxVa
         fUhQU38f6e8D9OGdfenFEe+D4iY612hEdFK2lBHGdmNlbL/eIAphk3wDw/NlFPtH6//v
         wqFOhdIhM/ECbrPLWRPJ45JJVd87xIzNmX+/NyOG39l+/FcwuIlZzDu3Wvz8UKjPK2oE
         1GfkgcNRBIUPWrRbp6U1hqwAvld4D7IbPHCT+ZreZgluUOEngusmP1834eBDLGcAqY1l
         m32tgwNtzS7EFbVjvENzBrEgVddAONL44onc4iujd652irN2ORTF9t51jyeS7w4cQ/Fj
         dMww==
X-Gm-Message-State: ACgBeo1Mgdr2wZAY/VBkjfXpiSCQ2HcCPHPPFH3uvPzErC0jqN8srGZd
        8rWnBiJsurSYcNCHgXVYDrfzz/aLMyA=
X-Google-Smtp-Source: AA6agR4vvYuZchZorwqNL4ADWM2SVsdXLpazfIk0/fo45JEQlQw8DGJMrYjsMUzBSUry6w5MQIFt772ped0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7a82:0:b0:671:6802:fb8d with SMTP id
 v124-20020a257a82000000b006716802fb8dmr20992881ybc.224.1659567007526; Wed, 03
 Aug 2022 15:50:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Aug 2022 22:49:57 +0000
In-Reply-To: <20220803224957.1285926-1-seanjc@google.com>
Message-Id: <20220803224957.1285926-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220803224957.1285926-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2 3/3] KVM: SVM: Disable SEV-ES support if MMIO caching is disable
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

Disable SEV-ES if MMIO caching is disabled as SEV-ES relies on MMIO SPTEs
generating #NPF(RSVD), which are reflected by the CPU into the guest as
a #VC.  With SEV-ES, the untrusted host, a.k.a. KVM, doesn't have access
to the guest instruction stream or register state and so can't directly
emulate in response to a #NPF on an emulated MMIO GPA.  Disabling MMIO
caching means guest accesses to emulated MMIO ranges cause #NPF(!PRESENT),
and those flavors of #NPF cause automatic VM-Exits, not #VC.

Adjust KVM's MMIO masks to account for the C-bit location prior to doing
SEV(-ES) setup, and document that dependency between adjusting the MMIO
SPTE mask and SEV(-ES) setup.

Fixes: b09763da4dd8 ("KVM: x86/mmu: Add module param to disable MMIO caching (for testing)")
Reported-by: Michael Roth <michael.roth@amd.com>
Tested-by: Michael Roth <michael.roth@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h      |  2 ++
 arch/x86/kvm/mmu/spte.c |  1 +
 arch/x86/kvm/mmu/spte.h |  2 --
 arch/x86/kvm/svm/sev.c  | 10 ++++++++++
 arch/x86/kvm/svm/svm.c  |  9 ++++++---
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index a99acec925eb..6bdaacb6faa0 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -6,6 +6,8 @@
 #include "kvm_cache_regs.h"
 #include "cpuid.h"
 
+extern bool __read_mostly enable_mmio_caching;
+
 #define PT_WRITABLE_SHIFT 1
 #define PT_USER_SHIFT 2
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 66f76f5a15bd..03ca740bf721 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -22,6 +22,7 @@
 bool __read_mostly enable_mmio_caching = true;
 static bool __ro_after_init allow_mmio_caching;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
+EXPORT_SYMBOL_GPL(enable_mmio_caching);
 
 u64 __read_mostly shadow_host_writable_mask;
 u64 __read_mostly shadow_mmu_writable_mask;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 26b144ffd146..9a9414b8d1d6 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -5,8 +5,6 @@
 
 #include "mmu_internal.h"
 
-extern bool __read_mostly enable_mmio_caching;
-
 /*
  * A MMU present SPTE is backed by actual memory and may or may not be present
  * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b0e793e7d85c..28064060413a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
 
+#include "mmu.h"
 #include "x86.h"
 #include "svm.h"
 #include "svm_ops.h"
@@ -2221,6 +2222,15 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled)
 		goto out;
 
+	/*
+	 * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
+	 * instruction stream, i.e. can't emulate in response to a #NPF and
+	 * instead relies on #NPF(RSVD) being reflected into the guest as #VC
+	 * (the guest can then do a #VMGEXIT to request MMIO emulation).
+	 */
+	if (!enable_mmio_caching)
+		goto out;
+
 	/* Does the CPU support SEV-ES? */
 	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
 		goto out;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 38f873cb6f2c..f3813dbacb9f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5034,13 +5034,16 @@ static __init int svm_hardware_setup(void)
 	/* Setup shadow_me_value and shadow_me_mask */
 	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
 
-	/* Note, SEV setup consumes npt_enabled. */
+	svm_adjust_mmio_mask();
+
+	/*
+	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
+	 * may be modified by svm_adjust_mmio_mask()).
+	 */
 	sev_hardware_setup();
 
 	svm_hv_hardware_setup();
 
-	svm_adjust_mmio_mask();
-
 	for_each_possible_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
-- 
2.37.1.559.g78731f0fdb-goog

