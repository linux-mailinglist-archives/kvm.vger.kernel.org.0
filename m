Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A726B1F81A2
	for <lists+kvm@lfdr.de>; Sat, 13 Jun 2020 10:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgFMILK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Jun 2020 04:11:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:50458 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgFMILH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Jun 2020 04:11:07 -0400
IronPort-SDR: yGPZ1Z7M8oabm0aXoy6aGGKQ/+6/sSPe/D74sp0BcJ56FmQJbC1CnxNH4fQnnVFcERa9AGfi3z
 HfbAxgCi6MWg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2020 01:11:03 -0700
IronPort-SDR: fM8V1pKNSOdeOzjezraxISaiMrF/G1Qs6okKN6PURfaF5grCqmvCOyouy5RjcG/U1dl+ECKQj+
 IT2yY/R8U0lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,506,1583222400"; 
   d="scan'208";a="474467309"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jun 2020 01:10:57 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v12 01/11] perf/x86: Fix variable types for LBR registers
Date:   Sat, 13 Jun 2020 16:09:46 +0800
Message-Id: <20200613080958.132489-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200613080958.132489-1-like.xu@linux.intel.com>
References: <20200613080958.132489-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

The MSR variable type can be 'unsigned int', which uses less memory than
the longer 'unsigned long'. Fix 'struct x86_pmu' for that. The lbr_nr won't
be a negative number, so make it 'unsigned int' as well.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/events/perf_event.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index e17a3d8a47ed..eb37f6c43c96 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -673,8 +673,8 @@ struct x86_pmu {
 	/*
 	 * Intel LBR
 	 */
-	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
-	int		lbr_nr;			   /* hardware stack size */
+	unsigned int	lbr_tos, lbr_from, lbr_to,
+			lbr_nr;			   /* LBR base regs and size */
 	u64		lbr_sel_mask;		   /* LBR_SELECT valid bits */
 	const int	*lbr_sel_map;		   /* lbr_select mappings */
 	bool		lbr_double_abort;	   /* duplicated lbr aborts */
-- 
2.21.3

