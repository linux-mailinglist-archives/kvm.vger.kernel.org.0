Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD863257EB
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhBYUsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbhBYUsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:48:41 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A2EC061786
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:00 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v62so7552642ybb.15
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dqqMnpXbv9GtgsoIAfcqn+NffK0Y9luh9hhBXNIAc1w=;
        b=LJrgs6eZBraYVLoHmXIbR/ceJisGaqISWo801gt9OBRf/fqEOrARTU61943OgAt7yN
         uTJEXaSbNbI/J/kZvNqKJ+YbIIkcl99nWfok3tiBtpDuFv0Bo7Qcy3Su+JkCC+kevDJ4
         kI+FNjrBFAWNaXCKT+o3POGGNrXRZm6mSJy+36NZdwIrhD/ftaXw7gMEqSk1JZ+rXoKe
         nzA57bjON7jkDgenv8nutLeRNRzibmkp767w6dtzFVXD07PXspPK9ttwJBRksipLFbok
         RWddPDWAVkSdKPHkgU4SqywGssuRH3AQxtKIjyT8hPEQ82EkXSCaX7nHpv1UmPEEWz6t
         BRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dqqMnpXbv9GtgsoIAfcqn+NffK0Y9luh9hhBXNIAc1w=;
        b=kja+sqnirUmdW6jZbNSPLVBh3zCvCT58JxwlOtAoMxUwDv6fidkfo1ih8SP/ffB8PA
         gQCCyibCOK2Phc/dSYUpECLHT3FVezFARtDMxFzefh5oI6Q1UHsBuc01nmW9dbgKiJAh
         r9qLODDJnQZJzgp0Q2Yxlokl5TzM10q86h75bvf3CVjd8ES5BhnQMryqB9ANIl4rPj3x
         LbrpMzNG4DXq8VPkCXKJIQdvAJZJLuQ8OKrJcomu/GqL9YPE+Kf1lDIyhbyxgCfSUTBx
         H+poPxN+GYEUaWxKp09DE0vLyT0BIK41ZoCNQKi6rgpBw3oWX1huvRJKe6RC16TmBavB
         bxIQ==
X-Gm-Message-State: AOAM533vNf+pVsZiTCUUnr5MUZ/uH9sjc2rLsABvJhA7jwnM544V6Jlr
        f/h+dCOOW3zrTAK4GEN+8FpwYwwcEmM=
X-Google-Smtp-Source: ABdhPJz2moruALIIKXz6XYFjRun2PuAcc2wsLbw3y5G/mYWepR5qnXm0prqWXw9TX9g8mKVJPKdKrN1xgy0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:74d4:: with SMTP id p203mr6436875ybc.75.1614286080185;
 Thu, 25 Feb 2021 12:48:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:26 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 01/24] KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only
 if PML is enabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that PML is actually enabled before setting the mask to force a
SPTE to be write-protected.  The bits used for the !AD_ENABLED case are
in the upper half of the SPTE.  With 64-bit paging and EPT, these bits
are ignored, but with 32-bit PAE paging they are reserved.  Setting them
for L2 SPTEs without checking PML breaks NPT on 32-bit KVM.

Fixes: 1f4e5fc83a42 ("KVM: x86: fix nested guest live migration with PML")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 72b0928f2b2d..ec4fc28b325a 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -81,15 +81,15 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * When using the EPT page-modification log, the GPAs in the log
-	 * would come from L2 rather than L1.  Therefore, we need to rely
-	 * on write protection to record dirty pages.  This also bypasses
-	 * PML, since writes now result in a vmexit.  Note, this helper will
-	 * tag SPTEs as needing write-protection even if PML is disabled or
-	 * unsupported, but that's ok because the tag is consumed if and only
-	 * if PML is enabled.  Omit the PML check to save a few uops.
+	 * When using the EPT page-modification log, the GPAs in the CPU dirty
+	 * log would come from L2 rather than L1.  Therefore, we need to rely
+	 * on write protection to record dirty pages, which bypasses PML, since
+	 * writes now result in a vmexit.  Note, the check on CPU dirty logging
+	 * being enabled is mandatory as the bits used to denote WP-only SPTEs
+	 * are reserved for NPT w/ PAE (32-bit KVM).
 	 */
-	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
+	return vcpu->arch.mmu == &vcpu->arch.guest_mmu &&
+	       kvm_x86_ops.cpu_dirty_log_size;
 }
 
 bool is_nx_huge_page_enabled(void);
-- 
2.30.1.766.gb4fecdf3b7-goog

