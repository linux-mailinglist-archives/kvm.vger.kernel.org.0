Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22468457B62
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbhKTEyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbhKTEyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:32 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C64DC0613F2
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:50:58 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id z3-20020a170903018300b0014224dca4a1so5728871plg.0
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dTfuca2Tp4mVI9fyXjZm+tqcMtV1gIFla4M6iTQ9eHc=;
        b=B85zqS6qVLzLP5rjv9wDo81+jvBejoE41wOXeNexV5KZyclydTvjNb6Kv2hRm+u+53
         ow0CDw0QaQgVwmxazag/dQYUaaquJs969qk/jYtoHuVY+j3VqZuvnFPO+1Tam47C52cN
         hHq12d/NdhUWVFig7vPoUJZjAQ7kmEg2zD6TbBJtD1sXCuWOphPv8blD8ECD1MxW26qk
         iJWeMOnn0H7ZxeqhymyEq2JEa8N+gsofELWAxCXFHRLm8mBMxn9uMimwt3j71qNh99Xa
         1IhCnKKabhLY6u/43DJVQJTfOLVZvfoN9Y3bAcmZ4GcyfaATrFyXbP13/HFLcKF5T7zn
         RU0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dTfuca2Tp4mVI9fyXjZm+tqcMtV1gIFla4M6iTQ9eHc=;
        b=eFhd2DfU+oT4MqwVcXPgfDtKH2cSeFVSWlNOaRxfLo8x2R7+xyQ819mhORC2XD1iZx
         9Ah76squKm5CC0q+j8wcHTdqUt0pdLP2AiauIv6np4adZ20APe3lNhRtzA1jdgt43XYh
         QriAkvdaQ9Wxi7VaPMgb0fyhbs1NOCwalnFm1Wx+VYG323XGnS/h6s3hw5xorBJnTZZ5
         V2h2pogdzON+2odz0FGChvxxYkPu/Mi6RHYqhIpBTfbJ2bUqsnqkMZ7kmDs9WBHC/PYL
         IYblVV91QCLF1edj/oGnLIrwcVfDKF0LMhZYRhQOn2sQakepVMHdaxJbI8cQysZ7dLEP
         mluQ==
X-Gm-Message-State: AOAM532+tnkdQ6yG07k6ApwPzs4koEF77qCAhZSD+XyxwiHOGrafHvUc
        dujmXOhy2ojwcYMDYcVIkr9TYbHAMlc=
X-Google-Smtp-Source: ABdhPJxCPMuIGBmCQgyDHxeeMYc98r4i6KP42raoUQEJf5kaGcr9pSYX11Go1tfPDKADgbprCOTM2il0LNU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:32d1:b0:142:1ce1:30c9 with SMTP id
 i17-20020a17090332d100b001421ce130c9mr82966921plr.0.1637383857953; Fri, 19
 Nov 2021 20:50:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:20 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 02/28] KVM: x86/mmu: Skip tlb flush if it has been done in zap_gfn_range()
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

From: Hou Wenlong <houwenlong93@linux.alibaba.com>

If the parameter flush is set, zap_gfn_range() would flush remote tlb
when yield, then tlb flush is not needed outside. So use the return
value of zap_gfn_range() directly instead of OR on it in
kvm_unmap_gfn_range() and kvm_tdp_mmu_unmap_gfn_range().

Fixes: 3039bcc744980 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8f0035517450..457336f67636 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1582,7 +1582,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
-		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
 
 	return flush;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a29ebff1cfa0..4cd6bf7e73f0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1032,8 +1032,8 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, false)
-		flush |= zap_gfn_range(kvm, root, range->start, range->end,
-				       range->may_block, flush, false);
+		flush = zap_gfn_range(kvm, root, range->start, range->end,
+				      range->may_block, flush, false);
 
 	return flush;
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

