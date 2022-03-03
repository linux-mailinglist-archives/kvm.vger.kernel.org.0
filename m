Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D2B4CC620
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiCCTjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiCCTjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C04C3177746
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nNB1Oa5q3CZcX1zVQnvyOn17MBV/603UYrsOl/Ls0w=;
        b=fYPNwbwZ0EYR8rRrb5vo8CMH24+Kkkk6LEtOlf/NjilzLTI5hIC3exlAu6NJ1H97/S5J6l
        00sp+Js+eJI2d8ejdQLPAB+N044i/Z7kuYBp1YqsZHfRwryKq8+wJ+/YYB8mB4BXvxYWKe
        c9WR1mz/9Q2InMFAUq31y562i952/zY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-YeLLj9apOoOgo7QjizRzmg-1; Thu, 03 Mar 2022 14:38:50 -0500
X-MC-Unique: YeLLj9apOoOgo7QjizRzmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FDAD1006AA6;
        Thu,  3 Mar 2022 19:38:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 775E25DF2E;
        Thu,  3 Mar 2022 19:38:48 +0000 (UTC)
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
Subject: [PATCH v4 05/30] KVM: x86/mmu: Require mmu_lock be held for write in unyielding root iter
Date:   Thu,  3 Mar 2022 14:38:17 -0500
Message-Id: <20220303193842.370645-6-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Assert that mmu_lock is held for write by users of the yield-unfriendly
TDP iterator.  The nature of a shared walk means that the caller needs to
play nice with other tasks modifying the page tables, which is more or
less the same thing as playing nice with yielding.  Theoretically, KVM
could gain a flow where it could legitimately take mmu_lock for read in
a non-preemptible context, but that's highly unlikely and any such case
should be viewed with a fair amount of scrutiny.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-7-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2ce6915b70fe..30424fbceb5f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -29,13 +29,16 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	return true;
 }
 
-static __always_inline void kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
+/* Arbitrarily returns true so that this may be used in if statements. */
+static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 							     bool shared)
 {
 	if (shared)
 		lockdep_assert_held_read(&kvm->mmu_lock);
 	else
 		lockdep_assert_held_write(&kvm->mmu_lock);
+
+	return true;
 }
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
@@ -172,11 +175,17 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 #define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)		\
 	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, false)
 
-#define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
-	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,		\
-				lockdep_is_held_type(&kvm->mmu_lock, 0) ||	\
-				lockdep_is_held(&kvm->arch.tdp_mmu_pages_lock))	\
-		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
+/*
+ * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
+ * the implication being that any flow that holds mmu_lock for read is
+ * inherently yield-friendly and should use the yield-safe variant above.
+ * Holding mmu_lock for write obviates the need for RCU protection as the list
+ * is guaranteed to be stable.
+ */
+#define for_each_tdp_mmu_root(_kvm, _root, _as_id)			\
+	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)	\
+		if (kvm_lockdep_assert_mmu_lock_held(_kvm, false) &&	\
+		    kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
-- 
2.31.1


