Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B74CA283FED
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 21:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgJETz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 15:55:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:42023 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbgJETzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 15:55:54 -0400
IronPort-SDR: THvRdd0BTsWeJXHA1uuRiJbq0EaLCsM97Pl1dOV3MoOsksOLb+ZR6pT89u0h7P+R/AK2+zvWx6
 aihQ/BY5GOhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="181660127"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="181660127"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 12:55:37 -0700
IronPort-SDR: oks1G58Ig037L17T3WhrWzyljR5CTaWaV5j6ZFyDqNKr97d3ytPGeEvEeTJC0asMgVHxHe5sjT
 3U5oqdNIuB5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="353550113"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 05 Oct 2020 12:55:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 2/2] KVM: VMX: Ignore userspace MSR filters for x2APIC when APICV is enabled
Date:   Mon,  5 Oct 2020 12:55:32 -0700
Message-Id: <20201005195532.8674-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005195532.8674-1-sean.j.christopherson@intel.com>
References: <20201005195532.8674-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the resetting of the MSR bitmap for x2APIC MSRs to ignore
userspace filtering when APICV is enabled.  Allowing userspace to
intercept reads to x2APIC MSRs when APICV is fully enabled for the guest
simply can't work.   The LAPIC and thus virtual APIC is in-kernel and
cannot be directly accessed by userspace.  If userspace wants to
intercept x2APIC MSRs, then it should first disable APICV.

Opportunistically change the behavior to reset the full range of MSRs if
and only if APICV is enabled for KVM.  The MSR bitmaps are initialized
to intercept all reads and writes by default, and enable_apicv cannot be
toggled after KVM is loaded.  I.e. if APICV is disabled, simply toggle
the TPR MSR accordingly.

Note, this still allows userspace to intercept reads and writes to TPR,
and writes to EOI and SELF_IPI.  It is at least plausible userspace
interception could work for those registers, though it is still silly.

Cc: Alexander Graf <graf@amazon.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 46 +++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 25ef0b22ac9e..e23c41ccfac9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3782,28 +3782,42 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 	return mode;
 }
 
-static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
+static void vmx_reset_x2apic_msrs_for_apicv(struct kvm_vcpu *vcpu, u8 mode)
 {
+	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
+	unsigned long read_intercept;
 	int msr;
 
-	for (msr = 0x800; msr <= 0x8ff; msr++) {
-		bool apicv = !!(mode & MSR_BITMAP_MODE_X2APIC_APICV);
+	read_intercept = (mode & MSR_BITMAP_MODE_X2APIC_APICV) ? 0 : ~0;
 
-		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_R, !apicv);
-		vmx_set_intercept_for_msr(vcpu, msr, MSR_TYPE_W, true);
+	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
+		unsigned int read_idx = msr / BITS_PER_LONG;
+		unsigned int write_idx = read_idx + (0x800 / sizeof(long));
+
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
+	if (enable_apicv)
+		vmx_reset_x2apic_msrs_for_apicv(vcpu, mode);
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
 
-- 
2.28.0

