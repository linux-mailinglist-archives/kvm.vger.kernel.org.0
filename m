Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6028C14F9ED
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgBAS4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:56:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:57278 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbgBASw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075504"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/61] KVM: x86: Use u32 for holding CPUID register value in helpers
Date:   Sat,  1 Feb 2020 10:51:42 -0800
Message-Id: <20200201185218.24473-26-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the intermediate CPUID output register values from "int" to "u32"
to match both hardware and the storage type in struct cpuid_reg.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index c1ac0995843d..72a79bdfed6b 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -95,7 +95,7 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
 	return reverse_cpuid[x86_leaf];
 }
 
-static __always_inline int *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
+static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
 {
 	struct kvm_cpuid_entry2 *entry;
 	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
@@ -121,7 +121,7 @@ static __always_inline int *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
 
 static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_feature)
 {
-	int *reg;
+	u32 *reg;
 
 	reg = guest_cpuid_get_register(vcpu, x86_feature);
 	if (!reg)
@@ -132,7 +132,7 @@ static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_
 
 static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu, unsigned x86_feature)
 {
-	int *reg;
+	u32 *reg;
 
 	reg = guest_cpuid_get_register(vcpu, x86_feature);
 	if (reg)
-- 
2.24.1

