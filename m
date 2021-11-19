Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326A64579CD
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhKTABk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236227AbhKTABU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:20 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E64C061574
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:17 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id v23-20020a170902bf9700b001421d86afc4so5356893pls.9
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IFiCOA44RFYNwaRr/Yb1BDlw+EFlbcyt6Uo3IPFhDZo=;
        b=kuGzEGQ65pTKEh6gsEmMPWzBQLJ3tfPfO2YP4JqYZllDteIFsyo3EJiTaJQeP2RLyL
         jHZumiyvBi/3tq0Y482P0/oT6o0tMb3p7NeqUaUrF1hDRHL1dmfk70JhvGACb3SMAb8w
         MG73XS+erymKTKp9F3LikG9NdwRIrYjtpd01twH1ExPmcguk9mpSPaTehYDzYd/XNN4A
         yhnF1AulmXv1wkB8MPhU/t6HJymMNks9QyEQn1sXd8tf9Vqdb4L7rGYmpxaOwQ+trQwE
         i6ExWO28eLjOedEqr3JM9IuzXccsSFUu4rKGvp7/E/oXnH4uIWD6ERILyFhIqn+bFHFa
         +CgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IFiCOA44RFYNwaRr/Yb1BDlw+EFlbcyt6Uo3IPFhDZo=;
        b=GMheO/agsugWp9zMsFiuLbiI2DJ+7sbhwT2OZWJ3RNb6g42AyiS5TjlR2mRZnGOi06
         SGcUmsrMrTMFhcUpx+nVA8AWiXx63FJU5CfNgaK3m3m/YcNLwyOoum4szv+YqFK1VOr0
         OO+5NBMviDYylbWFY8/yeNuM0XhZPVL1p6nwJzfU4kh2mYDd623EJ7rnOHP9Z4PH4nt9
         Dh3hccz1H1zNf2IN1jbrJjvBF+bLk2FWxbQ1LzN3gzFRLsubDXc7JmlqSjZ4zB4HdDqC
         7gjOJ/nBOZRxukLcVLdXHvc+xDJjDeRCL4nPzND42kFTUnjMn5nRWaiaQZoeTaIwtNk8
         zOBQ==
X-Gm-Message-State: AOAM531M7mJk8AJEKOIdnqVsX2pK84vlaHBOZnS5k/KvGW89kZyQzj2X
        via5N/G8d8rMI7dnlzZ5EUgP5Yy1aiG7PQ==
X-Google-Smtp-Source: ABdhPJydB1K+/B/2hmZVYyzVCOl2RrQKg/VTodVN+yYJAtI40Y49nXiXylnIcWmFVSJtOTp5jQ2hu7NnRLXGVA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:8d85:b0:142:892d:bfa with SMTP id
 v5-20020a1709028d8500b00142892d0bfamr82529714plo.76.1637366296582; Fri, 19
 Nov 2021 15:58:16 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:48 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 04/15] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
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
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the logic to atomically replace an SPTE with an SPTE that
points to a new page table. This will be used in a follow-up commit to
split a large page SPTE into one level lower.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 53 ++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cc9fe33c9b36..9ee3f4f7fdf5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -945,6 +945,39 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
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
+	u64 spte;
+
+	spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
+
+	if (tdp_mmu_set_spte_atomic(kvm, iter, spte)) {
+		tdp_mmu_link_page(kvm, sp, account_nx);
+		return true;
+	} else {
+		tdp_mmu_free_sp(sp);
+		return false;
+	}
+}
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -954,8 +987,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
-	u64 *child_pt;
-	u64 new_spte;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -983,6 +1014,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
+			bool account_nx = fault->huge_page_disallowed &&
+					  fault->req_level >= iter.level;
+
 			/*
 			 * If SPTE has been frozen by another thread, just
 			 * give up and retry, avoiding unnecessary page table
@@ -992,21 +1026,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
-				tdp_mmu_free_sp(sp);
+			if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx))
 				break;
-			}
 		}
 	}
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

