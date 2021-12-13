Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C96F473830
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244053AbhLMW7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244066AbhLMW72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:28 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60C1C061751
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:28 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id gf15-20020a17090ac7cf00b001a9a31687d0so9486269pjb.1
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7FL2w8dpPfO+G2QLXIxjm0csK2DC0KxYpauIDjxm0W4=;
        b=JZJEl3xodRJIDgfu8OkIMkbS7DBGGMWibPsNL7OqBNacy1HHNZJkU/XLzr71r0zHxl
         6ejE1eCRfIN9J+cAWg0/ms7ZJfYa0+CMF0sbvM3VmbM/bl2ZTAzA2B6GCLZnXb9YKfGQ
         vIRsRQ4hF5MNj7Uvc41GNTkl4amUj8iACgfohHSJFnQRX/62aAOfu8JJuNrn+FbR80jF
         ze5GuK2omvjVaGp5c9cdwIkdHhnm+0eY8JcVFBVMib47fOe0NsIGE0KnJ5D3i4nmKYgF
         dwMUaTRFZHH1WOcqRAzjtmyUmD095UIi3RgOaXDXAyWkECpDeGYF0pSIKLAaL8KGiXnG
         ejOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7FL2w8dpPfO+G2QLXIxjm0csK2DC0KxYpauIDjxm0W4=;
        b=YG610YprjkZY9QuveD6l1BU+KO57Ld2lDs+rWWOKLJQjjED2DYSmex6XLGo4ZPfl50
         crQibGoBxMThJ5En8Eh6f2uiFK74vxbGqFINktkm5RLtlCrMwhnuHhmmYaAuHsms64ah
         ZZiU935+elnmX2bKFSnn66SwfFxB8qGlXE9mn98BpP8pY7POwU3IWV/WjmJn2oF1ihJV
         LpwVDPtleb/J9GYwACau5m7pNC2e2bqM5wUal4FEr9e5ewt0srMz2EklWyyiFq8bZT/F
         PhKr4CJSuasRVzU3gr8oz/3jV7cIMM1BCvRNdA0tvld7ctYBYRUbMyQ0GVMqCi/WxVwi
         5xoQ==
X-Gm-Message-State: AOAM532MwcVsIID+5ANoIoR1vc99NIXViWC+LOT89D/hGzJcEMhS0bU2
        oPuihZiltnNXE9oFditffxv2Xcm0cEuKTg==
X-Google-Smtp-Source: ABdhPJzN2VsU0o8SxPQHyOSfFLQ6BjlTNn/thWcNFkZjJSo8shVVvaFc9PGJJ2RiiUpvuBzsWqQoN4TbH0jRsA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e804:b0:142:1c0b:c2a6 with SMTP
 id u4-20020a170902e80400b001421c0bc2a6mr1160949plg.23.1639436368190; Mon, 13
 Dec 2021 14:59:28 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:09 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 04/13] KVM: x86/mmu: Factor out logic to atomically install
 a new page table
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the logic to atomically replace an SPTE with an SPTE that
points to a new page table. This will be used in a follow-up commit to
split a large page SPTE into one level lower.

Opportunistically drop the kvm_mmu_get_page tracepoint in
kvm_tdp_mmu_map() since it is redundant with the identical tracepoint in
alloc_tdp_mmu_page().

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 48 +++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 656ebf5b20dc..dbd07c10d11a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -950,6 +950,36 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+/*
+ * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
+ * spte pointing to the provided page table.
+ *
+ * @kvm: kvm instance
+ * @iter: a tdp_iter instance currently on the SPTE that should be set
+ * @sp: The new TDP page table to install.
+ * @account_nx: True if this page table is being installed to split a
+ *              non-executable huge page.
+ *
+ * Returns: True if the new page table was installed. False if spte being
+ *          replaced changed, causing the atomic compare-exchange to fail.
+ *          If this function returns false the sp will be freed before
+ *          returning.
+ */
+static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,
+				      struct tdp_iter *iter,
+				      struct kvm_mmu_page *sp,
+				      bool account_nx)
+{
+	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
+
+	if (!tdp_mmu_set_spte_atomic(kvm, iter, spte))
+		return false;
+
+	tdp_mmu_link_page(kvm, sp, account_nx);
+
+	return true;
+}
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -959,8 +989,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
-	u64 *child_pt;
-	u64 new_spte;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -996,6 +1024,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
+			bool account_nx = fault->huge_page_disallowed &&
+					  fault->req_level >= iter.level;
+
 			/*
 			 * If SPTE has been frozen by another thread, just
 			 * give up and retry, avoiding unnecessary page table
@@ -1005,18 +1036,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 				break;
 
 			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
-			child_pt = sp->spt;
-
-			new_spte = make_nonleaf_spte(child_pt,
-						     !shadow_accessed_mask);
-
-			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
-				tdp_mmu_link_page(vcpu->kvm, sp,
-						  fault->huge_page_disallowed &&
-						  fault->req_level >= iter.level);
-
-				trace_kvm_mmu_get_page(sp, true);
-			} else {
+			if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx)) {
 				tdp_mmu_free_sp(sp);
 				break;
 			}
-- 
2.34.1.173.g76aa8bc2d0-goog

