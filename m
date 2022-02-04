Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AEA4A98A7
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358636AbiBDL5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358528AbiBDL50 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23LmqLrLqw9sHYk580lY5bQARRIz3tEWlrRaxErbyko=;
        b=XcwslnxoJCN/8/zQqqzASG7/AA426g4m3gDK37ql7USNh9e/bsg0/AV1t6a09XFJm7fJCF
        G+pevcC35ba+kYms0PrKkkj0BdFNTVzJ91MxvVLp9P/fdiFQ0ZJ5VKAZYV3eq51015I3JD
        SDYLEEjQcQvyJezS9BLGktz1b6ljcjI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-aJmuQr2pNgieNtln78GC6g-1; Fri, 04 Feb 2022 06:57:22 -0500
X-MC-Unique: aJmuQr2pNgieNtln78GC6g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 962AE190B2A1;
        Fri,  4 Feb 2022 11:57:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 299AA1081172;
        Fri,  4 Feb 2022 11:57:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 04/23] KVM: MMU: constify uses of struct kvm_mmu_role_regs
Date:   Fri,  4 Feb 2022 06:56:59 -0500
Message-Id: <20220204115718.14934-5-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct kvm_mmu_role_regs is computed just once and then accessed.  Use
const to enforce this.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0039b2f21286..3add9d8b0630 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -208,7 +208,7 @@ struct kvm_mmu_role_regs {
  * the single source of truth for the MMU's state.
  */
 #define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
-static inline bool __maybe_unused ____is_##reg##_##name(struct kvm_mmu_role_regs *regs)\
+static inline bool __maybe_unused ____is_##reg##_##name(const struct kvm_mmu_role_regs *regs)\
 {									\
 	return !!(regs->reg & flag);					\
 }
@@ -255,7 +255,7 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 	return regs;
 }
 
-static int role_regs_to_root_level(struct kvm_mmu_role_regs *regs)
+static int role_regs_to_root_level(const struct kvm_mmu_role_regs *regs)
 {
 	if (!____is_cr0_pg(regs))
 		return 0;
@@ -4666,7 +4666,7 @@ static void paging32_init_context(struct kvm_mmu *context)
 }
 
 static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
-							 struct kvm_mmu_role_regs *regs)
+							 const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_extended_role ext = {0};
 
@@ -4687,7 +4687,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 }
 
 static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
-						   struct kvm_mmu_role_regs *regs,
+						   const struct kvm_mmu_role_regs *regs,
 						   bool base_only)
 {
 	union kvm_mmu_role role = {0};
@@ -4723,7 +4723,8 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				struct kvm_mmu_role_regs *regs, bool base_only)
+				const struct kvm_mmu_role_regs *regs,
+				bool base_only)
 {
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
 
@@ -4769,7 +4770,8 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_role
 kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
-				      struct kvm_mmu_role_regs *regs, bool base_only)
+				      const struct kvm_mmu_role_regs *regs,
+				      bool base_only)
 {
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs, base_only);
 
@@ -4782,7 +4784,8 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   struct kvm_mmu_role_regs *regs, bool base_only)
+				   const struct kvm_mmu_role_regs *regs,
+				   bool base_only)
 {
 	union kvm_mmu_role role =
 		kvm_calc_shadow_root_page_role_common(vcpu, regs, base_only);
@@ -4940,7 +4943,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 }
 
 static union kvm_mmu_role
-kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, struct kvm_mmu_role_regs *regs)
+kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role;
 
-- 
2.31.1


