Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145F91AB2C5
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 22:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442064AbgDOUft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 16:35:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:20838 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S371299AbgDOUe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 16:34:59 -0400
IronPort-SDR: y7o8XkezhRGj1e+d1v50ARKuh3Dmy0h85Pdw3CwgUtdMVWTnGxlFDLBkV/NsVnEIKKvgHBE9K5
 ML5xRYoOHJyw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 13:34:58 -0700
IronPort-SDR: PieuOQJVnX4L+D6jP1Al+ggQIAA1Zccw2BbUfRFvBKLcHg7peFhqK4LW/tquq2yor0OhTm7YIN
 Wd2gtns0lxlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="288657647"
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
Subject: [PATCH 3/5] KVM: nVMX: Drop manual clearing of segment cache on nested VMCS switch
Date:   Wed, 15 Apr 2020 13:34:52 -0700
Message-Id: <20200415203454.8296-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415203454.8296-1-sean.j.christopherson@intel.com>
References: <20200415203454.8296-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the call to vmx_segment_cache_clear() in vmx_switch_vmcs() now that
the entire register cache is reset when switching the active VMCS, e.g.
vmx_segment_cache_test_set() will reset the segment cache due to
VCPU_EXREG_SEGMENTS being unavailable.

Move vmx_segment_cache_clear() to vmx.c now that it's no longer invoked
by the nested code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 1 -
 arch/x86/kvm/vmx/vmx.c    | 5 +++++
 arch/x86/kvm/vmx/vmx.h    | 5 -----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 91f04fb4f614..979d66fe0c0e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -308,7 +308,6 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	put_cpu();
 
 	vmx_register_cache_reset(vcpu);
-	vmx_segment_cache_clear(vmx);
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d1c16385904c..9709a6dbeebc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -437,6 +437,11 @@ static const struct kvm_vmx_segment_field {
 	VMX_SEGMENT_FIELD(LDTR),
 };
 
+static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
+{
+	vmx->segment_cache.bitmask = 0;
+}
+
 static unsigned long host_idt_base;
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6b668b604898..78c99a60fa49 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -443,11 +443,6 @@ BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
 BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
 BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
 
-static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
-{
-	vmx->segment_cache.bitmask = 0;
-}
-
 static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
-- 
2.26.0

