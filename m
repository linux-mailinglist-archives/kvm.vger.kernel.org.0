Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CE24BE143
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380336AbiBUQXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380232AbiBUQXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5220727150
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uy3Pyc+4AlM9oZHo3jTP9USfqWRT/Egoz0d9uTiykZ4=;
        b=Qn0GEFjOS64vKWzWerG5m85gjs+ndLokRLwEtmb0WiLolno2wzvIpbbre3qkqk9ea/+WQm
        HbxbX9gd/8R32zHhXCQok8Y0duGzycvtP4/3VH23b3NWCvFLn5EMZO+ZfP6PR4grpg5zw6
        LyXOmhXaZQFQEkowTfU9Scru5GaLgQ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-WGRErQCDNI6jFgr_8R1lRA-1; Mon, 21 Feb 2022 11:22:52 -0500
X-MC-Unique: WGRErQCDNI6jFgr_8R1lRA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E72721006AA5;
        Mon, 21 Feb 2022 16:22:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A6A778AA5;
        Mon, 21 Feb 2022 16:22:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 13/25] KVM: x86/mmu: cleanup computation of MMU roles for shadow paging
Date:   Mon, 21 Feb 2022 11:22:31 -0500
Message-Id: <20220221162243.683208-14-pbonzini@redhat.com>
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

Pass the already-computed CPU mode, instead of redoing it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0a08ab8e2e4e..725aef55c08f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4775,13 +4775,11 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 
 static union kvm_mmu_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
-				   const struct kvm_mmu_role_regs *regs)
+				   union kvm_mmu_role role)
 {
-	union kvm_mmu_role role = kvm_calc_cpu_mode(vcpu, regs);
-
-	if (!____is_efer_lma(regs))
+	if (!role.ext.efer_lma)
 		role.base.level = PT32E_ROOT_LEVEL;
-	else if (____is_cr4_la57(regs))
+	else if (role.ext.cr4_la57)
 		role.base.level = PT64_ROOT_5LEVEL;
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
@@ -4820,18 +4818,15 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
 	union kvm_mmu_role mmu_role =
-		kvm_calc_shadow_mmu_root_page_role(vcpu, regs);
+		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_mode);
 
 	shadow_mmu_init_context(vcpu, context, cpu_mode, mmu_role);
 }
 
 static union kvm_mmu_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
-				   const struct kvm_mmu_role_regs *regs)
+				   union kvm_mmu_role role)
 {
-	union kvm_mmu_role role =
-               kvm_calc_cpu_mode(vcpu, regs);
-
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 
 	return role;
@@ -4847,7 +4842,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.efer = efer,
 	};
 	union kvm_mmu_role cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
-	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);;
+	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_mode);
 
 	shadow_mmu_init_context(vcpu, context, cpu_mode, mmu_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
-- 
2.31.1


