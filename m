Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D32E4AF768
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237723AbiBIRA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237643AbiBIRAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:00:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8A5AC05CB86
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UmiLwad0yNHqYcNsluzF3JRoNRWaXkEyVI1t62KrVok=;
        b=OiD7WnRIDmh4DeDoLG2p0w/9q7nJuo6lApc2+3E3e1OF4wDPcGF9PFoIMufUPfrt7xqOAD
        PJ8ZxuLYnPyFx5IxjHOaMPB+IQCQ/u45NO/QeOSVeWlaaMPbCLj5az6wJyw5CW0peCH/K6
        feuP+b1eQU8e8AnDfm2RrpQQidCgObY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-U5WUf8sOO3O9cGvcDwstzQ-1; Wed, 09 Feb 2022 12:00:55 -0500
X-MC-Unique: U5WUf8sOO3O9cGvcDwstzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0EBB101F7A1;
        Wed,  9 Feb 2022 17:00:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 754F47CD66;
        Wed,  9 Feb 2022 17:00:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com
Subject: [PATCH 08/12] KVM: MMU: do not consult levels when freeing roots
Date:   Wed,  9 Feb 2022 12:00:16 -0500
Message-Id: <20220209170020.1775368-9-pbonzini@redhat.com>
In-Reply-To: <20220209170020.1775368-1-pbonzini@redhat.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, PGD caching requires a complicated dance of first computing
the MMU role and passing it to __kvm_mmu_new_pgd, and then separately calling
kvm_init_mmu.

Part of this is due to kvm_mmu_free_roots using mmu->root_level and
mmu->shadow_root_level to distinguish whether the page table uses a single
root or 4 PAE roots.  Because kvm_init_mmu can overwrite mmu->root_level,
kvm_mmu_free_roots must be called before kvm_init_mmu.

However, even after kvm_init_mmu there is a way to detect whether the page table
has a single root or four, because the pae_root does not have an associated
struct kvm_mmu_page.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3c3f597ea00d..95d0fa0bb876 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3219,12 +3219,15 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	struct kvm *kvm = vcpu->kvm;
 	int i;
 	LIST_HEAD(invalid_list);
-	bool free_active_root = roots_to_free & KVM_MMU_ROOT_CURRENT;
+	bool free_active_root;
 
 	BUILD_BUG_ON(KVM_MMU_NUM_PREV_ROOTS >= BITS_PER_LONG);
 
 	/* Before acquiring the MMU lock, see if we need to do any real work. */
-	if (!(free_active_root && VALID_PAGE(mmu->root.hpa))) {
+	free_active_root = (roots_to_free & KVM_MMU_ROOT_CURRENT)
+		&& VALID_PAGE(mmu->root.hpa);
+
+	if (!free_active_root) {
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			if ((roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) &&
 			    VALID_PAGE(mmu->prev_roots[i].hpa))
@@ -3242,8 +3245,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 					   &invalid_list);
 
 	if (free_active_root) {
-		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
-		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
+		if (to_shadow_page(mmu->root.hpa)) {
 			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
 		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i) {
-- 
2.31.1


