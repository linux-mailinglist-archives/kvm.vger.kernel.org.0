Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBE21E53C6
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 04:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgE1CPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 22:15:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:22236 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgE1CPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 22:15:32 -0400
IronPort-SDR: uchrLjJhGqkfY1psT2qsxRaS0/A9bwL5EfHY6aVSJQeeMO3P4wpVDQSbZHGASHQim7dzXuyB7X
 aNIZFWw35ZVQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 19:15:31 -0700
IronPort-SDR: ZsxugPmsaGgauJHajFMQGUnZ6XilY3GjFeF91lsi/lhAwQe6yrP2U+awZ3oR0Yq9oqUgvuwlpf
 MliaLxRu/0YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="376218319"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 27 May 2020 19:15:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergio Perez Gonzalez <sergio.perez.gonzalez@intel.com>,
        Adriana Cervantes Jimenez <adriana.cervantes.jimenez@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: selftests: Ignore KVM 5-level paging support for VM_MODE_PXXV48_4K
Date:   Wed, 27 May 2020 19:15:30 -0700
Message-Id: <20200528021530.28091-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly set the VA width to 48 bits for the x86_64-only PXXV48_4K VM
mode instead of asserting the guest VA width is 48 bits.  The fact that
KVM supports 5-level paging is irrelevant unless the selftests opt-in to
5-level paging by setting CR4.LA57 for the guest.  The overzealous
assert prevents running the selftests on a kernel with 5-level paging
enabled.

Incorporate LA57 into the assert instead of removing the assert entirely
as a sanity check of KVM's CPUID output.

Fixes: 567a9f1e9deb ("KVM: selftests: Introduce VM_MODE_PXXV48_4K")
Reported-by: Sergio Perez Gonzalez <sergio.perez.gonzalez@intel.com>
Cc: Adriana Cervantes Jimenez <adriana.cervantes.jimenez@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c9cede5c7d0de..74776ee228f2d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -195,11 +195,18 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	case VM_MODE_PXXV48_4K:
 #ifdef __x86_64__
 		kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
-		TEST_ASSERT(vm->va_bits == 48, "Linear address width "
-			    "(%d bits) not supported", vm->va_bits);
+		/*
+		 * Ignore KVM support for 5-level paging (vm->va_bits == 57),
+		 * it doesn't take effect unless a CR4.LA57 is set, which it
+		 * isn't for this VM_MODE.
+		 */
+		TEST_ASSERT(vm->va_bits == 48 || vm->va_bits == 57,
+			    "Linear address width (%d bits) not supported",
+			    vm->va_bits);
 		pr_debug("Guest physical address width detected: %d\n",
 			 vm->pa_bits);
 		vm->pgtable_levels = 4;
+		vm->va_bits = 48;
 #else
 		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
 #endif
-- 
2.26.0

