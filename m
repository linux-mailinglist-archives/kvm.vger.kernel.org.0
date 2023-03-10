Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B9A6B5318
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbjCJVot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjCJVoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:44:16 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F43588EEE
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:43:24 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id k17-20020a170902d59100b0019abcf45d75so3398172plh.8
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ksXX7w7DOgMSUfWcc6++N7pFfPEmS+/uh5KW2SxRWLg=;
        b=CdkmpywEjUR3b6EjxKkPa4YvZWHbCoXcmVBs3Hrb87A0RA1IF7R1chC4RjF2JU1UOO
         T/cPDMvG5as5m9qH6MplauVwoTRVSihJS3LAgYhtKzJX8Z1kYl4K5wiFEuEgOVRLSnGw
         moRsmkKH4UmV0BGwbRQbwpF+m76vXrmtiVO2m644ebUcqa/l6EUx13O5BGJaHJ+3NFZR
         T3Zkce7rO2JaWHF2Bk617TTUV2pO00zgP6GgppW8x5bVerYKtHy32JCdD7FgQieizCTs
         eiPnzyTcqjOSubxVy0dYUkClK8MpTWRqAu9J4BBo4EwRRL8Aw7W1OqcsW5dgcZu+QSuI
         2Z+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksXX7w7DOgMSUfWcc6++N7pFfPEmS+/uh5KW2SxRWLg=;
        b=JcepzYwp/YKDz7th/7/RIKS0heNrSKKh+xS2RNc+PySrV4d7nGy1MnpvXNd0sty45b
         l3EFEa11Yt3jy6Z7ZrpLIFdGc5dBt0wtzycXvzrXvfY82ySvu+NEg8jfcm1qLUjcnL1a
         7niHh3CSktbuAYY128HnbL5/Sqn7DvRJscXPtaf1JYkK9K6LQh1Vbrc8QYJvCNKTa0Ia
         llu2EDRRQspN1LcqPRwroQxbMC2LeUGErHshzh5ntIU0L+IYFry6REGIg0In6XzE8DP7
         q4xYlzS5fzVyzDwuELGcvGahTjR9kQSGJDYt2Q8h0SsPmnEU807PM6jq9YLRcDiLjFmK
         DDkg==
X-Gm-Message-State: AO0yUKXE4ACrNlvDgeLk9tRU1tJBCbub/QfqyejTq6fGbj2syUd5Lhju
        dMTUroo28li1XAo4rMumPzDNyAmtLyI=
X-Google-Smtp-Source: AK7set+XsHBE74XVTrryN54b8Gg3t9oEH4NnaUYXf+7w5reulKwgA27aofO8Yoo5+U0IPiFzcXypJh/zuqc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f90b:b0:19f:1ee9:a14 with SMTP id
 kw11-20020a170902f90b00b0019f1ee90a14mr331047plb.4.1678484588314; Fri, 10 Mar
 2023 13:43:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:30 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-17-seanjc@google.com>
Subject: [PATCH v2 16/18] x86/virt: KVM: Move "disable SVM" helper into KVM SVM
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move cpu_svm_disable() into KVM proper now that all hardware
virtualization management is routed through KVM.  Remove the now-empty
virtext.h.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 50 ----------------------------------
 arch/x86/kvm/svm/svm.c         | 28 +++++++++++++++++--
 2 files changed, 25 insertions(+), 53 deletions(-)
 delete mode 100644 arch/x86/include/asm/virtext.h

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
deleted file mode 100644
index 632575e257d8..000000000000
--- a/arch/x86/include/asm/virtext.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/* CPU virtualization extensions handling
- *
- * This should carry the code for handling CPU virtualization extensions
- * that needs to live in the kernel core.
- *
- * Author: Eduardo Habkost <ehabkost@redhat.com>
- *
- * Copyright (C) 2008, Red Hat Inc.
- *
- * Contains code from KVM, Copyright (C) 2006 Qumranet, Inc.
- */
-#ifndef _ASM_X86_VIRTEX_H
-#define _ASM_X86_VIRTEX_H
-
-#include <asm/processor.h>
-
-#include <asm/vmx.h>
-#include <asm/svm.h>
-#include <asm/tlbflush.h>
-
-/*
- * SVM functions:
- */
-/** Disable SVM on the current CPU
- */
-static inline void cpu_svm_disable(void)
-{
-	uint64_t efer;
-
-	wrmsrl(MSR_VM_HSAVE_PA, 0);
-	rdmsrl(MSR_EFER, efer);
-	if (efer & EFER_SVME) {
-		/*
-		 * Force GIF=1 prior to disabling SVM to ensure INIT and NMI
-		 * aren't blocked, e.g. if a fatal error occurred between CLGI
-		 * and STGI.  Note, STGI may #UD if SVM is disabled from NMI
-		 * context between reading EFER and executing STGI.  In that
-		 * case, GIF must already be set, otherwise the NMI would have
-		 * been blocked, so just eat the fault.
-		 */
-		asm_volatile_goto("1: stgi\n\t"
-				  _ASM_EXTABLE(1b, %l[fault])
-				  ::: "memory" : fault);
-fault:
-		wrmsrl(MSR_EFER, efer & ~EFER_SVME);
-	}
-}
-
-#endif /* _ASM_X86_VIRTEX_H */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f04b61c3d9d8..2db03991dcdf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -41,7 +41,6 @@
 #include <asm/reboot.h>
 #include <asm/fpu/api.h>
 
-#include <asm/virtext.h>
 #include "trace.h"
 
 #include "svm.h"
@@ -584,9 +583,32 @@ void __svm_write_tsc_multiplier(u64 multiplier)
 	preempt_enable();
 }
 
+static inline void kvm_cpu_svm_disable(void)
+{
+	uint64_t efer;
+
+	wrmsrl(MSR_VM_HSAVE_PA, 0);
+	rdmsrl(MSR_EFER, efer);
+	if (efer & EFER_SVME) {
+		/*
+		 * Force GIF=1 prior to disabling SVM to ensure INIT and NMI
+		 * aren't blocked, e.g. if a fatal error occurred between CLGI
+		 * and STGI.  Note, STGI may #UD if SVM is disabled from NMI
+		 * context between reading EFER and executing STGI.  In that
+		 * case, GIF must already be set, otherwise the NMI would have
+		 * been blocked, so just eat the fault.
+		 */
+		asm_volatile_goto("1: stgi\n\t"
+				  _ASM_EXTABLE(1b, %l[fault])
+				  ::: "memory" : fault);
+fault:
+		wrmsrl(MSR_EFER, efer & ~EFER_SVME);
+	}
+}
+
 static void svm_emergency_disable(void)
 {
-	cpu_svm_disable();
+	kvm_cpu_svm_disable();
 }
 
 static void svm_hardware_disable(void)
@@ -595,7 +617,7 @@ static void svm_hardware_disable(void)
 	if (tsc_scaling)
 		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 
-	cpu_svm_disable();
+	kvm_cpu_svm_disable();
 
 	amd_pmu_disable_virt();
 }
-- 
2.40.0.rc1.284.g88254d51c5-goog

