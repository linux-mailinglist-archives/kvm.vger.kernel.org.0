Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E7C14F9DE
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgBASw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:37509 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgBASw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075434"
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
Subject: [PATCH 02/61] KVM: x86: Refactor loop around do_cpuid_func() to separate helper
Date:   Sat,  1 Feb 2020 10:51:19 -0800
Message-Id: <20200201185218.24473-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the guts of kvm_dev_ioctl_get_cpuid()'s CPUID func loop to a
separate helper to improve code readability and pave the way for future
cleanup.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 45 ++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 47ce04762c20..f49fdd06f511 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -839,6 +839,29 @@ static bool is_centaur_cpu(const struct kvm_cpuid_param *param)
 	return boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR;
 }
 
+static int get_cpuid_func(struct kvm_cpuid_entry2 *entries, u32 func,
+			  int *nent, int maxnent, unsigned int type)
+{
+	u32 limit;
+	int r;
+
+	r = do_cpuid_func(&entries[*nent], func, nent, maxnent, type);
+	if (r)
+		return r;
+
+	limit = entries[*nent - 1].eax;
+	for (func = func + 1; func <= limit; ++func) {
+		if (*nent >= maxnent)
+			return -E2BIG;
+
+		r = do_cpuid_func(&entries[*nent], func, nent, maxnent, type);
+		if (r)
+			break;
+	}
+
+	return r;
+}
+
 static bool sanity_check_entries(struct kvm_cpuid_entry2 __user *entries,
 				 __u32 num_entries, unsigned int ioctl_type)
 {
@@ -871,8 +894,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 			    unsigned int type)
 {
 	struct kvm_cpuid_entry2 *cpuid_entries;
-	int limit, nent = 0, r = -E2BIG, i;
-	u32 func;
+	int nent = 0, r = -E2BIG, i;
+
 	static const struct kvm_cpuid_param param[] = {
 		{ .func = 0 },
 		{ .func = 0x80000000 },
@@ -901,22 +924,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 		if (ent->qualifier && !ent->qualifier(ent))
 			continue;
 
-		r = do_cpuid_func(&cpuid_entries[nent], ent->func,
-				  &nent, cpuid->nent, type);
-
-		if (r)
-			goto out_free;
-
-		limit = cpuid_entries[nent - 1].eax;
-		for (func = ent->func + 1; func <= limit && r == 0; ++func) {
-			if (nent >= cpuid->nent) {
-				r = -E2BIG;
-				goto out_free;
-			}
-			r = do_cpuid_func(&cpuid_entries[nent], func,
-				          &nent, cpuid->nent, type);
-		}
-
+		r = get_cpuid_func(cpuid_entries, ent->func, &nent,
+				   cpuid->nent, type);
 		if (r)
 			goto out_free;
 	}
-- 
2.24.1

