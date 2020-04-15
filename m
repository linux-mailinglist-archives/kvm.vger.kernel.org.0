Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309DA1AB2C3
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 22:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442048AbgDOUfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 16:35:37 -0400
Received: from mga17.intel.com ([192.55.52.151]:20837 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S371298AbgDOUfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 16:35:00 -0400
IronPort-SDR: 03GrC2Kz5nhFW3vseNVDPmuAEnO89C3rcu37+Mt/pQN5iiDNE/ivZtVyK6g472AiBm/uBr/VLr
 tmVMCadYv+Vg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 13:34:57 -0700
IronPort-SDR: cm7FFPlGwu2m2irY6U4wrSYhTw+9feNhVq8FaGUMHDgfb2mipzX4tOQiz2nBuhdRgdb7Pos7kl
 w76Ag3Iau3AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="288657643"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 15 Apr 2020 13:34:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] KVM: nVMX: Reset register cache (available and dirty masks) on VMCS switch
Date:   Wed, 15 Apr 2020 13:34:51 -0700
Message-Id: <20200415203454.8296-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415203454.8296-1-sean.j.christopherson@intel.com>
References: <20200415203454.8296-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reset the per-vCPU available and dirty register masks when switching
between vmcs01 and vmcs02, as the masks track state relative to the
current VMCS.  The stale masks don't cause problems in the current code
base because the registers are either unconditionally written on nested
transitions or, in the case of segment registers, have an additional
tracker that is manually reset.

Note, by dropping (previously implicitly, now explicitly) the dirty mask
when switching the active VMCS, KVM is technically losing writes to the
associated fields.  But, the only regs that can be dirtied (RIP, RSP and
PDPTRs) are unconditionally written on nested transitions, e.g. explicit
writeback is a waste of cycles, and a WARN_ON would be rather pointless.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  1 +
 arch/x86/kvm/vmx/vmx.c    |  7 +------
 arch/x86/kvm/vmx/vmx.h    | 11 +++++++++++
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f9ae42209d78..91f04fb4f614 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -307,6 +307,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vmx_sync_vmcs_host_state(vmx, prev);
 	put_cpu();
 
+	vmx_register_cache_reset(vcpu);
 	vmx_segment_cache_clear(vmx);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7da83325ace3..d1c16385904c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6711,12 +6711,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	loadsegment(es, __USER_DS);
 #endif
 
-	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
-				  | (1 << VCPU_EXREG_RFLAGS)
-				  | (1 << VCPU_EXREG_PDPTR)
-				  | (1 << VCPU_EXREG_SEGMENTS)
-				  | (1 << VCPU_EXREG_CR3));
-	vcpu->arch.regs_dirty = 0;
+	vmx_register_cache_reset(vcpu);
 
 	pt_guest_exit(vmx);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 31d7252df163..6b668b604898 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -8,6 +8,7 @@
 #include <asm/intel_pt.h>
 
 #include "capabilities.h"
+#include "kvm_cache_regs.h"
 #include "ops.h"
 #include "vmcs.h"
 
@@ -447,6 +448,16 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
+static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
+				  | (1 << VCPU_EXREG_RFLAGS)
+				  | (1 << VCPU_EXREG_PDPTR)
+				  | (1 << VCPU_EXREG_SEGMENTS)
+				  | (1 << VCPU_EXREG_CR3));
+	vcpu->arch.regs_dirty = 0;
+}
+
 static inline u32 vmx_vmentry_ctrl(void)
 {
 	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
-- 
2.26.0

