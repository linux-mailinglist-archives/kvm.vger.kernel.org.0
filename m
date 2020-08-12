Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9232424F1
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 07:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgHLFJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 01:09:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:55625 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgHLFJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 01:09:51 -0400
IronPort-SDR: 3VWtqI8RHhRNxYKPm6bz+5R2Q7LMoEygJNQLqsCALpcArhdSI/g1/WcSCE5XM4Dn3YY9bqB3yt
 k5Je4nCCZCXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="141729292"
X-IronPort-AV: E=Sophos;i="5.76,303,1592895600"; 
   d="scan'208";a="141729292"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 22:09:51 -0700
IronPort-SDR: jV/u4H842sfXW8M/als+kPyHvjNbX23gNxcm6qen1ioionXCqgHWipvLZud5Fxj5v4NHS4f65y
 MWETPvQgc1pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,303,1592895600"; 
   d="scan'208";a="332706627"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Aug 2020 22:09:48 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Jin@vger.kernel.org, Yao <yao.jin@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Add '.exclude_hv = 1' for guest perf_event
Date:   Wed, 12 Aug 2020 13:07:22 +0800
Message-Id: <20200812050722.25824-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To emulate PMC counter for guest, KVM would create an
event on the host with 'exclude_guest=0, exclude_hv=0'
which simply makes no sense and is utterly broken.

To keep perf semantics consistent, any event created by
pmc_reprogram_counter() should both set exclude_hv and
exclude_host in the KVM context.

Message-ID: <20200811084548.GW3982@worktop.programming.kicks-ass.net>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 67741d2a0308..6a30763a10d7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -108,6 +108,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_host = 1,
 		.exclude_user = exclude_user,
 		.exclude_kernel = exclude_kernel,
+		.exclude_hv = 1,
 		.config = config,
 	};
 
-- 
2.21.3

