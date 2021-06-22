Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0A53B0C5A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhFVSG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbhFVSF4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:05:56 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83718C0611C0
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:51 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 100-20020aed206d0000b029024ea3acef5bso70135qta.12
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SxMwq+Fb//YeteExsjIbg17V9/7EC+7XImLfVTV5nh0=;
        b=fAoidzFy5hhmiTZx77H2Mmpx6u8YLPdcyUQUhyg4Nxuo+jTSYmtT9Dd3BXKXjSRXrN
         +h8r7QscP2cXvRR2Z7hb4kJSGQxbHWMoKH2ovOrpdxX67nEiAq7WgRnOdHKmewkBr2v5
         0z5OZcl9bQ5OySrHCxmJ9Hc79IPYa8B8C8W7f1Ir8rwFzoLrsA873n+aa3ylzsUu3Qv+
         sqhZnDCCneH9MyXd25YT0V98giBBZXLYV96Udme3zKII/k4elffLVI0vDC+7svbGQ0p6
         ZksbfvHnOxbxNc+jeND2xmuYuZWG43Kv+MFr7z2ysYXATYd0kuh8nKtJ7/P92btseqZt
         kBjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SxMwq+Fb//YeteExsjIbg17V9/7EC+7XImLfVTV5nh0=;
        b=mLBoLVDNIYRkPtXS8NBkEbp9UPeNu+EexaSdpEIsD/A+nNZuLXJvBYadk1J6RgrTaD
         DPF9yFYyJg+zbBzw9BwEIiT7C+qxVH59mclTcbRyjdGpn4eW1YH0ENIIKsg/jFcC7ntG
         8HQ+2s0nceKn7oGI8j4+Ei39h3eBmMuekJU+bxnyc/nh0bRQPyeObcmCJNlHlvLcIfkB
         vpxY3/VQIgQPwW1fOahit7muqRIz3SK3VQKAw/pzHcxwxihAXGj1sxEff10jQIp3muCT
         Zrxn/scmRV8rhonwkJhhy8xPRj2aJqJW86dH6WsRdknqDtqKPzYoAO2QL+ZMEPbUbugp
         m1GA==
X-Gm-Message-State: AOAM531qrv5U3zHL4WQ22++UnI0LynVnfuL/hRXCmtOkVENI2Jilv7BA
        CwV2GnP65f/mB4Os51MhOLgud34D780=
X-Google-Smtp-Source: ABdhPJziCZqztf+hFpD0pPSembI4mPzbyKWFKGLTcjCfTLgRUsaT93V3nnoMdpr4KohNkXnphZICRQcS4M8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:a208:: with SMTP id b8mr6821090ybi.411.1624384790675;
 Tue, 22 Jun 2021 10:59:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:35 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-51-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 50/54] KVM: x86/mmu: Optimize and clean up so called "last
 nonleaf level" logic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the pre-computed last_nonleaf_level, which is arguably wrong and at
best confusing.  Per the comment:

  Can have large pages at levels 2..last_nonleaf_level-1.

the intent of the variable would appear to be to track what levels can
_legally_ have large pages, but that intent doesn't align with reality.
The computed value will be wrong for 5-level paging, or if 1gb pages are
not supported.

The flawed code is not a problem in practice, because except for 32-bit
PSE paging, bit 7 is reserved if large pages aren't supported at the
level.  Take advantage of this invariant and simply omit the level magic
math for 64-bit page tables (including PAE).

For 32-bit paging (non-PAE), the adjustments are needed purely because
bit 7 is ignored if PSE=0.  Retain that logic as is, but make
is_last_gpte() unique per PTTYPE so that the PSE check is avoided for
PAE and EPT paging.  In the spirit of avoiding branches, bump the "last
nonleaf level" for 32-bit PSE paging by adding the PSE bit itself.

Note, bit 7 is ignored or has other meaning in CR3/EPTP, but despite
FNAME(walk_addr_generic) briefly grabbing CR3/EPTP in "pte", they are
not PTEs and will blow up all the other gpte helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/mmu/mmu.c          | 31 -------------------------------
 arch/x86/kvm/mmu/paging_tmpl.h  | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2da8b5ddbd6a..c97b83cf8381 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -457,9 +457,6 @@ struct kvm_mmu {
 
 	struct rsvd_bits_validate guest_rsvd_check;
 
-	/* Can have large pages at levels 2..last_nonleaf_level-1. */
-	u8 last_nonleaf_level;
-
 	u64 pdptrs[4]; /* pae */
 };
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 34e7a489e71b..7849f53fd874 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4071,26 +4071,6 @@ static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 	return false;
 }
 
-static inline bool is_last_gpte(struct kvm_mmu *mmu,
-				unsigned level, unsigned gpte)
-{
-	/*
-	 * The RHS has bit 7 set iff level < mmu->last_nonleaf_level.
-	 * If it is clear, there are no large pages at this level, so clear
-	 * PT_PAGE_SIZE_MASK in gpte if that is the case.
-	 */
-	gpte &= level - mmu->last_nonleaf_level;
-
-	/*
-	 * PG_LEVEL_4K always terminates.  The RHS has bit 7 set
-	 * iff level <= PG_LEVEL_4K, which for our purpose means
-	 * level == PG_LEVEL_4K; set PT_PAGE_SIZE_MASK in gpte then.
-	 */
-	gpte |= level - PG_LEVEL_4K - 1;
-
-	return gpte & PT_PAGE_SIZE_MASK;
-}
-
 #define PTTYPE_EPT 18 /* arbitrary */
 #define PTTYPE PTTYPE_EPT
 #include "paging_tmpl.h"
@@ -4491,15 +4471,6 @@ static void update_pkru_bitmask(struct kvm_mmu *mmu)
 	}
 }
 
-static void update_last_nonleaf_level(struct kvm_mmu *mmu)
-{
-	unsigned root_level = mmu->root_level;
-
-	mmu->last_nonleaf_level = root_level;
-	if (root_level == PT32_ROOT_LEVEL && is_cr4_pse(mmu))
-		mmu->last_nonleaf_level++;
-}
-
 static void reset_guest_paging_metadata(struct kvm_vcpu *vcpu,
 					struct kvm_mmu *mmu)
 {
@@ -4509,7 +4480,6 @@ static void reset_guest_paging_metadata(struct kvm_vcpu *vcpu,
 	reset_rsvds_bits_mask(vcpu, mmu);
 	update_permission_bitmask(mmu, false);
 	update_pkru_bitmask(mmu);
-	update_last_nonleaf_level(mmu);
 }
 
 static void paging64_init_context(struct kvm_mmu *context)
@@ -4783,7 +4753,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->direct_map = false;
 
 	update_permission_bitmask(context, true);
-	update_last_nonleaf_level(context);
 	update_pkru_bitmask(context);
 	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
 	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index c92e712607b6..ec1de57f3572 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -305,6 +305,35 @@ static inline unsigned FNAME(gpte_pkeys)(struct kvm_vcpu *vcpu, u64 gpte)
 	return pkeys;
 }
 
+static inline bool FNAME(is_last_gpte)(struct kvm_mmu *mmu,
+				       unsigned int level, unsigned int gpte)
+{
+	/*
+	 * For EPT and PAE paging (both variants), bit 7 is either reserved at
+	 * all level or indicates a huge page (ignoring CR3/EPTP).  In either
+	 * case, bit 7 being set terminates the walk.
+	 */
+#if PTTYPE == 32
+	/*
+	 * 32-bit paging requires special handling because bit 7 is ignored if
+	 * CR4.PSE=0, not reserved.  Clear bit 7 in the gpte if the level is
+	 * greater than the last level for which bit 7 is the PAGE_SIZE bit.
+	 *
+	 * The RHS has bit 7 set iff level < (2 + PSE).  If it is clear, bit 7
+	 * is not reserved and does not indicate a large page at this level,
+	 * so clear PT_PAGE_SIZE_MASK in gpte if that is the case.
+	 */
+	gpte &= level - (PT32_ROOT_LEVEL + !!mmu->mmu_role.ext.cr4_pse);
+#endif
+	/*
+	 * PG_LEVEL_4K always terminates.  The RHS has bit 7 set
+	 * iff level <= PG_LEVEL_4K, which for our purpose means
+	 * level == PG_LEVEL_4K; set PT_PAGE_SIZE_MASK in gpte then.
+	 */
+	gpte |= level - PG_LEVEL_4K - 1;
+
+	return gpte & PT_PAGE_SIZE_MASK;
+}
 /*
  * Fetch a guest pte for a guest virtual address, or for an L2's GPA.
  */
@@ -421,7 +450,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
 		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
-	} while (!is_last_gpte(mmu, walker->level, pte));
+	} while (!FNAME(is_last_gpte)(mmu, walker->level, pte));
 
 	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
 	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
-- 
2.32.0.288.g62a8d224e6-goog

