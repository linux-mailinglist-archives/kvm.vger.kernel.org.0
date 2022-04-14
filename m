Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23F950074A
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240578AbiDNHn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240471AbiDNHmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACBB356C11
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=StKL8wBLFuz+JBSqbcoQ4KdZ20uKl8Zl8ZBV7e3EAAw=;
        b=Ys3TDeIZwbawniKKVUSgo6TdkgU5BBp+HwkiKFgDkifvDX6A/0kZjc+7dzuKu5nE5l7YHd
        TmK5sJFKpKyX63SU7lGmfjGUsxi1zHdOKBB9TcG98gY/W7PtLZA6xUF88EEblB2dH+FW0W
        mDvnXI+BfZpo9MbNLuTRppmhR4jhqec=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-RuHUpxrFNvWC1e3WwDO-ZA-1; Thu, 14 Apr 2022 03:40:03 -0400
X-MC-Unique: RuHUpxrFNvWC1e3WwDO-ZA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1854811E80;
        Thu, 14 Apr 2022 07:40:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3C1FC28100;
        Thu, 14 Apr 2022 07:40:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 10/22] KVM: x86/mmu: remove kvm_calc_shadow_root_page_role_common
Date:   Thu, 14 Apr 2022 03:39:48 -0400
Message-Id: <20220414074000.31438-11-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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

kvm_calc_shadow_root_page_role_common is the same as
kvm_calc_cpu_role except for the level, which is overwritten
afterwards in kvm_calc_shadow_mmu_root_page_role
and kvm_calc_shadow_npt_root_page_role.

role.base.direct is already set correctly for the CPU role,
and CR0.PG=1 is required for VMRUN so it will also be
correct for nested NPT.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fddc8a3237b0..3f712d2de0ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4824,28 +4824,14 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	reset_tdp_shadow_zero_bits_mask(context);
 }
 
-static union kvm_mmu_role
-kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
-				      const struct kvm_mmu_role_regs *regs)
-{
-	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, regs);
-
-	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
-	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
-	role.base.has_4_byte_gpte = ____is_cr0_pg(regs) && !____is_cr4_pae(regs);
-
-	return role;
-}
-
 static union kvm_mmu_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				   const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, regs);
-
-	role.base.direct = !____is_cr0_pg(regs);
+	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
+	union kvm_mmu_role role;
 
+	role = cpu_role;
 	if (!____is_efer_lma(regs))
 		role.base.level = PT32E_ROOT_LEVEL;
 	else if (____is_cr4_la57(regs))
@@ -4896,10 +4882,11 @@ static union kvm_mmu_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 				   const struct kvm_mmu_role_regs *regs)
 {
-	union kvm_mmu_role role =
-		kvm_calc_shadow_root_page_role_common(vcpu, regs);
+	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
+	union kvm_mmu_role role;
 
-	role.base.direct = false;
+	WARN_ON_ONCE(cpu_role.base.direct);
+	role = cpu_role;
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 
 	return role;
-- 
2.31.1


