Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0545714FA01
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgBAS5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:57:08 -0500
Received: from mga05.intel.com ([192.55.52.43]:37509 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbgBASw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075458"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/61] KVM: x86: Clean up CPUID 0x7 sub-leaf loop
Date:   Sat,  1 Feb 2020 10:51:27 -0800
Message-Id: <20200201185218.24473-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the sub-leaf loop for CPUID 0x7 to move the main leaf out of
said loop.  The emitted code savings is basically a mirage, as the
handling of the main leaf can easily be split to its own helper to avoid
code bloat.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6e1685a16cca..b626893a11d5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -573,16 +573,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 7: {
 		int i;
 
-		for (i = 0; ; ) {
+		do_cpuid_7_mask(entry, 0);
+
+		for (i = 1; i <= entry->eax; i++) {
+			if (*nent >= maxnent)
+				goto out;
+
+			do_host_cpuid(&entry[i], function, i);
+			++*nent;
+
 			do_cpuid_7_mask(&entry[i], i);
-			if (i == entry->eax)
-				break;
-			if (*nent >= maxnent)
-				goto out;
-
-			++i;
-			do_host_cpuid(&entry[i], function, i);
-			++*nent;
 		}
 		break;
 	}
-- 
2.24.1

