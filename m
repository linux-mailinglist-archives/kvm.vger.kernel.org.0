Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3794A98BD
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358855AbiBDL54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358684AbiBDL5j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AlOU5hIq1A/HFrJv2NU8RmCYxQMuiUK6gea68jpdViM=;
        b=WED573nXh/kA/xSVaLXVTmA8/Z1Of07XlvdGnxbNAO9hsKobkB0jbByebcK8DPpxj8FWvj
        aRljgqZ27kDMuMcF++VusPgoAglIhMwP/7QRH5HacWY14kmmRsY/4dSHmUni9gCGopPSdy
        CTTqqC8l4Rrr0DYFD+sWBmuMJPYau40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-HCxM_3_uO_mBxd-EB0azoA-1; Fri, 04 Feb 2022 06:57:38 -0500
X-MC-Unique: HCxM_3_uO_mBxd-EB0azoA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9A2B190B2A0;
        Fri,  4 Feb 2022 11:57:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B03027CAD8;
        Fri,  4 Feb 2022 11:57:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 20/23] KVM: MMU: pull CPU role computation to kvm_init_mmu
Date:   Fri,  4 Feb 2022 06:57:15 -0500
Message-Id: <20220204115718.14934-21-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not lead init_kvm_*mmu into the temptation of poking
into struct kvm_mmu_role_regs, by passing to it directly
the CPU role.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 01027da82e23..6f9d876ce429 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4721,11 +4721,9 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	return role;
 }
 
-static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
-			     const struct kvm_mmu_role_regs *regs)
+static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role cpu_role)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_page_role mmu_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_role);
 
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
@@ -4779,10 +4777,9 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
-				const struct kvm_mmu_role_regs *regs)
+				union kvm_mmu_role cpu_role)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_page_role mmu_role;
 
 	mmu_role = cpu_role.base;
@@ -4874,20 +4871,19 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
-			     const struct kvm_mmu_role_regs *regs)
+			     union kvm_mmu_role cpu_role)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 
-	kvm_init_shadow_mmu(vcpu, regs);
+	kvm_init_shadow_mmu(vcpu, cpu_role);
 
 	context->get_guest_pgd     = get_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
 
-static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
+static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_role new_role)
 {
-	union kvm_mmu_role new_role = kvm_calc_cpu_role(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_role.as_u64 == g_context->cpu_role.as_u64)
@@ -4928,13 +4924,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role
 void kvm_init_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
+	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
 
 	if (mmu_is_nested(vcpu))
-		init_kvm_nested_mmu(vcpu, &regs);
+		init_kvm_nested_mmu(vcpu, cpu_role);
 	else if (tdp_enabled)
-		init_kvm_tdp_mmu(vcpu, &regs);
+		init_kvm_tdp_mmu(vcpu, cpu_role);
 	else
-		init_kvm_softmmu(vcpu, &regs);
+		init_kvm_softmmu(vcpu, cpu_role);
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
-- 
2.31.1


