Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BB04BE712
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380364AbiBUQX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380268AbiBUQX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C302427B03
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ew2fA4AqH9vKgQPNp0OjXmbIreACjwPwyBewMu02duQ=;
        b=PV81SeU76uNsYTLwNA0IbHLHgw+k3BbJk+BoKpBafB4giLsbRxug6hq1ZsDFKL3h+tcQU1
        L4+Hv9j8VMXDvhxUorr8yC+NJpsNs1slS//KdVo8cGUq67F2pFAfUaD4HzCiZenXKi1G5d
        8GjzAaEj4OfiPBU1Ua1tlxNnCDWfmfY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-DqE0oH5vOpqHnLkcBe7Y_w-1; Mon, 21 Feb 2022 11:22:55 -0500
X-MC-Unique: DqE0oH5vOpqHnLkcBe7Y_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE7301926DA2;
        Mon, 21 Feb 2022 16:22:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FB347611B;
        Mon, 21 Feb 2022 16:22:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 19/25] KVM: x86/mmu: simplify and/or inline computation of shadow MMU roles
Date:   Mon, 21 Feb 2022 11:22:37 -0500
Message-Id: <20220221162243.683208-20-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shadow MMUs compute their role from cpu_mode.base, simply by adjusting
the root level.  It's one line of code, so do not place it in a separate
function.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 54 +++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d657e2e2ceec..47288643ab70 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4768,30 +4768,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	reset_tdp_shadow_zero_bits_mask(context);
 }
 
-static union kvm_mmu_page_role
-kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_mmu_paging_mode role)
-{
-	if (!role.ext.efer_lma)
-		role.base.level = PT32E_ROOT_LEVEL;
-	else if (role.ext.cr4_la57)
-		role.base.level = PT64_ROOT_5LEVEL;
-	else
-		role.base.level = PT64_ROOT_4LEVEL;
-
-	/*
-	 * KVM forces EFER.NX=1 when TDP is disabled, reflect it in the MMU role.
-	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
-	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
-	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
-	 * The iTLB multi-hit workaround can be toggled at any time, so assume
-	 * NX can be used by any non-nested shadow MMU to avoid having to reset
-	 * MMU contexts.
-	 */
-	role.base.efer_nx = true;
-	return role.base;
-}
-
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 				    union kvm_mmu_paging_mode cpu_mode,
 				    union kvm_mmu_page_role root_role)
@@ -4822,18 +4798,23 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
-	union kvm_mmu_page_role root_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_mode);
+	union kvm_mmu_page_role root_role;
 
-	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
-}
+	root_role = cpu_mode.base;
+	root_role.level = max_t(u32, root_role.level, PT32E_ROOT_LEVEL);
 
-static union kvm_mmu_page_role
-kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   union kvm_mmu_paging_mode role)
-{
-	role.base.level = kvm_mmu_get_tdp_level(vcpu);
-	return role.base;
+	/*
+	 * KVM forces EFER.NX=1 when TDP is disabled, reflect it in the MMU role.
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.
+	 */
+	root_role.efer_nx = true;
+
+	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
 }
 
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
@@ -4846,7 +4827,10 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.efer = efer,
 	};
 	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
-	union kvm_mmu_page_role root_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_mode);
+	union kvm_mmu_page_role root_role;
+
+	root_role = cpu_mode.base;
+	root_role.level = kvm_mmu_get_tdp_level(vcpu);
 
 	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
-- 
2.31.1


