Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5426950C70E
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 05:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiDWDvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiDWDvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:15 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE4E1C24AD
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:19 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a16-20020a62d410000000b00505734b752aso6564153pfh.4
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1xXlNuitmBIDnvcFCjqiRv5q853x221AI5N7xfAKCvw=;
        b=Ieha1ltUZLArH56kihEmLOyaNSxIK2twG7xkdpiCELNo5UCcfb1vggkZz9RL3fnwfX
         0PrKYmdnN319T2R6MCRyHOi/2cE2OfEmEIYTitnPdLe2o4Jca2F215W/GNgyRjtwd426
         d9nAiQtpboT76sQ/h5AHKqMAqBJao/zS+ZOlO/rSyuCh6X90Sjw28e/ce/KYoEGm0x0p
         y63JdEvo60hj73YVRQ1eTAapaPh9O+eCPkMUh5qo6bqmoxPd6o9KfUKCBlVu/PiKITli
         JMwbL98H13gphrSULEzFoSbv75jKpC2eCtQ/SnT0NgzN9Du2rLIOoz0kY5zHajyPk0pr
         yJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1xXlNuitmBIDnvcFCjqiRv5q853x221AI5N7xfAKCvw=;
        b=uKQztpjfkY7QWZ9YtcSbWrTylWmqWZoxh5/NeoqQY6tkiTN4EINjPAOzPoByR6uTfp
         rnmAB0rH/3KFCmwpzWK67jmxvjyb750NMypGTrPy9b1p5cg8dxpU7IDV6BibpTCOmVUs
         fV2WXfkmlPXC0VxJYj1Eke/zQYsswusRp6/AMk1iEU68Apu98l7l0tDWgBMHydD7Hz3W
         HTrogTT2Fhck//cJxlanqjt5BCY+c6+G+dzKC26eGVSxjeVa+6C2Bkimbdr3SjNwyQix
         TRCiWZXBRjZuASXjE1ng74TYSgJz0fTi4jlEwrTVL19cr9lANxePchrcI2hApC7K6o9p
         SMcg==
X-Gm-Message-State: AOAM532pWTJ3fehACUaepm7jWPlHA1I9O5ir9a+/5uqWp81IB+Vb14+0
        cL10AUzxYPmBHcWIeNSndQZQmcjwooM=
X-Google-Smtp-Source: ABdhPJyfPN5aVhvQWAJBOV4tNgKYBnOtE/XxNWNn9A1avm3uZilEE7X+6lalb5vG8Nfj4dmjhglENd/AbM0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:2006:0:b0:39d:8460:48a4 with SMTP id
 g6-20020a632006000000b0039d846048a4mr6604430pgg.623.1650685699488; Fri, 22
 Apr 2022 20:48:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:45 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 05/12] KVM: x86/mmu: Drop exec/NX check from "page fault can
 be fast"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
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

Tweak the "page fault can be fast" logic to explicitly check for !PRESENT
faults in the access tracking case, and drop the exec/NX check that
becomes redundant as a result.  No sane hardware will generate an access
that is both an instruct fetch and a write, i.e. it's a waste of cycles.
If hardware goes off the rails, or KVM runs under a misguided hypervisor,
spuriously running throught fast path is benign (KVM has been uknowingly
being doing exactly that for years).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dfd1cfa9c08c..f1618d8289ce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3001,16 +3001,14 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
 {
 	/*
-	 * Do not fix the mmio spte with invalid generation number which
-	 * need to be updated by slow page fault path.
+	 * Page faults with reserved bits set, i.e. faults on MMIO SPTEs, only
+	 * reach the common page fault handler if the SPTE has an invalid MMIO
+	 * generation number.  Refreshing the MMIO generation needs to go down
+	 * the slow path.  Note, EPT Misconfigs do NOT set the PRESENT flag!
 	 */
 	if (fault->rsvd)
 		return false;
 
-	/* See if the page fault is due to an NX violation */
-	if (unlikely(fault->exec && fault->present))
-		return false;
-
 	/*
 	 * #PF can be fast if:
 	 *
@@ -3026,7 +3024,14 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
 	 *    SPTE is MMU-writable (determined later), the fault can be fixed
 	 *    by setting the Writable bit, which can be done out of mmu_lock.
 	 */
-	return !kvm_ad_enabled() || (fault->write && fault->present);
+	if (!fault->present)
+		return !kvm_ad_enabled();
+
+	/*
+	 * Note, instruction fetches and writes are mutually exclusive, ignore
+	 * the "exec" flag.
+	 */
+	return fault->write;
 }
 
 /*
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

