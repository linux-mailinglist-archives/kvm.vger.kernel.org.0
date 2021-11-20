Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB2B457B74
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhKTEzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237057AbhKTEyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:47 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7689C06175A
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:30 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id 4-20020a170902c20400b0014381f710d5so5708476pll.11
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UNeY5TRi8Efp7KNQFRTCwp5OSjaWwnTOgjN/1SRz8Cs=;
        b=LRmtkx2yNEbStOsNFanNn49rq+ZzYnV8sFw9taBlzacX6PbXUC91mMcM1ABaRGwOCl
         jLFajEDZBk02DHGEVO7balKSCbLovvMCLayYq2Spk+KNuDEfJi1bXGQByNxwZjQluqlf
         5Vr6mc7nU+Fcb+thj8xmX7275Gad0M7/d3V9lu4C77Xf6qZxNVsInd2ELXVsF0seXvuQ
         a6CnO7vy22P3+4rwThdlxl79hGm4sVVb7uyaV0dr3rZrOnUs0Qs4rw+tSv2MGy0+Krs8
         SwzIeF6gmPwedTfwajtwSXercMM6+JkKO0UN4uZrw5XCCWsiSefdlk26qVhAJXMhJfKd
         slbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UNeY5TRi8Efp7KNQFRTCwp5OSjaWwnTOgjN/1SRz8Cs=;
        b=2zPMjC/AhNShfwf0JuT0m0m8PTC1Qqeq3+JSeceUygCm7wyys5bc4fG9lFNndYpCSu
         AxM79B3FPmVvKEKr8tbdYCspTd19LZetkr5eiWXM1fSdAeFzdsIa6azGMBPoYDvCXDrI
         Q9RjLRSVmjoafIxKwL0B1Fc++a20M9nYpltxIAZxQgmoRfqw8yZGNiRusXdAYyI1ZRQF
         SG7F/4s1yki//HKA/qy0Th/dcswPOVIIqZ6n+zBEZuRFGwHdnt1fvcYeEdsHt/Ac4kur
         6VqpgSK1VJFl75HnPb5u5On3FP0QHtuEFSnSCe1TdBU6TQrwOFA/jDPGnT5oxkbOoth5
         1Rqw==
X-Gm-Message-State: AOAM530PbSVA3Iz2hSMnnY2y5cS48woNXakfTaJ/eXYgTceIX+UTESbJ
        SempCtytcZc/v21yTy5iujlWZXwOAxo=
X-Google-Smtp-Source: ABdhPJxgg4BdMYce2BDw+q6Kfx6SdyoEeR19gnJgRyjz3CXE/DQ0GVM8PbahtbxAvgUP+5Sqf3dtjZJKpZQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:934a:b0:142:6ed6:5327 with SMTP id
 g10-20020a170902934a00b001426ed65327mr84698004plp.85.1637383890157; Fri, 19
 Nov 2021 20:51:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:41 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-24-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 23/28] KVM: x86/mmu: Use "zap root" path for "slow" zap of all
 TDP MMU SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the "slow" zap of all TDP MMU SPTEs doesn't flush the TLBs, use
the dedicated "zap root" helper, which can be used if and only if a flush
isn't needed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e5401f0efe8e..99ea19e763da 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -888,6 +888,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
+	struct kvm_mmu_page *root;
 	int i;
 
 	/*
@@ -895,8 +896,10 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
 	 */
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		(void)kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, false);
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		for_each_tdp_mmu_root_yield_safe(kvm, root, i, false)
+			(void)tdp_mmu_zap_root(kvm, root, false);
+	}
 }
 
 /*
-- 
2.34.0.rc2.393.gf8c9666880-goog

