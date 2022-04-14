Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3654500753
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240599AbiDNHnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240466AbiDNHmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98FF2205E0
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o9bQvmPTCK11kqEDs1q9cZ1XNwIKypiXik4QOo0yR6k=;
        b=A1zriwlZZ0Izk3kcxNTklgin2aR85k4tNyBpNKyOSj5+diVO54EFobe/C9YhHcFEh+M4Zk
        AOC65Us/pVIAtB5mfJM7EVyVhBA/TeMhOcmzFJGU/+pG36xWBKs816rt3/zhMrF/8lsZ7a
        14kFCZogN3BISIbaAx+hhLmnjTmPJrU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-UOSB2-7aP6aqQv6pY3HtTA-1; Thu, 14 Apr 2022 03:40:02 -0400
X-MC-Unique: UOSB2-7aP6aqQv6pY3HtTA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAE4B83396B;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97F5B41D40E;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, David Matlack <dmatlack@google.com>
Subject: [PATCH 03/22] KVM: x86/mmu: pull computation of kvm_mmu_role_regs to kvm_init_mmu
Date:   Thu, 14 Apr 2022 03:39:41 -0400
Message-Id: <20220414074000.31438-4-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 07b8550e68e9..d56875938c29 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4778,12 +4778,12 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
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
@@ -4797,7 +4797,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->root_level = role_regs_to_root_level(&regs);
+	context->root_level = role_regs_to_root_level(regs);
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -4966,12 +4966,12 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
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
 
 	context->get_guest_pgd     = get_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
@@ -4995,10 +4995,10 @@ kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *
 	return role;
 }
 
-static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
+static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
+				const struct kvm_mmu_role_regs *regs)
 {
-	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
-	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, &regs);
+	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_role.as_u64 == g_context->mmu_role.as_u64)
@@ -5038,12 +5038,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 
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


