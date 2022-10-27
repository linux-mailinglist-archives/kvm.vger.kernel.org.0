Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0491160FCEA
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbiJ0QTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236589AbiJ0QTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:19:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFDA196ED9
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6aHPqfRabBG7+Uh3PTVNYMLpzQUUZusTV/Bql6znhc=;
        b=ZUaU5FOf082+UzXpOZQo/0yddQBI5SFDNuLUV1hvrEbewr6LHOu5JYla1GfZKn2ulPlWR1
        AhTo0lGqoGIve0UR/y8AU0AYYbNegk9NwhQliTNOn54HiggkBlDIU9pVCi7RmNRTf33afQ
        hzw05wWAqZt8rIr9PvBCBfPG+YUKW8Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-lUjuoMU0PFaeMn5n0Jqg-A-1; Thu, 27 Oct 2022 12:18:52 -0400
X-MC-Unique: lUjuoMU0PFaeMn5n0Jqg-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6605E3C025CA;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44CC717593;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 11/16] KVM: Drop KVM's API to allow temprorarily unmapping gfn=>pfn cache
Date:   Thu, 27 Oct 2022 12:18:44 -0400
Message-Id: <20221027161849.2989332-12-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

From: Sean Christopherson <seanjc@google.com>

Drop kvm_gpc_unmap() as it has no users and unclear requirements.  The
API was added as part of the original gfn_to_pfn_cache support, but its
sole usage[*] was never merged.  Fold the guts of kvm_gpc_unmap() into
the deactivate path and drop the API.  Omit acquiring refresh_lock as
as concurrent calls to kvm_gpc_deactivate() are not allowed (this is
not enforced, e.g. via lockdep. due to it being called during vCPU
destruction).

If/when temporary unmapping makes a comeback, the desirable behavior is
likely to restrict temporary unmapping to vCPU-exclusive mappings and
require the vcpu->mutex be held to serialize unmap.  Use of the
refresh_lock to protect unmapping was somewhat specuatively added by
commit 93984f19e7bc ("KVM: Fully serialize gfn=>pfn cache refresh via
mutex") to guard against concurrent unmaps, but the primary use case of
the temporary unmap, nested virtualization[*], doesn't actually need or
want concurrent unmaps.

[*] https://lore.kernel.org/all/20211210163625.2886-7-dwmw2@infradead.org

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221013211234.1318131-12-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/kvm_host.h | 12 -----------
 virt/kvm/pfncache.c      | 44 +++++++++++++++-------------------------
 2 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d4a49c89bc08..3847b721e753 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1314,18 +1314,6 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
  */
 int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa);
 
-/**
- * kvm_gpc_unmap - temporarily unmap a gfn_to_pfn_cache.
- *
- * @kvm:	   pointer to kvm instance.
- * @gpc:	   struct gfn_to_pfn_cache object.
- *
- * This unmaps the referenced page. The cache is left in the invalid state
- * but at least the mapping from GPA to userspace HVA will remain cached
- * and can be reused on a subsequent refresh.
- */
-void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
-
 /**
  * kvm_gpc_deactivate - deactivate and unlink a gfn_to_pfn_cache.
  *
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index e4ebea75dca9..62429b2a6389 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -335,33 +335,6 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_refresh);
 
-void kvm_gpc_unmap(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
-{
-	void *old_khva;
-	kvm_pfn_t old_pfn;
-
-	mutex_lock(&gpc->refresh_lock);
-	write_lock_irq(&gpc->lock);
-
-	gpc->valid = false;
-
-	old_khva = gpc->khva - offset_in_page(gpc->khva);
-	old_pfn = gpc->pfn;
-
-	/*
-	 * We can leave the GPA → uHVA map cache intact but the PFN
-	 * lookup will need to be redone even for the same page.
-	 */
-	gpc->khva = NULL;
-	gpc->pfn = KVM_PFN_ERR_FAULT;
-
-	write_unlock_irq(&gpc->lock);
-	mutex_unlock(&gpc->refresh_lock);
-
-	gpc_unmap_khva(old_pfn, old_khva);
-}
-EXPORT_SYMBOL_GPL(kvm_gpc_unmap);
-
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm,
 		  struct kvm_vcpu *vcpu, enum pfn_cache_usage usage)
 {
@@ -407,6 +380,8 @@ EXPORT_SYMBOL_GPL(kvm_gpc_activate);
 void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 {
 	struct kvm *kvm = gpc->kvm;
+	kvm_pfn_t old_pfn;
+	void *old_khva;
 
 	if (gpc->active) {
 		/*
@@ -416,13 +391,26 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		 */
 		write_lock_irq(&gpc->lock);
 		gpc->active = false;
+		gpc->valid = false;
+
+		/*
+		 * Leave the GPA => uHVA cache intact, it's protected by the
+		 * memslot generation.  The PFN lookup however will have to be
+		 * redone after the cache is removed from the VM's gpc_list,
+		 * as that loses mmu_notifier protection.
+		 */
+		old_khva = gpc->khva - offset_in_page(gpc->khva);
+		gpc->khva = NULL;
+
+		old_pfn = gpc->pfn;
+		gpc->pfn = KVM_PFN_ERR_FAULT;
 		write_unlock_irq(&gpc->lock);
 
 		spin_lock(&kvm->gpc_lock);
 		list_del(&gpc->list);
 		spin_unlock(&kvm->gpc_lock);
 
-		kvm_gpc_unmap(kvm, gpc);
+		gpc_unmap_khva(old_pfn, old_khva);
 	}
 }
 EXPORT_SYMBOL_GPL(kvm_gpc_deactivate);
-- 
2.31.1


