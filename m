Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCFF60FCD5
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbiJ0QTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiJ0QTB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:19:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1026F196B5D
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nHpsDXiz+aHYtK+0lAoWeHJtx3zrlQWx8bxkmWSYZoI=;
        b=gQa8San15Dl5oT1qq0O+g5yCgwqcyJpdMtjQ+KTCThHzXFaLDQlqktmP/QRX6tp7MWr9If
        j8IPnZOS63Q5nGwWZaLdPTY9AuK54/uXBz2OIXJH8niW0WEacY7S71pQyYmighubTH25Lx
        uwwUo4kgsrILCsI/eSp0WC5QtYguZ8I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-4cbIMR2gNtSLMgLC42Eb8w-1; Thu, 27 Oct 2022 12:18:52 -0400
X-MC-Unique: 4cbIMR2gNtSLMgLC42Eb8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED5101C0896D;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC29C1401C21;
        Thu, 27 Oct 2022 16:18:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 09/16] KVM: Clean up hva_to_pfn_retry()
Date:   Thu, 27 Oct 2022 12:18:42 -0400
Message-Id: <20221027161849.2989332-10-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        PP_MIME_FAKE_ASCII_TEXT,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

Make hva_to_pfn_retry() use kvm instance cached in gfn_to_pfn_cache.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-10-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/pfncache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index dfcf883ca298..48f400819d1e 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -138,7 +138,7 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 	return kvm->mmu_invalidate_seq != mmu_seq;
 }
 
-static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 {
 	/* Note, the new page offset may be different than the old! */
 	void *old_khva = gpc->khva - offset_in_page(gpc->khva);
@@ -158,7 +158,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 	gpc->valid = false;
 
 	do {
-		mmu_seq = kvm->mmu_invalidate_seq;
+		mmu_seq = gpc->kvm->mmu_invalidate_seq;
 		smp_rmb();
 
 		write_unlock_irq(&gpc->lock);
@@ -216,7 +216,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(kvm, mmu_seq));
+	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
 
 	gpc->valid = true;
 	gpc->pfn = new_pfn;
@@ -296,7 +296,7 @@ static int __kvm_gpc_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc, gpa_
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
 	if (!gpc->valid || old_uhva != gpc->uhva) {
-		ret = hva_to_pfn_retry(kvm, gpc);
+		ret = hva_to_pfn_retry(gpc);
 	} else {
 		/* If the HVA→PFN mapping was already valid, don't unmap it. */
 		old_pfn = KVM_PFN_ERR_FAULT;
-- 
2.31.1


