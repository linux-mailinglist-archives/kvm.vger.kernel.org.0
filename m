Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F041768FA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgCCABh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:01:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:17168 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbgCBX50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384765"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 47/66] KVM: x86: Squash CPUID 0x2.0 insanity for modern CPUs
Date:   Mon,  2 Mar 2020 15:56:50 -0800
Message-Id: <20200302235709.27467-48-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework CPUID 0x2.0 to be a normal CPUID leaf if it returns "01" in AL,
i.e. EAX & 0xff, as a step towards removing KVM's stateful CPUID code
altogether.

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
eac"), which shows that the stateful iteration code was completely
broken when it was introduced by commit 0771671749b59 ("KVM: Enhance
guest cpuid management"), i.e. not actually tested.

Annotate all stateful code paths as "unlikely", but defer its removal to
a future patch to simplify reinstating the code if by some miracle there
is someone running KVM on a CPU with a stateful CPUID 0x2.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 617b532e51a1..b5dce17c070f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -413,9 +413,6 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
 
 	switch (function) {
-	case 2:
-		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
-		break;
 	case 4:
 	case 7:
 	case 0xb:
@@ -491,17 +488,31 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
 			entry = do_host_cpuid(array, function, 0);
 			if (!entry)
 				goto out;
+			entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
 		}
 		break;
 	/* functions 4 and 0x8000001d have additional index. */
@@ -911,7 +922,7 @@ static int is_matching_cpuid_entry(struct kvm_cpuid_entry2 *e,
 		return 0;
 	if ((e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) && e->index != index)
 		return 0;
-	if ((e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
+	if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
 	    !(e->flags & KVM_CPUID_FLAG_STATE_READ_NEXT))
 		return 0;
 	return 1;
@@ -928,7 +939,7 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 
 		e = &vcpu->arch.cpuid_entries[i];
 		if (is_matching_cpuid_entry(e, function, index)) {
-			if (e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC)
+			if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC))
 				move_to_next_stateful_cpuid_entry(vcpu, i);
 			best = e;
 			break;
-- 
2.24.1

