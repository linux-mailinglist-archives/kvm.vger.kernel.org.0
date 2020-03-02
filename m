Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDBA1768FE
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgCBX5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:57:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:17168 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727101AbgCBX5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384768"
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
Subject: [PATCH v2 48/66] KVM: x86: Remove stateful CPUID handling
Date:   Mon,  2 Mar 2020 15:56:51 -0800
Message-Id: <20200302235709.27467-49-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the code for handling stateful CPUID 0x2 and mark the associated
flags as deprecated.  WARN if host CPUID 0x2.0.AL > 1, i.e. if by some
miracle a host with stateful CPUID 0x2 is encountered.

No known CPU exists that supports hardware accelerated virtualization
_and_ a stateful CPUID 0x2.  Barring an extremely contrived nested
virtualization scenario, stateful CPUID support is dead code.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 Documentation/virt/kvm/api.rst | 22 ++--------
 arch/x86/kvm/cpuid.c           | 73 ++++++----------------------------
 2 files changed, 17 insertions(+), 78 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index ebd383fba939..c38cd9f88237 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1574,8 +1574,8 @@ This ioctl would set vcpu's xcr to the value userspace specified.
   };
 
   #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
-  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
-  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
+  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1) /* deprecated */
+  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2) /* deprecated */
 
   struct kvm_cpuid_entry2 {
 	__u32 function;
@@ -1626,13 +1626,6 @@ emulate them efficiently. The fields in each entry are defined as follows:
 
         KVM_CPUID_FLAG_SIGNIFCANT_INDEX:
            if the index field is valid
-        KVM_CPUID_FLAG_STATEFUL_FUNC:
-           if cpuid for this function returns different values for successive
-           invocations; there will be several entries with the same function,
-           all with this flag set
-        KVM_CPUID_FLAG_STATE_READ_NEXT:
-           for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
-           the first entry to be read by a cpu
 
    eax, ebx, ecx, edx:
          the values returned by the cpuid instruction for
@@ -3347,8 +3340,8 @@ The member 'flags' is used for passing flags from userspace.
 ::
 
   #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX		BIT(0)
-  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1)
-  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2)
+  #define KVM_CPUID_FLAG_STATEFUL_FUNC		BIT(1) /* deprecated */
+  #define KVM_CPUID_FLAG_STATE_READ_NEXT		BIT(2) /* deprecated */
 
   struct kvm_cpuid_entry2 {
 	__u32 function;
@@ -3394,13 +3387,6 @@ The fields in each entry are defined as follows:
 
         KVM_CPUID_FLAG_SIGNIFCANT_INDEX:
            if the index field is valid
-        KVM_CPUID_FLAG_STATEFUL_FUNC:
-           if cpuid for this function returns different values for successive
-           invocations; there will be several entries with the same function,
-           all with this flag set
-        KVM_CPUID_FLAG_STATE_READ_NEXT:
-           for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
-           the first entry to be read by a cpu
 
    eax, ebx, ecx, edx:
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b5dce17c070f..49527dbcc90c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -495,25 +495,16 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * time, with the least-significant byte in EAX enumerating the
 		 * number of times software should do CPUID(2, 0).
 		 *
-		 * Modern CPUs (quite likely every CPU KVM has *ever* run on)
-		 * are less idiotic.  Intel's SDM states that EAX & 0xff "will
-		 * always return 01H. Software should ignore this value and not
+		 * Modern CPUs, i.e. every CPU KVM has *ever* run on are less
+		 * idiotic.  Intel's SDM states that EAX & 0xff "will always
+		 * return 01H. Software should ignore this value and not
 		 * interpret it as an informational descriptor", while AMD's
 		 * APM states that CPUID(2) is reserved.
+		 *
+		 * WARN if a frankenstein CPU that supports virtualization and
+		 * a stateful CPUID.0x2 is encountered.
 		 */
-		max_idx = entry->eax & 0xff;
-		if (likely(max_idx <= 1))
-			break;
-
-		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
-		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
-
-		for (i = 1; i < max_idx; ++i) {
-			entry = do_host_cpuid(array, function, 0);
-			if (!entry)
-				goto out;
-			entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
-		}
+		WARN_ON_ONCE((entry->eax & 0xff) > 1);
 		break;
 	/* functions 4 and 0x8000001d have additional index. */
 	case 4:
@@ -894,58 +885,20 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	return r;
 }
 
-static int move_to_next_stateful_cpuid_entry(struct kvm_vcpu *vcpu, int i)
-{
-	struct kvm_cpuid_entry2 *e = &vcpu->arch.cpuid_entries[i];
-	struct kvm_cpuid_entry2 *ej;
-	int j = i;
-	int nent = vcpu->arch.cpuid_nent;
-
-	e->flags &= ~KVM_CPUID_FLAG_STATE_READ_NEXT;
-	/* when no next entry is found, the current entry[i] is reselected */
-	do {
-		j = (j + 1) % nent;
-		ej = &vcpu->arch.cpuid_entries[j];
-	} while (ej->function != e->function);
-
-	ej->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
-
-	return j;
-}
-
-/* find an entry with matching function, matching index (if needed), and that
- * should be read next (if it's stateful) */
-static int is_matching_cpuid_entry(struct kvm_cpuid_entry2 *e,
-	u32 function, u32 index)
-{
-	if (e->function != function)
-		return 0;
-	if ((e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) && e->index != index)
-		return 0;
-	if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
-	    !(e->flags & KVM_CPUID_FLAG_STATE_READ_NEXT))
-		return 0;
-	return 1;
-}
-
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index)
 {
+	struct kvm_cpuid_entry2 *e;
 	int i;
-	struct kvm_cpuid_entry2 *best = NULL;
 
 	for (i = 0; i < vcpu->arch.cpuid_nent; ++i) {
-		struct kvm_cpuid_entry2 *e;
-
 		e = &vcpu->arch.cpuid_entries[i];
-		if (is_matching_cpuid_entry(e, function, index)) {
-			if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC))
-				move_to_next_stateful_cpuid_entry(vcpu, i);
-			best = e;
-			break;
-		}
+
+		if (e->function == function && (e->index == index ||
+		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
+			return e;
 	}
-	return best;
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
-- 
2.24.1

