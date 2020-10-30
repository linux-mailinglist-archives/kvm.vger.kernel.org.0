Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9542B2A0C9C
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 18:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgJ3Rk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 13:40:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbgJ3RkZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 13:40:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604079624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZF7qERUUkIeahbTOL6C12Vf0o83/16+lgKINW+6oyco=;
        b=jWeuNdrAuCdxZT7vF+Yn7oJ8xt4LA3zG2Kv9Cje3uyrUkpeAvqMfYPW3Cv0rLxBGukFKPw
        q5SK+OBaWoWlrhI19xvu7oBhRVE6watPyZH0Un5p0YSHh1XmVhCUWdF1k6B8Zpg18iMSa5
        uEH0kVBjzPxCqkZ6YrHGYGK5siWnNyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-CPmwK-hqOJeHd46fAALIrg-1; Fri, 30 Oct 2020 13:40:16 -0400
X-MC-Unique: CPmwK-hqOJeHd46fAALIrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 957BD192AB64;
        Fri, 30 Oct 2020 17:40:14 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 472555DA2A;
        Fri, 30 Oct 2020 17:40:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: replace static const variables with macros
Date:   Fri, 30 Oct 2020 13:40:13 -0400
Message-Id: <20201030174013.3961199-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even though the compiler is able to replace static const variables with
their value, it will warn about them being unused when Linux is built with W=1.
Use good old macros instead, this is not C++.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c  | 10 +++++-----
 arch/x86/kvm/mmu/spte.c | 16 ++++++++--------
 arch/x86/kvm/mmu/spte.h | 16 ++++++++--------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 17587f496ec7..1f96adff8dc4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -225,7 +225,7 @@ static gfn_t get_mmio_spte_gfn(u64 spte)
 {
 	u64 gpa = spte & shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-	gpa |= (spte >> shadow_nonpresent_or_rsvd_mask_len)
+	gpa |= (spte >> SHADOW_NONPRESENT_OR_RSVD_MASK_LEN)
 	       & shadow_nonpresent_or_rsvd_mask;
 
 	return gpa >> PAGE_SHIFT;
@@ -591,15 +591,15 @@ static u64 mmu_spte_get_lockless(u64 *sptep)
 static u64 restore_acc_track_spte(u64 spte)
 {
 	u64 new_spte = spte;
-	u64 saved_bits = (spte >> shadow_acc_track_saved_bits_shift)
-			 & shadow_acc_track_saved_bits_mask;
+	u64 saved_bits = (spte >> SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
+			 & SHADOW_ACC_TRACK_SAVED_BITS_MASK;
 
 	WARN_ON_ONCE(spte_ad_enabled(spte));
 	WARN_ON_ONCE(!is_access_track_spte(spte));
 
 	new_spte &= ~shadow_acc_track_mask;
-	new_spte &= ~(shadow_acc_track_saved_bits_mask <<
-		      shadow_acc_track_saved_bits_shift);
+	new_spte &= ~(SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
+		      SHADOW_ACC_TRACK_SAVED_BITS_SHIFT);
 	new_spte |= saved_bits;
 
 	return new_spte;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d9c5665a55e9..fcac2cac78fe 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -55,7 +55,7 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
 	mask |= shadow_mmio_value | access;
 	mask |= gpa | shadow_nonpresent_or_rsvd_mask;
 	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
-		<< shadow_nonpresent_or_rsvd_mask_len;
+		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
 
 	return mask;
 }
@@ -231,12 +231,12 @@ u64 mark_spte_for_access_track(u64 spte)
 		  !spte_can_locklessly_be_made_writable(spte),
 		  "kvm: Writable SPTE is not locklessly dirty-trackable\n");
 
-	WARN_ONCE(spte & (shadow_acc_track_saved_bits_mask <<
-			  shadow_acc_track_saved_bits_shift),
+	WARN_ONCE(spte & (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<
+			  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT),
 		  "kvm: Access Tracking saved bit locations are not zero\n");
 
-	spte |= (spte & shadow_acc_track_saved_bits_mask) <<
-		shadow_acc_track_saved_bits_shift;
+	spte |= (spte & SHADOW_ACC_TRACK_SAVED_BITS_MASK) <<
+		SHADOW_ACC_TRACK_SAVED_BITS_SHIFT;
 	spte &= ~shadow_acc_track_mask;
 
 	return spte;
@@ -245,7 +245,7 @@ u64 mark_spte_for_access_track(u64 spte)
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
-	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << shadow_nonpresent_or_rsvd_mask_len));
+	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << SHADOW_NONPRESENT_OR_RSVD_MASK_LEN));
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
 	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
 	shadow_mmio_access_mask = access_mask;
@@ -306,9 +306,9 @@ void kvm_mmu_reset_all_pte_masks(void)
 	low_phys_bits = boot_cpu_data.x86_phys_bits;
 	if (boot_cpu_has_bug(X86_BUG_L1TF) &&
 	    !WARN_ON_ONCE(boot_cpu_data.x86_cache_bits >=
-			  52 - shadow_nonpresent_or_rsvd_mask_len)) {
+			  52 - SHADOW_NONPRESENT_OR_RSVD_MASK_LEN)) {
 		low_phys_bits = boot_cpu_data.x86_cache_bits
-			- shadow_nonpresent_or_rsvd_mask_len;
+			- SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
 		shadow_nonpresent_or_rsvd_mask =
 			rsvd_bits(low_phys_bits, boot_cpu_data.x86_cache_bits - 1);
 	}
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 4ecf40e0b8fe..5c75a451c000 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -104,20 +104,20 @@ extern u64 __read_mostly shadow_acc_track_mask;
  */
 extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 
+/*
+ * The number of high-order 1 bits to use in the mask above.
+ */
+#define SHADOW_NONPRESENT_OR_RSVD_MASK_LEN 5
+
 /*
  * The mask/shift to use for saving the original R/X bits when marking the PTE
  * as not-present for access tracking purposes. We do not save the W bit as the
  * PTEs being access tracked also need to be dirty tracked, so the W bit will be
  * restored only when a write is attempted to the page.
  */
-static const u64 shadow_acc_track_saved_bits_mask = PT64_EPT_READABLE_MASK |
-						    PT64_EPT_EXECUTABLE_MASK;
-static const u64 shadow_acc_track_saved_bits_shift = PT64_SECOND_AVAIL_BITS_SHIFT;
-
-/*
- * The number of high-order 1 bits to use in the mask above.
- */
-static const u64 shadow_nonpresent_or_rsvd_mask_len = 5;
+#define SHADOW_ACC_TRACK_SAVED_BITS_MASK (PT64_EPT_READABLE_MASK | \
+					  PT64_EPT_EXECUTABLE_MASK)
+#define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT PT64_SECOND_AVAIL_BITS_SHIFT
 
 /*
  * In some cases, we need to preserve the GFN of a non-present or reserved
-- 
2.26.2

