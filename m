Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1422E555454
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 21:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358375AbiFVT1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 15:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353265AbiFVT1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 15:27:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC0AB3B3F6
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655926037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGW/FKy2yGTHdwE4DwyvYNvZeSSvbQXgR8p2A1FLlvo=;
        b=FjYSf+W5dTSiI5YyvWqLVjj3jqOPBTnl7Lj1lR/EMB8dgt/jJd2fiPs/YqSvb1Q+ejW/oy
        7v63fky0+Xa4FMbFRuLuX9S3FRmUddu+2PAN96a4QPWnxq5K2IrgDCuGxKWFf5xlA9eeEa
        KdfWFPRUcA5PgP5VKvtbnhcMu3PGWOA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-bkI2lZpMOGGWfvfym1zdlg-1; Wed, 22 Jun 2022 15:27:14 -0400
X-MC-Unique: bkI2lZpMOGGWfvfym1zdlg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82DE980174C;
        Wed, 22 Jun 2022 19:27:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C1A01121314;
        Wed, 22 Jun 2022 19:27:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     maz@kernel.org, anup@brainfault.org, seanjc@google.com,
        bgardon@google.com, peterx@redhat.com, maciej.szmigiero@oracle.com,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, pfeiner@google.com,
        jiangshanlai@gmail.com, dmatlack@google.com
Subject: [PATCH v7 06/23] KVM: x86/mmu: Decompose kvm_mmu_get_page() into separate functions
Date:   Wed, 22 Jun 2022 15:26:53 -0400
Message-Id: <20220622192710.2547152-7-pbonzini@redhat.com>
In-Reply-To: <20220622192710.2547152-1-pbonzini@redhat.com>
References: <20220622192710.2547152-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Decompose kvm_mmu_get_page() into separate helper functions to increase
readability and prepare for allocating shadow pages without a vcpu
pointer.

Specifically, pull the guts of kvm_mmu_get_page() into 2 helper
functions:

kvm_mmu_find_shadow_page() -
  Walks the page hash checking for any existing mmu pages that match the
  given gfn and role.

kvm_mmu_alloc_shadow_page()
  Allocates and initializes an entirely new kvm_mmu_page. This currently
  requries a vcpu pointer for allocation and looking up the memslot but
  that will be removed in a future commit.

No functional change intended.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220516232138.1783324-7-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 52 +++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f4e7978a6c6a..a59fe860da29 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1993,16 +1993,16 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
-static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
+						     gfn_t gfn,
+						     struct hlist_head *sp_list,
+						     union kvm_mmu_page_role role)
 {
-	struct hlist_head *sp_list;
 	struct kvm_mmu_page *sp;
 	int ret;
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
-	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
 			collisions++;
@@ -2027,7 +2027,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 		/* unsync and write-flooding only apply to indirect SPs. */
 		if (sp->role.direct)
-			goto trace_get_page;
+			goto out;
 
 		if (sp->unsync) {
 			/*
@@ -2053,14 +2053,26 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 		__clear_sp_write_flooding_count(sp);
 
-trace_get_page:
-		trace_kvm_mmu_get_page(sp, false);
 		goto out;
 	}
 
+	sp = NULL;
 	++vcpu->kvm->stat.mmu_cache_miss;
 
-	sp = kvm_mmu_alloc_page(vcpu, role.direct);
+out:
+	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+
+	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
+		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
+	return sp;
+}
+
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+						      gfn_t gfn,
+						      struct hlist_head *sp_list,
+						      union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp = kvm_mmu_alloc_page(vcpu, role.direct);
 
 	sp->gfn = gfn;
 	sp->role = role;
@@ -2070,12 +2082,26 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
 			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
 	}
-	trace_kvm_mmu_get_page(sp, true);
-out:
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 
-	if (collisions > vcpu->kvm->stat.max_mmu_page_hash_collisions)
-		vcpu->kvm->stat.max_mmu_page_hash_collisions = collisions;
+	return sp;
+}
+
+static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
+					     union kvm_mmu_page_role role)
+{
+	struct hlist_head *sp_list;
+	struct kvm_mmu_page *sp;
+	bool created = false;
+
+	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
+
+	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
+	if (!sp) {
+		created = true;
+		sp = kvm_mmu_alloc_shadow_page(vcpu, gfn, sp_list, role);
+	}
+
+	trace_kvm_mmu_get_page(sp, created);
 	return sp;
 }
 
-- 
2.31.1


