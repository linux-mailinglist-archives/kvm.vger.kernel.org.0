Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA68A778450
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 01:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbjHJXt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 19:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbjHJXt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 19:49:26 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F359D2D53
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:49:24 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-26957018988so1712353a91.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691711364; x=1692316164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WMPe2NIMjXJcWowFfDwErjX/zalQdCmsflMWWEEOcuo=;
        b=d7jjy5/AjtnCGxszuB7lAloMbDsavS+OxL1L+9ajnm5Qz/Y41Z1HgawGVsunTUS3xB
         dqcAxCYwbvgbMRbN0nW3VCxeCNJkAUonDBIq7bfmj3bpZcxYkXpflWcNEgD2rTCkap+T
         IePqZu8IGKglgFlO74RS9KRjymGEQb8S/NFO/hVu19GnxTYtwH0AUY/So2DEapA7nvha
         Tht7/Q3vLjDfkl9g2FmxocBIfgE95sWGpDfRjHgcpYNKXdlr1/YbB7eYq+rmdlVinP9+
         BCTcd4/s2uOMlfXjfgoVPnPZsZego0tS/+3I7sRNhkUPL/Dp4/0oPN/SH/YFiyY0VNrL
         3A2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691711364; x=1692316164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WMPe2NIMjXJcWowFfDwErjX/zalQdCmsflMWWEEOcuo=;
        b=TnwRgLWRy7GUilAFZIlEal4hAqJudJm6znOKf/3OmTw9B/WqyfO26UKcF4rg85ML2y
         jAUtTG76EC2m4PQwfIIiFeEANCKPETg9ebbXo5rnBUjwOkLf5jL2RDWqcylHdhgk5YRh
         TSFkuAxTS7vptBV9rUmbxeVH1oNE5dWaKqkZkWhZ6Lx+6br6+982Iv1t1dIzEhJcyNfn
         FTyX747KRf5w6j832ssJ6FBpVrP1honRptzrg3d86V7tpWdZiHM+H56iMclQRcpiw5Eh
         IkF7vY/upJlWWgfVWXpel10jmN7FvvuyAat6ZekBDXmi5qsFdOxAF/mqWHcQQDtpJt6j
         RKoQ==
X-Gm-Message-State: AOJu0YwPSQc9M5bDEA7hBQWxO9pu7vHKHfax1y+YapxyQcyx7vlFSy0U
        t9n6Txihy8gijGsJgpvh7Ei/VBsbAsU=
X-Google-Smtp-Source: AGHT+IF5dfV2psEnzrif/xrVyroYLVg73dtvIBZ1EpixRBC1zh3pE/e8lsfgLte3lNjKoBQFP1xsiuWzrSQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4009:b0:26b:dcc:eea0 with SMTP id
 ie9-20020a17090b400900b0026b0dcceea0mr11392pjb.9.1691711364542; Thu, 10 Aug
 2023 16:49:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Aug 2023 16:49:18 -0700
In-Reply-To: <20230810234919.145474-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230810234919.145474-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230810234919.145474-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: SVM: Require nrips support for SEV guests (and beyond)
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
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
index 581958c9dd4d..7cb5ef5835c2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -202,7 +202,7 @@ static int nested = true;
 module_param(nested, int, S_IRUGO);
 
 /* enable/disable Next RIP Save */
-static int nrips = true;
+int nrips = true;
 module_param(nrips, int, 0444);
 
 /* enable/disable Virtual VMLOAD VMSAVE */
@@ -5191,9 +5191,11 @@ static __init int svm_hardware_setup(void)
 
 	svm_adjust_mmio_mask();
 
+	nrips = nrips && boot_cpu_has(X86_FEATURE_NRIPS);
+
 	/*
 	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
-	 * may be modified by svm_adjust_mmio_mask()).
+	 * may be modified by svm_adjust_mmio_mask()), as well as nrips.
 	 */
 	sev_hardware_setup();
 
@@ -5205,11 +5207,6 @@ static __init int svm_hardware_setup(void)
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
2.41.0.694.ge786442a9b-goog

