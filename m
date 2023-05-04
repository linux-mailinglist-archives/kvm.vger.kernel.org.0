Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAADE6F6AB4
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 14:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjEDMBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 08:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjEDMBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 08:01:14 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0555FD1;
        Thu,  4 May 2023 05:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1683201665; x=1714737665;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wY/0HtaFXExUfyhtjujNcqy7eM9j7gqpAvsxmRRgR1w=;
  b=gAam8pBUVYABlTsjzq0QxyNU7T2LQnxMGLf0MT7XJGP78qx2K0GXa3Kb
   +BwShGh+xef3cbAQNfXZvggOnBaRAVDsqtvUUj533lKg0FZWw+4rbizC/
   AK8EhHEKUV36T/twSSKeIxJHo66PJn7aCJOWIhjOtDCUOXirWDX1kSuaT
   Y=;
X-IronPort-AV: E=Sophos;i="5.99,249,1677542400"; 
   d="scan'208";a="336000648"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 12:00:56 +0000
Received: from EX19MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id 393AE41523;
        Thu,  4 May 2023 12:00:53 +0000 (UTC)
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 4 May 2023 12:00:46 +0000
Received: from u40bc5e070a0153.ant.amazon.com (10.1.212.8) by
 mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26 via Frontend Transport; Thu, 4 May 2023 12:00:44 +0000
From:   Roman Kagan <rkagan@amazon.de>
To:     <kvm@vger.kernel.org>
CC:     Dave Hansen <dave.hansen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Hankland <ehankland@google.com>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
Date:   Thu, 4 May 2023 14:00:42 +0200
Message-ID: <20230504120042.785651-1-rkagan@amazon.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Performance counters are defined to have width less than 64 bits.  The
vPMU code maintains the counters in u64 variables but assumes the value
to fit within the defined width.  However, for Intel non-full-width
counters (MSR_IA32_PERFCTRx) the value receieved from the guest is
truncated to 32 bits and then sign-extended to full 64 bits.  If a
negative value is set, it's sign-extended to 64 bits, but then in
kvm_pmu_incr_counter() it's incremented, truncated, and compared to the
previous value for overflow detection.
That previous value is not truncated, so it always evaluates bigger than
the truncated new one, and a PMI is injected.  If the PMI handler writes
a negative counter value itself, the vCPU never quits the PMI loop.

Turns out that Linux PMI handler actually does write the counter with
the value just read with RDPMC, so when no full-width support is exposed
via MSR_IA32_PERF_CAPABILITIES, and the guest initializes the counter to
a negative value, it locks up.

We observed this in the field, for example, when the guest configures
atop to use perfevents and runs two instances of it simultaneously.

To address the problem, maintain the invariant that the counter value
always fits in the defined bit width, by truncating the received value
in the respective set_msr methods.  For better readability, factor this
out into a helper function, pmc_set_counter, shared by vmx and svm
parts.

Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
Signed-off-by: Roman Kagan <rkagan@amazon.de>
---
 arch/x86/kvm/pmu.h           | 6 ++++++
 arch/x86/kvm/svm/pmu.c       | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 4 ++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5c7bbf03b599..6a91e1afef5a 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -60,6 +60,12 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 	return counter & pmc_bitmask(pmc);
 }
 
+static inline void pmc_set_counter(struct kvm_pmc *pmc, u64 val)
+{
+	pmc->counter += val - pmc_read_counter(pmc);
+	pmc->counter &= pmc_bitmask(pmc);
+}
+
 static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 {
 	if (pmc->perf_event) {
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 5fa939e411d8..f93543d84cfe 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -151,7 +151,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
-		pmc->counter += data - pmc_read_counter(pmc);
+		pmc_set_counter(pmc, data);
 		pmc_update_sample_period(pmc);
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 741efe2c497b..51354e3935d4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -467,11 +467,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (!msr_info->host_initiated &&
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
-			pmc->counter += data - pmc_read_counter(pmc);
+			pmc_set_counter(pmc, data);
 			pmc_update_sample_period(pmc);
 			break;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
-			pmc->counter += data - pmc_read_counter(pmc);
+			pmc_set_counter(pmc, data);
 			pmc_update_sample_period(pmc);
 			break;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
-- 
2.34.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



