Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68C54CC629
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiCCTjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbiCCTjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 001EC49F15
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nr512R7Czm6dxfKYEDi3K/yuSNvc5j851tfW+urize4=;
        b=ZpWvfulX98Nk1rTl5sYNRm4RhdiCQPfWkTObSouCaM9Q5mll+JdjHwMlI6ggqYvzJOKw+u
        KbVeE3ZbaRW+9q55BhtP5rujkofdxVJqwQ98NZpmPU8Bvzn8Ai7JfyXx/++MtpnbW85+GR
        8Jf7yttpRVFKhMiFQIASyFTPNQCZaWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-L9ZT5b79NKyva9HnzsPA5A-1; Thu, 03 Mar 2022 14:38:50 -0500
X-MC-Unique: L9ZT5b79NKyva9HnzsPA5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5CC9B1800D50;
        Thu,  3 Mar 2022 19:38:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AD525DF2E;
        Thu,  3 Mar 2022 19:38:47 +0000 (UTC)
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
Subject: [PATCH v4 04/30] KVM: x86/mmu: Document that zapping invalidated roots doesn't need to flush
Date:   Thu,  3 Mar 2022 14:38:16 -0500
Message-Id: <20220303193842.370645-5-pbonzini@redhat.com>
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

Remove the misleading flush "handling" when zapping invalidated TDP MMU
roots, and document that flushing is unnecessary for all flavors of MMUs
when zapping invalid/obsolete roots/pages.  The "handling" in the TDP MMU
is dead code, as zap_gfn_range() is called with shared=true, in which
case it will never return true due to the flushing being handled by
tdp_mmu_zap_spte_atomic().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     | 10 +++++++---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++++++++-----
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9a6df2d02777..8408d7db8d2a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5674,9 +5674,13 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 	}
 
 	/*
-	 * Trigger a remote TLB flush before freeing the page tables to ensure
-	 * KVM is not in the middle of a lockless shadow page table walk, which
-	 * may reference the pages.
+	 * Kick all vCPUs (via remote TLB flush) before freeing the page tables
+	 * to ensure KVM is not in the middle of a lockless shadow page table
+	 * walk, which may reference the pages.  The remote TLB flush itself is
+	 * not required and is simply a convenient way to kick vCPUs as needed.
+	 * KVM performs a local TLB flush when allocating a new root (see
+	 * kvm_mmu_load()), and the reload in the caller ensure no vCPUs are
+	 * running with an obsolete MMU.
 	 */
 	kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 921fa386df99..2ce6915b70fe 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -851,7 +851,6 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
 	struct kvm_mmu_page *next_root;
 	struct kvm_mmu_page *root;
-	bool flush = false;
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
@@ -864,7 +863,16 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 		rcu_read_unlock();
 
-		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
+		/*
+		 * A TLB flush is unnecessary, invalidated roots are guaranteed
+		 * to be unreachable by the guest (see kvm_tdp_mmu_put_root()
+		 * for more details), and unlike the legacy MMU, no vCPU kick
+		 * is needed to play nice with lockless shadow walks as the TDP
+		 * MMU protects its paging structures via RCU.  Note, zapping
+		 * will still flush on yield, but that's a minor performance
+		 * blip and not a functional issue.
+		 */
+		(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, true);
 
 		/*
 		 * Put the reference acquired in
@@ -878,9 +886,6 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 	}
 
 	rcu_read_unlock();
-
-	if (flush)
-		kvm_flush_remote_tlbs(kvm);
 }
 
 /*
-- 
2.31.1


