Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7384CC63D
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbiCCTkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbiCCTj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D32E918A7A2
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dvih/7ReoIrowVnu0jh9AfQzzh3B1h/nlGrRX+e2c8E=;
        b=NGCPwQps88MMYGfNypK5mN66SrIOGoEe/H8wgkfpNsQ2twsJVmKMuLZMVKFz1H9uMwtO9H
        VWkDXCfY4tnre6G3ny4rcWfBgdBhFXNysYJSpEDoF5RkJUGFTDcsuo3IXc/Z/dVVN7cLiK
        hmZdJKz5WJZE987Dq/NLE/MfmJyhY3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-zu3c9gvTPduh0ZJJsoFwKA-1; Thu, 03 Mar 2022 14:38:56 -0500
X-MC-Unique: zu3c9gvTPduh0ZJJsoFwKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EC7951DC;
        Thu,  3 Mar 2022 19:38:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A2E4ADDE;
        Thu,  3 Mar 2022 19:38:53 +0000 (UTC)
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
Subject: [PATCH v4 10/30] KVM: x86/mmu: Drop RCU after processing each root in MMU notifier hooks
Date:   Thu,  3 Mar 2022 14:38:22 -0500
Message-Id: <20220303193842.370645-11-pbonzini@redhat.com>
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

Drop RCU protection after processing each root when handling MMU notifier
hooks that aren't the "unmap" path, i.e. aren't zapping.  Temporarily
drop RCU to let RCU do its thing between roots, and to make it clear that
there's no special behavior that relies on holding RCU across all roots.

Currently, the RCU protection is completely superficial, it's necessary
only to make rcu_dereference() of SPTE pointers happy.  A future patch
will rely on holding RCU as a proxy for vCPUs in the guest, e.g. to
ensure shadow pages aren't freed before all vCPUs do a TLB flush (or
rather, acknowledge the need for a flush), but in that case RCU needs to
be held until the flush is complete if and only if the flush is needed
because a shadow page may have been removed.  And except for the "unmap"
path, MMU notifier events cannot remove SPs (don't toggle PRESENT bit,
and can't change the PFN for a SP).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-10-seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9b1d64468d95..22b0c03b673b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1123,18 +1123,18 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	struct tdp_iter iter;
 	bool ret = false;
 
-	rcu_read_lock();
-
 	/*
 	 * Don't support rescheduling, none of the MMU notifiers that funnel
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		rcu_read_lock();
+
 		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
 			ret |= handler(kvm, &iter, range);
-	}
 
-	rcu_read_unlock();
+		rcu_read_unlock();
+	}
 
 	return ret;
 }
-- 
2.31.1


