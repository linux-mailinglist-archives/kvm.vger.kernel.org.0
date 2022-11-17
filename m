Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5789E62E14D
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 17:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240335AbiKQQQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 11:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235038AbiKQQPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 11:15:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFF079E3C
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 08:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668701696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jgeHGWCI+pvVYt1W/flqhT0b6uT1opHUz8BI1fRXQBk=;
        b=MbuLJ565qNMrRTNvclHFiJGiEzRYYzjhxMPPuEY/88pqX/15x1Pg5XewBE3+OgUrKSaVLO
        LR4MqVd0f2G398UJQ67vNMlUWf0HXLiSE9eVbPsdXSg3vFui7Duq0r4JYf43lrBcblASrA
        8eOL2QXbSXcoKD9Wg8GfJBtPOVck2SE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-_kF_-fSCMuuZZh-HTI1sZQ-1; Thu, 17 Nov 2022 11:14:51 -0500
X-MC-Unique: _kF_-fSCMuuZZh-HTI1sZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8991A38123A8;
        Thu, 17 Nov 2022 16:14:50 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EF592024CC8;
        Thu, 17 Nov 2022 16:14:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH] KVM: x86/mmu: simplify kvm_tdp_mmu_map flow when guest has to retry
Date:   Thu, 17 Nov 2022 11:14:49 -0500
Message-Id: <20221117161449.114086-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A removed SPTE is never present, hence the "if" in kvm_tdp_mmu_map
only fails in the exact same conditions that the earlier loop
tested in order to issue a  "break". So, instead of checking twice the
condition (upper level SPTEs could not be created or was frozen), just
exit the loop with a goto---the usual poor-man C replacement for RAII
early returns.

While at it, do not use the "ret" variable for return values of
functions that do not return a RET_PF_* enum.  This is clearer
and also makes it possible to initialize ret to RET_PF_RETRY.

Suggested-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 40 ++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e08596775427..771210ce5181 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1159,7 +1159,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm *kvm = vcpu->kvm;
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
-	int ret;
+	int ret = RET_PF_RETRY;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
@@ -1168,23 +1168,25 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	rcu_read_lock();
 
 	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+		int r;
+
 		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
 		if (iter.level == fault->goal_level)
 			break;
 
-		/* Step down into the lower level page table if it exists. */
-		if (is_shadow_present_pte(iter.old_spte) &&
-		    !is_large_pte(iter.old_spte))
-			continue;
-
 		/*
 		 * If SPTE has been frozen by another thread, just give up and
 		 * retry, avoiding unnecessary page table allocation and free.
 		 */
 		if (is_removed_spte(iter.old_spte))
-			break;
+			goto retry;
+
+		/* Step down into the lower level page table if it exists. */
+		if (is_shadow_present_pte(iter.old_spte) &&
+		    !is_large_pte(iter.old_spte))
+			continue;
 
 		/*
 		 * The SPTE is either non-present or points to a huge page that
@@ -1196,13 +1198,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
 		if (is_shadow_present_pte(iter.old_spte))
-			ret = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
+			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
 		else
-			ret = tdp_mmu_link_sp(kvm, &iter, sp, true);
+			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
-		if (ret) {
+		/*
+		 * Also force the guest to retry the access if the upper level SPTEs
+		 * aren't in place.
+		 */
+		if (r) {
 			tdp_mmu_free_sp(sp);
-			break;
+			goto retry;
 		}
 
 		if (fault->huge_page_disallowed &&
@@ -1213,18 +1219,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
-	/*
-	 * Force the guest to retry the access if the upper level SPTEs aren't
-	 * in place, or if the target leaf SPTE is frozen by another CPU.
-	 */
-	if (iter.level != fault->goal_level || is_removed_spte(iter.old_spte)) {
-		rcu_read_unlock();
-		return RET_PF_RETRY;
-	}
-
 	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
-	rcu_read_unlock();
 
+retry:
+	rcu_read_unlock();
 	return ret;
 }
 
-- 
2.31.1

