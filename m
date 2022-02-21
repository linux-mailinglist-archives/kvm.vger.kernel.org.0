Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCCE4BDD61
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380325AbiBUQXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380229AbiBUQXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F29752714D
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1zP8NjyTETUCXArNph0FHuCwd64/z+cH8qWwcxs072Y=;
        b=aNeozQY+YrV0Z5cD8z27roFTOWwJif9h3jDoJZ5/xAR1KnnGXXAJ1YJp8MA3Wd3ziSrdOR
        qtnL0sUnPktIbMzVbUJUAdRPrNHQ5WFD3d4oilzMX9WhdxtCaKXJOXBE1KZrgyUCghryKt
        NNPjPgOSnAx/Hm5QZ5H4mFLVcEUdWBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-vc9mpemLMA64yjS6nMNb0Q-1; Mon, 21 Feb 2022 11:22:51 -0500
X-MC-Unique: vc9mpemLMA64yjS6nMNb0Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FEAD801B0B;
        Mon, 21 Feb 2022 16:22:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1305478AB5;
        Mon, 21 Feb 2022 16:22:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 12/25] KVM: x86/mmu: cleanup computation of MMU roles for two-dimensional paging
Date:   Mon, 21 Feb 2022 11:22:30 -0500
Message-Id: <20220221162243.683208-13-pbonzini@redhat.com>
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

Inline kvm_calc_mmu_role_common into its sole caller, and simplify it
by removing the computation of unnecessary bits.

Extended bits are unnecessary because page walking uses the CPU mode,
and EFER.NX/CR0.WP can be set to one unconditionally---matching the
format of shadow pages rather than the format of guest pages.

The MMU role for two dimensional paging does still depend on the CPU mode,
even if only barely so, due to SMM and guest mode; for consistency,
pass it down to kvm_calc_tdp_mmu_root_page_role instead of querying
the vcpu with is_smm or is_guest_mode.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 41 +++++++++--------------------------------
 1 file changed, 9 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 31874fad12fb..0a08ab8e2e4e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4706,34 +4706,6 @@ kvm_calc_cpu_mode(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
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
-	role.ext.valid = 1;
-
-	return role;
-}
-
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	/* tdp_root_level is architecture forced level, use it if nonzero */
@@ -4749,14 +4721,20 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 
 static union kvm_mmu_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				const struct kvm_mmu_role_regs *regs)
+				union kvm_mmu_role cpu_mode)
 {
-	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs);
+	union kvm_mmu_role role = {0};
 
+	role.base.access = ACC_ALL;
+	role.base.cr0_wp = true;
+	role.base.efer_nx = true;
+	role.base.smm = cpu_mode.base.smm;
+	role.base.guest_mode = cpu_mode.base.guest_mode;
 	role.base.ad_disabled = (shadow_accessed_mask == 0);
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	role.base.direct = true;
 	role.base.has_4_byte_gpte = false;
+	role.ext.valid = true;
 
 	return role;
 }
@@ -4766,8 +4744,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
-	union kvm_mmu_role mmu_role =
-		kvm_calc_tdp_mmu_root_page_role(vcpu, regs);
+	union kvm_mmu_role mmu_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_mode);
 
 	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
 	    mmu_role.as_u64 == context->mmu_role.as_u64)
-- 
2.31.1


