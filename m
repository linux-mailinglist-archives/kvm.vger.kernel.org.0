Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 225C0176916
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgCCACo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:02:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:37738 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgCBX5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384631"
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
Subject: [PATCH v2 03/66] KVM: x86: Simplify handling of Centaur CPUID leafs
Date:   Mon,  2 Mar 2020 15:56:06 -0800
Message-Id: <20200302235709.27467-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor the handling of the Centaur-only CPUID leaf to detect the leaf
via a runtime query instead of adding a one-off callback in the static
array.  When the callback was introduced, there were additional fields
in the array's structs, and more importantly, retpoline wasn't a thing.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f49fdd06f511..de52cbb46171 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -829,15 +829,7 @@ static int do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 func,
 	return __do_cpuid_func(entry, func, nent, maxnent);
 }
 
-struct kvm_cpuid_param {
-	u32 func;
-	bool (*qualifier)(const struct kvm_cpuid_param *param);
-};
-
-static bool is_centaur_cpu(const struct kvm_cpuid_param *param)
-{
-	return boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR;
-}
+#define CENTAUR_CPUID_SIGNATURE 0xC0000000
 
 static int get_cpuid_func(struct kvm_cpuid_entry2 *entries, u32 func,
 			  int *nent, int maxnent, unsigned int type)
@@ -845,6 +837,10 @@ static int get_cpuid_func(struct kvm_cpuid_entry2 *entries, u32 func,
 	u32 limit;
 	int r;
 
+	if (func == CENTAUR_CPUID_SIGNATURE &&
+	    boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
+		return 0;
+
 	r = do_cpuid_func(&entries[*nent], func, nent, maxnent, type);
 	if (r)
 		return r;
@@ -896,11 +892,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	int nent = 0, r = -E2BIG, i;
 
-	static const struct kvm_cpuid_param param[] = {
-		{ .func = 0 },
-		{ .func = 0x80000000 },
-		{ .func = 0xC0000000, .qualifier = is_centaur_cpu },
-		{ .func = KVM_CPUID_SIGNATURE },
+	static const u32 funcs[] = {
+		0, 0x80000000, CENTAUR_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
 	};
 
 	if (cpuid->nent < 1)
@@ -918,14 +911,9 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 		goto out;
 
 	r = 0;
-	for (i = 0; i < ARRAY_SIZE(param); i++) {
-		const struct kvm_cpuid_param *ent = &param[i];
-
-		if (ent->qualifier && !ent->qualifier(ent))
-			continue;
-
-		r = get_cpuid_func(cpuid_entries, ent->func, &nent,
-				   cpuid->nent, type);
+	for (i = 0; i < ARRAY_SIZE(funcs); i++) {
+		r = get_cpuid_func(cpuid_entries, funcs[i], &nent, cpuid->nent,
+				   type);
 		if (r)
 			goto out_free;
 	}
-- 
2.24.1

