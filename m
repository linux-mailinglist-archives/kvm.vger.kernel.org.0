Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BF31E4B92
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 19:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731215AbgE0RM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 13:12:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:25791 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730006AbgE0RM2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 13:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590599546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0Ma+strw5r3/zerzC9gCl0y+XwFVc4Xo+zlOUjNhXTY=;
        b=godB6zxkcscSCeZrHJ90Xwrk3hc0Ya/Wo6upCywZZjsYetU4EF2pH3DI9XaAbNBvQCxvM3
        J8KO9raB7tLJfc2fTRmhVfj8Gvl4oXH3HFR6EJhOVobQs7lbjnr8HihRkaek0hjv8y88ij
        9YNkGtk51zAwPxxFCYM2dAQapR8zjwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-3CpxfOFBMOmIMhUA1TfO8A-1; Wed, 27 May 2020 13:12:21 -0400
X-MC-Unique: 3CpxfOFBMOmIMhUA1TfO8A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2AB3253;
        Wed, 27 May 2020 17:12:20 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9F4F5D9E5;
        Wed, 27 May 2020 17:12:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: simplify is_mmio_spte
Date:   Wed, 27 May 2020 13:12:19 -0400
Message-Id: <20200527171219.130319-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can simply look at bits 52-53 to identify MMIO entries in KVM's page
tables.  Therefore, there is no need to pass a mask to kvm_mmu_set_mmio_spte_mask.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h     |  2 +-
 arch/x86/kvm/mmu/mmu.c | 10 +++-------
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  3 +--
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 8a3b1bce722a..048e865ad485 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -51,7 +51,7 @@ static inline u64 rsvd_bits(int s, int e)
 	return ((1ULL << (e - s + 1)) - 1) << s;
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask);
+void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask);
 
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 92d056954194..bef05a437a89 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -244,7 +244,6 @@ static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
 static u64 __read_mostly shadow_accessed_mask;
 static u64 __read_mostly shadow_dirty_mask;
-static u64 __read_mostly shadow_mmio_mask;
 static u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_mmio_access_mask;
 static u64 __read_mostly shadow_present_mask;
@@ -331,21 +330,19 @@ static void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_range(kvm, &range);
 }
 
-void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask)
+void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
-	BUG_ON((mmio_mask & mmio_value) != mmio_value);
 	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << shadow_nonpresent_or_rsvd_mask_len));
 	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
 	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
-	shadow_mmio_mask = mmio_mask | SPTE_SPECIAL_MASK;
 	shadow_mmio_access_mask = access_mask;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
 static bool is_mmio_spte(u64 spte)
 {
-	return (spte & shadow_mmio_mask) == shadow_mmio_value;
+	return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
 }
 
 static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
@@ -568,7 +565,6 @@ static void kvm_mmu_reset_all_pte_masks(void)
 	shadow_dirty_mask = 0;
 	shadow_nx_mask = 0;
 	shadow_x_mask = 0;
-	shadow_mmio_mask = 0;
 	shadow_present_mask = 0;
 	shadow_acc_track_mask = 0;
 
@@ -6154,7 +6150,7 @@ static void kvm_set_mmio_spte_mask(void)
 	else
 		mask = 0;
 
-	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);
+	kvm_mmu_set_mmio_spte_mask(mask, ACC_WRITE_MASK | ACC_USER_MASK);
 }
 
 static bool get_nx_auto_mode(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a862c768fd54..3c9b321a420a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -780,7 +780,7 @@ static __init void svm_adjust_mmio_mask(void)
 	 */
 	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
 
-	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
+	kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);
 }
 
 static void svm_hardware_teardown(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9b63ac8d97ee..65ff16f00c08 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4147,8 +4147,7 @@ static void ept_set_mmio_spte_mask(void)
 	 * EPT Misconfigurations can be generated if the value of bits 2:0
 	 * of an EPT paging-structure entry is 110b (write/execute).
 	 */
-	kvm_mmu_set_mmio_spte_mask(VMX_EPT_RWX_MASK,
-				   VMX_EPT_MISCONFIG_WX_VALUE, 0);
+	kvm_mmu_set_mmio_spte_mask(VMX_EPT_MISCONFIG_WX_VALUE, 0);
 }
 
 #define VMX_XSS_EXIT_BITMAP 0
-- 
2.26.2

