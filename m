Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050617B2259
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjI1Qaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjI1Qar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:30:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24BA1A3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695918603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kglJ7MDXIf3EPYGcUm7QWoca/YSI3KryqQDz+PiB8OQ=;
        b=KkgdaEGYeHedaJAEoq4sR1e6NHHyPVwUa/K8fBV2q226QEkYhKMUdM2y5xRr84qRtY4cW8
        9qUB9yUz/RXovXmsZl3hj73BZ5733cYE5c7I6X0L0N3BaUyOGIRbeuJmXK9P4aqetYfE/o
        c7SC1kWLwJ2l+6jiVRncrIoPsZxDdZA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-DlzphYcnOs-th9PdQp_fug-1; Thu, 28 Sep 2023 12:30:01 -0400
X-MC-Unique: DlzphYcnOs-th9PdQp_fug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E845280BC9D;
        Thu, 28 Sep 2023 16:30:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6639C140E969;
        Thu, 28 Sep 2023 16:30:00 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86/mmu: always take tdp_mmu_pages_lock
Date:   Thu, 28 Sep 2023 12:29:59 -0400
Message-Id: <20230928162959.1514661-4-pbonzini@redhat.com>
In-Reply-To: <20230928162959.1514661-1-pbonzini@redhat.com>
References: <20230928162959.1514661-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is cheap to take tdp_mmu_pages_lock in all write-side critical sections.
We already do it all the time when zapping with read_lock(), so it is not
a problem to do it from the kvm_tdp_mmu_zap_all() path (aka
kvm_arch_flush_shadow_all(), aka VM destruction and MMU notifier release).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/locking.rst |  6 ++----
 arch/x86/kvm/mmu/tdp_mmu.c         | 17 ++++++-----------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 3a034db5e55f..381eb0e7d947 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -43,10 +43,8 @@ On x86:
 
 - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock and kvm->arch.xen.xen_lock
 
-- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock and
-  kvm->arch.mmu_unsync_pages_lock are taken inside kvm->arch.mmu_lock, and
-  cannot be taken without already holding kvm->arch.mmu_lock (typically with
-  ``read_lock`` for the TDP MMU, thus the need for additional spinlocks).
+- kvm->arch.mmu_lock is an rwlock and is taken outside
+  kvm->arch.tdp_mmu_pages_lock and kvm->arch.mmu_unsync_pages_lock
 
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b9abfa78808a..f61bc842067f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -285,24 +285,19 @@ static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
  *	    the MMU lock and the operation must synchronize with other
  *	    threads that might be adding or removing pages.
  */
-static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
-			      bool shared)
+static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
+	lockdep_assert_held(&kvm->mmu_lock);
+
 	tdp_unaccount_mmu_page(kvm, sp);
 
 	if (!sp->nx_huge_page_disallowed)
 		return;
 
-	if (shared)
-		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	else
-		lockdep_assert_held_write(&kvm->mmu_lock);
-
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	sp->nx_huge_page_disallowed = false;
 	untrack_possible_nx_huge_page(kvm, sp);
-
-	if (shared)
-		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
 /**
@@ -331,7 +326,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 
 	trace_kvm_mmu_prepare_zap_page(sp);
 
-	tdp_mmu_unlink_sp(kvm, sp, shared);
+	tdp_mmu_unlink_sp(kvm, sp);
 
 	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
 		tdp_ptep_t sptep = pt + i;
-- 
2.39.1

