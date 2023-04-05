Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBFC6D71A1
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbjDEApb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbjDEAp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:45:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5904F468F
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:45:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5417f156cb9so341301207b3.8
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680655526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vzwiHRIkx/Ofvz49IPzfAACO6Ci51KB/Wu9lsV23c8g=;
        b=X0zmknsMe5WLmMccyTXLQG3HEv612eXVzRKnN8/ZIqgA8C5+68PswLGyJ75lEjdwSj
         /IwI8QPPL+nr5lUO/s+891Kfua4dDnvza+lYmwYBldQ5ZnX0hv5Oh466FPYtu/Xfkv7l
         qgt4UJ5HXVn84Bwp9qgZJ/ZZ7cvR0HWr91GfS7vyN6kiVjLhZCcetdNgou3W25U1vyKO
         uik15E6ZrTFRRDX2dNDoVW7qUM7d8srDSbxz57O2ANlIrfkURmz5fAbR5XnGMKP/jp+5
         XyLhAU80vOo7FONqF1G8S8E4pXyPBBrrSBZUbYocQ5kd39SZikffdZIgR6NX/1n+R8s+
         NeUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680655526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vzwiHRIkx/Ofvz49IPzfAACO6Ci51KB/Wu9lsV23c8g=;
        b=naPRJ12JQiE4/HYOwBD7rvnsdsDoOLumD1idLQHwkNLG+ezxBT2WS9uGi+cjK/vMSR
         EBFMXn6gpY8HZWA+JCmXoRjvFp6ehGiWrK0ZEtXdYi2DrFbUsaYwzeThk7LeadoPy36r
         y9J/R5gDQAeuo0itdRk6fYjC0y50uMtFnVTlLQ0TlH8Yp5RZ3MqeLDVXhXr27A7YSmPF
         ShTl7G0RT2b5G6PnbhH3iLhsS8qtD5yqu2Xx+CZNUbLQwjBN6a8/DKvDhLAEP8XtAhAC
         dEWq4E+wjMtWPNmVc0PoDq4u193ciA5/iND00sSxXPII17+j6wVJ8ECbRdjZYaS2OahS
         f6+Q==
X-Gm-Message-State: AAQBX9dnE7PObd5DWC210vE0BT6KBFRTRQ77qDmTjI7GmgZzdRXpxa50
        UIq2btiDe/k0pVFcbaL5q1psCMT53C0=
X-Google-Smtp-Source: AKy350Z8wrXsxgFcou8s4pHavGWJa+McW3YtZKVn2nnQBBST9Tum6IeAlxzfPur1/qkPTLiV7Vm91Ss9CdY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cacf:0:b0:b77:158d:b3a0 with SMTP id
 a198-20020a25cacf000000b00b77158db3a0mr777440ybg.6.1680655526560; Tue, 04 Apr
 2023 17:45:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:45:16 -0700
In-Reply-To: <20230405004520.421768-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405004520.421768-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405004520.421768-3-seanjc@google.com>
Subject: [PATCH v4 2/6] KVM: x86: Filter out XTILE_CFG if XTILE_DATA isn't permitted
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Filter out XTILE_CFG from the supported XCR0 reported to userspace if the
current process doesn't have access to XTILE_DATA.  Attempting to set
XTILE_CFG in XCR0 will #GP if XTILE_DATA is also not set, and so keeping
XTILE_CFG as supported results in explosions if userspace feeds
KVM_GET_SUPPORTED_CPUID back into KVM and the guest doesn't sanity check
CPUID.

Fixes: 445ecdf79be0 ("kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID")
Reported-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b6c6988d99b5..3402d69820da 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -3,6 +3,7 @@
 #define ARCH_X86_KVM_X86_H
 
 #include <linux/kvm_host.h>
+#include <asm/fpu/xstate.h>
 #include <asm/mce.h>
 #include <asm/pvclock.h>
 #include "kvm_cache_regs.h"
@@ -325,7 +326,22 @@ extern bool enable_pmu;
  */
 static inline u64 kvm_get_filtered_xcr0(void)
 {
-	return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+	u64 permitted_xcr0 = kvm_caps.supported_xcr0;
+
+	BUILD_BUG_ON(XFEATURE_MASK_USER_DYNAMIC != XFEATURE_MASK_XTILE_DATA);
+
+	if (permitted_xcr0 & XFEATURE_MASK_USER_DYNAMIC) {
+		permitted_xcr0 &= xstate_get_guest_group_perm();
+
+		/*
+		 * Treat XTILE_CFG as unsupported if the current process isn't
+		 * allowed to use XTILE_DATA, as attempting to set XTILE_CFG in
+		 * XCR0 without setting XTILE_DATA is architecturally illegal.
+		 */
+		if (!(permitted_xcr0 & XFEATURE_MASK_XTILE_DATA))
+			permitted_xcr0 &= ~XFEATURE_MASK_XTILE_CFG;
+	}
+	return permitted_xcr0;
 }
 
 static inline bool kvm_mpx_supported(void)
-- 
2.40.0.348.gf938b09366-goog

