Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931EE55546A
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 21:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358816AbiFVT15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 15:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241717AbiFVT12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 15:27:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C46513FBFD
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655926042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9oMq4GLRZUa/l4xqxYx4J3Z85ock88+SpI4Xe+x2Ml4=;
        b=G55b4OrZv0v7l2RKavejY0arb7dfkEGmHUxfUgtPFeItyztLyGHA0Es+b+Qrrv90rypfZi
        ulCOpj+qZE1coAIrsR0Nq4DMnGCO9IAxPA2bWsoO1KFm2TdlpJfJMlaniIvRNy4ilVqewd
        d//oS8WM9UefvkF115qmxvSYEWvwAOA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-AJ9guQqgMJSsIz3c33Fhrg-1; Wed, 22 Jun 2022 15:27:16 -0400
X-MC-Unique: AJ9guQqgMJSsIz3c33Fhrg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E89713C11726;
        Wed, 22 Jun 2022 19:27:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93D61141510C;
        Wed, 22 Jun 2022 19:27:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     maz@kernel.org, anup@brainfault.org, seanjc@google.com,
        bgardon@google.com, peterx@redhat.com, maciej.szmigiero@oracle.com,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, pfeiner@google.com,
        jiangshanlai@gmail.com, dmatlack@google.com
Subject: [PATCH v7 12/23] KVM: x86/mmu: Pass kvm pointer separately from vcpu to kvm_mmu_find_shadow_page()
Date:   Wed, 22 Jun 2022 15:26:59 -0400
Message-Id: <20220622192710.2547152-13-pbonzini@redhat.com>
In-Reply-To: <20220622192710.2547152-1-pbonzini@redhat.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Get the kvm pointer from the caller, rather than deriving it from
vcpu->kvm, and plumb the kvm pointer all the way from
kvm_mmu_get_shadow_page(). With this change in place, the vcpu pointer
is only needed to sync indirect shadow pages. In other words,
__kvm_mmu_get_shadow_page() can now be used to get *direct* shadow pages
without a vcpu pointer. This enables eager page splitting, which needs
to allocate direct shadow pages during VM ioctls.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220516232138.1783324-13-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c5a88e8d1b53..88b3f3c2c8b1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1975,7 +1975,8 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
+						     struct kvm_vcpu *vcpu,
 						     gfn_t gfn,
 						     struct hlist_head *sp_list,
 						     union kvm_mmu_page_role role)
@@ -1985,7 +1986,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
-	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
+	for_each_valid_sp(kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
 			collisions++;
 			continue;
@@ -2002,7 +2003,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 			 * upper-level page will be write-protected.
 			 */
 			if (role.level > PG_LEVEL_4K && sp->unsync)
-				kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
+				kvm_mmu_prepare_zap_page(kvm, sp,
 							 &invalid_list);
 			continue;
 		}
@@ -2030,7 +2031,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 
 			WARN_ON(!list_empty(&invalid_list));
 			if (ret > 0)
-				kvm_flush_remote_tlbs(vcpu->kvm);
+				kvm_flush_remote_tlbs(kvm);
 		}
 
 		__clear_sp_write_flooding_count(sp);
@@ -2039,13 +2040,13 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
 	}
 
 	sp = NULL;
-	++vcpu->kvm->stat.mmu_cache_miss;
+	++kvm->stat.mmu_cache_miss;
 
 out:
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
-		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
+	if (collisions > kvm->stat.max_mmu_page_hash_collisions)
+		kvm->stat.max_mmu_page_hash_collisions = collisions;
 	return sp;
 }
 
@@ -2089,7 +2090,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	return sp;
 }
 
-static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
+						      struct kvm_vcpu *vcpu,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      union kvm_mmu_page_role role)
@@ -2098,12 +2100,12 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	struct kvm_mmu_page *sp;
 	bool created = false;
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+	sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 
-	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
+	sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_alloc_shadow_page(vcpu->kvm, caches, gfn, sp_list, role);
+		sp = kvm_mmu_alloc_shadow_page(kvm, caches, gfn, sp_list, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
@@ -2120,7 +2122,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 		.gfn_array_cache = &vcpu->arch.mmu_gfn_array_cache,
 	};
 
-	return __kvm_mmu_get_shadow_page(vcpu, &caches, gfn, role);
+	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
 }
 
 static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, unsigned int access)
-- 
2.31.1


