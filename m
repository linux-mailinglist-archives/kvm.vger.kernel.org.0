Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EA650076C
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbiDNHoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240495AbiDNHmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72ACB49F25
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eqvqj5T+LOq6yAGMZt//QgZxyQ9dWMtUkAV4xPeREAg=;
        b=BfIkO+0x4vZV4aqNwbkJEN03t4i3jcqnW8xXfujwqvvp+cwTlSdpnCKS+toum2MO0I/gmQ
        zlqjR4+hjRsB7RXAUUX9pWpO7lqRec6bp+iDMmc+e9RS7C7hs2YTI4rzv7p09JoQmKZy9F
        s30948OhRLeOL+ZFLDJu28s2Wo5U32Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-MtFxEjoXPXSW_DG4jlReRg-1; Thu, 14 Apr 2022 03:40:04 -0400
X-MC-Unique: MtFxEjoXPXSW_DG4jlReRg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E78EE38149B6;
        Thu, 14 Apr 2022 07:40:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB794C28109;
        Thu, 14 Apr 2022 07:40:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 17/22] KVM: x86/mmu: remove valid from extended role
Date:   Thu, 14 Apr 2022 03:39:55 -0400
Message-Id: <20220414074000.31438-18-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The level and direct field of the CPU role can act as a marker for validity
instead: exactly one of them is guaranteed to be nonzero, so a zero value
for both means that the role is invalid and the MMU properties will be
computed again.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 +---
 arch/x86/kvm/mmu/mmu.c          | 8 +++-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 52ceeadbed28..1356959a2fe1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -347,8 +347,7 @@ union kvm_mmu_page_role {
  * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
  * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
  * including on nested transitions, if nothing in the full role changes then
- * MMU re-configuration can be skipped. @valid bit is set on first usage so we
- * don't treat all-zero structure as valid data.
+ * MMU re-configuration can be skipped.
  *
  * The properties that are tracked in the extended role but not the page role
  * are for things that either (a) do not affect the validity of the shadow page
@@ -365,7 +364,6 @@ union kvm_mmu_page_role {
 union kvm_mmu_extended_role {
 	u32 word;
 	struct {
-		unsigned int valid:1;
 		unsigned int execonly:1;
 		unsigned int cr4_pse:1;
 		unsigned int cr4_pke:1;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cf8a41675a79..33827d1e3d5a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4699,7 +4699,6 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 	role.base.access = ACC_ALL;
 	role.base.smm = is_smm(vcpu);
 	role.base.guest_mode = is_guest_mode(vcpu);
-	role.ext.valid = 1;
 
 	if (!____is_cr0_pg(regs)) {
 		role.base.direct = 1;
@@ -4909,7 +4908,6 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 
 	role.ext.word = 0;
 	role.ext.execonly = execonly;
-	role.ext.valid = 1;
 
 	return role;
 }
@@ -5030,9 +5028,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.root_mmu.root_role.word = 0;
 	vcpu->arch.guest_mmu.root_role.word = 0;
 	vcpu->arch.nested_mmu.root_role.word = 0;
-	vcpu->arch.root_mmu.cpu_role.ext.valid = 0;
-	vcpu->arch.guest_mmu.cpu_role.ext.valid = 0;
-	vcpu->arch.nested_mmu.cpu_role.ext.valid = 0;
+	vcpu->arch.root_mmu.cpu_role.as_u64 = 0;
+	vcpu->arch.guest_mmu.cpu_role.as_u64 = 0;
+	vcpu->arch.nested_mmu.cpu_role.as_u64 = 0;
 	kvm_mmu_reset_context(vcpu);
 
 	/*
-- 
2.31.1


