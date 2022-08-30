Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAF15A6B4D
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 19:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiH3RxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 13:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiH3Rww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 13:52:52 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2728BAE5B
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 10:49:58 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-340862314d9so169152517b3.3
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 10:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=qdcIT3aXMQ9POEdN/NuweRHQ1pTqvmpBvIOgZYrKpBM=;
        b=lryeRssPjNhAgu8RH3MjqWBLO58qSQ5bpVcUAKgTVXns9CHIAC4zpA64SK1FF+kFfh
         mxxzqdFwQ5NLEYDDnafGpMVEzGGkgjjF/WH++iGpLNuDHvq5GVMO0JDNqnn7TkD0uoNm
         Uvqfs+cnIcVMmtZgqAV9cNnJRdVyDVupkyW2TqbELx2fa3lDKfN0zpv2CsMh9c7zyvkX
         rixWSJ7mfGHOLG1h3kz+rpaT+kd/a9Nn7SCWVfAPSoIPElc279/mFndGczb1AMrB19Ct
         nLb7SLi2NuH49MfVA6c69tfgVo3gG7uwL8B7B/9cTZ3h2eoBzjORzRzUBJ+BQa7JsunM
         azpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=qdcIT3aXMQ9POEdN/NuweRHQ1pTqvmpBvIOgZYrKpBM=;
        b=yPaoYraNg6tkw1Eek/O5oGJ9B3WbB791Ubx94vJhlxi8fSfJRMx59nun8zAKuT7Vnt
         Pporj+39hcZHO7x2DrJgAQ+dmJHznBwzNCENnA12PHoVSOnrmBRdJ6XuOdUoCN7J0XDh
         VEAKmhs1ibqaZRHIu+g3xXTqwKCrLxJRUkNDOERChtYaMMTfhE566ifan44rX/V/BMd3
         zQtvUbWEu/26qc2C4tAgLhVvzlih808Pu+0ibSIcd7tWAkhv04Hj7bgfUvoVIYGPrxpr
         tiscizpDT29uabr+/bOtU8uYl6AGvZ5dR2yl8rbsyEJCfFDQs58pEm/01vIAYZ0SL9Jq
         XSQw==
X-Gm-Message-State: ACgBeo2NcqLD2HQnPw32RAfpwzJP1uORU7xYptigABzk8v/H4ikJ1m8L
        1W/Z/I/wSD1ZRBaYSq7rOQMpUpVZmIpXIfoxp7d7GxB0WUS/xxUOu4e5su1dDMXfOxpW8k2cEsW
        X9pXqrF/kZc+90H+JTzEslSBBVctSAaj9OHlmK+m6q9lb6q+OBsmNbC/DUDfp6I8=
X-Google-Smtp-Source: AA6agR7V7uUdnoiuB4l1FY0JoT4I+aGA6WAouS4wbFLJABHfhxuXV5igBPwCWOp1aY1DhpxhNzB1ro5w1d2m8g==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a5b:3ce:0:b0:66f:4692:27a2 with SMTP id
 t14-20020a5b03ce000000b0066f469227a2mr12739934ybp.167.1661881797354; Tue, 30
 Aug 2022 10:49:57 -0700 (PDT)
Date:   Tue, 30 Aug 2022 10:49:47 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830174947.2182144-1-jmattson@google.com>
Subject: [PATCH v2] KVM: x86: Mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vipin Sharma <vipinsh@google.com>
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

KVM should not claim to virtualize unknown IA32_ARCH_CAPABILITIES
bits. When kvm_get_arch_capabilities() was originally written, there
were only a few bits defined in this MSR, and KVM could virtualize all
of them. However, over the years, several bits have been defined that
KVM cannot just blindly pass through to the guest without additional
work (such as virtualizing an MSR promised by the
IA32_ARCH_CAPABILITES feature bit).

Define a mask of supported IA32_ARCH_CAPABILITIES bits, and mask off
any other bits that are set in the hardware MSR.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Fixes: 5b76a3cff011 ("KVM: VMX: Tell the nested hypervisor to skip L1D flush on vmentry")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Vipin Sharma <vipinsh@google.com>
---

 v1 -> v2: Clarified comment about unsupported bits.

 arch/x86/kvm/x86.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205ebdc2b11b..9a18acfcfdc8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1557,12 +1557,32 @@ static const u32 msr_based_features_all[] = {
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
 static unsigned int num_msr_based_features;
 
+/*
+ * Some IA32_ARCH_CAPABILITIES bits have dependencies on MSRs that KVM
+ * does not yet virtualize. These include:
+ *   10 - MISC_PACKAGE_CTRLS
+ *   11 - ENERGY_FILTERING_CTL
+ *   12 - DOITM
+ *   18 - FB_CLEAR_CTRL
+ *   21 - XAPIC_DISABLE_STATUS
+ *   23 - OVERCLOCKING_STATUS
+ */
+
+#define KVM_SUPPORTED_ARCH_CAP \
+	(ARCH_CAP_RDCL_NO | ARCH_CAP_IBRS_ALL | ARCH_CAP_RSBA | \
+	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
+	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
+	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
+	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
+
 static u64 kvm_get_arch_capabilities(void)
 {
 	u64 data = 0;
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
+		data &= KVM_SUPPORTED_ARCH_CAP;
+	}
 
 	/*
 	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
@@ -1610,9 +1630,6 @@ static u64 kvm_get_arch_capabilities(void)
 		 */
 	}
 
-	/* Guests don't need to know "Fill buffer clear control" exists */
-	data &= ~ARCH_CAP_FB_CLEAR_CTRL;
-
 	return data;
 }
 
-- 
2.37.2.672.g94769d06f0-goog

