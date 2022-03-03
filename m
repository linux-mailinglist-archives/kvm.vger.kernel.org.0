Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F32A4CC632
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiCCTjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236006AbiCCTjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BC5165D3C
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zZ4UIIxhpJEYvaQqiL3cf7FKEY9UCRRYhOm/du6iaY8=;
        b=SjWmrN20jg2PJss3B2wxF/6GSt/7N7JeP1YobrjgEMGPj+NoUY1sbXfi4IA57tdGafi30Z
        BBdYVLEZp9SuYq5dmHFVQwm/SZ8w13odTCK1sSiayWoqcSU1gl8Quk3pK8muObiDAP4JF3
        dsvcDkeX1CFYFo2wEvXrZGrQS+MAr2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-GzRa4kH9Of-IumONNbTYsQ-1; Thu, 03 Mar 2022 14:38:51 -0500
X-MC-Unique: GzRa4kH9Of-IumONNbTYsQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 414DF1006AA5;
        Thu,  3 Mar 2022 19:38:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E9B75E267;
        Thu,  3 Mar 2022 19:38:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 06/30] KVM: x86/mmu: only perform eager page splitting on valid roots
Date:   Thu,  3 Mar 2022 14:38:18 -0500
Message-Id: <20220303193842.370645-7-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eager page splitting is an optimization; it does not have to be performed on
invalid roots.  It is also the only case in which a reader might acquire
a reference to an invalid root, so after this change we know that readers
will skip both dying and invalid roots.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 30424fbceb5f..d39593b9ac9e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1464,7 +1464,7 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, shared) {
+	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, shared) {
 		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level, shared);
 		if (r) {
 			kvm_tdp_mmu_put_root(kvm, root, shared);
-- 
2.31.1


