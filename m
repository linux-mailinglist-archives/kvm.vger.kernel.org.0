Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638CA14F99A
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgBASwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:11294 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbgBASwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075571"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 47/61] KVM: x86: Squash CPUID 0x2.0 insanity for modern CPUs
Date:   Sat,  1 Feb 2020 10:52:04 -0800
Message-Id: <20200201185218.24473-48-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework CPUID 0x2.0 to be a normal CPUID leaf if it returns "01" in AL,
i.e. EAX & 0xff.

Long ago, Intel documented CPUID 0x2.0 as being a stateful leaf, e.g. a
version of the SDM circa 1995 states:

  The least-significant byte in register EAX (register AL) indicates the
  number of times the CPUID instruction must be executed with an input
  value of 2 to get a complete description of the processors's caches
  and TLBs.  The Pentium Pro family of processors will return a 1.

A 2000 version of the SDM only updated the paragraph to reference
Intel's new processory family:

  The first member of the family of Pentium 4 processors will return a 1.

Fast forward to the present, and Intel's SDM now states:

  The least-significant byte in register EAX (register AL) will always
  return 01H.  Software should ignore this value and not interpret it as
  an information descriptor.

AMD's APM simply states that CPUID 0x2 is reserved.

Given that CPUID itself was introduced in the Pentium, odds are good
that the only Intel CPU family that *maybe* implemented a stateful CPUID
was the P5.  Which obviously did not support VMX, or KVM.

In other words, KVM's emulation of a stateful CPUID 0x2.0 has likely
been dead code from the day it was introduced.  This is backed up by
commit 0fdf8e59faa5c ("KVM: Fix cpuid iteration on multiple leaves per
eac"), whichs show that the stateful iteration code was completely
broken when it was introduced by commit 0771671749b59 ("KVM: Enhance
guest cpuid management"), i.e. not actually tested.

Although it's _extremely_ tempting to yank KVM's stateful code, leave it
in for now but annotate all its code paths as "unlikely".  The code is
relatively contained, and if by some miracle there is someone running KVM
on a CPU with a stateful CPUID 0x2, more power to 'em.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 47f61f4497fb..ab2a34337588 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -405,9 +405,6 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
 
 	switch (function) {
-	case 2:
-		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
-		break;
 	case 4:
 	case 7:
 	case 0xb:
@@ -483,17 +480,31 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * it since we emulate x2apic in software */
 		cpuid_entry_set(entry, X86_FEATURE_X2APIC);
 		break;
-	/* function 2 entries are STATEFUL. That is, repeated cpuid commands
-	 * may return different values. This forces us to get_cpu() before
-	 * issuing the first command, and also to emulate this annoying behavior
-	 * in kvm_emulate_cpuid() using KVM_CPUID_FLAG_STATE_READ_NEXT */
 	case 2:
+		/*
+		 * On ancient CPUs, function 2 entries are STATEFUL.  That is,
+		 * CPUID(function=2, index=0) may return different results each
+		 * time, with the least-significant byte in EAX enumerating the
+		 * number of times software should do CPUID(2, 0).
+		 *
+		 * Modern CPUs (quite likely every CPU KVM has *ever* run on)
+		 * are less idiotic.  Intel's SDM states that EAX & 0xff "will
+		 * always return 01H. Software should ignore this value and not
+		 * interpret it as an informational descriptor", while AMD's
+		 * APM states that CPUID(2) is reserved.
+		 */
+		max_idx = entry->eax & 0xff;
+		if (likely(max_idx <= 1))
+			break;
+
+		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
 		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
 
-		for (i = 1, max_idx = entry->eax & 0xff; i < max_idx; ++i) {
+		for (i = 1; i < max_idx; ++i) {
 			entry = do_host_cpuid(array, 2, 0);
 			if (!entry)
 				goto out;
+			entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
 		}
 		break;
 	/* functions 4 and 0x8000001d have additional index. */
@@ -903,7 +914,7 @@ static int is_matching_cpuid_entry(struct kvm_cpuid_entry2 *e,
 		return 0;
 	if ((e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) && e->index != index)
 		return 0;
-	if ((e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
+	if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
 	    !(e->flags & KVM_CPUID_FLAG_STATE_READ_NEXT))
 		return 0;
 	return 1;
@@ -920,7 +931,7 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 
 		e = &vcpu->arch.cpuid_entries[i];
 		if (is_matching_cpuid_entry(e, function, index)) {
-			if (e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC)
+			if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC))
 				move_to_next_stateful_cpuid_entry(vcpu, i);
 			best = e;
 			break;
-- 
2.24.1

