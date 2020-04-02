Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B08D19C690
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 17:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389607AbgDBP4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 11:56:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:50591 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389325AbgDBP4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 11:56:50 -0400
IronPort-SDR: /18s+oQM0PYLIM35RS3myGfznwQo5OP2Qg5kfBz4G418iPkaf5iZBNug2KIVd2cs/7iqOgckok
 WEUHpd+erOlw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2020 08:56:49 -0700
IronPort-SDR: o6RqdacYPXg4J7MtrbwqCo51+VsSZ0pQa2CW6jvy+X9E2wRUNGdWZtgEiSqxdhj2igTeTFhPld
 1hSTtnRVYaEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,336,1580803200"; 
   d="scan'208";a="396413082"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 02 Apr 2020 08:56:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: Emulate split-lock access as a write in emulator
Date:   Thu,  2 Apr 2020 08:55:52 -0700
Message-Id: <20200402155554.27705-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200402155554.27705-1-sean.j.christopherson@intel.com>
References: <20200402124205.334622628@linutronix.de>
 <20200402155554.27705-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Emulate split-lock accesses as writes if split lock detection is on to
avoid #AC during emulation, which will result in a panic().  This should
never occur for a well behaved guest, but a malicious guest can
manipulate the TLB to trigger emulation of a locked instruction[1].

More discussion can be found [2][3].

[1] https://lkml.kernel.org/r/8c5b11c9-58df-38e7-a514-dc12d687b198@redhat.com
[2] https://lkml.kernel.org/r/20200131200134.GD18946@linux.intel.com
[3] https://lkml.kernel.org/r/20200227001117.GX9940@linux.intel.com

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf8564d73fc3..37ce0fc9a62d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5875,6 +5875,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 {
 	struct kvm_host_map map;
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	u64 page_line_mask;
 	gpa_t gpa;
 	char *kaddr;
 	bool exchanged;
@@ -5889,7 +5890,16 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	    (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 		goto emul_write;
 
-	if (((gpa + bytes - 1) & PAGE_MASK) != (gpa & PAGE_MASK))
+	/*
+	 * Emulate the atomic as a straight write to avoid #AC if SLD is
+	 * enabled in the host and the access splits a cache line.
+	 */
+	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
+		page_line_mask = ~(cache_line_size() - 1);
+	else
+		page_line_mask = PAGE_MASK;
+
+	if (((gpa + bytes - 1) & page_line_mask) != (gpa & page_line_mask))
 		goto emul_write;
 
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
-- 
2.24.1

