Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED0A50074D
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240588AbiDNHnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240487AbiDNHmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41B8956C22
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6W0jJ8VdTbxWN4De3uGlaS+0Uv/tBAivAEXdHTu3Sa8=;
        b=CM4jHQHF7FsWpDqywZEaOZ4LFDt6Ts6hvg1UJVxFCMsWMP93d+/jKdC205xQdPBgzUKQXt
        yLLUgarjCIN5/LfC2ZKVv6834HRBJhB0wr1s5ht+SiW4pvc6jsAaY31E+AIgT7r3NPFCCy
        01Uavy05bp9UyPFqPDUa1XI3wc5mUFo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-2va3GMacPDKOhjFRl1cAAA-1; Thu, 14 Apr 2022 03:40:04 -0400
X-MC-Unique: 2va3GMacPDKOhjFRl1cAAA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A075F811E76;
        Thu, 14 Apr 2022 07:40:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 844ACC28109;
        Thu, 14 Apr 2022 07:40:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 15/22] KVM: x86/mmu: rename kvm_mmu_role union
Date:   Thu, 14 Apr 2022 03:39:53 -0400
Message-Id: <20220414074000.31438-16-pbonzini@redhat.com>
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

It is quite confusing that the "full" union is called kvm_mmu_role
but is used for the "cpu_role" field of struct kvm_mmu.  Rename it
to kvm_cpu_role.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++---
 arch/x86/kvm/mmu/mmu.c          | 28 ++++++++++++++--------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c81221d03a1b..6bc5550ae530 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -281,7 +281,7 @@ struct kvm_kernel_irq_routing_entry;
 /*
  * kvm_mmu_page_role tracks the properties of a shadow page (where shadow page
  * also includes TDP pages) to determine whether or not a page can be used in
- * the given MMU context.  This is a subset of the overall kvm_mmu_role to
+ * the given MMU context.  This is a subset of the overall kvm_cpu_role to
  * minimize the size of kvm_memory_slot.arch.gfn_track, i.e. allows allocating
  * 2 bytes per gfn instead of 4 bytes per gfn.
  *
@@ -378,7 +378,7 @@ union kvm_mmu_extended_role {
 	};
 };
 
-union kvm_mmu_role {
+union kvm_cpu_role {
 	u64 as_u64;
 	struct {
 		union kvm_mmu_page_role base;
@@ -438,7 +438,7 @@ struct kvm_mmu {
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
-	union kvm_mmu_role cpu_role;
+	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
 	u8 root_level;
 	u8 shadow_root_level;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 13eb2d40e0a3..483a3761db81 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4683,10 +4683,10 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->direct_map = false;
 }
 
-static union kvm_mmu_role
+static union kvm_cpu_role
 kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role role = {0};
+	union kvm_cpu_role role = {0};
 
 	role.base.access = ACC_ALL;
 	role.base.smm = is_smm(vcpu);
@@ -4740,7 +4740,7 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_page_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				union kvm_mmu_role cpu_role)
+				union kvm_cpu_role cpu_role)
 {
 	union kvm_mmu_page_role role = {0};
 
@@ -4761,7 +4761,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 			     const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
+	union kvm_cpu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_page_role root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_role);
 
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
@@ -4793,7 +4793,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_page_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_mmu_role cpu_role)
+				   union kvm_cpu_role cpu_role)
 {
 	union kvm_mmu_page_role role;
 
@@ -4819,7 +4819,7 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    union kvm_mmu_role cpu_role,
+				    union kvm_cpu_role cpu_role,
 				    union kvm_mmu_page_role root_role)
 {
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
@@ -4847,7 +4847,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 				const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
+	union kvm_cpu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_page_role root_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_role);
 
@@ -4856,7 +4856,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_page_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_mmu_role cpu_role)
+				   union kvm_cpu_role cpu_role)
 {
 	union kvm_mmu_page_role role;
 
@@ -4875,7 +4875,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.cr4 = cr4 & ~X86_CR4_PKE,
 		.efer = efer,
 	};
-	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
+	union kvm_cpu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
 	union kvm_mmu_page_role root_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_role);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, root_role);
@@ -4883,11 +4883,11 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
-static union kvm_mmu_role
+static union kvm_cpu_role
 kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 				   bool execonly, u8 level)
 {
-	union kvm_mmu_role role = {0};
+	union kvm_cpu_role role = {0};
 
 	/*
 	 * KVM does not support SMM transfer monitors, and consequently does not
@@ -4914,7 +4914,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 {
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	u8 level = vmx_eptp_page_walk_level(new_eptp);
-	union kvm_mmu_role new_mode =
+	union kvm_cpu_role new_mode =
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
@@ -4956,7 +4956,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 				const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role new_mode = kvm_calc_cpu_role(vcpu, regs);
+	union kvm_cpu_role new_mode = kvm_calc_cpu_role(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_mode.as_u64 == g_context->cpu_role.as_u64)
@@ -6233,7 +6233,7 @@ int kvm_mmu_vendor_module_init(void)
 	 */
 	BUILD_BUG_ON(sizeof(union kvm_mmu_page_role) != sizeof(u32));
 	BUILD_BUG_ON(sizeof(union kvm_mmu_extended_role) != sizeof(u32));
-	BUILD_BUG_ON(sizeof(union kvm_mmu_role) != sizeof(u64));
+	BUILD_BUG_ON(sizeof(union kvm_cpu_role) != sizeof(u64));
 
 	kvm_mmu_reset_all_pte_masks();
 
-- 
2.31.1


