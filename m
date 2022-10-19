Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13009604DE7
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiJSQ4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 12:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJSQ43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 12:56:29 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFF41C4926
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id g3-20020a056a000b8300b00563772d1021so9771650pfj.18
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 09:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gy24ztDzsu2pVLCZMStQCiAA6/olN6OB6IFeEvw2nwc=;
        b=RkT5JmVHOx1xLJuKyPUTQ/GHWwPLL/Ofaa9fMFcWafnho5RGXPgWMJuq6JtFQIVRU5
         3MTRHaV+92xzf++NNAnl+DR9b5UgIZvfci41IYKi7CDUqVB2+NLKldXiZn18g62Ly3eN
         GP5xfcS2y6ft5gvqGdsKQufjnDmEap6e+Ggqnq1KWQ1ZMLIDN/eNajNku93QRdQyQSGg
         cXnlJOFm94o6frDwyz1i/mRrPIKOOgCJ3heiRrvlB8tXVHnRqxX8wwG5+Mf53qjVtc8D
         i/CqLQ/EdC68sMeiadZQajE7mvYEdOHQmt2H8C20u9lUD8opffszIpqLdrdMCs9Gvj+9
         isNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gy24ztDzsu2pVLCZMStQCiAA6/olN6OB6IFeEvw2nwc=;
        b=CvGCOD6YMphvXiAjdfQyy3hEnXA9U2q3tP4xAmPc2bt2V1g2MCe2uM631eh6C7rhob
         GftwU1CK9PbfafblgwiinDc4BLN0ickPkxbEFjxY7u4t+Hb4FCrE2SE8LAW5iAdD/E0i
         sTv2+wCkLH713U5xWqhQsGxZs5PtW0jr4VZJTUiarEcsjP/EDa3D4hn/4YLLYKEhrvH2
         Hq1U8PzkHmQWhFTydekoMqFwMlTRsO4rcGVOOzN2H11ih0/eCxUpM2NPShSJD4EAU26B
         TsvwWIXEu8eXMyUtEuPXFk/DiMlkPnboqftIlU9xFPzhgpZGlyE+U7jtm48IqWZzuzoP
         tgWA==
X-Gm-Message-State: ACrzQf1gakCT7uw39I3hvp19AxrcbZQ4xZECdqemzYSanBsW2dAeHaUW
        gHfxRoA6AkAkkST3+eaLyNnLpviij0A=
X-Google-Smtp-Source: AMsMyM7z+/HoT4H7P+QTJw0UCU7RU2z3T7Pf6h3t9Z69xlXBk9B/YfAGWls9cWCXFmfCrFwseqxLeAzoXxI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f78a:b0:184:f2e2:a5fa with SMTP id
 q10-20020a170902f78a00b00184f2e2a5famr9560092pln.161.1666198587158; Wed, 19
 Oct 2022 09:56:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 19 Oct 2022 16:56:13 +0000
In-Reply-To: <20221019165618.927057-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221019165618.927057-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019165618.927057-4-seanjc@google.com>
Subject: [PATCH v6 3/8] KVM: x86/mmu: Properly account NX huge page workaround
 for nonpaging MMUs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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

Account and track NX huge pages for nonpaging MMUs so that a future
enhancement to precisely check if a shadow page can't be replaced by a NX
huge page doesn't get false positives.  Without correct tracking, KVM can
get stuck in a loop if an instruction is fetching and writing data on the
same huge page, e.g. KVM installs a small executable page on the fetch
fault, replaces it with an NX huge page on the write fault, and faults
again on the fetch.

Alternatively, and perhaps ideally, KVM would simply not enforce the
workaround for nonpaging MMUs.  The guest has no page tables to abuse
and KVM is guaranteed to switch to a different MMU on CR0.PG being
toggled so there's no security or performance concerns.  However, getting
make_spte() to play nice now and in the future is unnecessarily complex.

In the current code base, make_spte() can enforce the mitigation if TDP
is enabled or the MMU is indirect, but make_spte() may not always have a
vCPU/MMU to work with, e.g. if KVM were to support in-line huge page
promotion when disabling dirty logging.

Without a vCPU/MMU, KVM could either pass in the correct information
and/or derive it from the shadow page, but the former is ugly and the
latter subtly non-trivial due to the possibility of direct shadow pages
in indirect MMUs.  Given that using shadow paging with an unpaged guest
is far from top priority _and_ has been subjected to the workaround since
its inception, keep it simple and just fix the accounting glitch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c  |  2 +-
 arch/x86/kvm/mmu/spte.c | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5dd98cdc5283..99086a684dd2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3143,7 +3143,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			continue;
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (fault->is_tdp && fault->huge_page_disallowed)
+		if (fault->huge_page_disallowed)
 			account_nx_huge_page(vcpu->kvm, sp,
 					     fault->req_level >= it.level);
 	}
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 2e08b2a45361..c0fd7e049b4e 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -161,6 +161,18 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (!prefetch)
 		spte |= spte_shadow_accessed_mask(spte);
 
+	/*
+	 * For simplicity, enforce the NX huge page mitigation even if not
+	 * strictly necessary.  KVM could ignore the mitigation if paging is
+	 * disabled in the guest, as the guest doesn't have an page tables to
+	 * abuse.  But to safely ignore the mitigation, KVM would have to
+	 * ensure a new MMU is loaded (or all shadow pages zapped) when CR0.PG
+	 * is toggled on, and that's a net negative for performance when TDP is
+	 * enabled.  When TDP is disabled, KVM will always switch to a new MMU
+	 * when CR0.PG is toggled, but leveraging that to ignore the mitigation
+	 * would tie make_spte() further to vCPU/MMU state, and add complexity
+	 * just to optimize a mode that is anything but performance critical.
+	 */
 	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
 	    is_nx_huge_page_enabled(vcpu->kvm)) {
 		pte_access &= ~ACC_EXEC_MASK;
-- 
2.38.0.413.g74048e4d9e-goog

