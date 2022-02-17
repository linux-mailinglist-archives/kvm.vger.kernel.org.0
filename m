Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832EB4BAB75
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244284AbiBQVEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243887AbiBQVEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 064C315DDE6
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=greicK0A3/Bhl1WwndRbJf57VmhSiHQc1qeb/4OzOEo=;
        b=KL5OD8xLjQ9HFQDnSPJh70IpFR9Qlka8OCCQnysvO/P2Au+MWhNZANhm8QZMsaOq5ZAl+Y
        0eaUix3VeOS1LmYRW4jeBcrapA+qA7eukpDsVup8Cd+crLoYbmWWyE7yyai1VDqJKoox27
        FIMN7C8IaOqENGNVAaASa1BcatXa1Z8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-pbi92wF3N26i6kL4ofPfZQ-1; Thu, 17 Feb 2022 16:03:45 -0500
X-MC-Unique: pbi92wF3N26i6kL4ofPfZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEBFC1800D50;
        Thu, 17 Feb 2022 21:03:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4485D46985;
        Thu, 17 Feb 2022 21:03:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH v2 07/18] KVM: x86/mmu: Do not use guest root level in audit
Date:   Thu, 17 Feb 2022 16:03:29 -0500
Message-Id: <20220217210340.312449-8-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Walking from the root page of the shadow page table should start with
the level of the shadow page table: shadow_root_level; do not
consult the level in order to check whether the root has a single
root or uses pae_root, either, and use to_shadow_page instead.

Also tweak audit_mappings(), where the current walking level is more
valuable to print.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu_audit.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
index 3e5d62a25350..d1c59aed0465 100644
--- a/arch/x86/kvm/mmu/mmu_audit.c
+++ b/arch/x86/kvm/mmu/mmu_audit.c
@@ -53,17 +53,16 @@ static void __mmu_spte_walk(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 {
-	int i;
+	hpa_t root = vcpu->arch.mmu->root.hpa;
 	struct kvm_mmu_page *sp;
+	int i;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
+	if (!VALID_PAGE(root))
 		return;
 
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
-		hpa_t root = vcpu->arch.mmu->root.hpa;
-
-		sp = to_shadow_page(root);
-		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->root_level);
+	sp = to_shadow_page(root);
+	if (sp) {
+		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->shadow_root_level);
 		return;
 	}
 
@@ -119,8 +118,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
 	hpa =  pfn << PAGE_SHIFT;
 	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
 		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
-			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
-			     hpa, *sptep);
+			     "ent %llxn", level, pfn, hpa, *sptep);
 }
 
 static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
-- 
2.31.1


