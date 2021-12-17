Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CF4478FC6
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238223AbhLQPaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:10842 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238198AbhLQPaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755004; x=1671291004;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/l/lzu8ovCU50omqsIU1bkVibRLaW4dJhOXZM0Wu658=;
  b=Z9fzAUNgVF8iWv9NQe28VKtzsADmE8y4RcOsKnHCSl+uJ/eIh4h7rRgn
   c420iY9VUJOG+dg7siBXcKfbAEf+PVb0r/Ashgyx4ltR8kgGCccoW/v1w
   NfKlmxig3stoqiEHd3/q2FWUA9o9PmA+D4XLoaahh+0pHx6rNcrqborgQ
   FH5w6q9DwMgcQQI87QMWNxYgTLjD7EzDk5Lz72n+xi54eZ+ex5K/LFJ5v
   e804NVK6XzXRQA0QUrYyUcE2eeW2JrS7AzwitBbNYx9aPfi38KDx704Mg
   czxdUt+Sn57v+RSfbeNIUmQRwZGDV/m46d0sde2s6+Dx1/LbkuPkRP7pJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723431"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723431"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588394"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:03 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 03/23] kvm: x86: Fix xstate_required_size() to follow XSTATE alignment rule
Date:   Fri, 17 Dec 2021 07:29:43 -0800
Message-Id: <20211217153003.1719189-4-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID.0xD.1.EBX enumerates the size of the XSAVE area (in compacted
format) required by XSAVES. If CPUID.0xD.i.ECX[1] is set for a state
component (i), this state component should be located on the next
64-bytes boundary following the preceding state component in the
compacted layout.

Fix xstate_required_size() to follow the alignment rule. AMX is the
first state component with 64-bytes alignment to catch this bug.

Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 07e9215e911d..148003e26cbb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -42,7 +42,8 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 		if (xstate_bv & 0x1) {
 		        u32 eax, ebx, ecx, edx, offset;
 		        cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
-			offset = compacted ? ret : ebx;
+			/* ECX[1]: 64B alignment in compacted form */
+			offset = compacted ? ((ecx & 0x2) ? ALIGN(ret, 64) : ret) : ebx;
 			ret = max(ret, offset + eax);
 		}
 
-- 
2.27.0

