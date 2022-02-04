Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9E74A98A3
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358561AbiBDL53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358515AbiBDL5Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdszhqD355DEoGMlDegfttlPu8jVJiAVeRKaATVPk1o=;
        b=Zui8Khp3EfCcP51YkHxNvXYBZ5GyJ74jg3HflLrYs1Phv27r4MRh42h3Yvj8+l0HslPuz5
        syBwMz7U7CU65wIO5MUthHV/1HEs53ZFxdxNAuj0YIdyMrcixrXMoswcYOzQnlhQBO31SH
        pw5U4TzN8bQyJ4ydAXWzxCuJ+SVQ7A0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-R2EQWIJYPiGy16cgnl3zfQ-1; Fri, 04 Feb 2022 06:57:23 -0500
X-MC-Unique: R2EQWIJYPiGy16cgnl3zfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2881A61261;
        Fri,  4 Feb 2022 11:57:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B05901081172;
        Fri,  4 Feb 2022 11:57:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 05/23] KVM: MMU: pull computation of kvm_mmu_role_regs to kvm_init_mmu
Date:   Fri,  4 Feb 2022 06:57:00 -0500
Message-Id: <20220204115718.14934-6-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The init_kvm_*mmu functions, with the exception of shadow NPT,
do not need to know the full values of CR0/CR4/EFER; they only
need to know the bits that make up the "role".  This cleanup
however will take quite a few incremental steps.  As a start,
pull the common computation of the struct kvm_mmu_role_regs
into their caller: all of them extract the struct from the vcpu
as the very first step.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3add9d8b0630..577e70509510 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4736,12 +4736,12 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	return role;
 }
 
-static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
+static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
+			     const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
 	union kvm_mmu_role new_role =
-		kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, false);
+		kvm_calc_tdp_mmu_root_page_role(vcpu, regs, false);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
@@ -4755,7 +4755,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->root_level = role_regs_to_root_level(&regs);
+	context->root_level = role_regs_to_root_level(regs);
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -4803,7 +4803,7 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
-				    struct kvm_mmu_role_regs *regs,
+				    const struct kvm_mmu_role_regs *regs,
 				    union kvm_mmu_role new_role)
 {
 	if (new_role.as_u64 == context->mmu_role.as_u64)
@@ -4824,7 +4824,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
-				struct kvm_mmu_role_regs *regs)
+				const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
@@ -4845,7 +4845,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   struct kvm_mmu_role_regs *regs)
+				   const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role =
 		kvm_calc_shadow_root_page_role_common(vcpu, regs, false);
@@ -4930,12 +4930,12 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
-static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
+static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
+			     const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
 
-	kvm_init_shadow_mmu(vcpu, &regs);
+	kvm_init_shadow_mmu(vcpu, regs);
 
 	context->get_guest_pgd     = get_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
@@ -4959,10 +4959,9 @@ kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *
 	return role;
 }
 
-static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
+static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
-	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
-	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, &regs);
+	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_role.as_u64 == g_context->mmu_role.as_u64)
@@ -5002,12 +5001,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu)
 {
+	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
+
 	if (mmu_is_nested(vcpu))
-		init_kvm_nested_mmu(vcpu);
+		init_kvm_nested_mmu(vcpu, &regs);
 	else if (tdp_enabled)
-		init_kvm_tdp_mmu(vcpu);
+		init_kvm_tdp_mmu(vcpu, &regs);
 	else
-		init_kvm_softmmu(vcpu);
+		init_kvm_softmmu(vcpu, &regs);
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
-- 
2.31.1


