Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F6F75D8A3
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 03:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjGVBYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 21:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjGVBX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 21:23:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F293588
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:23:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-583312344e7so30469777b3.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 18:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689989036; x=1690593836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wviPOsS6wxIVOzMjjv3mWVw+feSBMfs9pmoqRvrXCaY=;
        b=EHkFOyw454NLdiUH/cpx5RfGl2xPzYBb+VKZHOiimOclYEia0svEdqgFzm03OWmWHy
         dkKkpSnnOCoQ1HqQvKJpRCFvmh2C/8yf+6wTzsFjWnNxqevYbnFIFPdDioBUEswbDid4
         ZAYMCNS9F5oQm+0L8WtSeoKYZY4X0tzo+rnD7LqEVf6XAAseeoeLDY4P23x2zDF3pObH
         ymTPh8gB9tnAWpVmBOGbmiXmRhXGor5RmoVM5F7FJPKv/fadii2NcrE4jSMH/lCb+XsX
         wPeZtSSD9IkSzVHAvYff1x/x7g4rqLjATIXIgT/39Jv1C8hSLdrzU5o7gxjmwMqdGlyE
         2OEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689989036; x=1690593836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wviPOsS6wxIVOzMjjv3mWVw+feSBMfs9pmoqRvrXCaY=;
        b=gE0GB6I2IZj81mr4Ktyv9G81nPyW1tpayF/OemHvDpT//LMcYey70a4W5gqW5Dk8pJ
         EWrlXez6icoh+0NsXke6ZuhSYlT1R2Kr0+trqamO5m8hhDwetTmGpb7I2x/PYzX01H7E
         viROnhW78revElK7cXrztbWNwbYXe0o2vYp6PupQpnbtvLysPfEVGVy4M+4R/xLxK85r
         cpM6INpTVGP7ESZQDVFGDw0OTrYYj6a68n9F7y6KPzhIQ+bRshZZggmXM8jM2a5G43lI
         RhChDeeRHz9/TLPCF0yXGY+5qf51cHz0l/MDySncraTcf6kCq+yuxKzvfJQhq21c+9t+
         1lEg==
X-Gm-Message-State: ABy/qLbHQrOIiNerwjrCggbziQYViwrOMPF2jkHc4Z+0OML+GyDtKeYf
        L7HwRooM7p38/FRwPU9EaufG+302rLA=
X-Google-Smtp-Source: APBJJlG3MI1ivThdJIOZAAOfO3RZ7keJsgJaj28Shk4wff/ppxf/WlxePUdKf+F5UQQwnEIe9vzSgWkIDhs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2fd5:0:b0:cb0:e4d4:f4ff with SMTP id
 v204-20020a252fd5000000b00cb0e4d4f4ffmr21447ybv.3.1689989035982; Fri, 21 Jul
 2023 18:23:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 18:23:47 -0700
In-Reply-To: <20230722012350.2371049-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230722012350.2371049-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230722012350.2371049-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: x86/mmu: Harden new PGD against roots without shadow pages
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Harden kvm_mmu_new_pgd() against NULL pointer dereference bugs by sanity
checking that the target root has an associated shadow page prior to
dereferencing said shadow page.  The code in question is guaranteed to
only see roots with shadow pages as fast_pgd_switch() explicitly frees the
current root if it doesn't have a shadow page, i.e. is a PAE root, and
that in turn prevents valid roots from being cached, but that's all very
subtle.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1eadfcde30be..dd8cc46551b2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4560,9 +4560,19 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
 				  union kvm_mmu_page_role role)
 {
-	return (role.direct || pgd == root->pgd) &&
-	       VALID_PAGE(root->hpa) &&
-	       role.word == root_to_sp(root->hpa)->role.word;
+	struct kvm_mmu_page *sp;
+
+	if (!VALID_PAGE(root->hpa))
+		return false;
+
+	if (!role.direct && pgd != root->pgd)
+		return false;
+
+	sp = root_to_sp(root->hpa);
+	if (WARN_ON_ONCE(!sp))
+		return false;
+
+	return role.word == sp->role.word;
 }
 
 /*
@@ -4682,9 +4692,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	 * If this is a direct root page, it doesn't have a write flooding
 	 * count. Otherwise, clear the write flooding count.
 	 */
-	if (!new_role.direct)
-		__clear_sp_write_flooding_count(
-				root_to_sp(vcpu->arch.mmu->root.hpa));
+	if (!new_role.direct) {
+		struct kvm_mmu_page *sp = root_to_sp(vcpu->arch.mmu->root.hpa);
+
+		if (!WARN_ON_ONCE(!sp))
+			__clear_sp_write_flooding_count(sp);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
-- 
2.41.0.487.g6d72f3e995-goog

