Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9944A98B2
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358727AbiBDL5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46555 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358587AbiBDL5c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OfQ/zYI/xARDMrodHdk46Yk2GZI0WBamte9e9IL8TAQ=;
        b=ZI8QRy+IR41fVYXHXjl+FfnrOH5xsFGlFliAqzSW+sbfUakJZFnZ51GJcLNmF6DTUT8BMR
        FQfVCL7VVNfNQYHJ3q4ehyZurGuqnsZArCbpv+g4jYSdZAMlvYBfq7lHIB28VieUOOv7UH
        +YBJ1kqy6TPLJwzbQyfV2uxU7qbFdAk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-4SOzFpx2PMmMy3FMcvH2jg-1; Fri, 04 Feb 2022 06:57:30 -0500
X-MC-Unique: 4SOzFpx2PMmMy3FMcvH2jg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C20681054F91;
        Fri,  4 Feb 2022 11:57:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50B496E1EA;
        Fri,  4 Feb 2022 11:57:29 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 18/23] KVM: MMU: fetch shadow EFER.NX from MMU role
Date:   Fri,  4 Feb 2022 06:57:13 -0500
Message-Id: <20220204115718.14934-19-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the MMU role is separate from the CPU role, it contains a
truthful description of the format of the shadow pages.  This includes
whether the shadow pages use the NX bit, so use the MMU role instead of
hardcoding it in the callers of reset_shadow_zero_bits_mask.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b3856551607d..bba712d1a6d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4398,13 +4398,13 @@ static inline u64 reserved_hpa_bits(void)
  * follow the features in guest.
  */
 static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
-					struct kvm_mmu *context,
-					bool uses_nx)
+					struct kvm_mmu *context)
 {
 	/* @amd adds a check on bit of SPTEs, which KVM shouldn't use anyways. */
 	bool is_amd = true;
 	/* KVM doesn't use 2-level page tables for the shadow MMU. */
 	bool is_pse = false;
+	bool uses_nx = context->mmu_role.efer_nx;
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
 
@@ -4810,7 +4810,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	 * NX can be used by any non-nested shadow MMU to avoid having to reset
 	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
 	 */
-	reset_shadow_zero_bits_mask(vcpu, context, true);
+	reset_shadow_zero_bits_mask(vcpu, context);
 }
 
 static union kvm_mmu_page_role
@@ -4834,7 +4834,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	union kvm_mmu_page_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_role);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
-	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
+	reset_shadow_zero_bits_mask(vcpu, context);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
-- 
2.31.1


