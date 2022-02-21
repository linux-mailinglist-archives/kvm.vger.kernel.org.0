Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0455E4BDF89
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380317AbiBUQXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380221AbiBUQXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E969527170
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAJu1ZYoyOWVoqiIHT/VPmictdwQ4/efd597mncfWaY=;
        b=DBz4UYpFoA2iE7gSVhhUv5bY3HobDHR2ipBB8qsj7b1TQeVXgRNIIQJxyACI4NT5Dnl8Fl
        809mHgaHV/2VNn7DFtn/6TXCKptQ5qqR+6P8kkGYKLIc7A3C6H6rPVMI5l/DxIYxF63sYU
        TEgZb7NaUea10qr3MPk6G1S0Hou7qh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-QdDTdJ1gO7qvY7-tRlUjdg-1; Mon, 21 Feb 2022 11:22:49 -0500
X-MC-Unique: QdDTdJ1gO7qvY7-tRlUjdg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A28531926DA3;
        Mon, 21 Feb 2022 16:22:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4664877468;
        Mon, 21 Feb 2022 16:22:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 09/25] KVM: x86/mmu: do not recompute root level from kvm_mmu_role_regs
Date:   Mon, 21 Feb 2022 11:22:27 -0500
Message-Id: <20220221162243.683208-10-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The root_level can be found in the cpu_mode (in fact the field
is superfluous and could be removed, but one thing at a time).
Since there is only one usage left of role_regs_to_root_level,
inline it into kvm_calc_cpu_mode.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1af898f0cf87..6e539fc2c9c7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -244,19 +244,6 @@ static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
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
@@ -4695,7 +4682,13 @@ kvm_calc_cpu_mode(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
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
@@ -4790,7 +4783,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->get_guest_pgd = kvm_get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->root_level = role_regs_to_root_level(regs);
+	context->root_level = cpu_mode.base.level;
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
-- 
2.31.1


