Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C6014D3E1
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgA2Xrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:47:47 -0500
Received: from mga06.intel.com ([134.134.136.31]:46690 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbgA2Xqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551740"
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
Subject: [PATCH 16/26] KVM: x86: Add Kconfig-controlled auditing of reverse CPUID lookups
Date:   Wed, 29 Jan 2020 15:46:30 -0800
Message-Id: <20200129234640.8147-17-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add WARNs in the low level __cpuid_entry_get_reg() to assert that the
function and index of the CPUID entry and reverse CPUID entry match.
Wrap the WARNs in a new Kconfig, KVM_CPUID_AUDIT, as the checks add
almost no value in a production environment, i.e. will only detect
blatant KVM bugs and fatal hardware errors.  Add a Kconfig instead of
simply wrapping the WARNs with an off-by-default #ifdef so that syzbot
and other automated testing can enable the auditing.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/Kconfig | 10 ++++++++++
 arch/x86/kvm/cpuid.h |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 840e12583b85..bbbc3258358e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -96,6 +96,16 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_CPUID_AUDIT
+	bool "Audit KVM reverse CPUID lookups"
+	depends on KVM
+	help
+	 This option enables runtime checking of reverse CPUID lookups in KVM
+	 to verify the function and index of the referenced X86_FEATURE_* match
+	 the function and index of the CPUID entry being accessed.
+
+	 If unsure, say N.
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source "drivers/vhost/Kconfig"
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 51f19eade5a0..41ff94a7d3e0 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -98,6 +98,11 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
 static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
 						  const struct cpuid_reg *cpuid)
 {
+#ifdef CONFIG_KVM_CPUID_AUDIT
+	WARN_ON_ONCE(entry->function != cpuid->function);
+	WARN_ON_ONCE(entry->index != cpuid->index);
+#endif
+
 	switch (cpuid->reg) {
 	case CPUID_EAX:
 		return &entry->eax;
-- 
2.24.1

