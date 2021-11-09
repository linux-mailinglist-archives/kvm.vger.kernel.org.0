Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DE244B12E
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 17:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240026AbhKIQbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 11:31:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240045AbhKIQbn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Nov 2021 11:31:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636475337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zQZwHTdTsUweNWTXKd5s3LRpHFg1kPvveqpgGThpubI=;
        b=McjSPz+GZ+1dCF+47hhtq0hlj/qy/ab2XRtZAD64i+uDnHtZKQ4/bslw52Df/U2p2f7uNz
        GvtNgsnrA8krhr12TSR+ujiHUroo1UHsAsdfRRYFEeb/kab5pkRN9c7o187i9b3gDurEMg
        WCJ7/IlGcl+aM7zPPH+iZwGbqvHPPDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-P7v9tu1HNVmfsTIwLwFGqg-1; Tue, 09 Nov 2021 11:28:54 -0500
X-MC-Unique: P7v9tu1HNVmfsTIwLwFGqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE3DA8799EB;
        Tue,  9 Nov 2021 16:28:52 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D946C62A44;
        Tue,  9 Nov 2021 16:28:50 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/8] KVM: nVMX: Clean up x2APIC MSR handling for L2
Date:   Tue,  9 Nov 2021 17:28:31 +0100
Message-Id: <20211109162835.99475-5-vkuznets@redhat.com>
In-Reply-To: <20211109162835.99475-1-vkuznets@redhat.com>
References: <20211109162835.99475-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Clean up the x2APIC MSR bitmap intereption code for L2, which is the last
holdout of open coded bitmap manipulations.  Freshen up the SDM/PRM
comment, rename the function to make it abundantly clear the funky
behavior is x2APIC specific, and explain _why_ vmcs01's bitmap is ignored
(the previous comment was flat out wrong for x2APIC behavior).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 53 +++++++++++----------------------------
 arch/x86/kvm/vmx/vmx.h    |  8 ++++++
 2 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c569a135ca48..341c50816822 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -525,44 +525,19 @@ static int nested_vmx_check_tpr_shadow_controls(struct kvm_vcpu *vcpu,
 }
 
 /*
- * If a msr is allowed by L0, we should check whether it is allowed by L1.
- * The corresponding bit will be cleared unless both of L0 and L1 allow it.
+ * For x2APIC MSRs, ignore the vmcs01 bitmap.  L1 can enable x2APIC without L1
+ * itself utilizing x2APIC.  All MSRs were previously set to be intercepted,
+ * only the "disable intercept" case needs to be handled.
  */
-static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
-					       unsigned long *msr_bitmap_nested,
-					       u32 msr, int type)
+static void nested_vmx_disable_intercept_for_x2apic_msr(unsigned long *msr_bitmap_l1,
+							unsigned long *msr_bitmap_l0,
+							u32 msr, int type)
 {
-	int f = sizeof(unsigned long);
+	if (type & MSR_TYPE_R && !vmx_test_msr_bitmap_read(msr_bitmap_l1, msr))
+		vmx_clear_msr_bitmap_read(msr_bitmap_l0, msr);
 
-	/*
-	 * See Intel PRM Vol. 3, 20.6.9 (MSR-Bitmap Address). Early manuals
-	 * have the write-low and read-high bitmap offsets the wrong way round.
-	 * We can control MSRs 0x00000000-0x00001fff and 0xc0000000-0xc0001fff.
-	 */
-	if (msr <= 0x1fff) {
-		if (type & MSR_TYPE_R &&
-		   !test_bit(msr, msr_bitmap_l1 + 0x000 / f))
-			/* read-low */
-			__clear_bit(msr, msr_bitmap_nested + 0x000 / f);
-
-		if (type & MSR_TYPE_W &&
-		   !test_bit(msr, msr_bitmap_l1 + 0x800 / f))
-			/* write-low */
-			__clear_bit(msr, msr_bitmap_nested + 0x800 / f);
-
-	} else if ((msr >= 0xc0000000) && (msr <= 0xc0001fff)) {
-		msr &= 0x1fff;
-		if (type & MSR_TYPE_R &&
-		   !test_bit(msr, msr_bitmap_l1 + 0x400 / f))
-			/* read-high */
-			__clear_bit(msr, msr_bitmap_nested + 0x400 / f);
-
-		if (type & MSR_TYPE_W &&
-		   !test_bit(msr, msr_bitmap_l1 + 0xc00 / f))
-			/* write-high */
-			__clear_bit(msr, msr_bitmap_nested + 0xc00 / f);
-
-	}
+	if (type & MSR_TYPE_W && !vmx_test_msr_bitmap_write(msr_bitmap_l1, msr))
+		vmx_clear_msr_bitmap_write(msr_bitmap_l0, msr);
 }
 
 static inline void enable_x2apic_msr_intercepts(unsigned long *msr_bitmap)
@@ -631,7 +606,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
 	 * 4-byte writes on 32-bit systems) up front to enable intercepts for
-	 * the x2APIC MSR range and selectively disable them below.
+	 * the x2APIC MSR range and selectively toggle those relevant to L2.
 	 */
 	enable_x2apic_msr_intercepts(msr_bitmap_l0);
 
@@ -650,17 +625,17 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 			}
 		}
 
-		nested_vmx_disable_intercept_for_msr(
+		nested_vmx_disable_intercept_for_x2apic_msr(
 			msr_bitmap_l1, msr_bitmap_l0,
 			X2APIC_MSR(APIC_TASKPRI),
 			MSR_TYPE_R | MSR_TYPE_W);
 
 		if (nested_cpu_has_vid(vmcs12)) {
-			nested_vmx_disable_intercept_for_msr(
+			nested_vmx_disable_intercept_for_x2apic_msr(
 				msr_bitmap_l1, msr_bitmap_l0,
 				X2APIC_MSR(APIC_EOI),
 				MSR_TYPE_W);
-			nested_vmx_disable_intercept_for_msr(
+			nested_vmx_disable_intercept_for_x2apic_msr(
 				msr_bitmap_l1, msr_bitmap_l0,
 				X2APIC_MSR(APIC_SELF_IPI),
 				MSR_TYPE_W);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 83a14b61c80f..86c093da0d63 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -400,6 +400,14 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
+/*
+ * Note, early Intel manuals have the write-low and read-high bitmap offsets
+ * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and
+ * 0xc0000000-0xc0001fff.  The former (low) uses bytes 0-0x3ff for reads and
+ * 0x800-0xbff for writes.  The latter (high) uses 0x400-0x7ff for reads and
+ * 0xc00-0xfff for writes.  MSRs not covered by either of the ranges always
+ * VM-Exit.
+ */
 #define __BUILD_VMX_MSR_BITMAP_HELPER(rtype, action, bitop, access, base)      \
 static inline rtype vmx_##action##_msr_bitmap_##access(unsigned long *bitmap,  \
 						       u32 msr)		       \
-- 
2.31.1

