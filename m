Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C49F500746
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240624AbiDNHnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240483AbiDNHmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FE1B56201
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EWcpCvivQTVSzyazYGHjZpqxx/Mo5fOAnGDba/85XNc=;
        b=FiQlMiJvO1KzhI80bSvPa4CLJjW0lGo7H7twu57CfaLRVzSH5A6HRAJZ9uBs30K73sLaQC
        3nuG2eK3QZB8ejMhb8nWGDvJbS7+qKqX2d+MhYs78g1Ep4VbP3CzoyrAo5atlFaq3OT1CR
        77toTCsXhHJTBV7Veljxr+uKKEa/Kks=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-Fjn9UIIXP0GhGrm9QXzvxA-1; Thu, 14 Apr 2022 03:40:04 -0400
X-MC-Unique: Fjn9UIIXP0GhGrm9QXzvxA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A2DC19705DF;
        Thu, 14 Apr 2022 07:40:04 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E5C1C28109;
        Thu, 14 Apr 2022 07:40:04 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 19/22] KVM: x86/mmu: pull CPU mode computation to kvm_init_mmu
Date:   Thu, 14 Apr 2022 03:39:57 -0400
Message-Id: <20220414074000.31438-20-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not lead init_kvm_*mmu into the temptation of poking
into struct kvm_mmu_role_regs, by passing to it directly
the CPU mode.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f22aa9970356..b75e50f3a025 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4764,10 +4764,9 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 }
 
 static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
-			     const struct kvm_mmu_role_regs *regs)
+			     union kvm_cpu_role cpu_role)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_cpu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_page_role root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_role);
 
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
@@ -4823,10 +4822,9 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
-				const struct kvm_mmu_role_regs *regs)
+				union kvm_cpu_role cpu_role)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_cpu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
 	union kvm_mmu_page_role root_role;
 
 	root_role = cpu_role.base;
@@ -4929,11 +4927,11 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
-			     const struct kvm_mmu_role_regs *regs)
+			     union kvm_cpu_role cpu_role)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 
-	kvm_init_shadow_mmu(vcpu, regs);
+	kvm_init_shadow_mmu(vcpu, cpu_role);
 
 	context->get_guest_pgd     = get_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
@@ -4941,9 +4939,8 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
 }
 
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
-				const struct kvm_mmu_role_regs *regs)
+				union kvm_cpu_role new_mode)
 {
-	union kvm_cpu_role new_mode = kvm_calc_cpu_role(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_mode.as_u64 == g_context->cpu_role.as_u64)
@@ -4984,13 +4981,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu,
 void kvm_init_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
+	union kvm_cpu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
 
 	if (mmu_is_nested(vcpu))
-		init_kvm_nested_mmu(vcpu, &regs);
+		init_kvm_nested_mmu(vcpu, cpu_role);
 	else if (tdp_enabled)
-		init_kvm_tdp_mmu(vcpu, &regs);
+		init_kvm_tdp_mmu(vcpu, cpu_role);
 	else
-		init_kvm_softmmu(vcpu, &regs);
+		init_kvm_softmmu(vcpu, cpu_role);
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
-- 
2.31.1


