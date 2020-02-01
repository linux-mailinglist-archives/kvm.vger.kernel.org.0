Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF4A14FA02
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbgBAS5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:57:09 -0500
Received: from mga05.intel.com ([192.55.52.43]:37509 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbgBASw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075443"
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
Subject: [PATCH 05/61] KVM: x86: Check userapce CPUID array size after validating sub-leaf
Date:   Sat,  1 Feb 2020 10:51:22 -0800
Message-Id: <20200201185218.24473-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that the next sub-leaf of CPUID 0x4 (or 0x8000001d) is valid
before rejecting the entire KVM_GET_SUPPORTED_CPUID due to insufficent
space in the userspace array.

Note, although this is technically a bug, it's not visible to userspace
as KVM_GET_SUPPORTED_CPUID is guaranteed to fail on KVM_CPUID_SIGNATURE,
which is hardcoded to be added after the affected leafs.  The real
motivation for the change is to tightly couple the nent/maxnent and
do_host_cpuid() sequences in preparation for future cleanup.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 11d5f311ef10..e5cf1e0cf84a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -552,12 +552,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 
 		/* read more entries until cache_type is zero */
 		for (i = 1; ; ++i) {
-			if (*nent >= maxnent)
-				goto out;
-
 			cache_type = entry[i - 1].eax & 0x1f;
 			if (!cache_type)
 				break;
+
+			if (*nent >= maxnent)
+				goto out;
 			do_host_cpuid(&entry[i], function, i);
 			++*nent;
 		}
-- 
2.24.1

