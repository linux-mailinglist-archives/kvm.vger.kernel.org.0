Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF0C46BEEE
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbhLGPOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:14:24 -0500
Received: from mga03.intel.com ([134.134.136.65]:53856 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238728AbhLGPNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:13:53 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237536558"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237536558"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:10:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461290211"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:10:15 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 18/19] kvm: x86: AMX XCR0 support for guest
Date:   Tue,  7 Dec 2021 19:03:58 -0500
Message-Id: <20211208000359.2853257-19-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

Two XCR0 bits are defined for AMX to support XSAVE mechanism. Bit 17 is
for tilecfg and bit 18 is for tiledata.

The value of XCR0[17:18] is always either 00b or 11b. Also, SDM recommends
that only 64-bit operating systems enable Intel AMX by setting
XCR0[18:17].

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/kvm/x86.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d212f6d2d39a..a9a608c8fa50 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -210,7 +210,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
-				| XFEATURE_MASK_PKRU)
+				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
@@ -1017,6 +1017,23 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 		if ((xcr0 & XFEATURE_MASK_AVX512) != XFEATURE_MASK_AVX512)
 			return 1;
 	}
+
+#ifdef CONFIG_X86_64
+	if ((xcr0 & XFEATURE_MASK_XTILE) &&
+	    ((xcr0 & XFEATURE_MASK_XTILE) != XFEATURE_MASK_XTILE))
+		return 1;
+#else
+	/*
+	 * Intel AMX instructions can be executed only in 64-bit mode but
+	 * XSAVE can operate on XTILECFG and XTILEDATA in any mode.
+	 * Since the FPU core follows SDM recommendation to set
+	 * XCR[18:17] only in 64-bit environment, here also prevent any
+	 * guest OS from setting the two bits when host is 32-bit.
+	 *
+	 * XFEATURE_MASK_XTILE cannot be used since it is 0 in this case.
+	 */
+	xcr0 &= ~(XFEATURE_MASK_XTILE_DATA | XFEATURE_MASK_XTILE_CFG);
+#endif
 	vcpu->arch.xcr0 = xcr0;
 
 	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
