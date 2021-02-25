Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531CC3248C0
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 03:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbhBYCFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 21:05:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:15399 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235527AbhBYCFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 21:05:39 -0500
IronPort-SDR: 0Oq0OtVrfTxkfF8IE/rlKvy9hqtlCEbA9vtNx7aXFAYdB4fnHqk91ArR303xR+InwDMBg7qGu7
 g+74G0/yDuWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9905"; a="185432101"
X-IronPort-AV: E=Sophos;i="5.81,203,1610438400"; 
   d="scan'208";a="185432101"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2021 18:03:53 -0800
IronPort-SDR: deqi13EprK5XusdLMH1m5cIV/y6T78cCGIGj9ILsMn55gwwJD9BTVIlNDTRIAq1RiApkWy4/kt
 rf2uVs4W6Mzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,203,1610438400"; 
   d="scan'208";a="367209747"
Received: from vmmteam.bj.intel.com ([10.240.193.86])
  by orsmga006.jf.intel.com with ESMTP; 24 Feb 2021 18:03:50 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Revise guest_fpu xcomp_bv field
Date:   Thu, 25 Feb 2021 05:49:54 -0500
Message-Id: <20210225104955.3553-1-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

XCOMP_BV[63] field indicates that the save area is in the compacted
format and XCOMP_BV[62:0] indicates the states that have space allocated
in the save area, including both XCR0 and XSS bits enabled by the host
kernel. Use xfeatures_mask_all for calculating xcomp_bv and reuse
XCOMP_BV_COMPACTED_FORMAT defined by kernel.

Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b404e4d7dd8..f115493f577d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4435,8 +4435,6 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
-
 static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 {
 	struct xregs_state *xsave = &vcpu->arch.guest_fpu->state.xsave;
@@ -4494,7 +4492,8 @@ static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 	/* Set XSTATE_BV and possibly XCOMP_BV.  */
 	xsave->header.xfeatures = xstate_bv;
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		xsave->header.xcomp_bv = host_xcr0 | XSTATE_COMPACTION_ENABLED;
+		xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
+					 xfeatures_mask_all;
 
 	/*
 	 * Copy each region from the non-compacted offset to the
@@ -9912,9 +9911,6 @@ static void fx_init(struct kvm_vcpu *vcpu)
 		return;
 
 	fpstate_init(&vcpu->arch.guest_fpu->state);
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
-			host_xcr0 | XSTATE_COMPACTION_ENABLED;
 
 	/*
 	 * Ensure guest xcr0 is valid for loading
-- 
2.18.4

