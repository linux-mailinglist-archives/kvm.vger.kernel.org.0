Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408B9176900
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgCCABf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:01:35 -0500
Received: from mga03.intel.com ([134.134.136.65]:17170 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbgCBX50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384771"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 49/66] KVM: x86: Do host CPUID at load time to mask KVM cpu caps
Date:   Mon,  2 Mar 2020 15:56:52 -0800
Message-Id: <20200302235709.27467-50-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mask kvm_cpu_caps based on host CPUID in preparation for overriding the
CPUID results during KVM_GET_SUPPORTED_CPUID instead of doing the
masking at runtime.

Note, masking may or may not be necessary, e.g. the kernel rarely, if
ever, sets real CPUID bits that are not supported by hardware.  But, the
code is cheap and only runs once at load, so an abundance of caution is
warranted.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 49527dbcc90c..ec8e24b1c1a7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -272,8 +272,16 @@ static __always_inline void cpuid_entry_mask(struct kvm_cpuid_entry2 *entry,
 
 static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
 {
+	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
+	struct kvm_cpuid_entry2 entry;
+
 	reverse_cpuid_check(leaf);
 	kvm_cpu_caps[leaf] &= mask;
+
+	cpuid_count(cpuid.function, cpuid.index,
+		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
+
+	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, &cpuid);
 }
 
 void kvm_set_cpu_caps(void)
-- 
2.24.1

