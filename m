Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEBA4A98A9
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358572AbiBDL5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358558AbiBDL52 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0KvnVSZbYuXChqPICSoFkHZMPZz7M/WQK9Wm/Hf92g=;
        b=BfwoM15D0MsbH4HLg2g9UAs38vxdWGhUCdsENIWE0xitM88WWMy8TD8xDS0UX8GozKAXfv
        SOBBhgTGWoMW6DoNhoEOmuHCIuLH05bNumQrA6IQSoFY8RBFt3RvTj4cv1XcHoQF4DbOPS
        NA2VxcEBYT1+pgZiMqOfCZB+r129wAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-2r59kty6OcywRixb3SyHTQ-1; Fri, 04 Feb 2022 06:57:25 -0500
X-MC-Unique: 2r59kty6OcywRixb3SyHTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5822F1015DBE;
        Fri,  4 Feb 2022 11:57:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E12861081172;
        Fri,  4 Feb 2022 11:57:23 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 09/23] KVM: MMU: remove "bool base_only" arguments
Date:   Fri,  4 Feb 2022 06:57:04 -0500
Message-Id: <20220204115718.14934-10-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The argument is always false now that kvm_mmu_calc_root_page_role has
been removed.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 63 +++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 42475e4c2a48..dd69cfc8c4f6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4658,46 +4658,30 @@ static void paging32_init_context(struct kvm_mmu *context)
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
 
-	if (base_only)
-		return role;
-
-	role.ext = kvm_calc_mmu_role_ext(vcpu, regs);
-
 	return role;
 }
 
@@ -4716,10 +4700,9 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 
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
@@ -4734,7 +4717,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
-		kvm_calc_tdp_mmu_root_page_role(vcpu, regs, false);
+		kvm_calc_tdp_mmu_root_page_role(vcpu, regs);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
@@ -4763,10 +4746,9 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 
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
@@ -4777,11 +4759,10 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
 
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
 
@@ -4821,7 +4802,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, regs, false);
+		kvm_calc_shadow_mmu_root_page_role(vcpu, regs);
 
 	shadow_mmu_init_context(vcpu, context, regs, new_role);
 
@@ -4841,7 +4822,7 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 				   const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
+		kvm_calc_shadow_root_page_role_common(vcpu, regs);
 
 	role.base.direct = false;
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
@@ -4937,7 +4918,7 @@ kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *
 {
 	union kvm_mmu_role role;
 
-	role = kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
+	role = kvm_calc_shadow_root_page_role_common(vcpu, regs);
 
 	/*
 	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
-- 
2.31.1


