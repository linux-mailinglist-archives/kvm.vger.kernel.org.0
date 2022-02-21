Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7216F4BE382
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380230AbiBUQXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380199AbiBUQXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E552A2714D
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvmTg7zrEdwEArlt/5g3tbeZl6wapS1zW/jokMqAmyM=;
        b=goGuwCmMhFjsN4oEDVYyXSgOxBTpSRyOd1+QwUFn8Tr5cMTIkkjZk16B7Y6XzhQxKt3AMF
        0EkNeiEPN2pxBOziT/R6xJo46iAZdFGlvM+vqrThlbeMvQD4aHFVFzmiMzcL3ugaSjwS39
        Z5tiTdaLUOuwYA/lWJq+nOvR8Pi3bp4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-Rh47UOTvOlC4qG8vAQoSNg-1; Mon, 21 Feb 2022 11:22:46 -0500
X-MC-Unique: Rh47UOTvOlC4qG8vAQoSNg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C0221926DA3;
        Mon, 21 Feb 2022 16:22:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F67977468;
        Mon, 21 Feb 2022 16:22:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 03/25] KVM: x86/mmu: constify uses of struct kvm_mmu_role_regs
Date:   Mon, 21 Feb 2022 11:22:21 -0500
Message-Id: <20220221162243.683208-4-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct kvm_mmu_role_regs is computed just once and then accessed.  Use
const to make this clearer, even though the const fields of struct
kvm_mmu_role_regs already prevent modifications to the contents of the
struct, or rather make them harder.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4f9bbd02fb8b..97566ac539e3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -197,7 +197,7 @@ struct kvm_mmu_role_regs {
  * the single source of truth for the MMU's state.
  */
 #define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
-static inline bool __maybe_unused ____is_##reg##_##name(struct kvm_mmu_role_regs *regs)\
+static inline bool __maybe_unused ____is_##reg##_##name(const struct kvm_mmu_role_regs *regs)\
 {									\
 	return !!(regs->reg & flag);					\
 }
@@ -244,7 +244,7 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 	return regs;
 }
 
-static int role_regs_to_root_level(struct kvm_mmu_role_regs *regs)
+static int role_regs_to_root_level(const struct kvm_mmu_role_regs *regs)
 {
 	if (!____is_cr0_pg(regs))
 		return 0;
@@ -4681,7 +4681,7 @@ static void paging32_init_context(struct kvm_mmu *context)
 }
 
 static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
-							 struct kvm_mmu_role_regs *regs)
+							 const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_extended_role ext = {0};
 
@@ -4704,7 +4704,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 }
 
 static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
-						   struct kvm_mmu_role_regs *regs,
+						   const struct kvm_mmu_role_regs *regs,
 						   bool base_only)
 {
 	union kvm_mmu_role role = {0};
@@ -4740,7 +4740,8 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				struct kvm_mmu_role_regs *regs, bool base_only)
+				const struct kvm_mmu_role_regs *regs,
+				bool base_only)
 {
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
 
@@ -4786,7 +4787,8 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_role
 kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
-				      struct kvm_mmu_role_regs *regs, bool base_only)
+				      const struct kvm_mmu_role_regs *regs,
+				      bool base_only)
 {
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
 
@@ -4799,7 +4801,8 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   struct kvm_mmu_role_regs *regs, bool base_only)
+				   const struct kvm_mmu_role_regs *regs,
+				   bool base_only)
 {
 	union kvm_mmu_role role =
 		kvm_calc_shadow_root_page_role_common(vcpu, regs, base_only);
@@ -4817,7 +4820,7 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    struct kvm_mmu_role_regs *regs,
+				    const struct kvm_mmu_role_regs *regs,
 				    union kvm_mmu_role new_role)
 {
 	if (new_role.as_u64 == context->mmu_role.as_u64)
@@ -4840,7 +4843,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
-				struct kvm_mmu_role_regs *regs)
+				const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
@@ -4851,7 +4854,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   struct kvm_mmu_role_regs *regs)
+				   const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role =
 		kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
@@ -4951,7 +4954,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 }
 
 static union kvm_mmu_role
-kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, struct kvm_mmu_role_regs *regs)
+kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role;
 
-- 
2.31.1


