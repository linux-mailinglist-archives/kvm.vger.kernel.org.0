Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867052EA2F4
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 02:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbhAEBmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 20:42:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:49891 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhAEBmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 20:42:43 -0500
IronPort-SDR: o8EyXBT9FLYg5TIhIb7erlK/i4Nr4NjCU+wsaRkLnZY4XDBo89igUI33SdGQ7rhVic/zaZU2vT
 r8+WAHdrWLog==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177136727"
X-IronPort-AV: E=Sophos;i="5.78,475,1599548400"; 
   d="scan'208";a="177136727"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 17:42:02 -0800
IronPort-SDR: Lq7r08yZwWLomQl0e7IrS4PvGvQ1H4hP/p5SEdnZFv6sJRhETI8ZJxPqa47zDoonhmWPuacX4V
 Anm3WH1KcqUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,475,1599548400"; 
   d="scan'208";a="350166571"
Received: from icx-2s.bj.intel.com ([10.240.192.119])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jan 2021 17:41:59 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        tony.luck@intel.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kyung.min.park@intel.com, yang.zhong@intel.com
Subject: [PATCH 1/2] Enumerate AVX Vector Neural Network instructions
Date:   Tue,  5 Jan 2021 08:49:08 +0800
Message-Id: <20210105004909.42000-2-yang.zhong@intel.com>
X-Mailer: git-send-email 2.29.2.334.gfaefdd61ec
In-Reply-To: <20210105004909.42000-1-yang.zhong@intel.com>
References: <20210105004909.42000-1-yang.zhong@intel.com>
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

