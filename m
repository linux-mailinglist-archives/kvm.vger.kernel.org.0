Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC50A4A989F
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358503AbiBDL5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357014AbiBDL5W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UoW9C6WTQmDXSZguRIVvtIoVzfzF+dJipQYj4ctsU3Q=;
        b=MJvzunCElNe5dGRprhHlt2qntlI2yAzMg2lybwL5JsCM/uliExJFwTLMMqHNXKw0tGEpCX
        vbaW33vmNPs4SqLu/zeY8QiLNirdKO/DOhaAHW5FcrPvsP8c/6Fhxpd/W7u0QengnezYrO
        D3qBDP41UkLatFQNvN6Pu8ZwLaZlQUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-4rbSrh1JPqmLmI6pKzLEqA-1; Fri, 04 Feb 2022 06:57:21 -0500
X-MC-Unique: 4rbSrh1JPqmLmI6pKzLEqA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB76461259;
        Fri,  4 Feb 2022 11:57:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F7A81081172;
        Fri,  4 Feb 2022 11:57:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 01/23] KVM: MMU: pass uses_nx directly to reset_shadow_zero_bits_mask
Date:   Fri,  4 Feb 2022 06:56:56 -0500
Message-Id: <20220204115718.14934-2-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

reset_shadow_zero_bits_mask has a very unintuitive way of deciding
whether the shadow pages will use the NX bit.  The function is used in
two cases, shadow paging and shadow NPT; shadow paging has a use for
EFER.NX and needs to force it enabled, while shadow NPT only needs it
depending on L1's setting.

The actual root problem here is that is_efer_nx, despite being part
of the "base" role, only matches the format of the shadow pages in the
NPT case.  For now, just remove the ugly variable initialization and move
the call to reset_shadow_zero_bits_mask out of shadow_mmu_init_context.
The parameter can then be removed after the root problem in the role
is fixed.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 296f8723f9ae..9424ae90f1ef 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4410,18 +4410,9 @@ static inline u64 reserved_hpa_bits(void)
  * follow the features in guest.
  */
 static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
-					struct kvm_mmu *context)
+					struct kvm_mmu *context,
+					bool uses_nx)
 {
-	/*
-	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
-	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
-	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
-	 * The iTLB multi-hit workaround can be toggled at any time, so assume
-	 * NX can be used by any non-nested shadow MMU to avoid having to reset
-	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
-	 */
-	bool uses_nx = is_efer_nx(context) || !tdp_enabled;
-
 	/* @amd adds a check on bit of SPTEs, which KVM shouldn't use anyways. */
 	bool is_amd = true;
 	/* KVM doesn't use 2-level page tables for the shadow MMU. */
@@ -4829,8 +4820,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 
 	reset_guest_paging_metadata(vcpu, context);
 	context->shadow_root_level = new_role.base.level;
-
-	reset_shadow_zero_bits_mask(vcpu, context);
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
@@ -4841,6 +4830,16 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 		kvm_calc_shadow_mmu_root_page_role(vcpu, regs, false);
 
 	shadow_mmu_init_context(vcpu, context, regs, new_role);
+
+	/*
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
+	 */
+	reset_shadow_zero_bits_mask(vcpu, context, true);
 }
 
 static union kvm_mmu_role
@@ -4872,6 +4871,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
 
 	shadow_mmu_init_context(vcpu, context, &regs, new_role);
+	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
-- 
2.31.1


