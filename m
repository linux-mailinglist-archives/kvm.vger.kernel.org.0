Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20902DB979
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 03:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgLPC4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 21:56:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:9465 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgLPC4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 21:56:41 -0500
IronPort-SDR: pIgCqA8wiZgqFEtTeH2T98oJDsISJo47uB3gwPfy1ruwNXGgfED1fJeQZZitC2O9GSj4OH410g
 1LVt4iV1Ek4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9836"; a="175099201"
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="175099201"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2020 18:55:58 -0800
IronPort-SDR: 3f0utlsZ8lRjxpiCRmW8Um+I1ILiWoUiHQ5AyI7mZR7q5dsW8Yyv8jrqsfxQbLDDLN6QMqQe0y
 DF0Z4MDMJeGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,423,1599548400"; 
   d="scan'208";a="451538791"
Received: from icx-2s.bj.intel.com ([10.240.192.119])
  by fmsmga001.fm.intel.com with ESMTP; 15 Dec 2020 18:55:54 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kyung.min.park@intel.com, yang.zhong@intel.com
Subject: [PATCH 1/2] Enumerate AVX Vector Neural Network instructions
Date:   Wed, 16 Dec 2020 10:01:28 +0800
Message-Id: <20201216020129.19875-2-yang.zhong@intel.com>
X-Mailer: git-send-email 2.29.2.334.gfaefdd61ec
In-Reply-To: <20201216020129.19875-1-yang.zhong@intel.com>
References: <20201216020129.19875-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kyung Min Park <kyung.min.park@intel.com>

Add AVX version of the Vector Neural Network (VNNI) Instructions.

A processor supports AVX VNNI instructions if CPUID.0x07.0x1:EAX[4] is
present. The following instructions are available when this feature is
present.
  1. VPDPBUS: Multiply and Add Unsigned and Signed Bytes
  2. VPDPBUSDS: Multiply and Add Unsigned and Signed Bytes with Saturation
  3. VPDPWSSD: Multiply and Add Signed Word Integers
  4. VPDPWSSDS: Multiply and Add Signed Integers with Saturation

The only in-kernel usage of this is kvm passthrough. The CPU feature
flag is shown as "avx_vnni" in /proc/cpuinfo.

This instruction is currently documented in the latest "extensions"
manual (ISE). It will appear in the "main" manual (SDM) in the future.

Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f5ef2d5b9231..d10d9962bd9b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -293,6 +293,7 @@
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
+#define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
-- 
2.29.2.334.gfaefdd61ec

