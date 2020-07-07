Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A80C2163E2
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 04:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgGGCVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 22:21:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:27533 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727818AbgGGCVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 22:21:49 -0400
IronPort-SDR: 8zPgb0rk8JpSItB9tH9ZExBcMunZXptqlhKc8dqpylig4MUPgodPHLHT/9f/xmDC1DEsGKot2Z
 RFEKvTx6AqRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="165601315"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="165601315"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:21:49 -0700
IronPort-SDR: TLZ0mnRcBfUrdDviTVvmweLBil3ZwiBntpc2hPMYfb7WZR3Z/jAlt+19hA/A89zGV1NDSW/Bw7
 wcNUeko2r5Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="357633729"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.238.156.127])
  by orsmga001.jf.intel.com with ESMTP; 06 Jul 2020 19:21:43 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, ricardo.neri-calderon@linux.intel.com,
        kyung.min.park@intel.com, jpoimboe@redhat.com,
        gregkh@linuxfoundation.org, ak@linux.intel.com,
        dave.hansen@intel.com, tony.luck@intel.com,
        ravi.v.shankar@intel.com, Cathy Zhang <cathy.zhang@intel.com>
Subject: [PATCH v2 1/4] x86/cpufeatures: Add enumeration for SERIALIZE instruction
Date:   Tue,  7 Jul 2020 10:16:20 +0800
Message-Id: <1594088183-7187-2-git-send-email-cathy.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
References: <1594088183-7187-1-git-send-email-cathy.zhang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This instruction gives software a way to force the processor to complete
all modifications to flags, registers and memory from previous instructions
and drain all buffered writes to memory before the next instruction is
fetched and executed.

The same effect can be obtained using the cpuid instruction. However,
cpuid causes modification on the eax, ebx, ecx, and ecx regiters; it
also causes a VM exit.

A processor supports SERIALIZE instruction if CPUID.0x0x.0x0:EDX[14] is
present. The CPU feature flag is shown as "serialize" in /proc/cpuinfo.

Detailed information on the instructions and CPUID feature flag SERIALIZE
can be found in the latest Intel Architecture Instruction Set Extensions
and Future Features Programming Reference and Intel 64 and IA-32
Architectures Software Developer's Manual.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 02dabc9..adf45cf 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -365,6 +365,7 @@
 #define X86_FEATURE_SRBDS_CTRL		(18*32+ 9) /* "" SRBDS mitigation MSR available */
 #define X86_FEATURE_MD_CLEAR		(18*32+10) /* VERW clears CPU buffers */
 #define X86_FEATURE_TSX_FORCE_ABORT	(18*32+13) /* "" TSX_FORCE_ABORT */
+#define X86_FEATURE_SERIALIZE		(18*32+14) /* SERIALIZE instruction */
 #define X86_FEATURE_PCONFIG		(18*32+18) /* Intel PCONFIG */
 #define X86_FEATURE_SPEC_CTRL		(18*32+26) /* "" Speculation Control (IBRS + IBPB) */
 #define X86_FEATURE_INTEL_STIBP		(18*32+27) /* "" Single Thread Indirect Branch Predictors */
-- 
1.8.3.1

