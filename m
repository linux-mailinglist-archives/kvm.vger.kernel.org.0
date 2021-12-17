Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C938478FB5
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbhLQPaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:14 -0500
Received: from mga03.intel.com ([134.134.136.65]:10852 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238196AbhLQPaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755008; x=1671291008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YW4AxwndnvUQjvMrZxczR1u/34DqMkxUNjj5YnnNfFo=;
  b=SpobS4rjzrvoeH08FbfXnL4Y8OGrHttJdAv7lyH8ZcoyOCL6+78PY+m2
   iVmUvR8SphGQeIhc09RA7CVfcqXblcNrfFtoBQQvI3pBwEDqXL6oE75sl
   gL1EMQBVLnjopTuuAZLZs38y2e4rOuVC0kVH8YWqWIwi+kjTpS+2HDm7E
   mye+yttn2AxTsPhAmA0NnOBi8JrZ7EV6Keg9tQ0XkXpSkZa18sHG2Kq+5
   xKfZ0mCSHFoLEMNU0xnX8oPJfx+MQNfNGL20emkEfkGlh5LwH6Gq0QWGW
   Ip0nwbfuhN8/tHktCzxJl1om9sSCz0preYAsmAwMV90sf9zkNWHHn1e1/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723460"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723460"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588447"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:05 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 15/23] kvm: x86: Add XCR0 support for Intel AMX
Date:   Fri, 17 Dec 2021 07:29:55 -0800
Message-Id: <20211217153003.1719189-16-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two XCR0 bits are defined for AMX to support XSAVE mechanism. Bit 17
is for tilecfg and bit 18 is for tiledata.

The value of XCR0[17:18] is always either 00b or 11b. Also, SDM
recommends that only 64-bit operating systems enable Intel AMX by
setting XCR0[18:17]. If a 32-bit guest tries to set dynamic bits, it
fails to pass vcpu->arch.guest_supported_xcr0 check and gets a #GP.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/kvm/x86.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15b093c58b3d..f8bacf18e6ed 100644
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
@@ -989,6 +989,12 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 		if ((xcr0 & XFEATURE_MASK_AVX512) != XFEATURE_MASK_AVX512)
 			return 1;
 	}
+
+#ifdef CONFIG_X86_64
+	if ((xcr0 & XFEATURE_MASK_XTILE) &&
+	    ((xcr0 & XFEATURE_MASK_XTILE) != XFEATURE_MASK_XTILE))
+		return 1;
+#endif
 	vcpu->arch.xcr0 = xcr0;
 
 	if ((xcr0 ^ old_xcr0) & XFEATURE_MASK_EXTEND)
-- 
2.27.0

