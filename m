Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66024CC61E
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiCCTjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbiCCTjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9646694AB
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNdn5Vk+CrEyRiXh1DB8vt1j4ccuICGhDqmAiMrsokw=;
        b=i5BRUch40/VexlsuKiF4C0MqS8nc0ZyiKR1hberjF4We5cw18I7FS5SlFCe04q/v47pIHc
        d6uCL02Kb7ocJhX3iZl52UQD4qHS1bcKzwhfXUp2hMs1Qsi9pS29z8XqHXBVu1VePphnUg
        CIRIBxmBhtEh6PxAfVhMfaSg4+En5AI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-SvCN4WF1MJOtmZwhCPrzxQ-1; Thu, 03 Mar 2022 14:38:53 -0500
X-MC-Unique: SvCN4WF1MJOtmZwhCPrzxQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E45351DC;
        Thu,  3 Mar 2022 19:38:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BD025DF2E;
        Thu,  3 Mar 2022 19:38:50 +0000 (UTC)
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
Subject: [PATCH v4 07/30] KVM: x86/mmu: do not allow readers to acquire references to invalid roots
Date:   Thu,  3 Mar 2022 14:38:19 -0500
Message-Id: <20220303193842.370645-8-pbonzini@redhat.com>
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

Remove the "shared" argument of for_each_tdp_mmu_root_yield_safe, thus ensuring
that readers do not ever acquire a reference to an invalid root.  After this
patch, all readers except kvm_tdp_mmu_zap_invalidated_roots() treat
refcount=0/valid, refcount=0/invalid and refcount=1/invalid in exactly the
same way.  kvm_tdp_mmu_zap_invalidated_roots() is different but it also
does not acquire a reference to the invalid root, and it cannot see
refcount=0/invalid because it is guaranteed to run after
kvm_tdp_mmu_invalidate_all_roots().

Opportunistically add a lockdep assertion to the yield-safe iterator.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d39593b9ac9e..79bc48ddb69d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -166,14 +166,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _only_valid);	\
 	     _root;								\
 	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _only_valid))	\
-		if (kvm_mmu_page_as_id(_root) != _as_id) {			\
+		if (kvm_lockdep_assert_mmu_lock_held(_kvm, _shared) &&		\
+		    kvm_mmu_page_as_id(_root) != _as_id) {			\
 		} else
 
 #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
 	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
 
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)		\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, false)
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)			\
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, false, false)
 
 /*
  * Iterate over all TDP MMU roots.  Requires that mmu_lock be held for write,
@@ -808,7 +809,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
 		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
 				      false);
 
-- 
2.31.1


