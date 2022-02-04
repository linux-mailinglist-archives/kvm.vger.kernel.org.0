Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5564A98B3
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358532AbiBDL5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358541AbiBDL5b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yhlsGmiUXZA8gEHUfw5Hj0xsoP5XAliQCBV1I2fhGDs=;
        b=ePx5UWpYQ/7OnS9fz8EJuYo6IC7TKOShIY8keKipCP2EYYu/+/FyI3m1Q68wY+J3ScVm4I
        9ej0xYwG02IsvYavQkUKHcUG7dXLN1Gl1g4x6GjmwSvzH3aRrzLAhS5LbjNX7EeJwPsT7v
        +O2LmjrTdmVxg5A5aXYfNuYU+V3cHlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-eKSqtdHiPeSBIvq2G4wmEQ-1; Fri, 04 Feb 2022 06:57:28 -0500
X-MC-Unique: eKSqtdHiPeSBIvq2G4wmEQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0108B83DD24;
        Fri,  4 Feb 2022 11:57:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72F2E6E1FD;
        Fri,  4 Feb 2022 11:57:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 13/23] KVM: MMU: remove kvm_calc_shadow_root_page_role_common
Date:   Fri,  4 Feb 2022 06:57:08 -0500
Message-Id: <20220204115718.14934-14-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_calc_shadow_root_page_role_common is the same as
kvm_calc_cpu_role except for the level, which is overwritten
afterwards in kvm_calc_shadow_mmu_root_page_role
and kvm_calc_shadow_npt_root_page_role.

role.base.direct is already set correctly for the CPU role,
and CR0.PG=1 is required for VMRUN so it will also be
correct for nested NPT.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d6b5d8c1c0dc..19abf1e4cee9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4772,27 +4772,11 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	reset_tdp_shadow_zero_bits_mask(context);
 }
 
-static union kvm_mmu_role
-kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
-				      const struct kvm_mmu_role_regs *regs)
-{
-	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs);
-
-	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
-	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
-	role.base.has_4_byte_gpte = ____is_cr0_pg(regs) && !____is_cr4_pae(regs);
-
-	return role;
-}
-
 static union kvm_mmu_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				   const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, regs);
-
-	role.base.direct = !____is_cr0_pg(regs);
+	union kvm_mmu_role role = kvm_calc_cpu_role(vcpu, regs);
 
 	if (!____is_efer_lma(regs))
 		role.base.level = PT32E_ROOT_LEVEL;
@@ -4853,9 +4837,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 				   const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, regs);
+               kvm_calc_cpu_role(vcpu, regs);
 
-	role.base.direct = false;
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 
 	return role;
-- 
2.31.1


