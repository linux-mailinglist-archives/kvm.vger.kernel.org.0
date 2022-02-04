Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61644A98B6
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358781AbiBDL5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358592AbiBDL5c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NJOP7FoyOCifyX0DKl4Q1LzWVmhR0iMvwQ8KGPl/v9U=;
        b=DcWyt+dXbGw0ndTnQ/TA2rwcx6oR/aOufqNOqzxYXrvizdLyM5T1VkLqWu1sq2voRaxyma
        i3uDIkXn97Pu4hg6XB86/ll4I25bl20XN9N1/0iIl4izeUxVRq8TG+CnIdTaQ6ruyYxDrs
        ZIxMdBREPtGSEKzKo6n+obc3QiSKD9I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-9R-M2s5UO3K2MisQaDVVWw-1; Fri, 04 Feb 2022 06:57:29 -0500
X-MC-Unique: 9R-M2s5UO3K2MisQaDVVWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 182548710FB;
        Fri,  4 Feb 2022 11:57:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E32B6E1F1;
        Fri,  4 Feb 2022 11:57:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 15/23] KVM: MMU: cleanup computation of MMU roles for shadow paging
Date:   Fri,  4 Feb 2022 06:57:10 -0500
Message-Id: <20220204115718.14934-16-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass the already-computed CPU role, instead of redoing it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1650fc291284..817e6cc916fc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4751,13 +4751,11 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   const struct kvm_mmu_role_regs *regs)
+				   union kvm_mmu_role role)
 {
-	union kvm_mmu_role role = kvm_calc_cpu_role(vcpu, regs);
-
-	if (!____is_efer_lma(regs))
+	if (!role.ext.efer_lma)
 		role.base.level = PT32E_ROOT_LEVEL;
-	else if (____is_cr4_la57(regs))
+	else if (role.ext.cr4_la57)
 		role.base.level = PT64_ROOT_5LEVEL;
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
@@ -4794,7 +4792,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_role mmu_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, regs);
+		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_role);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
 
@@ -4811,11 +4809,8 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   const struct kvm_mmu_role_regs *regs)
+				   union kvm_mmu_role role)
 {
-	union kvm_mmu_role role =
-               kvm_calc_cpu_role(vcpu, regs);
-
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 
 	return role;
@@ -4831,7 +4826,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.efer = efer,
 	};
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
-	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);;
+	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_role);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
 	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
-- 
2.31.1


