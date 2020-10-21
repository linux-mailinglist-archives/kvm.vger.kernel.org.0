Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C44295449
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 23:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506257AbgJUVga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 17:36:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506253AbgJUVga (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 17:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603316187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TjNvZMlAC1VHWvy6fPJdhxQ1pl47H3dCj3CRkqJSM6E=;
        b=jNsbhiD/Pw8nDoJsdssoq4OE9RF3xBmpBDVqxReQ0+nmxyPl3e9xfsTOc0KrcGhr2+/oCi
        kndCqIBrEKpZW1hSmYo4nCFii5+SXAwaptG0UQg1XWvEN1fjjZir/ng3KWszt52taGWvzs
        ALmgKBFJdrRGqtL8R7XkLKyh+prlkzk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-NFCCwN2LO-mnO7dEk3WBkg-1; Wed, 21 Oct 2020 17:36:25 -0400
X-MC-Unique: NFCCwN2LO-mnO7dEk3WBkg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5266A18C5200;
        Wed, 21 Oct 2020 21:36:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 439C719C78;
        Wed, 21 Oct 2020 21:36:20 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     graf@amazon.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH] KVM: VMX: Ignore userspace MSR filters for x2APIC
Date:   Wed, 21 Oct 2020 17:36:19 -0400
Message-Id: <20201021213619.2377276-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Rework the resetting of the MSR bitmap for x2APIC MSRs to ignore userspace
filtering.  Allowing userspace to intercept reads to x2APIC MSRs when
APICV is fully enabled for the guest simply can't work; the LAPIC and thus
virtual APIC is in-kernel and cannot be directly accessed by userspace.
To keep things simple we will in fact forbid intercepting x2APIC MSRs
altogether, independent of the default_allow setting.

Cc: Alexander Graf <graf@amazon.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20201005195532.8674-3-sean.j.christopherson@intel.com>
[Modified to operate even if APICv is disabled, adjust documentation. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 27 +++++++++++---------
 arch/x86/kvm/vmx/vmx.c         | 45 ++++++++++++++++++++++------------
 arch/x86/kvm/x86.c             |  4 +--
 3 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 425325ff4434..bd94105f2960 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4735,37 +4735,37 @@ KVM_PV_VM_VERIFY
 	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
   };
 
-flags values for struct kvm_msr_filter_range:
+flags values for ``struct kvm_msr_filter_range``:
 
-KVM_MSR_FILTER_READ
+``KVM_MSR_FILTER_READ``
 
   Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
   indicates that a read should immediately fail, while a 1 indicates that
   a read for a particular MSR should be handled regardless of the default
   filter action.
 
-KVM_MSR_FILTER_WRITE
+``KVM_MSR_FILTER_WRITE``
 
   Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
   indicates that a write should immediately fail, while a 1 indicates that
   a write for a particular MSR should be handled regardless of the default
   filter action.
 
-KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE
+``KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE``
 
   Filter both read and write accesses to MSRs using the given bitmap. A 0
   in the bitmap indicates that both reads and writes should immediately fail,
   while a 1 indicates that reads and writes for a particular MSR are not
   filtered by this range.
 
-flags values for struct kvm_msr_filter:
+flags values for ``struct kvm_msr_filter``:
 
-KVM_MSR_FILTER_DEFAULT_ALLOW
+``KVM_MSR_FILTER_DEFAULT_ALLOW``
 
   If no filter range matches an MSR index that is getting accessed, KVM will
   fall back to allowing access to the MSR.
 
-KVM_MSR_FILTER_DEFAULT_DENY
+``KVM_MSR_FILTER_DEFAULT_DENY``
 
   If no filter range matches an MSR index that is getting accessed, KVM will
   fall back to rejecting access to the MSR. In this mode, all MSRs that should
@@ -4775,14 +4775,19 @@ This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
 specify whether a certain MSR access should be explicitly filtered for or not.
 
 If this ioctl has never been invoked, MSR accesses are not guarded and the
-old KVM in-kernel emulation behavior is fully preserved.
+default KVM in-kernel emulation behavior is fully preserved.
 
 As soon as the filtering is in place, every MSR access is processed through
-the filtering. If a bit is within one of the defined ranges, read and write
+the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff);
+x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
+and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
+register.
+
+If a bit is within one of the defined ranges, read and write
 accesses are guarded by the bitmap's value for the MSR index. If it is not
 defined in any range, whether MSR access is rejected is determined by the flags
-field in the kvm_msr_filter struct: KVM_MSR_FILTER_DEFAULT_ALLOW and
-KVM_MSR_FILTER_DEFAULT_DENY.
+field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW`` and
+``KVM_MSR_FILTER_DEFAULT_DENY``.
 
 Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
 filtering. In that mode, KVM_MSR_FILTER_DEFAULT_DENY no longer has any effect.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4797ec92c88c..132a8cc9f9a4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3782,28 +3782,41 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 	return mode;
 }
 
-static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
+static void vmx_reset_x2apic_msrs(struct kvm_vcpu *vcpu, u8 mode)
 {
+	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
+	unsigned long read_intercept;
 	int msr;
 
-	for (msr = 0x800; msr <= 0x8ff; msr++) {
-		bool apicv = !!(mode & MSR_BITMAP_MODE_X2APIC_APICV);
+	read_intercept = (mode & MSR_BITMAP_MODE_X2APIC_APICV) ? 0 : ~0;
+
+	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
+		unsigned int read_idx = msr / BITS_PER_LONG;
+		unsigned int write_idx = read_idx + (0x800 / sizeof(long));
 
-		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_R, !apicv);
-		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_W, true);
+		msr_bitmap[read_idx] = read_intercept;
+		msr_bitmap[write_idx] = ~0ul;
 	}
+}
 
-	if (mode & MSR_BITMAP_MODE_X2APIC) {
-		/*
-		 * TPR reads and writes can be virtualized even if virtual interrupt
-		 * delivery is not in use.
-		 */
-		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW);
-		if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
-			vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
-			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
-			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
-		}
+static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
+{
+	if (!cpu_has_vmx_msr_bitmap())
+		return;
+
+	vmx_reset_x2apic_msrs(vcpu, mode);
+
+	/*
+	 * TPR reads and writes can be virtualized even if virtual interrupt
+	 * delivery is not in use.
+	 */
+	vmx_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW,
+				  !(mode & MSR_BITMAP_MODE_X2APIC));
+
+	if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
+		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
+		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c4015a43cc8a..08cfb5e4bd07 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1497,8 +1497,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 	bool r = kvm->arch.msr_filter.default_allow;
 	int idx;
 
-	/* MSR filtering not set up, allow everything */
-	if (!count)
+	/* MSR filtering not set up or x2APIC enabled, allow everything */
+	if (!count || (index >= 0x800 && index <= 0x8ff))
 		return true;
 
 	/* Prevent collision with set_msr_filter */
-- 
2.26.2

