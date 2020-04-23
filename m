Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B389F1B570B
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 10:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgDWIRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 04:17:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:57581 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgDWIRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 04:17:39 -0400
IronPort-SDR: WjMp5FdaUMxQVfGMIiPqo7F9MzI2Ltpfw5DetEmJmLmHysw/MRXCPVfQwAbINjm6POyFaLECIU
 wr6XkkM/tjcg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 01:17:39 -0700
IronPort-SDR: FXEmfdYw4hyTRvdP0+eXfiwXur70+zIL0Sr8sRUBswK26SVCS21NQKqeMV7QXKq1o6u5UwVc+Q
 5owA0xeJ/ReA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="255910036"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 23 Apr 2020 01:17:36 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v10 01/11] perf/x86: Fix variable type for LBR registers
Date:   Thu, 23 Apr 2020 16:14:02 +0800
Message-Id: <20200423081412.164863-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200423081412.164863-1-like.xu@linux.intel.com>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

The msr variable type can be 'unsigned int', which uses less memory than
the longer 'unsigned long'. Fix 'struct x86_pmu' for that. The lbr_nr won't
be a negative number, so make it 'unsigned int' as well.

Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/events/perf_event.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index f1cd1ca1a77b..1025bc6eb04f 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -672,8 +672,8 @@ struct x86_pmu {
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
2.21.1

