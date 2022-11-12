Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D866268A8
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 10:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiKLJow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 04:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKLJov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 04:44:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7471D65D
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 01:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668246233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+vth4QqRUuDSpOWMLlQs7VjBpqTVerCXz3PtT0havhE=;
        b=Ll1VbxSWACGQ93dwCmiAgBGh0OlPImrNnKjOp2zLzSOrFwvO5FyGaCyeGpCzSbVu8VR5WB
        8mcsnSpkdbRRH83TqXZKnKtilPllw92FTkPQetXOHSNOroU9C1PnZLu3lwZs8qAAWxBf5P
        vUdc713cU/iEyJ8Ypz5oiO+LAxaE+PI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-DSjGDlhaODmp06gJS4w96A-1; Sat, 12 Nov 2022 04:43:51 -0500
X-MC-Unique: DSjGDlhaODmp06gJS4w96A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E58085A583;
        Sat, 12 Nov 2022 09:43:51 +0000 (UTC)
Received: from gshan.redhat.com (unknown [10.67.24.81])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A53AC17585;
        Sat, 12 Nov 2022 09:43:42 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
        seanjc@google.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH for-next] KVM: Push dirty information unconditionally to backup bitmap
Date:   Sat, 12 Nov 2022 17:43:22 +0800
Message-Id: <20221112094322.21911-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In mark_page_dirty_in_slot(), we bail out when no running vcpu exists
and a running vcpu context is strictly required by architecture. It may
cause backwards compatible issue. Currently, saving vgic/its tables is
the only known case where no running vcpu context is expected. We may
have other unknown cases where no running vcpu context exists and it's
reported by the warning message and we bail out without pushing the
dirty information to the backup bitmap. For this, the application is
going to enable the backup bitmap for the unknown cases. However, the
dirty information can't be pushed to the backup bitmap even though the
backup bitmap is enabled for those unknown cases in the application,
until the unknown cases are added to the allowed list of non-running
vcpu context with extra code changes to the host kernel.

In order to make the new application, where the backup bitmap has been
enabled, to work with the unchanged host, we continue to push the dirty
information to the backup bitmap instead of bailing out early. With the
added check on 'memslot->dirty_bitmap' to mark_page_dirty_in_slot(), the
kernel crash is avoided silently by the combined conditions: no running
vcpu context, kvm_arch_allow_write_without_running_vcpu() returns 'true',
and the backup bitmap (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) isn't enabled
yet.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 virt/kvm/kvm_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2719e10dd37d..03e6a38094c1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3308,8 +3308,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
 		return;
 
-	if (WARN_ON_ONCE(!kvm_arch_allow_write_without_running_vcpu(kvm) && !vcpu))
-		return;
+	WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm));
 #endif
 
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
@@ -3318,7 +3317,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 
 		if (kvm->dirty_ring_size && vcpu)
 			kvm_dirty_ring_push(vcpu, slot, rel_gfn);
-		else
+		else if (memslot->dirty_bitmap)
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
-- 
2.23.0

