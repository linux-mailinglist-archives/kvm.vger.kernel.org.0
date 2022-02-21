Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC974BE58C
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380313AbiBUQYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:24:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380249AbiBUQXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CB1922717D
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tIxBOIs9YqDKt+bVtp2eN+6o6aowPpvnga3h8cz9ah4=;
        b=ZmjzaGhZ0RbIBEOpaZhyLBrV7x5IDjkbAnq6A521ar2xhI4Bq8R4SPqMO3iY7tjHVuDf6a
        qJOxw+YY8bQcz44tgIDnWaFQJ+Aj9JHHyicxl2c0XrAQw7wdU3Crnku+ykLcPmQ/n3oMTD
        UI97BL8URwLCHeZJK+e48WYHjn9Bw84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-7NMPbX9jMCqH-jmTpwH3tw-1; Mon, 21 Feb 2022 11:22:53 -0500
X-MC-Unique: 7NMPbX9jMCqH-jmTpwH3tw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 688F41006AA0;
        Mon, 21 Feb 2022 16:22:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09E9D7611B;
        Mon, 21 Feb 2022 16:22:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 16/25] KVM: x86/mmu: rename kvm_mmu_role union
Date:   Mon, 21 Feb 2022 11:22:34 -0500
Message-Id: <20220221162243.683208-17-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is quite confusing that the "full" union is called kvm_mmu_role
but is used for the "cpu_mode" field of struct kvm_mmu.  Rename it
to kvm_mmu_paging_mode.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++---
 arch/x86/kvm/mmu/mmu.c          | 28 ++++++++++++++--------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b7d7c4f31730..3dbe0be075f5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -276,7 +276,7 @@ struct kvm_kernel_irq_routing_entry;
 /*
  * kvm_mmu_page_role tracks the properties of a shadow page (where shadow page
  * also includes TDP pages) to determine whether or not a page can be used in
- * the given MMU context.  This is a subset of the overall kvm_mmu_role to
+ * the given MMU context.  This is a subset of the overall kvm_mmu_paging_mode to
  * minimize the size of kvm_memory_slot.arch.gfn_track, i.e. allows allocating
  * 2 bytes per gfn instead of 4 bytes per gfn.
  *
@@ -373,7 +373,7 @@ union kvm_mmu_extended_role {
 	};
 };
 
-union kvm_mmu_role {
+union kvm_mmu_paging_mode {
 	u64 as_u64;
 	struct {
 		union kvm_mmu_page_role base;
@@ -433,7 +433,7 @@ struct kvm_mmu {
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
-	union kvm_mmu_role cpu_mode;
+	union kvm_mmu_paging_mode cpu_mode;
 	union kvm_mmu_page_role root_role;
 	u8 root_level;
 	u8 shadow_root_level;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 35907badb6ce..61499fd7d017 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4658,10 +4658,10 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->direct_map = false;
 }
 
-static union kvm_mmu_role
+static union kvm_mmu_paging_mode
 kvm_calc_cpu_mode(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role role = {0};
+	union kvm_mmu_paging_mode role = {0};
 
 	role.base.access = ACC_ALL;
 	role.base.smm = is_smm(vcpu);
@@ -4712,7 +4712,7 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_page_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				union kvm_mmu_role cpu_mode)
+				union kvm_mmu_paging_mode cpu_mode)
 {
 	union kvm_mmu_page_role role = {0};
 
@@ -4733,7 +4733,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 			     const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
+	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
 	union kvm_mmu_page_role root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_mode);
 
 	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
@@ -4765,7 +4765,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_page_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_mmu_role role)
+				   union kvm_mmu_paging_mode role)
 {
 	if (!role.ext.efer_lma)
 		role.base.level = PT32E_ROOT_LEVEL;
@@ -4788,7 +4788,7 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    union kvm_mmu_role cpu_mode,
+				    union kvm_mmu_paging_mode cpu_mode,
 				    union kvm_mmu_page_role root_role)
 {
 	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
@@ -4816,7 +4816,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 				const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
+	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
 	union kvm_mmu_page_role root_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_mode);
 
@@ -4825,7 +4825,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_page_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_mmu_role role)
+				   union kvm_mmu_paging_mode role)
 {
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	return role.base;
@@ -4840,7 +4840,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.cr4 = cr4 & ~X86_CR4_PKE,
 		.efer = efer,
 	};
-	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
+	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
 	union kvm_mmu_page_role root_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_mode);
 
 	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
@@ -4848,11 +4848,11 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
-static union kvm_mmu_role
+static union kvm_mmu_paging_mode
 kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 				   bool execonly, u8 level)
 {
-	union kvm_mmu_role role = {0};
+	union kvm_mmu_paging_mode role = {0};
 
 	/*
 	 * KVM does not support SMM transfer monitors, and consequently does not
@@ -4879,7 +4879,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 {
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	u8 level = vmx_eptp_page_walk_level(new_eptp);
-	union kvm_mmu_role new_mode =
+	union kvm_mmu_paging_mode new_mode =
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
@@ -4920,7 +4920,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role new_mode = kvm_calc_cpu_mode(vcpu, regs);
+	union kvm_mmu_paging_mode new_mode = kvm_calc_cpu_mode(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_mode.as_u64 == g_context->cpu_mode.as_u64)
@@ -6116,7 +6116,7 @@ int kvm_mmu_module_init(void)
 	 */
 	BUILD_BUG_ON(sizeof(union kvm_mmu_page_role) != sizeof(u32));
 	BUILD_BUG_ON(sizeof(union kvm_mmu_extended_role) != sizeof(u32));
-	BUILD_BUG_ON(sizeof(union kvm_mmu_role) != sizeof(u64));
+	BUILD_BUG_ON(sizeof(union kvm_mmu_paging_mode) != sizeof(u64));
 
 	kvm_mmu_reset_all_pte_masks();
 
-- 
2.31.1


