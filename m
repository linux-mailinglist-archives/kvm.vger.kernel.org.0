Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB1817A2A8
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgCEJ7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:59:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:18619 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbgCEJ7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:59:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 01:59:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234366513"
Received: from snr.bj.intel.com ([10.240.193.90])
  by orsmga008.jf.intel.com with ESMTP; 05 Mar 2020 01:59:11 -0800
From:   Luwei Kang <luwei.kang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com
Subject: [PATCH v1 04/11] KVM: x86/pmu: Decouple event enablement from event creation
Date:   Fri,  6 Mar 2020 01:56:58 +0800
Message-Id: <1583431025-19802-5-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

KVM needs to specially configure the event before enabling the event, e.g.
set event to assign a dedicated counter and handle auto-reload flags.

Set disabled = 1 when allocating the event. So perf will not enable the
event by default. Then enable the event explicitly. Previously, the process
is creating and enabling. Now, it's creating, KVM configure, and enabling.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bcc6a73..b4f9e97 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -109,6 +109,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_user = exclude_user,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
+		.disabled = 1,
 	};
 
 	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
@@ -136,6 +137,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 
 	pmc->perf_event = event;
 	pmc_to_pmu(pmc)->event_count++;
+	perf_event_enable(event);
 	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 }
 
-- 
1.8.3.1

