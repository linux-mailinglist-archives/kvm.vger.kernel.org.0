Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10107B4FA9
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 11:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbjJBJ56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 05:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbjJBJ55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 05:57:57 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A74B0;
        Mon,  2 Oct 2023 02:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=cQ02ZWi3OXJZ36oKzuEnX4ff/ZDsG5TQqSf2+fKM4a0=; b=HktkN30axQojx0wotuTnOunyDm
        Y1xDKecGGk/+oX9k0SJo22r+q4XAISbQl2Bp/rjKt385sqQtXE5apQbl7D57aD+dxIjO9PRnSjNCL
        v+IIvQlm1V7YsZzU0g4OAGXnbC1l9/ZYT/quiL8Af1UUuEeuGuV2Rj+VmYFNqz7q7v5A=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qnFgT-0000v6-O5; Mon, 02 Oct 2023 09:57:49 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qnFgT-0000Ft-GD; Mon, 02 Oct 2023 09:57:49 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 01/11] KVM: pfncache: add a map helper function
Date:   Mon,  2 Oct 2023 09:57:30 +0000
Message-Id: <20231002095740.1472907-2-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231002095740.1472907-1-paul@xen.org>
References: <20231002095740.1472907-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

We have an unmap helper but mapping is open-coded. Arguably this is fine
because mapping is done in only one place, hva_to_pfn_retry(), but adding
the helper does make that function more readable.

No functional change intended.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/pfncache.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 2d6aba677830..0f36acdf577f 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -96,17 +96,28 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_check);
 
-static void gpc_unmap_khva(kvm_pfn_t pfn, void *khva)
+static void *gpc_map(kvm_pfn_t pfn)
+{
+	if (pfn_valid(pfn))
+		return kmap(pfn_to_page(pfn));
+#ifdef CONFIG_HAS_IOMEM
+	else
+		return memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
+#endif
+}
+
+static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 {
 	/* Unmap the old pfn/page if it was mapped before. */
-	if (!is_error_noslot_pfn(pfn) && khva) {
-		if (pfn_valid(pfn))
-			kunmap(pfn_to_page(pfn));
+	if (is_error_noslot_pfn(pfn) || !khva)
+		return;
+
+	if (pfn_valid(pfn))
+		kunmap(pfn_to_page(pfn));
 #ifdef CONFIG_HAS_IOMEM
-		else
-			memunmap(khva);
+	else
+		memunmap(khva);
 #endif
-	}
 }
 
 static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq)
@@ -175,7 +186,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			 * the existing mapping and didn't create a new one.
 			 */
 			if (new_khva != old_khva)
-				gpc_unmap_khva(new_pfn, new_khva);
+				gpc_unmap(new_pfn, new_khva);
 
 			kvm_release_pfn_clean(new_pfn);
 
@@ -193,15 +204,11 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 * too must be done outside of gpc->lock!
 		 */
 		if (gpc->usage & KVM_HOST_USES_PFN) {
-			if (new_pfn == gpc->pfn) {
+			if (new_pfn == gpc->pfn)
 				new_khva = old_khva;
-			} else if (pfn_valid(new_pfn)) {
-				new_khva = kmap(pfn_to_page(new_pfn));
-#ifdef CONFIG_HAS_IOMEM
-			} else {
-				new_khva = memremap(pfn_to_hpa(new_pfn), PAGE_SIZE, MEMREMAP_WB);
-#endif
-			}
+			else
+				new_khva = gpc_map(new_pfn);
+
 			if (!new_khva) {
 				kvm_release_pfn_clean(new_pfn);
 				goto out_error;
@@ -326,7 +333,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
 	mutex_unlock(&gpc->refresh_lock);
 
 	if (unmap_old)
-		gpc_unmap_khva(old_pfn, old_khva);
+		gpc_unmap(old_pfn, old_khva);
 
 	return ret;
 }
@@ -412,7 +419,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
 
-		gpc_unmap_khva(old_pfn, old_khva);
+		gpc_unmap(old_pfn, old_khva);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);
-- 
2.39.2

