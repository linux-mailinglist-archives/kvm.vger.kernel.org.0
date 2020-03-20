Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1086F18DA5D
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCTVa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:30:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:42047 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727295AbgCTV2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:54 -0400
IronPort-SDR: YUOd+oNyNmuVLsUXJvLU4prUr83pH2VUX7TOh+rSDn+0vl0Eb73eu1JtxFejzA6VDK+PZidFQf
 7P+bJnMZmZ1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:52 -0700
IronPort-SDR: yLF3Aepsotya6U8kBqijwf+H4O0QK5uO2fprqGJiK33akeqny4pb/o19dmy4i1MwCa6/EeXunR
 +eBSSvPrgaDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224468"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 18/37] KVM: VMX: Move vmx_flush_tlb() to vmx.c
Date:   Fri, 20 Mar 2020 14:28:14 -0700
Message-Id: <20200320212833.3507-19-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move vmx_flush_tlb() to vmx.c and make it non-inline static now that all
its callers live in vmx.c.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 25 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h | 25 -------------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 477bdbc52ed0..c6affaaef138 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2849,6 +2849,31 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
 
 #endif
 
+static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * Flush all EPTP/VPID contexts, as the TLB flush _may_ have been
+	 * invoked via kvm_flush_remote_tlbs().  Flushing remote TLBs requires
+	 * all contexts to be flushed, not just the active context.
+	 *
+	 * Note, this also ensures a deferred TLB flush with VPID enabled and
+	 * EPT disabled invalidates the "correct" VPID, by nuking both L1 and
+	 * L2's VPIDs.
+	 */
+	if (enable_ept) {
+		ept_sync_global();
+	} else if (enable_vpid) {
+		if (cpu_has_vmx_invvpid_global()) {
+			vpid_sync_vcpu_global();
+		} else {
+			vpid_sync_vcpu_single(vmx->vpid);
+			vpid_sync_vcpu_single(vmx->nested.vpid02);
+		}
+	}
+}
+
 static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bab5d62ad964..571249e18bb6 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -503,31 +503,6 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
 
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
 
-static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	/*
-	 * Flush all EPTP/VPID contexts, as the TLB flush _may_ have been
-	 * invoked via kvm_flush_remote_tlbs().  Flushing remote TLBs requires
-	 * all contexts to be flushed, not just the active context.
-	 *
-	 * Note, this also ensures a deferred TLB flush with VPID enabled and
-	 * EPT disabled invalidates the "correct" VPID, by nuking both L1 and
-	 * L2's VPIDs.
-	 */
-	if (enable_ept) {
-		ept_sync_global();
-	} else if (enable_vpid) {
-		if (cpu_has_vmx_invvpid_global()) {
-			vpid_sync_vcpu_global();
-		} else {
-			vpid_sync_vcpu_single(vmx->vpid);
-			vpid_sync_vcpu_single(vmx->nested.vpid02);
-		}
-	}
-}
-
 static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
 {
 	vmx->current_tsc_ratio = vmx->vcpu.arch.tsc_scaling_ratio;
-- 
2.24.1

