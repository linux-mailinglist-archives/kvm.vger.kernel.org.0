Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F58B4BE1D4
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380306AbiBUQXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380226AbiBUQXS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50A6C27152
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9iGVRyuF8eH6f/8Mcput9LmHYap7PbXCJFm6PpLG9mk=;
        b=cXOaEFf+UcwvVTviAEqBLW174IjwKCK2kwnMw15y07ZCJ61GOYzzjfnCYSIrcgJ8hv/sJU
        r2ymmQ2JMRj4WqudlaOTzcm0BfjBb34UEgAPCxy8VZfArcEEvUvrwasqtRnpiAKArSVX7N
        zoxUwDWfLCdbzACdbHhRcmJEGBKYZOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-j7TOGg20M5SxcjVJNTUc9Q-1; Mon, 21 Feb 2022 11:22:48 -0500
X-MC-Unique: j7TOGg20M5SxcjVJNTUc9Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A88621006AA0;
        Mon, 21 Feb 2022 16:22:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C22077468;
        Mon, 21 Feb 2022 16:22:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 07/25] KVM: x86/mmu: remove "bool base_only" arguments
Date:   Mon, 21 Feb 2022 11:22:25 -0500
Message-Id: <20220221162243.683208-8-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The argument is always false now that kvm_mmu_calc_root_page_role has
been removed.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 66 +++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f3494dcc4e2f..7c835253a330 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4680,47 +4680,30 @@ static void paging32_init_context(struct kvm_mmu *context)
 	context->direct_map = false;
 }
 
-static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
-							 const struct kvm_mmu_role_regs *regs)
-{
-	union kvm_mmu_extended_role ext = {0};
-
-	if (____is_cr0_pg(regs)) {
-		ext.cr0_pg = 1;
-		ext.cr4_pae = ____is_cr4_pae(regs);
-		ext.cr4_smep = ____is_cr4_smep(regs);
-		ext.cr4_smap = ____is_cr4_smap(regs);
-		ext.cr4_pse = ____is_cr4_pse(regs);
-
-		/* PKEY and LA57 are active iff long mode is active. */
-		ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
-		ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
-		ext.efer_lma = ____is_efer_lma(regs);
-	}
-
-	ext.valid = 1;
-
-	return ext;
-}
-
 static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
-						   const struct kvm_mmu_role_regs *regs,
-						   bool base_only)
+						   const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role = {0};
 
 	role.base.access = ACC_ALL;
 	if (____is_cr0_pg(regs)) {
+		role.ext.cr0_pg = 1;
 		role.base.efer_nx = ____is_efer_nx(regs);
 		role.base.cr0_wp = ____is_cr0_wp(regs);
+
+		role.ext.cr4_pae = ____is_cr4_pae(regs);
+		role.ext.cr4_smep = ____is_cr4_smep(regs);
+		role.ext.cr4_smap = ____is_cr4_smap(regs);
+		role.ext.cr4_pse = ____is_cr4_pse(regs);
+
+		/* PKEY and LA57 are active iff long mode is active. */
+		role.ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
+		role.ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
+		role.ext.efer_lma = ____is_efer_lma(regs);
 	}
 	role.base.smm = is_smm(vcpu);
 	role.base.guest_mode = is_guest_mode(vcpu);
-
-	if (base_only)
-		return role;
-
-	role.ext = kvm_calc_mmu_role_ext(vcpu, regs);
+	role.ext.valid = 1;
 
 	return role;
 }
@@ -4740,10 +4723,9 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				const struct kvm_mmu_role_regs *regs,
-				bool base_only)
+				const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
+	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs);
 
 	role.base.ad_disabled = (shadow_accessed_mask == 0);
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
@@ -4758,7 +4740,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
-		kvm_calc_tdp_mmu_root_page_role(vcpu, regs, false);
+		kvm_calc_tdp_mmu_root_page_role(vcpu, regs);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
@@ -4787,10 +4769,9 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
-				      const struct kvm_mmu_role_regs *regs,
-				      bool base_only)
+				      const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
+	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs);
 
 	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
 	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
@@ -4801,11 +4782,10 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   const struct kvm_mmu_role_regs *regs,
-				   bool base_only)
+				   const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, regs, base_only);
+		kvm_calc_shadow_root_page_role_common(vcpu, regs);
 
 	role.base.direct = !____is_cr0_pg(regs);
 
@@ -4847,7 +4827,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, regs, false);
+		kvm_calc_shadow_mmu_root_page_role(vcpu, regs);
 
 	shadow_mmu_init_context(vcpu, context, regs, new_role);
 }
@@ -4857,7 +4837,7 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 				   const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
+		kvm_calc_shadow_root_page_role_common(vcpu, regs);
 
 	role.base.direct = false;
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
@@ -4958,7 +4938,7 @@ kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *
 {
 	union kvm_mmu_role role;
 
-	role = kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
+	role = kvm_calc_shadow_root_page_role_common(vcpu, regs);
 
 	/*
 	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
-- 
2.31.1


