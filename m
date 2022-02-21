Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4124BE5AA
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380321AbiBUQXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380214AbiBUQXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 485102714D
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xTJnCkKdsdNvfz4Xp1aH2PLk7lwHUyThFuz2jZw0IQo=;
        b=Q/PETOAHh+XSpTA0kErlwBGZlPQ8n7MCFJVmcpYvIVlZtT6QqxfwTqFuxFVuA9aSaer5l/
        NObJgU/V4q1DV5gB6ZKZPLePn27gMfpEh0gtBAL1O6Du3D6fWbC8Nz0nYZm1sMUnwqAW3m
        mMubfhxqQM2CTAREVa5EnhUcOcKSVow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-lCL9fJ85NXKPdLiy9lTs7g-1; Mon, 21 Feb 2022 11:22:51 -0500
X-MC-Unique: lCL9fJ85NXKPdLiy9lTs7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC60F1006AA0;
        Mon, 21 Feb 2022 16:22:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F4F678AA5;
        Mon, 21 Feb 2022 16:22:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 11/25] KVM: x86/mmu: remove kvm_calc_shadow_root_page_role_common
Date:   Mon, 21 Feb 2022 11:22:29 -0500
Message-Id: <20220221162243.683208-12-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_calc_shadow_root_page_role_common is the same as
kvm_calc_cpu_mode except for the level, which is overwritten
afterwards in kvm_calc_shadow_mmu_root_page_role
and kvm_calc_shadow_npt_root_page_role.

role.base.direct is already set correctly for the CPU mode,
and CR0.PG=1 is required for VMRUN so it will also be
correct for nested NPT.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3ffa6f2bf991..31874fad12fb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4796,27 +4796,11 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
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
+	union kvm_mmu_role role = kvm_calc_cpu_mode(vcpu, regs);
 
 	if (!____is_efer_lma(regs))
 		role.base.level = PT32E_ROOT_LEVEL;
@@ -4869,9 +4853,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 				   const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, regs);
+               kvm_calc_cpu_mode(vcpu, regs);
 
-	role.base.direct = false;
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 
 	return role;
-- 
2.31.1


