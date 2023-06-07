Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E2C727052
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 23:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbjFGVKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 17:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236429AbjFGVKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 17:10:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B74992
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 14:10:09 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53feeb13975so3059695a12.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 14:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686172208; x=1688764208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=w7Z/SdMXYjhkuszAlEVMnZ5/95aANKnnJVPer3MWcC4=;
        b=FYcomb03mMR0dPT3LebSWkoneJ4eSJk7TJleXChottOO7S0/1s0H9PY69SnNoEb18K
         27UYOjoxe8j5naBAx+CnRM/lO7HAxwvamMepA8kDAz56RUgOBpI+WcJpKjU1W67u6eDI
         uMLtZEsrOEQikP+osG/5UGwtLeE/EIm/yD7pWl0q+IyvHruAsSWMhphUBiIhzaPfpS2f
         LaTacortolfMjLhAW5gAQFy4nOsczO+UKqSMgFOIr1WQRm1b/UROw8UscgeErKVLVCoy
         f8u37v9ymgFQL8PNb2esru1895z4+zawfD57br+N9vKYKlVZgOmIXyuzyUP7FoS5MyLq
         WfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686172208; x=1688764208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w7Z/SdMXYjhkuszAlEVMnZ5/95aANKnnJVPer3MWcC4=;
        b=W3GXTp+jgByEAlIdYgbtpZIUNB+4qhbume9xhIPuUTE7L6+eU8EFszWxjuRXrorbsX
         IqJ4MsWcrVozVbHlGN6Kcxaa+uLcq/RPOPIHpuNoDe+f2/7EkQCyA453QvnuUGiNFE4d
         jE2yAJv2oNhrmEzgK3pH1ArazV/GDBHXXQx9IGcSt8WSfHgK/Xv4g9pVmXfcHT3+QYQf
         A3j0A0eDcrIJw8zcz99fB2yzda9ekcEB7DOhbbKWX7fru1hXbtH0bApZht1ilODxvC7e
         f2RMORTvT0SVEbhHyZAUaLvU80y+pajs0gWFLJ/weyEfark9AT7EIvPgLciXEJWEIYpL
         BGeg==
X-Gm-Message-State: AC+VfDyP/cHTMJCp62JPRCEbTe/lhdsDxHxgeLiZ0DVmwUPP+lyPrh2p
        ndzJJVsgt8GhmYm98weLpO8R63E/PCg=
X-Google-Smtp-Source: ACHHUZ63Yk6JvmCdU+3f98TH0xYyn3JE1vxFpuIKES2rWKU0FlywJMQZigJEmcJnZ/sFL+t8vxuzYiusD0w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f60d:0:b0:543:b015:600b with SMTP id
 m13-20020a63f60d000000b00543b015600bmr1486971pgh.8.1686172208492; Wed, 07 Jun
 2023 14:10:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  7 Jun 2023 14:09:56 -0700
In-Reply-To: <20230607210959.1577847-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607210959.1577847-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607210959.1577847-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/6] x86: Add defines for the various LBR
 record bit definitions
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Add defines for Intel's LBR info MSRs, and a define (along with a snarky
message) for AMD's lovely mispredict bit that is shoved into the LBR
MSRs themselves.  The AMD mispredict bit will be used to address false
positives in the LBRV tests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 0e3fd037..8abccf86 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -81,6 +81,17 @@
 #define MSR_IA32_LASTINTFROMIP		0x000001dd
 #define MSR_IA32_LASTINTTOIP		0x000001de
 
+/* Yes, AMD does indeed record mispredict info in the LBR records themselves. */
+#define AMD_LBR_RECORD_MISPREDICT	BIT_ULL(63)
+
+#define LBR_INFO_MISPRED		BIT_ULL(63)
+#define LBR_INFO_IN_TX			BIT_ULL(62)
+#define LBR_INFO_ABORT			BIT_ULL(61)
+#define LBR_INFO_CYC_CNT_VALID		BIT_ULL(60)
+#define LBR_INFO_CYCLES			0xffff
+#define LBR_INFO_BR_TYPE_OFFSET		56
+#define LBR_INFO_BR_TYPE		(0xfull << LBR_INFO_BR_TYPE_OFFSET)
+
 /* DEBUGCTLMSR bits (others vary by model): */
 #define DEBUGCTLMSR_LBR			(1UL <<  0) /* last branch recording */
 #define DEBUGCTLMSR_BTF			(1UL <<  1) /* single-step on branches */
-- 
2.41.0.162.gfafddb0af9-goog

