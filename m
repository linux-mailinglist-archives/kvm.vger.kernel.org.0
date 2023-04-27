Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146CA6F03C9
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 11:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243455AbjD0J4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 05:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243437AbjD0J42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 05:56:28 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C1949C1;
        Thu, 27 Apr 2023 02:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682589385; x=1714125385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=igRBkVKxy6Yba7VsMB5zWjPH3qQSaecfpwHBcFsFXC8=;
  b=Y9tcxbaoLu8sJCTud165qwFfm5BXFa2PNx6l+ExGpCvHsul6bcqFWMMV
   +kOZ26CLnLQVQhzIkElB8t5bcBwhfKfYHijEFWtpiGrokn/gFe7GQlIB9
   wu8IccBQnjNHyUFlf0COTDlt8Kka3UVcQOpdwYkQJ0MYscHXoDhsh++GL
   Y=;
X-IronPort-AV: E=Sophos;i="5.99,230,1677542400"; 
   d="scan'208";a="325574424"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 09:56:13 +0000
Received: from EX19MTAUEA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id 7172A60A4E;
        Thu, 27 Apr 2023 09:56:11 +0000 (UTC)
Received: from EX19D008UEA003.ant.amazon.com (10.252.134.116) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Apr 2023 09:56:11 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEA003.ant.amazon.com (10.252.134.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 27 Apr 2023 09:56:10 +0000
Received: from dev-dsk-abusse-1c-9fba1bbe.eu-west-1.amazon.com (10.13.253.110)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26 via Frontend Transport; Thu, 27 Apr 2023 09:56:09 +0000
From:   Anselm Busse <abusse@amazon.com>
CC:     <dwmw@amazon.co.uk>, <hborghor@amazon.de>, <sironi@amazon.de>,
        "Anselm Busse" <abusse@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] KVM: vmx/pmu: Add support for selected fixed vPMU enablement for PMU v5
Date:   Thu, 27 Apr 2023 09:53:33 +0000
Message-ID: <20230427095333.35038-3-abusse@amazon.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230427095333.35038-1-abusse@amazon.com>
References: <20230427095333.35038-1-abusse@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commits adds virtualization support to enable slected fixed
function PMCs for Intel PMU v5 based on CPUID.0AH.ECX.

Starting with v5, the Intel PMU allows to indicate the available fixed
function PMCs not only through CPUID.0AH.EDX[4:0] but also through a
bit mask in CPUID.0AH.ECX. According to the SDM the OS can consider a
fix function PMC i supported for:

CPUID.0AH.ECX[i] || (CPUID.0AH.EDX[4:0] > i)

This behavior is already supported by the Intel PMU driver. However, KVM
support is missing. Therefore, this commit extends the KVM
implementation by also taking the values in CPUID.0AH.ECX into account
when setting the bitmap of enabled fixed function PMCs.

Signed-off-by: Anselm Busse <abusse@amazon.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 55ff06a9df47..d1fd3472bfd4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -562,6 +562,13 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
+
+		if (pmu->version >= 5)
+			bitmap_or(pmu->mask_arch_fixed_counters,
+				  pmu->mask_arch_fixed_counters,
+				  (unsigned long *)&entry->ecx,
+				  INTEL_PMC_MAX_FIXED);
+
 		setup_fixed_pmc_eventsel(pmu);
 	}
 
-- 
2.39.2




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



