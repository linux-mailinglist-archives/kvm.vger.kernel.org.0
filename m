Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7D54A98BB
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358828AbiBDL5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45669 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358565AbiBDL5a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MuYSDO7EkngVPWTa07Xx0ZALA/kIXduI1AnC+SV/f2g=;
        b=DIuMv7QrCij+k9feKKzhgSQOTZL2/bQL1xNwusQ8uYsF/kDgjuB5tR0SZhr157NLIQGR4T
        fI79275uN8ShGdSEvPXhOSFNclROGYryIJ3sMVhWdlJS+dxAy3rm5ZqOMHgi+c5ZTL47SR
        7d5oVqv55IdBRwEyj9Pl/jQuo6ozrQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-NwmUUIaJO7qMNStcMXGMJw-1; Fri, 04 Feb 2022 06:57:28 -0500
X-MC-Unique: NwmUUIaJO7qMNStcMXGMJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83EAE1015DA1;
        Fri,  4 Feb 2022 11:57:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1652A6E1FF;
        Fri,  4 Feb 2022 11:57:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 14/23] KVM: MMU: cleanup computation of MMU roles for two-dimensional paging
Date:   Fri,  4 Feb 2022 06:57:09 -0500
Message-Id: <20220204115718.14934-15-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inline kvm_calc_mmu_role_common into its sole caller, and simplify it
by removing the computation of unnecessary bits.

Extended bits are unnecessary because page walking uses the CPU role,
and EFER.NX/CR0.WP can be set to one unconditionally---matching the
format of shadow pages rather than the format of guest pages.

The MMU role for two dimensional paging does still depend on the CPU role,
even if only barely so, due to SMM and guest mode; for consistency,
pass it down to kvm_calc_tdp_mmu_root_page_role instead of querying
the vcpu with is_smm or is_guest_mode.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 39 ++++++++-------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 19abf1e4cee9..1650fc291284 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4683,33 +4683,6 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 	return role;
 }
 
-static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
-						   const struct kvm_mmu_role_regs *regs)
-{
-	union kvm_mmu_role role = {0};
-
-	role.base.access = ACC_ALL;
-	if (____is_cr0_pg(regs)) {
-		role.ext.cr0_pg = 1;
-		role.base.efer_nx = ____is_efer_nx(regs);
-		role.base.cr0_wp = ____is_cr0_wp(regs);
-
-		role.ext.cr4_pae = ____is_cr4_pae(regs);
-		role.ext.cr4_smep = ____is_cr4_smep(regs);
-		role.ext.cr4_smap = ____is_cr4_smap(regs);
-		role.ext.cr4_pse = ____is_cr4_pse(regs);
-
-		/* PKEY and LA57 are active iff long mode is active. */
-		role.ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
-		role.ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
-		role.ext.efer_lma = ____is_efer_lma(regs);
-	}
-	role.base.smm = is_smm(vcpu);
-	role.base.guest_mode = is_guest_mode(vcpu);
-
-	return role;
-}
-
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	/* tdp_root_level is architecture forced level, use it if nonzero */
@@ -4725,10 +4698,15 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				const struct kvm_mmu_role_regs *regs)
+				union kvm_mmu_role cpu_role)
 {
-	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs);
+	union kvm_mmu_role role = {0};
 
+	role.base.access = ACC_ALL;
+	role.base.cr0_wp = true;
+	role.base.efer_nx = true;
+	role.base.smm = cpu_role.base.smm;
+	role.base.guest_mode = cpu_role.base.guest_mode;
 	role.base.ad_disabled = (shadow_accessed_mask == 0);
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	role.base.direct = true;
@@ -4742,8 +4720,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
-	union kvm_mmu_role mmu_role =
-		kvm_calc_tdp_mmu_root_page_role(vcpu, regs);
+	union kvm_mmu_role mmu_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_role);
 
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
 	    mmu_role.as_u64 == context->mmu_role.as_u64)
-- 
2.31.1


