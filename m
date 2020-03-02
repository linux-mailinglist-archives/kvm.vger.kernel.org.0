Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93627176917
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgCCACo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:02:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:37735 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgCBX5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384634"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:21 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 04/66] KVM: x86: Clean up error handling in kvm_dev_ioctl_get_cpuid()
Date:   Mon,  2 Mar 2020 15:56:07 -0800
Message-Id: <20200302235709.27467-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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

