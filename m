Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D29312216
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 08:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhBGG6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 01:58:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:48437 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229721AbhBGG56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 01:57:58 -0500
IronPort-SDR: +h3S9nDwxPMzQAgXrVKQMiMBsc2KMniRYA58Mnv64IrM/uKZ2OvFi2QRVtaORnF34J5RVTW4Ml
 LyVGXg2Ozp/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="245660854"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="245660854"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 22:54:52 -0800
IronPort-SDR: iasB+wYl29YDjO5FqNQn3Mb/jN+7veHC66sdj8loc20lAf9zfKbkJjx5vdxCBpDZhLwiSUg7CA
 6ENYskT7Yltg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="410376599"
Received: from vmmteam.bj.intel.com ([10.240.193.86])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2021 22:54:51 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: [PATCH RFC 5/7] kvm: x86: Revise CPUID.D.1.EBX for alignment rule
Date:   Sun,  7 Feb 2021 10:42:54 -0500
Message-Id: <20210207154256.52850-6-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210207154256.52850-1-jing2.liu@linux.intel.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID.0xD.1.EBX[1] is set if, when the compacted format of an XSAVE
area is used, this extended state component located on the next
64-byte boundary following the preceding state component (otherwise,
it is located immediately following the preceding state component).

AMX tileconfig and tiledata are the first to use 64B alignment.
Revise the runtime cpuid modification for this rule.

Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 04a73c395c71..ee1fac0a865e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -35,12 +35,17 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 {
 	int feature_bit = 0;
 	u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
+	bool is_aligned = false;
 
 	xstate_bv &= XFEATURE_MASK_EXTEND;
 	while (xstate_bv) {
 		if (xstate_bv & 0x1) {
 		        u32 eax, ebx, ecx, edx, offset;
 		        cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
+			/* ECX[2]: 64B alignment in compacted form */
+			is_aligned = !!(ecx & 2);
+			if (is_aligned && compacted)
+				ret = ALIGN(ret, 64);
 			offset = compacted ? ret : ebx;
 			ret = max(ret, offset + eax);
 		}
-- 
2.18.4

