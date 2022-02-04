Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E371F4A98B9
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358812AbiBDL5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59405 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358633AbiBDL5e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAlo3b8oAZQXk/zcIbEROEPp7sP/CVGo95J3iYCaLXk=;
        b=ZBgmgggmZ/GGJGHIhk1IYlsGAkZk4QVTeE8Pe6n2N9PyRvdJ+/lgJfdABWppaPkkuOey7/
        jO2LxXJQO5y7Ezhgnjp5JbOj0Bwz/T12pdg31rIn3zrPbJyu3nOLOe05hYnq87OmuHhS1R
        2rq1L1Xh3Mqe1MZED8OpDnhJQ1sKvrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-9Mh7QANsMt61Mk8W0foUMQ-1; Fri, 04 Feb 2022 06:57:30 -0500
X-MC-Unique: 9Mh7QANsMt61Mk8W0foUMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3616A1054F90;
        Fri,  4 Feb 2022 11:57:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC5D36E1F1;
        Fri,  4 Feb 2022 11:57:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 17/23] KVM: MMU: remove redundant bits from extended role
Date:   Fri,  4 Feb 2022 06:57:12 -0500
Message-Id: <20220204115718.14934-18-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before the separation of the CPU and the MMU role, CR0.PG was not
available in the base MMU role, because two-dimensional paging always
used direct=1 in the MMU role.  However, now that the raw role is
snapshotted in mmu->cpu_role, CR0.PG *can* be found (though inverted)
as !cpu_role.base.direct.  There is no need to store it again in union
kvm_mmu_extended_role; instead, write an is_cr0_pg accessor by hand that
takes care of the inversion.

Likewise, CR4.PAE is now always present in the CPU role as
!cpu_role.base.has_4_byte_gpte.  The inversion makes certain tests on
the MMU role easier, and is easily hidden by the is_cr4_pae accessor
when operating on the CPU role.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 --
 arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 121eefdb9991..b0085c54786c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -360,8 +360,6 @@ union kvm_mmu_extended_role {
 	u32 word;
 	struct {
 		unsigned int execonly:1;
-		unsigned int cr0_pg:1;
-		unsigned int cr4_pae:1;
 		unsigned int cr4_pse:1;
 		unsigned int cr4_pke:1;
 		unsigned int cr4_smap:1;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0cb46a74e561..b3856551607d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -232,16 +232,24 @@ static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
 {								\
 	return !!(mmu->cpu_role. base_or_ext . reg##_##name);	\
 }
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
 BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pae);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
 BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
 
+static inline bool is_cr0_pg(struct kvm_mmu *mmu)
+{
+	return !(mmu->cpu_role.base.direct);
+}
+
+static inline bool is_cr4_pae(struct kvm_mmu *mmu)
+{
+	return !(mmu->cpu_role.base.has_4_byte_gpte);
+}
+
 static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_role_regs regs = {
@@ -4668,8 +4676,6 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 		else
 			role.base.level = PT32_ROOT_LEVEL;
 
-		role.ext.cr0_pg = 1;
-		role.ext.cr4_pae = ____is_cr4_pae(regs);
 		role.ext.cr4_smep = ____is_cr4_smep(regs);
 		role.ext.cr4_smap = ____is_cr4_smap(regs);
 		role.ext.cr4_pse = ____is_cr4_pse(regs);
-- 
2.31.1


