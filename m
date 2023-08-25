Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF28787D3E
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 03:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbjHYBg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 21:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237383AbjHYBga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 21:36:30 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B842E10F4
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:36:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56385c43eaeso490015a12.1
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692927387; x=1693532187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=772R3fhvb1hJ+WgPywPWa6C7fO5Csuzrt1s6mb5DckI=;
        b=X+2BvBC6u4TKcVZ++ZGwunu3SE65Gvh4sabEesPL6PDVApqC+rvcTGf9MqAe5Y0R8j
         kCtoXMGfOylqtra+yu8AUH9NLn53MMLo7SVFskt93r+TipgOuHS2ThDMKGqNmZHYLDqG
         WPpjG4amQ0WJAVueUBcuOtELYU/v0oZnVSOPO/LdOS8XYoWDYArMmi8I5xts5uYlYAxa
         JgVf+ItKSjpH1zRuYLCNvIFM+S+hwf6Vi9VPah2pochSNfNKPwek57C/GaAlTPaEDuAR
         0758uex/2pgTcV41xNUVwWTCBLV+BNlR1H80eELH7Dek4kH5MJTGi+YqQ0oZ8qeTtQZi
         wwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692927387; x=1693532187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=772R3fhvb1hJ+WgPywPWa6C7fO5Csuzrt1s6mb5DckI=;
        b=JeP4jJdjxxBMX+AOoP5AogJbFudFD4C81kxo82NklF6Qsfq9T6vs6wjoWSuwfXTBV5
         /ULxEAcy1a+o/qP2ewhq0Nks+xgmkWWe7IxNdYQpN08hzMfGXYm73KWX/5mbMrW2JeZK
         /jYqKcbGlQIKcKCaaE3Ejg4+zquRsSIl4wdMorg0qb4iZrQQcTUDln1aztu84Z6RjS91
         WRiQmHSUADEdrLWKLCAwlKKoeLFt4TO5LPZE70lHke2mZ+quQYC8nILcD/cgmAJrcxAJ
         HYFrYYaHFfxkCaouAwflWFR+3TsefQEaXZ+JrqbtuBrAtFW67Mev2CgUN2Jg8Wcf4x3r
         7VTg==
X-Gm-Message-State: AOJu0YwI+rrNyhuR3hj93R4SFaKomBDBrv+fOgYqtCNMksLwSkJok44w
        k3f6VC+tr2hNDGX64mOihnfggb8Ea8M=
X-Google-Smtp-Source: AGHT+IFDstNWi9yd4ZsrD/aOyXNKkLudrxgwtqrCjoQNo0eWK/ax8ovhPQNmwtRTJTChjIOU1w100912sTI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3383:0:b0:565:eb0b:626a with SMTP id
 z125-20020a633383000000b00565eb0b626amr2673084pgz.4.1692927387236; Thu, 24
 Aug 2023 18:36:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Aug 2023 18:36:19 -0700
In-Reply-To: <20230825013621.2845700-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825013621.2845700-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230825013621.2845700-3-seanjc@google.com>
Subject: [PATCH v2 2/4] KVM: SVM: Require nrips support for SEV guests (and beyond)
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disallow SEV (and beyond) if nrips is disabled via module param, as KVM
can't read guest memory to partially emulate and skip an instruction.  All
CPUs that support SEV support NRIPS, i.e. this is purely stopping the user
from shooting themselves in the foot.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c |  2 +-
 arch/x86/kvm/svm/svm.c | 11 ++++-------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2cd15783dfb9..8ce9ffc8709e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2185,7 +2185,7 @@ void __init sev_hardware_setup(void)
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
-	if (!sev_enabled || !npt_enabled)
+	if (!sev_enabled || !npt_enabled || !nrips)
 		goto out;
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bd53b2d497d0..b21253c9ceb4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -202,7 +202,7 @@ static int nested = true;
 module_param(nested, int, S_IRUGO);
 
 /* enable/disable Next RIP Save */
-static int nrips = true;
+int nrips = true;
 module_param(nrips, int, 0444);
 
 /* enable/disable Virtual VMLOAD VMSAVE */
@@ -5203,9 +5203,11 @@ static __init int svm_hardware_setup(void)
 
 	svm_adjust_mmio_mask();
 
+	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
+
 	/*
 	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
-	 * may be modified by svm_adjust_mmio_mask()).
+	 * may be modified by svm_adjust_mmio_mask()), as well as nrips.
 	 */
 	sev_hardware_setup();
 
@@ -5217,11 +5219,6 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	if (nrips) {
-		if (!boot_cpu_has(X86_FEATURE_NRIPS))
-			nrips = false;
-	}
-
 	enable_apicv = avic = avic && avic_hardware_setup();
 
 	if (!enable_apicv) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2237230aad98..860511276087 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -34,6 +34,7 @@
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
+extern int nrips;
 extern int vgif;
 extern bool intercept_smi;
 extern bool x2avic_enabled;
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

