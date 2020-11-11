Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB172AE8F7
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 07:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgKKGcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 01:32:00 -0500
Received: from mga17.intel.com ([192.55.52.151]:43536 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgKKGb1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 01:31:27 -0500
IronPort-SDR: xe+hrv6e53TVuBTM1sicPH3CEfpBAQC1qcBUnBukwrLu130C17wwacd3tJsJRNGIlLsqqJ0XHR
 jjRyaU7D+MUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="149951497"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="149951497"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 22:31:27 -0800
IronPort-SDR: U4NXlMMBhq7IhaqRgIfN55Z/duQ4Ym0W9MUxJNcVFRlcjoP0Zdb/l5tOu5qYSxGYrYyBbd+r1l
 ofg/v19g4N2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="323167579"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2020 22:31:25 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 1/3] KVM: x86: Add helpers for {set|clear} bits in supported_xss
Date:   Wed, 11 Nov 2020 14:41:49 +0800
Message-Id: <20201111064151.1090-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201111064151.1090-1-weijiang.yang@intel.com>
References: <20201111064151.1090-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

KVM supported XSS feature bits are designated in supported_xss, bits
could be set/cleared dynamically, add helpers to facilitate the operation.
Also add MSR_IA32_XSS to the list of MSRs reported to userspace if
supported_xss is non-zero, i.e. KVM supports at least one XSS based
feature.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 397f599b20e5..528eba526c9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1237,6 +1237,8 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+
+	MSR_IA32_XSS,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
@@ -5728,6 +5730,10 @@ static void kvm_init_msr_list(void)
 			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
 				continue;
 			break;
+		case MSR_IA32_XSS:
+			if (!supported_xss)
+				continue;
+			break;
 		default:
 			break;
 		}
@@ -10137,6 +10143,18 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
+static inline void __maybe_unused kvm_set_xss_bits(u32 low, u32 high)
+{
+	supported_xss |= low;
+	supported_xss |= ((u64)high) << 32;
+}
+
+static inline void __maybe_unused kvm_clear_xss_bits(u32 low, u32 high)
+{
+	supported_xss &= ~low;
+	supported_xss &= ~(((u64)high) << 32);
+}
+
 int kvm_arch_hardware_setup(void *opaque)
 {
 	struct kvm_x86_init_ops *ops = opaque;
@@ -10155,6 +10173,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
+	else
+		supported_xss &= host_xss;
 
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
-- 
2.17.2

