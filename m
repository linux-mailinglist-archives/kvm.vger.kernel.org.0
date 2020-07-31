Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353EE234C83
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 22:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgGaUvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 16:51:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:25207 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbgGaUvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 16:51:18 -0400
IronPort-SDR: 3/83gqLT5a1hxU6ShYEj8zvQGTA2tEw1lGNdV9YWEXAzgLOV4PJK3QrlJPYxwW2zgW2jEjKcxD
 PCsW9/qMWHWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131435570"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="131435570"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 13:51:18 -0700
IronPort-SDR: c5kp/zR5mS/FK+QSpEKU2MlhBeSqEi5dyMntHl6dWMCco2meH524leym/UdmY2jbPnAhBc3BnH
 mbgsmZZcKo9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="329340987"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Jul 2020 13:51:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH] KVM: SVM: Disallow SEV if NPT is disabled
Date:   Fri, 31 Jul 2020 13:51:16 -0700
Message-Id: <20200731205116.14891-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Forcefully turn off SEV if NPT is disabled, e.g. via module param.  SEV
requires NPT as the C-bit only exists if NPT is active.

Fixes: e9df09428996f ("KVM: SVM: Add sev module_param")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

RFC as it's entirely possible that I am completely misunderstanding how
SEV works.  Compile tested only.

 arch/x86/kvm/svm/svm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 783330d0e7b88..e30629593458b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -860,8 +860,14 @@ static __init int svm_hardware_setup(void)
 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
 	}
 
+	if (!boot_cpu_has(X86_FEATURE_NPT))
+		npt_enabled = false;
+
+	if (npt_enabled && !npt)
+		npt_enabled = false;
+
 	if (sev) {
-		if (boot_cpu_has(X86_FEATURE_SEV) &&
+		if (boot_cpu_has(X86_FEATURE_SEV) && npt_enabled &&
 		    IS_ENABLED(CONFIG_KVM_AMD_SEV)) {
 			r = sev_hardware_setup();
 			if (r)
@@ -879,12 +885,6 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	if (!boot_cpu_has(X86_FEATURE_NPT))
-		npt_enabled = false;
-
-	if (npt_enabled && !npt)
-		npt_enabled = false;
-
 	kvm_configure_mmu(npt_enabled, PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
-- 
2.28.0

