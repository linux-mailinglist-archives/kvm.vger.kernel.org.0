Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC6F42F687
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbhJOPHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 11:07:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236064AbhJOPHk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 11:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634310334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UfQ0LrN6xpoaV3mY9Eud18l2Ja+hZhU4wb39sPJMTdc=;
        b=aZJOM0Ymu0UkEbnm38b2HPLVcUgzFYzD25/bKERyoc90izLu2MqiUB5FIdDjEMh1aXeUG6
        soWRKG2e94+CH0i7ZF9ykwJAxOmx2yj8D59lfDzQ7ca1Wc82/gMXrew73s9cSj0moXkFr8
        5opGUCjXv6x4iv3Jy/acxtu7QwSZBNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-EmXBQodWPnG2JXnGC71XrQ-1; Fri, 15 Oct 2021 11:05:30 -0400
X-MC-Unique: EmXBQodWPnG2JXnGC71XrQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E2561006AA2;
        Fri, 15 Oct 2021 15:05:28 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE15F2C175;
        Fri, 15 Oct 2021 15:05:25 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC] KVM: SVM: reduce guest MAXPHYADDR by one in case C-bit is a physical bit
Date:   Fri, 15 Oct 2021 17:05:24 +0200
Message-Id: <20211015150524.2030966-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several selftests (memslot_modification_stress_test, kvm_page_table_test,
dirty_log_perf_test,.. ) which rely on vm_get_max_gfn() started to fail
since commit ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of
vm_get_max_gfn()") on AMD EPYC 7401P:

 ./tools/testing/selftests/kvm/demand_paging_test
 Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
 guest physical test memory offset: 0xffffbffff000
 Finished creating vCPUs and starting uffd threads
 Started all vCPUs
 ==== Test Assertion Failure ====
   demand_paging_test.c:63: false
   pid=47131 tid=47134 errno=0 - Success
      1	0x000000000040281b: vcpu_worker at demand_paging_test.c:63
      2	0x00007fb36716e431: ?? ??:0
      3	0x00007fb36709c912: ?? ??:0
   Invalid guest sync status: exit_reason=SHUTDOWN

The commit, however, seems to be correct, it just revealed an already
present issue. AMD CPUs which support SEV may have a reduced physical
address space, e.g. on AMD EPYC 7401P I see:

 Address sizes:  43 bits physical, 48 bits virtual

The guest physical address space, however, is not reduced as stated in
commit e39f00f60ebd ("KVM: x86: Use kernel's x86_phys_bits to handle
reduced MAXPHYADDR"). This seems to be almost correct, however, APM has one
more clause (15.34.6):

  Note that because guest physical addresses are always translated through
  the nested page tables, the size of the guest physical address space is
  not impacted by any physical address space reduction indicated in CPUID
  8000_001F[EBX]. If the C-bit is a physical address bit however, the guest
  physical address space is effectively reduced by 1 bit.

Implement the reduction.

Fixes: e39f00f60ebd (KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR)
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
- RFC: I may have misdiagnosed the problem as I didn't dig to where exactly
 the guest crashes.
---
 arch/x86/kvm/cpuid.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 751aa85a3001..04ae280a0b66 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -923,13 +923,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 *
 		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
 		 * provided, use the raw bare metal MAXPHYADDR as reductions to
-		 * the HPAs do not affect GPAs.
+		 * the HPAs do not affect GPAs. The value, however, has to be
+		 * reduced by 1 in case C-bit is a physical bit (APM section
+		 * 15.34.6).
 		 */
-		if (!tdp_enabled)
+		if (!tdp_enabled) {
 			g_phys_as = boot_cpu_data.x86_phys_bits;
-		else if (!g_phys_as)
+		} else if (!g_phys_as) {
 			g_phys_as = phys_as;
 
+			if (kvm_cpu_cap_has(X86_FEATURE_SEV) &&
+			    (cpuid_ebx(0x8000001f) & 0x3f) < g_phys_as)
+				g_phys_as -= 1;
+		}
+
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
-- 
2.31.1

