Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD4F14FA07
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBAS5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:57:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:57278 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbgBASw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075440"
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
Subject: [PATCH 04/61] KVM: x86: Clean up error handling in kvm_dev_ioctl_get_cpuid()
Date:   Sat,  1 Feb 2020 10:51:21 -0800
Message-Id: <20200201185218.24473-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up the error handling in kvm_dev_ioctl_get_cpuid(), which has
gotten a bit crusty as the function has evolved over the years.

Opportunistically hoist the static @funcs declaration to the top of the
function to make it more obvious that it's a "static const".

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index de52cbb46171..11d5f311ef10 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -889,45 +889,40 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 			    struct kvm_cpuid_entry2 __user *entries,
 			    unsigned int type)
 {
-	struct kvm_cpuid_entry2 *cpuid_entries;
-	int nent = 0, r = -E2BIG, i;
-
 	static const u32 funcs[] = {
 		0, 0x80000000, CENTAUR_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
 	};
 
+	struct kvm_cpuid_entry2 *cpuid_entries;
+	int nent = 0, r, i;
+
 	if (cpuid->nent < 1)
-		goto out;
+		return -E2BIG;
 	if (cpuid->nent > KVM_MAX_CPUID_ENTRIES)
 		cpuid->nent = KVM_MAX_CPUID_ENTRIES;
 
 	if (sanity_check_entries(entries, cpuid->nent, type))
 		return -EINVAL;
 
-	r = -ENOMEM;
 	cpuid_entries = vzalloc(array_size(sizeof(struct kvm_cpuid_entry2),
 					   cpuid->nent));
 	if (!cpuid_entries)
-		goto out;
+		return -ENOMEM;
 
-	r = 0;
 	for (i = 0; i < ARRAY_SIZE(funcs); i++) {
 		r = get_cpuid_func(cpuid_entries, funcs[i], &nent, cpuid->nent,
 				   type);
 		if (r)
 			goto out_free;
 	}
+	cpuid->nent = nent;
 
-	r = -EFAULT;
 	if (copy_to_user(entries, cpuid_entries,
 			 nent * sizeof(struct kvm_cpuid_entry2)))
-		goto out_free;
-	cpuid->nent = nent;
-	r = 0;
+		r = -EFAULT;
 
 out_free:
 	vfree(cpuid_entries);
-out:
 	return r;
 }
 
-- 
2.24.1

