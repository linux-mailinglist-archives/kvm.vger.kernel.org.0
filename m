Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E455B9565
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 09:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIOH2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 03:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIOH1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 03:27:46 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3245979D4;
        Thu, 15 Sep 2022 00:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663226836; x=1694762836;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=46fP1v3/Cp/TNRk09EA9DKMo0jNSNIk8Tld+smpUepY=;
  b=IWzuPmVNzkxJUwg1wKnoicWmRTOlJezgRZL71ESzf+lCHRTcK4B9OsZ7
   mwf6Y4mowwpbqLvneGb3hDACsoM9ZIZz0IWyOPfY1pdezBlhDZHJPj/RM
   gU5QbySlVzYgjY5u00WsxV4iD0OcrtQo4Lz8YW+gqLJZ5bAg/LORkJvWn
   8UlZV3GZDzKTzqkuY7JfTl3uLEeyseSkeWZz66H3PQhka80gOtvNaSO+3
   v5iVkfVhmMxBroxd7kOEFrLODwOJyE0ZRB6WJT7D7Xf86GRngVvc9zM9A
   VC+OKw1oszCqMNSPJqVkDCPegOJgmALB94LKhAboWtyORPjy1LqErC1Vh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="299450593"
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="299450593"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 00:26:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="685614810"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.145])
  by fmsmga004.fm.intel.com with ESMTP; 15 Sep 2022 00:26:43 -0700
From:   Dapeng Mi <dapeng1.mi@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhenyuw@linux.intel.com, Dapeng Mi <dapeng1.mi@intel.com>
Subject: [PATCH] KVM: x86: disable halt polling when powersave governor is used
Date:   Thu, 15 Sep 2022 15:31:21 +0800
Message-Id: <20220915073121.1038840-1-dapeng1.mi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Halt polling is enabled by default even through the CPU frequency
governor is configured to powersave. Generally halt polling would
consume extra power and this's not identical with the intent of
powersave governor.

disabling halt polling in powersave governor can save the precious
power in power critical case.

FIO random read test on Alder Lake platform shows halt polling
occupies ~17% CPU utilization and consume 7% extra CPU power.
After disabling halt polling, CPU has more chance to enter deeper
C-states (C1E%: 25.3% -> 33.4%, C10%: 4.4% -> 17.4%).

On Alder Lake platform, we don't find there are obvious performance
downgrade after disabling halt polling on FIO and Netperf cases.
Netperf UDP_RR case runs from two VMs locate on two different physical
machines.

FIO(MB/s)	Base	Disable-halt-polling	Delta%
Rand-read	432.6	436.3			0.8%

Netperf		Base	Disable-halt-polling	Delta%
UDP_RR          509.8	508.5			-0.3%

Signed-off-by: Dapeng Mi <dapeng1.mi@intel.com>
---
 arch/x86/kvm/x86.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..c0eb6574cbbb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13015,7 +13015,22 @@ bool kvm_vector_hashing_enabled(void)
 
 bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
-	return (vcpu->arch.msr_kvm_poll_control & 1) == 0;
+	struct cpufreq_policy *policy = cpufreq_cpu_get(vcpu->cpu);
+	bool powersave = false;
+
+	/*
+	 * Halt polling could consume much CPU power, if CPU frequency
+	 * governor is set to "powersave", disable halt polling.
+	 */
+	if (policy) {
+		if ((policy->policy == CPUFREQ_POLICY_POWERSAVE) ||
+			(policy->governor &&
+				!strncmp(policy->governor->name, "powersave",
+					CPUFREQ_NAME_LEN)))
+			powersave = true;
+		cpufreq_cpu_put(policy);
+	}
+	return ((vcpu->arch.msr_kvm_poll_control & 1) == 0) || powersave;
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
-- 
2.34.1

