Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B765478FDB
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbhLQPbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:31:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:10852 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238236AbhLQPaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755007; x=1671291007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PXq6/YEFmL7fuafodWXOL+G8jefqhvh1JXMT3eAUNEI=;
  b=Unh9mg7UQwcm4rChbIy/dYdjANXCjOB8X3bBRTezdhZsHVE7iAQjc6Vy
   Bps/zE9EyD73NTKkOLeQqCl/wkJ7pyyG8JlYj63KqT7bgVQ51/qRU1oG3
   jYJrhUTkW3xVDCVVYmha4TrZPm+ErlborwGKl7B3kIzlDdBdqtezx7xEX
   ff8wwqycf+RYFNtrQAsDqqpq8/rx9EXs/LUSUEdM6DzYCcPmL7qZn6rh5
   YQKyE+oigSIauMRvf8vdt8gpuelqIlnwTergA5Di8VfIrRF9OXigeqhsE
   dq1DiICD/kAtYBRvQOa0Cqu2+LwX9FMBD/F+44q2QugYoMHeFiDqRF8QM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723453"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723453"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588435"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:05 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 12/23] x86/fpu: Prepare xfd_err in struct fpu_guest
Date:   Fri, 17 Dec 2021 07:29:52 -0800
Message-Id: <20211217153003.1719189-13-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When XFD causes an instruction to generate #NM, IA32_XFD_ERR
contains information about which disabled state components are
being accessed. The #NM handler is expected to check this
information and then enable the state components by clearing
IA32_XFD for the faulting task (if having permission).

If the XFD_ERR value generated in guest is consumed/clobbered
by the host before the guest itself doing so. This may lead to
non-XFD-related #NM treated as XFD #NM in host (due to non-zero
value in XFD_ERR), or XFD-related #NM treated as non-XFD #NM in
guest (XFD_ERR cleared by the host #NM handler).

Introduce a new field in fpu_guest to save the guest xfd_err value.
KVM is expected to save guest xfd_err before preemption is enabled
and restore it right before entering the guest (with preemption
disabled).

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/include/asm/fpu/types.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index c752d0aa23a4..3795d0573773 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -517,6 +517,11 @@ struct fpu_guest {
 	 */
 	u64				perm;
 
+	/*
+	 * @xfd_err:			Save the guest value.
+	 */
+	u64				xfd_err;
+
 	/*
 	 * @fpstate:			Pointer to the allocated guest fpstate
 	 */
-- 
2.27.0

