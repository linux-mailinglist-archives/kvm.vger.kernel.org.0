Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154FC4BE08F
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357036AbiBUQYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:24:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380248AbiBUQXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2137C275C2
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i3nje5ezz2l8EdII+5hi4MIxNm8UaLF4TH8gVbuFagw=;
        b=V4cpdK47fRVuVUnmKhfekpv6Kon+2rNkU9sKacaK2xMX8tRShCt/oY4aqlapQErHNM86xQ
        TVEN/Sv+5ciD/k9+AtJxNfqm/Bl3har1iyKiadbEC5htpahcp92l3ayJCWO7KtlBjFAk/K
        scNomuG3zl4Dh/N2PH7b5ZN2tc+2QVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590--lw84rjrO9OLbYqALxnYAg-1; Mon, 21 Feb 2022 11:22:53 -0500
X-MC-Unique: -lw84rjrO9OLbYqALxnYAg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0EB11091DA1;
        Mon, 21 Feb 2022 16:22:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 826E37611B;
        Mon, 21 Feb 2022 16:22:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 17/25] KVM: x86/mmu: remove redundant bits from extended role
Date:   Mon, 21 Feb 2022 11:22:35 -0500
Message-Id: <20220221162243.683208-18-pbonzini@redhat.com>
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

Before the separation of the CPU and the MMU role, CR0.PG was not
available in the base MMU role, because two-dimensional paging always
used direct=1 in the MMU role.  However, now that the raw role is
snapshotted in mmu->cpu_mode, CR0.PG *can* be found (though inverted)
as !cpu_mode.base.direct.  There is no need to store it again in union
kvm_mmu_extended_role; instead, write an is_cr0_pg accessor by hand that
takes care of the inversion.

Likewise, CR4.PAE is now always present in the CPU mode as
!cpu_mode.base.has_4_byte_gpte.  The inversion makes certain tests on
the MMU role easier, and is easily hidden by the is_cr4_pae accessor
when operating on the CPU mode.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 --
 arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3dbe0be075f5..14f391582738 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -362,8 +362,6 @@ union kvm_mmu_extended_role {
 	struct {
 		unsigned int valid:1;
 		unsigned int execonly:1;
-		unsigned int cr0_pg:1;
-		unsigned int cr4_pae:1;
 		unsigned int cr4_pse:1;
 		unsigned int cr4_pke:1;
 		unsigned int cr4_smap:1;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 61499fd7d017..eb7c62c11700 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -223,16 +223,24 @@ static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
 {								\
 	return !!(mmu->cpu_mode. base_or_ext . reg##_##name);	\
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
+        return !mmu->cpu_mode.base.direct;
+}
+
+static inline bool is_cr4_pae(struct kvm_mmu *mmu)
+{
+        return !mmu->cpu_mode.base.has_4_byte_gpte;
+}
+
 static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_role_regs regs = {
@@ -4681,8 +4689,6 @@ kvm_calc_cpu_mode(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 		else
 			role.base.level = PT32_ROOT_LEVEL;
 
-		role.ext.cr0_pg = 1;
-		role.ext.cr4_pae = ____is_cr4_pae(regs);
 		role.ext.cr4_smep = ____is_cr4_smep(regs);
 		role.ext.cr4_smap = ____is_cr4_smap(regs);
 		role.ext.cr4_pse = ____is_cr4_pse(regs);
-- 
2.31.1


