Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA916B5309
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 22:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjCJVnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 16:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbjCJVnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 16:43:19 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C205313F6A3
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id m6-20020a056902118600b00aeb1e3dbd1bso6994223ybu.9
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 13:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678484575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4wFJBbDcDIknYvP9PkVIkSgktI2hIe9TbO9oei+TFB8=;
        b=i+JQY/cIPm1ONBBu2vV2F1Z236I/PD9d+Aj/AOkXUu69DFE1aUVEaCP945YiAOGsR1
         KMADHV1bu3vvetWTbijcdZf4xFCxrDPqO9FVCv9Ig+GZd+rKebfskzjYKJ16dEbB6gLW
         LeJlzI21BJzSSNZLl3btrR4lvKYww+gX3hlkmVBaKnjUz2/uAt/gnzV57D3Qtu8X4Z6s
         X8jAtxiuZL+guarwCViDUEa2uGgc7vx58h/MAcIizqlNLZs5uK9ihabv5F3yVzes/P22
         WM0UwQcsnPgu1DkUV8XhvVUxp6LNZ1jYuOqSqwyQC8ix+6/szkAO6ExwuU1A0nmHKVwk
         fNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484575;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4wFJBbDcDIknYvP9PkVIkSgktI2hIe9TbO9oei+TFB8=;
        b=HX3IdJ4A+zo+pyXhnlGRXqUx6FHPVcXPEJzZ+IfPgXv0VOkZH0Q8w+O/hl+O1+wQO5
         tNRtFMZ+nGpV5nK0+Ftnidla7LQ6p/2eQGyYmLNP6kWbcUq1r3Hyp5ViVYNLgmC4kLJK
         usW1EdxfV9/wqvIhIBDR2dZ+6gfWUxBCczBzpcQCnFh1zq/zVhdS5lQuhxDsJxz/z4+r
         CjXibqPJ/t6c8eI1O/bew4QKPTIZesdWja31sHYFir0EfpdwK/NmFql0RPmoJKt4Y1Cw
         2cF0f+sfczSO1jkAIjGFmeCahkTfWZpF1gao9y0nz4aDltYfhzEF+HmdfXkx3lTBBLYm
         +T6A==
X-Gm-Message-State: AO0yUKVYw0fFMh4e6bFdw7YQDSfcmo0IEmZLDbdfCVw/d3RrRsgxxV1k
        D4g0nZRSvBXj2iYs4vohcDteOGiuyVc=
X-Google-Smtp-Source: AK7set/POvl50DXDIgFBNb600X+Dhacs3V6WGOuMFaG2rb1iDN2jf0j6tvem5xkpr6Ss1nF98r1exRLhzUI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae62:0:b0:53c:6fda:b469 with SMTP id
 g34-20020a81ae62000000b0053c6fdab469mr17681347ywk.0.1678484574891; Fri, 10
 Mar 2023 13:42:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 13:42:23 -0800
In-Reply-To: <20230310214232.806108-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310214232.806108-10-seanjc@google.com>
Subject: [PATCH v2 09/18] x86/virt: KVM: Open code cpu_has_vmx() in KVM VMX
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold the raw CPUID check for VMX into kvm_is_vmx_supported(), its sole
user.  Keep the check even though KVM also checks X86_FEATURE_VMX, as the
intent is to provide a unique error message if VMX is unsupported by
hardware, whereas X86_FEATURE_VMX may be clear due to firmware and/or
kernel actions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 10 ----------
 arch/x86/kvm/vmx/vmx.c         |  2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index aaed66249ccf..b1171a5ad452 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -22,14 +22,6 @@
 /*
  * VMX functions:
  */
-
-static inline int cpu_has_vmx(void)
-{
-	unsigned long ecx = cpuid_ecx(1);
-	return test_bit(5, &ecx); /* CPUID.1:ECX.VMX[bit 5] -> VT */
-}
-
-
 /**
  * cpu_vmxoff() - Disable VMX on the current CPU
  *
@@ -61,8 +53,6 @@ static inline int cpu_vmx_enabled(void)
 }
 
 /** Disable VMX if it is enabled on the current CPU
- *
- * You shouldn't call this if cpu_has_vmx() returns 0.
  */
 static inline void __cpu_emergency_vmxoff(void)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9e196b9fe183..58856e196536 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2747,7 +2747,7 @@ static bool kvm_is_vmx_supported(void)
 {
 	int cpu = raw_smp_processor_id();
 
-	if (!cpu_has_vmx()) {
+	if (!(cpuid_ecx(1) & feature_bit(VMX))) {
 		pr_err("VMX not supported by CPU %d\n", cpu);
 		return false;
 	}
-- 
2.40.0.rc1.284.g88254d51c5-goog

