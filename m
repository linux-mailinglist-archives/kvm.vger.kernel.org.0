Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E129C14D3E3
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbgA2Xr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:47:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:46690 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727161AbgA2Xqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551730"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/26] KVM: x86: Use u32 for holding CPUID register value in helpers
Date:   Wed, 29 Jan 2020 15:46:27 -0800
Message-Id: <20200129234640.8147-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
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

