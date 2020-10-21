Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEE8294A35
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437418AbgJUJKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:10:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:58976 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437412AbgJUJKi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 05:10:38 -0400
IronPort-SDR: lBDJxM9vk2HKXBv0s1aDtYHFPN5PFhG0+47CO7ttaIoumBdD4v45CHYcMJbGF9ETFQEUMz9CRc
 5ZdQNegSlo0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="231530459"
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="231530459"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 02:10:37 -0700
IronPort-SDR: H9Px2hJvDPOfU0ALHHBmzY97pXg2x5yLpkaCj6JxMFCTFDqqnh0QMvtAst16OLhg1Z8MuvyuYl
 FB1cXeyElVMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="522682465"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2020 02:10:35 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 5/7] [Trivial] kvm: x86: cpuid_query_maxphyaddr(): Use a simple 'e' instead of misleading 'best', as the variable name
Date:   Wed, 21 Oct 2020 17:10:08 +0800
Message-Id: <1603271410-71343-6-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
References: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Function's logic doesn't change at all.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 556c018..ff2d73c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -227,14 +227,14 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid_entry2 *best;
+	struct kvm_cpuid_entry2 *e;
 
-	best = kvm_find_cpuid_entry(vcpu, 0x80000000, 0);
-	if (!best || best->eax < 0x80000008)
+	e = kvm_find_cpuid_entry(vcpu, 0x80000000, 0);
+	if (!e || e->eax < 0x80000008)
 		goto not_found;
-	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
-	if (best)
-		return best->eax & 0xff;
+	e = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
+	if (e)
+		return e->eax & 0xff;
 not_found:
 	return 36;
 }
-- 
1.8.3.1

