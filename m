Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21AA67F2D3
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 01:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjA1AOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 19:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjA1AOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 19:14:31 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F5B7B40C
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:14:30 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id by10-20020a056a00400a00b005918acc2e44so3010395pfb.9
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iwlcdlJJgNxaN7KocVWCGFnG+kPyVohvYqXCxDe6XuM=;
        b=mAL/PvUSfxHJU7ATYhzNLnuzW9F2kvWTQEwpOIpDfhAtTqnD/Pf4LqrF1myJH6GbBy
         eusgGt0Ee3nfpYFyW192VjAIVORMH3fs8qyByuFvzuNOfXnEtSib4PPJwhx+HZG97I7H
         cDZWggsyLo6Mo7kYzLT9W3/nWwppkUzs+TJGyCD/codVSyeZSKidETC/2gT97QYHj8sp
         MFLgn+miHvKc/XlYJjx9jLWR5TZ0WN9HitIfRptRCn7bTSi5yQ04SZObOBn+/S4Jp0BX
         ZJ0Q/36NLzBcIwmcaR0fdKg4//N6w+zVi8xeasf0322d03ieBSz74NTJoD+rbuCFZhTq
         /gjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iwlcdlJJgNxaN7KocVWCGFnG+kPyVohvYqXCxDe6XuM=;
        b=FzaInpVWiOnEXyLDLphH4wm9HxBDfZI1hLX6wZRXi4Mp95DqxpS6LDuZiOhvsw025y
         VUkjom0V6FE8/Wz5/U0IPi7G2/uWcfR5b85wJm8znIWtgAIEgDHlth7+UQTVEemdw+X5
         ddVHVDedx+0+cCVWk4dJnbjmLjrc8+P3mPB/P9fz6ZAJwniUYMevq+ykaJxI1PSxyQ3W
         ZdvzVoOpU8DVKyCgodyTW+MKLdXH4mHpwT9rK/0F3pRyJXueQUS0ViE1hNaLmsRaQGS6
         RInBvcnfSmBZW3eiajxz6JWe8Bv6zPbogD3IUvqR7Ar3N5juN8vilCEJuE6gkeCx1Mx6
         wyYw==
X-Gm-Message-State: AO0yUKWwkQwGGSFzKt+bkXHHs9mb0WEoX3OYWL0J/5cz+MvuQPDIZ7Qn
        bnNgq7UVTN7QBo712RLHXMg6ZlgXaZs=
X-Google-Smtp-Source: AK7set/Son7/82cuGTzehMpialLra+Qlm9kv4QQ9rdurmaMqqFqZ63fIiMIjFT3QWkGpkmoJAsMbmJfsZ1U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1990:b0:593:909f:ed45 with SMTP id
 d16-20020a056a00199000b00593909fed45mr181136pfl.0.1674864869971; Fri, 27 Jan
 2023 16:14:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 28 Jan 2023 00:14:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230128001427.2548858-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs are available
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
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

Disallow enabling LBR support if the CPU supports architectural LBRs.
Traditional LBR support is absent on CPU models that have architectural
LBRs, and KVM doesn't yet support arch LBRs, i.e. KVM will pass through
non-existent MSRs if userspace enables LBRs for the guest.

Cc: stable@vger.kernel.org
Cc: Yang Weijiang <weijiang.yang@intel.com>
Cc: Like Xu <like.xu.linux@gmail.com>
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Am I missing something that would prevent this scenario?

 arch/x86/kvm/vmx/vmx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8f0f67c75f35..77ee6b4a5ec4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7761,9 +7761,11 @@ static u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	x86_perf_get_lbr(&lbr);
-	if (lbr.nr)
-		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
+		x86_perf_get_lbr(&lbr);
+		if (lbr.nr)
+			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+	}
 
 	if (vmx_pebs_supported()) {
 		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;

base-commit: 2de154f541fc5b9f2aed3fe06e218130718ce320
-- 
2.39.1.456.gfc5497dd1b-goog

