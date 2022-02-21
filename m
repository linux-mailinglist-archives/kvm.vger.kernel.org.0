Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4A54BDC84
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380378AbiBUQYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:24:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380258AbiBUQXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E15827152
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZC/3vO6f2ZKAzs9BdN9A8dm2vBnERQMJFs75uTXpSKk=;
        b=TWrDlZe7FePybEGVHFI1sUAb4re0PH+ybNkUl+omwCnQIAfvn/JpbZfjgKj0I1w2kpN+7s
        26IM8ihVe9R2pL0TLveaqpJAWnOFn5JnVR346PEbpV42sfGDlAhHk7iTRBGeI7jJISfcel
        B+bU7RSSmh9sv2dGKj4qyYdDvScXmKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-16XvRrf_M7i11pCLtcOs7g-1; Mon, 21 Feb 2022 11:22:55 -0500
X-MC-Unique: 16XvRrf_M7i11pCLtcOs7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE5941091DA4;
        Mon, 21 Feb 2022 16:22:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FE5484A1C;
        Mon, 21 Feb 2022 16:22:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 20/25] KVM: x86/mmu: pull CPU mode computation to kvm_init_mmu
Date:   Mon, 21 Feb 2022 11:22:38 -0500
Message-Id: <20220221162243.683208-21-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 47288643ab70..a7028c2ae5c7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4734,11 +4734,9 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	return role;
 }
 
-static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
-			     const struct kvm_mmu_role_regs *regs)
+static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode cpu_mode)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
 	union kvm_mmu_page_role root_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_mode);
 
 	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
@@ -4794,10 +4792,9 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
-				const struct kvm_mmu_role_regs *regs)
+				union kvm_mmu_paging_mode cpu_mode)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
 	union kvm_mmu_page_role root_role;
 
 	root_role = cpu_mode.base;
@@ -4895,20 +4892,19 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
-			     const struct kvm_mmu_role_regs *regs)
+			     union kvm_mmu_paging_mode cpu_mode)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 
-	kvm_init_shadow_mmu(vcpu, regs);
+	kvm_init_shadow_mmu(vcpu, cpu_mode);
 
 	context->get_guest_pgd	   = kvm_get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault_shadow;
 }
 
-static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
+static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode new_mode)
 {
-	union kvm_mmu_paging_mode new_mode = kvm_calc_cpu_mode(vcpu, regs);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
 
 	if (new_mode.as_u64 == g_context->cpu_mode.as_u64)
@@ -4949,13 +4945,14 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, const struct kvm_mmu_role
 void kvm_init_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
+	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
 
 	if (mmu_is_nested(vcpu))
-		init_kvm_nested_mmu(vcpu, &regs);
+		init_kvm_nested_mmu(vcpu, cpu_mode);
 	else if (tdp_enabled)
-		init_kvm_tdp_mmu(vcpu, &regs);
+		init_kvm_tdp_mmu(vcpu, cpu_mode);
 	else
-		init_kvm_softmmu(vcpu, &regs);
+		init_kvm_softmmu(vcpu, cpu_mode);
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
-- 
2.31.1


