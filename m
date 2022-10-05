Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773575F547B
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJEMbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 08:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJEMbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 08:31:40 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AE322502
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 05:31:38 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1og3Ym-00GedC-Tv; Wed, 05 Oct 2022 14:31:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References
        :In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=p7eA/YhudeL774+M8pHB4lgypqtLnbm/u/epHCCio+U=; b=ngeT+0jbwfDUdvXKyVejwhy/Qj
        9L4jpXbizGb5kr+A19ajtMS+IzEqRiQ7wgdOXwtU21pUAg3tI5toQca45n6XG1HV2M8byuDzuLtOq
        3YmmYHcdmPpL9pwZ4cP3iiwmyFB0ciJfWSWmPd4SikG3iqaoldQLI8bwOLryqvBy8hEbs6tOqOLbu
        Gt/6PTWpaLm2sc8ejxinKA8/3y8uay6geUT/Io7qRQ6vSdx5NHOTXvyTVkIvXlJR4k+JH9Q4prZlC
        DH0IqQNcrwGOGB0EYTlgrVochSREKbCN6Ey95WxE9CfWuTI4NmEguVnRPyNDl0hwaTbs05qylfuky
        cZKEF+Nw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1og3Ym-0001KZ-KV; Wed, 05 Oct 2022 14:31:36 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1og3YR-0007vp-B5; Wed, 05 Oct 2022 14:31:15 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 6/8] KVM: x86: Clean up hva_to_pfn_retry()
Date:   Wed,  5 Oct 2022 14:30:49 +0200
Message-Id: <20221005123051.895056-7-mhal@rbox.co>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221005123051.895056-1-mhal@rbox.co>
References: <YySujDJN2Wm3ivi/@google.com>
 <20221005123051.895056-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make hva_to_pfn_retry() use kvm instance cached in gfn_to_pfn_cache.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 virt/kvm/pfncache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index eb91025d7242..a2c95e393e34 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -135,7 +135,7 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 	return kvm->mmu_invalidate_seq != mmu_seq;
 }
 
-static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 {
 	/* Note, the new page offset may be different than the old! */
 	void *old_khva = gpc->khva - offset_in_page(gpc->khva);
@@ -155,7 +155,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	gpc->valid = false;
 
 	do {
-		mmu_seq = kvm->mmu_invalidate_seq;
+		mmu_seq = gpc->kvm->mmu_invalidate_seq;
 		smp_rmb();
 
 		write_unlock_irq(&gpc->lock);
@@ -213,7 +213,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(kvm, mmu_seq));
+	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
 
 	gpc->valid = true;
 	gpc->pfn = new_pfn;
@@ -285,7 +285,7 @@ int kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
 	if (!gpc->valid || old_uhva != gpc->uhva) {
-		ret = hva_to_pfn_retry(kvm, gpc);
+		ret = hva_to_pfn_retry(gpc);
 	} else {
 		/* If the HVA→PFN mapping was already valid, don't unmap it. */
 		old_pfn = KVM_PFN_ERR_FAULT;
-- 
2.37.3

