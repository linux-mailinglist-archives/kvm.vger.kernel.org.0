Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06B550C713
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 06:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiDWDvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiDWDvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:35 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39F61C78E9
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:28 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id j21-20020a170902c3d500b0015cecdddb3dso67522plj.21
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ElX6s8O+jQm/pf5/HoWc8mJl1k3Q5fJv6/6onQIYo7A=;
        b=r150U+eD4HCCeu3Wtly98bpxxf14GzpxUSlmcXASoApafzO1Kasae0DXfkL++A/kXu
         L9a+4bIXQlnFUca/vtg/auzoVn7lJxgJj9n23bu4hiZkXxt+ZiAPm6zioFicXHZ/WA53
         oQFyKfFdV9PIS7vuXoQrLd4Un4HhuQUDuUChb/4KN8tRjUwfm51/F7P+MpcyXy5uRbyg
         MZ2VYwkwbaG1LOf8kh3r4corliZxbp/QLt8zoV77WTeZc8m0QZ/m8TvYO2QfcckNGNRA
         o8CaMgNHpIA+WR3Ch8/X2njK7BQIXRbhtoQSICo4h6VAo6iAu1gpl5DZd8+KSitZhcYw
         lzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ElX6s8O+jQm/pf5/HoWc8mJl1k3Q5fJv6/6onQIYo7A=;
        b=Bl+yVpKierCqSqeB1EtAd7EjSqVYvzTSNrlfMO3WiE2MJLP+TNTjglTQMcWrtWICXs
         oTiuUZ+qVOXKRhySelPZNzXV+lz7lbOpPX2r8JIg8Bvaz9YodMec5fRVAH0gJaQRonki
         6Yyk9ocN6238LeVcPZNu3CaRbaebNSQF76hxGK7y3T4IFK37mOWXHTcYbHfoZYtjHjmw
         DwIE82Zlug1XKqT6cwDwnHSxU/nqL5FeeZnZedkhxwHIPDID9hFzXtcGlzMLv/I1lsvh
         MdxAWtwJWfJ0qk2qZg3uiC4168sbpDwb3whBCMo6JLpWal1QGrqAnaLNaURsKeR/AOLM
         QefA==
X-Gm-Message-State: AOAM530anJqhLBUmwq5qsLVbldmOBdnzJtBc6fauEqJO8ATxQjyV+INQ
        f3XO3KcePCIDuc3fXwtv8pSHiFe8K78=
X-Google-Smtp-Source: ABdhPJxrk2xLYR8PaLzAgUGhmeIhZwmbUeg/2Vk3Hssukf/3zfMDOSsmF/hWuknXOnynUDpT0bJixw9tkXQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr716293pjb.1.1650685708066; Fri, 22 Apr
 2022 20:48:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:50 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 10/12] DO NOT MERGE: KVM: x86/mmu: Always send !PRESENT faults
 down the fast path
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

Posted for posterity, and to show that it's possible to funnel indirect
page faults down the fast path.

Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 44 +++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 744c06bd7017..7ba88907d032 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3006,26 +3006,25 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
 		return false;
 
 	/*
-	 * #PF can be fast if:
-	 *
-	 * 1. The shadow page table entry is not present and A/D bits are
-	 *    disabled _by KVM_, which could mean that the fault is potentially
-	 *    caused by access tracking (if enabled).  If A/D bits are enabled
-	 *    by KVM, but disabled by L1 for L2, KVM is forced to disable A/D
-	 *    bits for L2 and employ access tracking, but the fast page fault
-	 *    mechanism only supports direct MMUs.
-	 * 2. The shadow page table entry is present, the access is a write,
-	 *    and no reserved bits are set (MMIO SPTEs cannot be "fixed"), i.e.
-	 *    the fault was caused by a write-protection violation.  If the
-	 *    SPTE is MMU-writable (determined later), the fault can be fixed
-	 *    by setting the Writable bit, which can be done out of mmu_lock.
+	 * Unconditionally send !PRESENT page faults (except for emulated MMIO)
+	 * through the fast path.  There are two scenarios where the fast path
+	 * can resolve the fault.  The first is if the fault is spurious, i.e.
+	 * a different vCPU has faulted in the page, which applies to all MMUs.
+	 * The second scenario is if KVM marked the SPTE !PRESENT for access
+	 * tracking (due to lack of EPT A/D bits), in which case KVM can fix
+	 * the fault after logging the access.
 	 */
 	if (!fault->present)
-		return !kvm_ad_enabled();
+		return true;
 
 	/*
-	 * Note, instruction fetches and writes are mutually exclusive, ignore
-	 * the "exec" flag.
+	 * Skip the fast path if the fault is due to a protection violation and
+	 * the access isn't a write.  Write-protection violations can be fixed
+	 * by KVM, e.g. if memory is write-protected for dirty logging, but all
+	 * other protection violations are in the domain of a third party, i.e.
+	 * either the primary MMU or the guest's page tables, and thus are
+	 * extremely unlikely to be resolved by KVM.  Note, instruction fetches
+	 * and writes are mutually exclusive, ignore the "exec" flag.
 	 */
 	return fault->write;
 }
@@ -3041,12 +3040,13 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	/*
 	 * Theoretically we could also set dirty bit (and flush TLB) here in
 	 * order to eliminate unnecessary PML logging. See comments in
-	 * set_spte. But fast_page_fault is very unlikely to happen with PML
-	 * enabled, so we do not do this. This might result in the same GPA
-	 * to be logged in PML buffer again when the write really happens, and
-	 * eventually to be called by mark_page_dirty twice. But it's also no
-	 * harm. This also avoids the TLB flush needed after setting dirty bit
-	 * so non-PML cases won't be impacted.
+	 * set_spte. But a write-protection violation that can be fixed outside
+	 * of mmu_lock is very unlikely to happen with PML enabled, so we don't
+	 * do this. This might result in the same GPA to be logged in the PML
+	 * buffer again when the write really happens, and eventually to be
+	 * sent to mark_page_dirty() twice, but that's a minor performance blip
+	 * and not a function issue.  This also avoids the TLB flush needed
+	 * after setting dirty bit so non-PML cases won't be impacted.
 	 *
 	 * Compare with set_spte where instead shadow_dirty_mask is set.
 	 */
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

