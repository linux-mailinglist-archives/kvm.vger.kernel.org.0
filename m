Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F814A98BC
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358832AbiBDL5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358638AbiBDL5f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e2E56FroKAIKAOPkFQHe02XUrHi9MAiTwjfpyI4L/KE=;
        b=U8Y2HcNyhmX/lwsygyOvT0d4rVeRvcBaaEClSU6x+vNFGRxvfG7DnkTvEXGcbvw+mXA9pB
        e/EsqOelENU5fadvm6xQnKPF2u72JCEha4He/9HBuAT/Z8S0zrnaGGxdV6muqppkElKOft
        W9iPi1GGrdk+vD/5dgF4eHA3zVGe27c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-bh0r1GCTNkmrJHhXPsaXZA-1; Fri, 04 Feb 2022 06:57:31 -0500
X-MC-Unique: bh0r1GCTNkmrJHhXPsaXZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55C7D190B2AE;
        Fri,  4 Feb 2022 11:57:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC1DD6E1EA;
        Fri,  4 Feb 2022 11:57:29 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 19/23] KVM: MMU: simplify and/or inline computation of shadow MMU roles
Date:   Fri,  4 Feb 2022 06:57:14 -0500
Message-Id: <20220204115718.14934-20-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shadow MMUs can compute their role from cpu_role.base, simply by adjusting
the root level.  It's one line of code, so do not place it in a separate
function.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bba712d1a6d7..01027da82e23 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4755,20 +4755,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	reset_tdp_shadow_zero_bits_mask(context);
 }
 
-static union kvm_mmu_page_role
-kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_mmu_role role)
-{
-	if (!role.ext.efer_lma)
-		role.base.level = PT32E_ROOT_LEVEL;
-	else if (role.ext.cr4_la57)
-		role.base.level = PT64_ROOT_5LEVEL;
-	else
-		role.base.level = PT64_ROOT_4LEVEL;
-
-	return role.base;
-}
-
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 				    union kvm_mmu_role cpu_role,
 				    union kvm_mmu_page_role mmu_role)
@@ -4797,9 +4783,10 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
-	union kvm_mmu_page_role mmu_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_role);
+	union kvm_mmu_page_role mmu_role;
 
+	mmu_role = cpu_role.base;
+	mmu_role.level = max_t(u32, mmu_role.level, PT32E_ROOT_LEVEL);
 	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
 
 	/*
@@ -4813,14 +4800,6 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
 
-static union kvm_mmu_page_role
-kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_mmu_role role)
-{
-	role.base.level = kvm_mmu_get_tdp_level(vcpu);
-	return role.base;
-}
-
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 			     unsigned long cr4, u64 efer, gpa_t nested_cr3)
 {
@@ -4831,7 +4810,10 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.efer = efer,
 	};
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
-	union kvm_mmu_page_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_role);
+	union kvm_mmu_page_role mmu_role;
+
+	mmu_role = cpu_role.base;
+	mmu_role.level = kvm_mmu_get_tdp_level(vcpu);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
 	reset_shadow_zero_bits_mask(vcpu, context);
-- 
2.31.1


