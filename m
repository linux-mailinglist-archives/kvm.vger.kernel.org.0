Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9BF2EA2F6
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 02:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbhAEBms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 20:42:48 -0500
Received: from mga03.intel.com ([134.134.136.65]:49900 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhAEBmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 20:42:47 -0500
IronPort-SDR: jdn/FJCSygo2JEwCS2+G/fV95BVD4RIu1MLM4dNCqC/naaYy0tyy0F6moBnMUU9wb69qu1rC8r
 T5rCf1PK6NOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177136736"
X-IronPort-AV: E=Sophos;i="5.78,475,1599548400"; 
   d="scan'208";a="177136736"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 17:42:06 -0800
IronPort-SDR: dbtqBygSy3EUkaBTe96SHj+Lw4aYLLCu4mSwaNdoV4wZf1//C5AW15OWVqah0/L7KuS14kcF4p
 iS4guPKGYoWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,475,1599548400"; 
   d="scan'208";a="350166595"
Received: from icx-2s.bj.intel.com ([10.240.192.119])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jan 2021 17:42:03 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kyung.min.park@intel.com, yang.zhong@intel.com
Subject: [PATCH 2/2] KVM: Expose AVX_VNNI instruction to guset
Date:   Tue,  5 Jan 2021 08:49:09 +0800
Message-Id: <20210105004909.42000-3-yang.zhong@intel.com>
X-Mailer: git-send-email 2.29.2.334.gfaefdd61ec
In-Reply-To: <20210105004909.42000-1-yang.zhong@intel.com>
References: <20210105004909.42000-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose AVX (VEX-encoded) versions of the Vector Neural Network
Instructions to guest.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[bit 4] AVX_VNNI

The following instructions are available when this feature is
present in the guest.
  1. VPDPBUS: Multiply and Add Unsigned and Signed Bytes
  2. VPDPBUSDS: Multiply and Add Unsigned and Signed Bytes with Saturation
  3. VPDPWSSD: Multiply and Add Signed Word Integers
  4. VPDPWSSDS: Multiply and Add Signed Integers with Saturation

This instruction is currently documented in the latest "extensions"
manual (ISE). It will appear in the "main" manual (SDM) in the future.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 83637a2ff605..4229b67f0a8d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -433,7 +433,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX512_BF16)
+		F(AVX_VNNI) | F(AVX512_BF16)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-- 
2.29.2.334.gfaefdd61ec

