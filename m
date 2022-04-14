Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C13C500752
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240507AbiDNHnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240347AbiDNHm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6544149F25
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4llhYUlEHnYS+rmS/rPK8xZy4asy8TJcfk9ASTbQTXg=;
        b=NuricHCLbk1/LVl6qs21S/NSYg5VI0pC/q2fH0RfJUuDZ89lJ7uq2ESgOrkZ7xmnNX0uVR
        8t+d0g3KoB+rqKYAIlP/SAJSWcyGum7uYyAFlbFSrFW1+fAE6AlhsuW8z4CM0jKzdTK5EW
        XDXLQRVJzr/R+otq2+VFgFHxVRUtm4c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-RKw1lzz6Mp2nLr21mGLC_Q-1; Thu, 14 Apr 2022 03:40:02 -0400
X-MC-Unique: RKw1lzz6Mp2nLr21mGLC_Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FD5A804184;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D63440D1DB;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, David Matlack <dmatlack@google.com>
Subject: [PATCH 02/22] KVM: x86/mmu: constify uses of struct kvm_mmu_role_regs
Date:   Thu, 14 Apr 2022 03:39:40 -0400
Message-Id: <20220414074000.31438-3-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct kvm_mmu_role_regs is computed just once and then accessed.  Use
const to make this clearer, even though the const fields of struct
kvm_mmu_role_regs already prevent (or make it harder...) to modify
the contents of the struct.

Reviewed-by: David Matlack <dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 797c51bb6cda..07b8550e68e9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -197,7 +197,8 @@ struct kvm_mmu_role_regs {
  * the single source of truth for the MMU's state.
  */
 #define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
-static inline bool __maybe_unused ____is_##reg##_##name(struct kvm_mmu_role_regs *regs)\
+static inline bool __maybe_unused					\
+____is_##reg##_##name(const struct kvm_mmu_role_regs *regs)		\
 {									\
 	return !!(regs->reg & flag);					\
 }
@@ -244,7 +245,7 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 	return regs;
 }
 
-static int role_regs_to_root_level(struct kvm_mmu_role_regs *regs)
+static int role_regs_to_root_level(const struct kvm_mmu_role_regs *regs)
 {
 	if (!____is_cr0_pg(regs))
 		return 0;
@@ -4705,7 +4706,7 @@ static void paging32_init_context(struct kvm_mmu *context)
 }
 
 static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
-							 struct kvm_mmu_role_regs *regs)
+							 const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_extended_role ext = {0};
 
@@ -4728,7 +4729,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 }
 
 static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
-						   struct kvm_mmu_role_regs *regs,
+						   const struct kvm_mmu_role_regs *regs,
 						   bool base_only)
 {
 	union kvm_mmu_role role = {0};
@@ -4764,7 +4765,8 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				struct kvm_mmu_role_regs *regs, bool base_only)
+				const struct kvm_mmu_role_regs *regs,
+				bool base_only)
 {
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
 
@@ -4810,7 +4812,8 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_role
 kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
-				      struct kvm_mmu_role_regs *regs, bool base_only)
+				      const struct kvm_mmu_role_regs *regs,
+				      bool base_only)
 {
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
 
@@ -4823,7 +4826,8 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   struct kvm_mmu_role_regs *regs, bool base_only)
+				   const struct kvm_mmu_role_regs *regs,
+				   bool base_only)
 {
 	union kvm_mmu_role role =
 		kvm_calc_shadow_root_page_role_common(vcpu, regs, base_only);
@@ -4841,7 +4845,7 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    struct kvm_mmu_role_regs *regs,
+				    const struct kvm_mmu_role_regs *regs,
 				    union kvm_mmu_role new_role)
 {
 	if (new_role.as_u64 == context->mmu_role.as_u64)
@@ -4864,7 +4868,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
-				struct kvm_mmu_role_regs *regs)
+				const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
@@ -4875,7 +4879,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   struct kvm_mmu_role_regs *regs)
+				   const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role =
 		kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
@@ -4975,7 +4979,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 }
 
 static union kvm_mmu_role
-kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, struct kvm_mmu_role_regs *regs)
+kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role;
 
-- 
2.31.1


