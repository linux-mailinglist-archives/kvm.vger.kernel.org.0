Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FBA4DE1DE
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 20:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbiCRTkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 15:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240261AbiCRTkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 15:40:10 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1C610CF3D
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 12:38:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2e589b1f3c4so79070197b3.9
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 12:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=A4+XIKos4PkA5PUWtKvp/crs3G2yPwben9yuSUF/Cok=;
        b=Mxysyu0JPDKhG4fvfBOTuNoi0uy6GPJJRW8Q1jj5BTfHEtrEGp07D5HRNAgDbyExup
         p3vBZlU07UyIadl0jVDljrOrR6HlGjiE+3NRxbRnRxx58H5vDI0Pf3SXshcd7gsJF/gZ
         X6SvI37MLemSbp7nqqXGjYR0iQASqxwCAbPULBQ8FDusHE6jmzRYWnQzqnAuEuAJRcUf
         9x0bzsdsJns3wBTBKWIKdmXMXgQsoF+iH3xW1UK55spGKFK650l01ZdMNaiN6sDUW2UC
         Ix+IRacvv6UmIgLLpZw4YGuzsstDVHeLuGqMVaHZc0lbP0aOhF82/tb9aoIA2z3b2Fef
         9MTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=A4+XIKos4PkA5PUWtKvp/crs3G2yPwben9yuSUF/Cok=;
        b=Y/pkB7tCQd3Xv5rW9dXb94KSqR8kWrZAc7PYOeFD14IUAbrijECpLk3g/MgIpPqYGy
         uP/0MzFyGG9FcFE6U1mm/ynzKsl167Yrdtg46xYr3uZTH5dHPX+b0Fsc2YfyuN81S65P
         4EOxy5yYOD1o5bjUusfCGehlvOLjDA0d2FPQoQM2ps7RezoImDgvEIfV6m9qHHDBaktJ
         fGKmVk+yFr7Iwu4ldxwK3TMSHY8RXtLIKf9thmSlB0sPZOCcx3bLIOKf3DE4NLAOsbBM
         T1Awn76K/wdTNSYREx1VXMtCJcI1Z0PTLSsa/mrMVCc9P9W+NUpink6UkwgkMrkH7b4H
         01Cg==
X-Gm-Message-State: AOAM530SOtUBCUK1vsFm2UkI4+rW0pVnbkhiBCzuxhUIE+2WIUb+3waZ
        ykui6s/H+XrPem+6GqEj3C9CksaNU5k=
X-Google-Smtp-Source: ABdhPJztfEv9sfkm6TJFpaI48HRSsOUCD3lKH1sR2VDcArNkH6v02JyB7zu2cpTG/sDFd+RCzo3Se6/3MzE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7310:0:b0:633:b888:5639 with SMTP id
 o16-20020a257310000000b00633b8885639mr5504409ybc.351.1647632331235; Fri, 18
 Mar 2022 12:38:51 -0700 (PDT)
Date:   Fri, 18 Mar 2022 19:38:30 +0000
In-Reply-To: <20220318193831.482349-1-oupton@google.com>
Message-Id: <20220318193831.482349-2-oupton@google.com>
Mime-Version: 1.0
References: <20220318193831.482349-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 1/2] KVM: arm64: Generally disallow SMC64 for AArch32 guests
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>
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

The only valid calling SMC calling convention from an AArch32 state is
SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
when called from AArch32 rather than comparing against known SMC64 PSCI
functions.

Note that without this change KVM advertises the SMC64 flavor of
SYSTEM_RESET2 to AArch32 guests.

Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index a433c3eac9b7..cd3ee947485f 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -216,15 +216,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
-	switch(fn) {
-	case PSCI_0_2_FN64_CPU_SUSPEND:
-	case PSCI_0_2_FN64_CPU_ON:
-	case PSCI_0_2_FN64_AFFINITY_INFO:
-		/* Disallow these functions for 32bit guests */
-		if (vcpu_mode_is_32bit(vcpu))
-			return PSCI_RET_NOT_SUPPORTED;
-		break;
-	}
+	/*
+	 * Prevent 32 bit guests from calling 64 bit PSCI functions.
+	 */
+	if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
+		return PSCI_RET_NOT_SUPPORTED;
 
 	return 0;
 }
-- 
2.35.1.894.gb6a874cedc-goog

