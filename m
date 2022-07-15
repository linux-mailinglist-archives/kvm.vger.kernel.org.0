Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA19E576A4A
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 01:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiGOXAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 19:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiGOXA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 19:00:27 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698A84E631
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:00:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-317f6128c86so49667897b3.22
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yUjqGaXxNRIkWFGwl+2pUdgstDXS94lxvTblB9yzYuE=;
        b=d0HtqcngCGEWckrmfolh8CY2i0XJnzrFb5U6PGDeVR1h0nBWTx0oQovQksQedcqaw5
         rNIEvehYP/e2WByw7UXCle8v5tnX9eUF2ixPX/LeaN32FU0RS43PhyHsktjm7mRl9kCx
         doOlYb7OJsbiz3CvdzNyLZJfaxmHMCvjtfJF3wTxPbYjHHoz9N2QJslDF/oOxCp1ysxU
         sEAKUl41bbj251CIbRBdBNFCB3nPXrHNA1IXyyN8rh9ycMtnsuGKxk9kPqTN/nUgyl6t
         ibjUEGvETaptRy5VB8ovSHwrKh1+6LxooBefTD6Tv8D2FL9GLC7UBbdFtd3ghJwAqq47
         0eAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yUjqGaXxNRIkWFGwl+2pUdgstDXS94lxvTblB9yzYuE=;
        b=7L16VZpXRrx98ckRnQ0UaZ4rhyrcD8WjFjD4MA/QHtIm0xsJZ5bbmH0t/7Uubmc6V/
         ofDkjxABcgIyfmzvncG6z8r1GM+M70+bzwGkriqCCcbO7cpqeq6qaJYnQG/AWRoQPjfu
         ZztqIdziH0GcY+IgsjFW9QDZ0oam1kB0G3xTKpl+yG/WwUnCQplrYLwJxqobHUJAcWuu
         oR8LJ5JdTnx+2CxY2225jtwQihRtuRgNynIwA9bOtW1hqm0cyPHOQ4itlMZn2jNqNjk3
         sTIgcyKX6vBsZ5KhuoqqnEfBLGWBNb/PDY3ttLLgT1cwMR2mu/OzV4B26mG4zhzHbkT0
         xwfw==
X-Gm-Message-State: AJIora+g3rwtJHtDBPvZppSHiYEr+ClUOWE6TV4Kj42awyd9Q3BiWzmw
        M8xObqdN2X05FexnUtzg32c5cZM33i0=
X-Google-Smtp-Source: AGRyM1tq+cKZgY4d++EmVCawqmZ05GuVHpsnrWVt/0hYjlpfSVIk4z9NrsOkzJTeXpY7o67QjtJoJD4vVbc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:13d7:0:b0:31c:c22b:4727 with SMTP id
 206-20020a8113d7000000b0031cc22b4727mr19236561ywt.38.1657926024502; Fri, 15
 Jul 2022 16:00:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 23:00:15 +0000
In-Reply-To: <20220715230016.3762909-1-seanjc@google.com>
Message-Id: <20220715230016.3762909-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220715230016.3762909-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 3/4] KVM: x86/mmu: Add shadow mask for effective host MTRR memtype
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Add shadow_memtype_mask to capture that EPT needs a non-zero memtype mask
instead of relying on TDP being enabled, as NPT doesn't need a non-zero
mask.  This is a glorified nop as kvm_x86_ops.get_mt_mask() returns zero
for NPT anyways.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 21 ++++++++++++++++++---
 arch/x86/kvm/mmu/spte.h |  1 +
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fb1f17504138..7314d27d57a4 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -33,6 +33,7 @@ u64 __read_mostly shadow_mmio_value;
 u64 __read_mostly shadow_mmio_mask;
 u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
+u64 __read_mostly shadow_memtype_mask;
 u64 __read_mostly shadow_me_value;
 u64 __read_mostly shadow_me_mask;
 u64 __read_mostly shadow_acc_track_mask;
@@ -161,10 +162,10 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (level > PG_LEVEL_4K)
 		spte |= PT_PAGE_SIZE_MASK;
-	if (tdp_enabled)
+
+	if (shadow_memtype_mask)
 		spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
-			kvm_is_mmio_pfn(pfn));
-
+							 kvm_is_mmio_pfn(pfn));
 	if (host_writable)
 		spte |= shadow_host_writable_mask;
 	else
@@ -391,6 +392,13 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
 	shadow_nx_mask		= 0ull;
 	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
 	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
+	/*
+	 * EPT overrides the host MTRRs, and so KVM must program the desired
+	 * memtype directly into the SPTEs.  Note, this mask is just the mask
+	 * of all bits that factor into the memtype, the actual memtype must be
+	 * dynamically calculated, e.g. to ensure host MMIO is mapped UC.
+	 */
+	shadow_memtype_mask	= VMX_EPT_MT_MASK | VMX_EPT_IPAT_BIT;
 	shadow_acc_track_mask	= VMX_EPT_RWX_MASK;
 	shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
 	shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
@@ -441,6 +449,13 @@ void kvm_mmu_reset_all_pte_masks(void)
 	shadow_nx_mask		= PT64_NX_MASK;
 	shadow_x_mask		= 0;
 	shadow_present_mask	= PT_PRESENT_MASK;
+
+	/*
+	 * For shadow paging and NPT, KVM uses PAT entry '0' to encode WB
+	 * memtype in the SPTEs, i.e. relies on host MTRRs to provide the
+	 * correct memtype (WB is the "weakest" memtype).
+	 */
+	shadow_memtype_mask	= 0;
 	shadow_acc_track_mask	= 0;
 	shadow_me_mask		= 0;
 	shadow_me_value		= 0;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index ba3dccb202bc..cabe3fbb4f39 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -147,6 +147,7 @@ extern u64 __read_mostly shadow_mmio_value;
 extern u64 __read_mostly shadow_mmio_mask;
 extern u64 __read_mostly shadow_mmio_access_mask;
 extern u64 __read_mostly shadow_present_mask;
+extern u64 __read_mostly shadow_memtype_mask;
 extern u64 __read_mostly shadow_me_value;
 extern u64 __read_mostly shadow_me_mask;
 
-- 
2.37.0.170.g444d1eabd0-goog

