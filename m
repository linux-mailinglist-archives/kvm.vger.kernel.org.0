Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6764BAB89
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244745AbiBQVE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243928AbiBQVEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86D06164D03
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9EeiJmrNVxBypIUwOEl5IfkA+kYU2Kz2k4uxn3ETf0w=;
        b=ZQSBonePcLYT0asa60BupySCmBfAI1gKvLDziUCi5exIFDMQLuPMeMl+TJ3CcNqM+tcLyr
        VVXFvfm8skuPurpSpWw6BNUNStF0DyMAdYij12/zw2OYqKNs6YwCHdZnYD2lhfzEKi1kQu
        p7Ws60WBbaKrCl6hsNn8eDjlZ1QYh5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-B0NOLb-tO5uPcypCRKhefw-1; Thu, 17 Feb 2022 16:03:45 -0500
X-MC-Unique: B0NOLb-tO5uPcypCRKhefw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29F671006AA4;
        Thu, 17 Feb 2022 21:03:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0D2346982;
        Thu, 17 Feb 2022 21:03:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 06/18] KVM: x86/mmu: do not consult levels when freeing roots
Date:   Thu, 17 Feb 2022 16:03:28 -0500
Message-Id: <20220217210340.312449-7-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, PGD caching requires a complicated dance of first computing
the MMU role and passing it to __kvm_mmu_new_pgd(), and then separately calling
kvm_init_mmu().

Part of this is due to kvm_mmu_free_roots using mmu->root_level and
mmu->shadow_root_level to distinguish whether the page table uses a single
root or 4 PAE roots.  Because kvm_init_mmu() can overwrite mmu->root_level,
kvm_mmu_free_roots() must be called before kvm_init_mmu().

However, even after kvm_init_mmu() there is a way to detect whether the
page table may hold PAE roots, as root.hpa isn't backed by a shadow when
it points at PAE roots.  Using this method results in simpler code, and
is one less obstacle in moving all calls to __kvm_mmu_new_pgd() after the
MMU has been initialized.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a478667d7561..e1578f71feae 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3240,12 +3240,15 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
@@ -3263,8 +3266,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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


