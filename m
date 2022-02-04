Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463B04A98B7
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358792AbiBDL5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358566AbiBDL5a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oChNsJadBLIffGVGmDXFiHjemHn5uBlLZG2TbVnS7ts=;
        b=N0DXoidWFGIW6fU92PRp/bv0nWZqhLzgwC/qOHRpQD/TewYqmJ73Y/KHiFmW+MDqLfgtZI
        RD0bI2t4Nhho6iAYqrKnRnwKmW76AYFf/rB9HMFbpxthjOwbqBzNzNvh4YcZafF1iBMaid
        3S0pU84XwmHOXRenwo4rIc+n7Cf4SMw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-56riODwuNlSJmXs5Na8ZVw-1; Fri, 04 Feb 2022 06:57:27 -0500
X-MC-Unique: 56riODwuNlSJmXs5Na8ZVw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C47E7190B2A0;
        Fri,  4 Feb 2022 11:57:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 567A46E1F1;
        Fri,  4 Feb 2022 11:57:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 11/23] KVM: MMU: do not recompute root level from kvm_mmu_role_regs
Date:   Fri,  4 Feb 2022 06:57:06 -0500
Message-Id: <20220204115718.14934-12-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The root_level can be found in the cpu_role (in fact the field
is superfluous and could be removed, but one thing at a time).
Since there is only one usage left of role_regs_to_root_level,
inline it into kvm_calc_cpu_role.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f98444e1d834..74789295f922 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -253,19 +253,6 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 	return regs;
 }
 
-static int role_regs_to_root_level(const struct kvm_mmu_role_regs *regs)
-{
-	if (!____is_cr0_pg(regs))
-		return 0;
-	else if (____is_efer_lma(regs))
-		return ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL :
-					       PT64_ROOT_4LEVEL;
-	else if (____is_cr4_pae(regs))
-		return PT32E_ROOT_LEVEL;
-	else
-		return PT32_ROOT_LEVEL;
-}
-
 static inline bool kvm_available_flush_tlb_with_range(void)
 {
 	return kvm_x86_ops.tlb_remote_flush_with_range;
@@ -4673,7 +4660,13 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 		role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
 		role.base.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
 		role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
-		role.base.level = role_regs_to_root_level(regs);
+
+		if (____is_efer_lma(regs))
+			role.base.level = ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
+		else if (____is_cr4_pae(regs))
+			role.base.level = PT32E_ROOT_LEVEL;
+		else
+			role.base.level = PT32_ROOT_LEVEL;
 
 		role.ext.cr0_pg = 1;
 		role.ext.cr4_pae = ____is_cr4_pae(regs);
@@ -4766,7 +4759,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->root_level = role_regs_to_root_level(regs);
+	context->root_level = cpu_role.base.level;
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
-- 
2.31.1


