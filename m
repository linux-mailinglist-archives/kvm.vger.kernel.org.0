Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02C43F94C7
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244347AbhH0HEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:04:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:6124 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244387AbhH0HEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 03:04:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="205045920"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="205045920"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 00:03:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="495553126"
Received: from lxy-dell.sh.intel.com ([10.239.159.31])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2021 00:03:15 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] KVM: VMX: Check Intel PT related CPUID leaves
Date:   Fri, 27 Aug 2021 15:02:48 +0800
Message-Id: <20210827070249.924633-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210827070249.924633-1-xiaoyao.li@intel.com>
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID 0xD leaves reports the capabilities of Intel PT, e.g. it decides
which bits are valid to be set in MSR_IA32_RTIT_CTL, and reports the
number of PT ADDR ranges.

KVM needs to check that guest CPUID values set by userspace doesn't
enable any bit which is not supported by bare metal. Otherwise,
1. it will trigger vm-entry failure if hardware unsupported bit is
   exposed to guest and set by guest.
2. it triggers #GP when context switch PT MSRs if exposing more
   RTIT_ADDR* MSRs than hardware capacity.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
There is bit 31 of CPUID(0xD, 0).ECX that doesn't restrict any bit in
MSR_IA32_RTIT_CTL. If guest has different value than host, it won't
cause any vm-entry failure, but guest will parse the PT packet with
wrong format.

I also check it to be same as host to ensure the virtualization correctness.

Changes in v2:
- Call out that if configuring more PT ADDR MSRs than hardware, it can
  cause #GP when context switch.
---
 arch/x86/kvm/cpuid.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 739be5da3bca..0c8e06a24156 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -76,6 +76,7 @@ static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 {
 	struct kvm_cpuid_entry2 *best;
+	u32 eax, ebx, ecx, edx;
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -89,6 +90,30 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 			return -EINVAL;
 	}
 
+	/*
+	 * CPUID 0xD leaves tell Intel PT capabilities, which decides
+	 * pt_desc.ctl_bitmask in later update_intel_pt_cfg().
+	 *
+	 * pt_desc.ctl_bitmask decides the legal value for guest
+	 * MSR_IA32_RTIT_CTL. KVM cannot support PT capabilities beyond native,
+	 * otherwise it will trigger vm-entry failure if guest sets native
+	 * unsupported bits in MSR_IA32_RTIT_CTL.
+	 */
+	best = cpuid_entry2_find(entries, nent, 0xD, 0);
+	if (best) {
+		cpuid_count(0xD, 0, &eax, &ebx, &ecx, &edx);
+		if (best->ebx & ~ebx || best->ecx & ~ecx)
+			return -EINVAL;
+	}
+	best = cpuid_entry2_find(entries, nent, 0xD, 1);
+	if (best) {
+		cpuid_count(0xD, 0, &eax, &ebx, &ecx, &edx);
+		if (((best->eax & 0x7) > (eax & 0x7)) ||
+		    ((best->eax & ~eax) >> 16) ||
+		    (best->ebx & ~ebx))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.27.0

