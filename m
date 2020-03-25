Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895841930EB
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 20:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgCYTNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 15:13:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:19925 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbgCYTNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 15:13:00 -0400
IronPort-SDR: 8UlUOX3Q1KxquXMkk7WywKVPP2/PAa0BMP7JaVNFaubPQwGnTyucWhxe2HyisQiSCQFGDOfC3Q
 8Mqc0KIuq/Gw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 12:13:00 -0700
IronPort-SDR: bQeRBDjYsYwoIzI4XP0Iyc8k6ExUzw5Fb7NEfqduEHTmrXqzi1+unrBqE9U+ap/POV/I74TBMc
 zeoLXjwt43Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,305,1580803200"; 
   d="scan'208";a="357902461"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 25 Mar 2020 12:13:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] KVM: x86: Fix BUILD_BUG() in __cpuid_entry_get_reg() w/ CONFIG_UBSAN=y
Date:   Wed, 25 Mar 2020 12:12:59 -0700
Message-Id: <20200325191259.23559-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take the target reg in __cpuid_entry_get_reg() instead of a pointer to a
struct cpuid_reg.  When building with -fsanitize=alignment (enabled by
CONFIG_UBSAN=y), some versions of gcc get tripped up on the pointer and
trigger the BUILD_BUG().

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: d8577a4c238f8 ("KVM: x86: Do host CPUID at load time to mask KVM cpu caps")
Fixes: 4c61534aaae2a ("KVM: x86: Introduce cpuid_entry_{get,has}() accessors")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 arch/x86/kvm/cpuid.h | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 08280d8a2ac9..16d3ae432420 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -269,7 +269,7 @@ static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
 	cpuid_count(cpuid.function, cpuid.index,
 		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
 
-	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, &cpuid);
+	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
 }
 
 void kvm_set_cpu_caps(void)
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 23b4cd1ad986..63a70f6a3df3 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -99,9 +99,9 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_featu
 }
 
 static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
-						  const struct cpuid_reg *cpuid)
+						  u32 reg)
 {
-	switch (cpuid->reg) {
+	switch (reg) {
 	case CPUID_EAX:
 		return &entry->eax;
 	case CPUID_EBX:
@@ -121,7 +121,7 @@ static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
 {
 	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
 
-	return __cpuid_entry_get_reg(entry, &cpuid);
+	return __cpuid_entry_get_reg(entry, cpuid.reg);
 }
 
 static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
@@ -189,7 +189,7 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
 	if (!entry)
 		return NULL;
 
-	return __cpuid_entry_get_reg(entry, &cpuid);
+	return __cpuid_entry_get_reg(entry, cpuid.reg);
 }
 
 static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
-- 
2.24.1

