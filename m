Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74814A98A6
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358602AbiBDL5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358520AbiBDL5Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzIDUAXsJoa+BiSWuGe751GcZgmjbrKEWZp98e47DYA=;
        b=WzzoMiGSiK9v3U3Yh76yNCtUlY2smOvrpOlCSOf1nBeXJ7q27r07nXPHFcGBjG4w316E7O
        VBrPyJvVYqW7ZLym2UUGOM06b+04FqlIZBQuqefKFymksapLHOy9bp55jSq72Xem1IKTE4
        R8SJrSV29+6psOlmSXufR0P9nO85J04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-ziQl9z8bOUeB2IVJ1VGaRQ-1; Fri, 04 Feb 2022 06:57:23 -0500
X-MC-Unique: ziQl9z8bOUeB2IVJ1VGaRQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B05268710F8;
        Fri,  4 Feb 2022 11:57:22 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 429281084184;
        Fri,  4 Feb 2022 11:57:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 06/23] KVM: MMU: load new PGD once nested two-dimensional paging is initialized
Date:   Fri,  4 Feb 2022 06:57:01 -0500
Message-Id: <20220204115718.14934-7-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__kvm_mmu_new_pgd looks at the MMU's root_level and shadow_root_level
via fast_pgd_switch.  It makes no sense to call it before updating
these fields, even though it was done like that ever since nested
VMX grew the ability to use fast CR3 switch (commit 50c28f21d045,
"kvm: x86: Use fast CR3 switch for nested VMX").

Pull it to the end of the initialization of the shadow nested MMUs.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 577e70509510..b8ab16323629 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4869,10 +4869,9 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 
 	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
 
-	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
-
 	shadow_mmu_init_context(vcpu, context, &regs, new_role);
 	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
+	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
@@ -4906,27 +4905,25 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
-
-	if (new_role.as_u64 == context->mmu_role.as_u64)
-		return;
-
-	context->mmu_role.as_u64 = new_role.as_u64;
-
-	context->shadow_root_level = level;
-
-	context->ept_ad = accessed_dirty;
-	context->page_fault = ept_page_fault;
-	context->gva_to_gpa = ept_gva_to_gpa;
-	context->sync_page = ept_sync_page;
-	context->invlpg = ept_invlpg;
-	context->root_level = level;
-	context->direct_map = false;
+	if (new_role.as_u64 != context->mmu_role.as_u64) {
+		context->mmu_role.as_u64 = new_role.as_u64;
+
+		context->shadow_root_level = level;
+
+		context->ept_ad = accessed_dirty;
+		context->page_fault = ept_page_fault;
+		context->gva_to_gpa = ept_gva_to_gpa;
+		context->sync_page = ept_sync_page;
+		context->invlpg = ept_invlpg;
+		context->root_level = level;
+		context->direct_map = false;
+		update_permission_bitmask(context, true);
+		context->pkru_mask = 0;
+		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
+		reset_ept_shadow_zero_bits_mask(context, execonly);
+	}
 
-	update_permission_bitmask(context, true);
-	context->pkru_mask = 0;
-	reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
-	reset_ept_shadow_zero_bits_mask(context, execonly);
+	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
-- 
2.31.1


