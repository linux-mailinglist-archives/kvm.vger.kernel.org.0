Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744894CC661
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiCCToW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbiCCTnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:43:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B60FDCC52B
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FlDxIdfvuhWS0CXMFQ/cPlPI27gcOld4vJ0GlmM2Eho=;
        b=ZWR2aXk14Vn0wri6xhwDCT9+DGKddOH5Fl+sXbzHhXXI8mGA6ZeCGdp9KM2IkzHYbEQD4D
        eDCWjXXKwMGosc8uPj6WO7ExCgzDYbwwE4tnw+Q3+Cz9h45aQgaUrwbSL6ea/h06T+MVc6
        Ddm9qvLBTg1BS+Dx97hI0TxnXGatboY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-zmKCSHp6MEOVZ-whomMVUg-1; Thu, 03 Mar 2022 14:38:53 -0500
X-MC-Unique: zmKCSHp6MEOVZ-whomMVUg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B9BE1800D50;
        Thu,  3 Mar 2022 19:38:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48D3D5DF2E;
        Thu,  3 Mar 2022 19:38:51 +0000 (UTC)
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
Subject: [PATCH v4 08/30] KVM: x86/mmu: Check for !leaf=>leaf, not PFN change, in TDP MMU SP removal
Date:   Thu,  3 Mar 2022 14:38:20 -0500
Message-Id: <20220303193842.370645-9-pbonzini@redhat.com>
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

Look for a !leaf=>leaf conversion instead of a PFN change when checking
if a SPTE change removed a TDP MMU shadow page.  Convert the PFN check
into a WARN, as KVM should never change the PFN of a shadow page (except
when its being zapped or replaced).

From a purely theoretical perspective, it's not illegal to replace a SP
with a hugepage pointing at the same PFN.  In practice, it's impossible
as that would require mapping guest memory overtop a kernel-allocated SP.
Either way, the check is odd.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-8-seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 79bc48ddb69d..53c7987198b7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -491,9 +491,12 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
-	 * the paging structure.
+	 * the paging structure.  Note the WARN on the PFN changing without the
+	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
+	 * pages are kernel allocations and should never be migrated.
 	 */
-	if (was_present && !was_leaf && (pfn_changed || !is_present))
+	if (was_present && !was_leaf &&
+	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
 }
 
-- 
2.31.1


