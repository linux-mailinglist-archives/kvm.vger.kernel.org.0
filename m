Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C844CC64A
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiCCTl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbiCCTkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D752D1A614D
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ahr/fiGSTrMbHbDr7E8nI7nMuNvsjz26M208s7cL90U=;
        b=TFbm6b7jZBtb9X+wJIXu5a7pdNsHAWqYcFS8OnufziuCYIEXhfcrlTgWTI7ezaI4hUgf3B
        ZN9zmKIbXL/89PWRCokCXQwQGq5XaqhzGcpvbrAYvzTwTX+zX8hzbP55+hKT6RIdBUJddk
        UBn5ZY8CJIn4nl5u6ZOq+m2qBpLRBFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-Hyvb77uAPpC0VYFvx4xz3g-1; Thu, 03 Mar 2022 14:39:19 -0500
X-MC-Unique: Hyvb77uAPpC0VYFvx4xz3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 801AE51DC;
        Thu,  3 Mar 2022 19:39:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D6DA5FC22;
        Thu,  3 Mar 2022 19:39:16 +0000 (UTC)
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
Subject: [PATCH v4 26/30] KVM: x86/mmu: WARN on any attempt to atomically update REMOVED SPTE
Date:   Thu,  3 Mar 2022 14:38:38 -0500
Message-Id: <20220303193842.370645-27-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Disallow calling tdp_mmu_set_spte_atomic() with a REMOVED "old" SPTE.
This solves a conundrum introduced by commit 3255530ab191 ("KVM: x86/mmu:
Automatically update iter->old_spte if cmpxchg fails"); if the helper
doesn't update old_spte in the REMOVED case, then theoretically the
caller could get stuck in an infinite loop as it will fail indefinitely
on the REMOVED SPTE.  E.g. until recently, clear_dirty_gfn_range() didn't
check for a present SPTE and would have spun until getting rescheduled.

In practice, only the page fault path should "create" a new SPTE, all
other paths should only operate on existing, a.k.a. shadow present,
SPTEs.  Now that the page fault path pre-checks for a REMOVED SPTE in all
cases, require all other paths to indirectly pre-check by verifying the
target SPTE is a shadow-present SPTE.

Note, this does not guarantee the actual SPTE isn't REMOVED, nor is that
scenario disallowed.  The invariant is only that the caller mustn't
invoke tdp_mmu_set_spte_atomic() if the SPTE was REMOVED when last
observed by the caller.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220226001546.360188-25-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 89e6eb6640fe..a0e24d260983 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -622,16 +622,15 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	u64 *sptep = rcu_dereference(iter->sptep);
 	u64 old_spte;
 
-	WARN_ON_ONCE(iter->yielded);
-
-	lockdep_assert_held_read(&kvm->mmu_lock);
-
 	/*
-	 * Do not change removed SPTEs. Only the thread that froze the SPTE
-	 * may modify it.
+	 * The caller is responsible for ensuring the old SPTE is not a REMOVED
+	 * SPTE.  KVM should never attempt to zap or manipulate a REMOVED SPTE,
+	 * and pre-checking before inserting a new SPTE is advantageous as it
+	 * avoids unnecessary work.
 	 */
-	if (is_removed_spte(iter->old_spte))
-		return -EBUSY;
+	WARN_ON_ONCE(iter->yielded || is_removed_spte(iter->old_spte));
+
+	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	/*
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
-- 
2.31.1


