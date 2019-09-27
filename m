Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F2BC0D8C
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 23:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbfI0Vp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 17:45:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:45951 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728526AbfI0Vp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 17:45:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 14:45:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,557,1559545200"; 
   d="scan'208";a="196852070"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Sep 2019 14:45:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 5/8] KVM: x86: Add WARNs to detect out-of-bounds register indices
Date:   Fri, 27 Sep 2019 14:45:20 -0700
Message-Id: <20190927214523.3376-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190927214523.3376-1-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add WARN_ON_ONCE() checks in kvm_register_{read,write}() to detect reg
values that would cause KVM to overflow vcpu->arch.regs.  Change the reg
param to an 'int' to make it clear that the reg index is unverified.

Open code the RIP and RSP accessors so as to avoid pointless overhead of
WARN_ON_ONCE().  Alternatively, lower-level helpers could be provided,
but that opens the door for improper use of said helpers, and the
ugliness of the open-coding will be slightly improved in future patches.

Regarding the overhead of WARN_ON_ONCE(), now that all fixed GPR reads
and writes use dedicated accessors, e.g. kvm_rax_read(), the overhead
is limited to flows where the reg index is generated at runtime.  And
there is at least one historical bug where KVM has generated an out-of-
bounds access to arch.regs (see commit b68f3cc7d9789, "KVM: x86: Always
use 32-bit SMRAM save state for 32-bit kernels").

Adding the WARN_ON_ONCE() protection paves the way for additional
cleanup related to kvm_reg and kvm_reg_ex.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 30 ++++++++++++++++++++++--------
 arch/x86/kvm/x86.h            |  6 ++----
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 1cc6c47dc77e..3972e1b65635 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -37,19 +37,23 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
 BUILD_KVM_GPR_ACCESSORS(r15, R15)
 #endif
 
-static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu,
-					      enum kvm_reg reg)
+static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
 {
+	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
+		return 0;
+
 	if (!test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail))
 		kvm_x86_ops->cache_reg(vcpu, reg);
 
 	return vcpu->arch.regs[reg];
 }
 
-static inline void kvm_register_write(struct kvm_vcpu *vcpu,
-				      enum kvm_reg reg,
+static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
 				      unsigned long val)
 {
+	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
+		return;
+
 	vcpu->arch.regs[reg] = val;
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
@@ -57,22 +61,32 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu,
 
 static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
 {
-	return kvm_register_read(vcpu, VCPU_REGS_RIP);
+	if (!test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_avail))
+		kvm_x86_ops->cache_reg(vcpu, VCPU_REGS_RIP);
+
+	return vcpu->arch.regs[VCPU_REGS_RIP];
 }
 
 static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
 {
-	kvm_register_write(vcpu, VCPU_REGS_RIP, val);
+	vcpu->arch.regs[VCPU_REGS_RIP] = val;
+	__set_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty);
+	__set_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
 static inline unsigned long kvm_rsp_read(struct kvm_vcpu *vcpu)
 {
-	return kvm_register_read(vcpu, VCPU_REGS_RSP);
+	if (!test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_avail))
+		kvm_x86_ops->cache_reg(vcpu, VCPU_REGS_RSP);
+
+	return vcpu->arch.regs[VCPU_REGS_RSP];
 }
 
 static inline void kvm_rsp_write(struct kvm_vcpu *vcpu, unsigned long val)
 {
-	kvm_register_write(vcpu, VCPU_REGS_RSP, val);
+	vcpu->arch.regs[VCPU_REGS_RSP] = val;
+	__set_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty);
+	__set_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_avail);
 }
 
 static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index dbf7442a822b..45d82b8277e5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -238,8 +238,7 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return false;
 }
 
-static inline unsigned long kvm_register_readl(struct kvm_vcpu *vcpu,
-					       enum kvm_reg reg)
+static inline unsigned long kvm_register_readl(struct kvm_vcpu *vcpu, int reg)
 {
 	unsigned long val = kvm_register_read(vcpu, reg);
 
@@ -247,8 +246,7 @@ static inline unsigned long kvm_register_readl(struct kvm_vcpu *vcpu,
 }
 
 static inline void kvm_register_writel(struct kvm_vcpu *vcpu,
-				       enum kvm_reg reg,
-				       unsigned long val)
+				       int reg, unsigned long val)
 {
 	if (!is_64_bit_mode(vcpu))
 		val = (u32)val;
-- 
2.22.0

