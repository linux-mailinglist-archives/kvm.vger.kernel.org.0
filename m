Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B837F4AF76E
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237693AbiBIRA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbiBIRAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:00:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C13CEC05CB9A
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=maNLEYrkI9/B7Gp1A8K9ykB0aRV+CgOE/hJeFpDr/sg=;
        b=eivZxkuQej4XxkAqU9jSTH9raTUmZEE2rqpKAv7hXL/RrBt/i0R5ToR6ffejuoRvBYcPiS
        NfYMW9bCHeFSVKoZMglTaXma6CYvdVg+JSxLvQ6Kvm12fF1Z5suZWGtCl5xCs2Y+zaNToD
        3lNSFPaOM6VDLeOvx/tZoXqdPWKG53M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-IT82pY6aOeenyWtwkXPNyg-1; Wed, 09 Feb 2022 12:00:50 -0500
X-MC-Unique: IT82pY6aOeenyWtwkXPNyg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35C388145EB;
        Wed,  9 Feb 2022 17:00:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E5017CD66;
        Wed,  9 Feb 2022 17:00:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com
Subject: [PATCH 02/12] KVM: MMU: move MMU role accessors to header
Date:   Wed,  9 Feb 2022 12:00:10 -0500
Message-Id: <20220209170020.1775368-3-pbonzini@redhat.com>
In-Reply-To: <20220209170020.1775368-1-pbonzini@redhat.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We will use is_cr0_pg to check whether a page fault can be delivered.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h     | 21 +++++++++++++++++++++
 arch/x86/kvm/mmu/mmu.c | 21 ---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index a5a50cfeffff..b9d06a218b2c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -65,6 +65,27 @@ static __always_inline u64 rsvd_bits(int s, int e)
 	return ((2ULL << (e - s)) - 1) << s;
 }
 
+/*
+ * The MMU itself (with a valid role) is the single source of truth for the
+ * MMU.  Do not use the regs used to build the MMU/role, nor the vCPU.  The
+ * regs don't account for dependencies, e.g. clearing CR4 bits if CR0.PG=1,
+ * and the vCPU may be incorrect/irrelevant.
+ */
+#define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
+static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
+{								\
+	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
+}
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
+BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pae);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
+BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 296f8723f9ae..e0c0f0bc2e8b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -223,27 +223,6 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, la57, X86_CR4_LA57);
 BUILD_MMU_ROLE_REGS_ACCESSOR(efer, nx, EFER_NX);
 BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
 
-/*
- * The MMU itself (with a valid role) is the single source of truth for the
- * MMU.  Do not use the regs used to build the MMU/role, nor the vCPU.  The
- * regs don't account for dependencies, e.g. clearing CR4 bits if CR0.PG=1,
- * and the vCPU may be incorrect/irrelevant.
- */
-#define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
-static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
-{								\
-	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
-}
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
-BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pae);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
-BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
-
 static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_role_regs regs = {
-- 
2.31.1


