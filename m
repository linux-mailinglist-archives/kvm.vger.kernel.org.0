Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353374BDDCE
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380264AbiBUQXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380207AbiBUQXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4AE972717F
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FTGaq+J16vxVuhexbjLIY//LQWKKBD2mHulNQ/IMUkQ=;
        b=SzYcdwtDxpiwZPef4CseygzguRdMCD5lHdfgY0B/LkjJXRSTATRvKAoOXRz8BdRO+hiBDt
        I7KrBjOIlHf0VM3WKpJmlK8j1N1jkb3iAB8qIpAcvehMxRIZzTxLAqDHWjczf8vc/Jsvhz
        DtPlJXndvE6nhyTfGpZPaouWPwGnulw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-1bNqFLkCMx6UFzMmAR0Gkw-1; Mon, 21 Feb 2022 11:22:47 -0500
X-MC-Unique: 1bNqFLkCMx6UFzMmAR0Gkw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3F5C2F4A;
        Mon, 21 Feb 2022 16:22:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86AB577468;
        Mon, 21 Feb 2022 16:22:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 04/25] KVM: x86/mmu: pull computation of kvm_mmu_role_regs to kvm_init_mmu
Date:   Mon, 21 Feb 2022 11:22:22 -0500
Message-Id: <20220221162243.683208-5-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The init_kvm_*mmu functions, with the exception of shadow NPT,
do not need to know the full values of CR0/CR4/EFER; they only
need to know the bits that make up the "role".  This cleanup
however will take quite a few incremental steps.  As a start,
pull the common computation of the struct kvm_mmu_role_regs
into their caller: all of them extract the struct from the vcpu
as the very first step.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 97566ac539e3..0e393506f4df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4753,12 +4753,12 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	return role;
 }
 
-static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
+static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
+			     const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
 	union kvm_mmu_role new_role =
-		kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, false);
+		kvm_calc_tdp_mmu_root_page_role(vcpu, regs, false);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
@@ -4772,7 +4772,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_guest_pgd = kvm_get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->root_level = role_regs_to_root_level(&regs);
+	context->root_level = role_regs_to_root_level(regs);
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -4941,12 +4941,12 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
-static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
+static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
+			     const struct kvm_mmu_role_regs *regs)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
 
-	kvm_init_shadow_mmu(vcpu, &regs);
+	kvm_init_shadow_mmu(vcpu, regs);
 
 	context->get_guest_pgd	   = kvm_get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
@@ -4970,10 +4970,9 @@ kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *
 	return role;
 }
 
-static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
+static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
-	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
-	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, &regs);
+	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_role.as_u64 == g_context->mmu_role.as_u64)
@@ -5013,12 +5012,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu)
 {
+	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
+
 	if (mmu_is_nested(vcpu))
-		init_kvm_nested_mmu(vcpu);
+		init_kvm_nested_mmu(vcpu, &regs);
 	else if (tdp_enabled)
-		init_kvm_tdp_mmu(vcpu);
+		init_kvm_tdp_mmu(vcpu, &regs);
 	else
-		init_kvm_softmmu(vcpu);
+		init_kvm_softmmu(vcpu, &regs);
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
-- 
2.31.1


