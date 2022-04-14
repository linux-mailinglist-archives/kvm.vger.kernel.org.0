Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725C1500742
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240611AbiDNHnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240464AbiDNHmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3DBF49F25
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fGx1NqlmPHgaS764h2CsqWVqQ4YK5QPPrGStgAvJ6cM=;
        b=PMsvDXwcWFeI+UkZz+23fpOzX0cwq6BXBQPF6XfOYe2yRNdbO35gB4LmTJtcORKBrecAnW
        VB7pKLnC7GfpA5LJYseCLaG7lsDKXQz3fpFUAJCsn1mUfR1GV7Z+6aUVB0C9P5zA47k0GB
        PbjX1nBxKCMz1UesNlJKXQgqOa04Xtw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-0PfYkateM8WahsqZCqsX_Q-1; Thu, 14 Apr 2022 03:40:04 -0400
X-MC-Unique: 0PfYkateM8WahsqZCqsX_Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16D7580418F;
        Thu, 14 Apr 2022 07:40:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF236C28109;
        Thu, 14 Apr 2022 07:40:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 18/22] KVM: x86/mmu: simplify and/or inline computation of shadow MMU roles
Date:   Thu, 14 Apr 2022 03:39:56 -0400
Message-Id: <20220414074000.31438-19-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shadow MMUs compute their role from cpu_role.base, simply by adjusting
the root level.  It's one line of code, so do not place it in a separate
function.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 65 ++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 33827d1e3d5a..f22aa9970356 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -231,6 +231,7 @@ BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
 BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
+BUILD_MMU_ROLE_ACCESSOR(ext,  efer, lma);
 
 static inline bool is_cr0_pg(struct kvm_mmu *mmu)
 {
@@ -4796,33 +4797,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	reset_tdp_shadow_zero_bits_mask(context);
 }
 
-static union kvm_mmu_page_role
-kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_cpu_role cpu_role)
-{
-	union kvm_mmu_page_role role;
-
-	role = cpu_role.base;
-	if (!cpu_role.ext.efer_lma)
-		role.level = PT32E_ROOT_LEVEL;
-	else if (cpu_role.ext.cr4_la57)
-		role.level = PT64_ROOT_5LEVEL;
-	else
-		role.level = PT64_ROOT_4LEVEL;
-
-	/*
-	 * KVM forces EFER.NX=1 when TDP is disabled, reflect it in the MMU role.
-	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
-	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
-	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
-	 * The iTLB multi-hit workaround can be toggled at any time, so assume
-	 * NX can be used by any non-nested shadow MMU to avoid having to reset
-	 * MMU contexts.
-	 */
-	role.efer_nx = true;
-	return role;
-}
-
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 				    union kvm_cpu_role cpu_role,
 				    union kvm_mmu_page_role root_role)
@@ -4853,22 +4827,25 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_cpu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
-	union kvm_mmu_page_role root_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_role);
+	union kvm_mmu_page_role root_role;
 
-	shadow_mmu_init_context(vcpu, context, cpu_role, root_role);
-}
+	root_role = cpu_role.base;
 
-static union kvm_mmu_page_role
-kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_cpu_role cpu_role)
-{
-	union kvm_mmu_page_role role;
+	/* KVM uses PAE paging whenever the guest isn't using 64-bit paging. */
+	root_role.level = max_t(u32, root_role.level, PT32E_ROOT_LEVEL);
 
-	WARN_ON_ONCE(cpu_role.base.direct);
-	role = cpu_role.base;
-	role.level = kvm_mmu_get_tdp_level(vcpu);
-	return role;
+	/*
+	 * KVM forces EFER.NX=1 when TDP is disabled, reflect it in the MMU role.
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.
+	 */
+	root_role.efer_nx = true;
+
+	shadow_mmu_init_context(vcpu, context, cpu_role, root_role);
 }
 
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
@@ -4881,7 +4858,13 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.efer = efer,
 	};
 	union kvm_cpu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
-	union kvm_mmu_page_role root_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_role);
+	union kvm_mmu_page_role root_role;
+
+	/* NPT requires CR0.PG=1. */
+	WARN_ON_ONCE(cpu_role.base.direct);
+
+	root_role = cpu_role.base;
+	root_role.level = kvm_mmu_get_tdp_level(vcpu);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, root_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
-- 
2.31.1


