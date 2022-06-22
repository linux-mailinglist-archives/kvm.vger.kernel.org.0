Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468F9555468
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 21:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358720AbiFVT1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 15:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbiFVT12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 15:27:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B284E3FBF8
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655926042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xlRQ8mEQ9YvjZnUl++QqeZB4cfPsCz6OaymdUv9rICk=;
        b=AztjexBDr3FJhmToWc4vhwgTs1bUw1XNdoLnY0omhwavHN183XMYPdaqrUrpxMRZNtnlZt
        7TJtSSQLUSQLA1fbMvIA3x+qPhFMxinhyYZJXv5xp8Llt6tEW8uDcHR5B1hx6LzEDV4Cyf
        5X4Ca+MYv+CcuuT4MsOvpKnLSXIiQKg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-ZKp3q13APJ6c8yNa5GJx3Q-1; Wed, 22 Jun 2022 15:27:17 -0400
X-MC-Unique: ZKp3q13APJ6c8yNa5GJx3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 697B518A6580;
        Wed, 22 Jun 2022 19:27:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0554141510C;
        Wed, 22 Jun 2022 19:27:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     maz@kernel.org, anup@brainfault.org, seanjc@google.com,
        bgardon@google.com, peterx@redhat.com, maciej.szmigiero@oracle.com,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, pfeiner@google.com,
        jiangshanlai@gmail.com, dmatlack@google.com
Subject: [PATCH v7 13/23] KVM: x86/mmu: Allow NULL @vcpu in kvm_mmu_find_shadow_page()
Date:   Wed, 22 Jun 2022 15:27:00 -0400
Message-Id: <20220622192710.2547152-14-pbonzini@redhat.com>
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

Allow @vcpu to be NULL in kvm_mmu_find_shadow_page() (and its only
caller __kvm_mmu_get_shadow_page()). @vcpu is only required to sync
indirect shadow pages, so it's safe to pass in NULL when looking up
direct shadow pages.

This will be used for doing eager page splitting, which allocates direct
shadow pages from the context of a VM ioctl without access to a vCPU
pointer.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220516232138.1783324-14-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 88b3f3c2c8b1..a7748c5a2385 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1975,6 +1975,12 @@ static void clear_sp_write_flooding_count(u64 *spte)
 	__clear_sp_write_flooding_count(sptep_to_sp(spte));
 }
 
+/*
+ * The vCPU is required when finding indirect shadow pages; the shadow
+ * page may already exist and syncing it needs the vCPU pointer in
+ * order to read guest page tables.  Direct shadow pages are never
+ * unsync, thus @vcpu can be NULL if @role.direct is true.
+ */
 static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 						     struct kvm_vcpu *vcpu,
 						     gfn_t gfn,
@@ -2013,6 +2019,9 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			goto out;
 
 		if (sp->unsync) {
+			if (KVM_BUG_ON(!vcpu, kvm))
+				break;
+
 			/*
 			 * The page is good, but is stale.  kvm_sync_page does
 			 * get the latest guest state, but (unlike mmu_unsync_children)
@@ -2090,6 +2099,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	return sp;
 }
 
+/* Note, @vcpu may be NULL if @role.direct is true; see kvm_mmu_find_shadow_page. */
 static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 						      struct kvm_vcpu *vcpu,
 						      struct shadow_page_caches *caches,
-- 
2.31.1


