Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3625332DEF1
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhCEBLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhCEBLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:47 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A89C061761
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:46 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f81so676995yba.8
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1d75g85xgtYE6EG7cfU2REgYRmx185ZHiOuo3S9KNAA=;
        b=txRUg8YkvyfqIJ0/XuPt5R/AlheVjwdXFDUJapIwiRlZfuO1aTxi7EME12Kt4vEcGi
         hHumJL9TnwIbyLcyuFKqpeLtXJL5WWf+5pc1CcI0IH/lziTzBSDxuj0p+3hjvVJO4dqI
         eTvVqADPE/JcQamgBZ9NfUe8/C7ww/mTuimP96Lavhvgo6rhz+YUEdM+taue2t+xlZbG
         ZRN9PPVOZdlckrxevuXpR2bLlPnBad9AwoWUF4JObK+/+sIJTF52TcULbf4W03kwTaQS
         Nf/fgJQyepDxAY1KjPj2QutFZr37DCSyif1Ff9w1pqTMiChnONWfsJ7BVjjja/6yEtRC
         Z+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1d75g85xgtYE6EG7cfU2REgYRmx185ZHiOuo3S9KNAA=;
        b=Tzy1mJnukeV/GYFVJBM2e+9BQAPQM2Hcl30X/TThvNqCf+s1Ovbs+qtfe3pnjmnvSd
         tQXw7T27RTWtt4WfCys3iVjcYXT/vM88zMdiCRFBzuZoIl7WE265XpEXt1jGFQY0SAkZ
         mA3XJnZF0TZ/vzPYUiYqPuK3QIKNEbxvRfGT8h+lbTcg5bjAcZMw+POxCOM/qI2lSeK1
         n7WB4aEMh4i5RWHc42fxdjGGFRHYmS4Pjrl9pbXMROn0tgs+DZ6GlUTES5EMC3iIKks+
         6f++OMzqAl1C/8edEzi/LA0o2MUMWp0y68wcjRq/0fef5TdvNGCxSKwmajU0PcqkPaTn
         3/xw==
X-Gm-Message-State: AOAM530GiTC+3S56DYlApsGRCkN8/xQNYFMjIpu0WU89LGBx/V51drqR
        Q/Z9tjpj3s8uDIGFp6fjo/SCJVQy+pw=
X-Google-Smtp-Source: ABdhPJyML4KoyC8fISaQe2/KDV43JeBYfE/oli0AyNxL8l43JmeZozRuqeue98etV5vlZnI0RdCiqZp3a0k=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:3417:: with SMTP id b23mr10520532yba.257.1614906706188;
 Thu, 04 Mar 2021 17:11:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:11:01 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-18-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 17/17] KVM: x86/mmu: WARN on NULL pae_root or lm_root, or
 bad shadow root level
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if KVM is about to dereference a NULL pae_root or lm_root when
loading an MMU, and convert the BUG() on a bad shadow_root_level into a
WARN (now that errors are handled cleanly).  With nested NPT, botching
the level and sending KVM down the wrong path is all too easy, and the
on-demand allocation of pae_root and lm_root means bugs crash the host.
Obviously, KVM could unconditionally allocate the roots, but that's
arguably a worse failure mode as it would potentially corrupt the guest
instead of crashing it.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bceff7d815c3..eb9dd8144fa5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3253,6 +3253,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
 		mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
+		if (WARN_ON_ONCE(!mmu->pae_root))
+			return -EIO;
+
 		for (i = 0; i < 4; ++i) {
 			WARN_ON_ONCE(mmu->pae_root[i]);
 
@@ -3262,8 +3265,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 					   shadow_me_mask;
 		}
 		mmu->root_hpa = __pa(mmu->pae_root);
-	} else
-		BUG();
+	} else {
+		WARN_ONCE(1, "Bad TDP root level = %d\n", shadow_root_level);
+		return -EIO;
+	}
 
 	/* root_pgd is ignored for direct MMUs. */
 	mmu->root_pgd = 0;
@@ -3307,6 +3312,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		goto set_root_pgd;
 	}
 
+	if (WARN_ON_ONCE(!mmu->pae_root))
+		return -EIO;
+
 	/*
 	 * We shadow a 32 bit page table. This may be a legacy 2-level
 	 * or a PAE 3-level page table. In either case we need to be aware that
@@ -3316,6 +3324,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
+		if (WARN_ON_ONCE(!mmu->lm_root))
+			return -EIO;
+
 		mmu->lm_root[0] = __pa(mmu->pae_root) | pm_mask;
 	}
 
-- 
2.30.1.766.gb4fecdf3b7-goog

