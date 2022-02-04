Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2EF4A98AD
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358686AbiBDL5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358524AbiBDL5Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EpNiTSjqJIiQYBK9fyczhlCSJngnEHfTdSweeKvpGZc=;
        b=XStrKfd77pw8TkrjR3B1fIMDJWNOjeGTgGCvQ7O9PmvEuyikmSwGpiVzB9IKR4GbhGts/f
        3gaF66t3zvqx/DveAVcVDGYcP0LNMOCp6TYxjzrmh1VbDEkVAT/xzhYzYwcAsSMnzpIA4I
        euLCRGA9CnkC2UTSKL/wmW84AvtGYZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-ptUzOL1INVuDCuqhKWQAEA-1; Fri, 04 Feb 2022 06:57:22 -0500
X-MC-Unique: ptUzOL1INVuDCuqhKWQAEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F58F1054F90;
        Fri,  4 Feb 2022 11:57:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 967C81081172;
        Fri,  4 Feb 2022 11:57:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 03/23] KVM: MMU: remove valid from extended role
Date:   Fri,  4 Feb 2022 06:56:58 -0500
Message-Id: <20220204115718.14934-4-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The level field of the MMU role can act as a marker for validity
instead: it is guaranteed to be nonzero so a zero value means the role
is invalid and the MMU properties will be computed again.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 +---
 arch/x86/kvm/mmu/mmu.c          | 9 +++------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e7e5bd9a984d..4ec7d1e3aa36 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -342,8 +342,7 @@ union kvm_mmu_page_role {
  * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
  * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
  * including on nested transitions, if nothing in the full role changes then
- * MMU re-configuration can be skipped. @valid bit is set on first usage so we
- * don't treat all-zero structure as valid data.
+ * MMU re-configuration can be skipped.
  *
  * The properties that are tracked in the extended role but not the page role
  * are for things that either (a) do not affect the validity of the shadow page
@@ -360,7 +359,6 @@ union kvm_mmu_page_role {
 union kvm_mmu_extended_role {
 	u32 word;
 	struct {
-		unsigned int valid:1;
 		unsigned int execonly:1;
 		unsigned int cr0_pg:1;
 		unsigned int cr4_pae:1;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b0065ae3cea8..0039b2f21286 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4683,8 +4683,6 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 		ext.efer_lma = ____is_efer_lma(regs);
 	}
 
-	ext.valid = 1;
-
 	return ext;
 }
 
@@ -4891,7 +4889,6 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
 	role.ext.word = 0;
 	role.ext.execonly = execonly;
-	role.ext.valid = 1;
 
 	return role;
 }
@@ -5039,9 +5036,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * problem is swept under the rug; KVM's CPUID API is horrific and
 	 * it's all but impossible to solve it without introducing a new API.
 	 */
-	vcpu->arch.root_mmu.mmu_role.ext.valid = 0;
-	vcpu->arch.guest_mmu.mmu_role.ext.valid = 0;
-	vcpu->arch.nested_mmu.mmu_role.ext.valid = 0;
+	vcpu->arch.root_mmu.mmu_role.base.level = 0;
+	vcpu->arch.guest_mmu.mmu_role.base.level = 0;
+	vcpu->arch.nested_mmu.mmu_role.base.level = 0;
 	kvm_mmu_reset_context(vcpu);
 
 	/*
-- 
2.31.1


